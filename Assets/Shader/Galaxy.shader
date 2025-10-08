Shader "Custom/InfiniteGalaxyPendant"
{
    Properties {
        _DepthScale ("Depth Scale", Float) = 1.0
        _LoopSpeed ("Loop Speed", Float) = 1.0
        _StarDensity ("Star Density", Range(0,1)) = 0.4
        _StarTwinkleSpeed ("Twinkle Speed", Float) = 1.0
        _StarSize ("Star Size", Float) = 0.03
        _BaseColor ("Base Color", Color) = (0.02,0.02,0.05,1)
        _StarColor ("Star Color", Color) = (1,1,1,1)
        _NebulaColor ("Nebula Color", Color) = (0.2,0.3,0.6,1)
        _NebulaIntensity ("Nebula Intensity", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
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
        fixed4 _NebulaColor;
        float _NebulaIntensity;

        float hash(float3 p)
        {
            p = frac(p * 0.3183099 + 0.1);
            p *= 17.0;
            return frac(p.x * p.y * (p.x + p.y));
        }

        float noise(float3 p)
        {
            float n = dot(p, float3(1.0, 57.0, 113.0));
            return frac(sin(n) * 43758.5453);
        }

        float smoothNoise(float3 p)
        {
            float3 i = floor(p);
            float3 f = frac(p);
            f = f * f * (3.0 - 2.0 * f);

            float n000 = noise(i + float3(0, 0, 0));
            float n100 = noise(i + float3(1, 0, 0));
            float n010 = noise(i + float3(0, 1, 0));
            float n110 = noise(i + float3(1, 1, 0));
            float n001 = noise(i + float3(0, 0, 1));
            float n101 = noise(i + float3(1, 0, 1));
            float n011 = noise(i + float3(0, 1, 1));
            float n111 = noise(i + float3(1, 1, 1));

            float nx00 = lerp(n000, n100, f.x);
            float nx10 = lerp(n010, n110, f.x);
            float nx01 = lerp(n001, n101, f.x);
            float nx11 = lerp(n011, n111, f.x);
            float nxy0 = lerp(nx00, nx10, f.y);
            float nxy1 = lerp(nx01, nx11, f.y);
            return lerp(nxy0, nxy1, f.z);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float3 dir = normalize(IN.viewDir);

            // 銀河の回転
            float angle = _Time.y * 0.05;
            float cosA = cos(angle);
            float sinA = sin(angle);
            float3 rotatedDir = float3(
                cosA * dir.x - sinA * dir.y,
                sinA * dir.x + cosA * dir.y,
                dir.z
            );

            // 星の分布
            float3 starCoord = rotatedDir * (1.0 / _StarSize);
            float starValue = hash(floor(starCoord));
            float starMask = smoothstep(1.0 - _StarDensity, 1.0, starValue);
            float twinkle = 0.5 + 0.5 * sin(_Time.y * _StarTwinkleSpeed + starValue * 20.0);
            float starBrightness = starMask * twinkle;

            // 星雲の柔らかいノイズ
            float nebula = smoothNoise(rotatedDir * 3.0 + _Time.y * _LoopSpeed);
            nebula = pow(nebula, 3.0) * _NebulaIntensity;

            // 色の合成
            float3 color = _BaseColor.rgb +
                           _NebulaColor.rgb * nebula +
                           _StarColor.rgb * starBrightness;

            o.Albedo = color;
            o.Emission = color * (starBrightness + nebula * 0.5);
            o.Alpha = 1.0;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
