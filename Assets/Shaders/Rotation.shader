Shader "Custom/Rotation"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Rotation ("Rotation Degrees", Range(0,359)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float _Rotation;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        //Funcion que toma las coordenadas uv y un angulo y devuelve
        //las coordenadas uv rotadas 
        float2 RotateUV(float2 uv, float angle)
        {
            //para poder rotar un vector de 2 dimensiones
            //necesitamos Matriz de Rotacion de espacio bidimensional
            //[cos -sen]
            //[sen  cos]2x2

            float rad = radians(angle); //(angle*pi)/180
            float cosAngle = cos(rad);
            float sinAngle = sin(rad);
            float2x2 rotationMatrix = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

            //uv rotadas
            return mul(rotationMatrix, uv);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 rotatedUV = RotateUV(IN.uv_MainTex, _Rotation);

            fixed4 c = tex2D (_MainTex, rotatedUV);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
