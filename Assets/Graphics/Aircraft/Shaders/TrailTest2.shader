Shader "Custom/TrailTest2"
{
	Properties
	{
		_Colour("Colour", Color) = (1,1,1,1)
		// _PhaseOffset("Phase Offset", Float) = 0
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

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
			};

			float4 _Colour;

			float _step(float i)
			{
				return (i < 0.5)? 0 :1 ;
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float phase = _Time * -400.0;
				o.vertex.y += sin(phase + v.uv.x*200) * 2 *v.uv.x ;//*-1*_step(sin(v.uv.x*5000));
				o.vertex.x += cos(phase + v.uv.x*200) * 2 *v.uv.x ;//*-1*_step(sin(v.uv.x*5000));
				//o.vertex.x += 1; 
				// o.vertex.x , o.vertex.y = o.vertex.y , o.vertex.x;
				o.uv = v.uv;//*2 + float2(-0.5,2.5); //float2(v.uv[1],v.uv[0]*200);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				return _Colour * float4(1-2*i.uv.x,1,1, clamp(1-3*i.uv.x,0,1));
			}
			ENDCG
		}
	}
}
