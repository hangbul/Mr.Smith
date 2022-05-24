using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

[Serializable]
public class VoteTimer : MonoBehaviour
{
    private TwitchIRC IRC;
    private EventManager _eventManager;
    
    public TMP_Text text_timer;
    public float LimitTime;
    public TMP_Text vote_T1, vote_T2, vote_T3;
    public int vote1, vote2, vote3;
    public VoteType votetype;
    


    void Update()
    {
        LimitTime -= Time.deltaTime;
        text_timer.text = "시간 : " + Mathf.Round(LimitTime);
        if (LimitTime <= 0)
        {
            //투표 종료시 들어갈 타입별 이벤트 
            if (votetype == VoteType.Spawn)
            {
                if(vote1 > vote2)
                    _eventManager.Spawn_Mv();
                else
                    _eventManager.Spawn_Rt();
            }
            if (_eventManager.voteCount == 1)
            {
                GameObject canvas = GameObject.Find("Canvas");
                canvas.transform.GetChild(3).gameObject.SetActive(false);
                _eventManager.CountDown();
            }
            else
            {
                _eventManager.CountDown();
            }
            Destroy(this.gameObject);
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

        if (votetype == VoteType.Weather)
        {
            if (msgString == "!" + vote_T3.text)
            {
                vote3++;
            }
        }
    }
   
    void Awake()
    {
        _eventManager = GameObject.Find("EventManager").GetComponent<EventManager>();
        vote1 = 0;
        vote2 = 0;
        vote3 = 0;
        IRC = GameObject.Find("TwitchIRC").GetComponent<TwitchIRC>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }


}
