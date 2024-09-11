Shader "Unlit/Color_split_FACE_TO_CAMERA"
{
    Properties
    {
        //Add Properties
        _MainTex ("Texture", 2D) = "white" {}
        _ColorFront("Front Face Color", Color) = (1, 0, 0, 1) 
        _ColorBack("Back Face Color", Color) = (0, 1, 0, 1) 
        _ColorSide("Side Face Color", Color) = (0, 0, 1, 1) 
    
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            //Add global variables
            float4 _ColorFront;
            float4 _ColorBack;
            float4 _ColorSide;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL; //Add normal data from mesh
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD0; //Add TEXTCOORD0 to save world normal position
                float3 worldVertex : TEXCOORD1; //Add TEXTCOORD1 to save world vertex position
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
