Shader "Unlit/Surface_Basic"
{
    /*
        Surface Shader to avoid complex light calculations. Let's create a simple surface Shader.
    */

    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (0, 0, 0, 1) //add color property
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
              
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
		fixed4 _Color; //add color variable

        struct Input {
	        float2 uv_MainTexture; 
        };

        void surf(Input i, inout SurfaceOutputStandard o){
            //Add simple color calculations
            fixed4 col = tex2D(_MainTex, i.uv_MainTexture);
			col *= _Color;
        }
        ENDCG
    }
}
