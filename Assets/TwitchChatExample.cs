using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(TwitchIRC))]
public class TwitchChatExample : MonoBehaviour
{
    public int maxMessages = 100; 
    public UnityEngine.RectTransform chatBox;
    
    private TwitchIRC IRC;
    private GameObject go;
    
    private UnityEngine.UI.Text text;
    private UnityEngine.UI.LayoutElement layout;
    
    void OnChatMsgRecieved(string msg)
    {
        //parse from buffer.
        int msgIndex = msg.IndexOf("PRIVMSG #");
        string msgString = msg.Substring(msgIndex + IRC.channelName.Length + 11);
        string user = msg.Substring(1, msg.IndexOf('!') - 1);

        //add new message.
        CreateUIMessage(user, msgString);
    }
    void CreateUIMessage(string userName, string msgString)
    {
        Color32 c = ColorFromUsername(userName);
        string nameColor = "#" + c.r.ToString("X2") + c.g.ToString("X2") + c.b.ToString("X2");
        
        go.transform.SetParent(chatBox);
        go.transform.position = chatBox.transform.position;
        go.GetComponent<RectTransform>().anchorMin = new Vector2 (0.2f,0.5f);
        go.GetComponent<RectTransform>().anchorMax = new Vector2 (1-0.2f,0.5f);

        text.text = msgString;
        text.color = Color.black;
        text.fontSize = 20;
        text.font = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf") as Font;
    }

    Color ColorFromUsername(string username)
    {
        Random.seed = username.Length + (int)username[0] + (int)username[username.Length - 1];
        return new Color(Random.Range(0.25f, 0.55f), Random.Range(0.20f, 0.55f), Random.Range(0.25f, 0.55f));
    }
    // Use this for initialization
    void Start()
    {
        IRC = this.GetComponent<TwitchIRC>();
        //IRC.SendCommand("CAP REQ :twitch.tv/tags"); //register for additional data such as emote-ids, name color etc.
        go = new GameObject("twitchMsg");
        text = go.AddComponent<UnityEngine.UI.Text>();
        layout = go.AddComponent<UnityEngine.UI.LayoutElement>();
        layout.minHeight = 5f;
        text.text = "  ";
        text.color = Color.black;
        text.fontSize = 20;
        text.font = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf") as Font;
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }
}
