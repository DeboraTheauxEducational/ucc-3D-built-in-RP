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

        Pass
        {
            CGPROGRAM
            sampler2D _MainTex;

            //Add new struct called Input. This will hold all the information we need to modify our surface. 
            //For this example, we only need uv coordinates.
            struct Input {
	            float2 uv_MainTexture; 
            };

            }
            ENDCG
        }
    }
}
