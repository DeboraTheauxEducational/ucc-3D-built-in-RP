Shader "Custom/Texture_Rotation"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Rotation ("Texture Rotation (Degrees)", Float) = 0
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

        float2 RotateUV(float2 uv, float angle)
        {
            //Para rotar un vector2, se necesita de una matriz de rotación bidimesional. Dicha matriz es 2x2 
            //[cos, -sen]
            //[sen,  cos]
            //Por lo tanto necesitamos calcular el sen y cos del angulo

            //En HLSL se utiliza radianes para calcular dichas operaciones trigonometricas, por lo que primero debemos pasar el valor en grados a radianes.

            float radAngle = radians(angle);
            
            float cosAngle = cos(radAngle);
            float sinAngle = sin(radAngle);

            //Ahora si podemos crear la matriz de rotacion
            float2x2 rotationMatrix = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

            //Y solo nos queda multiplicar la matriz por el vector UV
            return mul(rotationMatrix, uv);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //ahora usamos la función para rotar los uv.

            float2 rotatedUV = RotateUV(IN.uv_MainTex, _Rotation);

            fixed4 c = tex2D (_MainTex, rotatedUV);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
