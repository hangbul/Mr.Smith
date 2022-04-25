using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class TownManager : MonoBehaviour
{

    public GameObject townPanel;
    public GameObject statusPanel;

    public TextMeshProUGUI playerStatPointText;
    public TextMeshProUGUI playerHealthPointText;
    public TextMeshProUGUI playerSpeedPointText;
    public TextMeshProUGUI playerAttackPointText;

    public int playerStatusPoint;
    public int playerHealthPoint;
    public int playerSpeedPoint;
    public int playerAttackPoint;

    private int resultHP;
    private int resultSpeed;
    private int resultAttack;
    
    private void Awake()
    {
        townPanel.SetActive(true);
        statusPanel.SetActive(false);
    }

    void Start()
    {
    }

    public void GoGameScene()
    {

        resultAttack += playerAttackPoint;
        resultSpeed += playerSpeedPoint;
        resultHP += playerHealthPoint;
        Debug.Log("result Attack :" + resultAttack);
        Debug.Log("result Speed : " + resultSpeed);
        Debug.Log("result Health : " + resultHP);
        SceneManager.LoadScene("GameScene"); 
    }


    public void GoAutioncene()
    {
        SceneManager.LoadScene("AuctionScene");
    }

    public void increaseHealth()
    {
        if (playerStatusPoint == 0)
            return;
        {
            playerHealthPoint++;
            playerStatusPoint--;
        }
    }

    public void increaseSpeed()
    {
        if (playerStatusPoint == 0)
            return;
        {
            playerSpeedPoint++;
            playerStatusPoint--;
        }
    }
    public void increaseAttack()
    {
        if (playerStatusPoint == 0)
            return;
        {
            playerAttackPoint++;
            playerStatusPoint--;
        }
    }

    public void intoDungeonClick()
    {
        townPanel.SetActive(false);
        statusPanel.SetActive(true);
    }

    private void LateUpdate()
    {
        playerAttackPointText.text = playerAttackPoint.ToString();
        playerHealthPointText.text = playerHealthPoint.ToString();
        playerSpeedPointText.text = playerSpeedPoint.ToString();
        playerStatPointText.text = "POINT : " + playerStatusPoint.ToString();
    }
}
