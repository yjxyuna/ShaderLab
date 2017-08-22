Shader "Custom/PipeFlow"
{
//http://www.manew.com/thread-97247-1-1.html
//http://blog.csdn.net/candycat1992/article/details/51417965
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)

		[Space(10)] _Space("Space", Float) = 3

		[Space] _FlowSpeed("FlowSpeed", Float) = 0.2

		[Space][Toggle] _InvertDirection ("Invert Direction", Float) = 0

		[Space][Enum(Normal, 0, Flow, 1)] _State ("State", Float) = 0

		[Space] _Brightness("Brightness", Float) = 1
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode" = "vertex"}   //ForwardBase/vertex
		LOD 100


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile pipe_flow pipe_normal 
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			#define PI 3.14159

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				fixed3 worldNormal : Color0;
				float3 worldPos :TEXCOORD1;
				float3 color : Color1; 
			};

			fixed4 _Color;
			half _Space;
			half _FlowSpeed;
			half _InvertDirection;
			half _State;
			half _Brightness;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = ShadeVertexLights(v.vertex, v.normal);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(v.vertex, unity_WorldToObject).xyz;

				#ifdef pipe_normal  
	            o.uv = v.uv;
           		#endif  
           		#ifdef pipe_flow  
           		_InvertDirection = _InvertDirection * 2 - 1; //map value from[0, 1] to [-1, 1];
				o.uv = v.uv + float2(0.0, _Time.y) * _FlowSpeed * _InvertDirection;
            	#endif  

				return o;
			}

			fixed clamp01(fixed min, fixed max, fixed value) {
				return (value - min) / (max - min);
			}

			fixed4 halfLambert(fixed3 direction) {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 normalDir = normalize(direction);
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//对于每个顶点来说 光的位置就是光的方向 ，因为光是平行光
				float halfLambert = dot(normalDir, lightDir) * 0.5 + 0.5;
				fixed3 diffuse = _LightColor0.rgb * halfLambert;  //取得漫反射的颜色
				fixed3 tempColor = diffuse + ambient;
				return fixed4(tempColor, 1);
			}

			fixed4 test(v2f i) {
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
				fixed angle = dot(viewDir, normalize(i.worldNormal));
				if (angle > 0)// && i.uv.y > 0.2 && i.uv.y < 0.6)
					return fixed4(1, 0, 0, 1);
				else 
					return fixed4(1, 1, 1, 1);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				#ifdef pipe_normal  
	            
	            #endif  
	            #ifdef pipe_flow  

	            #endif  

	            if (_State == 1) {
	            	fixed min = 0.45;
					fixed max = 0.55;
				    float y = cos(_Space * 2.0 * PI * i.uv.y);
	                y = (y + 1.0) * 0.5;
	                fixed ret = clamp(y, min, max);
	                fixed4 color = lerp(_Color, fixed4(1, 1, 1, 1), clamp01(min, max, ret));
	                return halfLambert(i.worldNormal) * color * _Brightness;
	            } else {
	            	return halfLambert(i.worldNormal) * _Color * _Brightness;

//	            	return test(i);
	            }

				
			}
			ENDCG
		}
	}
}
