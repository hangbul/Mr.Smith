using UnityEngine;
using System.Collections;
 
public class Flying : MonoBehaviour
{
    public float speed = 2f;
    public GameObject player;

    Vector3 newPosition;
 
    void Start ()
    {
        transform.position = player.transform.position;
        PositionChange();
    }
 
    void PositionChange()
    {
        newPosition = player.transform.position + new Vector3( Random.Range(-1.0f, 1.0f), 0f, Random.Range(-1.0f, 1.0f));
    }
   
    void Update ()
    {
        if((Vector3.Distance(transform.position, player.transform.position) > 1.5) )
            PositionChange();
        
        transform.position=Vector3.Lerp(transform.position,newPosition,Time.deltaTime*speed);
 
    }
 
}