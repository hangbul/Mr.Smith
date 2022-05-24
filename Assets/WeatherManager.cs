using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class WeatherManager : MonoBehaviour
{
    private Transform _offset;
    private Camera cam;

    public DAYnNIGHT DnN;

    public List<Transform> FXPs;
    private ParticleSystem currFXP = null;
    private ParticleSystem.EmissionModule _emissionModule;
    [SerializeField] private float maxFXP_EmissionRate;
    [SerializeField] private float emissionScale;
    private float emission_rate = 0;

    public enum weather
    {
        isRaining,
        isSnowing,
        isSunny
    }

    private weather currWeather = weather.isSunny;
    public float changeTime = 0f;

    void Awake()
    {
        cam = Camera.main;
        ;
        foreach (var wFXP in FXPs)
        {
            currFXP = wFXP.GetComponent<ParticleSystem>();
            _emissionModule = currFXP.emission;
            _emissionModule.enabled = false;
        }


    }

    void Update()
    {
        this.transform.position = cam.transform.position;

        if (currWeather != weather.isSunny)
        {
            DnN.maxFogDensity = 0.02f;
            if (emission_rate <= maxFXP_EmissionRate)
            {
                emission_rate += Time.deltaTime * 0.1f * emissionScale;
                _emissionModule.rate = emission_rate;
            }

            if (changeTime < 0)
            {
                DnN.sPerTime = 0.0f;
                changeTime = 0;
            }
        }
        else
        {
            if (changeTime < 0)
            {
                DnN.maxFogDensity = 0.05f;
                DnN.sPerTime = 5.0f;
                DnN.maxlight = 20.0f;
                changeTime = 0;
            }
        }

        if (changeTime > 0)
        {
            changeTime -= Time.deltaTime;
        }
    }


    public void wRainingNow()
    {
        if (currWeather != weather.isRaining)
        {
            ChangeWeather(0);
            currWeather = weather.isRaining;
        }
    }


    public void wSnowingNow()
    {
        if (currWeather != weather.isSnowing)
        {
            ChangeWeather(1);
            currWeather = weather.isSnowing;
        }
    }

    public void wNowClaer()
    {
        if (currWeather != weather.isSunny)
        {
            DnN.sPerTime = 200.0f;
            
            changeTime = 10.0f;
            _emissionModule.enabled = false;
            _emissionModule.rate = 0;
            currWeather = weather.isSunny;
        }
    }

    public void ChangeWeather(int idx)
    {
        if (currWeather == weather.isSunny)
        {
            changeTime = 10.0f;
            if (!DnN.inNight)
            {
                DnN.sPerTime = 100.0f;
            }
            DnN.maxlight = 10.0f;
        }

        _emissionModule.enabled = false;
        _emissionModule.rate = 0;
        currFXP = FXPs[idx].GetComponent<ParticleSystem>();
        _emissionModule = currFXP.emission;
        _emissionModule.enabled = true;
    }
}
