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

        struct Input
        {

        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
