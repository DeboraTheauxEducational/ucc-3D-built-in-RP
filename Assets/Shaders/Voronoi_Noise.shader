Shader "Custom/Voronoi_Noise"
{
    Properties
    {
        _CellSize ("Cell Size", Range(0, 2)) = 1
		_BorderColor ("Border Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        float _CellSize;
		float3 _BorderColor;

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
