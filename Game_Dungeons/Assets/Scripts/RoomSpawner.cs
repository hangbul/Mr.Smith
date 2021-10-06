using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;

public class RoomSpawner : MonoBehaviour
{
    public int opeingDirection;
    // 1-> bottom door
    // 2-> top door
    // 3-> left door
    // 4-> right door

    private RoomTemplates templates;
    private int rand;
    public bool spawned = false;

    public float waitTime = 4f;
    
    void Start()
    {
        Destroy(gameObject, waitTime);
        templates = GameObject.FindGameObjectWithTag("Rooms").GetComponent<RoomTemplates>();
        Invoke("Spawn", 0.1f);
    }
    
    
    void Spawn()
    {
        if (spawned == false)
        {
            if (opeingDirection == 1)
            {
                //bottom
                rand = Random.Range(0, templates.bottomRooms.Length);
                Instantiate(templates.bottomRooms[rand], transform.position,
                    templates.bottomRooms[rand].transform.rotation);
            }
            else if (opeingDirection == 2)
            {
                //top
                rand = Random.Range(0, templates.topRooms.Length);
                Instantiate(templates.topRooms[rand], transform.position, templates.topRooms[rand].transform.rotation);
            }
            else if (opeingDirection == 3)
            {
                //left
                rand = Random.Range(0, templates.leftRooms.Length);
                Instantiate(templates.leftRooms[rand], transform.position,
                    templates.leftRooms[rand].transform.rotation);
            }
            else if (opeingDirection == 4)
            {
                //right
                rand = Random.Range(0, templates.rightRooms.Length);
                Instantiate(templates.rightRooms[rand], transform.position,
                    templates.rightRooms[rand].transform.rotation);
            }

            spawned = true;
        }
        
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("SpawnPoint"))
        {
            if (other.GetComponent<RoomSpawner>().spawned == false && spawned == false)
            {
                Instantiate(templates.closedRooms, transform.position, Quaternion.identity);
                Destroy(gameObject);
            }
            spawned = true;
        }
    }
}
