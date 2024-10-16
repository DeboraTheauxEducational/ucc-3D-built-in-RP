Shader "Custom/RiverFlow"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Direction ("Direction", Vector) = (0,0,0,0)

        _DepthColor ("Depth Color", Color) = (1,1,1,1)
        _DepthTex ("Depth Albedo (RGB)", 2D) = "white" {}
        _DepthDirection ("Depth Direction", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _DepthTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float2 _Direction;
        fixed4 _DepthColor;
        float2 _DepthDirection;

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos; // posicion del pixel en la pantalla
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // tex2D funci�n que obtiene el color de un pixel en una posici�n de la textura.
            // MainTex textura base.
            // IN.uv_MainTex las coordenadas uv de la textura MainTex.
            // _Direction vector de direcci�n 
            // _Time.y del vector de tiempo (macro de Unity), se obtiene la coordenada "y" que indica los segundos.
            // este macro se utiliza para animaciones.
            // IN.uv_MainTex + _Direction * _Time.y => movemos la coordenada "x,y" veces en funci�n del tiempo,
            // lo que resulta en que el color del pixel se mueva hacia esa direcci�n.
            // En el tiempo 1 al pixel le toca el color rojo, en el tiempo 2 le toca el color azul, etc.
            // *_Color sirve para "te�ir" la textura y al estar multiplicado crea un "merge" entre el color de la textura y el de la variable Color.
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex + _Direction * _Time.y) * _Color;
            
            // Hacemos lo mismo para calcular el Foam
            // Invertimos los colores del Foam
            // La "cantidad" de espuma va a depender de ese 1 o 0.1 y queremos que sea en base a la "profundidad"
            // screenPos.w es un valor que suele ser inverso a la profundidad: a medida que el objeto est� m�s lejos de la c�mara, el valor w aumenta.
            //Si IN.screenPos.w = 1.0 (un pixel cerca de la c�mara)
            //Si IN.screenPos.w = 10.0 (un pixel m�s lejano)
            //Agregamos un divisor para controlar el valor de foam factor
            //Invertimos el factor para que sea proporcional a la profundidad.
            float foamFactor = (1 - IN.screenPos.w)/2;
            //Agregar foam factor para determinar que tanto hay que invertir el color en ese pixel
            fixed4 foamColor = foamFactor - tex2D(_DepthTex, IN.uv_MainTex + _DepthDirection * _Time.y) * _DepthColor;

            // "mergeamos" las texturas y colores: probar multiplicacion y suma y ver que sucede con el color negro (0,0,0,0)
            //Tomamos solo el canal rojo del foam (normalmente relacionado con la "altura")
            color += foamColor.r;


            o.Albedo = color.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
