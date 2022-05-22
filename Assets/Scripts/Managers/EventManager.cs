using System;
using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
using Cinemachine;
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
    public CinemachineVirtualCamera CVcam;

    public GameObject SpawnPoint;
    public GameObject GameObjects;
    public GameObject player;
    public RoomTemplates roomList;
    public CinemachineVirtualCamera virCam = null;

    private bool debug_TopCam = false;
    private bool debug_godMode = false;

    private static GameObject instance;
    
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

        //Debug
        else if (Input.GetKeyDown(KeyCode.F1))
        {
            if (!debug_godMode)
            {
                player.GetComponent<PlayerInfo>().debug_godMode = true;
            }
            else
            {
                player.GetComponent<PlayerInfo>().debug_godMode = false;
            }
            debug_godMode = !debug_godMode;
        }
        else if (Input.GetKeyDown(KeyCode.F2))
        {
            OnChangePriorty();
        }
        else if (Input.GetKeyDown(KeyCode.F3))
        {
            //수정 필요
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
        else if (Input.GetKeyDown(KeyCode.F4))
        {
            //수정 필요
            SceneManager.LoadScene("TownScene");
        }

    }

    public void OnChangePriorty()
    {
        if (virCam.Priority == 9)
        {
            virCam.Priority = 11;
        }

        else
        {
            virCam.Priority = 9;
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