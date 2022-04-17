using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    
    public WeapneType type;
    public int idx = 0;
    public int damage;
    public float rate;
    public BoxCollider meleeArea;
    public TrailRenderer traileEffect;

    public GameObject bullet;
    public Transform bulletPos;

    public int maxAmmo;
    public int curAmmo;
    
    public void Use()
    {
        if (type == WeapneType.Melee)
        {
            StopCoroutine("Swing");
            StartCoroutine("Swing");
        }else if (type == WeapneType.Missile)
        {
            if (curAmmo > 0)
            {
                curAmmo--;
                StartCoroutine("shot");
            }
        }
    }

    IEnumerator Swing()
    {
        yield return new WaitForSeconds(0.1f);
        meleeArea.enabled = true;
        traileEffect.enabled = true;

        yield return new WaitForSeconds(0.3f);
        meleeArea.enabled = false;

        yield return new WaitForSeconds(0.3f);
        traileEffect.enabled = false;
        
    }

    IEnumerator shot()
    {
        GameObject instantBullet = Instantiate(bullet, bulletPos.position, bulletPos.rotation);
        Rigidbody bulletRigid = instantBullet.GetComponent<Rigidbody>();
        bulletRigid.velocity = bulletPos.forward * 50;
        yield return null;
    }
}

