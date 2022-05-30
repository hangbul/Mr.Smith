using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    
    public WeapneType type;
    public PlayerInfo playerInfo;
    public int idx = 0;
    public float damage;
    public float rate;
    public BoxCollider meleeArea;
    public ParticleSystem effect;

    public GameObject bullet;
    public Transform bulletPos;

    public int maxAmmo;
    public int curAmmo;

    private MeshRenderer _meshRenderer;
    public Material defaultMat;
    public Material fireMat;
    public Material iceMat;
    public Material lightMat;
    private void Awake()
    {
        _meshRenderer = GetComponentInChildren<MeshRenderer>();
    }

    private void LateUpdate()
    {
        if(playerInfo.playerElement == PlayerElement.None)
            _meshRenderer.material = defaultMat;
        else if (playerInfo.playerElement == PlayerElement.Fire)
            _meshRenderer.material = fireMat;
        else if (playerInfo.playerElement == PlayerElement.Ice)
            _meshRenderer.material = iceMat;
        else if (playerInfo.playerElement == PlayerElement.Lightning)
            _meshRenderer.material = lightMat;
        
        if(playerInfo.playerElement == PlayerElement.None)
            damage = 10;
        else if (playerInfo.playerElement == PlayerElement.Fire)
            damage = 15;
        else if (playerInfo.playerElement == PlayerElement.Ice)
            damage = 12;
        else if (playerInfo.playerElement == PlayerElement.Lightning)
            damage = 13;
    }

    public void Use()
    {
        if (type == WeapneType.Melee)
        {
            StopCoroutine("Swing");
            StartCoroutine("Swing");
        }
        else if (type == WeapneType.Missile)
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
        effect.Play();
        //traileEffect.enabled = true;

        yield return new WaitForSeconds(0.2f);
        effect.Stop();

        yield return new WaitForSeconds(0.2f);
        meleeArea.enabled = false;
        //traileEffect.enabled = false;
        
    }

    IEnumerator shot()
    {
        GameObject instantBullet = Instantiate(bullet, bulletPos.position, bulletPos.rotation);
        Rigidbody bulletRigid = instantBullet.GetComponent<Rigidbody>();
        bulletRigid.velocity = bulletPos.forward * 50;
        yield return null;
    }
}

