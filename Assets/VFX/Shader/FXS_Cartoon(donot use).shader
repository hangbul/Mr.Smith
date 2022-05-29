// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon_shaded"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Albedo("Albedo", 2D) = "white" {}
		_RimOffset("Rim Offset", Float) = 0
		_Tint_Color("Tint_Color", Color) = (0,0,0,0)
		_RimTint("Rim Tint", Color) = (0.4963955,0.838906,0.9150943,0)
		_RimPow("Rim Pow", Range( 0 , 1)) = 0.4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		uniform half4 _ASEOutlineColor;
		uniform half _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _RimOffset;
		uniform float _RimPow;
		uniform float4 _RimTint;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo45 = ( _Tint_Color * tex2D( _Albedo, uv_Albedo ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 normal40 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult18 = dot( normalize( (WorldNormalVector( i , normal40 )) ) , ase_worldlightDir );
			float normal_lightdir29 = dotResult18;
			float2 temp_cast_0 = ((normal_lightdir29*0.5 + 0.5)).xx;
			float4 shadow35 = ( Albedo45 * tex2D( _ToonRamp, temp_cast_0 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lighting55 = ( shadow35 * ase_lightColor );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult31 = dot( ase_worldNormal , ase_worldViewDir );
			float normal_viewdir30 = dotResult31;
			float4 Rim71 = ( saturate( ( pow( ( 1.0 - saturate( ( _RimOffset + normal_viewdir30 ) ) ) , _RimPow ) * ( normal_lightdir29 * ase_lightAtten ) ) ) * ( ase_lightColor * _RimTint ) );
			c.rgb = ( lighting55 + Rim71 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
0;369;1523;629;2313.509;837.9553;1.322444;True;True
Node;AmplifyShaderEditor.CommentaryNode;60;-2878.075,122.0907;Float;False;608.49;280;Normal Map;2;39;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;39;-2828.075,172.0907;Float;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;None;982bab90bf9a2ff4daf7bb692135c28a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-2493.585,179.4544;Float;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2079.397,444.1913;Float;False;740.7817;447.0001;Normal.ViewDir;4;27;31;30;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;28;-1983.397,703.1912;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;27;-2029.397,494.1913;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;49;-2048.694,-86.3104;Float;False;710.7527;443.1;Normal.LightDir;4;15;17;18;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-2224.047,-1.055481;Float;False;40;normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;31;-1713.971,618.498;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;15;-1975.994,-36.31038;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;17;-1998.694,173.7896;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;46;-1734.044,-719.9233;Float;False;804.2341;542.7344;Albedo;4;43;44;45;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1563.616,639.7569;Float;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1991.059,1621.027;Float;False;1778.645;804.014;Lim Light;17;63;64;65;67;68;70;79;77;78;69;75;73;80;83;74;76;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;18;-1755.994,15.68963;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-1684.044,-407.1889;Float;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;False;0;None;897185ce22dac7b4e9178c7b62de6bcc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;47;-1294.011,468.7921;Float;False;1208.013;421.6652;Shadow;7;35;51;34;50;37;38;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;43;-1597.861,-671.2457;Float;False;Property;_Tint_Color;Tint_Color;4;0;Create;True;0;0;False;0;0,0,0,0;0.7924528,0.7924528,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1941.059,1776.325;Float;False;30;normal_viewdir;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1869.456,1671.027;Float;False;Property;_RimOffset;Rim Offset;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1558.897,28.64994;Float;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-1679.456,1720.027;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1244.011,692.4573;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1318.402,-576.7096;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-1199.073,541.7036;Float;False;29;normal_lightdir;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;37;-970.0117,549.4572;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;-1543.456,1725.027;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1153.81,-572.2611;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1455.456,2000.027;Float;False;Property;_RimPow;Rim Pow;6;0;Create;True;0;0;False;0;0.4;0.712;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-1466.537,2115.232;Float;False;29;normal_lightdir;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-780.5418,587.7921;Float;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;False;0;None;6b2c17a125bad13459f8293197b42fd3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;79;-1450.352,2266.636;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;-1370.456,1726.027;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-656.9937,507.2499;Float;False;45;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;69;-1179.456,1732.027;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-487.9937,583.2498;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1202.901,2126.843;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-712.1031,2213.041;Float;False;Property;_RimTint;Rim Tint;5;0;Create;True;0;0;False;0;0.4963955,0.838906,0.9150943,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-339.998,589.0331;Float;False;shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-898.6997,1755.568;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;-1948.069,1014.934;Float;False;1241.096;612.5365;Lighting;9;53;52;54;55;58;56;57;59;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightColorNode;73;-712.1035,2040.648;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;83;-730.4839,1755.687;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;53;-1572.912,1170.721;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-521.8314,2029.156;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-1435.325,1064.934;Float;False;35;shadow;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1149.973,1137.808;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-588.1448,1731.662;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-436.4144,1733.74;Float;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-930.9728,1154.808;Float;False;lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-500.0681,230.9907;Float;False;55;lighting;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-519.0569,322.8307;Float;False;71;Rim;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1382.876,1322.845;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;85;-1771.458,2576.385;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;102;-268.4821,395.2407;Float;False;101;spec;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-1503.884,2679.007;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-1714.916,2973.31;Float;False;40;normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;91;-1264.338,2774.826;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1072.016,2996.551;Float;False;Property;_max;max;9;0;Create;True;0;0;False;0;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;92;-1125.171,2788.515;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1255.212,2939.088;Float;False;Property;_Spec_Someting;Spec_Someting;7;0;Create;True;0;0;False;0;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;88;-1489.055,2948.216;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightPos;86;-1782.709,2841.631;Float;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;94;-879.9173,2770.263;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1898.069,1400.347;Float;False;40;normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;56;-1672.917,1408.907;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1062.016,2907.551;Float;False;Property;_min;min;8;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-100.0159,2752.551;Float;False;spec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;99;-507.0159,2628.551;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-599.0159,2753.551;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-282.9291,249.02;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1438.806,1446.471;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;57;-1659.806,1516.471;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-275.0159,2754.551;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-770.0159,3033.551;Float;False;Property;_SpecIntensity;Spec Intensity;10;0;Create;True;0;0;False;0;0.4588235;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;14;-1,-1;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Toon_shaded;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;39;0
WireConnection;31;0;27;0
WireConnection;31;1;28;0
WireConnection;15;0;41;0
WireConnection;30;0;31;0
WireConnection;18;0;15;0
WireConnection;18;1;17;0
WireConnection;29;0;18;0
WireConnection;65;0;64;0
WireConnection;65;1;63;0
WireConnection;44;0;43;0
WireConnection;44;1;42;0
WireConnection;37;0;33;0
WireConnection;37;1;38;0
WireConnection;37;2;38;0
WireConnection;67;0;65;0
WireConnection;45;0;44;0
WireConnection;34;1;37;0
WireConnection;68;0;67;0
WireConnection;69;0;68;0
WireConnection;69;1;70;0
WireConnection;50;0;51;0
WireConnection;50;1;34;0
WireConnection;78;0;77;0
WireConnection;78;1;79;0
WireConnection;35;0;50;0
WireConnection;80;0;69;0
WireConnection;80;1;78;0
WireConnection;83;0;80;0
WireConnection;74;0;73;0
WireConnection;74;1;75;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;76;0;83;0
WireConnection;76;1;74;0
WireConnection;71;0;76;0
WireConnection;55;0;54;0
WireConnection;61;0;53;0
WireConnection;61;1;58;0
WireConnection;87;0;85;0
WireConnection;87;1;86;1
WireConnection;91;0;87;0
WireConnection;91;1;88;0
WireConnection;92;0;91;0
WireConnection;92;1;93;0
WireConnection;88;0;89;0
WireConnection;94;0;92;0
WireConnection;94;1;95;0
WireConnection;94;2;96;0
WireConnection;56;0;59;0
WireConnection;101;0;100;0
WireConnection;97;0;94;0
WireConnection;97;1;98;0
WireConnection;81;0;36;0
WireConnection;81;1;72;0
WireConnection;58;0;56;0
WireConnection;58;1;57;0
WireConnection;100;0;99;0
WireConnection;100;1;97;0
WireConnection;14;13;81;0
ASEEND*/
//CHKSM=A22E3EF9337F6F80003D640E641C1C113FC99FF0