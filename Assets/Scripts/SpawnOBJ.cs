using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnOBJ : MonoBehaviour
{
    private RoomTemplates _roomTemplates;
    public List<GameObject> TargetObj;
    
    // Start is called before the first frame update
   

    public void Spawn_Mv()
    {
        GameObject enemy = Instantiate(TargetObj[0], new Vector3(transform.position.x, transform.position.y + 1.5f, transform.position.z), Quaternion.identity);
    }
    public void Spawn_Rt()
    {
        GameObject enemy = Instantiate(TargetObj[1], new Vector3(transform.position.x, transform.position.y, transform.position.z), Quaternion.identity);
    }
}
