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
    
    
    void Update()
    {
        LimitTime -= Time.deltaTime;
        text_timer.text = "시간 : " + Mathf.Round(LimitTime);
        if (LimitTime <= 0)
        {
            Destroy(gameObject);
        }
    }

    void OnChatMsgRecieved(string msg)
    {
        int msgIndex = msg.IndexOf("PRIVMSG #");
        string msgString = msg.Substring(msgIndex + IRC.channelName.Length + 11);
        
        Debug.Log("ChatRecieved");
        Debug.Log(msgString);
        Debug.Log("vote1 : " + vote_T1.text + ",  vote2 : " + vote_T2.text);

        if (msgString == "!" + vote_T1.text)
        {
            vote1++;
        }
        if (msgString == "!" + vote_T2.text)
        {
            vote2++;
        }
    }
   
    void Start()
    {
        vote1 = 0;
        vote2 = 0;
        IRC = GameObject.Find("TwitchIRC").GetComponent<TwitchIRC>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }


}
