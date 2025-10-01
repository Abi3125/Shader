Shader "Custom/Galaxy"
{
    Properties {
        _DepthScale ("Depth Scale", Float) = 1.0
        _LoopSpeed ("Loop Speed", Float) = 1.0
        _StarDensity ("StarDensity", Float) = 0.5
        _StarTwinkleSpeed ("Twinkle Speed", Float) = 1.0
        _StarSize ("Star Size", Float) = 0.01
        _BaseColor ("Base Color", Color) = (0,0,0,1)
        _StarColor ("Star Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        #pragma target 3.0

        struct Input
        {
            float3 viewDir;
            float2 uv;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
        }
        ENDCG
    }
    Fallback "Diffuse"
}
