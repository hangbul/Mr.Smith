using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SoundManager : MonoBehaviour
{
   public AudioSource musicSource;
   
   void Start()
   {
      musicSource.Stop();
      if (SceneManager.GetActiveScene().name == "IntroScene") 
         musicSource.PlayDelayed(4);
      else
         musicSource.Play();
   }
   
   
   public void SetmusicVolume(float volume)
   {
      musicSource.volume = volume;
   }
   
}
