Shader "Unlit/White_Noise"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        #include "WhiteNoise.cginc" //agregamos la referencia al .cginc

        struct Input
        {
            float3 worldPos; //agregamos la variable de uso del .cginc
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {

        }
        ENDCG
    }
    FallBack "Diffuse"
}
