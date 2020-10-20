Shader "Custom/Edge"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Scale ("Scale", Range(0, 1)) = 0
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"
    
    float4 _Color;
    float _Scale;
    
    float4 frag(v2f_img i):SV_Target
    {
        float param = abs(sin(_Time.y));
        float4 c = float4(param, _Color.g, _Color.b, _Color.a);
        float up = step(i.uv.y, param/2);
        float down = step(1.0 - param/2, i.uv.y);
        float right = step(i.uv.x, param/2);
        float left = step(1.0 - param/2, i.uv.x);
        return c * (up + down + left + right);
    }
    ENDCG
    
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }   
    }
}
