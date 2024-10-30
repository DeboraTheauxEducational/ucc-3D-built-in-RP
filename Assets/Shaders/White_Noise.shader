Shader "Unlit/White_Noise"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  "Queue"="Geometry"}
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
             o.Albedo = rand3dTo3d(IN.worldPos); //usamos la funcion de WhiteNoise.cginc para agregar el ruido al color base
        }
        ENDCG
    }
    FallBack "Diffuse"
}
