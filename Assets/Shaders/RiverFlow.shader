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
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "ForceNoShadowCasting"="True"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha
        #pragma target 4.0

        //Tenemos que agregar la variable de la textura. Unity se encarga de asignarle un valor.
        sampler2D  _CameraDepthTexture;
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
            // tex2D función que obtiene el color de un pixel en una posición de la textura.
            // MainTex textura base.
            // IN.uv_MainTex las coordenadas uv de la textura MainTex.
            // _Direction vector de dirección 
            // _Time.y del vector de tiempo (macro de Unity), se obtiene la coordenada "y" que indica los segundos.
            // este macro se utiliza para animaciones.
            // IN.uv_MainTex + _Direction * _Time.y => movemos la coordenada "x,y" veces en función del tiempo,
            // lo que resulta en que el color del pixel se mueva hacia esa dirección.
            // En el tiempo 1 al pixel le toca el color rojo, en el tiempo 2 le toca el color azul, etc.
            // *_Color sirve para "teñir" la textura y al estar multiplicado crea un "merge" entre el color de la textura y el de la variable Color.
            fixed4 color = tex2D (_MainTex, IN.uv_MainTex + _Direction * _Time.y) * _Color;
            
            // Hacemos lo mismo para calcular el Foam
            // Invertimos los colores del Foam
            // La "cantidad" de espuma va a depender de ese 1 o 0.1 y queremos que sea en base a la "profundidad"
            // screenPos.w es un valor que suele ser inverso a la profundidad: a medida que el objeto está más lejos de la cámara, el valor w aumenta.
            //Si IN.screenPos.w = 1.0 (un pixel cerca de la cámara)
            //Si IN.screenPos.w = 10.0 (un pixel más lejano)
            //Agregamos un divisor para controlar el valor de foam factor
            //Invertimos el factor para que sea proporcional a la profundidad.
            //Invertimos toda la expresión para obtener lo siguiente:
            //Los fragmentos que están más cerca de la cámara resulten en un valor menor para foamFactor (cercano a 0).
            //Los fragmentos que están más lejos de la cámara resulten en un valor mayor para foamFactor (cercano a 1).

            //Ahora bien, queremos que esta profundidad se mida en base a la distancia con objetos de la escena, para eso se puede utilizar un macro que toma la textura de profundidad de la escena, capturada por la cámara.
            // Este macro es SAMPLE_DEPTH_TEXTURE_PROJ y tiene 2 argumentos: la textura y las coordenadas de la textura, similar a tex2D.
            //La posición de la textura de profundidad de la cámara que queremos obtener no es (1,1,1,1), es en relacion a la posicion del pixel en la proyeccion de la cámara.
            //UNITY_PROJ_COORD(IN.screenPos) toma las coordenadas en espacio de clip (como IN.screenPos) y realiza una corrección para pasar a coordenadas proyectadas, que son necesarias para realizar ciertos cálculos relacionados con la posición de los fragmentos en la pantalla.
            float4 sceneCoords = UNITY_PROJ_COORD(IN.screenPos);
            float sceneDepth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, sceneCoords);
            float foamFactor = 1 - ((sceneDepth -IN.screenPos.w)/2);
            //Agregar foam factor para determinar que tanto hay que invertir el color en ese pixel
            fixed4 foamColor = saturate(foamFactor - tex2D(_DepthTex, IN.uv_MainTex + _DepthDirection * _Time.y) * _DepthColor);

            // "mergeamos" las texturas y colores: probar multiplicacion y suma y ver que sucede con el color negro (0,0,0,0)
            //Tomamos solo el canal rojo del foam (normalmente relacionado con la "altura")
            color.rgb = lerp(color.rgb, foamColor, foamFactor);

            o.Albedo = color.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
