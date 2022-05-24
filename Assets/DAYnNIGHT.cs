using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.GlobalIllumination;
using RenderSettings = UnityEngine.RenderSettings;

public class DAYnNIGHT : MonoBehaviour
{
    [SerializeField] public float sPerTime;
    private bool inNight = false;
    
    [SerializeField] private float nightFogDensity;
    private float dayFogDensity;

    [SerializeField] private float fogDensityScale;
    private float maxFogDensity = 0.05f;
    public float currentFogDensity;

    [SerializeField] private float lightIntensityScale;
    [SerializeField] private float maxlight;
    public Light fairy;
    private EventManager _eventManager;

    void Start()
    {
        _eventManager = GameObject.Find("EventManager").GetComponent<EventManager>();
        dayFogDensity = RenderSettings.fogDensity;
    }

    void Update()
    {
        transform.Rotate(Vector3.right, 0.1f * sPerTime * Time.deltaTime);

        if (transform.eulerAngles.x >= 170) // x 축 회전값 170 이상이면 밤
        {
            inNight = true;
            _eventManager.isNight = inNight;
        }
        else if (transform.eulerAngles.x <= 10) // x 축 회전값 10 이하면 낮
        {
            inNight = false;
            _eventManager.isNight = inNight;
        }

        if (inNight)
        {
            if (currentFogDensity <= nightFogDensity && currentFogDensity <= maxFogDensity )
            {
                currentFogDensity += 0.1f * fogDensityScale * Time.deltaTime;
                RenderSettings.fogDensity = currentFogDensity;
            }
            if(fairy.intensity <= maxlight)
                fairy.intensity += 0.1f * lightIntensityScale * Time.deltaTime;
        }
        else
        {
            if (currentFogDensity >= dayFogDensity)
            {
                currentFogDensity -= 0.1f * fogDensityScale * Time.deltaTime;
                RenderSettings.fogDensity = currentFogDensity;
            }
            if(fairy.intensity >= 0)
                fairy.intensity -= 0.1f * lightIntensityScale * Time.deltaTime;
        }
    }
    
}
