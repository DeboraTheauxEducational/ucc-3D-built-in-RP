Shader "Debo/MiPrimerShader"
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
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata //data del mesh
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f //appDataClip
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
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

					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.uv);
					

					if (i.uv.y <= _ColorChangePos)
					{
						_SelectedColor = _Color1;
					}
					else
					{
						_SelectedColor = _Color2;
					}

					col *= _SelectedColor;

					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
			ENDCG
		}
	}
}
