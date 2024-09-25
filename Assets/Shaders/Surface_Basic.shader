Shader "Unlit/Surface_Basic"
{
    /*
        Surface Shader to avoid complex light calculations. Let's create a simple surface Shader.
    */

    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
              
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;

        struct Input {
	        float2 uv_MainTexture; 
        };

        void surf(Input i, inout SurfaceOutputStandard o){

        }
        ENDCG
    }
}
