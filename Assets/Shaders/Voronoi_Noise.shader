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
            float3 noise = voronoiNoiseWithEdge2D(cell); //calcula el Voronoi Noise para la posición de la celda.

            //noise.x: la distancia desde el punto actual al centro de la celda más cercana.
            //noise.y: un valor aleatorio único para cada celda, usado para darle un color distintivo a cada celda.
            //noise.z: la distancia al borde de la celda más cercana (esto permite que se dibujen los bordes entre celdas).

            float3 cellColor = rand1dTo3d(noise.y); //generar un color para cada celda

            //rand1dTo3d(noise.y) convierte el valor noise.y en un color float3. Esto garantiza que cada celda tenga un color único y distintivo. El color es aleatorio y depende del valor noise.y generado para cada celda.

			o.Albedo = half3(cellColor.x,cellColor.y, cellColor.z);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
