using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;

public class MCMvcam : MonoBehaviour
{
    private CinemachineVirtualCamera cam;
    private RaycastHit hit;
    private Vector3 dir;
    void Awake()
    {
        cam = GetComponent<CinemachineVirtualCamera>();
        Transform target = GameObject.FindWithTag("Player").transform;
        dir = target.position - transform.position;

    }
    void Update()
    {
        Debug.DrawRay(transform.position, dir.normalized * 50, Color.red);
        if (Physics.Raycast(transform.position, dir.normalized, out hit))
        {
            Debug.Log(hit.collider.tag);
            
            if(hit.collider.tag == "Player")
            {
                if (cam.Priority == 7)
                    cam.Priority = 10;
            }
            else
            {
                if (cam.Priority == 10)
                    cam.Priority = 7;
            }
        }
    }
}
