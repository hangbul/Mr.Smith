using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using UnityEditor.VersionControl;
using UnityEngine;
using UnityEngine.Networking;


public class phploader : MonoBehaviour
{
   private int DBCount;

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
}
