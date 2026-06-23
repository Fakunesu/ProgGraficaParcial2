// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wata"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Pow("Pow", Range( 0 , 2)) = 0
		_Color0("Color 0", Color) = (0,0.7253882,0.8396226,0)
		_Float0("Float 0", Float) = 2.77
		_Scale("Scale", Range( 0 , 1)) = 0
		_WaveFrequency("WaveFrequency", Float) = 5
		_Bias("Bias", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 2
		_WaveHeight("WaveHeight", Float) = 0.1
		_WaterLevel("WaterLevel", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		Offset  0 , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _WaveFrequency;
		uniform float _Speed;
		uniform float _WaveHeight;
		uniform float4 _Color0;
		uniform float _Float0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Pow;
		uniform float _WaterLevel;
		uniform float _Cutoff = 0.5;


		float2 voronoihash47( float2 p )
		{
			p = p - 6 * floor( p / 6 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi47( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash47( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * ( abs(r.x) + abs(r.y) );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 1.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult20 = (float4(0.0 , 0.0 , ( (0.0 + (ase_vertex3Pos.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * ( sin( ( ( ase_vertex3Pos.x * _WaveFrequency ) + ( _Time.y * _Speed ) ) ) * _WaveHeight ) ) , 0.0));
			v.vertex.xyz += appendResult20.xyz;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time47 = _Time.y;
			float2 coords47 = i.uv_texcoord * _Float0;
			float2 id47 = 0;
			float2 uv47 = 0;
			float fade47 = 0.5;
			float voroi47 = 0;
			float rest47 = 0;
			for( int it47 = 0; it47 <2; it47++ ){
			voroi47 += fade47 * voronoi47( coords47, time47, id47, uv47, 0 );
			rest47 += fade47;
			coords47 *= 2;
			fade47 *= 0.5;
			}//Voronoi47
			voroi47 /= rest47;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			o.Emission = ( ( _Color0 + voroi47 ) + saturate( ( 1.0 - pow( ( ( distanceDepth49 + _Bias ) * _Scale ) , _Pow ) ) ) ).rgb;
			o.Alpha = 1;
			float temp_output_41_0 = step( i.uv_texcoord.y , _WaterLevel );
			clip( temp_output_41_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
363;73;1101;535;1734.216;177.8771;2.056748;False;False
Node;AmplifyShaderEditor.SimpleTimeNode;4;-2153.901,614.657;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2231.901,533.6578;Inherit;False;Property;_WaveFrequency;WaveFrequency;5;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-2208.901,360.6571;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2124.901,704.1557;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;49;-1616.086,-27.2823;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1646.258,78.34704;Inherit;False;Property;_Bias;Bias;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-2009.899,446.6575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1966.899,673.1559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1363.086,-27.2823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1535.348,156.2402;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1199.086,-26.28229;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1334.964,78.17846;Inherit;False;Property;_Pow;Pow;1;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1794.609,523.7664;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-1583.723,524.7299;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;55;-1049.086,-25.2823;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1591.469,740.6906;Inherit;False;Property;_WaveHeight;WaveHeight;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-1311.687,-297.5103;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1297.121,-215.4223;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;2.77;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1801.08,300.525;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-881.6589,-24.70745;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;47;-1130.485,-321.8157;Inherit;True;0;2;1;0;2;True;6;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1386.536,523.4432;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-925.4271,-507.5506;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0,0.7253882,0.8396226,0;0,0.7253882,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-682.2252,-344.7134;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;56;-650.2193,-80.75679;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1169.968,445.1802;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1189.086,672.5082;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1226.559,789.9005;Inherit;False;Property;_WaterLevel;WaterLevel;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;41;-931.5242,624.9356;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;19;-647.3853,511.2655;Inherit;False;1;0;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;73;-943.9476,-250.26;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-431.7297,-253.669;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;43;-673.0628,364.3137;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-943.8983,395.3974;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;-176.5079,-177.3754;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;wata;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;True;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;9;0;2;0
WireConnection;9;1;5;0
WireConnection;10;0;9;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;13;0;1;2
WireConnection;57;0;55;0
WireConnection;47;1;44;0
WireConnection;47;2;45;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;56;0;57;0
WireConnection;14;0;13;0
WireConnection;14;1;11;0
WireConnection;41;0;40;2
WireConnection;41;1;21;0
WireConnection;73;0;47;0
WireConnection;76;0;48;0
WireConnection;76;1;56;0
WireConnection;43;0;41;0
WireConnection;20;2;14;0
WireConnection;72;2;76;0
WireConnection;72;10;41;0
WireConnection;72;11;20;0
WireConnection;72;14;19;0
ASEEND*/
//CHKSM=77C92F07942A0E9BA11635960A4BB9A903BA46F5