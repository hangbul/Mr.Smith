using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using Unity.VisualScripting;
using UnityEditor.VersionControl;
using UnityEngine;
using UnityEngine.Networking;
using Random = System.Random;

public class phploader : MonoBehaviour
{
   public int DBCount;
   private string twitchID;
   public int userSkill;
   public int userSkillLv;

   private void Start()
   {
      StartCoroutine(getDBCount());
      StartCoroutine(getUserSkill());
      StartCoroutine(getUserSkillLv());
      StartCoroutine(getUserID());
   }

   private void Update()
   {
       //Refresh();
   }

   //DB전체 count 받아옴
   IEnumerator getDBCount()
   {
      WWWForm form = new WWWForm();

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/DBCountLoad.php", form))
      {
         yield return webRequest.SendWebRequest();

         if (webRequest.isNetworkError || webRequest.isHttpError)
         {
            Debug.Log(webRequest.error);
         }
         else
         {
            string data = webRequest.downloadHandler.text;
            Debug.Log("DBcount : " + data);
            DBCount = Convert.ToInt32(data);
         }
      }
   }


   //랜덤 넘버를 뽑기위한 함수
   int getRandomNumber()
   {
      int result = UnityEngine.Random.Range(1, DBCount);
      return result;
   }

   IEnumerator getUserSkill()
   {
      WWWForm form = new WWWForm();
      form.AddField("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadSkill.php", form))
      {
         yield return webRequest.SendWebRequest();

         if (webRequest.isNetworkError || webRequest.isHttpError)
         {
            Debug.Log(webRequest.error);
         }
         else
         {
            string data = webRequest.downloadHandler.text;
            userSkill = Convert.ToInt32(data);
            Debug.Log("UserSkill : " + userSkill);
         }
      }
   }

   IEnumerator getUserID()
   {
      WWWForm form = new WWWForm();
      form.AddField("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadID.php", form))
      {
         yield return webRequest.SendWebRequest();

         if (webRequest.isNetworkError || webRequest.isHttpError)
         {
            Debug.Log(webRequest.error);
         }
         else
         {
            string data = webRequest.downloadHandler.text;
            twitchID = data.ToString();
         }
      }
   }

   IEnumerator getUserSkillLv()
   {
      WWWForm form = new WWWForm();
      form.AddField("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadSkillLv.php", form))
      {
         yield return webRequest.SendWebRequest();

         if (webRequest.isNetworkError || webRequest.isHttpError)
         {
            Debug.Log(webRequest.error);
         }
         else
         {
            string data = webRequest.downloadHandler.text;
            userSkillLv = Convert.ToInt32(data);
            Debug.Log("UserSkillLV : "+ userSkillLv);
         }
      }
   }

   public void Refresh()
   {
      StopCoroutine(getDBCount());
      StopCoroutine(getUserSkill());
      StopCoroutine(getUserSkillLv());
      StopCoroutine(getUserID());
      
      StartCoroutine(getDBCount());
      StartCoroutine(getUserSkill());
      StartCoroutine(getUserSkillLv());
      StartCoroutine(getUserID());
   }

   public int getSkill()
  {
     return userSkill;
  }

  public int getSkillLv()
  {
     return userSkillLv;
  }
  
}
