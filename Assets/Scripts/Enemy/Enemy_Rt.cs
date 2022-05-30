using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using Assets.Scripts.InputSystem;
using UnityEngine;
using UnityEngine.AI;
using Random = UnityEngine.Random;
using UnityEngine.UI;


[Serializable]
public class Enemy_Rt : MonoBehaviour
{
    [SerializeField] private EnenyStateUI stateTextPrefab;

    [SerializeField] private float idleTime = 2f; //= 2M
    [SerializeField] private float searchTime = 4f;
    [SerializeField] private float loseTime = 2f;
    [SerializeField] private float deadAnimationTime = 2f;
    [SerializeField] private float sightAngle = 90f;
    [SerializeField] private float sightLength = 10f;
    [SerializeField] private int maxhitPoint = 2;

    public EnemyState EnemyState => _enemyState;
    public EnemyState _enemyState;
    private Vector3 currentRandomPos;
    private GameObject _player;
    private Animator anim;
    
    private float _idelTimer;
    private float _loseTimer;
    private float _deadAnimationTimer;
    private float rotationSpeed = 5;
    private int currentHitPoint;

    private bool Damaged = false;
    private bool AimingPlayer = false;

    public float curHealth;
    public float maxHealth;

    public GameObject[] items;
    public BoxCollider meleeArea;
    
    public GameObject bullet;
    public Transform bulletPos;

    private BoxCollider collider;
    private Material mat;

    public float distance;
    
    private EventManager _eventManager;
    
    public Slider m_Slider;                        
    public Image m_FillImage;                      
    public Color m_FullHealthColor = Color.green;  
    public Color m_ZeroHealthColor = Color.red;  

    

    private void Awake()
    {
        maxHealth = 30;
        curHealth = maxHealth;

        collider = GetComponent<BoxCollider>();
        //mat = GetComponentInChildren<MeshRenderer>().material;
        
        _eventManager = GameObject.Find("EventManager").GetComponent<EventManager>();
    }
    
    private void SetHealthUI()
    {
        m_Slider.value = curHealth;
        m_FillImage.color = Color.Lerp(m_ZeroHealthColor, m_FullHealthColor, curHealth / maxHealth);
    }


    void Start()
    {
        _enemyState = EnemyState.Idle;
        //var stateGameObject = Instantiate(stateTextPrefab.gameObject, FindObjectOfType<Canvas>().transform);
        _player = GameObject.FindWithTag("Player");
        currentHitPoint = maxhitPoint;
        anim = GetComponentInChildren<Animator>();

        //stateGameObject.GetComponent<EnenyStateUI>().SetEnemy(this);
        StartCoroutine(EnenmyStateMachine());
    }

    void Update()
    {
        distance = Vector3.Distance(transform.position, _player.transform.position);

        if (distance <= 10.0f)
        {
            var target_pos = _player.transform.position - transform.position;
            Vector3 target = new Vector3(target_pos.x, 0, target_pos.z); 
            var from = transform.rotation;
            var to = Quaternion.LookRotation(target);
            transform.rotation = Quaternion.Lerp(from, to, Time.deltaTime * rotationSpeed);
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "MeleeWeapon")
        {
            Damaged = true;
            Weapon weapon = other.GetComponent<Weapon>();

            if (_eventManager.CurWeatherReturn() == EventManager.varWeather.isSunny)
            {
                switch (_player.GetComponent<PlayerInfo>().playerElement)
                {
                    case PlayerElement.None:
                        curHealth -= weapon.damage;
                        break;
                    case PlayerElement.Fire:
                        curHealth -= weapon.damage * 0.8f;
                        break;
                    case PlayerElement.Ice:
                        curHealth -= weapon.damage * 1.4f;
                        break;
                    case PlayerElement.Lightning:
                        curHealth -= weapon.damage * 1.2f;
                        break;
                }
            }
            else if (_eventManager.CurWeatherReturn() == EventManager.varWeather.isRaining)
            {
                switch (_player.GetComponent<PlayerInfo>().playerElement)
                {
                    case PlayerElement.None:
                        curHealth -= weapon.damage;
                        break;
                    case PlayerElement.Fire:
                        curHealth -= weapon.damage * 0.5f;
                        break;
                    case PlayerElement.Ice:
                        curHealth -= weapon.damage * 1.2f;
                        break;
                    case PlayerElement.Lightning:
                        curHealth -= weapon.damage * 1.6f;
                        break;
                }
            }
            else if (_eventManager.CurWeatherReturn() == EventManager.varWeather.isSnowing)
            {
                switch (_player.GetComponent<PlayerInfo>().playerElement)
                {
                    case PlayerElement.None:
                        curHealth -= weapon.damage;
                        break;
                    case PlayerElement.Fire:
                        curHealth -= weapon.damage * 1.5f;
                        break;
                    case PlayerElement.Ice:
                        curHealth -= weapon.damage * 1.2f;
                        break;
                    case PlayerElement.Lightning:
                        curHealth -= weapon.damage * 1.2f;
                        break;
                }
            }
            SetHealthUI();
            StartCoroutine(OnDamage());
        }
        else if (other.tag == "bullet")
        {
            Damaged = true;
            Bullet bullet = other.GetComponent<Bullet>();
            curHealth -= bullet.damage;
            Vector3 reactVec = -transform.forward;
            Destroy(other.gameObject);
            StartCoroutine(OnDamage());
        }
    }

    IEnumerator OnDamage()
    {
        PlayerInfo player = GameObject.FindWithTag("Player").GetComponent<PlayerInfo>();
        
        if(player.playerElement == PlayerElement.None)
            mat.color = Color.red;
        else if(player.playerElement == PlayerElement.Fire)
            mat.color = Color.yellow;
        else if(player.playerElement == PlayerElement.Ice)
            mat.color = Color.blue;
        else if(player.playerElement == PlayerElement.Lightning)
            mat.color = Color.cyan;
        
        yield return new WaitForSeconds(0.1f);

        if (curHealth > 0)
        {
            mat.color = Color.white;
        }
        else
        {
            mat.color = Color.gray;
            gameObject.layer = 9;
            
            Destroy(gameObject,0.7f);
        }
    }

    IEnumerator EnenmyStateMachine()
    {
        while (true)
        {
            while (_enemyState == EnemyState.Idle)
            {
                if (curHealth <= 0)
                    _enemyState = EnemyState.Dead;

                else
                {
                    _idelTimer += Time.deltaTime;
                    if (distance <= 10.0f)
                    {
                        _enemyState = EnemyState.Attack;
                    }
                    // Idle 단계에서 핼항 것
                    // 예: Getcomponent<Animator>를 이용하는 등
                }

                yield return null;
            }

            while (_enemyState == EnemyState.Attack)
            {
                anim.SetTrigger("isAttack");
                yield return new WaitForSeconds(1f);

                GameObject instantBullet = Instantiate(bullet, bulletPos.position, bulletPos.rotation);
                Rigidbody bulletRigid = instantBullet.GetComponent<Rigidbody>();
                bulletRigid.velocity = bulletPos.forward * 20;

                _enemyState = EnemyState.Idle;

            }

            while (_enemyState == EnemyState.Dead)
            {
                if (_deadAnimationTimer > deadAnimationTime)
                {

                    anim.SetTrigger("doDie");
                    Destroy(gameObject);
                }
                else
                {
                    StartCoroutine("dropItems");
                    _deadAnimationTimer += Time.deltaTime;
                    transform.localScale = new Vector3(1 - _deadAnimationTimer, 1 - _deadAnimationTimer,
                        1 - _deadAnimationTimer);
                }

                yield return null;
            }
        }
    }


    IEnumerator dropItems()
    { 
        int randomitems = Random.Range(0, 3);
        yield return new WaitForSeconds(1.99f);
        Instantiate(items[randomitems], transform.position+new Vector3(0,2,0), Quaternion.identity);
    }
   



    private bool IsPlayerInSight()
    {
        // 시야각과 Raycasting
        var dir = (_player.transform.position - transform.position).normalized;
        var angle = Mathf.Acos(Vector3.Dot(transform.forward, dir)) * Mathf.Rad2Deg;

        if (angle > sightAngle)
        {
            if (Physics.Raycast(transform.position, dir, out var hit, sightLength))
            {
                var player = hit.collider.GetComponent<PlayerMovement>();
                if (player != null)
                    return true;
                else
                    return false;
            }
            else
                return false;
        }
        else
            return false;
    }

}
