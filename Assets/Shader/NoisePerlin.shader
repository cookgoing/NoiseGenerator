Shader "Test/NoisePerlin"
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
            float4 scrPos : TEXCOORD1;
        };

        float2 Noise(float2 i){
            return -1 + 2 * frac(sin(float2(dot(i,float2(152.123,125.127)),dot(i,float2(112.123,156.12)))) * 1000);
        }

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv * 10;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 uv = i.uv;

            float2 index = floor(uv);
            float2 coordinate = frac(uv);

            float buttomLeft = dot(Noise(index) ,coordinate - float2(0,0));
            float buttomRight = dot(Noise(index  + float2(1,0)), coordinate - float2(1,0));
            float TopLeft = dot(Noise(index  + float2(0,1)), coordinate - float2(0,1));
            float TopRight = dot(Noise(index  + float2(1,1)), coordinate - float2(1,1));

            float2 u = coordinate * coordinate * ( 3 - 2 * coordinate);

            float vx = lerp(buttomLeft ,buttomRight ,u.x);
            float vy = lerp(TopLeft ,TopRight ,u.x);
            float value = lerp(vx, vy, u.y);
            value = value * 0.5 + 0.5;

            return fixed4(value, value, value, 1);
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
