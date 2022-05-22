using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using Assets.Scripts.InputSystem;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class VoteSceneManager : MonoBehaviour
{
    public List<TMP_Text> stagePoints;

    public TMP_Text timertext;
    
    private List<int> settingStagePoints;

    private float LimitTimer = 5;
    
    public GameObject player;
    
    private void Start()
    {
        timertext.text = "시간 : " + Mathf.Round(LimitTimer);
        settingStagePoints = new List<int>{0,0,0,0,0};
        foreach (var stgP in stagePoints)
        {
            int idx = 0;
            stgP.text = settingStagePoints[idx].ToString();
            idx++;
        }
    }

    public void GoGameScene()
    {
        //DontDestroyOnLoad(player);
        int idx = settingStagePoints.IndexOf(settingStagePoints.Max());
        switch (idx)
        {
            case 0:
            case 2:
                SceneManager.LoadScene("DemoScene");
//                SceneManager.LoadScene("GameScene");

                break;
            case 1:
            case 3:
            case 4:
                SceneManager.LoadScene("OneRoomScene");
                break;
            default:
                SceneManager.LoadScene("GameScene");
                //SceneManager.LoadScene("DemoScene");
                break;
        }
    }

    public void GoAutionScene()
    {
        SceneManager.LoadScene("AuctionScene");
    }

    public void votting(int idx)
    {
        settingStagePoints[idx]++;
        stagePoints[idx].text = settingStagePoints[idx].ToString();
    }

    private void Update()
    {
        LimitTimer -= Time.deltaTime;
        timertext.text = "시간 : " + Mathf.Round(LimitTimer);
        if (LimitTimer <= 0)
        {
            GoGameScene();
        }
    }
}
