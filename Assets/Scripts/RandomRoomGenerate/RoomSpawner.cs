﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Debug = System.Diagnostics.Debug;

public class RoomSpawner : MonoBehaviour
{
	public int openingDirection;
	// 1 --> need bottom door
	// 2 --> need top door
	// 3 --> need left door
	// 4 --> need right door


	private RoomTemplates templates;
	private int rand;
	public bool spawned = false;
	
	public float waitTime = 5f;

	
	void Start(){
		Destroy(gameObject, waitTime);
		templates = GameObject.FindGameObjectWithTag("Rooms").GetComponent<RoomTemplates>();
		Invoke("Spawn", 0.5f);
	}


	void Spawn(){
		if(spawned == false){
			if(openingDirection == 1){
				rand = Random.Range(0, templates.bottomRooms.Length);
				Instantiate(templates.bottomRooms[rand], transform.position, templates.bottomRooms[rand].transform.rotation);
			} else if(openingDirection == 2){
				rand = Random.Range(0, templates.topRooms.Length);
				Instantiate(templates.topRooms[rand], transform.position, templates.topRooms[rand].transform.rotation);
			} else if(openingDirection == 3){
				rand = Random.Range(0, templates.leftRooms.Length);
				Instantiate(templates.leftRooms[rand], transform.position, templates.leftRooms[rand].transform.rotation);
			} else if(openingDirection == 4){
				rand = Random.Range(0, templates.rightRooms.Length);
				Instantiate(templates.rightRooms[rand], transform.position, templates.rightRooms[rand].transform.rotation);
			}
			spawned = true;
		}
	}

	void OnTriggerEnter(Collider other){
		if(other.CompareTag("SpawnPoint")){
			Debug.Assert(other != null, nameof(other) + " != null");
			if(other.GetComponent<RoomSpawner>().spawned == false && spawned == false)
			{
				Instantiate(templates.closedRoom, transform.position, Quaternion.identity);
				Destroy(gameObject);
			} 
			spawned = true;
		}
	}
}