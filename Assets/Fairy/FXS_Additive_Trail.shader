// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BeheFX/Additive_Trail"
{
	Properties
	{
		[HDR]_Gra_Color01("Gra_Color01", Color) = (0.7478451,3.68705,1.493568,0)
		[HDR]_Gra_Color02("Gra_Color02", Color) = (1.289894,1.191212,0.2372918,0)
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_Main_Tex_Speed("Main_Tex_Speed", Float) = 0.35
		_Noise_Tex_Speed("Noise_Tex_Speed", Float) = 0.35
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 4.705882
		_Main_Ins("Main_Ins", Range( 1 , 10)) = 3.647059
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Gra_Color01;
		uniform float4 _Gra_Color02;
		uniform sampler2D _Noise_Texture;
		uniform float _Noise_Tex_Speed;
		uniform float4 _Noise_Texture_ST;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform float _Main_Tex_Speed;
		uniform float _Main_Pow;
		uniform float _Main_Ins;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult3 = lerp( _Gra_Color01 , _Gra_Color02 , i.uv_texcoord.x);
			float2 appendResult32 = (float2(_Noise_Tex_Speed , 0.0));
			float2 uv0_Noise_Texture = i.uv_texcoord * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			float2 panner42 = ( 1.0 * _Time.y * appendResult32 + uv0_Noise_Texture);
			float2 uv0_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float2 appendResult16 = (float2(_Main_Tex_Speed , 0.0));
			float2 panner41 = ( 1.0 * _Time.y * appendResult16 + uv0_Main_Tex);
			float4 temp_cast_0 = (_Main_Pow).xxxx;
			float4 temp_output_36_0 = saturate( ( ( ( tex2D( _Noise_Texture, panner42 ).r - uv0_Main_Tex.x ) + ( 1.0 - uv0_Main_Tex.x ) ) * ( pow( tex2D( _Main_Tex, panner41 ) , temp_cast_0 ) * _Main_Ins ) ) );
			o.Emission = ( lerpResult3 * temp_output_36_0 ).rgb;
			o.Alpha = temp_output_36_0.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-5.599976;105.6;1920;887;3176.957;366.6126;1.673312;True;True
Node;AmplifyShaderEditor.RangedFloatNode;34;-3335.971,452.0172;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3363.071,360.81;Float;False;Property;_Noise_Tex_Speed;Noise_Tex_Speed;5;0;Create;True;0;0;False;0;0.35;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2701.184,1063.455;Float;False;Constant;_U;;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2729.184,984.4546;Float;False;Property;_Main_Tex_Speed;Main_Tex_Speed;4;0;Create;True;0;0;False;0;0.35;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3249.64,111.9118;Float;False;0;25;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;16;-2498.184,986.4546;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-3132.971,376.1072;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2648.184,786.4546;Float;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;41;-2370.099,855.4194;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;42;-2953.269,188.6388;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2025.766,740.1226;Float;False;Property;_Main_Pow;Main_Pow;7;0;Create;True;0;0;False;0;4.705882;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-2089.501,850.0295;Float;True;Property;_Main_Tex;Main_Tex;3;0;Create;True;0;0;False;0;567181d38137f7548b99dd81004d9232;567181d38137f7548b99dd81004d9232;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-2673.074,80.94119;Float;True;Property;_Noise_Texture;Noise_Texture;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;37;-1745.587,498.5334;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1763.407,740.6019;Float;False;Property;_Main_Ins;Main_Ins;8;0;Create;True;0;0;False;0;3.647059;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-2300.778,265.6136;Float;True;2;0;FLOAT;0.8;False;1;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-2294.896,511.1802;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1990.896,414.1802;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1517.536,502.4259;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1302.479,493.9984;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-2210.3,-536.7648;Float;False;Property;_Gra_Color02;Gra_Color02;2;1;[HDR];Create;True;0;0;False;0;1.289894,1.191212,0.2372918,0;3.531465,3.252233,0.5584643,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2223.681,-363.8481;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-2213.7,-708.1647;Float;False;Property;_Gra_Color01;Gra_Color01;1;1;[HDR];Create;True;0;0;False;0;0.7478451,3.68705,1.493568,0;0.4392157,3.403922,0.454902,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;-1013.14,450.1826;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;3;-1751.9,-389.9647;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1269.479,132.9965;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-685.55,258.4502;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BeheFX/Additive_Trail;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;0
WireConnection;16;1;20;0
WireConnection;32;0;35;0
WireConnection;32;1;34;0
WireConnection;41;0;17;0
WireConnection;41;2;16;0
WireConnection;42;0;30;0
WireConnection;42;2;32;0
WireConnection;9;1;41;0
WireConnection;25;1;42;0
WireConnection;37;0;9;0
WireConnection;37;1;39;0
WireConnection;22;0;25;1
WireConnection;22;1;17;1
WireConnection;28;0;17;1
WireConnection;29;0;22;0
WireConnection;29;1;28;0
WireConnection;38;0;37;0
WireConnection;38;1;40;0
WireConnection;23;0;29;0
WireConnection;23;1;38;0
WireConnection;36;0;23;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;5;1
WireConnection;24;0;3;0
WireConnection;24;1;36;0
WireConnection;0;2;24;0
WireConnection;0;9;36;0
ASEEND*/
//CHKSM=4BB5EA06F76B0BD5270933E487D8AB96B6385DDD