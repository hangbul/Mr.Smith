using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoteEventTrigger : MonoBehaviour
{
    private EventManager EM;
    private GameObject canvas;
    void Awake()
    {
        EM = GameObject.Find("EventManager").GetComponent<EventManager>();
        canvas = GameObject.Find("Canvas");
    }
    
    void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            canvas.transform.GetChild(4).gameObject.SetActive(true);
            EM.CreateVote();
            Destroy(this);
        }
    }
}
