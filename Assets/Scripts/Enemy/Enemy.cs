using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using Assets.Scripts.InputSystem;
using UnityEngine;
using UnityEngine.AI;
using Random = UnityEngine.Random;

public class Enemy : MonoBehaviour
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
    private EnemyState _enemyState;
    private Vector3 currentRandomPos;
    private GameObject _player;
    private NavMeshAgent _navMeshAgent;
    private Animator anim;
    
    private float _idelTimer;
    private float _searchTimer;
    private float _loseTimer;
    private float _deadAnimationTimer;
    private int currentHitPoint;

    private bool Damaged = false;

    public int curHealth;
    public int maxHealth;
    public int AttackPoint;

    public GameObject[] items;
    public BoxCollider meleeArea;

    private Rigidbody rigid;
    private BoxCollider collider;
    private Material mat;
    
    

    private void Awake()
    {
        maxHealth = 30;
        curHealth = maxHealth;

        rigid = GetComponent<Rigidbody>();
        collider = GetComponent<BoxCollider>();
        mat = GetComponentInChildren<MeshRenderer>().material;
    }

    void Start()
    {
        _enemyState = EnemyState.Idle;
        //var stateGameObject = Instantiate(stateTextPrefab.gameObject, FindObjectOfType<Canvas>().transform);
        _player = GameObject.FindWithTag("Player");
        _navMeshAgent = GetComponent<NavMeshAgent>();
        currentHitPoint = maxhitPoint;
        anim = GetComponentInChildren<Animator>();

        //stateGameObject.GetComponent<EnenyStateUI>().SetEnemy(this);
        StartCoroutine(EnenmyStateMachine());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "MeleeWeapon")
        {
            Damaged = true;
            Weapon weapon = other.GetComponent<Weapon>();
            curHealth -= weapon.damage;
            Vector3 reactVec = -transform.forward;
            
            StartCoroutine(OnDamage(reactVec));
        }
        else if (other.tag == "bullet")
        {
            Damaged = true;
            Bullet bullet = other.GetComponent<Bullet>();
            curHealth -= bullet.damage;
            Vector3 reactVec = -transform.forward;
            Destroy(other.gameObject);
            StartCoroutine(OnDamage(reactVec));
        }

    }


    IEnumerator OnDamage(Vector3 reactVec)
    {
        mat.color = Color.red;
        yield return new WaitForSeconds(0.1f);

        if (curHealth > 0)
        {
            mat.color = Color.white;
            reactVec += Vector3.up;
            rigid.AddForce(reactVec * 200,ForceMode.Impulse);
        }
        else
        {
            mat.color = Color.gray;
            gameObject.layer = 9;

            reactVec += Vector3.up;
            rigid.AddForce(reactVec * 200,ForceMode.Impulse);
         
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
                
                if (_idelTimer > idleTime)
                {
                    anim.SetBool("isWalk", true);
                    _enemyState = EnemyState.Search;
                    _idelTimer = 0f;
                    currentRandomPos = new Vector3(Random.Range(transform.position.x - 5, transform.position.x + 5), 0, 
                        Random.Range(transform.position.z-5, transform.position.z + 5));
                }
                else
                {
                    _idelTimer += Time.deltaTime;
                    
                    // Idle 단계에서 핼항 것
                    // 예: Getcomponent<Animator>를 이용하는 등
                }

                yield return null;
            }
            while (_enemyState == EnemyState.Search)
            {
                if (curHealth <= 0)
                    _enemyState = EnemyState.Dead;
                
                if (_searchTimer > searchTime)
                {
                    anim.SetBool("isWalk", false);

                    _enemyState = EnemyState.Idle;
                    _searchTimer = 0f;
                }
                else
                {
                    _searchTimer += Time.deltaTime;
                    if (IsPlayerInSight())
                    {
                        _enemyState = EnemyState.Chase;
                        _searchTimer = 0f;
                    }
                    var from = transform.position;
                    var to =  currentRandomPos;
                    //transform.position = Vector3.Lerp(from,to, Time.deltaTime);
                    var from2 = transform.rotation;
                    var to2 = Quaternion.LookRotation(to - from);
                    transform.rotation = Quaternion.Lerp(from2, to2, Time.deltaTime * 10);
                }

                yield return null;
            }
            while (_enemyState == EnemyState.Chase)
            {
                if (curHealth <= 0)
                    _enemyState = EnemyState.Dead;

                if (Damaged)
                {
                    anim.SetBool("isWalk", false);
                    _enemyState = EnemyState.Idle;
                }

                if (IsPlayerInSight())
                {
                    _navMeshAgent.destination = _player.transform.position;
                    float targetRadius = 1.5f;
                    float targetRange = 3f;
                    RaycastHit[] rayHit = Physics.SphereCastAll(transform.position, targetRadius, transform.forward, targetRange, LayerMask.GetMask("Player"));
                    
                    if (rayHit.Length > 0 && _enemyState != EnemyState.Attack)
                    {
                        _enemyState = EnemyState.Attack;
                    }
                }
                else
                {
                    //losetimer
                    _loseTimer += Time.deltaTime;
                    if (_loseTimer > loseTime)
                    {
                        _enemyState = EnemyState.Search;
                        _loseTimer = 0f;
                    }               
                }
                yield return null;
            }
            while (_enemyState == EnemyState.Attack)
            {  
                anim.SetBool("isWalk", false);
                anim.SetBool("isAttack",true);
                yield return new WaitForSeconds(0.2f);
                meleeArea.enabled = true;

                yield return new WaitForSeconds(1f);
                meleeArea.enabled = false;

                yield return new WaitForSeconds(1f);
                anim.SetBool("isAttack",false);
                _enemyState = EnemyState.Idle;
            }
            while (_enemyState == EnemyState.Dead)
            {

               
                if(_deadAnimationTimer > deadAnimationTime)
                {
                    rigid.AddForce(-transform.forward * 200,ForceMode.Impulse);
                    anim.SetTrigger("doDie");
                    Destroy(gameObject);
                }
                else
                {
                    StartCoroutine("dropItems");
                    _deadAnimationTimer += Time.deltaTime;
                    transform.localScale = new Vector3(1-_deadAnimationTimer, 1 - _deadAnimationTimer, 1 - _deadAnimationTimer);
                }
                yield return null;
            }
        }

    }

    IEnumerator dropItems()
    {
        yield return new WaitForSeconds(0.77f);
        int randomitems = Random.Range(0, 3);
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
