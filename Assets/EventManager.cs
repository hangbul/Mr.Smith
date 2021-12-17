using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EventManager : MonoBehaviour
{
    public GameObject MenuPanel;
    public GameObject MenuSet;
    public GameObject SettingMenu;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            Time.timeScale = 0;
            MenuPanel.SetActive(true);
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
    
}
