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
            //delete pragma vertex
            //delete pragma fragment
            // make fog work
            //delete pragma multi_compile_fog

            //delete include "UnityCG.cginc"

           //delete appdata and v2f structs

            sampler2D _MainTex;
            //delete _MainTex_ST;

            //delete vert shader

            //delete frag shader

            }
            ENDCG
        }
    }
}
