using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TownManager : MonoBehaviour
{

    void Start()
    {
        
    }

    public void GoGameScene()
    {
        SceneManager.LoadScene("GameScene");
    }
    public void GoAutioncene()
    {
        SceneManager.LoadScene("AuctionScene");
    }
    
}
