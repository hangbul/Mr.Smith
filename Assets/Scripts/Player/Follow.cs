using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;

public class Follow : MonoBehaviour
{
    private CinemachineVirtualCamera cam;
    void Awake()
    {
        cam = GetComponent<CinemachineVirtualCamera>();
        Transform playerTransform = GameObject.FindWithTag("Player").transform;
        cam.Follow = playerTransform;
        cam.LookAt = playerTransform;
    }
    
}
