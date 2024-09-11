/*
The decision of which color to apply is made in the vertex shader, and the calculated value is passed to the fragment shader through the v2f structure.
The color value is interpolated between vertices when passed to the fragment shader. 
This means that if a triangle contains vertices using both _Color1 and _Color2, 
the colors will blend smoothly across the surface of the triangle, creating a gradual transition between the two colors.
*/

Shader "Unlit/Color_split_vertex"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (1,1,1,1)
		_Color2("Color 2", Color) = (1,1,1,1)
		_ColorChangePos("Color Change Pos", float) = 0.5
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata //data del mesh
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f //appDataClip
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					//we need to add a variable to the struct so that its value can be passed between the vert and the frag
					float4 selectedColor : TEXCOORD1; //we must assign an initial value
				};

				/*
				What is TEXCOORD?
				Texture coordinates and tell the shader how to map 2D texture onto a 3D object, based on UV mapping (U: horizontal, V: vertical axes).
				TEXCOORD0 is the first set of texture coordinates, ofted used to pass the main UV mapping for the texture.
				TEXCOORD1,2,etc are additional sets of texture coordinates, used for passing other data, 
				like secondary UV maps, custom vertex colors, or any other interpolated values you need between the vertex and the fragment shaders.

				What is the logic to apply? 
				Remember that the shader is applied per vertex. 
				Keeping this in mind, in the vertex shader, you assign data to these TEXCOORD slots. Then, the fragment shader
				reads the interpolated data through the same TEXCOORD slots. Each TEXCOORD slot can hold different types of data, 
				not just UVs. They are essentially registers that the GPU uses to transfer information 
				between the vertex and fragment shaders.

				*/

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _SelectedColor; //vert and frag pass doesn't share global variables
				float4 _Color1;
				float4 _Color2;
				float _ColorChangePos; 

				v2f vert(appdata v) //vertex to fragment!!!
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					
					//Trying to change color based on uv.y position of TEXCOORD0 and assign it value on TEXCOORD1
					if (o.uv.y <= _ColorChangePos)
					{
						o.selectedColor = _Color1;
					}
					else
					{
						o.selectedColor = _Color2;
					}
					/*
					Why does this work? 
					The TEXCOORDX interpolation registers are generic channels that allow storing any type of floating-point data or vector of 
					floating-point data (such as float2, float3, float4), and in this case, 
					a color can be represented as a float4 (RGBA), which fits perfectly with the type of data TEXCOORD1 accepts. 
					In reality, it's a memory space you can use to pass any interpolated data between the vertex shader and the fragment shader.
					*/

					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.uv);

					//asign the variable TEXCOORD1 stored on the v2f struct 
					col *= i.selectedColor; //this color will no longer be (0,0,0,0)

					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
			ENDCG
		}
	}
}