Shader "Custom/Truss"
{
	Properties
	{
		[MaterialToggle] _ColorBlind("Color Blind", Float) = 0
		_Stress("Stress", Range(0.0, 1.0)) = 0
		_Color("Color", Color) = (1,1,1,1)
	}
		SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

		// compile shader into multiple variants, with and without shadows
		// (we don't care about any lightmaps yet, so skip these variants)
		#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
		// shadow helper functions and macros
		#include "AutoLight.cginc"

		struct v2f
		{
			//float2 uv : TEXCOORD0;
			SHADOW_COORDS(1) // put shadows data into TEXCOORD1
			fixed3 diff : COLOR0;
			fixed3 ambient : COLOR1;
			float4 pos : SV_POSITION;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			//o.uv = v.texcoord;
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			o.diff = nl * _LightColor0.rgb;
			o.ambient = ShadeSH9(half4(worldNormal,1));
			// compute shadows data
			TRANSFER_SHADOW(o)
			return o;
		}

		fixed4 _Color;
		uniform float _Stress;
		uniform float _ColorBlind;

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

		fixed4 frag(v2f i) : SV_Target
		{
			//fixed4 col = tex2D(_MainTex, i.uv);
			fixed4 col = _Color;
			// compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
			fixed shadow = SHADOW_ATTENUATION(i);

			float stressMultiplier = 0.7f;
			if (_Stress > 0)
			{
				if (_ColorBlind > 0)
				{
					float3 hsv = float3((1 - _Stress) * 0.35f, 0, (1 - _Stress) * 0.9f); // color blind version
					col.rgb = (hsv_to_rgb(hsv));
				}
				else
				{
					float3 hsv = float3((1 - _Stress) * 0.35f, 0.7f, 0.7f);
					col.rgb = (hsv_to_rgb(hsv));
				}

				return col;
			}
			else {
				// darken light's illumination with shadow, keep ambient intact
				fixed3 lighting = i.diff * shadow + i.ambient;
				col.rgb *= lighting;
				return col;
			}
		}
	ENDCG
}

// shadow casting support
UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}