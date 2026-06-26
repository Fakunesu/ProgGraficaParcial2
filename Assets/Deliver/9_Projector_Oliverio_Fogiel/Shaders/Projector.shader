// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Projector"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Intensity("Intensity", Float) = 3.43
		_CausticsColor("CausticsColor", Color) = (0,0.4163918,1,0)
		_Speed("Speed", Float) = 0.15
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _CausticsColor;
		uniform sampler2D _TextureSample0;
		float4x4 unity_Projector;
		uniform float _Speed;
		uniform float _Intensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Emission = ( ( _CausticsColor * tex2D( _TextureSample0, ( (mul( unity_Projector, float4( ase_vertex3Pos , 0.0 ) ).xyz).xy + ( _Time.y * _Speed ) ) ) ) * _Intensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
363;73;1101;533;458.4488;47.18158;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;17;-2148.311,386.3546;Inherit;False;423.4;231.4;Toma posicion local de cada vertice que recibe proyeccion;1;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-2372.709,213.5543;Inherit;False;652;119.4;Transformar la posicion de cada vertice del objeto al espacio de coordenadas del proyector;1;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-1149.774,389.3322;Inherit;False;403.6974;244.3764;Velocidad en el que se mueve la textura ;3;10;11;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1602.622,200.5543;Inherit;False;381.1;171.7;Convierte posicion de vertices al espacio del proyector;1;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.UnityProjectorMatrixNode;6;-2324.609,252.1543;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;7;-2098.312,436.3546;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;19;-1172.822,195.1543;Inherit;False;424;163;Que parte de la textura de caustcis se ve en cada zona;1;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1552.622,250.5543;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1099.774,439.3322;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1078.836,517.7086;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-908.0766,439.3325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;9;-1122.822,245.1543;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-711.9756,251.9474;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;21;-582.6677,-24.03425;Inherit;False;596.9159;476.5363;Lee la textura que le pasemos y le podemos asignar un color especifico;3;5;2;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;5;-532.6677,222.502;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;1604464883a3ddc419e781afc77f36fe;1604464883a3ddc419e781afc77f36fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-442.3953,25.96575;Inherit;False;Property;_CausticsColor;CausticsColor;2;0;Create;True;0;0;0;False;0;False;0,0.4163918,1,0;0,0.4163918,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;31.70467,308.7675;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;3.43;1.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-197.7518,203.3368;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;192.8499,202.3368;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;372.3734,153.729;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Projector;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;22;611.03,159.4189;Inherit;False;1002;162;Al usar PARTICLE ADDITIVE sirve para que las texturas iluminen el piso en vez de reemplazar su color completamente;0;;1,1,1,1;0;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;10;0;11;0
WireConnection;10;1;3;0
WireConnection;9;0;8;0
WireConnection;12;0;9;0
WireConnection;12;1;10;0
WireConnection;5;1;12;0
WireConnection;14;0;2;0
WireConnection;14;1;5;0
WireConnection;15;0;14;0
WireConnection;15;1;4;0
WireConnection;0;2;15;0
ASEEND*/
//CHKSM=34E9CA53F1882073C408A526B74A24164910297E