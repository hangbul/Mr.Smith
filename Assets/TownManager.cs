using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
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
    
    public int playerHealthPoint;
    public int playerSpeedPoint;
    public int playerAttackPoint;

    private int resultHP;
    private int resultSpeed;
    private int resultAttack;
    private int totalStatusPoint;

    public GameObject player;
    public PlayerInfo playerinfo;
    public PlayerMovement playerMovement;
    
    private void Awake()
    {
        townPanel.SetActive(true);
        statusPanel.SetActive(false);
        totalStatusPoint = playerinfo.playerStatusPoint;
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
        
        DontDestroyOnLoad(player);
        SceneManager.LoadScene("GameScene"); 
    }


    public void GoAutioncene()
    {
        SceneManager.LoadScene("AuctionScene");
    }

    public void increaseHealth()
    {
        if (totalStatusPoint == 0)
            return;
        {
            playerHealthPoint++;
            playerinfo.maxHealth += 50;
            totalStatusPoint--;
        }
    }

    public void increaseSpeed()
    {
        if (totalStatusPoint == 0)
            return;
        {
            playerSpeedPoint++;
            playerMovement.speed += 0.1f;
            totalStatusPoint--;
        }
    }
    public void increaseAttack()
    {
        if (totalStatusPoint == 0)
            return;
        {
            playerAttackPoint++;
            playerinfo.AttackPoint += 3;
            totalStatusPoint--;
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
        playerStatPointText.text = "POINT : " + totalStatusPoint.ToString();
    }
}
