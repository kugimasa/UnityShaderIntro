Shader "Custom/Wiggle"
{
    Properties
    {
        _sin_step ("SinStep", Range(0,10)) = 0.0
        _blue ("Blue", Range(0,1.0)) = 0.0
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    float _sin_step;
    float _blue;
    #define PI 3.14159265359
    
    float diag(float2 uv)
    {
        float2 st = sin(_Time.y) - uv;
        return atan2(st.y, st.x);
    }

    float distort(float2 uv)
    {
        float x = 2 * uv.y + sin(_Time.z);
        return sin(_Time.y * 2) * 0.1 * sin(5 * x) * (-(x - 1) * (x - 1) + 1);
    }
    
    float4 frag(v2f_img i):SV_Target
    {   
        float shake = distort(i.uv);
        i.uv.x += shake;
        float alpha = diag(i.uv);
        float cos_step = cos(_Time.y/5) * 2.0;
        float d = step(min(abs(sin(alpha * _sin_step)), abs(cos(alpha * cos_step))),0.4);
        return float4(abs(sin(d)), abs(cos(d)), _blue, 1);
    }
    ENDCG
    
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }   
    }
}
