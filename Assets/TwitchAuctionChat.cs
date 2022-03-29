using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(TwitchIRC))]
public class TwitchAuctionChat : MonoBehaviour
{
    public int maxMessages = 100; //we start deleting UI elements when the count is larger than this var.
    private LinkedList<GameObject> messages =
        new LinkedList<GameObject>();
    public UnityEngine.RectTransform chatPanel;
    private TwitchIRC IRC;
    void OnChatMsgRecieved(string msg)
    {
        int msgIndex = msg.IndexOf("PRIVMSG #");
        string msgString = msg.Substring(msgIndex + IRC.channelName.Length + 11);
        string user = msg.Substring(1, msg.IndexOf('!') - 1);

        if (messages.Count > maxMessages)
        {
            Destroy(messages.First.Value);
            messages.RemoveFirst();
        }

        CreateUIMessage(user, msgString);
    }
    void CreateUIMessage(string userName, string msgString)
    {
        Color32 c = ColorFromUsername(userName);
        string nameColor = "#" + c.r.ToString("X2") + c.g.ToString("X2") + c.b.ToString("X2");
        GameObject go = new GameObject("twitchMsg");
        var text = go.AddComponent<UnityEngine.UI.Text>();
        var layout = go.AddComponent<UnityEngine.UI.LayoutElement>();
        go.transform.SetParent(chatPanel); 
        float posX = Random.Range(chatPanel.rect.xMin, chatPanel.rect.xMax);
        float posY = Random.Range(chatPanel.rect.yMin, chatPanel.rect.yMax);
        go.transform.position = new Vector3(posX, posY, 0); 
        
        messages.AddLast(go);
        layout.minHeight = 20f;
        text.text = "<color=" + nameColor + "><b>" + userName + "</b></color>" + ": " + msgString;
        text.color = Color.black;
        text.font = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf") as Font;
    }
    Color ColorFromUsername(string username)
    {
        Random.seed = username.Length + (int)username[0] + (int)username[username.Length - 1];
        return new Color(Random.Range(0.25f, 0.55f), Random.Range(0.20f, 0.55f), Random.Range(0.25f, 0.55f));
    }
    void Start()
    {
        IRC = this.GetComponent<TwitchIRC>();
        IRC.messageRecievedEvent.AddListener(OnChatMsgRecieved);
    }
  
}