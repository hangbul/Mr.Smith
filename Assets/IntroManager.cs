using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class IntroManager : MonoBehaviour
{
    public GameObject StartPanel;
    public GameObject IntroPanel;
    
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

    public void GoGameScene()
    {
        SceneManager.LoadScene(1);
    }
    
}
