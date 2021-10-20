using System.Collections;
using System.Collections.Generic;
using Assets.Scripts.InputSystem;
using UnityEngine;
using UnityEngine.AI;

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

    private float _idelTimer;
    private float _searchTimer;
    private float _loseTimer;
    private float _deadAnimationTimer;
    private int currentHitPoint;

    void Start()
    {
        _enemyState = EnemyState.Idle;
        //var stateGameObject = Instantiate(stateTextPrefab.gameObject, FindObjectOfType<Canvas>().transform);
        _player = GameObject.FindWithTag("Player");
        _navMeshAgent = GetComponent<NavMeshAgent>();
        currentHitPoint = maxhitPoint;

        //stateGameObject.GetComponent<EnenyStateUI>().SetEnemy(this);
        StartCoroutine(EnenmyStateMachine());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OntriggerEnter(Collider other)
    {
        //hit
    }

    IEnumerator EnenmyStateMachine()
    {
        while (true)
        {
            while (_enemyState == EnemyState.Idle)
            {
                if (_idelTimer > idleTime)
                {
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
                if (_searchTimer > searchTime)
                {
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
                if(IsPlayerInSight())
                    _navMeshAgent.destination = _player.transform.position;
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
                yield return null;
            }
            while (_enemyState == EnemyState.Dead)
            {
                if(_deadAnimationTimer > deadAnimationTime)
                {
                    Destroy(gameObject);
                }
                else
                {
                    _deadAnimationTimer += Time.deltaTime;
                    transform.localScale = new Vector3(1-_deadAnimationTimer, 1 - _deadAnimationTimer, 1 - _deadAnimationTimer);
                }
                yield return null;
            }
        }

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
