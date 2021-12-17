using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class IntroManager : MonoBehaviour
{
    public GameObject StartPanel;
    public GameObject IntroPanel;
    public GameObject SoundMenu;

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

    public void GoGameScene()
    {
        SceneManager.LoadScene("GameScene");
    }
    public void CloseGame()
    {
        Application.Quit();
    }
    
}
