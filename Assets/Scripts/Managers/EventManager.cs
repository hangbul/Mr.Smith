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

    public GameObject SpawnPoint;
    public GameObject GameObjects;
    public GameObject player;
    public RoomTemplates roomList;
    public CinemachineVirtualCamera virCam = null;
    
    public bool isNight = false;    //밤낮여부
    public enum varWeather
    {
        isRaining,
        isSnowing,
        isSunny
    }
    private varWeather currWeather = varWeather.isSunny;

    public DAYnNIGHT DnN;
    private bool debug_TopCam = false;
    private bool debug_godMode = false;
    private int debug_count = 0;
    private static GameObject instance;
    private GameObject canvas;
    public WeatherManager WM;

    private GameObject[] spawnPoints;
    void Start()
    {
        spawnPoints = GameObject.FindGameObjectsWithTag("SpawnOBJPoint");
        voteCount = 0;
        canvas = GameObject.Find("Canvas");
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
        else if (Input.GetKeyDown(KeyCode.F5))
        {
            if(DnN.sPerTime == 5)
                DnN.sPerTime = 50;
            else
                DnN.sPerTime = 5;
        }
        else if (Input.GetKeyDown(KeyCode.F6))
        {
            debug_count++;
            if (debug_count > 3)
                debug_count = 0;
            ChageWeather(debug_count);
     
        }
        else if (Input.GetKeyDown(KeyCode.F7))
        {
            CreateVote();
        }

        
    }

    public void OnChangePriorty()
    {
        if (virCam.Priority == 8)
        {
            virCam.Priority = 13;
        }

        else
        {
            virCam.Priority = 8;
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

        if (voteCount == 0)
        {
            canvas.transform.GetChild(3).gameObject.SetActive(true);
        }
        
        voteCount++;
        int rand = Random.Range(0, VoteContents.voteDatas.Count);
        GameObject go = Instantiate(VoteContents.voteDatas[rand].votePrefab);
        go.GetComponent<VoteTimer>().votetype = VoteContents.voteDatas[rand].voteType;
        go.GetComponent<VoteTimer>().vote_T1.text = VoteContents.voteDatas[rand].text1;
        go.GetComponent<VoteTimer>().vote_T2.text = VoteContents.voteDatas[rand].text2;
        if(go.GetComponent<VoteTimer>().votetype  == VoteType.Weather)
            go.GetComponent<VoteTimer>().vote_T3.text = VoteContents.voteDatas[rand].text3;
        go.GetComponent<VoteTimer>().LimitTime = VoteContents.voteDatas[rand].lifeTime;

        go.transform.SetParent(VoteView.transform);
        go.transform.localScale = new Vector3(0.6f, 0.6f, 0);
    }

    public void CountDown()
    {
        voteCount--;
        if(voteCount <= 0)
            canvas.transform.GetChild(3).gameObject.SetActive(false);
    }
    public void Spawn_Rt()
    {
        foreach (var point in spawnPoints)
        {
                point.GetComponent<SpawnOBJ>().Spawn_Rt();
        }
        
    }
    public void Spawn_Mv()
    {
        foreach (var point in spawnPoints)
        {
            point.GetComponent<SpawnOBJ>().Spawn_Mv();
        }
    }

    public void ChageWeather(int idx)
    {
        switch (idx)
        {
            case 0:
                if (currWeather != varWeather.isSunny)
                {
                    WM.wNowClaer();
                    currWeather = varWeather.isSunny;
                }
                break;
            case 1:
                if (currWeather != varWeather.isRaining)
                {
                    WM.wRainingNow();
                    currWeather = varWeather.isRaining;
                }
                break;
            case 2:
            default:
                if (currWeather != varWeather.isSnowing)
                {
                    WM.wSnowingNow();
                    currWeather = varWeather.isSnowing;
                }
                break;
        }
    }
}