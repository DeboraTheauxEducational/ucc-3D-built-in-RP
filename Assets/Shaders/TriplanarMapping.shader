Shader "Custom/TriplanarMapping"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos; // posicion en los ejes globales
            float3 worldNormal; //normales globales (frente siempre es frente)
        };

        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv_front = IN.worldPos.xy; 
            float2 uv_top = IN.worldPos.xz; 
            float2 uv_side = IN.worldPos.yz; 

            fixed4 color_front = tex2D (_MainTex, uv_front) * _Color;
            fixed4 color_top = tex2D (_MainTex, uv_top) * _Color;
            fixed4 color_side = tex2D (_MainTex, uv_side) * _Color;

            //Queremos que la textura se adapte a las normales globales

            color_front *= abs(IN.worldNormal).z;
            color_top *= abs(IN.worldNormal).y;
            color_side *= abs(IN.worldNormal).x;

            fixed4 finalColor = color_front + color_top + color_side;

            o.Albedo = finalColor.rgb;
            o.Alpha = finalColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
