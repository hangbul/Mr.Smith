using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EventManager : MonoBehaviour
{
    public GameObject MenuPanel;
    public GameObject MenuSet;
    public GameObject SettingMenu;
    
    public GameObject VoteView;
    public GameObject VoteContent;

    private int voteCount;

    void Start()
    {
        voteCount = 0;
    }
    
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            Time.timeScale = 0;
            MenuPanel.SetActive(true);
        }

        if (Time.frameCount % 600 == 0 && voteCount < 3)
        {
            CreateVote();
        }
        
    }
    public void ResumeGame()
    {
        Time.timeScale = 1;
        MenuPanel.SetActive(false);
    }
    public void OpenSettingMenu()
    {
        MenuSet.SetActive(false);
        SettingMenu.SetActive(true);
    }
    public void CloseSettingMenu()
    {
        MenuSet.SetActive(true);
        SettingMenu.SetActive(false);
    }

    public void GamneExit()
    {       
        Application.Quit();
    }
    void CreateVote()
    {
        GameObject go = Instantiate(VoteContent);
        go.transform.SetParent(VoteView.transform);
        go.transform.localScale = new Vector3(0.3f, 0.3f, 0);
    }
}
