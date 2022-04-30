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
        private bool isSwap = false;
        private bool isReload =false;
        
        private bool isATKReady;
        private bool inter_Active = false;
        
        private int weaponSlot =0;
        private float speed = 5.0f;
        private float rotationSpeed = 15.0f;
        private float ATKDelay;
        private Animator anim;

        private GameObject nearObj;
        private float posY;

        private PlayerInfo _playerInfo;
        
        private void Awake()
        {
            moveVec = Vector3.zero;
            anim = GetComponentInChildren<Animator>();
            _characterController = GetComponent<CharacterController>();
            mouseLDown = false;
            _playerInfo = GetComponent<PlayerInfo>();
        }

        void Update()
        {
            
            if (keyInput)
            {
                moveVec = new Vector3(_playerInput.x, 0, _playerInput.y);
            }
            forward = moveVec;
            if(!isDodge && keyInput)
                _characterController.Move(forward * speed * Time.deltaTime);
            else if(isDodge)
                _characterController.Move(dodgeVec * speed * Time.deltaTime);
            if (mouseLDown)
            {
                Ray ray = mainCam.ScreenPointToRay(MousePos);
                RaycastHit hit;
                if(Physics.Raycast(ray, out hit, 15))
                {
                    Vector3 next = hit.point - transform.position;
                    var from = transform.rotation;
                    var to =  Quaternion.LookRotation(new Vector3(next.x, 0, next.z));
                    transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * rotationSpeed);
                }
            }
            else
            {
                var from = transform.rotation;
                var to = Quaternion.LookRotation(forward);
                if(!isDodge && keyInput)
                    transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * rotationSpeed);
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
            
            if (equipweapons.type == WeapneType.Missile && equipweapons.curAmmo == 0)
                return;

            if (isFireReady && !isDodge && !isSwap && !isReload)
            {
                equipweapons.Use();
                
                if(equipweapons.type == WeapneType.Melee)
                    anim.SetTrigger("doSwing");
                else if(equipweapons.type == WeapneType.Missile)
                    anim.SetTrigger("doShot");
                
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
                if (!isDodge && !isReload)
                {
                    if (equipweapons != null)
                        equipweapons.gameObject.SetActive(false);
                    equipweapons = weapons[idx].GetComponent<Weapon>();
                    equipweapons.gameObject.SetActive(true);
                    
                    anim.SetTrigger("doSwap");
                    isSwap = true;
                    Invoke("SwapOut",0.4f);
                }
            }
        }
        
        void SwapOut()
        {
            isSwap = false;
        }
        
        public void OnReload(InputAction.CallbackContext callback)
        {
            if (equipweapons == null)
                return;
        
            if(equipweapons.type == WeapneType.Melee)
                return;

            if (_playerInfo.curAmmo == 0)
                return;

            if  (!isSwap && isFireReady && !isDodge)
            {
                anim.SetTrigger("doReload");
                isReload = true;

                Invoke("ReloadOut", 0.5f);
            }
        }

        void ReloadOut()
        {
            int reAmmo = _playerInfo.curAmmo < equipweapons.maxAmmo ? _playerInfo.curAmmo : equipweapons.maxAmmo;
            equipweapons.curAmmo = reAmmo;
            _playerInfo.curAmmo -= reAmmo;
            isReload = false;
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
        public void OnInteraction(InputAction.CallbackContext callback)
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
                else if (nearObj.CompareTag("Chest"))
                {
                    Chest chest = nearObj.GetComponent<Chest>();
                    chest.SetActive();
                }
                else if (nearObj.CompareTag("Items"))
                {
                    Item item = nearObj.GetComponent<Item>();
                    PlayerInfo player = GetComponent<PlayerInfo>();
                    switch (item.type)
                    {
                        case Item.Type.Coin:
                            player.gold += item.value;
                            if (player.gold > player.maxGold)
                                player.gold = player.maxGold;
                            break;
                        case Item.Type.Ammo:
                            player.curAmmo += item.value;
                            if (player.curAmmo > player.maxAmmo)
                                player.curAmmo = player.maxAmmo;
                            break;
                    }
                    Destroy(nearObj.gameObject);
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
            else if (other.CompareTag("Chest"))
            {
                nearObj = other.gameObject;
                inter_Active = true;
            }
            else if (other.CompareTag("Items"))
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