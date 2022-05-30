using System;
using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public int damage;
    private Collider _collider;
    private GameObject player;
    public enum bulletType
    {
        arrow,
        seed
    }

    [SerializeField]public bulletType _type;
    private void Awake()
    {
        _collider = GetComponentInChildren<Collider>();
        player = GameObject.FindWithTag("Player");
        if(_type == bulletType.seed)
            damage = 5;
        else
            damage = player.GetComponent<PlayerInfo>().AttackPoint;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Centry Room" || collision.gameObject.tag == "Rooms")
        {
            Destroy(gameObject);
        }

        if (_type == bulletType.seed)
        {
            if (collision.gameObject.tag == "Player")
            {
                Destroy(gameObject);
            }
        }
    }
}
