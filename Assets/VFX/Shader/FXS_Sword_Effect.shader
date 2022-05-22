// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Weapon_Shader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MetalicTex("MetalicTex", 2D) = "white" {}
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_Noise_Pow("Noise_Pow", Range( 1 , 10)) = 1
		_Noise_Ins("Noise_Ins", Range( 0 , 20)) = 0
		[HDR]_Noise_Color("Noise_Color", Color) = (0,0,0,0)
		_V_Panner("V_Panner", Float) = 0
		_U_Panner("U_Panner", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Noise_Tex;
		uniform float _U_Panner;
		uniform float _V_Panner;
		uniform float4 _Noise_Tex_ST;
		uniform float _Noise_Pow;
		uniform float _Noise_Ins;
		uniform float4 _Noise_Color;
		uniform sampler2D _MetalicTex;
		uniform float4 _MetalicTex_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color5 = IsGammaSpace() ? float4(0.5566038,0.5566038,0.5566038,0) : float4(0.2702231,0.2702231,0.2702231,0);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( color5 * tex2DNode3 ).rgb;
			float2 appendResult35 = (float2(_U_Panner , _V_Panner));
			float2 uv0_Noise_Tex = i.uv_texcoord * _Noise_Tex_ST.xy + _Noise_Tex_ST.zw;
			float2 panner29 = ( 1.0 * _Time.y * appendResult35 + uv0_Noise_Tex);
			float4 temp_cast_1 = (_Noise_Pow).xxxx;
			o.Emission = ( tex2DNode3.r * ( ( pow( tex2D( _Noise_Tex, panner29 ) , temp_cast_1 ) * _Noise_Ins ) * _Noise_Color ) ).rgb;
			float2 uv_MetalicTex = i.uv_texcoord * _MetalicTex_ST.xy + _MetalicTex_ST.zw;
			o.Metallic = ( float4( 0,0,0,0 ) * tex2D( _MetalicTex, uv_MetalicTex ) ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
115;222;1523;797;2024.434;13.13388;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;33;-1598.492,417.8244;Float;False;Property;_V_Panner;V_Panner;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1603.492,334.8244;Float;False;Property;_U_Panner;U_Panner;7;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-1438.492,353.8244;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1686.75,114.223;Float;False;0;18;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;29;-1465.492,129.8244;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1126.439,350.0547;Float;False;Property;_Noise_Pow;Noise_Pow;3;0;Create;True;0;0;False;0;1;1.83;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1285.153,101.8677;Float;True;Property;_Noise_Tex;Noise_Tex;2;0;Create;True;0;0;False;0;None;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-853.4383,347.4548;Float;False;Property;_Noise_Ins;Noise_Ins;4;0;Create;True;0;0;False;0;0;4.8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-933.266,100.4403;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;-570.0843,342.395;Float;False;Property;_Noise_Color;Noise_Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.284359,0.8506409,0.5495392,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-633.4714,88.75681;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;5;-709.8167,-685.1987;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;0.5566038,0.5566038,0.5566038,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-723.5811,-193.6748;Float;True;Property;_MetalicTex;MetalicTex;1;0;Create;True;0;0;False;0;None;1adef7643091f024a80cd7a04de19963;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-746.8167,-465.1987;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;8175bcb86de036941aaf8d3bcc7510d1;1adef7643091f024a80cd7a04de19963;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-425.7847,90.19453;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-402.4811,-217.0749;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-291.3616,53.37923;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-433.8167,-616.1987;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Weapon_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;32;0
WireConnection;35;1;33;0
WireConnection;29;0;26;0
WireConnection;29;2;35;0
WireConnection;18;1;29;0
WireConnection;21;0;18;0
WireConnection;21;1;23;0
WireConnection;25;0;21;0
WireConnection;25;1;24;0
WireConnection;28;0;25;0
WireConnection;28;1;27;0
WireConnection;14;1;12;0
WireConnection;20;0;3;1
WireConnection;20;1;28;0
WireConnection;6;0;5;0
WireConnection;6;1;3;0
WireConnection;2;0;6;0
WireConnection;2;2;20;0
WireConnection;2;3;14;0
ASEEND*/
//CHKSM=CC40FDD1463F64ACD503F84604D91AD1F07C4B2D