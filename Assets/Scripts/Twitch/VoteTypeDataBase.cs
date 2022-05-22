using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName ="VoteTypeDatabase", menuName ="투표 데이터베이스 만들기")]
public class VoteTypeDataBase : ScriptableObject
{
    public List<VoteData> voteDatas;
}
