using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine.SceneManagement;

namespace Assets.Scripts.InputSystem
{
    public class PlayerMovement : MonoBehaviour
    {
        
        [SerializeField] Camera mainCam;
        [SerializeField] GameObject weapon;

        public GameObject[] weapons;
        public Weapon equipweapons;
        
        
        public bool[] inx_weapons;
        int idx = -1;

        private float fireDelay;
        private bool isFireReady;
        private bool keyInput;
        private CharacterController _characterController;
        private PlayerInfo P_info;
        private Vector2 _playerInput;
        private Vector2 MousePos;
        
        private Vector3 moveVec;
        private Vector3 dodgeVec;
        private Vector3 forward;

        private bool mouseLDown;
        private bool isDodge = false;
        private bool isATKReady;
        private bool inter_Active = false;
        
        private int weaponSlot =0;
        private float speed = 5.0f;
        private float ATKDelay;
        private Animator anim;

        private GameObject nearObj;
        
        private void Awake()
        {
            moveVec = Vector3.zero;
            anim = GetComponentInChildren<Animator>();
            _characterController = GetComponent<CharacterController>();
            mouseLDown = false;
        }

        void Update()
        {
            if (keyInput)
            {
                moveVec = new Vector3(_playerInput.x, 0, _playerInput.y);
            }
            forward = moveVec;
            if(!isDodge && keyInput)
                _characterController.Move(forward * speed *Time.deltaTime);
            else if(isDodge)
                _characterController.SimpleMove(dodgeVec * speed);
            if (mouseLDown)
            {
                Ray ray = mainCam.ScreenPointToRay(MousePos);
                RaycastHit hit;
                if(Physics.Raycast(ray, out hit, 15))
                {
                    Vector3 next = hit.point - transform.position;
                    var from = transform.rotation;
                    var to =  Quaternion.LookRotation(new Vector3(next.x, 0, next.z));
                    transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * speed);
                }
            }
            else
            {
                var from = transform.rotation;
                var to = Quaternion.LookRotation(forward);
                if(!isDodge && keyInput)
                    transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * speed);
                else if(isDodge)
                {
                    transform.rotation = Quaternion.LookRotation(dodgeVec);
                }
            }
        
        }

        public void OnMove(InputAction.CallbackContext callback)
        {
            _playerInput = callback.ReadValue<Vector2>();
            anim.SetBool("IsRun", _playerInput != Vector2.zero);
            if (callback.ReadValue<Vector2>() != Vector2.zero)
            {
                keyInput = true;
            }
            else
            {
                keyInput = false;
            }
        }

        public void OnAttack(InputAction.CallbackContext callback)
        {
            if (equipweapons == null)
                return;
            fireDelay += Time.deltaTime;
            isFireReady = equipweapons.rate < fireDelay;

            if (isFireReady && !isDodge)
            {
                equipweapons.Use();
                anim.SetTrigger("doSwing");
                fireDelay = 0;
            }

        }

        public void Swap(InputAction.CallbackContext callback)
        {
            idx += 1;
            if (idx > inx_weapons.Length)
                idx = -1;
            if (inx_weapons[idx])
            {
                if (!isDodge)
                {
                    if (equipweapons != null)
                        equipweapons.gameObject.SetActive(false);
                    equipweapons = weapons[idx].GetComponent<Weapon>();
                    equipweapons.gameObject.SetActive(true);
                }
            }
        }
        public void OnDodge(InputAction.CallbackContext callback)
        {
            speed = 10.0f;
            anim.SetTrigger("doDodge");
            isDodge = true;
            dodgeVec = moveVec;
            Invoke("DodgeOut", 0.5f);
        }
        public void DodgeOut()
        {
            speed = 5.0f;
            isDodge = false;
        }
        public void GetMousePosition(InputAction.CallbackContext callback)
        {
            MousePos = callback.ReadValue<Vector2>();
        }

        public void OnAim(InputAction.CallbackContext callback)
        {
            switch (callback.phase)
            {
                case InputActionPhase.Started:
                    mouseLDown = true;
                    break;
                case InputActionPhase.Canceled:
                    mouseLDown = false;
                    break;
                
            }

        }
        public void Interaction(InputAction.CallbackContext callback)
        {
            if (nearObj != null && inter_Active && !isDodge)
            {
                if (nearObj.CompareTag("Weapon"))
                {
                    Weapon weapon = nearObj.GetComponent<Weapon>();
                    int idx = weapon.idx;
                    inx_weapons[idx] = true;
                    
                    Destroy(nearObj);
                }
            }

        }
        void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Goal"))
            {
                SceneManager.LoadScene("TownScene");

            }
        }
        void OnTriggerStay (Collider other)
        {
            if (other.CompareTag("Weapon"))
            {
                nearObj = other.gameObject;
                inter_Active = true;
            }

        }
        void OnTriggerExit(Collider other)
        {
            nearObj = null;
        }
    }
}