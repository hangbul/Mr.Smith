using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using UnityEditor.VersionControl;
using UnityEngine;
using UnityEngine.Networking;

public class phploader : MonoBehaviour
{
   
   public class UserData
   {
      public string twitchID;
      public string twitchNickname;
      public int userNumber;
      public int point;
   }
   
   public class ResUserData
   {
      public List<UserData> UserDatas;
   }

   private void Start()
   {
      StartCoroutine(getSQLData());
   }

   IEnumerator getSQLData()
   {
      WWWForm form = new WWWForm();

      using (UnityWebRequest webRequest =
             UnityWebRequest.Post("http://ljch0407.cafe24.com/LoadMySQL.php", form))
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
         }
      }

   }
}
