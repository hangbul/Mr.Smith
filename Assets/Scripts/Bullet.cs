using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public int damage;

    private void Awake()
    {
        damage = GameObject.FindWithTag("Player").GetComponent<PlayerInfo>().AttackPoint;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Centry Room" || collision.gameObject.tag == "Rooms")
        {
            Destroy(gameObject);
        }
    }
}
