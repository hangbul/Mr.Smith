using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;

public class MCMvcam : MonoBehaviour
{
    private CinemachineVirtualCamera cam;
    private RaycastHit hit;

    void Awake()
    {
        cam = GetComponent<CinemachineVirtualCamera>();
    }
    void Update()
    {
        Debug.DrawRay(transform.position, transform.forward * 10, Color.red);
        if (Physics.Raycast(transform.position, transform.forward, out hit))
        {
            Debug.Log(hit.collider.tag);
            if (hit.collider.tag == "Rooms")
            {
                if (cam.Priority == 10)
                    cam.Priority = 7;
            }
            else
            {
                if (cam.Priority == 7)
                    cam.Priority = 10;
            }
        }
    }
}
