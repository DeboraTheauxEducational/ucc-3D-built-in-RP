Shader "Unlit/Surface_Basic"
{
    /*
        Surface Shader to avoid complex light calculations. Let's create a simple surface Shader.
    */

    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EmissionTex ("Emission Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (0, 0, 0, 1) //add color property
        //Add other properties
		_Smoothness ("Smoothness", Range(0, 1)) = 0 
		_Metallic ("Metalness", Range(0, 1)) = 0
		[HDR] _EmissionColor ("Emission", Color) = (0,0,0,1) //hdr to set brightness to higher values
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
              
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _EmissionTex;
		fixed4 _Color; //add color variable

        //add properties variables
        float _Smoothness; //scalar value
		float _Metallic; //scalar value
		fixed4 _EmissionColor;     //rgb values without alpha and bigger than 1

        struct Input {
	        float2 uv_MainTex; //Name is important!!
	        float2 uv_EmissionTex; //Name is important!!
        };

        void surf(Input i, inout SurfaceOutputStandard o){
            //Add simple color calculations
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            fixed4 emission = tex2D(_EmissionTex, i.uv_EmissionTex);
			col *= _Color;
            emission *= _EmissionColor;
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
            //set the output variable
            o.Albedo = col.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Emission = emission.rgb;
        }
        ENDCG
    }
}
