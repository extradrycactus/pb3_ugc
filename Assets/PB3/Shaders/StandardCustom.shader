Shader "Custom/StandardCustom"
{
	Properties
	{
		[MaterialToggle] _ColorBlind("Color Blind", Float) = 0
		_Stress("Stress", Range(0.0, 1.0)) = 0
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		//_StartHSV("StartHSV", Vector) = (0.35, 0.7, 0.7, 0)
		//_EndHSV("EndHSV", Vector) = (0.35, 0.7, 0.7, 0)
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

		sampler2D _MainTex;

	struct Input
	{
		float2 uv_MainTex;
	};

	uniform float _Stress;
	uniform float _ColorBlind;
	//float4 _StartHSV;
	//float4 _EndHSV;

	half _Glossiness;
	half _Metallic;
	fixed4 _Color;

	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
	// #pragma instancing_options assumeuniformscaling
	UNITY_INSTANCING_BUFFER_START(Props)
		// put more per-instance properties here
	UNITY_INSTANCING_BUFFER_END(Props)

		float3 hsv_to_rgb(float3 HSV)
	{
		float3 RGB = HSV.z;

		float var_h = HSV.x * 6;
		float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
		float var_1 = HSV.z * (1.0 - HSV.y);
		float var_2 = HSV.z * (1.0 - HSV.y * (var_h - var_i));
		float var_3 = HSV.z * (1.0 - HSV.y * (1 - (var_h - var_i)));
		if (var_i == 0) { RGB = float3(HSV.z, var_3, var_1); }
		else if (var_i == 1) { RGB = float3(var_2, HSV.z, var_1); }
		else if (var_i == 2) { RGB = float3(var_1, HSV.z, var_3); }
		else if (var_i == 3) { RGB = float3(var_1, var_2, HSV.z); }
		else if (var_i == 4) { RGB = float3(var_3, var_1, HSV.z); }
		else { RGB = float3(HSV.z, var_1, var_2); }

		return (RGB);
	}

	void surf(Input IN, inout SurfaceOutputStandard o)
	{
		if (_Stress > 0)
		{
			float clampedStress = min(1,_Stress); // (stress can exceed 1 in unbreakable mode so we clamp it)
			if (_ColorBlind > 0)
			{
				float3 hsv = float3((1 - clampedStress) * 0.35f, 0, (1 - clampedStress) * 0.9f); // color blind version
				o.Albedo = half3(hsv_to_rgb(hsv));
			}
			else
			{
				float3 hsv = float3((1 - clampedStress) * 0.30556f, 0.6f, 0.6f);
				//float3 hsv = lerp(_StartHSV, _EndHSV, clampedStress).xyz;
				o.Albedo = half3(hsv_to_rgb(hsv));
			}
		}
		else {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		}

		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = 1;
	}
	ENDCG
	}
	
	FallBack "Diffuse"
}