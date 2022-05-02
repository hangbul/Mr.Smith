// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BeheFX/Alphablend_Sword"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (0.2214756,0.3507767,0.745283,0)
		_Main_Ins("Main_Ins", Range( 1 , 10)) = 1
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Main_UPanner("Main_UPanner", Float) = 0
		_Main_VPanner("Main_VPanner", Float) = 0
		[HDR]_Emi_Color("Emi_Color", Color) = (0,0,0,0)
		_Emi_Offset("Emi_Offset", Range( -1 , 1)) = 0
		_Sword_Texture("Sword_Texture", 2D) = "white" {}
		_Sword_UOffset("Sword_UOffset", Range( -1 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 10)) = 1
		_Noise_Texture("Noise_Texture", 2D) = "bump" {}
		_Noise_UPanner("Noise_UPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0
		_Noise_Val("Noise_Val", Range( 0 , 1)) = 0
		_Dissolve_Texture("Dissolve_Texture", 2D) = "white" {}
		_Diss_UPanner("Diss_UPanner", Float) = 0
		_Emi_Ins("Emi_Ins", Range( 1 , 100)) = 1
		_Diss_VPanner("Diss_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _USE_CUSTOM_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
		};

		uniform float _Emi_Offset;
		uniform sampler2D _Main_Texture;
		uniform float _Main_UPanner;
		uniform float _Main_VPanner;
		uniform sampler2D _Noise_Texture;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float4 _Noise_Texture_ST;
		uniform float _Noise_Val;
		uniform float _Emi_Ins;
		uniform float4 _Emi_Color;
		uniform float4 _Tint_Color;
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform sampler2D _Sword_Texture;
		uniform float4 _Sword_Texture_ST;
		uniform float _Sword_UOffset;
		uniform float _Opacity;
		uniform sampler2D _Dissolve_Texture;
		uniform float _Diss_UPanner;
		uniform float _Diss_VPanner;
		uniform float4 _Dissolve_Texture_ST;
		uniform float _Dissolve;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			#ifdef _USE_CUSTOM_ON
				float staticSwitch92 = i.uv2_tex4coord2.z;
			#else
				float staticSwitch92 = _Emi_Offset;
			#endif
			float2 appendResult25 = (float2(_Main_UPanner , _Main_VPanner));
			float2 appendResult37 = (float2(_Noise_UPanner , _Noise_VPanner));
			float2 uv0_Noise_Texture = i.uv_texcoord * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			float2 panner34 = ( 1.0 * _Time.y * appendResult37 + uv0_Noise_Texture);
			float2 panner21 = ( 1.0 * _Time.y * appendResult25 + ( ( (UnpackNormal( tex2D( _Noise_Texture, panner34 ) )).xy * _Noise_Val ) + i.uv_texcoord ));
			float4 tex2DNode17 = tex2D( _Main_Texture, panner21 );
			#ifdef _USE_CUSTOM_ON
				float staticSwitch97 = i.uv2_tex4coord2.w;
			#else
				float staticSwitch97 = _Emi_Ins;
			#endif
			o.Emission = ( ( ( ( pow( ( saturate( ( ( 1.0 - i.uv_texcoord.x ) + staticSwitch92 ) ) * tex2DNode17.r ) , 2.0 ) * staticSwitch97 ) * _Emi_Color ) + ( _Tint_Color * ( pow( tex2DNode17.r , _Main_Pow ) * _Main_Ins ) ) ) * i.vertexColor ).rgb;
			float2 uv0_Sword_Texture = i.uv_texcoord * _Sword_Texture_ST.xy + _Sword_Texture_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch89 = i.uv2_tex4coord2.x;
			#else
				float staticSwitch89 = _Sword_UOffset;
			#endif
			float2 appendResult14 = (float2(staticSwitch89 , 0.0));
			float2 appendResult41 = (float2(_Diss_UPanner , _Diss_VPanner));
			float2 uv0_Dissolve_Texture = i.uv_texcoord * _Dissolve_Texture_ST.xy + _Dissolve_Texture_ST.zw;
			float2 panner43 = ( 1.0 * _Time.y * appendResult41 + uv0_Dissolve_Texture);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch91 = i.uv2_tex4coord2.y;
			#else
				float staticSwitch91 = _Dissolve;
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( ( tex2D( _Sword_Texture, (uv0_Sword_Texture*1.0 + appendResult14) ).r * _Opacity ) * saturate( ( tex2D( _Dissolve_Texture, panner43 ).r + staticSwitch91 ) ) ) * saturate( pow( ( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.x ) ) * 4.0 ) , 5.0 ) ) ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-5.599976;292.8;1920;653;1854.154;1003.881;1.21251;True;True
Node;AmplifyShaderEditor.CommentaryNode;67;-3540.819,-669.4136;Float;False;1460.201;445.4185;UV_Noise;9;35;36;33;37;34;27;32;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3490.819,-363.9658;Float;False;Property;_Noise_VPanner;Noise_VPanner;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3489.757,-442.5809;Float;False;Property;_Noise_UPanner;Noise_UPanner;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-3291.095,-423.4583;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-3418.96,-612.1292;Float;False;0;27;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;34;-3142.96,-565.1292;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;-2950.539,-619.4136;Float;True;Property;_Noise_Texture;Noise_Texture;11;0;Create;True;0;0;False;0;ca13f4c0cd8f4eb4fb22f7b62e6e0d7e;ca13f4c0cd8f4eb4fb22f7b62e6e0d7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;68;-2057.207,-668.7452;Float;False;1794.967;700.6252;Main;13;22;23;25;21;17;64;19;18;66;63;65;31;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2000.329,103.5263;Float;False;1369.936;411.8513;Sword;8;11;5;14;6;2;16;15;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;32;-2578.961,-617.1292;Float;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2002.795,550.5957;Float;False;1378.661;399.2952;Dissolve;10;41;43;42;39;40;38;45;44;46;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2664.831,-360.5015;Float;False;Property;_Noise_Val;Noise_Val;14;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1951.733,746.1441;Float;False;Property;_Diss_UPanner;Diss_UPanner;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;85;-2577.051,298.2759;Float;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;61;-2027.407,1018.33;Float;False;1438.574;524;Mask;7;51;53;54;55;56;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1970.975,-82.31213;Float;False;Property;_Main_VPanner;Main_VPanner;5;0;Create;True;0;0;False;0;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-2206.681,-1158.392;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-1952.795,824.7592;Float;False;Property;_Diss_VPanner;Diss_VPanner;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2381.339,-945.0148;Float;True;Property;_Emi_Offset;Emi_Offset;7;0;Create;True;0;0;False;0;0;-0.5176471;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1985.429,382.7404;Float;False;Property;_Sword_UOffset;Sword_UOffset;9;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2315.617,-477.9953;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2037.383,-423.7941;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1969.913,-160.9271;Float;False;Property;_Main_UPanner;Main_UPanner;4;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;92;-2050.784,-925.8712;Float;False;Property;_Use_Custom;Use_Custom;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1828.664,-526.9063;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1977.407,1149.688;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;41;-1753.071,765.2668;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1771.251,-141.8045;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;75;-1963.158,-1136.428;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;89;-1730.286,387.2646;Float;False;Property;_Use_Custom;Use_Custom;20;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-1877.936,600.5956;Float;False;0;38;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1521.363,382.3776;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1531.134,827.8908;Float;False;Property;_Dissolve;Dissolve;19;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1765.158,-1142.428;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;43;-1604.936,623.5956;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1803.722,158.344;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;21;-1642.705,-318.1573;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1733.056,1240.835;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-1317.126,618.3192;Float;True;Property;_Dissolve_Texture;Dissolve_Texture;15;0;Create;True;0;0;False;0;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;74;-1555.158,-1136.428;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-1521.132,160.4685;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;-1368.109,-324.2578;Float;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;False;0;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1498.035,1158.33;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;91;-1258.816,822.7501;Float;False;Property;_Use_Custom;Use_Custom;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1410.158,-1134.428;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1178.234,1396.19;Float;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1259.035,1159.33;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1319.293,-822.9932;Float;False;Property;_Emi_Ins;Emi_Ins;17;0;Create;True;0;0;False;0;1;12;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-992.134,622.8908;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1164.178,396.3132;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;False;0;1;6.89;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1190.51,153.5263;Float;True;Property;_Sword_Texture;Sword_Texture;8;0;Create;True;0;0;False;0;222487ca0da15c240b14f9edf6e79f20;222487ca0da15c240b14f9edf6e79f20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;-1322.152,-925.1918;Float;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1348.33,-84.12;Float;False;Property;_Main_Pow;Main_Pow;3;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-1021.674,1188.486;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;63;-1063.604,-313.0756;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-789.1338,632.8908;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;77;-1167.47,-1125.431;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-865.3937,185.4241;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1053.755,-91.31998;Float;False;Property;_Main_Ins;Main_Ins;2;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;97;-1050.186,-800.6543;Float;False;Property;_Use_Custom;Use_Custom;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-571.1979,190.735;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-992.9175,-533.1637;Float;False;Property;_Tint_Color;Tint_Color;1;1;[HDR];Create;True;0;0;False;0;0.2214756,0.3507767,0.745283,0;0.8627451,2.227451,3.215686,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;60;-786.8337,1186.399;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-830.7817,-309.9408;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-922.7336,-1141.755;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;-853.0042,-905.571;Float;False;Property;_Emi_Color;Emi_Color;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.870588,1.694118,0.5333334,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-676.4283,-1142.88;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-497.2396,-314.239;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-362.3546,190.3567;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-163.5586,190.8457;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;94;-251.2387,-542.9422;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-281.6639,-919.0668;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;62.29395,-751.5211;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-15.06164,-198.9413;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;223.1285,1.992219;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BeheFX/Alphablend_Sword;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;35;0
WireConnection;37;1;36;0
WireConnection;34;0;33;0
WireConnection;34;2;37;0
WireConnection;27;1;34;0
WireConnection;32;0;27;0
WireConnection;29;0;32;0
WireConnection;29;1;30;0
WireConnection;92;1;73;0
WireConnection;92;0;85;3
WireConnection;31;0;29;0
WireConnection;31;1;20;0
WireConnection;41;0;40;0
WireConnection;41;1;39;0
WireConnection;25;0;22;0
WireConnection;25;1;23;0
WireConnection;75;0;71;1
WireConnection;89;1;11;0
WireConnection;89;0;85;1
WireConnection;14;0;89;0
WireConnection;72;0;75;0
WireConnection;72;1;92;0
WireConnection;43;0;42;0
WireConnection;43;2;41;0
WireConnection;21;0;31;0
WireConnection;21;2;25;0
WireConnection;53;0;51;1
WireConnection;38;1;43;0
WireConnection;74;0;72;0
WireConnection;6;0;5;0
WireConnection;6;2;14;0
WireConnection;17;1;21;0
WireConnection;54;0;51;1
WireConnection;54;1;53;0
WireConnection;91;1;45;0
WireConnection;91;0;85;2
WireConnection;76;0;74;0
WireConnection;76;1;17;1
WireConnection;55;0;54;0
WireConnection;44;0;38;1
WireConnection;44;1;91;0
WireConnection;2;1;6;0
WireConnection;56;0;55;0
WireConnection;56;1;58;0
WireConnection;63;0;17;1
WireConnection;63;1;64;0
WireConnection;46;0;44;0
WireConnection;77;0;76;0
WireConnection;77;1;78;0
WireConnection;15;0;2;1
WireConnection;15;1;16;0
WireConnection;97;1;81;0
WireConnection;97;0;85;4
WireConnection;48;0;15;0
WireConnection;48;1;46;0
WireConnection;60;0;56;0
WireConnection;65;0;63;0
WireConnection;65;1;66;0
WireConnection;79;0;77;0
WireConnection;79;1;97;0
WireConnection;83;0;79;0
WireConnection;83;1;82;0
WireConnection;18;0;19;0
WireConnection;18;1;65;0
WireConnection;62;0;48;0
WireConnection;62;1;60;0
WireConnection;69;0;62;0
WireConnection;84;0;83;0
WireConnection;84;1;18;0
WireConnection;95;0;84;0
WireConnection;95;1;94;0
WireConnection;96;0;94;4
WireConnection;96;1;69;0
WireConnection;0;2;95;0
WireConnection;0;9;96;0
ASEEND*/
//CHKSM=83A719D9F50931E77E2AC7B15E7EEBB563DCEB61