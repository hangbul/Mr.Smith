using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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
    public List<int> votes;
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
                if(votes[0] > votes[1])
                    _eventManager.Spawn_Mv();
                else
                    _eventManager.Spawn_Rt();
            }
            else if (votetype == VoteType.Weather)
            {
                int idx = votes.IndexOf(votes.Max());
                _eventManager.ChageWeather(idx);
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
            votes[0]++;
        }
        if (msgString == "!" + vote_T2.text)
        {
            votes[1]++;
        }

        if (votetype == VoteType.Weather)
        {
            if (msgString == "!" + vote_T3.text)
            {
                votes[2]++;
            }
        }
    }
   
    void Awake()
    {
        votes = new List<int>{0,0,0};
        _eventManager = GameObject.Find("EventManager").GetComponent<EventManager>();
        IRC = GameObject.Find("TwitchIRC").GetComponent<TwitchIRC>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }


}
