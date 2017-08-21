Shader "Custom/PipeFlow"
{
//http://www.manew.com/thread-97247-1-1.html
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_Space("Space", Float) = 3
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			#define PI 3.14159

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

			fixed4 _Color;
			half _Space;
			float ret;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float y = cos(_Space * 2.0 * PI * i.uv.y);
                y = (y + 1.0) * 0.5; // map [-1,1] to [0,1]
                ret = clamp(y, 0, 1);
                fixed3 color = fixed3(ret, ret, ret);

				return fixed4(color * _Color.rgb, 1);
			}
			ENDCG
		}
	}
}
