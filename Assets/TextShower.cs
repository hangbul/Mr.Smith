using System.Collections;
using UnityEngine;
using UnityEngine.UI;


public class TextShower : MonoBehaviour
{
    public GameObject chatView;
    public Camera camera;
    private Transform target;
    
    void Start () {
        target = GetComponent<Transform> ();
    }
    void Update () {
        Vector3 screenPos = camera.WorldToScreenPoint (target.position);
        chatView.transform.position = new Vector3(screenPos.x, screenPos.y , chatView.transform.position.z);
    }
}