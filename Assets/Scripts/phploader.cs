using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using UnityEditor.VersionControl;
using UnityEngine;
using UnityEngine.Networking;
using Random = System.Random;

public class phploader : MonoBehaviour
{
   public int DBCount;
   private string twitchID;
   private int userSkill;

   private void Start()
   {
      StartCoroutine(getDBCount());
      StartCoroutine(getUserSkill());
      StartCoroutine(getUserID());
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
            Debug.Log(data);
            DBCount = Convert.ToInt32(data);
         }
      }
   }

   
   //랜덤 넘버를 뽑기위한 함수
   int getRandomNumber()
   {
      Random rand = new Random();
      int result = rand.Next(1, DBCount);
      return result;
   }

   IEnumerator getUserSkill()
   {
      WWWForm form = new WWWForm();
      form.AddField ("UserNumberPost", getRandomNumber());

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
         }
      } 
   }
   
   IEnumerator getUserID()
   {
      WWWForm form = new WWWForm();
      form.AddField ("UserNumberPost", getRandomNumber());

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

}
