Shader "Custom/YinYang"
{
    Properties
    {
        _Color_Yin ("Color_Yin", Color) = (1,1,1,1)
        _Color_Yan ("Color_Yan", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Dot_Radius ("DotRadius", Range(0, 1)) = 0.5
        _Outline ("Outline", Range(0, 0.5)) = 0.01
        _RotSpeed ("RotationSpeed", Range(1, 5)) = 1
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    #define PI 3.14159265359

    float4 _Color_Yin;
    float4 _Color_Yang;
    float _RotSpeed;
    float _Dot_Radius;
    float _Outline;
    int _count = 0;


    float2 rotation(float2 p, float theta){
	    return float2((p.x) * cos(theta) - p.y * sin(theta), p.x * sin(theta) +  p.y * cos(theta));
    }
    
    float4 frag(v2f_img i):SV_Target
    {
        float angle = (sin(_Time.z) + cos(_Time.z) * cos(_Time.z)) * _RotSpeed;
        _Outline =  abs(sin(_Time.z)) * _Outline;
        float2 center = float2(0.5f, 0.5f);
        i.uv = rotation(0.5 - i.uv, angle) + 0.5;
        float outline_r = 0.5f;
        float base_r = outline_r - _Outline;
        float dot_center_y = (base_r)/2 + _Outline;

        float2 center_yin = float2(0.5f, dot_center_y);
        float2 center_yang = float2(0.5f, 1.0f - dot_center_y);
        float dot_yin = step(distance(center_yang, i.uv),_Dot_Radius);
        float dot_yang = step(distance(center_yin, i.uv),_Dot_Radius);
        float circle_yin = step(distance(center_yin, i.uv), base_r/2);
        float circle_yang = step(distance(center_yang, i.uv), base_r/2);
        float base_circle_yin = step(distance(center, i.uv), base_r);
        if (i.uv.x >= 0.5f)
        {
            base_circle_yin = 0;
        }
        float outline_circle = step(distance(center, i.uv), outline_r);
        return step(1, outline_circle - base_circle_yin - circle_yin + circle_yang) - dot_yin + dot_yang;
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
