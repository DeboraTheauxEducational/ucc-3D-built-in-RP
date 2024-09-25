Shader "Unlit/Color_split_FACE_TO_CAMERA"
{
    Properties {
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _ColorX ("Color X", Color) = (1,1,1,1)
        _ColorY ("Color Y", Color) = (1,1,1,1)
        _YLimit ("Limit Y", Float) = 0.0
        _FadeRange ("Fade Range", Float) = 1.0//
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }//{ "RenderType"="Opaque" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            fixed4 _BaseColor;
            fixed4 _ColorX;
            fixed4 _ColorY;
            float _YLimit;
            float _FadeRange;//

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float yPos : TEXCOORD1;
            };

            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normalDir = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                o.yPos =  mul(unity_ObjectToWorld, v.vertex).y;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {

               float3 right = float3(1,0,0);
               float3 up = float3(0,1,0);
               float3 left = float3(-1,0,0);
               float3 finalColor = (0,0,0);
               float alpha = 1.0;

               finalColor += _ColorX.rgb * dot(i.normalDir, right) * _ColorX.a;

               finalColor += _ColorY.rgb * dot(i.normalDir, up) * _ColorY.a;

               finalColor += _BaseColor.rgb * dot(i.normalDir, left) * saturate((i.yPos - (_YLimit - _FadeRange)) / _FadeRange);    

               if(i.yPos < _YLimit)
               {
                    alpha = saturate((i.yPos - (_YLimit - _FadeRange)) / _FadeRange);//
               }
               
               return fixed4(finalColor, alpha);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}