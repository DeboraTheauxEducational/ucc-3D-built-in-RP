Shader "Custom/Triplanar_Mapping"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Calculamos la proyeccion de cada plano (cara) del objeto
            float2 uv_front = IN.worldPos.xy;
            float2 uv_side = IN.worldPos.zy;
            float2 uv_top = IN.worldPos.xz;

            //Tomamos el color de pixel en cada caso
            fixed4 col_front = tex2D(_MainTex, uv_front);
            fixed4 col_side = tex2D(_MainTex, uv_side);
            fixed4 col_top = tex2D(_MainTex, uv_top);

            //Calculamos
            col_front *= IN.worldNormal.z;
            col_side *= IN.worldNormal.x;
            col_top *= IN.worldNormal.y;

            //Sumamos los colores proyectados
            fixed4 col = col_front + col_side + col_top;

            //los mostramos en Albedo
            o.Albedo = col.rgb;
            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
