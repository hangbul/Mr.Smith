using System;
using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class EventManager : MonoBehaviour
{
    public GameObject MenuPanel;
    public GameObject MenuSet;
    public GameObject SettingMenu;

    public GameObject VoteView;
    public VoteTypeDataBase VoteContents;
    
    public int voteCount;

    public GameObject SpawnPoint;
    public GameObject GameObjects;
    private GameObject player;
    public RoomTemplates roomList;

    void Start()
    {
        voteCount = 0;
        player = GameObject.Find("Player");
        player.GetComponent<PlayerInfo>().healthbar = GameObject.Find("Health Bar").GetComponent<HealthBar>();
        player.GetComponent<PlayerInfo>().SetUpMaxHealth();
        player.GetComponent<PlayerMovement>().mainCam = Camera.main;
        player.transform.SetParent(GameObjects.transform);
        player.transform.position = SpawnPoint.transform.position;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            Time.timeScale = 0;
            MenuPanel.SetActive(true);
        }

    
    /*
    if (Time.frameCount % 540 == 0 && voteCount < 3)
    {
        CreateVote();
    }
     */

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

    public void CreateVote()
    {
        
        
        int rand = Random.Range(0, VoteContents.voteDatas.Count);
        GameObject go = Instantiate(VoteContents.voteDatas[rand].votePrefab);
        VoteType type = go.GetComponent<VoteTimer>().votetype;
        go.GetComponent<VoteTimer>().vote_T1.text = VoteContents.voteDatas[rand].text1;
        go.GetComponent<VoteTimer>().vote_T2.text = VoteContents.voteDatas[rand].text2;
        if(type == VoteType.Normal2)
            go.GetComponent<VoteTimer>().vote_T3.text = VoteContents.voteDatas[rand].text3;
        go.GetComponent<VoteTimer>().LimitTime = VoteContents.voteDatas[rand].lifeTime;

        go.transform.SetParent(VoteView.transform);
        go.transform.localScale = new Vector3(0.6f, 0.6f, 0);
    }
    public void Spawn()
    {
        foreach (var room in roomList.rooms)
        {
            if (room.transform.GetChild(0).tag == "SpawnOBJPoint")
            {
                room.transform.GetChild(0).GetComponent<SpawnOBJ>().Spawn();
            }
        }
        
    }
}