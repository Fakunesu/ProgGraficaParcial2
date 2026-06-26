// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water2D_Shader"
{
	Properties
	{
		_Water_Pow("Water_Pow", Range( 0 , 2)) = 0
		_WaterColor("WaterColor", Color) = (0,0.7253882,0.8396226,0)
		_Water_Scale("Water_Scale", Range( 0 , 1)) = 0
		_WaveFrequency("WaveFrequency", Float) = 5
		_Water_Bias("Water_Bias", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 2
		_WaveHeight("WaveHeight", Float) = 0.1
		_WaterLevel("WaterLevel", Range( 0 , 1)) = 1
		_waterOpacity("waterOpacity", Range( 0 , 1)) = 0.4982522
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
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
		uniform float4 _WaterColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Water_Bias;
		uniform float _Water_Scale;
		uniform float _Water_Pow;
		uniform float _WaterLevel;
		uniform float _waterOpacity;

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
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth49 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth49 = abs( ( screenDepth49 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			o.Emission = ( ( _WaterColor * tex2D( _TextureSample0, uv_TextureSample0 ) ) + saturate( ( 1.0 - pow( ( ( distanceDepth49 + _Water_Bias ) * _Water_Scale ) , _Water_Pow ) ) ) ).rgb;
			o.Alpha = ( step( i.uv_texcoord.y , _WaterLevel ) * _waterOpacity );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
363;73;1101;535;3328.326;1180.057;3.119752;True;False
Node;AmplifyShaderEditor.CommentaryNode;83;-2240.749,-496.5651;Inherit;False;1733.287;336.176;Efecto de Toon water para hacer visible los objetos ;9;56;57;55;54;53;51;50;49;52;;0.4292453,0.8839423,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2104.282,325.4081;Inherit;False;1612.453;715.194;Movimiento Sin del agua (Olas);13;20;14;13;11;12;10;9;5;2;4;6;1;3;;1,0.2783019,0.2783019,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-1991.716,482.8772;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1907.716,826.3774;Inherit;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;2;3.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1936.716,736.879;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;49;-2136.682,-404.1575;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2168.451,-298.528;Inherit;False;Property;_Water_Bias;Water_Bias;5;0;Create;True;0;0;0;False;0;False;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2014.716,655.8781;Inherit;False;Property;_WaveFrequency;WaveFrequency;4;0;Create;True;0;0;0;False;0;False;5;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1749.715,795.3776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1848.114,-284.5832;Inherit;False;Property;_Water_Scale;Water_Scale;3;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1792.715,568.8775;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1885.286,-404.1575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1534.238,-403.1575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1509.05,-284.9069;Inherit;False;Property;_Water_Pow;Water_Pow;1;0;Create;True;0;0;0;False;0;False;0;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1577.425,645.9866;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1142.918,-959.7552;Inherit;False;632.3805;439.2537;Setear color y material del agua;3;81;79;80;;0.6753641,1,0.3443396,1;0;0
Node;AmplifyShaderEditor.PowerNode;55;-1178,-403.7562;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1363.877,-138.0977;Inherit;False;868.8406;426.9369;Moficar escala del agua (llenado);5;77;78;41;21;40;;1,0.8228265,0,1;0;0
Node;AmplifyShaderEditor.SinOpNode;10;-1366.539,646.9501;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1374.285,862.9122;Inherit;False;Property;_WaveHeight;WaveHeight;7;0;Create;True;0;0;0;False;0;False;0.1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-927.4367,-404.7802;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1169.351,645.6633;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1583.896,422.7451;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;80;-905.1576,-912.0847;Inherit;False;Property;_WaterColor;WaterColor;2;0;Create;True;0;0;0;False;0;False;0,0.7253882,0.8396226,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1311.847,62.07852;Inherit;False;Property;_WaterLevel;WaterLevel;8;0;Create;False;0;0;0;False;0;False;1;0.6792554;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1254.014,-82.85792;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;-993.9697,-728.3364;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;5acc02f5f1a382e40825420db0b4044a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;41;-982.0798,-94.5033;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-635.6625,-720.6803;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-952.7834,567.4002;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;-677.7928,-406.1379;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1037.722,183.3796;Inherit;False;Property;_waterOpacity;waterOpacity;9;0;Create;True;0;0;0;False;0;False;0.4982522;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-708.8126,-97.24562;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-726.7147,517.6174;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-447.1324,-635.3406;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;19;-414.373,568.6006;Inherit;False;1;0;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;-39.80346,-301.363;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Water2D_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;True;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;9;0;2;0
WireConnection;9;1;5;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;10;0;9;0
WireConnection;57;0;55;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;13;0;1;2
WireConnection;41;0;40;2
WireConnection;41;1;21;0
WireConnection;81;0;80;0
WireConnection;81;1;79;0
WireConnection;14;0;13;0
WireConnection;14;1;11;0
WireConnection;56;0;57;0
WireConnection;77;0;41;0
WireConnection;77;1;78;0
WireConnection;20;2;14;0
WireConnection;76;0;81;0
WireConnection;76;1;56;0
WireConnection;72;2;76;0
WireConnection;72;9;77;0
WireConnection;72;11;20;0
WireConnection;72;14;19;0
ASEEND*/
//CHKSM=7CEBB9695E14F03BC5E21C9D2EA1A43044F6AB78