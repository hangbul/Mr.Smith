// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BeheFX/Additive_Shcokwave"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Main_Color("Main_Color", Color) = (1,1,1,0)
		_Main_UPanner("Main_UPanner", Float) = 0
		_Main_VPanner("Main_VPanner", Float) = 0.5
		_Main_UVPow("Main_UVPow", Range( -10 , 10)) = 1
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Main_Ins("Main_Ins", Range( 1 , 20)) = 2.117647
		_Opacity("Opacity", Range( 0 , 10)) = 1.800658
		_Dissolve_Texture("Dissolve_Texture", 2D) = "white" {}
		_Diss_UPanner("Diss_UPanner", Float) = 0
		_Diss_VPanner("Diss_VPanner", Float) = 0.5
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		_Noise_Texture("Noise_Texture", 2D) = "bump" {}
		_Noise_Val("Noise_Val", Range( 0 , 1)) = 0.3515617
		_Noise_UPanner("Noise_UPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0.4
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		[KeywordEnum(UP,Down,Middle)] _Choice_Mask("Choice_Mask", Float) = 2
		_Mask_Range("Mask_Range", Range( 1 , 20)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _USE_CUSTOM_ON
		#pragma shader_feature _CHOICE_MASK_UP _CHOICE_MASK_DOWN _CHOICE_MASK_MIDDLE
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
		};

		uniform float4 _Main_Color;
		uniform sampler2D _Main_Texture;
		uniform float _Main_UPanner;
		uniform float _Main_VPanner;
		uniform sampler2D _Noise_Texture;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float _Noise_Val;
		uniform float4 _Main_Texture_ST;
		uniform float _Main_UVPow;
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform float _Opacity;
		uniform sampler2D _Dissolve_Texture;
		uniform float _Diss_UPanner;
		uniform float _Diss_VPanner;
		uniform float4 _Dissolve_Texture_ST;
		uniform float _Dissolve;
		uniform float _Mask_Range;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult9 = (float2(_Main_UPanner , _Main_VPanner));
			float2 appendResult43 = (float2(_Noise_UPanner , _Noise_VPanner));
			float2 panner38 = ( 1.0 * _Time.y * appendResult43 + i.uv_texcoord);
			float2 uv0_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch63 = i.uv2_tex4coord2.z;
			#else
				float staticSwitch63 = _Main_UVPow;
			#endif
			float2 appendResult56 = (float2(uv0_Main_Texture.x , pow( uv0_Main_Texture.y , staticSwitch63 )));
			float2 panner5 = ( 1.0 * _Time.y * appendResult9 + ( ( (UnpackNormal( tex2D( _Noise_Texture, panner38 ) )).xy * _Noise_Val ) + appendResult56 ));
			float4 tex2DNode3 = tex2D( _Main_Texture, panner5 );
			#ifdef _USE_CUSTOM_ON
				float staticSwitch62 = i.uv2_tex4coord2.x;
			#else
				float staticSwitch62 = _Main_Ins;
			#endif
			o.Emission = ( i.vertexColor * ( _Main_Color * ( pow( tex2DNode3.r , _Main_Pow ) * staticSwitch62 ) ) ).rgb;
			float2 appendResult53 = (float2(_Diss_UPanner , _Diss_VPanner));
			float2 uv0_Dissolve_Texture = i.uv_texcoord * _Dissolve_Texture_ST.xy + _Dissolve_Texture_ST.zw;
			float2 panner49 = ( 1.0 * _Time.y * appendResult53 + uv0_Dissolve_Texture);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch64 = i.uv2_tex4coord2.y;
			#else
				float staticSwitch64 = _Dissolve;
			#endif
			float2 temp_cast_1 = (0.01).xx;
			float2 uv_TexCoord14 = i.uv_texcoord + temp_cast_1;
			float temp_output_15_0 = ( uv_TexCoord14.y + 0.0 );
			float temp_output_16_0 = ( 1.0 - uv_TexCoord14.y );
			#if defined(_CHOICE_MASK_UP)
				float staticSwitch81 = saturate( pow( temp_output_15_0 , _Mask_Range ) );
			#elif defined(_CHOICE_MASK_DOWN)
				float staticSwitch81 = saturate( pow( temp_output_16_0 , _Mask_Range ) );
			#elif defined(_CHOICE_MASK_MIDDLE)
				float staticSwitch81 = saturate( pow( ( ( temp_output_15_0 * temp_output_16_0 ) * 4.0 ) , _Mask_Range ) );
			#else
				float staticSwitch81 = saturate( pow( ( ( temp_output_15_0 * temp_output_16_0 ) * 4.0 ) , _Mask_Range ) );
			#endif
			o.Alpha = ( i.vertexColor.a * ( ( ( tex2DNode3.r * _Opacity ) * saturate( ( tex2D( _Dissolve_Texture, panner49 ).r + staticSwitch64 ) ) ) * staticSwitch81 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-5.599976;144;1920;839;2318.74;32.11941;1.031703;True;True
Node;AmplifyShaderEditor.CommentaryNode;83;-2580.212,-511.1487;Float;False;1503.052;468.9232;Noise;9;39;38;34;37;35;36;40;43;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2530.212,-158.2255;Float;False;Property;_Noise_VPanner;Noise_VPanner;16;0;Create;True;0;0;False;0;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2527.212,-242.0662;Float;False;Property;_Noise_UPanner;Noise_UPanner;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-2302.212,-213.0662;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2428.159,-435.1487;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;86;-1905.387,-74.69126;Float;False;817.1549;497.6668;Texture 늘리기;5;55;57;56;4;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2031.844,1175.599;Float;False;240;214;찌꺼기 제거;1;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;38;-2136.159,-339.1488;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2033.871,320.3878;Float;False;Property;_Main_UVPow;Main_UVPow;5;0;Create;True;0;0;False;0;1;1.5;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;61;-120.5667,712.3365;Float;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;84;-1981.844,1225.599;Float;False;Constant;_Vector0;Vector 0;23;0;Create;True;0;0;False;0;0,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;63;-1765.639,319.537;Float;False;Property;_Use_Custom;Use_Custom;17;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-1950.158,-447.1487;Float;True;Property;_Noise_Texture;Noise_Texture;13;0;Create;True;0;0;False;0;c3b5d6c29a7e15a43878a0c45ef082e8;cea95a8877501cd4aa25c4cd4d8a3715;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1850.917,-24.69126;Float;True;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;74;-1757.225,923.5671;Float;False;1432.857;1095.616;Mask;15;14;16;15;17;18;22;19;27;20;25;26;21;72;71;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1722.461,436.5307;Float;False;1382.999;459.2526;Dissolve;10;51;52;53;50;49;44;45;47;46;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;35;-1621.158,-461.1487;Float;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1610.158,-259.1488;Float;False;Property;_Noise_Val;Noise_Val;14;0;Create;True;0;0;False;0;0.3515617;0.135;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1670.461,696.7529;Float;False;Property;_Diss_UPanner;Diss_UPanner;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1707.225,1189.424;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;57;-1560.111,129.5574;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1672.461,779.7831;Float;False;Property;_Diss_VPanner;Diss_VPanner;11;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1405.151,1039.565;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1393.008,1272.537;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1323.232,9.904382;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1454.461,705.7831;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1083.253,213.5132;Float;False;Property;_Main_UPanner;Main_UPanner;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-1608.4,529.9709;Float;False;0;44;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1312.158,-430.1487;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1085.253,295.5132;Float;False;Property;_Main_VPanner;Main_VPanner;4;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1165.943,1425.986;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1171.48,741.9439;Float;False;Property;_Dissolve;Dissolve;12;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;49;-1311.682,546.4554;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-989.2502,-76.7283;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-867.2531,221.5132;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1112.644,1150.11;Float;False;Property;_Mask_Range;Mask_Range;21;0;Create;True;0;0;False;0;1;8.3;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;-742.2531,42.51318;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;44;-1000.283,495.4496;Float;True;Property;_Dissolve_Texture;Dissolve_Texture;9;0;Create;True;0;0;False;0;c7d564bbc661feb448e7dcb86e2aa438;c7d564bbc661feb448e7dcb86e2aa438;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;64;-892.1978,733.3235;Float;False;Property;_Use_Custom;Use_Custom;17;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-961.9428,1432.986;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;20;-757.9281,1199.817;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-766.1986,973.5671;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-412.6913,-47.28172;Float;False;Property;_Main_Pow;Main_Pow;6;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-761.9428,1434.986;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-511.819,305.3546;Float;False;Property;_Opacity;Opacity;8;0;Create;True;0;0;False;0;1.800658;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-672.3362,497.1506;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-159.7345,39.37964;Float;False;Property;_Main_Ins;Main_Ins;7;0;Create;True;0;0;False;0;2.117647;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-514.4089,24.86535;Float;True;Property;_Main_Texture;Main_Texture;1;0;Create;True;0;0;False;0;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;26;-528.1228,1202.667;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;-522.3685,973.9324;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-537.4622,486.5307;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-146.4299,194.5689;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-535.7265,1448.652;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;10;-105.8219,-245.4051;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;62;160.14,107.4487;Float;False;Property;_Use_Custom;Use_Custom;17;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;81;-176.1356,1174.598;Float;False;Property;_Choice_Mask;Choice_Mask;20;0;Create;True;0;0;False;0;0;2;2;True;;KeywordEnum;3;UP;Down;Middle;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;68.63821,194.3317;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;171.7498,-354.7283;Float;False;Property;_Main_Color;Main_Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,0;3.433962,2.455734,0.7613029,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;170.1866,-99.28595;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;280.2051,203.9833;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;58;405.8914,-478.7422;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;401.7498,-170.7283;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;72;-1117.101,1738.715;Float;True;Property;_Mask_Texture;Mask_Texture;19;0;Create;True;0;0;False;0;edd433d00a571af4c99cb5b3620347b0;edd433d00a571af4c99cb5b3620347b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;614.8914,-371.7422;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;630.8914,5.257813;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-576.3827,1736.396;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;71;-803.754,1737.717;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1995.189,1005.552;Float;False;Property;_CullMode;CullMode;18;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;779.2941,-85.388;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BeheFX/Additive_Shcokwave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;True;65;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;76;-1167.101,1684.724;Float;False;788.7186;310.337;Texture Mask;0;;1,1,1,1;0;0
WireConnection;43;0;40;0
WireConnection;43;1;41;0
WireConnection;38;0;39;0
WireConnection;38;2;43;0
WireConnection;63;1;55;0
WireConnection;63;0;61;3
WireConnection;34;1;38;0
WireConnection;35;0;34;0
WireConnection;14;1;84;2
WireConnection;57;0;4;2
WireConnection;57;1;63;0
WireConnection;15;0;14;2
WireConnection;16;0;14;2
WireConnection;56;0;4;1
WireConnection;56;1;57;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;49;0;50;0
WireConnection;49;2;53;0
WireConnection;33;0;36;0
WireConnection;33;1;56;0
WireConnection;9;0;6;0
WireConnection;9;1;7;0
WireConnection;5;0;33;0
WireConnection;5;2;9;0
WireConnection;44;1;49;0
WireConnection;64;1;46;0
WireConnection;64;0;61;2
WireConnection;18;0;17;0
WireConnection;20;0;16;0
WireConnection;20;1;22;0
WireConnection;21;0;15;0
WireConnection;21;1;22;0
WireConnection;19;0;18;0
WireConnection;19;1;22;0
WireConnection;45;0;44;1
WireConnection;45;1;64;0
WireConnection;3;1;5;0
WireConnection;26;0;20;0
WireConnection;25;0;21;0
WireConnection;47;0;45;0
WireConnection;12;0;3;1
WireConnection;12;1;13;0
WireConnection;27;0;19;0
WireConnection;10;0;3;1
WireConnection;10;1;11;0
WireConnection;62;1;30;0
WireConnection;62;0;61;1
WireConnection;81;1;25;0
WireConnection;81;0;26;0
WireConnection;81;2;27;0
WireConnection;48;0;12;0
WireConnection;48;1;47;0
WireConnection;29;0;10;0
WireConnection;29;1;62;0
WireConnection;28;0;48;0
WireConnection;28;1;81;0
WireConnection;31;0;32;0
WireConnection;31;1;29;0
WireConnection;59;0;58;0
WireConnection;59;1;31;0
WireConnection;60;0;58;4
WireConnection;60;1;28;0
WireConnection;69;0;71;0
WireConnection;71;0;72;1
WireConnection;71;1;22;0
WireConnection;2;2;59;0
WireConnection;2;9;60;0
ASEEND*/
//CHKSM=2FE5B5BD93063701E60C421D7C26619682D235D4