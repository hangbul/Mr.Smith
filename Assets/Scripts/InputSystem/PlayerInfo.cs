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

    private SkinnedMeshRenderer _meshRenderer;
    private bool isDamage = false;
    void Start()
    {
        curHealth = maxHealth;
        healthbar.SetMaxHealth(maxHealth);
        _meshRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EnemyBullet")
        {
            Bullet enemyBullet = other.GetComponent<Bullet>();
            curHealth -= enemyBullet.damage;

            StartCoroutine(OnDamage());
        }
    }

   IEnumerator OnDamage()
   {
       isDamage = true;
       _meshRenderer.material.color = Color.red;
       
       healthbar.SetHealth(curHealth);
       isPlayerDead();

       yield return new WaitForSeconds(1f);
       _meshRenderer.material.color = Color.white;
       isDamage = false;
   }

    public void TakeDamage(int damage)
    {
        print("Damaged  ");
       
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
