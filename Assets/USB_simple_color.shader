Shader "Unlit/USB_simple_color" //Inspector path
{
    Properties //Inspector properties
    {
        //You can modify dynamically or at runetime.
        //PropertyName ("display name", trype) = defaultValue //syntax for declaring property
        _MainTex ("Texture", 2D) = "white" {}
        //Number ad slider properties
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3 //reflexión, espejo
        _Factor ("Color Factor", Float) = 0.3
        _CId ("Color Id", Int) = 2 
        // Short names (_CId) in CGPROGRAM reduce memory on GPU, improve performance, follow conventions, enhance readability in compact code, and ensure compatibility across platforms.
        _Color("Tint", Color) = (1,1,1,1)
        _VPos ("Vertex Position", Vector) = (0,0,0,1)
        _Reflection("Reflection", Cube) = "black" {} //Cubemap is useful for generating reflection maps like reflections on a character's armor or on metallic elements.
        _3DTexture("3D Texture", 3D) = "white" {} //Used less frequently \, have an additional coordinate for their spatial calculation.
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
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

            float4 exampleFunction()
            {
                return (1, 1, 1, 1);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //// sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                //// apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //return col;
                float4 f = exampleFunction();
                return f;
            }

            ENDCG
        }
    }
}
