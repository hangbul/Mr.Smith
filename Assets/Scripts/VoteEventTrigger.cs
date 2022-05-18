using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoteEventTrigger : MonoBehaviour
{
    private EventManager EM;
    public GameObject canvas;
    void Start()
    {
        EM = GameObject.Find("EventManager").GetComponent<EventManager>();
        canvas = GameObject.Find("Canvas");
    }
    
    void OnTriggerEnter(Collider other)
    { 
        if (other.transform.tag == "Player")
        {
            
            if (EM.voteCount == 0)
            {
                canvas.transform.GetChild(3).gameObject.SetActive(true);
            }
            

            EM.CreateVote();
            Destroy(this);
        }
    }
}
