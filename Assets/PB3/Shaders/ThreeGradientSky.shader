Shader "Custom/ThreeGradientUnlit"
{
		Properties
		{
			_ColorTop("Top Color", Color) = (1,1,1,1)
			_ColorMid("Mid Color", Color) = (1,1,1,1)
			_ColorBot("Bot Color", Color) = (1,1,1,1)
			_Middle("Middle", Range(0.001, 0.999)) = 1
			_MainTex("Texture", 2D) = "white" {}
		}

		SubShader
		{
			Tags{ "RenderType" = "Opaque" }
			LOD 100
			Zwrite On

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _ColorTop;
			fixed4 _ColorMid;
			fixed4 _ColorBot;
			float  _Middle;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = lerp(_ColorBot, _ColorMid, i.screenPos.y / _Middle) * step(i.screenPos.y, _Middle);
				col += lerp(_ColorMid, _ColorTop, (i.screenPos.y - _Middle) / (1 - _Middle)) * (1 - step(i.screenPos.y, _Middle));
				return col;
			}

			ENDCG
		}
	}
}