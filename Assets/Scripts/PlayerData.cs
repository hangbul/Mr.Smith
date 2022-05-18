using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class PlayerData 
{
    public int maxHealth;

    public int maxAmmo = 100;
    public int curAmmo = 0;

    public int gold;
    public int maxGold;
    public bool hasKey;

    public int AttackPoint = 10;

}
