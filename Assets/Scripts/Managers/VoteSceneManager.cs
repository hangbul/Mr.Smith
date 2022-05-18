using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Assets.Scripts.InputSystem;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class VoteSceneManager : MonoBehaviour
{
    public List<TMP_Text> stagePoints;

    public TMP_Text timertext;
    
    private List<int> settingStagePoints;

    private float LimitTimer = 30;
    
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
        if(idx > 0)
            SceneManager.LoadScene("DemoScene"); 
        else
            SceneManager.LoadScene("GameScene");
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
