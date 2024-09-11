Shader "Unlit/Color_split_FACE_TO_CAMERA"
{
    Properties
    {
        //Add Properties
        _MainTex ("Texture", 2D) = "white" {}
        _ColorFront("Front Face Color", Color) = (1, 0, 0, 1) 
        _ColorBack("Back Face Color", Color) = (0, 1, 0, 1) 
        _ColorSide("Side Face Color", Color) = (0, 0, 1, 1) 
    
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            //Add global variables
            float4 _ColorFront;
            float4 _ColorBack;
            float4 _ColorSidr;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL; //Add normal data from mesh
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1; //Add TEXTCOORD1 to save world normal position
                float3 worldVertex : TEXCOORD2; //Add TEXTCOORD2 to save world vertex position
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
               v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // vertex position to Clip pos
                o.worldNormal = mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz; // normal to World Position using macros float3 to float4 an finally to float3
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // vertex position to World Space
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //calculate the distance between the camera position and vertex world position, to obtain the direction
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos); 

                 // A mathematical operation that takes two vectors and returns a scalar value. 
                 //This value indicates how aligned the two vectors are. 
                 //In this case, we measure how aligned the surface normal is with the direction toward the camera.
                float dotProd = dot(i.worldNormal, viewDir);
                //i.worldNormal: Determines the orientation of the object's face.
                //viewDir: The direction toward the camera from the perspective of each pixel.

                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
