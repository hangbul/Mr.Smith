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
        target = GameObject.Find("Player").transform;
    }
    
    void LateUpdate()
    {
        
        camTransform.position = target.position - (Vector3.forward * dist) + (Vector3.up * height);
    
        camTransform.LookAt(target);
    }
}
