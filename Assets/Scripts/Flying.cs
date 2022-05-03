using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flying : MonoBehaviour
{
    public float speed = 2f;
    public GameObject player;

    private Vector3 newPosition;
    
    void Start()
    {
        player = GameObject.Find("Player");
        transform.position = player.transform.position;
        PositionChange();
    }

    private void PositionChange()
    {
        newPosition = player.transform.position + new Vector3(Random.Range(-1.0f, 1.0f), 0, Random.Range(-1.0f, 1.0f));
    }

    void Update()
    {
        if ((Vector3.Distance(transform.position, player.transform.position) > 1.5))
        {
            PositionChange();
        }

        transform.position = Vector3.Lerp(transform.position, newPosition, Time.deltaTime * speed);
    }
}
