// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

shader "Bridges/PolyWaterShader"
{
	Properties{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Speed ("Speed", Float) = 0.5
		_Height ("Height", Range(0,1)) = 1
		_Color ("Main Color", Color) = (1,1,1,1)
		_Contrast ("Contrast", Range(0.0, 1.0)) = 1
	}
	SubShader{
		Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		//ZWrite Off
		//ZTest LEqual
		
		CGPROGRAM
		#pragma glsl
		#pragma surface surf Lambert vertex:vert alpha 
		#pragma target 3.0
		
		sampler2D _MainTex;
		half _Speed;
		float _Height;
		half4 _Color;
		uniform float _Contrast;
		
		struct Input{
			half2 uv_MainTex;
			//fixed3 vertColors;
			float3 worldPos : SV_POSITION;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
		};
		
		half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}
		
		float3 ContrastSaturationBrightness( float3 color, float brt, float sat, float con)
		{
			//RGB Color Channels
			float AvgLumR = 0.5;
			float AvgLumG = 0.5;
			float AvgLumB = 0.5;
			
			//Luminace Coefficients for brightness of image
			float3 LuminaceCoeff = float3(0.2125,0.7154,0.0721);
			
			//Brigntess calculations
			float3 AvgLumin = float3(AvgLumR,AvgLumG,AvgLumB);
			float3 brtColor = color * brt;
			float intensityf = dot(brtColor, LuminaceCoeff);
			float3 intensity = float3(intensityf, intensityf, intensityf);
			
			//Saturation calculation
			float3 satColor = lerp(intensity, brtColor, sat);
			
			//Contrast calculations
			float3 conColor = lerp(AvgLumin, satColor, con);
			
			return conColor;
		}
		
		float random( float2 p )
		{
			float2 r = float2(
			23.1406926327792690,  // e^pi (Gelfond's constant)
			2.6651441426902251); // 2^sqrt(2) (Gelfond–Schneider constant)
			return frac( cos( fmod( 123456789., 1e-7 + 256. * dot(p,r) ) ) );  
		}
		
		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
			//o.vertColors = v.color.rgb;
			
			float4 tex = tex2Dlod (_MainTex, float4(v.texcoord.xy,0,0));
			o.texcoord = v.texcoord.xy;
			float rippleOffset = ((tex.r - 0.5f ) * 3)  * _Height;
           
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            
			float sineOffset = ( sin(_Time.z * _Speed + worldPos.z * worldPos.x * 100) * 0.1f ) * _Height;
			
			if ( v.texcoord1.x != 0 )
			{
				v.vertex.y += rippleOffset;
				
				//if ( sineOffset * rippleOffset > 0 )
				
				v.vertex.y += sineOffset;
			}
				
			o.texcoord1.x = 0;
			o.texcoord1.y = v.texcoord1.y;
			
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			float t;
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			if ( IN.texcoord1.y == 0)
				t = 0;
			else
				t = (( sin(_Time.y * _Speed + IN.texcoord1.y * 9374.34f  ) + 1)  * 0.5f )  * _Height;
			t = clamp(t, 0 , 1);
			//float i = random(IN.worldPos) * 0.03f;
			if ( _Contrast < 1 )
			{
				float3 color = ContrastSaturationBrightness(_Color, 1, _Contrast, 1);
				o.Albedo = lerp(color, 1, t);// + half3(i,i,i);
				//o.Albedo = color;// + half3(i,i,i);// + half3(rand(IN.worldPos) * 0.05f);// + half3(0,1,0);
			}
			if ( _Contrast > 0 )
			{
			if ( IN.texcoord1.y != 0 )
			{
				half4 crestColor = lerp(_Color, 1, t * 0.2f);
				float rippleAmount = clamp(c - 0.5f, 0, 1);
				half4 rippledColor = lerp(crestColor, 1, rippleAmount * 1);
				if ( IN.texcoord1.y == 0)
					o.Albedo = crestColor;// + half3(i,i,i);
				else
					o.Albedo = rippledColor;
					}
					else
					{
						if ( _Contrast < 1 )
						{
							float3 color = ContrastSaturationBrightness(_Color, 1, _Contrast, 1);
							o.Albedo = lerp(color, 1, t);
						}
						else
						{
							o.Albedo = _Color;
						}
					}
			}
			
			o.Alpha = lerp(0.6f,_Color.a, _Height);//0.45f + _Height * 0.45f;
			o.Specular = 1;
			
			
			//o.Albedo = c.rgb;	
			
			o.Gloss = 0;
		}
		
		ENDCG
	}
} 