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
   private int userSkillLv;

   private void Start()
   {
      StartCoroutine(getDBCount());
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

   public void getUserSkill()
   {
      WWWForm form = new WWWForm();
      form.AddField ("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadSkill.php", form))
      {
         webRequest.SendWebRequest();

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
   
   public void getUserID()
   {
      WWWForm form = new WWWForm();
      form.AddField ("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadID.php", form))
      {
         webRequest.SendWebRequest();

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
   
  public void getUserSkillLv()
   {
      WWWForm form = new WWWForm();
      form.AddField ("UserNumberPost", getRandomNumber());

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadSkillLv.php", form))
      {
         webRequest.SendWebRequest();

         if (webRequest.isNetworkError || webRequest.isHttpError)
         {
            Debug.Log(webRequest.error);
         }
         else
         {
            string data = webRequest.downloadHandler.text;
            userSkillLv = Convert.ToInt32(data);
         }
      } 
   }

}
