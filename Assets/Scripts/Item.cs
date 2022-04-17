using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{
    public enum Type
    {
        Coin,
        Heart,
        Weapon,
        Ammo,
    };

    private float rotateSpeed = 40.0f;
    
    public Type type;
    public int value;

    private void Update()
    {
        transform.Rotate(Vector3.up * rotateSpeed * Time.deltaTime);
    }
}
