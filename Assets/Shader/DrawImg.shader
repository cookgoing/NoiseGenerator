Shader "Test/DrawImg"
{
    Properties
    {
        _LineScale ("line scale", Float) = 0.1
    }

    SubShader
    {
        CGINCLUDE

        #include "UnityCG.cginc"

        float _LineScale;

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

        v2f vert_sin(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.scrPos = ComputeScreenPos(o.vertex);//[0, 1]
            return o;
        }

        fixed4 frag_sin(v2f i) : SV_Target
        {
            float y = sin(i.scrPos.x * 3.14 *10);
            if (i.scrPos.y >= y - _LineScale && i.scrPos.y <= y + _LineScale)
            {
                return fixed4(1,0,0,1);
            }
            else
            {
                return fixed4(1,1,1,1);
            }
        }

        
        float Noise(float x)
        {
            float xi = floor(x);
            float xp = frac(x);
            float y1 = sin(xi) * 1000;
            float y2 = sin(xi + 1) * 1000;
            float y1p = frac(y1);
            float y2p = frac(y2);
            float u = xp * xp * (3 - 2 * xp);
            float y = lerp(y1p, y2p, u);
            return y;
        }

        v2f vert_random1(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.scrPos = v.vertex * float4(10, 2,1,1);
            return o;
        }

        fixed4 frag_random1(v2f i) : SV_Target
        {
            float y = Noise(i.scrPos.x);

            if (i.scrPos.y >= y - _LineScale && i.scrPos.y <= y + _LineScale)
            {
                return fixed4(1,0,0,1);
            }
            else
            {
                return fixed4(1,1,1,1);
            }
        }

        v2f vert_wave(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.scrPos = v.vertex * float4(10, 2,1,1);
            o.uv = v.uv;
            return o;
        }

        fixed4 frag_wave(v2f i) : SV_Target
        {
            float y = Noise(i.scrPos.x + _Time.y * 5);
            
            float color = step(y, i.scrPos.y);
            return fixed4(color,color,color,1);
        }

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_wave
            #pragma fragment frag_wave

            //v2f vert (appdata v)
            //{
            //    v2f o;
            //    o.vertex = UnityObjectToClipPos(v.vertex);
            //    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            //    return o;
            //}

            //fixed4 frag (v2f i) : SV_Target
            //{
            //    fixed4 col = tex2D(_MainTex, i.uv);
            //    return col;
            //}
            ENDCG
        }
    }
}
