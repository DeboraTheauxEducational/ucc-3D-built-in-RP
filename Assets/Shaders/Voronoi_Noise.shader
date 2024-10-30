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

        #include "VoronoiNoise.cginc" 

        float _CellSize;
		float3 _BorderColor;

        struct Input
        {
           float3 worldPos;
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 cell = IN.worldPos.xz / _CellSize; //se divide el plano XZ del mundo en tamaño de celdas
			o.Albedo = half3(cell.x,cell.y, 0.0);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
