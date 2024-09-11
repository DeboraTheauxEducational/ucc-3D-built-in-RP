Shader "Unlit/Color_split_WORLD_POSITION"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (1,1,1,1)
		_Color2("Color 2", Color) = (1,1,1,1)
		_ColorChangePos("Color Change Pos", float) = 0.5
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f 
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					float3 worldPos : TEXCOORD1; //We need a TEXCOORD variable
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _SelectedColor;
				float4 _Color1;
				float4 _Color2;
				float _ColorChangePos; 

				
					/*
					Currently, the color cutoff on the object is based on UV coordinates, 
					which vary on each face of the cube, so the result is different on each side. 
					The color transition needs to be based on the global position of the object (Object Space)
					or even World Space coordinates, instead of the local UV coordinates of each face to achieve the desired result.

					In the vertex shader, we obtain the position in Object Space or World Space, 
					and use that coordinate to determine the color change in the fragment shader.
					*/

				v2f vert(appdata v) 
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					//use the function mul(unity_ObjectToWorld, v.vertex) to transform the vertex coordinates from Object Space to World Space. 
					//If you prefer to work in Object Space instead of World Space (so that the cutoff depends on the cube’s orientation in its own space), you can use the function o.worldPos = v.vertex.xyz;.
					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv);
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
			ENDCG
		}
	}
}
