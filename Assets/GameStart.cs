using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameStart : MonoBehaviour
{
    private EventManager EM;
    void Awake()
    {
        EM = GameObject.Find("EventManager").GetComponent<EventManager>();
        EM.GetSpawnPoint();
    }

}
