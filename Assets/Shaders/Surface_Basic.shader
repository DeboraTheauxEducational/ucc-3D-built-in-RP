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

            //Add pragma to make Unity correctly handle light
            //Add surface for the type of shader.
            //Add surf for the method used.
            //Add Standard fullforwardshadows for the last lighting model we want it to use
            #pragma surface surf Standard fullforwardshadows

            sampler2D _MainTex;

            //Add new struct called Input. This will hold all the information we need to modify our surface. 
            //For this example, we only need uv coordinates.
            struct Input {
	            float2 uv_MainTexture; 
            };

            //Create surf shader function. This function doesn't return anything, so we use void instead.
            //surf function take 2 arguments. An instance of Input (per vertex data) and a struct called SurfaceOutputShader.
            //SurfaceOutputShader is used for returning information to the generated part of the shader. 
            //Unity will use it for lighting calculations physically based. Add inout keyword for that.
            void surf(Input i, inout SurfaceOutputStandard o){

            }
            ENDCG
        }
    }
}
