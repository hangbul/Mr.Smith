// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BeheFX/Additive_Helix_Move"
{
	Properties
	{
		_FXT_Helix_Arrow("FXT_Helix_Arrow", 2D) = "white" {}
		_Helix_Move("Helix_Move", Float) = 0
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,0)
		_Arrow_Pow("Arrow_Pow", Range( 1 , 10)) = 1
		_Arrow_Ins("Arrow_Ins", Range( 1 , 10)) = 1
		[Toggle(_CUSTOM_ON_ON)] _Custom_On("Custom_On", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _CUSTOM_ON_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _FXT_Helix_Arrow;
		uniform float4 _FXT_Helix_Arrow_ST;
		uniform float _Helix_Move;
		uniform float _Arrow_Pow;
		uniform float _Arrow_Ins;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_FXT_Helix_Arrow = i.uv_texcoord * _FXT_Helix_Arrow_ST.xy + _FXT_Helix_Arrow_ST.zw;
			#ifdef _CUSTOM_ON_ON
				float staticSwitch16 = i.uv_tex4coord.z;
			#else
				float staticSwitch16 = _Helix_Move;
			#endif
			float2 appendResult6 = (float2(staticSwitch16 , 0.0));
			o.Emission = ( ( _Tint_Color * ( pow( tex2D( _FXT_Helix_Arrow, (uv0_FXT_Helix_Arrow*1.0 + appendResult6) ).r , _Arrow_Pow ) * _Arrow_Ins ) ) * i.vertexColor ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ( ( 1.0 - i.uv_texcoord.x ) * i.uv_texcoord.x ) * 4.0 ) , 5.0 ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
0;0;1920;1019;2091.061;12.8222;1;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;15;-1709.13,393.4968;Float;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1689.891,300.2092;Float;False;Property;_Helix_Move;Helix_Move;2;0;Create;True;0;0;False;0;0;1.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;16;-1491.13,285.4968;Float;False;Property;_Custom_On;Custom_On;6;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1423.891,503.2092;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-1254.891,280.2092;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1379.341,609.2042;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1410.891,62.20912;Float;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;2;-1119.891,75.20912;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1118.041,581.9043;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-874.6451,46.68111;Float;True;Property;_FXT_Helix_Arrow;FXT_Helix_Arrow;1;0;Create;True;0;0;False;0;38454b5285704764cbf393d08b99df4f;38454b5285704764cbf393d08b99df4f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-935.1412,589.6043;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-813.3365,307.1043;Float;False;Property;_Arrow_Pow;Arrow_Pow;4;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-534.3365,312.1043;Float;False;Property;_Arrow_Ins;Arrow_Ins;5;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;7;-596.0623,62.0748;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-733.3412,590.2042;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-667.3024,845.1614;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-507.3023,593.1614;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-384.7,60.58142;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-413.9367,-123.8957;Float;False;Property;_Tint_Color;Tint_Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0.8301887,0.6651509,0.2075472,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;13;-127.3906,257.8045;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-150.7365,10.30429;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;-269.3023,597.1614;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;48.25001,521.1865;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;83.87744,4.151703;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;292.5,-48.1;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BeheFX/Additive_Helix_Move;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;1;4;0
WireConnection;16;0;15;3
WireConnection;6;0;16;0
WireConnection;6;1;5;0
WireConnection;2;0;3;0
WireConnection;2;2;6;0
WireConnection;18;0;17;1
WireConnection;1;1;2;0
WireConnection;19;0;18;0
WireConnection;19;1;17;1
WireConnection;7;0;1;1
WireConnection;7;1;12;0
WireConnection;20;0;19;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;8;0;7;0
WireConnection;8;1;11;0
WireConnection;9;0;10;0
WireConnection;9;1;8;0
WireConnection;23;0;21;0
WireConnection;24;0;13;4
WireConnection;24;1;23;0
WireConnection;14;0;9;0
WireConnection;14;1;13;0
WireConnection;0;2;14;0
WireConnection;0;9;24;0
ASEEND*/
//CHKSM=79AE36770EDF1B18C4CEFEB6D7C6DB456FB5D3E5