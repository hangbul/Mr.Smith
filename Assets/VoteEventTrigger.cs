using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoteEventTrigger : MonoBehaviour
{
    private EventManager EM;

    void Awake()
    {
        EM = GameObject.Find("EventManager").GetComponent<EventManager>();
    }
    
    void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            EM.CreateVote();
            Destroy(this);
        }
    }
}
