Shader "Custom/Texture_Rotation"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Rotation ("Texture Rotation (Degrees)", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        float _Rotation;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        float2 RotateUV(float2 uv, float angle)
        {
            //Para rotar un vector2, se necesita de una matriz de rotación bidimesional. Dicha matriz es 2x2 
            //[cos, -sen]
            //[sen,  cos]
            //Por lo tanto necesitamos calcular el sen y cos del angulo

            float cos = cos(angle);
            float sin = sin(angle);

            return 0;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
