using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;

namespace Assets.Scripts.InputSystem
{
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField] private float speed = 2.0f;
        [SerializeField] Camera mainCam;
        [SerializeField] GameObject weapon;

        private CharacterController _characterController;
        private PlayerInfo P_info;
        private Vector2 _playerInput;
        private Vector2 MousePos;
        private bool mouseLDown;
        
        private void Awake()
        {
            _characterController = GetComponent<CharacterController>();
            mouseLDown = false;
        }

        void Update()
        {
            var forward = new Vector3(_playerInput.x, 0, _playerInput.y);
            _characterController.SimpleMove(forward * speed);
            
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
                transform.rotation = Quaternion.Lerp(from,to, Time.deltaTime * speed);
            }

        }

        public void OnMove(InputAction.CallbackContext callback)
        {
            _playerInput = callback.ReadValue<Vector2>();
        }

        public void OnAttack(InputAction.CallbackContext callback)
        {
            
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