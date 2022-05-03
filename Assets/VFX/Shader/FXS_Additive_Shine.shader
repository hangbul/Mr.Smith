// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BeheFX/Additive_Shine"
{
	Properties
	{
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,0)
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Noise_UPanner("Noise_UPanner", Float) = -0.16
		_Noise_VPanner("Noise_VPanner", Float) = 0
		_Mask_Range_UP("Mask_Range_UP", Float) = 1
		_Mask_Range_Down("Mask_Range_Down", Float) = 1.6
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Tint_Color;
		uniform float _Mask_Range_Down;
		uniform float _Mask_Range_UP;
		uniform sampler2D _Noise_Texture;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float4 _Noise_Texture_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult30 = (float2(_Noise_UPanner , _Noise_VPanner));
			float2 uv0_Noise_Texture = i.uv_texcoord * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			float2 panner26 = ( 1.0 * _Time.y * appendResult30 + uv0_Noise_Texture);
			o.Emission = ( ( ( _Tint_Color * ( saturate( ( pow( i.uv_texcoord.x , _Mask_Range_Down ) * 45.0 ) ) * ( saturate( pow( ( 1.0 - i.uv_texcoord.x ) , _Mask_Range_UP ) ) * ( pow( ( 1.0 - abs( ( i.uv_texcoord.y - 0.5 ) ) ) , 8.0 ) * 4.0 ) ) ) ) * tex2D( _Noise_Texture, panner26 ) ) * i.vertexColor ).rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
0;0;1920;1019;1977.844;787.8975;1.112806;True;True
Node;AmplifyShaderEditor.RangedFloatNode;3;-1917.943,227.0083;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2012.053,-170.6796;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-1705.232,-70.78676;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;4;-1451.352,-69.41436;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1319.609,222.8915;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1548.782,-159.9872;Float;False;Property;_Mask_Range_Down;Mask_Range_Down;6;0;Create;True;0;0;False;0;1.6;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-1293.535,-66.66965;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1255.13,-441.5854;Float;False;Property;_Mask_Range_UP;Mask_Range_UP;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-1413.609,-655.9821;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-1325.099,-356.2303;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;8;-1120.622,-65.29733;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1235.893,-140.7728;Float;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;False;0;45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1117.877,220.1467;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;-1058.911,-658.3849;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;-814.9614,-656.586;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-963.3217,530.0942;Float;False;Property;_Noise_VPanner;Noise_VPanner;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1067.102,-352.1131;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-963.7067,443.4612;Float;False;Property;_Noise_UPanner;Noise_UPanner;3;0;Create;True;0;0;False;0;-0.16;-0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-880.4645,-63.92498;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-780.7776,472.1832;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;19;-842.0403,-346.6238;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-647.1683,-142.1471;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-908.8232,218.3181;Float;False;0;25;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-552.8583,-499.5759;Float;False;Property;_Tint_Color;Tint_Color;1;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-424.7584,-158.6696;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-654.1002,225.3449;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-296.614,-397.5935;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;25;-446.2399,196.3735;Float;True;Property;_Noise_Texture;Noise_Texture;2;0;Create;True;0;0;False;0;8d21b35fab1359d4aa689ddf302e1b01;ed92731307059fd4fa0510d6b97bce10;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-83.99167,-29.34645;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;23;140.9688,19.20937;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;287.4066,-245.315;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;585.1278,-178.3057;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BeheFX/Additive_Shine;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;2
WireConnection;2;1;3;0
WireConnection;4;0;2;0
WireConnection;7;0;4;0
WireConnection;13;0;1;1
WireConnection;14;0;1;1
WireConnection;14;1;15;0
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;32;0;13;0
WireConnection;32;1;33;0
WireConnection;35;0;32;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;9;0;8;0
WireConnection;9;1;11;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;19;0;16;0
WireConnection;12;0;35;0
WireConnection;12;1;9;0
WireConnection;20;0;19;0
WireConnection;20;1;12;0
WireConnection;26;0;27;0
WireConnection;26;2;30;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;25;1;26;0
WireConnection;31;0;22;0
WireConnection;31;1;25;0
WireConnection;24;0;31;0
WireConnection;24;1;23;0
WireConnection;0;2;24;0
WireConnection;0;9;23;4
ASEEND*/
//CHKSM=6F44ADBBAFCB656DA01CBF93104A738DA4D447A9