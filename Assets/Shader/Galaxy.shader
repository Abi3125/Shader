Shader "Custom/InfiniteGalaxyPendant"
{
    Properties {
        _DepthScale ("Depth Scale", Float) = 1.0
        _LoopSpeed ("Loop Speed", Float) = 1.0
        _StarDensity ("Star Density", Float) = 0.5
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
        };

        float _DepthScale;
        float _LoopSpeed;
        float _StarDensity;
        float _StarTwinkleSpeed;
        float _StarSize;
        fixed4 _BaseColor;
        fixed4 _StarColor;

        float hash(float3 p)
        {
            p = frac(p * 0.3183099 + 0.1);
            p *= 17.0;
            return frac(p.x * p.y * (p.x + p.y));
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float3 dir = normalize(IN.viewDir);

            float depth = length(dir);
            float depthFactor = pow(1.0 - dir.z, _DepthScale);

            float loopCoord = frac(depth + _Time * _LoopSpeed);

            float angle = _Time * 0.1;
            float cosA = cos(angle);
            float sinA = sin(angle);
            float3 rotatedDir = float3(
                cosA * dir.x - sinA * dir.y,
                sinA * dir.x + cosA * dir.y,
                dir.z
            );

            float twinkle = sin(_Time * _StarTwinkleSpeed + depth * 10.0);

            float starPattern = step(1.0 - _StarDensity, hash(rotatedDir * 100.0));
            float starBrightness = starPattern * twinkle;

            float3 color = _BaseColor.rgb * (1.0 - depthFactor) + _StarColor.rgb * starBrightness;

            o.Albedo = color;
            o.Alpha = 1.0;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
