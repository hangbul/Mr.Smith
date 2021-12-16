using System;
using UnityEngine;
using Object = System.Object;

[Serializable]
public struct WeaponData
{
    public Sprite weaponSpriteimage;
    public GameObject weaponPrefab;
    public string weaponName;
    public WeapneType WeaponType;
    public float attack_dmg;
    
}