// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_alcoholDrinked("alcoholDrinked", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_speedOfPanner("speedOfPanner", Vector) = (0.5,0.5,0,0)

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float2 _speedOfPanner;
			uniform float _alcoholDrinked;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv_Texture0 = i.uv.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float lerpResult91 = lerp( 0.3 , 0.4 , _alcoholDrinked);
				float cos61 = cos( ( sin( _Time.y ) * lerpResult91 ) );
				float sin61 = sin( ( sin( _Time.y ) * lerpResult91 ) );
				float2 rotator61 = mul( uv_Texture0 - _speedOfPanner , float2x2( cos61 , -sin61 , sin61 , cos61 )) + _speedOfPanner;
				float4 tex2DNode50 = tex2D( _Texture0, rotator61 );
				float2 appendResult51 = (float2(tex2DNode50.r , tex2DNode50.g));
				float AlcoholVar87 = _alcoholDrinked;
				float2 lerpResult47 = lerp( uv_MainTex , ( uv_MainTex + ( appendResult51 * float2( 0.001,0.001 ) ) ) , AlcoholVar87);
				float4 color73 = IsGammaSpace() ? float4(0.8301887,0.5973309,0,0.572549) : float4(0.6562665,0.3154403,0,0.572549);
				float temp_output_85_0 = ( AlcoholVar87 * 0.05 );
				float4 lerpResult84 = lerp( 0 , ( color73 * temp_output_85_0 ) , temp_output_85_0);
				

				finalColor = ( tex2D( _MainTex, lerpResult47 ) + lerpResult84 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;535;2566.111;1228.386;3.871303;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;62;-1726.708,127.693;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1697.635,356.5059;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1700.169,449.116;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1705.992,567.3323;Inherit;False;Property;_alcoholDrinked;alcoholDrinked;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;-1456.239,397.7932;Inherit;False;3;0;FLOAT;0.3;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-1508.134,132.1348;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;53;-1280.961,-490.6014;Inherit;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;0;False;0;False;16d574e53541bba44a84052fa38778df;16d574e53541bba44a84052fa38778df;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1286.183,133.2228;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1568.883,-275.8141;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;56;-1751.202,-90.16647;Inherit;False;Property;_speedOfPanner;speedOfPanner;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;61;-1132.925,-122.5954;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;50;-876.3652,-330.7086;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;16d574e53541bba44a84052fa38778df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;42;-475.1044,-543.798;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-1515.271,707.7607;Inherit;False;AlcoholVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-487.3882,-301.3677;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-380.5487,-424.4099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-319.3406,-258.0397;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.001,0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-102.7858,-163.483;Inherit;False;87;AlcoholVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;85;192.4349,-134.5614;Inherit;False;0.05;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-117.1376,-288.344;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;73;30.9696,-0.3027105;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0.8301887,0.5973309,0,0.572549;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;47;30.48832,-311.9517;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;440.2656,9.172241;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;43;509.1146,-346.9933;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;84;769.4172,3.603625;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;886.4716,-188.1557;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;52;-1204.234,-273.9715;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1123.808,-333.0371;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;91;0;92;0
WireConnection;91;1;93;0
WireConnection;91;2;49;0
WireConnection;68;0;62;0
WireConnection;69;0;68;0
WireConnection;69;1;91;0
WireConnection;54;2;53;0
WireConnection;61;0;54;0
WireConnection;61;1;56;0
WireConnection;61;2;69;0
WireConnection;50;0;53;0
WireConnection;50;1;61;0
WireConnection;87;0;49;0
WireConnection;51;0;50;1
WireConnection;51;1;50;2
WireConnection;44;2;42;0
WireConnection;55;0;51;0
WireConnection;85;0;86;0
WireConnection;45;0;44;0
WireConnection;45;1;55;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;47;2;86;0
WireConnection;78;0;73;0
WireConnection;78;1;85;0
WireConnection;43;0;42;0
WireConnection;43;1;47;0
WireConnection;84;0;42;0
WireConnection;84;1;78;0
WireConnection;84;2;85;0
WireConnection;77;0;43;0
WireConnection;77;1;84;0
WireConnection;52;0;54;0
WireConnection;52;2;56;0
WireConnection;0;0;77;0
ASEEND*/
//CHKSM=975D0049E9EAFDF198B18ABCC8B31A005F82888C