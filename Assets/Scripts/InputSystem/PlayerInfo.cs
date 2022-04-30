using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;


public class PlayerInfo : MonoBehaviour
{
    public int maxHealth = 100;
    public int curHealth;
    public HealthBar healthbar;

    public int maxAmmo = 100;
    public int curAmmo = 0;

    public int gold;
    public int maxGold;
    
    void Start()
    {
        curHealth = maxHealth;
        healthbar.SetMaxHealth(maxHealth);
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy")
        {
            Enemy enemy = other.GetComponent<Enemy>();
            TakeDamage(enemy.AttackPoint);
        }
    }

    public void TakeDamage(int damage)
    {
        print("Damaged  ");
        curHealth -= damage;
        healthbar.SetHealth(curHealth);
        isPlayerDead();
    }

    public void isPlayerDead()
    {
        if (curHealth <= 0)
        {
            SceneManager.LoadScene("TownScene");
        }
    }

}
