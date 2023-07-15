Shader "Unlit/vertexDisplacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude ("Amplitude", Range(0.1, 5.0)) = 1.0
        _Frequency ("Frequency", Range(0.1, 10.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #include "perlinNoise.cginc"
            #include "noiseSimplex.cginc"
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
                float yCoord : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Amplitude;
            float _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                float2 t;
                t.x = _Time;
                t.y = _Time;

                float freq = _Frequency;
                float amp = _Amplitude;

                v.vertex.y += snoise(v.vertex.xz / freq + 2 * t) * amp;
                o.yCoord = (v.vertex.y - _Amplitude) / (_Amplitude * 2) +1.0; // Normalize yCoord

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Define your color gradient based on height
                fixed4 colorLow = fixed4(0.0, 0.2, 0.6, 1.0); // Dark blue for low heights
                fixed4 colorHigh = fixed4(0, 0.451, 0.6,1.0); // Light blue for high heights

                // Interpolate the color based on the height
                fixed4 col = lerp(colorLow, colorHigh, i.yCoord);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }
    }
}
