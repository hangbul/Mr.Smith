using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class IntroManager : MonoBehaviour
{
    public GameObject StartPanel;
    public GameObject IntroPanel;
    public GameObject InputPanel;
    public GameObject SoundMenu;
    public string channelName;
    void Start()
    {
        StartCoroutine(DelayTime(4));
    }

    IEnumerator DelayTime(float time)
    {
        yield return new WaitForSeconds(time);
        IntroPanel.SetActive(false);
        StartPanel.SetActive(true);
    }

    public void OpenSoundMenu()
    {
        SoundMenu.SetActive(true);
    }

    public void CloseSoundMenu()
    {
        SoundMenu.SetActive(false);
    }

    public void CloseInputMenu()
    {
        InputPanel.SetActive(false);
    }

    public void GoTownScene()
    {
        InputPanel.SetActive(true);
    }
    public void CloseGame()
    {
        Application.Quit();
    }

    public void tossChannelName()
    {
        channelName = InputPanel.GetComponentInChildren<InputField>().text;
        SceneManager.LoadScene("TownScene");
        DontDestroyOnLoad(this);

    } 
}
