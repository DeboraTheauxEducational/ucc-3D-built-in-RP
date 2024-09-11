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
