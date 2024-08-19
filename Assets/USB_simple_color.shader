Shader "Unlit/USB_simple_color" //Inspector path
{
    //ShaderLab declarative Language: global variables
    Properties //Inspector properties
    {
        //You can modify dynamically or at runetime.
        //PropertyName ("display name", trype) = defaultValue //syntax for declaring property
        _MainTex ("Texture", 2D) = "white" {}
        //Number ad slider properties
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3 //reflexión, espejo
        _Factor ("Color Factor", Float) = 0.3
        _CId ("Color Id", Int) = 2 
        // Short names (_CId) in CGPROGRAM reduce memory on GPU, improve performance, follow conventions, enhance readability in compact code, and ensure compatibility across platforms.
        _Color("Tint", Color) = (1,1,1,1)
        _VPos ("Vertex Position", Vector) = (0,0,0,1)
        _Reflection("Reflection", Cube) = "black" {} //Cubemap is useful for generating reflection maps like reflections on a character's armor or on metallic elements.
        _3DTexture("3D Texture", 3D) = "white" {} //Used less frequently \, have an additional coordinate for their spatial calculation.    

        //Drawers properties: can generate multple states allowing the creation of dynamic effects without the need to change material at execution time.
        //Generally used with two type of shader variants: #pragma multi_compile and #pragma shader_feature
        //Toggle: SharderLab does not support boolean type properties. Toggle allows switching from one state form another. It's an integer 0 = off, 1 = on
        [Toggle] _Enable ("Enable?", Float) = 0 //Why Float? This is because GPUs are highly optimized for floating-point operations, and working with floats is generally faster and more efficient.

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            //#pragma is a directive used to control the compilation process. These are used to specify which functions in your shader code should be treated as the vertex and fragment (or pixel) shaders.
            #pragma vertex vert //This tells the compiler that the "vert function" is the vertex shader
            #pragma fragment frag //This tells the compiler that the "frag function" is the fragment shader.
            // make fog work
            #pragma multi_compile_fog //Used to compile multiple versions of the shader with different keyword combinations, often for features that can be toggled on or off, like shadows, lighting models, etc.

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //Add connection variables: THE SAME NAME!!
            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;

            v2f vert (appdata v) // THIS IS THE VERTEX SHADER
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            //float4 exampleFunction()
            //{
            //    return (1, 1, 1, 1);
            //}

            fixed4 frag(v2f i) : SV_Target // THIS IS THE FRAGMENT SHADER
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                #if _ENABLE_ON
                return col * _Color;
                #else
                return col;
                #endif
                //float4 f = exampleFunction();
                //return f;
            }

            ENDCG
        }
    }
}
