using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
public class PlayerInfo : MonoBehaviour
{
    public int maxHealth = 100;
    public int currHealth;
    public HealthBar healthbar;

    public int maxAmmo = 100;
    public int curAmmo = 0;

    public int gold;
    public int maxGold;
    
    void Start()
    {
        currHealth = maxHealth;
        healthbar.SetMaxHealth(maxHealth);
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EnemyAttack")
        {
            
        }
    }

    public void TakeDamage(int damage)
    {
        print("Damaged  ");
        currHealth -= damage;
        healthbar.SetHealth(currHealth);
    }
    
}
