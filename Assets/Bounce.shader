Shader "Custom/Bounce"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _posXSin ("posX Sin", Range(0.0, 2.0)) = 1.0
        _posYSin ("posY Sin", Range(0.0, 5.0)) = 1.0
        _posYCos ("posY Cos", Range(0.0, 5.0)) = 1.0
        _ballColor ("Ball Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    float _distanceStep;

    float _posXSin;
    float _posYSin;
    float _posYCos;

    float4 _ballColor;

    float4 frag(v2f_img i):SV_Target
    {
        float posX = abs(_posXSin * sin(_Time.y));
        float posY = abs(_posYSin * sin(_Time.y) + _posYCos * cos(_Time.y));
        float2 center = float2(posX, posY);
        float dist = distance(center, i.uv);
        float a = abs(sin(_Time.z)) * 0.4;
        float bounce = step(a, dist);
        return bounce + _ballColor;
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
