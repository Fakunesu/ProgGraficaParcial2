// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_alcoholDrinked("alcoholDrinked", Float) = 9.06
		_Texture0("Texture 0", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_speedOfPanner("speedOfPanner", Vector) = (0.5,0.5,0,0)
		_Vector0("Vector 0", Vector) = (40,40,0,0)

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
			uniform sampler2D _Texture1;
			uniform float2 _Vector0;
			uniform float4 _Texture1_ST;
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
				float cos61 = cos( ( sin( ( _Time.y * 0.4 ) ) * 3.5 ) );
				float sin61 = sin( ( sin( ( _Time.y * 0.4 ) ) * 3.5 ) );
				float2 rotator61 = mul( uv_Texture0 - _speedOfPanner , float2x2( cos61 , -sin61 , sin61 , cos61 )) + _speedOfPanner;
				float4 tex2DNode50 = tex2D( _Texture0, rotator61 );
				float2 appendResult51 = (float2(tex2DNode50.r , tex2DNode50.g));
				float2 temp_output_55_0 = ( appendResult51 * float2( 0.001,0.001 ) );
				float temp_output_101_0 = ( _Time.y * 0.5 );
				float2 appendResult115 = (float2(( cos( temp_output_101_0 ) * 0.02 ) , ( sin( ( temp_output_101_0 * 2.0 ) ) * 0.01 )));
				float2 uv_Texture1 = i.uv.xy * _Texture1_ST.xy + _Texture1_ST.zw;
				float2 panner106 = ( _Vector0.x * appendResult115 + uv_Texture1);
				float4 tex2DNode105 = tex2D( _Texture1, panner106 );
				float2 appendResult116 = (float2(tex2DNode105.r , tex2DNode105.g));
				float AlcoholVar87 = _alcoholDrinked;
				float2 lerpResult47 = lerp( uv_MainTex , ( uv_MainTex + ( temp_output_55_0 + ( appendResult116 * float2( 0.001,0.001 ) ) ) + temp_output_55_0 ) , AlcoholVar87);
				float4 tex2DNode43 = tex2D( _MainTex, lerpResult47 );
				float4 color150 = IsGammaSpace() ? float4(1,0.9607843,0.8823529,1) : float4(1,0.9130987,0.7529423,1);
				float clampResult157 = clamp( AlcoholVar87 , 0.0 , 8.0 );
				float4 lerpResult155 = lerp( tex2DNode43 , ( tex2DNode43 * color150 ) , clampResult157);
				

				finalColor = lerpResult155;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;681;340.583;680.5074;1.811473;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;95;-2037.247,1235.84;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1953.047,1403.641;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1609.048,1202.698;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;62;-2436.645,186.5775;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-1503.326,1444.189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;112;-1362.908,1414.314;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;113;-1355.566,1127.709;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2025.502,220.5268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;53;-1544.145,-459.7352;Inherit;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;0;False;0;False;6a128976440e81d4fbdd3ff51a039f5c;16d574e53541bba44a84052fa38778df;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SinOpNode;68;-1646.229,153.321;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-1147.426,1414.337;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1163.768,1126.068;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;100;-1366.099,542.1047;Inherit;True;Property;_Texture1;Texture 1;2;0;Create;True;0;0;0;False;0;False;6a128976440e81d4fbdd3ff51a039f5c;16d574e53541bba44a84052fa38778df;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1762.144,-260.9479;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-1714.761,870.2723;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1406.099,196.1976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;103;-1943.921,999.2379;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;40,40;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;115;-924.7354,1182.357;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;56;-1944.463,-75.3002;Inherit;False;Property;_speedOfPanner;speedOfPanner;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;106;-1087.115,809.305;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;61;-1481.441,-91.48124;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;50;-1069.626,-315.8423;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;16d574e53541bba44a84052fa38778df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;105;-996.2219,373.4395;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;16d574e53541bba44a84052fa38778df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;116;-612.9698,249.9465;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-747.5469,-286.5015;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;42;-475.1044,-543.798;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-305.5691,246.8362;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.001,0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2514.137,640.2295;Inherit;False;Property;_alcoholDrinked;alcoholDrinked;0;0;Create;True;0;0;0;False;0;False;9.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-604.3406,-287.0397;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.001,0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-2006.614,640.4402;Inherit;False;AlcoholVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-380.5487,-424.4099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;144;-322.9658,-179.7339;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-43.67324,-33.22107;Inherit;False;87;AlcoholVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-117.1376,-288.344;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;47;240.27,-309.7665;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;43;511.519,-352.0562;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;150;613.4658,-24.4023;Inherit;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;1,0.9607843,0.8823529,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;152;737.5743,220.8786;Inherit;False;87;AlcoholVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;157;1023.456,161.8278;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;823.9272,-207.7843;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;155;1194.803,-267.4856;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1398.066,-350.5306;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;101;0;95;0
WireConnection;101;1;96;0
WireConnection;135;0;101;0
WireConnection;112;0;135;0
WireConnection;113;0;101;0
WireConnection;148;0;62;0
WireConnection;68;0;148;0
WireConnection;121;0;112;0
WireConnection;114;0;113;0
WireConnection;54;2;53;0
WireConnection;102;2;100;0
WireConnection;145;0;68;0
WireConnection;115;0;114;0
WireConnection;115;1;121;0
WireConnection;106;0;102;0
WireConnection;106;2;115;0
WireConnection;106;1;103;0
WireConnection;61;0;54;0
WireConnection;61;1;56;0
WireConnection;61;2;145;0
WireConnection;50;0;53;0
WireConnection;50;1;61;0
WireConnection;105;0;100;0
WireConnection;105;1;106;0
WireConnection;116;0;105;1
WireConnection;116;1;105;2
WireConnection;51;0;50;1
WireConnection;51;1;50;2
WireConnection;143;0;116;0
WireConnection;55;0;51;0
WireConnection;87;0;49;0
WireConnection;44;2;42;0
WireConnection;144;0;55;0
WireConnection;144;1;143;0
WireConnection;45;0;44;0
WireConnection;45;1;144;0
WireConnection;45;2;55;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;47;2;86;0
WireConnection;43;0;42;0
WireConnection;43;1;47;0
WireConnection;157;0;152;0
WireConnection;154;0;43;0
WireConnection;154;1;150;0
WireConnection;155;0;43;0
WireConnection;155;1;154;0
WireConnection;155;2;157;0
WireConnection;0;0;155;0
ASEEND*/
//CHKSM=BD88CE7C9E506D09134A9F10AA24B744583B8FA7