Shader "Custom/ScanLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OpacityScanLine ("Opacity ScanLine", Range(0, 2)) = 0.8
        _OpacityNoise ("Opacity Noise", Range(0, 1)) = 0.1
        _FlickeringSpeed ("Flickering Speed", Range(0, 1000)) = 600
        _FlickeringStrength ("Flickering Strength", Range(0, 0.1)) = 0.02
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float random (float2 st) {
                return frac(sin(dot(st.xy, float2(12.9898,78.233)))*43758.5453123);
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            half _OpacityScanLine;
            half _OpacityNoise;
            half _FlickeringSpeed;
            half _FlickeringStrength; 

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 img = tex2D(_MainTex, i.uv);
                float3 col = float3(0, 0, 0);
                float s = sin(i.uv.y * 1000);
                float c = cos(i.uv.y * 1000);
                col += float3(c, s, c) * _OpacityScanLine;

                float r = random(i.uv*_Time);
                col += float3(r, r, r) * _OpacityNoise;

                float flash = sin(_FlickeringSpeed*_Time);
                col += float3(flash, flash, flash) * _FlickeringStrength;
                return img * float4(col, 1.0);
            }
            ENDCG
        }
    }
}
