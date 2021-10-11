using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomTemplates : MonoBehaviour {

	
	public GameObject[] bottomRooms;
	public GameObject[] topRooms;
	public GameObject[] leftRooms;
	public GameObject[] rightRooms;

	public GameObject closedRoom;

	public List<GameObject> rooms;

	public float waitTime;
	private bool spawnedBoss;
	
	public GameObject boss;
	
	void Update(){

		if (waitTime <= 0 && spawnedBoss == false)
		{
			Vector3 bossPos = rooms[rooms.Count - 1].transform.position;
			bossPos.z = bossPos.z + 3.0f;
			Instantiate(boss, bossPos, Quaternion.identity);
			spawnedBoss = true;
		}
		else {
			waitTime -= Time.deltaTime;
		}

		
	}
}
