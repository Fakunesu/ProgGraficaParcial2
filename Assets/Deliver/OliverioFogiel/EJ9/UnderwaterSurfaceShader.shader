// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UnderwaterSurfaceShader"
{
	Properties
	{
		_WaveStrenth("_WaveStrenth", Range( 0 , 0.3)) = 0.1
		_WaveTexture("_WaveTexture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _WaveStrenth;
			uniform sampler2D _WaveTexture;
			uniform float4 _WaveTexture_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( ( 0.0 - 0.5 ) * _WaveStrenth ) * v.ase_normal );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_WaveTexture = i.ase_texcoord1.xy * _WaveTexture_ST.xy + _WaveTexture_ST.zw;
				float4 color42 = IsGammaSpace() ? float4(0.4481132,0.8965007,1,0) : float4(0.1691188,0.7805057,1,0);
				float4 appendResult33 = (float4(( ( tex2D( _WaveTexture, uv_WaveTexture ).r * 0.12 ) + color42 ).rgb , 0.1));
				
				
				finalColor = appendResult33;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;683;-1731.907;-609.0494;1.225729;True;False
Node;AmplifyShaderEditor.RangedFloatNode;47;1905.239,719.3892;Inherit;False;Constant;_Float6;Float 6;8;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;1738.839,525.1053;Inherit;True;Property;_WaveTexture;_WaveTexture;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;505.663,1543.797;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;2049.12,799.0261;Inherit;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0.4481132,0.8965007,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;2122.727,689.8799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;696.4783,1548.001;Inherit;False;Property;_WaveStrenth;_WaveStrenth;3;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;649.663,1433.797;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;2087.209,1137.54;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;2340.225,693.1594;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;26;893.9504,1051.118;Inherit;False;227.0001;185;WaveMask;1;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;1008.663,1435.797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;37;1589.554,1572.583;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-687.5447,1519.718;Inherit;False;Property;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0;0;-0.2;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-528.8276,921.256;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;164.9695,1253.018;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;28;1553.563,1055.919;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;1834.288,1436.797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;1648.965,1265.383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;18;-136.1971,1280.369;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-578.3456,1157.019;Inherit;False;Property;_Float4;Float 4;2;0;Create;True;0;0;0;False;0;False;0;0;-0.2;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-248.6873,1078.098;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;25;617.6518,1209.017;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-528.946,1283.12;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;-375.5462,1439.117;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;2;926.371,843.8544;Inherit;False;Constant;_WaterColor;WaterColor;1;0;Create;True;0;0;0;False;0;False;0,0.723927,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;1314.21,1353.32;Inherit;False;Property;_Opacity;_Opacity;0;0;Create;True;0;0;0;False;0;False;0.45;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;1284.569,1017.398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1421.056,850.2192;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;2308.049,1035.963;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;30;1261.15,930.8189;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-65.22847,920.2545;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-681.4836,1432.67;Inherit;False;Property;_WaveSpeedB;_WaveSpeedB;4;0;Create;True;0;0;0;False;0;False;0;0;-0.2;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-577.7281,1073.011;Inherit;False;Property;_WaveSpeedA;_WaveSpeedA;1;0;Create;True;0;0;0;False;0;False;0;0;-0.2;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;626.7513,1099.822;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;24;943.9504,1101.118;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2533.448,1036.962;Float;False;True;-1;2;ASEMaterialInspector;100;1;UnderwaterSurfaceShader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;46;0;45;1
WireConnection;46;1;47;0
WireConnection;34;1;35;0
WireConnection;48;0;46;0
WireConnection;48;1;42;0
WireConnection;36;0;34;0
WireConnection;36;1;5;0
WireConnection;39;1;18;0
WireConnection;28;0;29;0
WireConnection;28;1;27;0
WireConnection;28;2;24;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;31;0;24;0
WireConnection;31;1;3;0
WireConnection;18;0;20;0
WireConnection;18;2;21;0
WireConnection;16;0;4;0
WireConnection;16;1;17;0
WireConnection;21;0;12;0
WireConnection;21;1;22;0
WireConnection;27;0;2;0
WireConnection;27;1;24;0
WireConnection;29;0;2;0
WireConnection;29;1;30;0
WireConnection;33;0;48;0
WireConnection;33;3;43;0
WireConnection;7;0;6;0
WireConnection;7;2;16;0
WireConnection;23;1;39;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;0;0;33;0
WireConnection;0;1;38;0
ASEEND*/
//CHKSM=ED5ED19EDB71965E5461321B3519E804A53707ED