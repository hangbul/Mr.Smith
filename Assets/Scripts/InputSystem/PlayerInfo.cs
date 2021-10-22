using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
public class PlayerInfo : MonoBehaviour
{
    public int maxHealth = 100;
    public int currHealth;
    public HealthBar healthbar;

    void Start()
    {
        currHealth = maxHealth;
        healthbar.SetMaxHealth(maxHealth);
    }

    
    public void TakeDamage(int damage)
    {
        print("Damaged  ");
        currHealth -= damage;
        healthbar.SetHealth(currHealth);
    }
    
}
