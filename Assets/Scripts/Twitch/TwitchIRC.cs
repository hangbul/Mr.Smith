using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TwitchIRC : MonoBehaviour
{
    public string channelName;
    public class MsgEvent : UnityEngine.Events.UnityEvent<string> { }
    public MsgEvent messageRecievedEvent = new MsgEvent();

    private string server = "irc.twitch.tv";
    private string oauth = "oauth:0hbmyni5a8uzwzpnq5klqk6v8y429h";
    private int port = 6667;
    private string buffer = string.Empty;
    private bool stopThreads = false;
    private Queue<string> commandQueue = new Queue<string>();
    private List<string> recievedMsgs = new List<string>();
    private System.Threading.Thread inProc, outProc;
    private void StartIRC()
    {
        System.Net.Sockets.TcpClient client = new System.Net.Sockets.TcpClient();
        client.Connect(server, port);
        if (!client.Connected)
        {
            Debug.Log("Failed to connect!");
            return;
        }
        var networkStream = client.GetStream();
        var input = new System.IO.StreamReader(networkStream);
        var output = new System.IO.StreamWriter(networkStream);

        output.WriteLine("PASS " + oauth);
        output.WriteLine("NICK " + "temp");
        output.Flush();

        outProc = new System.Threading.Thread(() => IRCOutputProcedure(output));
        outProc.Start();
        inProc = new System.Threading.Thread(() => IRCInputProcedure(input, networkStream));
        inProc.Start();
    }
    private void IRCInputProcedure(System.IO.TextReader input, System.Net.Sockets.NetworkStream networkStream)
    {
        while (!stopThreads)
        {
            if (!networkStream.DataAvailable)
                continue;

            buffer = input.ReadLine();

            if (buffer.Contains("PRIVMSG #"))
            {
                lock (recievedMsgs)
                {
                    recievedMsgs.Add(buffer);
                }
            }
            
            if (buffer.StartsWith("PING "))
            {
                SendCommand(buffer.Replace("PING", "PONG"));
            }
            if (buffer.Split(' ')[1] == "001")
            {
                SendCommand("JOIN #" + channelName);
            }
        }
    }
    private void IRCOutputProcedure(System.IO.TextWriter output)
    {
        System.Diagnostics.Stopwatch stopWatch = new System.Diagnostics.Stopwatch();
        stopWatch.Start();
        while (!stopThreads)
        {
            lock (commandQueue)
            {
                if (commandQueue.Count > 0) 
                {
                    if (stopWatch.ElapsedMilliseconds > 1750)
                    {
                        output.WriteLine(commandQueue.Peek());
                        output.Flush();
                        commandQueue.Dequeue();
                        stopWatch.Reset();
                        stopWatch.Start();
                    }
                }
            }
        }
    }

    public void SendCommand(string cmd)
    {
        lock (commandQueue)
        {
            commandQueue.Enqueue(cmd);
        }
    }
    void Start()
    {
        GameObject _introManager = GameObject.Find("IntroManager");
        if(_introManager != null)
            channelName = _introManager.GetComponent<IntroManager>().channelName;
    }
    void OnEnable()
    {
        stopThreads = false;
        StartIRC();
    }
    void OnDisable()
    {
        stopThreads = true;
    }
    void OnDestroy()
    {
        stopThreads = true;
    }
    void Update()
    {
        lock (recievedMsgs)
        {
            if (recievedMsgs.Count > 0)
            {
                for (int i = 0; i < recievedMsgs.Count; i++)
                {
                    messageRecievedEvent.Invoke(recievedMsgs[i]);
                }
                recievedMsgs.Clear();
            }
        }
    }
}
