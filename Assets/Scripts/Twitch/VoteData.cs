using System;
using UnityEngine;
using Object = System.Object;

[Serializable]

public struct VoteData
{
    public Sprite questSpriteimage;
    public GameObject votePrefab;
    public string voteName;
    public VoteType voteType;
    public string voteDescription;
    public string text1, text2, text3;
    public int ID;
    public float lifeTime;


}
