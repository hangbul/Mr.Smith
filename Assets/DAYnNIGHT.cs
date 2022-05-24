using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.GlobalIllumination;
using RenderSettings = UnityEngine.RenderSettings;

public class DAYnNIGHT : MonoBehaviour
{
    [SerializeField] private float sPerTime;
    private bool inNight = false;
    
    [SerializeField] private float nightFogDensity;
    private float dayFogDensity;

    [SerializeField] private float fogDensityScale;
    private float currentFogDensity;

    [SerializeField] private float lightIntensityScale;
    public Light fairy;
    void Start()
    {
        dayFogDensity = RenderSettings.fogDensity;
    }

    void Update()
    {
        // 계속 태양을 X 축 중심으로 회전. 현실시간 1초에  0.1f * secondPerRealTimeSecond 각도만큼 회전
        transform.Rotate(Vector3.right, 0.1f * sPerTime * Time.deltaTime);

        if (transform.eulerAngles.x >= 170) // x 축 회전값 170 이상이면 밤
            inNight = true;
        else if (transform.eulerAngles.x <= 10)  // x 축 회전값 10 이하면 낮
            inNight = false;

        if (inNight)
        {
            if (currentFogDensity <= nightFogDensity)
            {
                currentFogDensity += 0.1f * fogDensityScale * Time.deltaTime;
                RenderSettings.fogDensity = currentFogDensity;
                fairy.intensity += 0.1f * lightIntensityScale * Time.deltaTime;
            }
        }
        else
        {
            if (currentFogDensity >= dayFogDensity)
            {
                currentFogDensity -= 0.1f * fogDensityScale * Time.deltaTime;
                RenderSettings.fogDensity = currentFogDensity;
                fairy.intensity -= 0.1f * lightIntensityScale * Time.deltaTime;

            }
        }
    }

}
