Shader "Test/NoiseCell"
{
    SubShader
    {
        CGINCLUDE
        #include "UnityCG.cginc"

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

        float2 Noise(float2 i){
            return -1 + 2 * frac(sin(float2(dot(i,float2(152.123,125.127)),dot(i,float2(112.123,156.12)))) * 1000);
        }

        float PointValue(float2 uv)
        {
            float2 pint = floor(uv);
            float2 coord = frac(uv);

            float distance = 1;
            float step = 10;
            for(float i = -step; i <= step; i++)
            {
                for(float j = -step; j <= step; j++)
                {
                    float2 offset = float2(i, j);
                    //float neighor = pint + offset;
                    float2 noisePoint = Noise(offset);
                    noisePoint = sin(_Time.x + 6.2831 * noisePoint) * 0.5 + 0.5;
                    distance = min(distance, length(noisePoint - coord));
                }
            }
            
            return distance;
        }

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv * 1;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 uv = i.uv;
            //return fixed4(floor(uv.x), 0, 0, 1);

            float c = PointValue(uv);
            return fixed4(c,c,c,1);
        }

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDCG
        }
    }
}
