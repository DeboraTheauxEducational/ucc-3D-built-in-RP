Shader "Unlit/Texture_BreakUp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HeightTex ("Height Texture", 2D) = "white" {}
        _FadeThreshold ("Fade Threshold", Range(0, 1)) = 0.0
        _OutlineColor ("Outline Color", Color) = (1, 0, 0, 1)
        _OutlineThickness ("Outline Thickness", Float) = 0.01
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
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
                float2 uv_height : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _HeightTex;
            float4 _MainTex_ST;
            float4 _HeightTex_ST;
            float _FadeThreshold;
            float4 _OutlineColor;
            float _OutlineThickness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_height = TRANSFORM_TEX(v.uv, _HeightTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float height = tex2D(_HeightTex, i.uv_height).r; //tex2D returns (r,g,b,a) on uv position, normally r is for the height.

                float left = tex2D(_HeightTex, i.uv_height + float2(-_OutlineThickness, 0)).r;
                float right = tex2D(_HeightTex, i.uv_height + float2(_OutlineThickness, 0)).r;
                float up = tex2D(_HeightTex, i.uv_height + float2(0, _OutlineThickness)).r;
                float down = tex2D(_HeightTex, i.uv_height + float2(0, -_OutlineThickness)).r;

                bool isEdge = (height < _FadeThreshold) && (left >= _FadeThreshold || right >= _FadeThreshold || up >= _FadeThreshold || down >= _FadeThreshold);

                if (isEdge)
                {
                    return _OutlineColor;
                }

                if (height < _FadeThreshold)
                {
                    discard;
                }

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
