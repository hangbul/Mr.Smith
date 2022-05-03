using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class Door : MonoBehaviour
{
    public GameObject dor;
    public float speed;

    private void Awake()
    {
        speed = 0f;
    }

    private void FixedUpdate()
    {
        dor.transform.position = new Vector3(dor.transform.position.x, dor.transform.position.y - speed,
            dor.transform.position.z);
        
        if (dor.transform.position.y < -30f)
            speed = 0f;
    }

    public void OpenDoor()
    {
        speed = 0.1f;
    }
}
