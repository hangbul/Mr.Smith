using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Follow : MonoBehaviour
{
    public Transform target;
    public float dist = 10.0f;
    public float height = 10.0f;
    public float smoothRotate = 5.0f;
    
    private Transform camTransform;

    void Awake()
    {
        camTransform = GetComponent<Transform>();
    }
    
    void LateUpdate()
    {
        //천천히 회전
        float currYAngle =
            Mathf.LerpAngle(camTransform.eulerAngles.y, target.eulerAngles.y, smoothRotate * Time.deltaTime);
        
        Quaternion rot = Quaternion.Euler(0,currYAngle, 0);

        camTransform.position = target.position - (rot * Vector3.forward * dist) + (Vector3.up * height);
    
        camTransform.LookAt(target);
    }
}
