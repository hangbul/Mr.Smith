using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class VoteTimer : MonoBehaviour
{
    private TwitchIRC IRC;
    public TMP_Text text_timer;
    public float LimitTime;
    public TMP_Text vote_T1, vote_T2, vote_T3;
    public int vote1, vote2, vote3;
    public VoteType votetype;
    public RoomTemplates roomList;


    void Update()
    {
        LimitTime -= Time.deltaTime;
        text_timer.text = "시간 : " + Mathf.Round(LimitTime);
        if (LimitTime <= 0)
        {
            //투표 종료시 들어갈 타입별 이벤트 
            if (votetype == VoteType.Normal)
            {
                if (vote1 > vote2)
                {
                    for (int i = 0; i < roomList.rooms.Count; i++)
                    {
                        GameObject SpawnPoint = roomList.rooms[i].transform.Find("EenmySpawnPoint").gameObject;
                        SpawnPoint.GetComponent<SpawnOBJ>().Spawn();
                    }
                }
                
            }
            else if (votetype == VoteType.Normal2)
            {
                if (vote1 > vote2)
                {
                    for (int i = 0; i < roomList.rooms.Count; i++)
                    {
                        GameObject SpawnPoint = roomList.rooms[i].transform.Find("EenmySpawnPoint").gameObject;
                        SpawnPoint.GetComponent<SpawnOBJ>().Spawn();
                    }
                }
                
            }

            Destroy(gameObject);
        }
    }

    void OnChatMsgRecieved(string msg)
    {
        int msgIndex = msg.IndexOf("PRIVMSG #");
        string msgString = msg.Substring(msgIndex + IRC.channelName.Length + 11);
        
        if (msgString == "!" + vote_T1.text)
        {
            vote1++;
        }
        if (msgString == "!" + vote_T2.text)
        {
            vote2++;
        }

        if (votetype == VoteType.Normal2)
        {
            if (msgString == "!" + vote_T3.text)
            {
                vote3++;
            }
        }
    }
   
    void Awake()
    {
        vote1 = 0;
        vote2 = 0;
        vote3 = 0;
        IRC = GameObject.Find("TwitchIRC").GetComponent<TwitchIRC>();
        roomList = GameObject.Find("Room Templates").GetComponent<RoomTemplates>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }


}
