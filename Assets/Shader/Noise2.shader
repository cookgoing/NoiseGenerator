Shader "Test/Noise2"
{
    SubShader
    {
        CGINCLUDE

        #include "UnityCG.cginc"
        
        float Noise(float2 uv)
        {
            //float i = uv.y * 20 + uv.x;
            //float ii = floor(i);
            //float ip = frac(i);
            //float r1 = frac(sin(ii) * 1000);
            //float r2 = frac(sin(ii + 1) * 1000);
            //return lerp(r1, r2, ip);

            // return fract(Mathf.Sin(Vector2.Dot(coord, new Vector2(12.9898f, 78.233f))) * 43758.5453f);

            float d = dot(uv, float2(12.9898, 78.233));
            float f = sin(d) * 43758.5453;
            return frac(f);
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
            float4 scrPos : TEXCOORD1;
        };

        v2f vert_value (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv * 20;
            return o;
        }

        fixed4 frag_value (v2f i) : SV_Target
        {
            //return fixed4(1,0,0,1);
            float2 uv_bl = floor(i.uv);
            float2 uv_br = floor(i.uv) + float2(1, 0);
            float2 uv_tl = floor(i.uv) + float2(0, 1);
            float2 uv_tr = floor(i.uv) + float2(1, 1);

            float n_bl = Noise(uv_bl);
            float n_br = Noise(uv_br);
            float n_tl = Noise(uv_tl);
            float n_tr = Noise(uv_tr);

            float xp = frac(i.uv.x);
            float yp = frac(i.uv.y);

            xp = xp * xp * (3 - 2 * xp);
            yp = yp * yp * (3 - 2 * yp);

            float cb = lerp(n_bl, n_br, xp);
            float ct = lerp(n_tl, n_tr, xp);
            float c = lerp(cb, ct, yp);

            return fixed4(c,c,c,1);
        }

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_value
            #pragma fragment frag_value

            ENDCG
        }
    }
}
