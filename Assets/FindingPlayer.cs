using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FindingPlayer : MonoBehaviour
{
    private GameObject P;

    void Start()
    {
        P = transform.parent.gameObject;
    }
    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
            P.GetComponent<Enemy_Rt>()._enemyState = EnemyState.Attack;
    }

    void OnTriggerStay(Collider other)
    {
        
    }

    void OnTriggerExit(Collider other)
    {
        if(other.tag == "Player")
            P.GetComponent<Enemy_Rt>()._enemyState = EnemyState.Idle;
    }


}
