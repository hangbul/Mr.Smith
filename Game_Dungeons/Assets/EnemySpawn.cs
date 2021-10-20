using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawn : MonoBehaviour
{
    private RoomTemplates _roomTemplates;
    public GameObject EnenmyObj;
    
    // Start is called before the first frame update
    void Start()
    {
        _roomTemplates = GameObject.FindGameObjectWithTag("Rooms").GetComponent<RoomTemplates>();
    }

    void Update()
    {
        if (_roomTemplates.spawnedBoss)
        {
            GameObject enemy = Instantiate(EnenmyObj, new Vector3(transform.position.x, transform.position.y + 1.5f, transform.position.z), Quaternion.identity);
            Destroy(this);
        }
    }
}
