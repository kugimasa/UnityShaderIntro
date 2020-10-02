Shader "Custom/Glow"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Speed ("Speed", Range(0.0, 2.0)) = 1.0
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    float _distanceStep;
    float _Speed;

    float4 frag(v2f_img i):SV_Target
    {
        float2 center = float2(0.5, 0.5);
        float step = abs(sin(_Time.y * _Speed));
        float d = (1.0 - distance(i.uv, center)) * step;
        return float4((i.uv.y + step) * d, (i.uv.x + step) * d, d, 1);
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
