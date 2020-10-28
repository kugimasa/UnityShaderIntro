Shader "Custom/Trichromatic"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RotSpeed ("RotationSpeed", Range(1, 5)) = 1
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    #define PI 3.14159265359
    
    float _RotSpeed;
    
    float4 frag(v2f_img i):SV_Target
    {
        float angle = _Time.y * _RotSpeed;
        float2 center = float2(0.5f, 0.5f);
        float2 vert1 = center - float2(cos(PI/2 + angle), sin(PI/2 + angle));
        float2 vert2 = center - float2(cos(7 * PI/6 + angle), sin(7 * PI/6 + angle));
        float2 vert3 = center - float2(cos(11 * PI/6 + angle), sin(11 * PI/6 + angle));
        float dist1 = step(distance(vert1, i.uv), abs(sin(_Time.y)));
        float dist2 = step(distance(vert2, i.uv), abs(sin(_Time.y)));
        float dist3 = step(distance(vert3, i.uv), abs(sin(_Time.y)));

        return float4(dist1, dist2, dist3, 1.0f);
        
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
