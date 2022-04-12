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

    public void Use()
    {
        if (type == WeapneType.Melee)
        {
            StopCoroutine("Swing");
            StartCoroutine("Swing");
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
}

