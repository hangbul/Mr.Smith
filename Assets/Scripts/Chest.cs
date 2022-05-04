using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using Random = UnityEngine.Random;

public class Chest : MonoBehaviour
{
 
    public GameObject[] items;
    public bool isActive = false;
    public int itemCount = 0;
    private SphereCollider collider;

    private void Awake()
    {
        collider = GetComponent<SphereCollider>();
    }

    private void FixedUpdate()
    {
        dropItems();
    }

    public void SetActive()
    {
        isActive = true;
    }
    
    private void dropItems()
    {
        if (itemCount > 5)
        {
            Destroy(this.gameObject,3f);
            return;
        }
        
        if (isActive && itemCount<=5)
        {
            new WaitForSeconds(0.3f);
            int randomItems = Random.Range(0, 4);
            Instantiate(items[randomItems], transform.position + new Vector3(0, 2, 0), Quaternion.identity);
            itemCount++;
        }
    }
}
