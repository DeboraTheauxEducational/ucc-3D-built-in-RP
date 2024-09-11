/*
Unity provides macros and functions in the inclusion files (cginc) that help you easily obtain positions in these different spaces.

The main matrices are:

unity_ObjectToWorld:
Transforms coordinates from Object Space (local) to World Space. 
Used to get the position of a vertex or point in the global scene space.
Function: mul(unity_ObjectToWorld, v.vertex)

unity_WorldToObject:
Transforms coordinates from World Space to Object Space (local). 
Useful for reversing transformations and obtaining local positions.
Function: mul(unity_WorldToObject, v.vertex)

UNITY_MATRIX_MV:
The Model-View matrix, which transforms coordinates from Object Space to View Space.
Function: mul(UNITY_MATRIX_MV, v.vertex)

UNITY_MATRIX_VP:
The combined View-Projection matrix. 
Used to transform coordinates from View Space directly to Clip Space.
Function: mul(UNITY_MATRIX_VP, v.vertex)

UNITY_MATRIX_MVP:
The combined Model-View-Projection matrix, which transforms coordinates from Object Space directly to Clip Space,
used for rendering on the screen.
Function: mul(UNITY_MATRIX_MVP, v.vertex)

UNITY_MATRIX_IT_MV:
The inverse transpose of the Model-View matrix. 
Useful for transforming normals to View Space while preserving correct orientation.
Function: mul(UNITY_MATRIX_IT_MV, v.normal)

unity_CameraProjection:
The camera projection matrix,
used to transform coordinates from View Space to Clip Space, applying perspective.
Function: mul(unity_CameraProjection, v.vertex)

UNITY_MATRIX_P:
The Projection matrix, which transforms coordinates from View Space 
to homogeneous coordinates in Clip Space.
Function: mul(UNITY_MATRIX_P, v.vertex)
*/

Shader "Unlit/Color_split_OBJECT_POSITION"
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
					float3 objectPos : TEXCOORD1; //We need a TEXCOORD variable
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _SelectedColor;
				float4 _Color1;
				float4 _Color2;
				float _ColorChangePos; 

				v2f vert(appdata v) 
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					//If you prefer to work in Object Space instead of World Space (so that the cutoff depends on the cube’s orientation in its own space), you can use the function o.objectPos = v.vertex.xyz;.
					o.objectPos = v.vertex.xyz;

					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv);

					if (i.objectPos.y > _ColorChangePos)
					{
						col *= _Color1;
					}
					else
					{
						col *= _Color2;
					}

					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
			ENDCG
		}
	}
}
