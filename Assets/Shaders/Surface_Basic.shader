Shader "Unlit/Surface_Basic"
{
    /*
        Surface Shader to avoid complex light calculations. Let's create a simple surface Shader.
    */

    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (0, 0, 0, 1) //add color property
        //Add other properties
		_Smoothness ("Smoothness", Range(0, 1)) = 0 
		_Metallic ("Metalness", Range(0, 1)) = 0
		[HDR] _Emission ("Emission", color) = (0,0,0) //hdr to set brightness to higher values
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
              
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
		fixed4 _Color; //add color variable

        //add properties variables
        half _Smoothness; //scalar value
		half _Metallic; //scalar value
		half3 _Emission; //rgb values without alpha and bigger than 1

        struct Input {
	        float2 uv_MainTex; //Name is important!!
        };

        void surf(Input i, inout SurfaceOutputStandard o){
            //Add simple color calculations
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
			col *= _Color;
			o.Albedo = col.rgb;

            /*
                It doesn't make any change to the texture color because we are not setting the output parameter (SurfaceOutputStandard o ).

                Standard Lighting Properties (SurfaceOutputStandard)
                This structure allows us to modify the value of differents properties. Like
                Albedo: Base color of the material, influenced by the light but not affecting specular lighting.
                Normal: describe the surface direction in tangent space.
                Emission: is the glow, independently of light.
                Metallic: adjust relfection behaviour.
                Smoothness: controls surface polish.
                Occlusion: simulates shadows in crevices.
                Alpha: manages transparency.
            */

            o.Albedo = col.rgb;
            //set the output variable
            o.Albedo = col.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Emission = _Emission;
        }
        ENDCG
    }
}
