Shader "Custom/EmissionScrollingUV" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EmissionMap("Emission Map", 2D) = "black" {}
		_EmissionColor("Emission Color", Color) = (0,0,0)
		_TextureColor("Texture Color", Color) = (1, 1, 1, 1)
		_ScrollXSpeed("X Scroll Speed", Range(-5, 5)) = 0
		_ScrollYSpeed("Y Scroll Speed", Range(-5, 5)) = 0
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }

		CGPROGRAM
#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		sampler2D _EmissionMap;
		fixed3 _EmissionColor;
		fixed4 _TextureColor;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

	struct Input {
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		fixed varX = _ScrollXSpeed * _Time;
		fixed varY = _ScrollYSpeed * _Time;
		fixed2 uv_Tex = IN.uv_MainTex + fixed2(varX, varY);
		half4 c = tex2D(_MainTex, uv_Tex) * _TextureColor;
		o.Albedo = c.rgb;
		o.Emission = tex2D(_EmissionMap, IN.uv_MainTex).rgb *_EmissionColor.rgb;
		o.Alpha = c.a;
	}
	ENDCG
	}
		FallBack "Diffuse"
}