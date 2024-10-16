Shader "Custom/River"
{
    Properties
    {
        // Combined Specs Properties
        _Specs ("Specs Layer", 2D) = "white" {}
        _SpecColor ("Spec Color Layer", Color) = (1,1,1,1)
        _SpecDirection ("Spec Direction", Vector) = (0, 1, 0, 0)

        // Foam Properties
        _FoamNoise ("Foam Noise", 2D) = "white" {}
        _FoamColor ("Foam Color", Color) = (1,1,1,1)
        _FoamAmount ("Foam Amount", Range(0, 2)) = 1
        _FoamDirection ("Foam Direction", Vector) = (0, 1, 0, 0)
    }

    SubShader
    {
       Tags { "RenderType"="Transparent" "Queue"="Transparent" "ForceNoShadowCasting"="True"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha
        #pragma target 4.0

        struct Input {
            float2 uv_Specs;
            float2 uv_FoamNoise;
            float4 screenPos;
        };

        sampler2D  _CameraDepthTexture;

        sampler2D _Specs;
        float2 _SpecDirection;

        sampler2D _FoamNoise;
        fixed4 _FoamColor;
        float _FoamAmount;
        float2 _FoamDirection;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 col = _SpecColor;

            // Moving specs
            float2 specCoords = IN.uv_Specs + _SpecDirection * _Time.y;
            col.rgb =  tex2D(_Specs, specCoords).rgb * _SpecColor.rgb;
            
            float4 projCoords = UNITY_PROJ_COORD(IN.screenPos);
            float sceneDepth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, projCoords);
            float foamFactor = 1 - ((LinearEyeDepth(sceneDepth) - IN.screenPos.w) / _FoamAmount);
            foamFactor = saturate(foamFactor - tex2D(_FoamNoise, IN.uv_FoamNoise + _FoamDirection * _Time.y).r);
            col.rgb = lerp (col.rgb, _FoamColor.rgb, foamFactor);
            col.a = lerp(col.a, 1, foamFactor * _FoamColor.a);

            // Foam calculation
            // float4 projCoords = UNITY_PROJ_COORD(IN.screenPos);
            // float sceneDepth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, projCoords);
            // float foamFactor = 1 - (LinearEyeDepth(sceneDepth) - IN.screenPos.w) / _FoamAmount;
            // foamFactor = saturate(foamFactor - tex2D(_FoamNoise, IN.uv_FoamNoise + _FoamDirection * _Time.y).r);
            // col.rgb = lerp(col.rgb, _FoamColor.rgb, foamFactor);
            // col.a = lerp(col.a, 1, foamFactor * _FoamColor.a);

            o.Albedo = col.rgb;
            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}