Shader "Custom/Color_Fresnel"
{

    /*
        With a fresnel you can darken, lighten or color the outline of your objects, increasing the sense of depth.
        Fresnel uses the normals of the object to determine the intensity of the effect
    */
    
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [HDR] _Emission ("Emission", color) = (0,0,0) //add Emission property
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
            float3 worldNormal; //to get and generate the worldspace normal.
        };

        half _Glossiness;
        half _Metallic;
        half3 _Emission;
        fixed4 _Color;

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, i.uv_MainTex) * _Color;
            float fresnel = dot(i.worldNormal, float3(0, 1, 0)); //let's calculate how aligned those vectors are
            o.Emission = _Emission + fresnel; //and visualized on the emission

            //The emission is lighter when the normal points up and darker where it points down.

            // o.Albedo = c.rgb;
            // o.Metallic = _Metallic;
            // o.Smoothness = _Glossiness;
            // o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
