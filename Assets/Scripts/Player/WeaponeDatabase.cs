using UnityEngine;
using System.Collections.Generic;

[CreateAssetMenu(fileName ="WeaponeDatabase", menuName ="무기 데이터베이스 만들기")]
public class WeaponeDatabase : ScriptableObject
{
    public List<WeaponData> WeaponDatas;
}
