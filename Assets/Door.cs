using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    public GameObject dor;

    public void OpenDoor()
    {
        dor.transform.position = new Vector3(0, dor.transform.position.y  -50, 0);
    }
}
