// GENERATED AUTOMATICALLY FROM 'Assets/Scripts/InputSystem/PlayerControls.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @PlayerControls : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @PlayerControls()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""PlayerControls"",
    ""maps"": [
        {
            ""name"": ""GamePlayerMaps"",
            ""id"": ""e8641558-b7a7-43a1-a246-8954e173208f"",
            ""actions"": [
                {
                    ""name"": ""Movement"",
                    ""type"": ""Value"",
                    ""id"": ""4d5eef30-4be1-407e-99c5-aa43a25c1172"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Attack"",
                    ""type"": ""Button"",
                    ""id"": ""907dbcd5-620b-4414-a6b5-194d9ea9aa57"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""MousePosition"",
                    ""type"": ""PassThrough"",
                    ""id"": ""44892dc3-21fc-418f-891e-3e043729ab61"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Aiming"",
                    ""type"": ""Button"",
                    ""id"": ""c5ca5449-4993-4017-8de9-8af4df532ba2"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Dodge"",
                    ""type"": ""Button"",
                    ""id"": ""10dd2f24-4abb-4b89-9d1f-08bab625e8c9"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""c7a7e1d3-9dfd-4b10-80db-b9c7dab79040"",
                    ""path"": ""<Keyboard>/space"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Attack"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""KeyBoard"",
                    ""id"": ""f540a605-5c64-4a66-9f5c-b76e6cda75da"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""9d2cfd2d-4b8e-4687-a7e0-105cd2537f43"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""849422c5-7913-4ee3-9ce1-6b13cf115dd9"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""3e1372e3-9dee-4f67-8dde-43cf6662cbbb"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""94c5578f-47a3-4534-a2be-549c13d07eb4"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""2a18eea0-a91c-4445-b367-4153ac784e0d"",
                    ""path"": ""<Mouse>/position"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""MousePosition"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""41e5299d-ba1e-4f37-a234-4cb28653f55e"",
                    ""path"": ""<Mouse>/leftButton"",
                    ""interactions"": ""Hold"",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Aiming"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f2e28f84-b0fe-4c6a-8284-36e21d8a5165"",
                    ""path"": ""<Keyboard>/LeftShift"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": ""MainControlScheme"",
                    ""action"": ""Dodge"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": [
        {
            ""name"": ""MainControlScheme"",
            ""bindingGroup"": ""MainControlScheme"",
            ""devices"": [
                {
                    ""devicePath"": ""<Keyboard>"",
                    ""isOptional"": false,
                    ""isOR"": false
                },
                {
                    ""devicePath"": ""<Mouse>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        }
    ]
}");
        // GamePlayerMaps
        m_GamePlayerMaps = asset.FindActionMap("GamePlayerMaps", throwIfNotFound: true);
        m_GamePlayerMaps_Movement = m_GamePlayerMaps.FindAction("Movement", throwIfNotFound: true);
        m_GamePlayerMaps_Attack = m_GamePlayerMaps.FindAction("Attack", throwIfNotFound: true);
        m_GamePlayerMaps_MousePosition = m_GamePlayerMaps.FindAction("MousePosition", throwIfNotFound: true);
        m_GamePlayerMaps_Aiming = m_GamePlayerMaps.FindAction("Aiming", throwIfNotFound: true);
        m_GamePlayerMaps_Dodge = m_GamePlayerMaps.FindAction("Dodge", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // GamePlayerMaps
    private readonly InputActionMap m_GamePlayerMaps;
    private IGamePlayerMapsActions m_GamePlayerMapsActionsCallbackInterface;
    private readonly InputAction m_GamePlayerMaps_Movement;
    private readonly InputAction m_GamePlayerMaps_Attack;
    private readonly InputAction m_GamePlayerMaps_MousePosition;
    private readonly InputAction m_GamePlayerMaps_Aiming;
    private readonly InputAction m_GamePlayerMaps_Dodge;
    public struct GamePlayerMapsActions
    {
        private @PlayerControls m_Wrapper;
        public GamePlayerMapsActions(@PlayerControls wrapper) { m_Wrapper = wrapper; }
        public InputAction @Movement => m_Wrapper.m_GamePlayerMaps_Movement;
        public InputAction @Attack => m_Wrapper.m_GamePlayerMaps_Attack;
        public InputAction @MousePosition => m_Wrapper.m_GamePlayerMaps_MousePosition;
        public InputAction @Aiming => m_Wrapper.m_GamePlayerMaps_Aiming;
        public InputAction @Dodge => m_Wrapper.m_GamePlayerMaps_Dodge;
        public InputActionMap Get() { return m_Wrapper.m_GamePlayerMaps; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(GamePlayerMapsActions set) { return set.Get(); }
        public void SetCallbacks(IGamePlayerMapsActions instance)
        {
            if (m_Wrapper.m_GamePlayerMapsActionsCallbackInterface != null)
            {
                @Movement.started -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMovement;
                @Movement.performed -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMovement;
                @Movement.canceled -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMovement;
                @Attack.started -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAttack;
                @Attack.performed -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAttack;
                @Attack.canceled -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAttack;
                @MousePosition.started -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMousePosition;
                @MousePosition.performed -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMousePosition;
                @MousePosition.canceled -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnMousePosition;
                @Aiming.started -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAiming;
                @Aiming.performed -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAiming;
                @Aiming.canceled -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnAiming;
                @Dodge.started -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnDodge;
                @Dodge.performed -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnDodge;
                @Dodge.canceled -= m_Wrapper.m_GamePlayerMapsActionsCallbackInterface.OnDodge;
            }
            m_Wrapper.m_GamePlayerMapsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Movement.started += instance.OnMovement;
                @Movement.performed += instance.OnMovement;
                @Movement.canceled += instance.OnMovement;
                @Attack.started += instance.OnAttack;
                @Attack.performed += instance.OnAttack;
                @Attack.canceled += instance.OnAttack;
                @MousePosition.started += instance.OnMousePosition;
                @MousePosition.performed += instance.OnMousePosition;
                @MousePosition.canceled += instance.OnMousePosition;
                @Aiming.started += instance.OnAiming;
                @Aiming.performed += instance.OnAiming;
                @Aiming.canceled += instance.OnAiming;
                @Dodge.started += instance.OnDodge;
                @Dodge.performed += instance.OnDodge;
                @Dodge.canceled += instance.OnDodge;
            }
        }
    }
    public GamePlayerMapsActions @GamePlayerMaps => new GamePlayerMapsActions(this);
    private int m_MainControlSchemeSchemeIndex = -1;
    public InputControlScheme MainControlSchemeScheme
    {
        get
        {
            if (m_MainControlSchemeSchemeIndex == -1) m_MainControlSchemeSchemeIndex = asset.FindControlSchemeIndex("MainControlScheme");
            return asset.controlSchemes[m_MainControlSchemeSchemeIndex];
        }
    }
    public interface IGamePlayerMapsActions
    {
        void OnMovement(InputAction.CallbackContext context);
        void OnAttack(InputAction.CallbackContext context);
        void OnMousePosition(InputAction.CallbackContext context);
        void OnAiming(InputAction.CallbackContext context);
        void OnDodge(InputAction.CallbackContext context);
    }
}
