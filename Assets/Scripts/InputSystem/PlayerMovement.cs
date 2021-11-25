using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;

namespace Assets.Scripts.InputSystem
{
    public class PlayerMovement : MonoBehaviour
    {
        
        [SerializeField] Camera mainCam;
        [SerializeField] GameObject weapon;

        private CharacterController _characterController;
        private PlayerInfo P_info;
        private Vector2 _playerInput;
        private Vector2 MousePos;
        
        private Vector3 moveVec;
        private Vector3 dodgeVec;

        private bool mouseLDown;
        private bool isDodge = false;
        private bool isATKReady;
        
        private float speed = 5.0f;
        private float ATKDelay;
        private Animator anim;
        
        private void Awake()
        {
            anim = GetComponentInChildren<Animator>();
            _characterController = GetComponent<CharacterController>();
            mouseLDown = false;
        }

        void Update()
        {
            moveVec = new Vector3(_playerInput.x, 0, _playerInput.y);
            var forward = moveVec;
            if(!isDodge)
                _characterController.SimpleMove(forward * speed);
            else
            {
                _characterController.SimpleMove(dodgeVec * speed);

            }        
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
                if(!isDodge)
                    transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * speed);
                else
                {
                    transform.rotation = Quaternion.LookRotation(dodgeVec);
                }
            }

        }

        public void OnMove(InputAction.CallbackContext callback)
        {
            _playerInput = callback.ReadValue<Vector2>();
            anim.SetBool("IsRun", _playerInput != Vector2.zero);
        }

        public void OnAttack(InputAction.CallbackContext callback)
        {
            
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
    }
}