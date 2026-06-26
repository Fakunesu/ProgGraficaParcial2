// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcessFlashbang"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_flash("flash", Range( 0 , 1)) = 0

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
			
			uniform float _flash;


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
				float FlashPower42 = pow( _flash , 0.4 );
				float2 appendResult15 = (float2(( uv_MainTex.x + ( (0.2 + (cos( _Time.y ) - -1.0) * (-0.2 - 0.2) / (1.0 - -1.0)) * 0 ) ) , ( uv_MainTex.y + ( (-0.2 + (cos( ( _Time.y * 1.3 ) ) - -1.0) * (0.2 - -0.2) / (1.0 - -1.0)) * FlashPower42 ) )));
				float2 appendResult65 = (float2(( uv_MainTex.x - ( (0.2 + (cos( _Time.y ) - -1.0) * (-0.2 - 0.2) / (1.0 - -1.0)) * FlashPower42 ) ) , ( uv_MainTex.y - ( (-0.2 + (cos( ( _Time.y * 1.3 ) ) - -1.0) * (0.2 - -0.2) / (1.0 - -1.0)) * FlashPower42 ) )));
				float4 lerpResult67 = lerp( tex2D( _MainTex, appendResult15 ) , tex2D( _MainTex, appendResult65 ) , 0.5);
				float4 color36 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float4 lerpResult34 = lerp( lerpResult67 , color36 , FlashPower42);
				

				finalColor = lerpResult34;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
348;73;1100;749;2082.264;348.6313;2.432857;True;False
Node;AmplifyShaderEditor.RangedFloatNode;2;280.1457,948.2644;Inherit;False;Property;_flash;flash;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1852.292,189.9308;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-2003.032,873.5311;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;53;-1804.916,874.3166;Inherit;False;1.3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1713.997,-78.28651;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;35;615.3912,881.8046;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;54;-1864.737,605.3135;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;48;-1654.176,190.7163;Inherit;False;1.3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;56;-1635.995,603.8118;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;23;-1485.255,-79.78821;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;55;-1645.602,874.4289;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;797.5593,918.8835;Inherit;False;FlashPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;46;-1494.862,190.8286;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-1355.252,606.3403;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;50;-1495.869,453.1375;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;12;-1204.512,-77.25966;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1354.795,766.2739;Inherit;False;42;FlashPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1204.055,82.6739;Inherit;False;42;FlashPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1227.557,354.0199;Inherit;False;42;FlashPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;21;-1327.761,-277.2713;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;57;-1364.531,875.4412;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1378.297,1037.623;Inherit;False;42;FlashPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1213.791,191.841;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1097.29,916.0073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1342.574,472.8849;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-939.8458,-31.48912;Inherit;False;2;2;0;FLOAT;0;False;1;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-964.3607,232.4066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1090.586,652.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1174.466,-257.5239;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-863.0974,864.769;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-674.4711,-97.28122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-677.0179,-201.6326;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;63;-874.9712,621.339;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;4;-409.4421,272.4649;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-460.3239,-84.60614;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-501.8347,512.0802;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;39;-197.623,70.30219;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-199.9834,372.3275;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;157.488,575.2013;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;189.5443,312.3402;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;341.0839,637.5158;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;34;491.7018,296.3276;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;743.0247,304.6045;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcessFlashbang;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;53;0;52;0
WireConnection;35;0;2;0
WireConnection;48;0;47;0
WireConnection;56;0;54;0
WireConnection;23;0;10;0
WireConnection;55;0;53;0
WireConnection;42;0;35;0
WireConnection;46;0;48;0
WireConnection;58;0;56;0
WireConnection;12;0;23;0
WireConnection;57;0;55;0
WireConnection;13;0;46;0
WireConnection;61;0;57;0
WireConnection;61;1;59;0
WireConnection;51;2;50;0
WireConnection;40;0;12;0
WireConnection;40;1;43;0
WireConnection;41;0;13;0
WireConnection;41;1;45;0
WireConnection;62;0;58;0
WireConnection;62;1;60;0
WireConnection;5;2;21;0
WireConnection;64;0;51;2
WireConnection;64;1;61;0
WireConnection;9;0;5;2
WireConnection;9;1;41;0
WireConnection;14;0;5;1
WireConnection;14;1;40;0
WireConnection;63;0;51;1
WireConnection;63;1;62;0
WireConnection;15;0;14;0
WireConnection;15;1;9;0
WireConnection;65;0;63;0
WireConnection;65;1;64;0
WireConnection;39;0;4;0
WireConnection;39;1;15;0
WireConnection;66;0;4;0
WireConnection;66;1;65;0
WireConnection;67;0;39;0
WireConnection;67;1;66;0
WireConnection;67;2;68;0
WireConnection;34;0;67;0
WireConnection;34;1;36;0
WireConnection;34;2;42;0
WireConnection;0;0;34;0
ASEEND*/
//CHKSM=6AF439AA3DD02C88EE2A3A7724DBFA1D752B5DA5