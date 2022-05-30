using System;
using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public int damage;

    private void Awake()
    {
        if(this.tag == "E_bullet")
            damage = 10;
        else
            damage = GameObject.FindWithTag("Player").GetComponent<PlayerInfo>().AttackPoint;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Centry Room" || collision.gameObject.tag == "Rooms")
        {
            Destroy(gameObject);
        }

        if (this.tag == "E_bullet")
        {
            if (collision.gameObject.tag == "Player")
            {
                Destroy(gameObject);
            }
        }
    }
}
