Shader "Unlit/Color_4split_vertex_COLOR"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR; // Color to interpolate
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //Example on a square
                // Assign color based on the vertex position in local space.
                if (v.vertex.x < 0 && v.vertex.y > 0) // Vertex A
                    o.color = float4(1, 0, 0, 1); // Red
                else if (v.vertex.x > 0 && v.vertex.y > 0) // Vertex B
                    o.color = float4(0, 1, 0, 1); // Green
                else if (v.vertex.x < 0 && v.vertex.y < 0) // Vertex C
                    o.color = float4(0, 0, 1, 1); // Blue
                else // else vertex
                    o.color = float4(1, 1, 1, 1); // White

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}