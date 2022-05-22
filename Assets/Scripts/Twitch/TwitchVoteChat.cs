using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

[RequireComponent(typeof(TwitchIRC))]
public class TwitchVoteChat : MonoBehaviour
{
    private TwitchIRC IRC;
    private VoteSceneManager _eventManager;
    
    void Update()
    {
    }

    void OnChatMsgRecieved(string msg)
    {
        int msgIndex = msg.IndexOf("PRIVMSG #");
        string msgString = msg.Substring(msgIndex + IRC.channelName.Length + 11);
        
        if (msgString == "!" + 1)
        {
            _eventManager.votting(0);
        }
        if (msgString == "!" + 2)
        {
            _eventManager.votting(1);
        }
        if (msgString == "!" + 3)
        {
            _eventManager.votting(2);
        }
        if (msgString == "!" + 4)
        {
            _eventManager.votting(3);
        }
        if (msgString == "!" + 5)
        {
            _eventManager.votting(4);
        }
    }
   
    void Awake()
    {
        _eventManager = GameObject.Find("VoteManager").GetComponent<VoteSceneManager>();
        IRC = GameObject.Find("TwitchIRC").GetComponent<TwitchIRC>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }

  
}