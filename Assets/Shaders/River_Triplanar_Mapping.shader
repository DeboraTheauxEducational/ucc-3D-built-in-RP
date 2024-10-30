Shader "Unlit/River_Triplanar_Mapping"
{
    Properties 
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Direction ("Direction", Vector) = (0,0,0,0)
        _DirectionTop ("Direction Top", Vector) = (0,0,0,0)

        _DepthColor ("Depth Color", Color) = (1,1,1,1)
        _DepthTex ("Depth Albedo (RGB)", 2D) = "white" {}
        _DepthDirection ("Depth Direction", Vector) = (0,0,0,0)
        _DepthDistance("Depth Distance", Float) = 2

        _Sharpness ("Blend sharpness", Range(1, 64)) = 1
        _RotationTop ("Texture Rotation Top (Degrees)", Float) = 0
        _RotationFront ("Texture Rotation Front (Degrees)", Float) = 0
        _RotationSide ("Texture Rotation Side (Degrees)", Float) = 0
    }

    SubShader 
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "ForceNoShadowCasting"="True" }
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D  _CameraDepthTexture;
        sampler2D _MainTex;
        sampler2D _DepthTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float2 _Direction;
        float2 _DirectionTop;
        fixed4 _DepthColor;
        float2 _DepthDirection;
        float _DepthDistance;
        float _Sharpness;
        float _RotationTop;
        float _RotationFront;
        float _RotationSide;

        struct Input {
            float3 worldPos;
            float3 worldNormal;
            float4 screenPos;
            float2 uv_MainTex;
        };	

        // Función para aplicar rotación a las coordenadas UV
        float2 RotateUV(float2 uv, float angle)
        {
            float rad = radians(angle);
            float cosTheta = cos(rad);
            float sinTheta = sin(rad);
            float2x2 rotationMatrix = float2x2(cosTheta, -sinTheta, sinTheta, cosTheta);
            return mul(rotationMatrix, uv);
        }

        void surf(Input IN, inout SurfaceOutput o) 
        {
            // Calcula las coordenadas UV para las tres proyecciones
            float2 uv_front = RotateUV(IN.worldPos.xy * _Sharpness, _RotationFront) + _Direction * _Time.y;
            float2 uv_side = RotateUV(IN.worldPos.zy * _Sharpness, _RotationSide) + _Direction * _Time.y;
            float2 uv_top = RotateUV(IN.worldPos.xz * _Sharpness, _RotationTop) + _DirectionTop * _Time.y;

            // Lee las texturas en las posiciones UV de las tres proyecciones
            fixed4 col_front = tex2D(_MainTex, uv_front);
            fixed4 col_side = tex2D(_MainTex, uv_side);
            fixed4 col_top = tex2D(_MainTex, uv_top);

            // Genera pesos a partir de las normales del mundo
            float3 weights = abs(IN.worldNormal);

            // Ajusta la nitidez de la mezcla
            weights = pow(weights, _Sharpness);

            // Normaliza los pesos para que sumen 1
            weights = weights / (weights.x + weights.y + weights.z);

            // Combina las texturas proyectadas con sus pesos
            col_front *= weights.z;
            col_side *= weights.x;
            col_top *= weights.y;

            // Suma los colores proyectados
            fixed4 col = col_front + col_side + col_top;

            // Foam (Espuma)
            float4 sceneCoords = UNITY_PROJ_COORD(IN.screenPos);
            float sceneDepth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, sceneCoords);
            float foamFactor = 1 - ((LinearEyeDepth(sceneDepth) - IN.screenPos.w) / _DepthDistance);
            fixed4 foamColor = tex2D(_DepthTex, IN.uv_MainTex + _DepthDirection * _Time.y) * _DepthColor;
            foamFactor = saturate(foamFactor - foamColor);

            // Mezcla de color del triplanar con la espuma
            col = lerp(col * _Color, foamColor, foamFactor);

            // Asigna el color resultante a la salida del surface shader
            o.Albedo = col.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}