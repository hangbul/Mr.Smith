using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMovement : MonoBehaviour
{
    private CharacterController _characterController;

    private Vector2 _playerInput;
    
    private void Awake()
    {
        _characterController = GetComponent<CharacterController>();
    }
    
    void Update()
    {
        var forward = new Vector3(_playerInput.x, 0, _playerInput.y);
        _characterController.SimpleMove(forward);
        transform.rotation = Quaternion.LookRotation(forward);
    }
    
    void OnMove(InputValue inputVal)
    {
        _playerInput = inputVal.Get<Vector2>();
    }
}
