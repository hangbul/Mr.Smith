using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class EnenyStateUI : MonoBehaviour
{
    private Camera _mainCamera;
    private TMP_Text _text;
    private Enemy _targetEnemy;

    private void Awake()
    {
        _mainCamera = FindObjectOfType<Camera>();
        _text = GetComponent<TMP_Text>();
    }

    void Update()
    {
        transform.position = _mainCamera.WorldToScreenPoint(_targetEnemy.transform.position);
        _text.text = _targetEnemy.EnemyState.ToString();

    }

    public void SetEnemy(Enemy targetEnemy)
    {
        _targetEnemy = targetEnemy;
    }
}