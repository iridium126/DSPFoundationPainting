Shader "VF Shaders/Forward/Terrain Reform"
{
	Properties
	{
		_SpeclColor ("高光颜色", Color) = (0,0,0,0)
		_LightColorScreen ("阳光颜色（滤色）", Color) = (0,0,0,1)
		_AmbientColor0 ("Ambient Color 0", Color) = (0,0,0,0)
		_AmbientColor1 ("Ambient Color 1", Color) = (0,0,0,0)
		_AmbientColor2 ("Ambient Color 2", Color) = (0,0,0,0)
		_GIStrengthDay ("全局光照（白天）", Range(0, 1)) = 1
		_GIStrengthNight ("全局光照（夜晚）", Range(0, 1)) = 0.2
		_GISaturate ("全局光照饱和度", Range(0, 2)) = 1
		_Multiplier ("Multiplier", Float) = 1
		_AmbientInc ("Ambient Increase", Float) = 1
		_AlphaMultiplier ("Alpha Multiplier", Float) = 1
		_EmissionStrength ("Emission Strength", Float) = 0
		_MetallicMultiplier ("Metallic", Float) = 1
		_SmoothnessMultiplier ("Smoothness", Float) = 1
		_MaterialIndex ("Material Index", Float) = 0
		_ColorsTexture ("Colors Texture", 2D) = "white" {}
		_AlbedoTex1 ("Albedo Texture 1", 2D) = "white" {}
		_NormalTex1 ("Normal Texture 1", 2D) = "bump" {}
		_EmissionTex1 ("Emission Texture 1", 2D) = "black" {}
		_AlbedoTex2 ("Albedo Texture 2", 2D) = "white" {}
		_NormalTex2 ("Normal Texture 2", 2D) = "bump" {}
		_EmissionTex2 ("Emission Texture 2", 2D) = "black" {}
		_AlbedoTex3 ("Albedo Texture 3", 2D) = "white" {}
		_NormalTex3 ("Normal Texture 3", 2D) = "bump" {}
		_EmissionTex3 ("Emission Texture 3", 2D) = "black" {}
		_Distance ("Distance", Float) = 0
		_SunDir ("Sun Dir", Vector) = (0,1,0,0)
		_Rotation ("Rotation ", Vector) = (0,0,0,1)
		_LatitudeCount ("Latitude Count", Float) = 500
		_PaintingTexture ("Painting Texture", 2D) = "transparent" {}
	}
	SubShader
	{
		LOD 200
		Tags { "DisableBatching" = "true" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
		GrabPass { "_ReformGrab" }
		Pass
		{
			Name "FORWARD"
			LOD 200
			Tags { "DisableBatching" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }

			HLSLPROGRAM

			// https://docs.unity3d.com/Manual/SL-PragmaDirectives.html
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			/*#pragma shader_feature DIRECTIONAL
			#pragma multi_compile _ LIGHTPROBE_SH
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON*/
			#define DIRECTIONAL


			#ifdef DIRECTIONAL
			#ifndef LIGHTPROBE_SH
			#ifndef SHADOWS_SCREEN
			#ifndef VERTEXLIGHT_ON
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_76 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_78 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_79 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_106 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_108 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_117 = vertex_unnamed_106 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_119 = vertex_unnamed_108 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_120 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].w)) + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_128 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_129 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_130 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_171 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_172 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_173 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_174 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_171;
				gl_Position.y = vertex_unnamed_172;
				gl_Position.z = vertex_unnamed_173;
				gl_Position.w = vertex_unnamed_174;
				float vertex_unnamed_183 = rsqrt(dot(float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79), float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79)));
				float vertex_unnamed_184 = vertex_unnamed_183 * vertex_unnamed_79;
				float vertex_unnamed_185 = vertex_unnamed_183 * vertex_unnamed_76;
				float vertex_unnamed_186 = vertex_unnamed_183 * vertex_unnamed_78;
				vertex_output_4.x = vertex_unnamed_76;
				vertex_output_4.y = vertex_unnamed_78;
				vertex_output_4.z = vertex_unnamed_79;
				float vertex_unnamed_199 = mad(vertex_unnamed_186, 0.0f, (-0.0f) - (vertex_unnamed_184 * 1.0f));
				float vertex_unnamed_201 = mad(vertex_unnamed_185, 1.0f, (-0.0f) - (vertex_unnamed_186 * 0.0f));
				bool vertex_unnamed_207 = sqrt(dot(float2(vertex_unnamed_199, vertex_unnamed_201), float2(vertex_unnamed_199, vertex_unnamed_201))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_214 = asfloat(vertex_unnamed_207 ? 1065353216u : asuint(vertex_unnamed_199));
				float vertex_unnamed_218 = asfloat(vertex_unnamed_207 ? 0u : asuint(vertex_unnamed_201));
				float vertex_unnamed_222 = rsqrt(dot(float2(vertex_unnamed_214, vertex_unnamed_218), float2(vertex_unnamed_214, vertex_unnamed_218)));
				float vertex_unnamed_223 = vertex_unnamed_222 * vertex_unnamed_214;
				float vertex_unnamed_224 = vertex_unnamed_222 * asfloat(vertex_unnamed_207 ? 0u : asuint(mad(vertex_unnamed_184, 0.0f, (-0.0f) - (vertex_unnamed_185 * 0.0f))));
				float vertex_unnamed_225 = vertex_unnamed_222 * vertex_unnamed_218;
				float vertex_unnamed_239 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_223, vertex_unnamed_225 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_240 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_223, vertex_unnamed_225 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_241 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_223, vertex_unnamed_225 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_245 = rsqrt(dot(float3(vertex_unnamed_239, vertex_unnamed_240, vertex_unnamed_241), float3(vertex_unnamed_239, vertex_unnamed_240, vertex_unnamed_241)));
				float vertex_unnamed_246 = vertex_unnamed_245 * vertex_unnamed_239;
				float vertex_unnamed_247 = vertex_unnamed_245 * vertex_unnamed_240;
				float vertex_unnamed_248 = vertex_unnamed_245 * vertex_unnamed_241;
				vertex_output_1.x = vertex_unnamed_248;
				float vertex_unnamed_262 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_277 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_292 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_298 = rsqrt(dot(float3(vertex_unnamed_292, vertex_unnamed_262, vertex_unnamed_277), float3(vertex_unnamed_292, vertex_unnamed_262, vertex_unnamed_277)));
				float vertex_unnamed_299 = vertex_unnamed_298 * vertex_unnamed_292;
				float vertex_unnamed_300 = vertex_unnamed_298 * vertex_unnamed_262;
				float vertex_unnamed_301 = vertex_unnamed_298 * vertex_unnamed_277;
				float vertex_unnamed_317 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_317 * mad(vertex_unnamed_301, vertex_unnamed_247, (-0.0f) - (vertex_unnamed_246 * vertex_unnamed_299));
				vertex_output_1.z = vertex_unnamed_300;
				vertex_output_1.w = vertex_unnamed_128;
				vertex_output_2.z = vertex_unnamed_301;
				vertex_output_3.z = vertex_unnamed_299;
				vertex_output_2.x = vertex_unnamed_246;
				vertex_output_3.x = vertex_unnamed_247;
				vertex_output_2.w = vertex_unnamed_129;
				vertex_output_2.y = vertex_unnamed_317 * mad(vertex_unnamed_299, vertex_unnamed_248, (-0.0f) - (vertex_unnamed_247 * vertex_unnamed_300));
				vertex_output_3.y = vertex_unnamed_317 * mad(vertex_unnamed_300, vertex_unnamed_246, (-0.0f) - (vertex_unnamed_248 * vertex_unnamed_301));
				vertex_output_3.w = vertex_unnamed_130;
				vertex_output_10.x = vertex_unnamed_128;
				vertex_output_10.y = vertex_unnamed_129;
				vertex_output_10.z = vertex_unnamed_130;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_223;
				vertex_output_6.y = vertex_unnamed_224;
				vertex_output_6.z = vertex_unnamed_225;
				float vertex_unnamed_365 = mad(vertex_input_1.y, vertex_unnamed_225, (-0.0f) - (vertex_unnamed_224 * vertex_input_1.z));
				float vertex_unnamed_366 = mad(vertex_input_1.z, vertex_unnamed_223, (-0.0f) - (vertex_unnamed_225 * vertex_input_1.x));
				float vertex_unnamed_367 = mad(vertex_input_1.x, vertex_unnamed_224, (-0.0f) - (vertex_unnamed_223 * vertex_input_1.y));
				float vertex_unnamed_371 = rsqrt(dot(float3(vertex_unnamed_365, vertex_unnamed_366, vertex_unnamed_367), float3(vertex_unnamed_365, vertex_unnamed_366, vertex_unnamed_367)));
				vertex_output_7.x = vertex_unnamed_371 * vertex_unnamed_365;
				vertex_output_7.y = vertex_unnamed_371 * vertex_unnamed_366;
				vertex_output_7.z = vertex_unnamed_371 * vertex_unnamed_367;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_389 = vertex_unnamed_174 * 0.5f;
				vertex_output_9.z = vertex_unnamed_173;
				vertex_output_9.w = vertex_unnamed_174;
				vertex_output_9.x = vertex_unnamed_389 + (vertex_unnamed_171 * 0.5f);
				vertex_output_9.y = vertex_unnamed_389 + (vertex_unnamed_172 * (-0.5f));
				vertex_output_11.x = 0.0f;
				vertex_output_11.y = 0.0f;
				vertex_output_11.z = 0.0f;
				vertex_output_12.x = 0.0f;
				vertex_output_12.y = 0.0f;
				vertex_output_12.z = 0.0f;
				vertex_output_12.w = 0.0f;
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // !LIGHTPROBE_SH
			#endif // !SHADOWS_SCREEN
			#endif // !VERTEXLIGHT_ON


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifndef SHADOWS_SCREEN
			#ifndef VERTEXLIGHT_ON
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 unity_SHAr;
			float4 unity_SHAg;
			float4 unity_SHAb;
			float4 unity_SHBr;
			float4 unity_SHBg;
			float4 unity_SHBb;
			float4 unity_SHC;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[46];
			static float4 vertex_uniform_buffer_2[10];
			static float4 vertex_uniform_buffer_3[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_81 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_83 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_84 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_111 = mad(vertex_uniform_buffer_2[2u].x, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].x));
				float vertex_unnamed_112 = mad(vertex_uniform_buffer_2[2u].y, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].y));
				float vertex_unnamed_113 = mad(vertex_uniform_buffer_2[2u].z, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].z));
				float vertex_unnamed_122 = vertex_unnamed_111 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_123 = vertex_unnamed_112 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_124 = vertex_unnamed_113 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_125 = mad(vertex_uniform_buffer_2[2u].w, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].w, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].w)) + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_133 = mad(vertex_uniform_buffer_2[3u].x, vertex_input_0.w, vertex_unnamed_111);
				float vertex_unnamed_134 = mad(vertex_uniform_buffer_2[3u].y, vertex_input_0.w, vertex_unnamed_112);
				float vertex_unnamed_135 = mad(vertex_uniform_buffer_2[3u].z, vertex_input_0.w, vertex_unnamed_113);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[20u].x, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].x, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].x, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].x)));
				float vertex_unnamed_177 = mad(vertex_uniform_buffer_3[20u].y, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].y, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].y, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].y)));
				float vertex_unnamed_178 = mad(vertex_uniform_buffer_3[20u].z, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].z, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].z, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].z)));
				float vertex_unnamed_179 = mad(vertex_uniform_buffer_3[20u].w, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].w, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].w, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].w)));
				gl_Position.x = vertex_unnamed_176;
				gl_Position.y = vertex_unnamed_177;
				gl_Position.z = vertex_unnamed_178;
				gl_Position.w = vertex_unnamed_179;
				float vertex_unnamed_188 = rsqrt(dot(float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84), float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84)));
				float vertex_unnamed_189 = vertex_unnamed_188 * vertex_unnamed_84;
				float vertex_unnamed_190 = vertex_unnamed_188 * vertex_unnamed_81;
				float vertex_unnamed_191 = vertex_unnamed_188 * vertex_unnamed_83;
				vertex_output_4.x = vertex_unnamed_81;
				vertex_output_4.y = vertex_unnamed_83;
				vertex_output_4.z = vertex_unnamed_84;
				float vertex_unnamed_204 = mad(vertex_unnamed_191, 0.0f, (-0.0f) - (vertex_unnamed_189 * 1.0f));
				float vertex_unnamed_206 = mad(vertex_unnamed_190, 1.0f, (-0.0f) - (vertex_unnamed_191 * 0.0f));
				bool vertex_unnamed_212 = sqrt(dot(float2(vertex_unnamed_204, vertex_unnamed_206), float2(vertex_unnamed_204, vertex_unnamed_206))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_219 = asfloat(vertex_unnamed_212 ? 1065353216u : asuint(vertex_unnamed_204));
				float vertex_unnamed_223 = asfloat(vertex_unnamed_212 ? 0u : asuint(vertex_unnamed_206));
				float vertex_unnamed_227 = rsqrt(dot(float2(vertex_unnamed_219, vertex_unnamed_223), float2(vertex_unnamed_219, vertex_unnamed_223)));
				float vertex_unnamed_228 = vertex_unnamed_227 * vertex_unnamed_219;
				float vertex_unnamed_229 = vertex_unnamed_227 * asfloat(vertex_unnamed_212 ? 0u : asuint(mad(vertex_unnamed_189, 0.0f, (-0.0f) - (vertex_unnamed_190 * 0.0f))));
				float vertex_unnamed_230 = vertex_unnamed_227 * vertex_unnamed_223;
				float vertex_unnamed_244 = mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].y);
				float vertex_unnamed_245 = mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].z);
				float vertex_unnamed_246 = mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].x);
				float vertex_unnamed_250 = rsqrt(dot(float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246), float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246)));
				float vertex_unnamed_251 = vertex_unnamed_250 * vertex_unnamed_244;
				float vertex_unnamed_252 = vertex_unnamed_250 * vertex_unnamed_245;
				float vertex_unnamed_253 = vertex_unnamed_250 * vertex_unnamed_246;
				vertex_output_1.x = vertex_unnamed_253;
				float vertex_unnamed_267 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[4u].xyz));
				float vertex_unnamed_282 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[5u].xyz));
				float vertex_unnamed_297 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[6u].xyz));
				float vertex_unnamed_303 = rsqrt(dot(float3(vertex_unnamed_267, vertex_unnamed_282, vertex_unnamed_297), float3(vertex_unnamed_267, vertex_unnamed_282, vertex_unnamed_297)));
				float vertex_unnamed_304 = vertex_unnamed_303 * vertex_unnamed_267;
				float vertex_unnamed_305 = vertex_unnamed_303 * vertex_unnamed_282;
				float vertex_unnamed_306 = vertex_unnamed_303 * vertex_unnamed_297;
				float vertex_unnamed_322 = vertex_input_2.w * vertex_uniform_buffer_2[9u].w;
				vertex_output_1.y = vertex_unnamed_322 * mad(vertex_unnamed_305, vertex_unnamed_252, (-0.0f) - (vertex_unnamed_251 * vertex_unnamed_306));
				vertex_output_1.w = vertex_unnamed_133;
				vertex_output_1.z = vertex_unnamed_304;
				vertex_output_2.x = vertex_unnamed_251;
				vertex_output_3.x = vertex_unnamed_252;
				vertex_output_2.w = vertex_unnamed_134;
				vertex_output_2.y = vertex_unnamed_322 * mad(vertex_unnamed_306, vertex_unnamed_253, (-0.0f) - (vertex_unnamed_252 * vertex_unnamed_304));
				vertex_output_3.y = vertex_unnamed_322 * mad(vertex_unnamed_304, vertex_unnamed_251, (-0.0f) - (vertex_unnamed_253 * vertex_unnamed_305));
				vertex_output_2.z = vertex_unnamed_305;
				vertex_output_3.w = vertex_unnamed_135;
				vertex_output_10.x = vertex_unnamed_133;
				vertex_output_10.y = vertex_unnamed_134;
				vertex_output_10.z = vertex_unnamed_135;
				vertex_output_3.z = vertex_unnamed_306;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_228;
				vertex_output_6.y = vertex_unnamed_229;
				vertex_output_6.z = vertex_unnamed_230;
				float vertex_unnamed_370 = mad(vertex_input_1.y, vertex_unnamed_230, (-0.0f) - (vertex_unnamed_229 * vertex_input_1.z));
				float vertex_unnamed_371 = mad(vertex_input_1.z, vertex_unnamed_228, (-0.0f) - (vertex_unnamed_230 * vertex_input_1.x));
				float vertex_unnamed_372 = mad(vertex_input_1.x, vertex_unnamed_229, (-0.0f) - (vertex_unnamed_228 * vertex_input_1.y));
				float vertex_unnamed_376 = rsqrt(dot(float3(vertex_unnamed_370, vertex_unnamed_371, vertex_unnamed_372), float3(vertex_unnamed_370, vertex_unnamed_371, vertex_unnamed_372)));
				vertex_output_7.x = vertex_unnamed_376 * vertex_unnamed_370;
				vertex_output_7.y = vertex_unnamed_376 * vertex_unnamed_371;
				vertex_output_7.z = vertex_unnamed_376 * vertex_unnamed_372;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_394 = vertex_unnamed_179 * 0.5f;
				vertex_output_9.z = vertex_unnamed_178;
				vertex_output_9.w = vertex_unnamed_179;
				vertex_output_9.x = vertex_unnamed_394 + (vertex_unnamed_176 * 0.5f);
				vertex_output_9.y = vertex_unnamed_394 + (vertex_unnamed_177 * (-0.5f));
				float vertex_unnamed_405 = mad(vertex_unnamed_304, vertex_unnamed_304, (-0.0f) - (vertex_unnamed_305 * vertex_unnamed_305));
				float vertex_unnamed_406 = vertex_unnamed_305 * vertex_unnamed_304;
				float vertex_unnamed_407 = vertex_unnamed_306 * vertex_unnamed_305;
				float vertex_unnamed_408 = vertex_unnamed_306 * vertex_unnamed_306;
				float vertex_unnamed_409 = vertex_unnamed_304 * vertex_unnamed_306;
				float vertex_unnamed_449 = asfloat(1065353216u);
				vertex_output_11.x = mad(vertex_uniform_buffer_1[45u].x, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[42u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[39u]), float4(vertex_unnamed_304, vertex_unnamed_305, vertex_unnamed_306, vertex_unnamed_449));
				vertex_output_11.y = mad(vertex_uniform_buffer_1[45u].y, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[43u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[40u]), float4(vertex_unnamed_304, vertex_unnamed_305, vertex_unnamed_306, vertex_unnamed_449));
				vertex_output_11.z = mad(vertex_uniform_buffer_1[45u].z, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[44u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[41u]), float4(vertex_unnamed_304, vertex_unnamed_305, vertex_unnamed_306, vertex_unnamed_449));
				vertex_output_12.x = 0.0f;
				vertex_output_12.y = 0.0f;
				vertex_output_12.z = 0.0f;
				vertex_output_12.w = 0.0f;
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[39] = float4(unity_SHAr[0], unity_SHAr[1], unity_SHAr[2], unity_SHAr[3]);

				vertex_uniform_buffer_1[40] = float4(unity_SHAg[0], unity_SHAg[1], unity_SHAg[2], unity_SHAg[3]);

				vertex_uniform_buffer_1[41] = float4(unity_SHAb[0], unity_SHAb[1], unity_SHAb[2], unity_SHAb[3]);

				vertex_uniform_buffer_1[42] = float4(unity_SHBr[0], unity_SHBr[1], unity_SHBr[2], unity_SHBr[3]);

				vertex_uniform_buffer_1[43] = float4(unity_SHBg[0], unity_SHBg[1], unity_SHBg[2], unity_SHBg[3]);

				vertex_uniform_buffer_1[44] = float4(unity_SHBb[0], unity_SHBb[1], unity_SHBb[2], unity_SHBb[3]);

				vertex_uniform_buffer_1[45] = float4(unity_SHC[0], unity_SHC[1], unity_SHC[2], unity_SHC[3]);

				vertex_uniform_buffer_2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_2[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_2[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_2[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_2[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_2[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_3[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_3[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_3[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_3[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // !SHADOWS_SCREEN
			#endif // !VERTEXLIGHT_ON


			#ifdef DIRECTIONAL
			#ifdef SHADOWS_SCREEN
			#ifndef LIGHTPROBE_SH
			#ifndef VERTEXLIGHT_ON
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _ProjectionParams;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[6];
			static float4 vertex_uniform_buffer_2[10];
			static float4 vertex_uniform_buffer_3[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_81 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_83 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_84 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_111 = mad(vertex_uniform_buffer_2[2u].x, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].x));
				float vertex_unnamed_112 = mad(vertex_uniform_buffer_2[2u].y, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].y));
				float vertex_unnamed_113 = mad(vertex_uniform_buffer_2[2u].z, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].z));
				float vertex_unnamed_122 = vertex_unnamed_111 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_123 = vertex_unnamed_112 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_124 = vertex_unnamed_113 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_125 = mad(vertex_uniform_buffer_2[2u].w, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].w, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].w)) + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_133 = mad(vertex_uniform_buffer_2[3u].x, vertex_input_0.w, vertex_unnamed_111);
				float vertex_unnamed_134 = mad(vertex_uniform_buffer_2[3u].y, vertex_input_0.w, vertex_unnamed_112);
				float vertex_unnamed_135 = mad(vertex_uniform_buffer_2[3u].z, vertex_input_0.w, vertex_unnamed_113);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[20u].x, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].x, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].x, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].x)));
				float vertex_unnamed_177 = mad(vertex_uniform_buffer_3[20u].y, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].y, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].y, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].y)));
				float vertex_unnamed_178 = mad(vertex_uniform_buffer_3[20u].z, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].z, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].z, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].z)));
				float vertex_unnamed_179 = mad(vertex_uniform_buffer_3[20u].w, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].w, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].w, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].w)));
				gl_Position.x = vertex_unnamed_176;
				gl_Position.y = vertex_unnamed_177;
				gl_Position.z = vertex_unnamed_178;
				gl_Position.w = vertex_unnamed_179;
				float vertex_unnamed_188 = rsqrt(dot(float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84), float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84)));
				float vertex_unnamed_189 = vertex_unnamed_188 * vertex_unnamed_84;
				float vertex_unnamed_190 = vertex_unnamed_188 * vertex_unnamed_81;
				float vertex_unnamed_191 = vertex_unnamed_188 * vertex_unnamed_83;
				vertex_output_4.x = vertex_unnamed_81;
				vertex_output_4.y = vertex_unnamed_83;
				vertex_output_4.z = vertex_unnamed_84;
				float vertex_unnamed_204 = mad(vertex_unnamed_191, 0.0f, (-0.0f) - (vertex_unnamed_189 * 1.0f));
				float vertex_unnamed_206 = mad(vertex_unnamed_190, 1.0f, (-0.0f) - (vertex_unnamed_191 * 0.0f));
				bool vertex_unnamed_212 = sqrt(dot(float2(vertex_unnamed_204, vertex_unnamed_206), float2(vertex_unnamed_204, vertex_unnamed_206))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_219 = asfloat(vertex_unnamed_212 ? 1065353216u : asuint(vertex_unnamed_204));
				float vertex_unnamed_223 = asfloat(vertex_unnamed_212 ? 0u : asuint(vertex_unnamed_206));
				float vertex_unnamed_227 = rsqrt(dot(float2(vertex_unnamed_219, vertex_unnamed_223), float2(vertex_unnamed_219, vertex_unnamed_223)));
				float vertex_unnamed_228 = vertex_unnamed_227 * vertex_unnamed_219;
				float vertex_unnamed_229 = vertex_unnamed_227 * asfloat(vertex_unnamed_212 ? 0u : asuint(mad(vertex_unnamed_189, 0.0f, (-0.0f) - (vertex_unnamed_190 * 0.0f))));
				float vertex_unnamed_230 = vertex_unnamed_227 * vertex_unnamed_223;
				float vertex_unnamed_244 = mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].y);
				float vertex_unnamed_245 = mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].z);
				float vertex_unnamed_246 = mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].x);
				float vertex_unnamed_250 = rsqrt(dot(float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246), float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246)));
				float vertex_unnamed_251 = vertex_unnamed_250 * vertex_unnamed_244;
				float vertex_unnamed_252 = vertex_unnamed_250 * vertex_unnamed_245;
				float vertex_unnamed_253 = vertex_unnamed_250 * vertex_unnamed_246;
				vertex_output_1.x = vertex_unnamed_253;
				float vertex_unnamed_267 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[4u].xyz));
				float vertex_unnamed_282 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[5u].xyz));
				float vertex_unnamed_296 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[6u].xyz));
				float vertex_unnamed_302 = rsqrt(dot(float3(vertex_unnamed_296, vertex_unnamed_267, vertex_unnamed_282), float3(vertex_unnamed_296, vertex_unnamed_267, vertex_unnamed_282)));
				float vertex_unnamed_303 = vertex_unnamed_302 * vertex_unnamed_296;
				float vertex_unnamed_304 = vertex_unnamed_302 * vertex_unnamed_267;
				float vertex_unnamed_305 = vertex_unnamed_302 * vertex_unnamed_282;
				float vertex_unnamed_321 = vertex_input_2.w * vertex_uniform_buffer_2[9u].w;
				vertex_output_1.y = vertex_unnamed_321 * mad(vertex_unnamed_305, vertex_unnamed_252, (-0.0f) - (vertex_unnamed_251 * vertex_unnamed_303));
				vertex_output_1.z = vertex_unnamed_304;
				vertex_output_1.w = vertex_unnamed_133;
				vertex_output_2.z = vertex_unnamed_305;
				vertex_output_3.z = vertex_unnamed_303;
				vertex_output_2.x = vertex_unnamed_251;
				vertex_output_3.x = vertex_unnamed_252;
				vertex_output_2.w = vertex_unnamed_134;
				vertex_output_2.y = vertex_unnamed_321 * mad(vertex_unnamed_303, vertex_unnamed_253, (-0.0f) - (vertex_unnamed_252 * vertex_unnamed_304));
				vertex_output_3.y = vertex_unnamed_321 * mad(vertex_unnamed_304, vertex_unnamed_251, (-0.0f) - (vertex_unnamed_253 * vertex_unnamed_305));
				vertex_output_3.w = vertex_unnamed_135;
				vertex_output_10.x = vertex_unnamed_133;
				vertex_output_10.y = vertex_unnamed_134;
				vertex_output_10.z = vertex_unnamed_135;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_228;
				vertex_output_6.y = vertex_unnamed_229;
				vertex_output_6.z = vertex_unnamed_230;
				float vertex_unnamed_369 = mad(vertex_input_1.y, vertex_unnamed_230, (-0.0f) - (vertex_unnamed_229 * vertex_input_1.z));
				float vertex_unnamed_370 = mad(vertex_input_1.z, vertex_unnamed_228, (-0.0f) - (vertex_unnamed_230 * vertex_input_1.x));
				float vertex_unnamed_371 = mad(vertex_input_1.x, vertex_unnamed_229, (-0.0f) - (vertex_unnamed_228 * vertex_input_1.y));
				float vertex_unnamed_375 = rsqrt(dot(float3(vertex_unnamed_369, vertex_unnamed_370, vertex_unnamed_371), float3(vertex_unnamed_369, vertex_unnamed_370, vertex_unnamed_371)));
				vertex_output_7.x = vertex_unnamed_375 * vertex_unnamed_369;
				vertex_output_7.y = vertex_unnamed_375 * vertex_unnamed_370;
				vertex_output_7.z = vertex_unnamed_375 * vertex_unnamed_371;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_393 = vertex_unnamed_179 * 0.5f;
				vertex_output_9.x = mad(vertex_unnamed_176, 0.5f, vertex_unnamed_393);
				vertex_output_9.y = mad(vertex_unnamed_177, -0.5f, vertex_unnamed_393);
				vertex_output_12.x = vertex_unnamed_393 + (vertex_unnamed_176 * 0.5f);
				vertex_output_12.y = vertex_unnamed_393 + ((vertex_unnamed_177 * vertex_uniform_buffer_1[5u].x) * 0.5f);
				vertex_output_9.z = vertex_unnamed_178;
				vertex_output_9.w = vertex_unnamed_179;
				vertex_output_12.z = vertex_unnamed_178;
				vertex_output_12.w = vertex_unnamed_179;
				vertex_output_11.x = 0.0f;
				vertex_output_11.y = 0.0f;
				vertex_output_11.z = 0.0f;
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[5] = float4(_ProjectionParams[0], _ProjectionParams[1], _ProjectionParams[2], _ProjectionParams[3]);

				vertex_uniform_buffer_2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_2[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_2[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_2[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_2[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_2[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_3[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_3[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_3[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_3[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // SHADOWS_SCREEN
			#endif // !LIGHTPROBE_SH
			#endif // !VERTEXLIGHT_ON


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifdef SHADOWS_SCREEN
			#ifndef VERTEXLIGHT_ON
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _ProjectionParams;
			float4 unity_SHAr;
			float4 unity_SHAg;
			float4 unity_SHAb;
			float4 unity_SHBr;
			float4 unity_SHBg;
			float4 unity_SHBb;
			float4 unity_SHC;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[6];
			static float4 vertex_uniform_buffer_2[46];
			static float4 vertex_uniform_buffer_3[10];
			static float4 vertex_uniform_buffer_4[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_86 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_88 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_89 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_116 = mad(vertex_uniform_buffer_3[2u].x, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].x));
				float vertex_unnamed_117 = mad(vertex_uniform_buffer_3[2u].y, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].y));
				float vertex_unnamed_118 = mad(vertex_uniform_buffer_3[2u].z, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].z));
				float vertex_unnamed_127 = vertex_unnamed_116 + vertex_uniform_buffer_3[3u].x;
				float vertex_unnamed_128 = vertex_unnamed_117 + vertex_uniform_buffer_3[3u].y;
				float vertex_unnamed_129 = vertex_unnamed_118 + vertex_uniform_buffer_3[3u].z;
				float vertex_unnamed_130 = mad(vertex_uniform_buffer_3[2u].w, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].w, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].w)) + vertex_uniform_buffer_3[3u].w;
				float vertex_unnamed_138 = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_116);
				float vertex_unnamed_139 = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_117);
				float vertex_unnamed_140 = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_118);
				float vertex_unnamed_181 = mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].x)));
				float vertex_unnamed_182 = mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].y)));
				float vertex_unnamed_183 = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].z)));
				float vertex_unnamed_184 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].w)));
				gl_Position.x = vertex_unnamed_181;
				gl_Position.y = vertex_unnamed_182;
				gl_Position.z = vertex_unnamed_183;
				gl_Position.w = vertex_unnamed_184;
				float vertex_unnamed_193 = rsqrt(dot(float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89), float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89)));
				float vertex_unnamed_194 = vertex_unnamed_193 * vertex_unnamed_89;
				float vertex_unnamed_195 = vertex_unnamed_193 * vertex_unnamed_86;
				float vertex_unnamed_196 = vertex_unnamed_193 * vertex_unnamed_88;
				vertex_output_4.x = vertex_unnamed_86;
				vertex_output_4.y = vertex_unnamed_88;
				vertex_output_4.z = vertex_unnamed_89;
				float vertex_unnamed_209 = mad(vertex_unnamed_196, 0.0f, (-0.0f) - (vertex_unnamed_194 * 1.0f));
				float vertex_unnamed_211 = mad(vertex_unnamed_195, 1.0f, (-0.0f) - (vertex_unnamed_196 * 0.0f));
				bool vertex_unnamed_217 = sqrt(dot(float2(vertex_unnamed_209, vertex_unnamed_211), float2(vertex_unnamed_209, vertex_unnamed_211))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_224 = asfloat(vertex_unnamed_217 ? 1065353216u : asuint(vertex_unnamed_209));
				float vertex_unnamed_228 = asfloat(vertex_unnamed_217 ? 0u : asuint(vertex_unnamed_211));
				float vertex_unnamed_232 = rsqrt(dot(float2(vertex_unnamed_224, vertex_unnamed_228), float2(vertex_unnamed_224, vertex_unnamed_228)));
				float vertex_unnamed_233 = vertex_unnamed_232 * vertex_unnamed_224;
				float vertex_unnamed_234 = vertex_unnamed_232 * asfloat(vertex_unnamed_217 ? 0u : asuint(mad(vertex_unnamed_194, 0.0f, (-0.0f) - (vertex_unnamed_195 * 0.0f))));
				float vertex_unnamed_235 = vertex_unnamed_232 * vertex_unnamed_228;
				float vertex_unnamed_249 = mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].y);
				float vertex_unnamed_250 = mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].z);
				float vertex_unnamed_251 = mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].x);
				float vertex_unnamed_255 = rsqrt(dot(float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251), float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251)));
				float vertex_unnamed_256 = vertex_unnamed_255 * vertex_unnamed_249;
				float vertex_unnamed_257 = vertex_unnamed_255 * vertex_unnamed_250;
				float vertex_unnamed_258 = vertex_unnamed_255 * vertex_unnamed_251;
				vertex_output_1.x = vertex_unnamed_258;
				float vertex_unnamed_272 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[4u].xyz));
				float vertex_unnamed_287 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[5u].xyz));
				float vertex_unnamed_301 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[6u].xyz));
				float vertex_unnamed_307 = rsqrt(dot(float3(vertex_unnamed_272, vertex_unnamed_287, vertex_unnamed_301), float3(vertex_unnamed_272, vertex_unnamed_287, vertex_unnamed_301)));
				float vertex_unnamed_308 = vertex_unnamed_307 * vertex_unnamed_272;
				float vertex_unnamed_309 = vertex_unnamed_307 * vertex_unnamed_287;
				float vertex_unnamed_310 = vertex_unnamed_307 * vertex_unnamed_301;
				float vertex_unnamed_326 = vertex_input_2.w * vertex_uniform_buffer_3[9u].w;
				vertex_output_1.y = vertex_unnamed_326 * mad(vertex_unnamed_309, vertex_unnamed_257, (-0.0f) - (vertex_unnamed_256 * vertex_unnamed_310));
				vertex_output_1.w = vertex_unnamed_138;
				vertex_output_1.z = vertex_unnamed_308;
				vertex_output_2.x = vertex_unnamed_256;
				vertex_output_3.x = vertex_unnamed_257;
				vertex_output_2.w = vertex_unnamed_139;
				vertex_output_2.y = vertex_unnamed_326 * mad(vertex_unnamed_310, vertex_unnamed_258, (-0.0f) - (vertex_unnamed_257 * vertex_unnamed_308));
				vertex_output_3.y = vertex_unnamed_326 * mad(vertex_unnamed_308, vertex_unnamed_256, (-0.0f) - (vertex_unnamed_258 * vertex_unnamed_309));
				vertex_output_2.z = vertex_unnamed_309;
				vertex_output_3.w = vertex_unnamed_140;
				vertex_output_10.x = vertex_unnamed_138;
				vertex_output_10.y = vertex_unnamed_139;
				vertex_output_10.z = vertex_unnamed_140;
				vertex_output_3.z = vertex_unnamed_310;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_233;
				vertex_output_6.y = vertex_unnamed_234;
				vertex_output_6.z = vertex_unnamed_235;
				float vertex_unnamed_374 = mad(vertex_input_1.y, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_input_1.z));
				float vertex_unnamed_375 = mad(vertex_input_1.z, vertex_unnamed_233, (-0.0f) - (vertex_unnamed_235 * vertex_input_1.x));
				float vertex_unnamed_376 = mad(vertex_input_1.x, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_233 * vertex_input_1.y));
				float vertex_unnamed_380 = rsqrt(dot(float3(vertex_unnamed_374, vertex_unnamed_375, vertex_unnamed_376), float3(vertex_unnamed_374, vertex_unnamed_375, vertex_unnamed_376)));
				vertex_output_7.x = vertex_unnamed_380 * vertex_unnamed_374;
				vertex_output_7.y = vertex_unnamed_380 * vertex_unnamed_375;
				vertex_output_7.z = vertex_unnamed_380 * vertex_unnamed_376;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_398 = vertex_unnamed_184 * 0.5f;
				vertex_output_9.x = mad(vertex_unnamed_181, 0.5f, vertex_unnamed_398);
				vertex_output_9.y = mad(vertex_unnamed_182, -0.5f, vertex_unnamed_398);
				vertex_output_12.x = vertex_unnamed_398 + (vertex_unnamed_181 * 0.5f);
				vertex_output_12.y = vertex_unnamed_398 + ((vertex_unnamed_182 * vertex_uniform_buffer_1[5u].x) * 0.5f);
				vertex_output_9.z = vertex_unnamed_183;
				vertex_output_9.w = vertex_unnamed_184;
				vertex_output_12.z = vertex_unnamed_183;
				vertex_output_12.w = vertex_unnamed_184;
				float vertex_unnamed_419 = mad(vertex_unnamed_308, vertex_unnamed_308, (-0.0f) - (vertex_unnamed_309 * vertex_unnamed_309));
				float vertex_unnamed_420 = vertex_unnamed_309 * vertex_unnamed_308;
				float vertex_unnamed_421 = vertex_unnamed_310 * vertex_unnamed_309;
				float vertex_unnamed_422 = vertex_unnamed_310 * vertex_unnamed_310;
				float vertex_unnamed_423 = vertex_unnamed_308 * vertex_unnamed_310;
				float vertex_unnamed_463 = asfloat(1065353216u);
				vertex_output_11.x = mad(vertex_uniform_buffer_2[45u].x, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[42u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[39u]), float4(vertex_unnamed_308, vertex_unnamed_309, vertex_unnamed_310, vertex_unnamed_463));
				vertex_output_11.y = mad(vertex_uniform_buffer_2[45u].y, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[43u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[40u]), float4(vertex_unnamed_308, vertex_unnamed_309, vertex_unnamed_310, vertex_unnamed_463));
				vertex_output_11.z = mad(vertex_uniform_buffer_2[45u].z, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[44u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[41u]), float4(vertex_unnamed_308, vertex_unnamed_309, vertex_unnamed_310, vertex_unnamed_463));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[5] = float4(_ProjectionParams[0], _ProjectionParams[1], _ProjectionParams[2], _ProjectionParams[3]);

				vertex_uniform_buffer_2[39] = float4(unity_SHAr[0], unity_SHAr[1], unity_SHAr[2], unity_SHAr[3]);

				vertex_uniform_buffer_2[40] = float4(unity_SHAg[0], unity_SHAg[1], unity_SHAg[2], unity_SHAg[3]);

				vertex_uniform_buffer_2[41] = float4(unity_SHAb[0], unity_SHAb[1], unity_SHAb[2], unity_SHAb[3]);

				vertex_uniform_buffer_2[42] = float4(unity_SHBr[0], unity_SHBr[1], unity_SHBr[2], unity_SHBr[3]);

				vertex_uniform_buffer_2[43] = float4(unity_SHBg[0], unity_SHBg[1], unity_SHBg[2], unity_SHBg[3]);

				vertex_uniform_buffer_2[44] = float4(unity_SHBb[0], unity_SHBb[1], unity_SHBb[2], unity_SHBb[3]);

				vertex_uniform_buffer_2[45] = float4(unity_SHC[0], unity_SHC[1], unity_SHC[2], unity_SHC[3]);

				vertex_uniform_buffer_3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_3[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_3[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_3[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_3[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_3[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_4[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_4[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_4[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_4[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // SHADOWS_SCREEN
			#endif // !VERTEXLIGHT_ON


			#ifdef DIRECTIONAL
			#ifdef VERTEXLIGHT_ON
			#ifndef LIGHTPROBE_SH
			#ifndef SHADOWS_SCREEN
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 unity_4LightPosX0;
			float4 unity_4LightPosY0;
			float4 unity_4LightPosZ0;
			float4 unity_4LightAtten0;
			float4 unity_LightColor[8];
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[15];
			static float4 vertex_uniform_buffer_2[10];
			static float4 vertex_uniform_buffer_3[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_81 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_83 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_84 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_111 = mad(vertex_uniform_buffer_2[2u].x, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].x));
				float vertex_unnamed_112 = mad(vertex_uniform_buffer_2[2u].y, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].y));
				float vertex_unnamed_113 = mad(vertex_uniform_buffer_2[2u].z, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].z));
				float vertex_unnamed_122 = vertex_unnamed_111 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_123 = vertex_unnamed_112 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_124 = vertex_unnamed_113 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_125 = mad(vertex_uniform_buffer_2[2u].w, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].w, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].w)) + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_133 = mad(vertex_uniform_buffer_2[3u].x, vertex_input_0.w, vertex_unnamed_111);
				float vertex_unnamed_134 = mad(vertex_uniform_buffer_2[3u].y, vertex_input_0.w, vertex_unnamed_112);
				float vertex_unnamed_135 = mad(vertex_uniform_buffer_2[3u].z, vertex_input_0.w, vertex_unnamed_113);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[20u].x, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].x, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].x, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].x)));
				float vertex_unnamed_177 = mad(vertex_uniform_buffer_3[20u].y, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].y, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].y, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].y)));
				float vertex_unnamed_178 = mad(vertex_uniform_buffer_3[20u].z, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].z, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].z, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].z)));
				float vertex_unnamed_179 = mad(vertex_uniform_buffer_3[20u].w, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].w, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].w, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].w)));
				gl_Position.x = vertex_unnamed_176;
				gl_Position.y = vertex_unnamed_177;
				gl_Position.z = vertex_unnamed_178;
				gl_Position.w = vertex_unnamed_179;
				float vertex_unnamed_188 = rsqrt(dot(float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84), float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84)));
				float vertex_unnamed_189 = vertex_unnamed_188 * vertex_unnamed_84;
				float vertex_unnamed_190 = vertex_unnamed_188 * vertex_unnamed_81;
				float vertex_unnamed_191 = vertex_unnamed_188 * vertex_unnamed_83;
				vertex_output_4.x = vertex_unnamed_81;
				vertex_output_4.y = vertex_unnamed_83;
				vertex_output_4.z = vertex_unnamed_84;
				float vertex_unnamed_204 = mad(vertex_unnamed_191, 0.0f, (-0.0f) - (vertex_unnamed_189 * 1.0f));
				float vertex_unnamed_206 = mad(vertex_unnamed_190, 1.0f, (-0.0f) - (vertex_unnamed_191 * 0.0f));
				bool vertex_unnamed_212 = sqrt(dot(float2(vertex_unnamed_204, vertex_unnamed_206), float2(vertex_unnamed_204, vertex_unnamed_206))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_219 = asfloat(vertex_unnamed_212 ? 1065353216u : asuint(vertex_unnamed_204));
				float vertex_unnamed_223 = asfloat(vertex_unnamed_212 ? 0u : asuint(vertex_unnamed_206));
				float vertex_unnamed_227 = rsqrt(dot(float2(vertex_unnamed_219, vertex_unnamed_223), float2(vertex_unnamed_219, vertex_unnamed_223)));
				float vertex_unnamed_228 = vertex_unnamed_227 * vertex_unnamed_219;
				float vertex_unnamed_229 = vertex_unnamed_227 * asfloat(vertex_unnamed_212 ? 0u : asuint(mad(vertex_unnamed_189, 0.0f, (-0.0f) - (vertex_unnamed_190 * 0.0f))));
				float vertex_unnamed_230 = vertex_unnamed_227 * vertex_unnamed_223;
				float vertex_unnamed_244 = mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].y);
				float vertex_unnamed_245 = mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].z);
				float vertex_unnamed_246 = mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].x);
				float vertex_unnamed_250 = rsqrt(dot(float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246), float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246)));
				float vertex_unnamed_251 = vertex_unnamed_250 * vertex_unnamed_244;
				float vertex_unnamed_252 = vertex_unnamed_250 * vertex_unnamed_245;
				float vertex_unnamed_253 = vertex_unnamed_250 * vertex_unnamed_246;
				vertex_output_1.x = vertex_unnamed_253;
				float vertex_unnamed_267 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[4u].xyz));
				float vertex_unnamed_282 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[5u].xyz));
				float vertex_unnamed_297 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[6u].xyz));
				float vertex_unnamed_303 = rsqrt(dot(float3(vertex_unnamed_297, vertex_unnamed_267, vertex_unnamed_282), float3(vertex_unnamed_297, vertex_unnamed_267, vertex_unnamed_282)));
				float vertex_unnamed_304 = vertex_unnamed_303 * vertex_unnamed_297;
				float vertex_unnamed_305 = vertex_unnamed_303 * vertex_unnamed_267;
				float vertex_unnamed_306 = vertex_unnamed_303 * vertex_unnamed_282;
				float vertex_unnamed_322 = vertex_input_2.w * vertex_uniform_buffer_2[9u].w;
				vertex_output_1.y = vertex_unnamed_322 * mad(vertex_unnamed_306, vertex_unnamed_252, (-0.0f) - (vertex_unnamed_251 * vertex_unnamed_304));
				vertex_output_1.z = vertex_unnamed_305;
				vertex_output_1.w = vertex_unnamed_133;
				vertex_output_2.x = vertex_unnamed_251;
				vertex_output_3.x = vertex_unnamed_252;
				vertex_output_2.y = vertex_unnamed_322 * mad(vertex_unnamed_304, vertex_unnamed_253, (-0.0f) - (vertex_unnamed_252 * vertex_unnamed_305));
				vertex_output_3.y = vertex_unnamed_322 * mad(vertex_unnamed_305, vertex_unnamed_251, (-0.0f) - (vertex_unnamed_253 * vertex_unnamed_306));
				vertex_output_2.z = vertex_unnamed_306;
				vertex_output_2.w = vertex_unnamed_134;
				vertex_output_3.z = vertex_unnamed_304;
				vertex_output_3.w = vertex_unnamed_135;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_228;
				vertex_output_6.y = vertex_unnamed_229;
				vertex_output_6.z = vertex_unnamed_230;
				float vertex_unnamed_367 = mad(vertex_input_1.y, vertex_unnamed_230, (-0.0f) - (vertex_unnamed_229 * vertex_input_1.z));
				float vertex_unnamed_368 = mad(vertex_input_1.z, vertex_unnamed_228, (-0.0f) - (vertex_unnamed_230 * vertex_input_1.x));
				float vertex_unnamed_369 = mad(vertex_input_1.x, vertex_unnamed_229, (-0.0f) - (vertex_unnamed_228 * vertex_input_1.y));
				float vertex_unnamed_373 = rsqrt(dot(float3(vertex_unnamed_367, vertex_unnamed_368, vertex_unnamed_369), float3(vertex_unnamed_367, vertex_unnamed_368, vertex_unnamed_369)));
				vertex_output_7.x = vertex_unnamed_373 * vertex_unnamed_367;
				vertex_output_7.y = vertex_unnamed_373 * vertex_unnamed_368;
				vertex_output_7.z = vertex_unnamed_373 * vertex_unnamed_369;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_391 = vertex_unnamed_179 * 0.5f;
				vertex_output_9.z = vertex_unnamed_178;
				vertex_output_9.w = vertex_unnamed_179;
				vertex_output_9.x = vertex_unnamed_391 + (vertex_unnamed_176 * 0.5f);
				vertex_output_9.y = vertex_unnamed_391 + (vertex_unnamed_177 * (-0.5f));
				vertex_output_10.x = vertex_unnamed_133;
				vertex_output_10.y = vertex_unnamed_134;
				vertex_output_10.z = vertex_unnamed_135;
				float vertex_unnamed_403 = (-0.0f) - vertex_unnamed_134;
				float vertex_unnamed_410 = vertex_unnamed_403 + vertex_uniform_buffer_1[4u].x;
				float vertex_unnamed_411 = vertex_unnamed_403 + vertex_uniform_buffer_1[4u].y;
				float vertex_unnamed_412 = vertex_unnamed_403 + vertex_uniform_buffer_1[4u].z;
				float vertex_unnamed_413 = vertex_unnamed_403 + vertex_uniform_buffer_1[4u].w;
				float vertex_unnamed_422 = (-0.0f) - vertex_unnamed_133;
				float vertex_unnamed_429 = vertex_unnamed_422 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_430 = vertex_unnamed_422 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_431 = vertex_unnamed_422 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_432 = vertex_unnamed_422 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_433 = (-0.0f) - vertex_unnamed_135;
				float vertex_unnamed_440 = vertex_unnamed_433 + vertex_uniform_buffer_1[5u].x;
				float vertex_unnamed_441 = vertex_unnamed_433 + vertex_uniform_buffer_1[5u].y;
				float vertex_unnamed_442 = vertex_unnamed_433 + vertex_uniform_buffer_1[5u].z;
				float vertex_unnamed_443 = vertex_unnamed_433 + vertex_uniform_buffer_1[5u].w;
				float vertex_unnamed_460 = max(mad(vertex_unnamed_440, vertex_unnamed_440, mad(vertex_unnamed_429, vertex_unnamed_429, vertex_unnamed_410 * vertex_unnamed_410)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_462 = max(mad(vertex_unnamed_441, vertex_unnamed_441, mad(vertex_unnamed_430, vertex_unnamed_430, vertex_unnamed_411 * vertex_unnamed_411)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_463 = max(mad(vertex_unnamed_442, vertex_unnamed_442, mad(vertex_unnamed_431, vertex_unnamed_431, vertex_unnamed_412 * vertex_unnamed_412)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_464 = max(mad(vertex_unnamed_443, vertex_unnamed_443, mad(vertex_unnamed_432, vertex_unnamed_432, vertex_unnamed_413 * vertex_unnamed_413)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_491 = (1.0f / mad(vertex_unnamed_460, vertex_uniform_buffer_1[6u].x, 1.0f)) * max(mad(vertex_unnamed_440, vertex_unnamed_304, mad(vertex_unnamed_429, vertex_unnamed_305, vertex_unnamed_306 * vertex_unnamed_410)) * rsqrt(vertex_unnamed_460), 0.0f);
				float vertex_unnamed_492 = (1.0f / mad(vertex_unnamed_462, vertex_uniform_buffer_1[6u].y, 1.0f)) * max(mad(vertex_unnamed_441, vertex_unnamed_304, mad(vertex_unnamed_430, vertex_unnamed_305, vertex_unnamed_306 * vertex_unnamed_411)) * rsqrt(vertex_unnamed_462), 0.0f);
				float vertex_unnamed_493 = (1.0f / mad(vertex_unnamed_463, vertex_uniform_buffer_1[6u].z, 1.0f)) * max(mad(vertex_unnamed_442, vertex_unnamed_304, mad(vertex_unnamed_431, vertex_unnamed_305, vertex_unnamed_306 * vertex_unnamed_412)) * rsqrt(vertex_unnamed_463), 0.0f);
				float vertex_unnamed_494 = (1.0f / mad(vertex_unnamed_464, vertex_uniform_buffer_1[6u].w, 1.0f)) * max(mad(vertex_unnamed_443, vertex_unnamed_304, mad(vertex_unnamed_432, vertex_unnamed_305, vertex_unnamed_306 * vertex_unnamed_413)) * rsqrt(vertex_unnamed_464), 0.0f);
				vertex_output_11.x = mad(vertex_uniform_buffer_1[10u].x, vertex_unnamed_494, mad(vertex_uniform_buffer_1[9u].x, vertex_unnamed_493, mad(vertex_uniform_buffer_1[7u].x, vertex_unnamed_491, vertex_unnamed_492 * vertex_uniform_buffer_1[8u].x)));
				vertex_output_11.y = mad(vertex_uniform_buffer_1[10u].y, vertex_unnamed_494, mad(vertex_uniform_buffer_1[9u].y, vertex_unnamed_493, mad(vertex_uniform_buffer_1[7u].y, vertex_unnamed_491, vertex_unnamed_492 * vertex_uniform_buffer_1[8u].y)));
				vertex_output_11.z = mad(vertex_uniform_buffer_1[10u].z, vertex_unnamed_494, mad(vertex_uniform_buffer_1[9u].z, vertex_unnamed_493, mad(vertex_uniform_buffer_1[7u].z, vertex_unnamed_491, vertex_unnamed_492 * vertex_uniform_buffer_1[8u].z)));
				vertex_output_12.x = 0.0f;
				vertex_output_12.y = 0.0f;
				vertex_output_12.z = 0.0f;
				vertex_output_12.w = 0.0f;
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[3] = float4(unity_4LightPosX0[0], unity_4LightPosX0[1], unity_4LightPosX0[2], unity_4LightPosX0[3]);

				vertex_uniform_buffer_1[4] = float4(unity_4LightPosY0[0], unity_4LightPosY0[1], unity_4LightPosY0[2], unity_4LightPosY0[3]);

				vertex_uniform_buffer_1[5] = float4(unity_4LightPosZ0[0], unity_4LightPosZ0[1], unity_4LightPosZ0[2], unity_4LightPosZ0[3]);

				vertex_uniform_buffer_1[6] = float4(unity_4LightAtten0[0], unity_4LightAtten0[1], unity_4LightAtten0[2], unity_4LightAtten0[3]);

				vertex_uniform_buffer_1[7] = float4(unity_LightColor[0][0], unity_LightColor[0][1], unity_LightColor[0][2], unity_LightColor[0][3]);
				vertex_uniform_buffer_1[8] = float4(unity_LightColor[1][0], unity_LightColor[1][1], unity_LightColor[1][2], unity_LightColor[1][3]);
				vertex_uniform_buffer_1[9] = float4(unity_LightColor[2][0], unity_LightColor[2][1], unity_LightColor[2][2], unity_LightColor[2][3]);
				vertex_uniform_buffer_1[10] = float4(unity_LightColor[3][0], unity_LightColor[3][1], unity_LightColor[3][2], unity_LightColor[3][3]);
				vertex_uniform_buffer_1[11] = float4(unity_LightColor[4][0], unity_LightColor[4][1], unity_LightColor[4][2], unity_LightColor[4][3]);
				vertex_uniform_buffer_1[12] = float4(unity_LightColor[5][0], unity_LightColor[5][1], unity_LightColor[5][2], unity_LightColor[5][3]);
				vertex_uniform_buffer_1[13] = float4(unity_LightColor[6][0], unity_LightColor[6][1], unity_LightColor[6][2], unity_LightColor[6][3]);
				vertex_uniform_buffer_1[14] = float4(unity_LightColor[7][0], unity_LightColor[7][1], unity_LightColor[7][2], unity_LightColor[7][3]);

				vertex_uniform_buffer_2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_2[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_2[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_2[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_2[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_2[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_3[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_3[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_3[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_3[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // VERTEXLIGHT_ON
			#endif // !LIGHTPROBE_SH
			#endif // !SHADOWS_SCREEN


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifdef VERTEXLIGHT_ON
			#ifndef SHADOWS_SCREEN
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 unity_4LightPosX0;
			float4 unity_4LightPosY0;
			float4 unity_4LightPosZ0;
			float4 unity_4LightAtten0;
			float4 unity_LightColor[8];
			float4 unity_SHAr;
			float4 unity_SHAg;
			float4 unity_SHAb;
			float4 unity_SHBr;
			float4 unity_SHBg;
			float4 unity_SHBb;
			float4 unity_SHC;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[46];
			static float4 vertex_uniform_buffer_2[10];
			static float4 vertex_uniform_buffer_3[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_81 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_83 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_84 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_111 = mad(vertex_uniform_buffer_2[2u].x, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].x));
				float vertex_unnamed_112 = mad(vertex_uniform_buffer_2[2u].y, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].y));
				float vertex_unnamed_113 = mad(vertex_uniform_buffer_2[2u].z, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].z));
				float vertex_unnamed_122 = vertex_unnamed_111 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_123 = vertex_unnamed_112 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_124 = vertex_unnamed_113 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_125 = mad(vertex_uniform_buffer_2[2u].w, vertex_unnamed_84, mad(vertex_uniform_buffer_2[0u].w, vertex_unnamed_81, vertex_unnamed_83 * vertex_uniform_buffer_2[1u].w)) + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_133 = mad(vertex_uniform_buffer_2[3u].x, vertex_input_0.w, vertex_unnamed_111);
				float vertex_unnamed_134 = mad(vertex_uniform_buffer_2[3u].y, vertex_input_0.w, vertex_unnamed_112);
				float vertex_unnamed_135 = mad(vertex_uniform_buffer_2[3u].z, vertex_input_0.w, vertex_unnamed_113);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[20u].x, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].x, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].x, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].x)));
				float vertex_unnamed_177 = mad(vertex_uniform_buffer_3[20u].y, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].y, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].y, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].y)));
				float vertex_unnamed_178 = mad(vertex_uniform_buffer_3[20u].z, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].z, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].z, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].z)));
				float vertex_unnamed_179 = mad(vertex_uniform_buffer_3[20u].w, vertex_unnamed_125, mad(vertex_uniform_buffer_3[19u].w, vertex_unnamed_124, mad(vertex_uniform_buffer_3[17u].w, vertex_unnamed_122, vertex_unnamed_123 * vertex_uniform_buffer_3[18u].w)));
				gl_Position.x = vertex_unnamed_176;
				gl_Position.y = vertex_unnamed_177;
				gl_Position.z = vertex_unnamed_178;
				gl_Position.w = vertex_unnamed_179;
				float vertex_unnamed_188 = rsqrt(dot(float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84), float3(vertex_unnamed_81, vertex_unnamed_83, vertex_unnamed_84)));
				float vertex_unnamed_189 = vertex_unnamed_188 * vertex_unnamed_84;
				float vertex_unnamed_190 = vertex_unnamed_188 * vertex_unnamed_81;
				float vertex_unnamed_191 = vertex_unnamed_188 * vertex_unnamed_83;
				vertex_output_4.x = vertex_unnamed_81;
				vertex_output_4.y = vertex_unnamed_83;
				vertex_output_4.z = vertex_unnamed_84;
				float vertex_unnamed_204 = mad(vertex_unnamed_191, 0.0f, (-0.0f) - (vertex_unnamed_189 * 1.0f));
				float vertex_unnamed_206 = mad(vertex_unnamed_190, 1.0f, (-0.0f) - (vertex_unnamed_191 * 0.0f));
				bool vertex_unnamed_212 = sqrt(dot(float2(vertex_unnamed_204, vertex_unnamed_206), float2(vertex_unnamed_204, vertex_unnamed_206))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_219 = asfloat(vertex_unnamed_212 ? 1065353216u : asuint(vertex_unnamed_204));
				float vertex_unnamed_223 = asfloat(vertex_unnamed_212 ? 0u : asuint(vertex_unnamed_206));
				float vertex_unnamed_227 = rsqrt(dot(float2(vertex_unnamed_219, vertex_unnamed_223), float2(vertex_unnamed_219, vertex_unnamed_223)));
				float vertex_unnamed_228 = vertex_unnamed_227 * vertex_unnamed_219;
				float vertex_unnamed_229 = vertex_unnamed_227 * asfloat(vertex_unnamed_212 ? 0u : asuint(mad(vertex_unnamed_189, 0.0f, (-0.0f) - (vertex_unnamed_190 * 0.0f))));
				float vertex_unnamed_230 = vertex_unnamed_227 * vertex_unnamed_223;
				float vertex_unnamed_244 = mad(vertex_uniform_buffer_2[0u].y, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].y);
				float vertex_unnamed_245 = mad(vertex_uniform_buffer_2[0u].z, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].z);
				float vertex_unnamed_246 = mad(vertex_uniform_buffer_2[0u].x, vertex_unnamed_228, vertex_unnamed_230 * vertex_uniform_buffer_2[2u].x);
				float vertex_unnamed_250 = rsqrt(dot(float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246), float3(vertex_unnamed_244, vertex_unnamed_245, vertex_unnamed_246)));
				float vertex_unnamed_251 = vertex_unnamed_250 * vertex_unnamed_244;
				float vertex_unnamed_252 = vertex_unnamed_250 * vertex_unnamed_245;
				float vertex_unnamed_253 = vertex_unnamed_250 * vertex_unnamed_246;
				vertex_output_1.x = vertex_unnamed_253;
				float vertex_unnamed_261 = vertex_input_2.w * vertex_uniform_buffer_2[9u].w;
				float vertex_unnamed_274 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[4u].xyz));
				float vertex_unnamed_289 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[5u].xyz));
				float vertex_unnamed_304 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_2[6u].xyz));
				float vertex_unnamed_310 = rsqrt(dot(float3(vertex_unnamed_274, vertex_unnamed_289, vertex_unnamed_304), float3(vertex_unnamed_274, vertex_unnamed_289, vertex_unnamed_304)));
				float vertex_unnamed_311 = vertex_unnamed_310 * vertex_unnamed_274;
				float vertex_unnamed_312 = vertex_unnamed_310 * vertex_unnamed_289;
				float vertex_unnamed_313 = vertex_unnamed_310 * vertex_unnamed_304;
				vertex_output_1.y = vertex_unnamed_261 * mad(vertex_unnamed_312, vertex_unnamed_252, (-0.0f) - (vertex_unnamed_251 * vertex_unnamed_313));
				vertex_output_1.w = vertex_unnamed_133;
				vertex_output_1.z = vertex_unnamed_311;
				vertex_output_2.x = vertex_unnamed_251;
				vertex_output_3.x = vertex_unnamed_252;
				vertex_output_2.y = vertex_unnamed_261 * mad(vertex_unnamed_313, vertex_unnamed_253, (-0.0f) - (vertex_unnamed_252 * vertex_unnamed_311));
				vertex_output_3.y = vertex_unnamed_261 * mad(vertex_unnamed_311, vertex_unnamed_251, (-0.0f) - (vertex_unnamed_253 * vertex_unnamed_312));
				vertex_output_2.w = vertex_unnamed_134;
				vertex_output_2.z = vertex_unnamed_312;
				vertex_output_3.w = vertex_unnamed_135;
				vertex_output_3.z = vertex_unnamed_313;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_228;
				vertex_output_6.y = vertex_unnamed_229;
				vertex_output_6.z = vertex_unnamed_230;
				float vertex_unnamed_367 = mad(vertex_input_1.y, vertex_unnamed_230, (-0.0f) - (vertex_unnamed_229 * vertex_input_1.z));
				float vertex_unnamed_368 = mad(vertex_input_1.z, vertex_unnamed_228, (-0.0f) - (vertex_unnamed_230 * vertex_input_1.x));
				float vertex_unnamed_369 = mad(vertex_input_1.x, vertex_unnamed_229, (-0.0f) - (vertex_unnamed_228 * vertex_input_1.y));
				float vertex_unnamed_373 = rsqrt(dot(float3(vertex_unnamed_367, vertex_unnamed_368, vertex_unnamed_369), float3(vertex_unnamed_367, vertex_unnamed_368, vertex_unnamed_369)));
				vertex_output_7.x = vertex_unnamed_373 * vertex_unnamed_367;
				vertex_output_7.y = vertex_unnamed_373 * vertex_unnamed_368;
				vertex_output_7.z = vertex_unnamed_373 * vertex_unnamed_369;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_391 = vertex_unnamed_179 * 0.5f;
				vertex_output_9.z = vertex_unnamed_178;
				vertex_output_9.w = vertex_unnamed_179;
				vertex_output_9.x = vertex_unnamed_391 + (vertex_unnamed_176 * 0.5f);
				vertex_output_9.y = vertex_unnamed_391 + (vertex_unnamed_177 * (-0.5f));
				vertex_output_10.x = vertex_unnamed_133;
				vertex_output_10.y = vertex_unnamed_134;
				vertex_output_10.z = vertex_unnamed_135;
				float vertex_unnamed_405 = mad(vertex_unnamed_311, vertex_unnamed_311, (-0.0f) - (vertex_unnamed_312 * vertex_unnamed_312));
				float vertex_unnamed_406 = vertex_unnamed_312 * vertex_unnamed_311;
				float vertex_unnamed_407 = vertex_unnamed_313 * vertex_unnamed_312;
				float vertex_unnamed_408 = vertex_unnamed_313 * vertex_unnamed_313;
				float vertex_unnamed_409 = vertex_unnamed_311 * vertex_unnamed_313;
				float vertex_unnamed_449 = asfloat(1065353216u);
				float vertex_unnamed_483 = (-0.0f) - vertex_unnamed_134;
				float vertex_unnamed_490 = vertex_unnamed_483 + vertex_uniform_buffer_1[4u].x;
				float vertex_unnamed_491 = vertex_unnamed_483 + vertex_uniform_buffer_1[4u].y;
				float vertex_unnamed_492 = vertex_unnamed_483 + vertex_uniform_buffer_1[4u].z;
				float vertex_unnamed_493 = vertex_unnamed_483 + vertex_uniform_buffer_1[4u].w;
				float vertex_unnamed_502 = (-0.0f) - vertex_unnamed_133;
				float vertex_unnamed_509 = vertex_unnamed_502 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_510 = vertex_unnamed_502 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_511 = vertex_unnamed_502 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_512 = vertex_unnamed_502 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_513 = (-0.0f) - vertex_unnamed_135;
				float vertex_unnamed_520 = vertex_unnamed_513 + vertex_uniform_buffer_1[5u].x;
				float vertex_unnamed_521 = vertex_unnamed_513 + vertex_uniform_buffer_1[5u].y;
				float vertex_unnamed_522 = vertex_unnamed_513 + vertex_uniform_buffer_1[5u].z;
				float vertex_unnamed_523 = vertex_unnamed_513 + vertex_uniform_buffer_1[5u].w;
				float vertex_unnamed_540 = max(mad(vertex_unnamed_520, vertex_unnamed_520, mad(vertex_unnamed_509, vertex_unnamed_509, vertex_unnamed_490 * vertex_unnamed_490)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_542 = max(mad(vertex_unnamed_521, vertex_unnamed_521, mad(vertex_unnamed_510, vertex_unnamed_510, vertex_unnamed_491 * vertex_unnamed_491)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_543 = max(mad(vertex_unnamed_522, vertex_unnamed_522, mad(vertex_unnamed_511, vertex_unnamed_511, vertex_unnamed_492 * vertex_unnamed_492)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_544 = max(mad(vertex_unnamed_523, vertex_unnamed_523, mad(vertex_unnamed_512, vertex_unnamed_512, vertex_unnamed_493 * vertex_unnamed_493)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_571 = (1.0f / mad(vertex_unnamed_540, vertex_uniform_buffer_1[6u].x, 1.0f)) * max(mad(vertex_unnamed_520, vertex_unnamed_313, mad(vertex_unnamed_509, vertex_unnamed_311, vertex_unnamed_312 * vertex_unnamed_490)) * rsqrt(vertex_unnamed_540), 0.0f);
				float vertex_unnamed_572 = (1.0f / mad(vertex_unnamed_542, vertex_uniform_buffer_1[6u].y, 1.0f)) * max(mad(vertex_unnamed_521, vertex_unnamed_313, mad(vertex_unnamed_510, vertex_unnamed_311, vertex_unnamed_312 * vertex_unnamed_491)) * rsqrt(vertex_unnamed_542), 0.0f);
				float vertex_unnamed_573 = (1.0f / mad(vertex_unnamed_543, vertex_uniform_buffer_1[6u].z, 1.0f)) * max(mad(vertex_unnamed_522, vertex_unnamed_313, mad(vertex_unnamed_511, vertex_unnamed_311, vertex_unnamed_312 * vertex_unnamed_492)) * rsqrt(vertex_unnamed_543), 0.0f);
				float vertex_unnamed_574 = (1.0f / mad(vertex_unnamed_544, vertex_uniform_buffer_1[6u].w, 1.0f)) * max(mad(vertex_unnamed_523, vertex_unnamed_313, mad(vertex_unnamed_512, vertex_unnamed_311, vertex_unnamed_312 * vertex_unnamed_493)) * rsqrt(vertex_unnamed_544), 0.0f);
				vertex_output_11.x = (mad(vertex_uniform_buffer_1[45u].x, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[42u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[39u]), float4(vertex_unnamed_311, vertex_unnamed_312, vertex_unnamed_313, vertex_unnamed_449))) + mad(vertex_uniform_buffer_1[10u].x, vertex_unnamed_574, mad(vertex_uniform_buffer_1[9u].x, vertex_unnamed_573, mad(vertex_uniform_buffer_1[7u].x, vertex_unnamed_571, vertex_unnamed_572 * vertex_uniform_buffer_1[8u].x)));
				vertex_output_11.y = (mad(vertex_uniform_buffer_1[45u].y, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[43u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[40u]), float4(vertex_unnamed_311, vertex_unnamed_312, vertex_unnamed_313, vertex_unnamed_449))) + mad(vertex_uniform_buffer_1[10u].y, vertex_unnamed_574, mad(vertex_uniform_buffer_1[9u].y, vertex_unnamed_573, mad(vertex_uniform_buffer_1[7u].y, vertex_unnamed_571, vertex_unnamed_572 * vertex_uniform_buffer_1[8u].y)));
				vertex_output_11.z = (mad(vertex_uniform_buffer_1[45u].z, vertex_unnamed_405, dot(float4(vertex_uniform_buffer_1[44u]), float4(vertex_unnamed_406, vertex_unnamed_407, vertex_unnamed_408, vertex_unnamed_409))) + dot(float4(vertex_uniform_buffer_1[41u]), float4(vertex_unnamed_311, vertex_unnamed_312, vertex_unnamed_313, vertex_unnamed_449))) + mad(vertex_uniform_buffer_1[10u].z, vertex_unnamed_574, mad(vertex_uniform_buffer_1[9u].z, vertex_unnamed_573, mad(vertex_uniform_buffer_1[7u].z, vertex_unnamed_571, vertex_unnamed_572 * vertex_uniform_buffer_1[8u].z)));
				vertex_output_12.x = 0.0f;
				vertex_output_12.y = 0.0f;
				vertex_output_12.z = 0.0f;
				vertex_output_12.w = 0.0f;
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[3] = float4(unity_4LightPosX0[0], unity_4LightPosX0[1], unity_4LightPosX0[2], unity_4LightPosX0[3]);

				vertex_uniform_buffer_1[4] = float4(unity_4LightPosY0[0], unity_4LightPosY0[1], unity_4LightPosY0[2], unity_4LightPosY0[3]);

				vertex_uniform_buffer_1[5] = float4(unity_4LightPosZ0[0], unity_4LightPosZ0[1], unity_4LightPosZ0[2], unity_4LightPosZ0[3]);

				vertex_uniform_buffer_1[6] = float4(unity_4LightAtten0[0], unity_4LightAtten0[1], unity_4LightAtten0[2], unity_4LightAtten0[3]);

				vertex_uniform_buffer_1[7] = float4(unity_LightColor[0][0], unity_LightColor[0][1], unity_LightColor[0][2], unity_LightColor[0][3]);
				vertex_uniform_buffer_1[8] = float4(unity_LightColor[1][0], unity_LightColor[1][1], unity_LightColor[1][2], unity_LightColor[1][3]);
				vertex_uniform_buffer_1[9] = float4(unity_LightColor[2][0], unity_LightColor[2][1], unity_LightColor[2][2], unity_LightColor[2][3]);
				vertex_uniform_buffer_1[10] = float4(unity_LightColor[3][0], unity_LightColor[3][1], unity_LightColor[3][2], unity_LightColor[3][3]);
				vertex_uniform_buffer_1[11] = float4(unity_LightColor[4][0], unity_LightColor[4][1], unity_LightColor[4][2], unity_LightColor[4][3]);
				vertex_uniform_buffer_1[12] = float4(unity_LightColor[5][0], unity_LightColor[5][1], unity_LightColor[5][2], unity_LightColor[5][3]);
				vertex_uniform_buffer_1[13] = float4(unity_LightColor[6][0], unity_LightColor[6][1], unity_LightColor[6][2], unity_LightColor[6][3]);
				vertex_uniform_buffer_1[14] = float4(unity_LightColor[7][0], unity_LightColor[7][1], unity_LightColor[7][2], unity_LightColor[7][3]);

				vertex_uniform_buffer_1[39] = float4(unity_SHAr[0], unity_SHAr[1], unity_SHAr[2], unity_SHAr[3]);

				vertex_uniform_buffer_1[40] = float4(unity_SHAg[0], unity_SHAg[1], unity_SHAg[2], unity_SHAg[3]);

				vertex_uniform_buffer_1[41] = float4(unity_SHAb[0], unity_SHAb[1], unity_SHAb[2], unity_SHAb[3]);

				vertex_uniform_buffer_1[42] = float4(unity_SHBr[0], unity_SHBr[1], unity_SHBr[2], unity_SHBr[3]);

				vertex_uniform_buffer_1[43] = float4(unity_SHBg[0], unity_SHBg[1], unity_SHBg[2], unity_SHBg[3]);

				vertex_uniform_buffer_1[44] = float4(unity_SHBb[0], unity_SHBb[1], unity_SHBb[2], unity_SHBb[3]);

				vertex_uniform_buffer_1[45] = float4(unity_SHC[0], unity_SHC[1], unity_SHC[2], unity_SHC[3]);

				vertex_uniform_buffer_2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_2[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_2[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_2[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_2[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_2[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_3[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_3[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_3[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_3[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // VERTEXLIGHT_ON
			#endif // !SHADOWS_SCREEN


			#ifdef DIRECTIONAL
			#ifdef SHADOWS_SCREEN
			#ifdef VERTEXLIGHT_ON
			#ifndef LIGHTPROBE_SH
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _ProjectionParams;
			float4 unity_4LightPosX0;
			float4 unity_4LightPosY0;
			float4 unity_4LightPosZ0;
			float4 unity_4LightAtten0;
			float4 unity_LightColor[8];
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[6];
			static float4 vertex_uniform_buffer_2[15];
			static float4 vertex_uniform_buffer_3[10];
			static float4 vertex_uniform_buffer_4[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_86 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_88 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_89 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_116 = mad(vertex_uniform_buffer_3[2u].x, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].x));
				float vertex_unnamed_117 = mad(vertex_uniform_buffer_3[2u].y, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].y));
				float vertex_unnamed_118 = mad(vertex_uniform_buffer_3[2u].z, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].z));
				float vertex_unnamed_127 = vertex_unnamed_116 + vertex_uniform_buffer_3[3u].x;
				float vertex_unnamed_128 = vertex_unnamed_117 + vertex_uniform_buffer_3[3u].y;
				float vertex_unnamed_129 = vertex_unnamed_118 + vertex_uniform_buffer_3[3u].z;
				float vertex_unnamed_130 = mad(vertex_uniform_buffer_3[2u].w, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].w, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].w)) + vertex_uniform_buffer_3[3u].w;
				float vertex_unnamed_138 = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_116);
				float vertex_unnamed_139 = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_117);
				float vertex_unnamed_140 = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_118);
				float vertex_unnamed_181 = mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].x)));
				float vertex_unnamed_182 = mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].y)));
				float vertex_unnamed_183 = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].z)));
				float vertex_unnamed_184 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].w)));
				gl_Position.x = vertex_unnamed_181;
				gl_Position.y = vertex_unnamed_182;
				gl_Position.z = vertex_unnamed_183;
				gl_Position.w = vertex_unnamed_184;
				float vertex_unnamed_193 = rsqrt(dot(float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89), float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89)));
				float vertex_unnamed_194 = vertex_unnamed_193 * vertex_unnamed_89;
				float vertex_unnamed_195 = vertex_unnamed_193 * vertex_unnamed_86;
				float vertex_unnamed_196 = vertex_unnamed_193 * vertex_unnamed_88;
				vertex_output_4.x = vertex_unnamed_86;
				vertex_output_4.y = vertex_unnamed_88;
				vertex_output_4.z = vertex_unnamed_89;
				float vertex_unnamed_209 = mad(vertex_unnamed_196, 0.0f, (-0.0f) - (vertex_unnamed_194 * 1.0f));
				float vertex_unnamed_211 = mad(vertex_unnamed_195, 1.0f, (-0.0f) - (vertex_unnamed_196 * 0.0f));
				bool vertex_unnamed_217 = sqrt(dot(float2(vertex_unnamed_209, vertex_unnamed_211), float2(vertex_unnamed_209, vertex_unnamed_211))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_224 = asfloat(vertex_unnamed_217 ? 1065353216u : asuint(vertex_unnamed_209));
				float vertex_unnamed_228 = asfloat(vertex_unnamed_217 ? 0u : asuint(vertex_unnamed_211));
				float vertex_unnamed_232 = rsqrt(dot(float2(vertex_unnamed_224, vertex_unnamed_228), float2(vertex_unnamed_224, vertex_unnamed_228)));
				float vertex_unnamed_233 = vertex_unnamed_232 * vertex_unnamed_224;
				float vertex_unnamed_234 = vertex_unnamed_232 * asfloat(vertex_unnamed_217 ? 0u : asuint(mad(vertex_unnamed_194, 0.0f, (-0.0f) - (vertex_unnamed_195 * 0.0f))));
				float vertex_unnamed_235 = vertex_unnamed_232 * vertex_unnamed_228;
				float vertex_unnamed_249 = mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].y);
				float vertex_unnamed_250 = mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].z);
				float vertex_unnamed_251 = mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].x);
				float vertex_unnamed_255 = rsqrt(dot(float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251), float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251)));
				float vertex_unnamed_256 = vertex_unnamed_255 * vertex_unnamed_249;
				float vertex_unnamed_257 = vertex_unnamed_255 * vertex_unnamed_250;
				float vertex_unnamed_258 = vertex_unnamed_255 * vertex_unnamed_251;
				vertex_output_1.x = vertex_unnamed_258;
				float vertex_unnamed_272 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[4u].xyz));
				float vertex_unnamed_287 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[5u].xyz));
				float vertex_unnamed_301 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[6u].xyz));
				float vertex_unnamed_307 = rsqrt(dot(float3(vertex_unnamed_301, vertex_unnamed_272, vertex_unnamed_287), float3(vertex_unnamed_301, vertex_unnamed_272, vertex_unnamed_287)));
				float vertex_unnamed_308 = vertex_unnamed_307 * vertex_unnamed_301;
				float vertex_unnamed_309 = vertex_unnamed_307 * vertex_unnamed_272;
				float vertex_unnamed_310 = vertex_unnamed_307 * vertex_unnamed_287;
				float vertex_unnamed_326 = vertex_input_2.w * vertex_uniform_buffer_3[9u].w;
				vertex_output_1.y = vertex_unnamed_326 * mad(vertex_unnamed_310, vertex_unnamed_257, (-0.0f) - (vertex_unnamed_256 * vertex_unnamed_308));
				vertex_output_1.z = vertex_unnamed_309;
				vertex_output_1.w = vertex_unnamed_138;
				vertex_output_2.x = vertex_unnamed_256;
				vertex_output_3.x = vertex_unnamed_257;
				vertex_output_2.y = vertex_unnamed_326 * mad(vertex_unnamed_308, vertex_unnamed_258, (-0.0f) - (vertex_unnamed_257 * vertex_unnamed_309));
				vertex_output_3.y = vertex_unnamed_326 * mad(vertex_unnamed_309, vertex_unnamed_256, (-0.0f) - (vertex_unnamed_258 * vertex_unnamed_310));
				vertex_output_2.z = vertex_unnamed_310;
				vertex_output_2.w = vertex_unnamed_139;
				vertex_output_3.z = vertex_unnamed_308;
				vertex_output_3.w = vertex_unnamed_140;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_233;
				vertex_output_6.y = vertex_unnamed_234;
				vertex_output_6.z = vertex_unnamed_235;
				float vertex_unnamed_371 = mad(vertex_input_1.y, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_input_1.z));
				float vertex_unnamed_372 = mad(vertex_input_1.z, vertex_unnamed_233, (-0.0f) - (vertex_unnamed_235 * vertex_input_1.x));
				float vertex_unnamed_373 = mad(vertex_input_1.x, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_233 * vertex_input_1.y));
				float vertex_unnamed_377 = rsqrt(dot(float3(vertex_unnamed_371, vertex_unnamed_372, vertex_unnamed_373), float3(vertex_unnamed_371, vertex_unnamed_372, vertex_unnamed_373)));
				vertex_output_7.x = vertex_unnamed_377 * vertex_unnamed_371;
				vertex_output_7.y = vertex_unnamed_377 * vertex_unnamed_372;
				vertex_output_7.z = vertex_unnamed_377 * vertex_unnamed_373;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_395 = vertex_unnamed_184 * 0.5f;
				vertex_output_9.x = mad(vertex_unnamed_181, 0.5f, vertex_unnamed_395);
				vertex_output_9.y = mad(vertex_unnamed_182, -0.5f, vertex_unnamed_395);
				vertex_output_12.x = vertex_unnamed_395 + (vertex_unnamed_181 * 0.5f);
				vertex_output_12.y = vertex_unnamed_395 + ((vertex_unnamed_182 * vertex_uniform_buffer_1[5u].x) * 0.5f);
				vertex_output_9.z = vertex_unnamed_183;
				vertex_output_9.w = vertex_unnamed_184;
				vertex_output_12.z = vertex_unnamed_183;
				vertex_output_12.w = vertex_unnamed_184;
				vertex_output_10.x = vertex_unnamed_138;
				vertex_output_10.y = vertex_unnamed_139;
				vertex_output_10.z = vertex_unnamed_140;
				float vertex_unnamed_417 = (-0.0f) - vertex_unnamed_139;
				float vertex_unnamed_424 = vertex_unnamed_417 + vertex_uniform_buffer_2[4u].x;
				float vertex_unnamed_425 = vertex_unnamed_417 + vertex_uniform_buffer_2[4u].y;
				float vertex_unnamed_426 = vertex_unnamed_417 + vertex_uniform_buffer_2[4u].z;
				float vertex_unnamed_427 = vertex_unnamed_417 + vertex_uniform_buffer_2[4u].w;
				float vertex_unnamed_436 = (-0.0f) - vertex_unnamed_138;
				float vertex_unnamed_443 = vertex_unnamed_436 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_444 = vertex_unnamed_436 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_445 = vertex_unnamed_436 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_446 = vertex_unnamed_436 + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_447 = (-0.0f) - vertex_unnamed_140;
				float vertex_unnamed_454 = vertex_unnamed_447 + vertex_uniform_buffer_2[5u].x;
				float vertex_unnamed_455 = vertex_unnamed_447 + vertex_uniform_buffer_2[5u].y;
				float vertex_unnamed_456 = vertex_unnamed_447 + vertex_uniform_buffer_2[5u].z;
				float vertex_unnamed_457 = vertex_unnamed_447 + vertex_uniform_buffer_2[5u].w;
				float vertex_unnamed_474 = max(mad(vertex_unnamed_454, vertex_unnamed_454, mad(vertex_unnamed_443, vertex_unnamed_443, vertex_unnamed_424 * vertex_unnamed_424)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_476 = max(mad(vertex_unnamed_455, vertex_unnamed_455, mad(vertex_unnamed_444, vertex_unnamed_444, vertex_unnamed_425 * vertex_unnamed_425)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_477 = max(mad(vertex_unnamed_456, vertex_unnamed_456, mad(vertex_unnamed_445, vertex_unnamed_445, vertex_unnamed_426 * vertex_unnamed_426)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_478 = max(mad(vertex_unnamed_457, vertex_unnamed_457, mad(vertex_unnamed_446, vertex_unnamed_446, vertex_unnamed_427 * vertex_unnamed_427)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_505 = (1.0f / mad(vertex_unnamed_474, vertex_uniform_buffer_2[6u].x, 1.0f)) * max(mad(vertex_unnamed_454, vertex_unnamed_308, mad(vertex_unnamed_443, vertex_unnamed_309, vertex_unnamed_310 * vertex_unnamed_424)) * rsqrt(vertex_unnamed_474), 0.0f);
				float vertex_unnamed_506 = (1.0f / mad(vertex_unnamed_476, vertex_uniform_buffer_2[6u].y, 1.0f)) * max(mad(vertex_unnamed_455, vertex_unnamed_308, mad(vertex_unnamed_444, vertex_unnamed_309, vertex_unnamed_310 * vertex_unnamed_425)) * rsqrt(vertex_unnamed_476), 0.0f);
				float vertex_unnamed_507 = (1.0f / mad(vertex_unnamed_477, vertex_uniform_buffer_2[6u].z, 1.0f)) * max(mad(vertex_unnamed_456, vertex_unnamed_308, mad(vertex_unnamed_445, vertex_unnamed_309, vertex_unnamed_310 * vertex_unnamed_426)) * rsqrt(vertex_unnamed_477), 0.0f);
				float vertex_unnamed_508 = (1.0f / mad(vertex_unnamed_478, vertex_uniform_buffer_2[6u].w, 1.0f)) * max(mad(vertex_unnamed_457, vertex_unnamed_308, mad(vertex_unnamed_446, vertex_unnamed_309, vertex_unnamed_310 * vertex_unnamed_427)) * rsqrt(vertex_unnamed_478), 0.0f);
				vertex_output_11.x = mad(vertex_uniform_buffer_2[10u].x, vertex_unnamed_508, mad(vertex_uniform_buffer_2[9u].x, vertex_unnamed_507, mad(vertex_uniform_buffer_2[7u].x, vertex_unnamed_505, vertex_unnamed_506 * vertex_uniform_buffer_2[8u].x)));
				vertex_output_11.y = mad(vertex_uniform_buffer_2[10u].y, vertex_unnamed_508, mad(vertex_uniform_buffer_2[9u].y, vertex_unnamed_507, mad(vertex_uniform_buffer_2[7u].y, vertex_unnamed_505, vertex_unnamed_506 * vertex_uniform_buffer_2[8u].y)));
				vertex_output_11.z = mad(vertex_uniform_buffer_2[10u].z, vertex_unnamed_508, mad(vertex_uniform_buffer_2[9u].z, vertex_unnamed_507, mad(vertex_uniform_buffer_2[7u].z, vertex_unnamed_505, vertex_unnamed_506 * vertex_uniform_buffer_2[8u].z)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[5] = float4(_ProjectionParams[0], _ProjectionParams[1], _ProjectionParams[2], _ProjectionParams[3]);

				vertex_uniform_buffer_2[3] = float4(unity_4LightPosX0[0], unity_4LightPosX0[1], unity_4LightPosX0[2], unity_4LightPosX0[3]);

				vertex_uniform_buffer_2[4] = float4(unity_4LightPosY0[0], unity_4LightPosY0[1], unity_4LightPosY0[2], unity_4LightPosY0[3]);

				vertex_uniform_buffer_2[5] = float4(unity_4LightPosZ0[0], unity_4LightPosZ0[1], unity_4LightPosZ0[2], unity_4LightPosZ0[3]);

				vertex_uniform_buffer_2[6] = float4(unity_4LightAtten0[0], unity_4LightAtten0[1], unity_4LightAtten0[2], unity_4LightAtten0[3]);

				vertex_uniform_buffer_2[7] = float4(unity_LightColor[0][0], unity_LightColor[0][1], unity_LightColor[0][2], unity_LightColor[0][3]);
				vertex_uniform_buffer_2[8] = float4(unity_LightColor[1][0], unity_LightColor[1][1], unity_LightColor[1][2], unity_LightColor[1][3]);
				vertex_uniform_buffer_2[9] = float4(unity_LightColor[2][0], unity_LightColor[2][1], unity_LightColor[2][2], unity_LightColor[2][3]);
				vertex_uniform_buffer_2[10] = float4(unity_LightColor[3][0], unity_LightColor[3][1], unity_LightColor[3][2], unity_LightColor[3][3]);
				vertex_uniform_buffer_2[11] = float4(unity_LightColor[4][0], unity_LightColor[4][1], unity_LightColor[4][2], unity_LightColor[4][3]);
				vertex_uniform_buffer_2[12] = float4(unity_LightColor[5][0], unity_LightColor[5][1], unity_LightColor[5][2], unity_LightColor[5][3]);
				vertex_uniform_buffer_2[13] = float4(unity_LightColor[6][0], unity_LightColor[6][1], unity_LightColor[6][2], unity_LightColor[6][3]);
				vertex_uniform_buffer_2[14] = float4(unity_LightColor[7][0], unity_LightColor[7][1], unity_LightColor[7][2], unity_LightColor[7][3]);

				vertex_uniform_buffer_3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_3[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_3[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_3[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_3[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_3[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_4[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_4[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_4[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_4[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // SHADOWS_SCREEN
			#endif // VERTEXLIGHT_ON
			#endif // !LIGHTPROBE_SH


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifdef SHADOWS_SCREEN
			#ifdef VERTEXLIGHT_ON
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _ProjectionParams;
			float4 unity_4LightPosX0;
			float4 unity_4LightPosY0;
			float4 unity_4LightPosZ0;
			float4 unity_4LightAtten0;
			float4 unity_LightColor[8];
			float4 unity_SHAr;
			float4 unity_SHAg;
			float4 unity_SHAb;
			float4 unity_SHBr;
			float4 unity_SHBg;
			float4 unity_SHBb;
			float4 unity_SHC;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[6];
			static float4 vertex_uniform_buffer_2[46];
			static float4 vertex_uniform_buffer_3[10];
			static float4 vertex_uniform_buffer_4[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float4 vertex_output_1;
			static float4 vertex_output_2;
			static float4 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float4 vertex_output_9;
			static float3 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float4 vertex_output_1 : TEXCOORD; // TEXCOORD
				float4 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float4 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float4 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float3 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 vertex_output_13 : TEXCOORD13; // TEXCOORD_13
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_86 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_88 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_89 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_116 = mad(vertex_uniform_buffer_3[2u].x, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].x));
				float vertex_unnamed_117 = mad(vertex_uniform_buffer_3[2u].y, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].y));
				float vertex_unnamed_118 = mad(vertex_uniform_buffer_3[2u].z, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].z));
				float vertex_unnamed_127 = vertex_unnamed_116 + vertex_uniform_buffer_3[3u].x;
				float vertex_unnamed_128 = vertex_unnamed_117 + vertex_uniform_buffer_3[3u].y;
				float vertex_unnamed_129 = vertex_unnamed_118 + vertex_uniform_buffer_3[3u].z;
				float vertex_unnamed_130 = mad(vertex_uniform_buffer_3[2u].w, vertex_unnamed_89, mad(vertex_uniform_buffer_3[0u].w, vertex_unnamed_86, vertex_unnamed_88 * vertex_uniform_buffer_3[1u].w)) + vertex_uniform_buffer_3[3u].w;
				float vertex_unnamed_138 = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_116);
				float vertex_unnamed_139 = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_117);
				float vertex_unnamed_140 = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_118);
				float vertex_unnamed_181 = mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].x)));
				float vertex_unnamed_182 = mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].y)));
				float vertex_unnamed_183 = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].z)));
				float vertex_unnamed_184 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_130, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_129, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_127, vertex_unnamed_128 * vertex_uniform_buffer_4[18u].w)));
				gl_Position.x = vertex_unnamed_181;
				gl_Position.y = vertex_unnamed_182;
				gl_Position.z = vertex_unnamed_183;
				gl_Position.w = vertex_unnamed_184;
				float vertex_unnamed_193 = rsqrt(dot(float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89), float3(vertex_unnamed_86, vertex_unnamed_88, vertex_unnamed_89)));
				float vertex_unnamed_194 = vertex_unnamed_193 * vertex_unnamed_89;
				float vertex_unnamed_195 = vertex_unnamed_193 * vertex_unnamed_86;
				float vertex_unnamed_196 = vertex_unnamed_193 * vertex_unnamed_88;
				vertex_output_4.x = vertex_unnamed_86;
				vertex_output_4.y = vertex_unnamed_88;
				vertex_output_4.z = vertex_unnamed_89;
				float vertex_unnamed_209 = mad(vertex_unnamed_196, 0.0f, (-0.0f) - (vertex_unnamed_194 * 1.0f));
				float vertex_unnamed_211 = mad(vertex_unnamed_195, 1.0f, (-0.0f) - (vertex_unnamed_196 * 0.0f));
				bool vertex_unnamed_217 = sqrt(dot(float2(vertex_unnamed_209, vertex_unnamed_211), float2(vertex_unnamed_209, vertex_unnamed_211))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_224 = asfloat(vertex_unnamed_217 ? 1065353216u : asuint(vertex_unnamed_209));
				float vertex_unnamed_228 = asfloat(vertex_unnamed_217 ? 0u : asuint(vertex_unnamed_211));
				float vertex_unnamed_232 = rsqrt(dot(float2(vertex_unnamed_224, vertex_unnamed_228), float2(vertex_unnamed_224, vertex_unnamed_228)));
				float vertex_unnamed_233 = vertex_unnamed_232 * vertex_unnamed_224;
				float vertex_unnamed_234 = vertex_unnamed_232 * asfloat(vertex_unnamed_217 ? 0u : asuint(mad(vertex_unnamed_194, 0.0f, (-0.0f) - (vertex_unnamed_195 * 0.0f))));
				float vertex_unnamed_235 = vertex_unnamed_232 * vertex_unnamed_228;
				float vertex_unnamed_249 = mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].y);
				float vertex_unnamed_250 = mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].z);
				float vertex_unnamed_251 = mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_233, vertex_unnamed_235 * vertex_uniform_buffer_3[2u].x);
				float vertex_unnamed_255 = rsqrt(dot(float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251), float3(vertex_unnamed_249, vertex_unnamed_250, vertex_unnamed_251)));
				float vertex_unnamed_256 = vertex_unnamed_255 * vertex_unnamed_249;
				float vertex_unnamed_257 = vertex_unnamed_255 * vertex_unnamed_250;
				float vertex_unnamed_258 = vertex_unnamed_255 * vertex_unnamed_251;
				vertex_output_1.x = vertex_unnamed_258;
				float vertex_unnamed_266 = vertex_input_2.w * vertex_uniform_buffer_3[9u].w;
				float vertex_unnamed_279 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[4u].xyz));
				float vertex_unnamed_294 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[5u].xyz));
				float vertex_unnamed_308 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[6u].xyz));
				float vertex_unnamed_314 = rsqrt(dot(float3(vertex_unnamed_279, vertex_unnamed_294, vertex_unnamed_308), float3(vertex_unnamed_279, vertex_unnamed_294, vertex_unnamed_308)));
				float vertex_unnamed_315 = vertex_unnamed_314 * vertex_unnamed_279;
				float vertex_unnamed_316 = vertex_unnamed_314 * vertex_unnamed_294;
				float vertex_unnamed_317 = vertex_unnamed_314 * vertex_unnamed_308;
				vertex_output_1.y = vertex_unnamed_266 * mad(vertex_unnamed_316, vertex_unnamed_257, (-0.0f) - (vertex_unnamed_256 * vertex_unnamed_317));
				vertex_output_1.w = vertex_unnamed_138;
				vertex_output_1.z = vertex_unnamed_315;
				vertex_output_2.x = vertex_unnamed_256;
				vertex_output_3.x = vertex_unnamed_257;
				vertex_output_2.y = vertex_unnamed_266 * mad(vertex_unnamed_317, vertex_unnamed_258, (-0.0f) - (vertex_unnamed_257 * vertex_unnamed_315));
				vertex_output_3.y = vertex_unnamed_266 * mad(vertex_unnamed_315, vertex_unnamed_256, (-0.0f) - (vertex_unnamed_258 * vertex_unnamed_316));
				vertex_output_2.w = vertex_unnamed_139;
				vertex_output_2.z = vertex_unnamed_316;
				vertex_output_3.w = vertex_unnamed_140;
				vertex_output_3.z = vertex_unnamed_317;
				vertex_output_5.x = vertex_input_1.x;
				vertex_output_5.y = vertex_input_1.y;
				vertex_output_5.z = vertex_input_1.z;
				vertex_output_6.x = vertex_unnamed_233;
				vertex_output_6.y = vertex_unnamed_234;
				vertex_output_6.z = vertex_unnamed_235;
				float vertex_unnamed_371 = mad(vertex_input_1.y, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_input_1.z));
				float vertex_unnamed_372 = mad(vertex_input_1.z, vertex_unnamed_233, (-0.0f) - (vertex_unnamed_235 * vertex_input_1.x));
				float vertex_unnamed_373 = mad(vertex_input_1.x, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_233 * vertex_input_1.y));
				float vertex_unnamed_377 = rsqrt(dot(float3(vertex_unnamed_371, vertex_unnamed_372, vertex_unnamed_373), float3(vertex_unnamed_371, vertex_unnamed_372, vertex_unnamed_373)));
				vertex_output_7.x = vertex_unnamed_377 * vertex_unnamed_371;
				vertex_output_7.y = vertex_unnamed_377 * vertex_unnamed_372;
				vertex_output_7.z = vertex_unnamed_377 * vertex_unnamed_373;
				vertex_output_8.x = vertex_input_3.x;
				vertex_output_8.y = vertex_input_3.y;
				vertex_output_8.z = vertex_input_3.z;
				float vertex_unnamed_395 = vertex_unnamed_184 * 0.5f;
				vertex_output_9.x = mad(vertex_unnamed_181, 0.5f, vertex_unnamed_395);
				vertex_output_9.y = mad(vertex_unnamed_182, -0.5f, vertex_unnamed_395);
				vertex_output_12.x = vertex_unnamed_395 + (vertex_unnamed_181 * 0.5f);
				vertex_output_12.y = vertex_unnamed_395 + ((vertex_unnamed_182 * vertex_uniform_buffer_1[5u].x) * 0.5f);
				vertex_output_9.z = vertex_unnamed_183;
				vertex_output_9.w = vertex_unnamed_184;
				vertex_output_12.z = vertex_unnamed_183;
				vertex_output_12.w = vertex_unnamed_184;
				vertex_output_10.x = vertex_unnamed_138;
				vertex_output_10.y = vertex_unnamed_139;
				vertex_output_10.z = vertex_unnamed_140;
				float vertex_unnamed_419 = mad(vertex_unnamed_315, vertex_unnamed_315, (-0.0f) - (vertex_unnamed_316 * vertex_unnamed_316));
				float vertex_unnamed_420 = vertex_unnamed_316 * vertex_unnamed_315;
				float vertex_unnamed_421 = vertex_unnamed_317 * vertex_unnamed_316;
				float vertex_unnamed_422 = vertex_unnamed_317 * vertex_unnamed_317;
				float vertex_unnamed_423 = vertex_unnamed_315 * vertex_unnamed_317;
				float vertex_unnamed_463 = asfloat(1065353216u);
				float vertex_unnamed_497 = (-0.0f) - vertex_unnamed_139;
				float vertex_unnamed_504 = vertex_unnamed_497 + vertex_uniform_buffer_2[4u].x;
				float vertex_unnamed_505 = vertex_unnamed_497 + vertex_uniform_buffer_2[4u].y;
				float vertex_unnamed_506 = vertex_unnamed_497 + vertex_uniform_buffer_2[4u].z;
				float vertex_unnamed_507 = vertex_unnamed_497 + vertex_uniform_buffer_2[4u].w;
				float vertex_unnamed_516 = (-0.0f) - vertex_unnamed_138;
				float vertex_unnamed_523 = vertex_unnamed_516 + vertex_uniform_buffer_2[3u].x;
				float vertex_unnamed_524 = vertex_unnamed_516 + vertex_uniform_buffer_2[3u].y;
				float vertex_unnamed_525 = vertex_unnamed_516 + vertex_uniform_buffer_2[3u].z;
				float vertex_unnamed_526 = vertex_unnamed_516 + vertex_uniform_buffer_2[3u].w;
				float vertex_unnamed_527 = (-0.0f) - vertex_unnamed_140;
				float vertex_unnamed_534 = vertex_unnamed_527 + vertex_uniform_buffer_2[5u].x;
				float vertex_unnamed_535 = vertex_unnamed_527 + vertex_uniform_buffer_2[5u].y;
				float vertex_unnamed_536 = vertex_unnamed_527 + vertex_uniform_buffer_2[5u].z;
				float vertex_unnamed_537 = vertex_unnamed_527 + vertex_uniform_buffer_2[5u].w;
				float vertex_unnamed_554 = max(mad(vertex_unnamed_534, vertex_unnamed_534, mad(vertex_unnamed_523, vertex_unnamed_523, vertex_unnamed_504 * vertex_unnamed_504)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_556 = max(mad(vertex_unnamed_535, vertex_unnamed_535, mad(vertex_unnamed_524, vertex_unnamed_524, vertex_unnamed_505 * vertex_unnamed_505)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_557 = max(mad(vertex_unnamed_536, vertex_unnamed_536, mad(vertex_unnamed_525, vertex_unnamed_525, vertex_unnamed_506 * vertex_unnamed_506)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_558 = max(mad(vertex_unnamed_537, vertex_unnamed_537, mad(vertex_unnamed_526, vertex_unnamed_526, vertex_unnamed_507 * vertex_unnamed_507)), 9.9999999747524270787835121154785e-07f);
				float vertex_unnamed_585 = (1.0f / mad(vertex_unnamed_554, vertex_uniform_buffer_2[6u].x, 1.0f)) * max(mad(vertex_unnamed_534, vertex_unnamed_317, mad(vertex_unnamed_523, vertex_unnamed_315, vertex_unnamed_316 * vertex_unnamed_504)) * rsqrt(vertex_unnamed_554), 0.0f);
				float vertex_unnamed_586 = (1.0f / mad(vertex_unnamed_556, vertex_uniform_buffer_2[6u].y, 1.0f)) * max(mad(vertex_unnamed_535, vertex_unnamed_317, mad(vertex_unnamed_524, vertex_unnamed_315, vertex_unnamed_316 * vertex_unnamed_505)) * rsqrt(vertex_unnamed_556), 0.0f);
				float vertex_unnamed_587 = (1.0f / mad(vertex_unnamed_557, vertex_uniform_buffer_2[6u].z, 1.0f)) * max(mad(vertex_unnamed_536, vertex_unnamed_317, mad(vertex_unnamed_525, vertex_unnamed_315, vertex_unnamed_316 * vertex_unnamed_506)) * rsqrt(vertex_unnamed_557), 0.0f);
				float vertex_unnamed_588 = (1.0f / mad(vertex_unnamed_558, vertex_uniform_buffer_2[6u].w, 1.0f)) * max(mad(vertex_unnamed_537, vertex_unnamed_317, mad(vertex_unnamed_526, vertex_unnamed_315, vertex_unnamed_316 * vertex_unnamed_507)) * rsqrt(vertex_unnamed_558), 0.0f);
				vertex_output_11.x = (mad(vertex_uniform_buffer_2[45u].x, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[42u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[39u]), float4(vertex_unnamed_315, vertex_unnamed_316, vertex_unnamed_317, vertex_unnamed_463))) + mad(vertex_uniform_buffer_2[10u].x, vertex_unnamed_588, mad(vertex_uniform_buffer_2[9u].x, vertex_unnamed_587, mad(vertex_uniform_buffer_2[7u].x, vertex_unnamed_585, vertex_unnamed_586 * vertex_uniform_buffer_2[8u].x)));
				vertex_output_11.y = (mad(vertex_uniform_buffer_2[45u].y, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[43u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[40u]), float4(vertex_unnamed_315, vertex_unnamed_316, vertex_unnamed_317, vertex_unnamed_463))) + mad(vertex_uniform_buffer_2[10u].y, vertex_unnamed_588, mad(vertex_uniform_buffer_2[9u].y, vertex_unnamed_587, mad(vertex_uniform_buffer_2[7u].y, vertex_unnamed_585, vertex_unnamed_586 * vertex_uniform_buffer_2[8u].y)));
				vertex_output_11.z = (mad(vertex_uniform_buffer_2[45u].z, vertex_unnamed_419, dot(float4(vertex_uniform_buffer_2[44u]), float4(vertex_unnamed_420, vertex_unnamed_421, vertex_unnamed_422, vertex_unnamed_423))) + dot(float4(vertex_uniform_buffer_2[41u]), float4(vertex_unnamed_315, vertex_unnamed_316, vertex_unnamed_317, vertex_unnamed_463))) + mad(vertex_uniform_buffer_2[10u].z, vertex_unnamed_588, mad(vertex_uniform_buffer_2[9u].z, vertex_unnamed_587, mad(vertex_uniform_buffer_2[7u].z, vertex_unnamed_585, vertex_unnamed_586 * vertex_uniform_buffer_2[8u].z)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[5] = float4(_ProjectionParams[0], _ProjectionParams[1], _ProjectionParams[2], _ProjectionParams[3]);

				vertex_uniform_buffer_2[3] = float4(unity_4LightPosX0[0], unity_4LightPosX0[1], unity_4LightPosX0[2], unity_4LightPosX0[3]);

				vertex_uniform_buffer_2[4] = float4(unity_4LightPosY0[0], unity_4LightPosY0[1], unity_4LightPosY0[2], unity_4LightPosY0[3]);

				vertex_uniform_buffer_2[5] = float4(unity_4LightPosZ0[0], unity_4LightPosZ0[1], unity_4LightPosZ0[2], unity_4LightPosZ0[3]);

				vertex_uniform_buffer_2[6] = float4(unity_4LightAtten0[0], unity_4LightAtten0[1], unity_4LightAtten0[2], unity_4LightAtten0[3]);

				vertex_uniform_buffer_2[7] = float4(unity_LightColor[0][0], unity_LightColor[0][1], unity_LightColor[0][2], unity_LightColor[0][3]);
				vertex_uniform_buffer_2[8] = float4(unity_LightColor[1][0], unity_LightColor[1][1], unity_LightColor[1][2], unity_LightColor[1][3]);
				vertex_uniform_buffer_2[9] = float4(unity_LightColor[2][0], unity_LightColor[2][1], unity_LightColor[2][2], unity_LightColor[2][3]);
				vertex_uniform_buffer_2[10] = float4(unity_LightColor[3][0], unity_LightColor[3][1], unity_LightColor[3][2], unity_LightColor[3][3]);
				vertex_uniform_buffer_2[11] = float4(unity_LightColor[4][0], unity_LightColor[4][1], unity_LightColor[4][2], unity_LightColor[4][3]);
				vertex_uniform_buffer_2[12] = float4(unity_LightColor[5][0], unity_LightColor[5][1], unity_LightColor[5][2], unity_LightColor[5][3]);
				vertex_uniform_buffer_2[13] = float4(unity_LightColor[6][0], unity_LightColor[6][1], unity_LightColor[6][2], unity_LightColor[6][3]);
				vertex_uniform_buffer_2[14] = float4(unity_LightColor[7][0], unity_LightColor[7][1], unity_LightColor[7][2], unity_LightColor[7][3]);

				vertex_uniform_buffer_2[39] = float4(unity_SHAr[0], unity_SHAr[1], unity_SHAr[2], unity_SHAr[3]);

				vertex_uniform_buffer_2[40] = float4(unity_SHAg[0], unity_SHAg[1], unity_SHAg[2], unity_SHAg[3]);

				vertex_uniform_buffer_2[41] = float4(unity_SHAb[0], unity_SHAb[1], unity_SHAb[2], unity_SHAb[3]);

				vertex_uniform_buffer_2[42] = float4(unity_SHBr[0], unity_SHBr[1], unity_SHBr[2], unity_SHBr[3]);

				vertex_uniform_buffer_2[43] = float4(unity_SHBg[0], unity_SHBg[1], unity_SHBg[2], unity_SHBg[3]);

				vertex_uniform_buffer_2[44] = float4(unity_SHBb[0], unity_SHBb[1], unity_SHBb[2], unity_SHBb[3]);

				vertex_uniform_buffer_2[45] = float4(unity_SHC[0], unity_SHC[1], unity_SHC[2], unity_SHC[3]);

				vertex_uniform_buffer_3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_3[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_3[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_3[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_3[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_3[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_4[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_4[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_4[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_4[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // SHADOWS_SCREEN
			#endif // VERTEXLIGHT_ON


			#ifdef DIRECTIONAL
			#ifndef LIGHTPROBE_SH
			#ifndef SHADOWS_SCREEN
			#define ANY_SHADER_VARIANT_ACTIVE

			float4 _LightColor0;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[26];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _EmissionTex1;
			SamplerState sampler_EmissionTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _EmissionTex2;
			SamplerState sampler_EmissionTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _EmissionTex3;
			SamplerState sampler_EmissionTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;
			Texture2D<float4> _PaintingTexture;
			SamplerState sampler_PaintingTexture;

			static float4 fragment_input_1;
			static float4 fragment_input_2;
			static float4 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float4 fragment_input_9;
			static float3 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float4 fragment_input_1 : TEXCOORD; // TEXCOORD
				float4 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float4 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float4 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float3 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD12; // TEXCOORD_12
				float4 fragment_input_13 : TEXCOORD13; // TEXCOORD_13
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2213)
			{
				if (fragment_unnamed_2213)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_133 = rsqrt(dot(float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z), float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z)));
				float fragment_unnamed_140 = fragment_unnamed_133 * fragment_input_4.y;
				float fragment_unnamed_141 = fragment_unnamed_133 * fragment_input_4.x;
				float fragment_unnamed_142 = fragment_unnamed_133 * fragment_input_4.z;
				uint fragment_unnamed_151 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_157 = sqrt(((-0.0f) - abs(fragment_unnamed_140)) + 1.0f);
				float fragment_unnamed_166 = mad(mad(mad(abs(fragment_unnamed_140), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_140), -0.212114393711090087890625f), abs(fragment_unnamed_140), 1.570728778839111328125f);
				float fragment_unnamed_191 = (1.0f / max(abs(fragment_unnamed_142), abs(fragment_unnamed_141))) * min(abs(fragment_unnamed_142), abs(fragment_unnamed_141));
				float fragment_unnamed_192 = fragment_unnamed_191 * fragment_unnamed_191;
				float fragment_unnamed_200 = mad(fragment_unnamed_192, mad(fragment_unnamed_192, mad(fragment_unnamed_192, mad(fragment_unnamed_192, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_218 = asfloat(((((-0.0f) - fragment_unnamed_142) < fragment_unnamed_142) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_191, fragment_unnamed_200, asfloat(((abs(fragment_unnamed_142) < abs(fragment_unnamed_141)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_200 * fragment_unnamed_191, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_220 = min((-0.0f) - fragment_unnamed_142, fragment_unnamed_141);
				float fragment_unnamed_222 = max((-0.0f) - fragment_unnamed_142, fragment_unnamed_141);
				float fragment_unnamed_236 = (((-0.0f) - mad(fragment_unnamed_166, fragment_unnamed_157, asfloat(((fragment_unnamed_140 < ((-0.0f) - fragment_unnamed_140)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_157 * fragment_unnamed_166, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_237 = fragment_unnamed_236 * 0.3183098733425140380859375f;
				bool fragment_unnamed_239 = 0.0f < fragment_unnamed_236;
				float fragment_unnamed_246 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_237)) : asuint(floor(fragment_unnamed_237)));
				float fragment_unnamed_250 = float(fragment_unnamed_151);
				uint fragment_unnamed_258 = uint(asfloat((0.0f < fragment_unnamed_246) ? asuint(fragment_unnamed_246 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_246) + fragment_unnamed_250) + (-0.89999997615814208984375f))));
				int fragment_unnamed_261 = _OffsetsBuffer.Load(fragment_unnamed_258);
				float fragment_unnamed_268 = float((-fragment_unnamed_261) + _OffsetsBuffer.Load(fragment_unnamed_258 + 1u));
				float fragment_unnamed_269 = mad(((((fragment_unnamed_222 >= ((-0.0f) - fragment_unnamed_222)) ? 4294967295u : 0u) & ((fragment_unnamed_220 < ((-0.0f) - fragment_unnamed_220)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_218) : fragment_unnamed_218, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_271 = fragment_unnamed_268 * fragment_unnamed_269;
				bool fragment_unnamed_272 = 0.0f < fragment_unnamed_271;
				float fragment_unnamed_278 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_271)) : asuint(floor(fragment_unnamed_271)));
				float fragment_unnamed_279 = mad(fragment_unnamed_268, 0.5f, 0.5f);
				float fragment_unnamed_295 = float(fragment_unnamed_261 + uint(asfloat((fragment_unnamed_279 < fragment_unnamed_278) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_278) + (-1.0f)) : asuint(fragment_unnamed_268 + ((-0.0f) - fragment_unnamed_278))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_298 = frac(fragment_unnamed_295);
				uint fragment_unnamed_301 = _DataBuffer.Load(uint(floor(fragment_unnamed_295)));
				uint fragment_unnamed_313 = 16u & 31u;
				uint fragment_unnamed_320 = 8u & 31u;
				uint fragment_unnamed_328 = (0.625f < fragment_unnamed_298) ? (fragment_unnamed_301 >> 24u) : ((0.375f < fragment_unnamed_298) ? spvBitfieldUExtract(fragment_unnamed_301, fragment_unnamed_313, min((8u & 31u), (32u - fragment_unnamed_313))) : ((0.125f < fragment_unnamed_298) ? spvBitfieldUExtract(fragment_unnamed_301, fragment_unnamed_320, min((8u & 31u), (32u - fragment_unnamed_320))) : (fragment_unnamed_301 & 255u)));
				float fragment_unnamed_335 = float(fragment_unnamed_328 >> 5u);
				float fragment_unnamed_342 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(fragment_unnamed_335 < (fragment_unnamed_342 + 0.00999999977648258209228515625f));
				uint reform_index = fragment_unnamed_295 * 4;
				bool is_reform_transparent = (fragment_unnamed_342 + 3.9900000095367431640625f) < fragment_unnamed_335;
				uint n_index = frac(fragment_uniform_buffer_0[14u].x / 2 - fragment_unnamed_237) * 8;
				uint m_index = frac(fragment_unnamed_271) * 8;
				float4 fragment_unnamed_848 = is_reform_transparent ? _PaintingTexture.Sample(sampler_ColorsTexture, float2((reform_index % 512 * 8 + m_index + 0.5f) / 4096.0f, 1 - (reform_index / 512 * 8 + n_index + 0.5f) / 5088.0f)) : _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_328 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				discard_cond(is_reform_transparent && fragment_unnamed_848.w < 0.0001);
				float fragment_unnamed_361 = mad(fragment_unnamed_236, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_362 = mad(fragment_unnamed_236, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_373 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_361)) : asuint(floor(fragment_unnamed_361)));
				float fragment_unnamed_375 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_362)) : asuint(floor(fragment_unnamed_362)));
				uint fragment_unnamed_377 = uint(ceil(max(abs(fragment_unnamed_237) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_396 = uint(asfloat((0.0f < fragment_unnamed_373) ? asuint(fragment_unnamed_373 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_250 + ((-0.0f) - fragment_unnamed_373)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_397 = uint(asfloat((0.0f < fragment_unnamed_375) ? asuint(fragment_unnamed_375 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_250 + ((-0.0f) - fragment_unnamed_375)) + (-0.89999997615814208984375f))));
				int fragment_unnamed_399 = _OffsetsBuffer.Load(fragment_unnamed_396);
				int fragment_unnamed_401 = _OffsetsBuffer.Load(fragment_unnamed_397);
				uint fragment_unnamed_412 = (fragment_unnamed_258 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_415 = (fragment_unnamed_258 != (fragment_unnamed_151 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_418 = (fragment_unnamed_151 != fragment_unnamed_258) ? 4294967295u : 0u;
				uint fragment_unnamed_422 = (fragment_unnamed_258 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_438 = (fragment_unnamed_422 & (fragment_unnamed_418 & (fragment_unnamed_412 & fragment_unnamed_415))) != 0u;
				uint fragment_unnamed_441 = asuint(fragment_unnamed_268);
				uint fragment_unnamed_442 = fragment_unnamed_438 ? asuint(float((-fragment_unnamed_399) + _OffsetsBuffer.Load(fragment_unnamed_396 + 1u))) : fragment_unnamed_441;
				float fragment_unnamed_444 = asfloat(fragment_unnamed_438 ? asuint(float((-fragment_unnamed_401) + _OffsetsBuffer.Load(fragment_unnamed_397 + 1u))) : fragment_unnamed_441);
				float fragment_unnamed_447 = fragment_unnamed_269 * asfloat(fragment_unnamed_442);
				float fragment_unnamed_448 = fragment_unnamed_269 * fragment_unnamed_444;
				float fragment_unnamed_449 = mad(fragment_unnamed_269, fragment_unnamed_268, 0.5f);
				float fragment_unnamed_450 = mad(fragment_unnamed_269, fragment_unnamed_268, -0.5f);
				float fragment_unnamed_457 = asfloat((fragment_unnamed_268 < fragment_unnamed_449) ? asuint(((-0.0f) - fragment_unnamed_268) + fragment_unnamed_449) : asuint(fragment_unnamed_449));
				float fragment_unnamed_463 = asfloat((fragment_unnamed_450 < 0.0f) ? asuint(fragment_unnamed_268 + fragment_unnamed_450) : asuint(fragment_unnamed_450));
				float fragment_unnamed_473 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_447)) : asuint(floor(fragment_unnamed_447)));
				float fragment_unnamed_475 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_448)) : asuint(floor(fragment_unnamed_448)));
				float fragment_unnamed_481 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_457)) : asuint(floor(fragment_unnamed_457)));
				float fragment_unnamed_487 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_463)) : asuint(floor(fragment_unnamed_463)));
				float fragment_unnamed_488 = frac(fragment_unnamed_237);
				float fragment_unnamed_489 = frac(fragment_unnamed_271);
				float fragment_unnamed_490 = fragment_unnamed_488 + (-0.5f);
				float fragment_unnamed_499 = min((((-0.0f) - fragment_unnamed_489) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_501 = min(fragment_unnamed_489 * 40.0f, 1.0f);
				float fragment_unnamed_502 = min(fragment_unnamed_488 * 40.0f, 1.0f);
				float fragment_unnamed_561 = float(fragment_unnamed_399 + uint(asfloat((mad(asfloat(fragment_unnamed_442), 0.5f, 0.5f) < fragment_unnamed_473) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_442), 0.5f, fragment_unnamed_473) + (-1.0f)) : asuint(asfloat(fragment_unnamed_442) + ((-0.0f) - fragment_unnamed_473))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_563 = frac(fragment_unnamed_561);
				uint fragment_unnamed_566 = _DataBuffer.Load(uint(floor(fragment_unnamed_561)));
				uint fragment_unnamed_572 = 16u & 31u;
				uint fragment_unnamed_577 = 8u & 31u;
				float fragment_unnamed_587 = float(uint(asfloat((mad(fragment_unnamed_444, 0.5f, 0.5f) < fragment_unnamed_475) ? asuint(mad((-0.0f) - fragment_unnamed_444, 0.5f, fragment_unnamed_475) + (-1.0f)) : asuint(fragment_unnamed_444 + ((-0.0f) - fragment_unnamed_475))) + 0.100000001490116119384765625f) + fragment_unnamed_401) * 0.25f;
				float fragment_unnamed_589 = frac(fragment_unnamed_587);
				uint fragment_unnamed_592 = _DataBuffer.Load(uint(floor(fragment_unnamed_587)));
				uint fragment_unnamed_598 = 16u & 31u;
				uint fragment_unnamed_603 = 8u & 31u;
				float fragment_unnamed_613 = float(uint(asfloat((fragment_unnamed_279 < fragment_unnamed_481) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_481) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_481) + fragment_unnamed_268)) + 0.100000001490116119384765625f) + fragment_unnamed_261) * 0.25f;
				float fragment_unnamed_615 = frac(fragment_unnamed_613);
				uint fragment_unnamed_618 = _DataBuffer.Load(uint(floor(fragment_unnamed_613)));
				uint fragment_unnamed_624 = 16u & 31u;
				uint fragment_unnamed_629 = 8u & 31u;
				float fragment_unnamed_639 = float(uint(asfloat((fragment_unnamed_279 < fragment_unnamed_487) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_487) + (-1.0f)) : asuint(fragment_unnamed_268 + ((-0.0f) - fragment_unnamed_487))) + 0.100000001490116119384765625f) + fragment_unnamed_261) * 0.25f;
				float fragment_unnamed_641 = frac(fragment_unnamed_639);
				uint fragment_unnamed_644 = _DataBuffer.Load(uint(floor(fragment_unnamed_639)));
				uint fragment_unnamed_650 = 16u & 31u;
				uint fragment_unnamed_655 = 8u & 31u;
				float fragment_unnamed_665 = float(((0.625f < fragment_unnamed_589) ? (fragment_unnamed_592 >> 24u) : ((0.375f < fragment_unnamed_589) ? spvBitfieldUExtract(fragment_unnamed_592, fragment_unnamed_598, min((8u & 31u), (32u - fragment_unnamed_598))) : ((0.125f < fragment_unnamed_589) ? spvBitfieldUExtract(fragment_unnamed_592, fragment_unnamed_603, min((8u & 31u), (32u - fragment_unnamed_603))) : (fragment_unnamed_592 & 255u)))) >> 5u);
				float fragment_unnamed_667 = float(((0.625f < fragment_unnamed_615) ? (fragment_unnamed_618 >> 24u) : ((0.375f < fragment_unnamed_615) ? spvBitfieldUExtract(fragment_unnamed_618, fragment_unnamed_624, min((8u & 31u), (32u - fragment_unnamed_624))) : ((0.125f < fragment_unnamed_615) ? spvBitfieldUExtract(fragment_unnamed_618, fragment_unnamed_629, min((8u & 31u), (32u - fragment_unnamed_629))) : (fragment_unnamed_618 & 255u)))) >> 5u);
				float fragment_unnamed_669 = float(((0.625f < fragment_unnamed_641) ? (fragment_unnamed_644 >> 24u) : ((0.375f < fragment_unnamed_641) ? spvBitfieldUExtract(fragment_unnamed_644, fragment_unnamed_650, min((8u & 31u), (32u - fragment_unnamed_650))) : ((0.125f < fragment_unnamed_641) ? spvBitfieldUExtract(fragment_unnamed_644, fragment_unnamed_655, min((8u & 31u), (32u - fragment_unnamed_655))) : (fragment_unnamed_644 & 255u)))) >> 5u);
				float fragment_unnamed_670 = float(((0.625f < fragment_unnamed_563) ? (fragment_unnamed_566 >> 24u) : ((0.375f < fragment_unnamed_563) ? spvBitfieldUExtract(fragment_unnamed_566, fragment_unnamed_572, min((8u & 31u), (32u - fragment_unnamed_572))) : ((0.125f < fragment_unnamed_563) ? spvBitfieldUExtract(fragment_unnamed_566, fragment_unnamed_577, min((8u & 31u), (32u - fragment_unnamed_577))) : (fragment_unnamed_566 & 255u)))) >> 5u);
				float fragment_unnamed_681 = fragment_unnamed_271 * 0.20000000298023223876953125f;
				float fragment_unnamed_683 = fragment_unnamed_236 * 0.06366197764873504638671875f;
				float fragment_unnamed_685 = (fragment_unnamed_269 * float((-_OffsetsBuffer.Load(fragment_unnamed_377)) + _OffsetsBuffer.Load(fragment_unnamed_377 + 1u))) * 0.20000000298023223876953125f;
				float fragment_unnamed_692 = ddx_coarse(fragment_input_10.x);
				float fragment_unnamed_693 = ddx_coarse(fragment_input_10.y);
				float fragment_unnamed_694 = ddx_coarse(fragment_input_10.z);
				float fragment_unnamed_698 = sqrt(dot(float3(fragment_unnamed_692, fragment_unnamed_693, fragment_unnamed_694), float3(fragment_unnamed_692, fragment_unnamed_693, fragment_unnamed_694)));
				float fragment_unnamed_705 = ddy_coarse(fragment_input_10.x);
				float fragment_unnamed_706 = ddy_coarse(fragment_input_10.y);
				float fragment_unnamed_707 = ddy_coarse(fragment_input_10.z);
				float fragment_unnamed_711 = sqrt(dot(float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707), float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707)));
				float fragment_unnamed_722 = min(max(log2(sqrt(dot(float2(fragment_unnamed_698, fragment_unnamed_711), float2(fragment_unnamed_698, fragment_unnamed_711))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_724 = min((((-0.0f) - fragment_unnamed_488) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_802;
				float fragment_unnamed_804;
				float fragment_unnamed_806;
				float fragment_unnamed_808;
				float fragment_unnamed_810;
				float fragment_unnamed_812;
				float fragment_unnamed_814;
				float fragment_unnamed_816;
				float fragment_unnamed_818;
				float fragment_unnamed_820;
				float fragment_unnamed_822;
				float fragment_unnamed_824;
				float fragment_unnamed_826;
				float fragment_unnamed_828;
				float fragment_unnamed_830;
				float fragment_unnamed_832;
				float fragment_unnamed_834;
				float fragment_unnamed_836;
				float fragment_unnamed_838;
				float fragment_unnamed_840;
				if ((((((fragment_unnamed_342 + 0.9900000095367431640625f) < fragment_unnamed_335) ? 4294967295u : 0u) & ((fragment_unnamed_335 < (fragment_unnamed_342 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) | (((fragment_unnamed_342 + 3.9900000095367431640625f) < fragment_unnamed_335) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_737 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float4 fragment_unnamed_743 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					float4 fragment_unnamed_750 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float fragment_unnamed_756 = mad(fragment_unnamed_750.w * fragment_unnamed_750.x, 2.0f, -1.0f);
					float fragment_unnamed_758 = mad(fragment_unnamed_750.y, 2.0f, -1.0f);
					float4 fragment_unnamed_766 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					float fragment_unnamed_772 = mad(fragment_unnamed_766.w * fragment_unnamed_766.x, 2.0f, -1.0f);
					float fragment_unnamed_773 = mad(fragment_unnamed_766.y, 2.0f, -1.0f);
					float4 fragment_unnamed_782 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float4 fragment_unnamed_787 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					fragment_unnamed_802 = fragment_unnamed_737.x;
					fragment_unnamed_804 = fragment_unnamed_737.y;
					fragment_unnamed_806 = fragment_unnamed_737.z;
					fragment_unnamed_808 = fragment_unnamed_743.x;
					fragment_unnamed_810 = fragment_unnamed_743.y;
					fragment_unnamed_812 = fragment_unnamed_743.z;
					fragment_unnamed_814 = fragment_unnamed_737.w;
					fragment_unnamed_816 = fragment_unnamed_743.w;
					fragment_unnamed_818 = fragment_unnamed_756;
					fragment_unnamed_820 = fragment_unnamed_758;
					fragment_unnamed_822 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_756, fragment_unnamed_758), float2(fragment_unnamed_756, fragment_unnamed_758)), 1.0f)) + 1.0f);
					fragment_unnamed_824 = fragment_unnamed_772;
					fragment_unnamed_826 = fragment_unnamed_773;
					fragment_unnamed_828 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_772, fragment_unnamed_773), float2(fragment_unnamed_772, fragment_unnamed_773)), 1.0f)) + 1.0f);
					fragment_unnamed_830 = fragment_unnamed_782.x;
					fragment_unnamed_832 = fragment_unnamed_782.y;
					fragment_unnamed_834 = fragment_unnamed_782.z;
					fragment_unnamed_836 = fragment_unnamed_787.x;
					fragment_unnamed_838 = fragment_unnamed_787.y;
					fragment_unnamed_840 = fragment_unnamed_787.z;
				}
				else
				{
					float fragment_unnamed_803;
					float fragment_unnamed_805;
					float fragment_unnamed_807;
					float fragment_unnamed_809;
					float fragment_unnamed_811;
					float fragment_unnamed_813;
					float fragment_unnamed_815;
					float fragment_unnamed_817;
					float fragment_unnamed_819;
					float fragment_unnamed_821;
					float fragment_unnamed_823;
					float fragment_unnamed_825;
					float fragment_unnamed_827;
					float fragment_unnamed_829;
					float fragment_unnamed_831;
					float fragment_unnamed_833;
					float fragment_unnamed_835;
					float fragment_unnamed_837;
					float fragment_unnamed_839;
					float fragment_unnamed_841;
					if (((((fragment_unnamed_342 + 1.9900000095367431640625f) < fragment_unnamed_335) ? 4294967295u : 0u) & ((fragment_unnamed_335 < (fragment_unnamed_342 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1252 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1258 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float4 fragment_unnamed_1265 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float fragment_unnamed_1271 = mad(fragment_unnamed_1265.w * fragment_unnamed_1265.x, 2.0f, -1.0f);
						float fragment_unnamed_1272 = mad(fragment_unnamed_1265.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1280 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float fragment_unnamed_1286 = mad(fragment_unnamed_1280.w * fragment_unnamed_1280.x, 2.0f, -1.0f);
						float fragment_unnamed_1287 = mad(fragment_unnamed_1280.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1296 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1301 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						fragment_unnamed_803 = fragment_unnamed_1252.x;
						fragment_unnamed_805 = fragment_unnamed_1252.y;
						fragment_unnamed_807 = fragment_unnamed_1252.z;
						fragment_unnamed_809 = fragment_unnamed_1258.x;
						fragment_unnamed_811 = fragment_unnamed_1258.y;
						fragment_unnamed_813 = fragment_unnamed_1258.z;
						fragment_unnamed_815 = fragment_unnamed_1252.w;
						fragment_unnamed_817 = fragment_unnamed_1258.w;
						fragment_unnamed_819 = fragment_unnamed_1271;
						fragment_unnamed_821 = fragment_unnamed_1272;
						fragment_unnamed_823 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1271, fragment_unnamed_1272), float2(fragment_unnamed_1271, fragment_unnamed_1272)), 1.0f)) + 1.0f);
						fragment_unnamed_825 = fragment_unnamed_1286;
						fragment_unnamed_827 = fragment_unnamed_1287;
						fragment_unnamed_829 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1286, fragment_unnamed_1287), float2(fragment_unnamed_1286, fragment_unnamed_1287)), 1.0f)) + 1.0f);
						fragment_unnamed_831 = fragment_unnamed_1296.x;
						fragment_unnamed_833 = fragment_unnamed_1296.y;
						fragment_unnamed_835 = fragment_unnamed_1296.z;
						fragment_unnamed_837 = fragment_unnamed_1301.x;
						fragment_unnamed_839 = fragment_unnamed_1301.y;
						fragment_unnamed_841 = fragment_unnamed_1301.z;
					}
					else
					{
						float4 fragment_unnamed_1307 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1313 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float4 fragment_unnamed_1320 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float fragment_unnamed_1326 = mad(fragment_unnamed_1320.w * fragment_unnamed_1320.x, 2.0f, -1.0f);
						float fragment_unnamed_1327 = mad(fragment_unnamed_1320.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1335 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float fragment_unnamed_1341 = mad(fragment_unnamed_1335.w * fragment_unnamed_1335.x, 2.0f, -1.0f);
						float fragment_unnamed_1342 = mad(fragment_unnamed_1335.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1351 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1356 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						fragment_unnamed_803 = fragment_unnamed_1307.x;
						fragment_unnamed_805 = fragment_unnamed_1307.y;
						fragment_unnamed_807 = fragment_unnamed_1307.z;
						fragment_unnamed_809 = fragment_unnamed_1313.x;
						fragment_unnamed_811 = fragment_unnamed_1313.y;
						fragment_unnamed_813 = fragment_unnamed_1313.z;
						fragment_unnamed_815 = fragment_unnamed_1307.w;
						fragment_unnamed_817 = fragment_unnamed_1313.w;
						fragment_unnamed_819 = fragment_unnamed_1326;
						fragment_unnamed_821 = fragment_unnamed_1327;
						fragment_unnamed_823 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1326, fragment_unnamed_1327), float2(fragment_unnamed_1326, fragment_unnamed_1327)), 1.0f)) + 1.0f);
						fragment_unnamed_825 = fragment_unnamed_1341;
						fragment_unnamed_827 = fragment_unnamed_1342;
						fragment_unnamed_829 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1341, fragment_unnamed_1342), float2(fragment_unnamed_1341, fragment_unnamed_1342)), 1.0f)) + 1.0f);
						fragment_unnamed_831 = fragment_unnamed_1351.x;
						fragment_unnamed_833 = fragment_unnamed_1351.y;
						fragment_unnamed_835 = fragment_unnamed_1351.z;
						fragment_unnamed_837 = fragment_unnamed_1356.x;
						fragment_unnamed_839 = fragment_unnamed_1356.y;
						fragment_unnamed_841 = fragment_unnamed_1356.z;
					}
					fragment_unnamed_802 = fragment_unnamed_803;
					fragment_unnamed_804 = fragment_unnamed_805;
					fragment_unnamed_806 = fragment_unnamed_807;
					fragment_unnamed_808 = fragment_unnamed_809;
					fragment_unnamed_810 = fragment_unnamed_811;
					fragment_unnamed_812 = fragment_unnamed_813;
					fragment_unnamed_814 = fragment_unnamed_815;
					fragment_unnamed_816 = fragment_unnamed_817;
					fragment_unnamed_818 = fragment_unnamed_819;
					fragment_unnamed_820 = fragment_unnamed_821;
					fragment_unnamed_822 = fragment_unnamed_823;
					fragment_unnamed_824 = fragment_unnamed_825;
					fragment_unnamed_826 = fragment_unnamed_827;
					fragment_unnamed_828 = fragment_unnamed_829;
					fragment_unnamed_830 = fragment_unnamed_831;
					fragment_unnamed_832 = fragment_unnamed_833;
					fragment_unnamed_834 = fragment_unnamed_835;
					fragment_unnamed_836 = fragment_unnamed_837;
					fragment_unnamed_838 = fragment_unnamed_839;
					fragment_unnamed_840 = fragment_unnamed_841;
				}
				float fragment_unnamed_856 = fragment_unnamed_848.w * 0.800000011920928955078125f;
				float fragment_unnamed_858 = mad(fragment_unnamed_848.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_866 = exp2(log2(abs(fragment_unnamed_490) + abs(fragment_unnamed_490)) * 10.0f);
				float fragment_unnamed_885 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_820) + fragment_unnamed_826, fragment_unnamed_820);
				float fragment_unnamed_886 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_818) + fragment_unnamed_824, fragment_unnamed_818);
				float fragment_unnamed_887 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_822) + fragment_unnamed_828, fragment_unnamed_822);
				float fragment_unnamed_897 = (fragment_unnamed_858 * fragment_unnamed_848.x) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_802) + fragment_unnamed_808, fragment_unnamed_802);
				float fragment_unnamed_898 = (fragment_unnamed_858 * fragment_unnamed_848.y) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_804) + fragment_unnamed_810, fragment_unnamed_804);
				float fragment_unnamed_899 = (fragment_unnamed_858 * fragment_unnamed_848.z) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_806) + fragment_unnamed_812, fragment_unnamed_806);
				float fragment_unnamed_906 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_unnamed_897), fragment_unnamed_897);
				float fragment_unnamed_907 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_unnamed_898), fragment_unnamed_898);
				float fragment_unnamed_908 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_unnamed_899), fragment_unnamed_899);
				float fragment_unnamed_910 = ((-0.0f) - mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_814) + fragment_unnamed_816, fragment_unnamed_814)) + 1.0f;
				float fragment_unnamed_915 = fragment_unnamed_910 * fragment_uniform_buffer_0[4u].w;
				float fragment_unnamed_924 = mad(fragment_unnamed_848.w, mad((-0.0f) - fragment_unnamed_910, fragment_uniform_buffer_0[4u].w, clamp(fragment_unnamed_915 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_915);
				bool fragment_unnamed_958 = (fragment_unnamed_415 & (fragment_unnamed_418 & (((fragment_unnamed_670 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_966 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_906) : asuint(fragment_unnamed_906);
				uint fragment_unnamed_968 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_907) : asuint(fragment_unnamed_907);
				uint fragment_unnamed_970 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_908) : asuint(fragment_unnamed_908);
				uint fragment_unnamed_972 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_983 = (fragment_unnamed_422 & (fragment_unnamed_412 & (((fragment_unnamed_665 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_988 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_966)) : fragment_unnamed_966;
				uint fragment_unnamed_990 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_968)) : fragment_unnamed_968;
				uint fragment_unnamed_992 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_970)) : fragment_unnamed_970;
				uint fragment_unnamed_994 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_972)) : fragment_unnamed_972;
				bool fragment_unnamed_1003 = (((fragment_unnamed_667 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_1008 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_988)) : fragment_unnamed_988;
				uint fragment_unnamed_1010 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_990)) : fragment_unnamed_990;
				uint fragment_unnamed_1012 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_992)) : fragment_unnamed_992;
				uint fragment_unnamed_1014 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_994)) : fragment_unnamed_994;
				bool fragment_unnamed_1023 = (((fragment_unnamed_669 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_1029 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1014)) : fragment_unnamed_1014);
				discard_cond((fragment_unnamed_1029 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1049 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_9.x / fragment_input_9.w, fragment_input_9.y / fragment_input_9.w));
				float fragment_unnamed_1051 = fragment_unnamed_1049.x;
				float fragment_unnamed_1052 = fragment_unnamed_1049.y;
				float fragment_unnamed_1053 = fragment_unnamed_1049.z;
				float fragment_unnamed_1058 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1008)) : fragment_unnamed_1008) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1059 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1010)) : fragment_unnamed_1010) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1060 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1012)) : fragment_unnamed_1012) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1072 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1073 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1074 = fragment_uniform_buffer_0[13u].x + fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1075 = fragment_uniform_buffer_0[13u].y + fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1081 = fragment_unnamed_1074 * fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1082 = fragment_unnamed_1075 * fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1083 = fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1091 = fragment_unnamed_1074 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1092 = fragment_unnamed_1075 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1096 = fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1127 = mad(fragment_unnamed_1092 + (fragment_unnamed_1072 * fragment_uniform_buffer_0[13u].x), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1075, (-0.0f) - fragment_unnamed_1096), fragment_input_4.y, (((-0.0f) - (fragment_unnamed_1083 + fragment_unnamed_1082)) + 1.0f) * fragment_input_4.x));
				float fragment_unnamed_1145 = mad(mad(fragment_uniform_buffer_0[13u].y, fragment_unnamed_1073, (-0.0f) - fragment_unnamed_1091), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1075, fragment_unnamed_1096), fragment_input_4.x, (((-0.0f) - (fragment_unnamed_1083 + fragment_unnamed_1081)) + 1.0f) * fragment_input_4.y));
				float fragment_unnamed_1151 = mad(((-0.0f) - (fragment_unnamed_1082 + fragment_unnamed_1081)) + 1.0f, fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1072, (-0.0f) - fragment_unnamed_1092), fragment_input_4.x, (fragment_unnamed_1091 + (fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].y)) * fragment_input_4.y));
				float fragment_unnamed_1155 = rsqrt(dot(float3(fragment_unnamed_1127, fragment_unnamed_1145, fragment_unnamed_1151), float3(fragment_unnamed_1127, fragment_unnamed_1145, fragment_unnamed_1151)));
				float fragment_unnamed_1156 = fragment_unnamed_1155 * fragment_unnamed_1127;
				float fragment_unnamed_1157 = fragment_unnamed_1155 * fragment_unnamed_1145;
				float fragment_unnamed_1158 = fragment_unnamed_1155 * fragment_unnamed_1151;
				float fragment_unnamed_1165 = mad(mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1058), 0.5f, fragment_unnamed_1058);
				float fragment_unnamed_1166 = mad(mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1059), 0.5f, fragment_unnamed_1059);
				float fragment_unnamed_1167 = mad(mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1060), 0.5f, fragment_unnamed_1060);
				float fragment_unnamed_1168 = dot(float3(fragment_unnamed_1165, fragment_unnamed_1166, fragment_unnamed_1167), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1174 = mad(((-0.0f) - fragment_unnamed_1168) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1168);
				float fragment_unnamed_1180 = (-0.0f) - fragment_unnamed_1174;
				float fragment_unnamed_1201 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 0.7200000286102294921875f, fragment_unnamed_1165), 0.14000000059604644775390625f, fragment_unnamed_1174 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1058), fragment_unnamed_1058);
				float fragment_unnamed_1202 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 0.85000002384185791015625f, fragment_unnamed_1166), 0.14000000059604644775390625f, fragment_unnamed_1174 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1059), fragment_unnamed_1059);
				float fragment_unnamed_1203 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 1.0f, fragment_unnamed_1167), 0.14000000059604644775390625f, fragment_unnamed_1174 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1060), fragment_unnamed_1060);
				float fragment_unnamed_1208 = mad((-0.0f) - fragment_uniform_buffer_0[15u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1237 = ((-0.0f) - fragment_input_1.w) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1238 = ((-0.0f) - fragment_input_2.w) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1239 = ((-0.0f) - fragment_input_3.w) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1243 = rsqrt(dot(float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239), float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239)));
				float fragment_unnamed_1244 = fragment_unnamed_1243 * fragment_unnamed_1237;
				float fragment_unnamed_1245 = fragment_unnamed_1243 * fragment_unnamed_1238;
				float fragment_unnamed_1246 = fragment_unnamed_1243 * fragment_unnamed_1239;
				float fragment_unnamed_1454;
				float fragment_unnamed_1455;
				float fragment_unnamed_1456;
				float fragment_unnamed_1457;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1364 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1444 = _Global_PGI.Sample(sampler_Global_PGI, float3(max(mad((asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].x, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].x, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : asuint(fragment_input_1.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), (asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].y, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].y, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : asuint(fragment_input_2.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, (asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].z, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].z, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : asuint(fragment_input_3.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1454 = fragment_unnamed_1444.x;
					fragment_unnamed_1455 = fragment_unnamed_1444.y;
					fragment_unnamed_1456 = fragment_unnamed_1444.z;
					fragment_unnamed_1457 = fragment_unnamed_1444.w;
				}
				else
				{
					fragment_unnamed_1454 = asfloat(1065353216u);
					fragment_unnamed_1455 = asfloat(1065353216u);
					fragment_unnamed_1456 = asfloat(1065353216u);
					fragment_unnamed_1457 = asfloat(1065353216u);
				}
				float fragment_unnamed_1468 = clamp(dot(float4(fragment_unnamed_1454, fragment_unnamed_1455, fragment_unnamed_1456, fragment_unnamed_1457), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float fragment_unnamed_1475 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1484 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1493 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1499 = rsqrt(dot(float3(fragment_unnamed_1475, fragment_unnamed_1484, fragment_unnamed_1493), float3(fragment_unnamed_1475, fragment_unnamed_1484, fragment_unnamed_1493)));
				float fragment_unnamed_1500 = fragment_unnamed_1499 * fragment_unnamed_1475;
				float fragment_unnamed_1501 = fragment_unnamed_1499 * fragment_unnamed_1484;
				float fragment_unnamed_1502 = fragment_unnamed_1499 * fragment_unnamed_1493;
				float fragment_unnamed_1522 = ((-0.0f) - fragment_uniform_buffer_0[5u].x) + 1.0f;
				float fragment_unnamed_1523 = ((-0.0f) - fragment_uniform_buffer_0[5u].y) + 1.0f;
				float fragment_unnamed_1524 = ((-0.0f) - fragment_uniform_buffer_0[5u].z) + 1.0f;
				float fragment_unnamed_1537 = dot(float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1540 = mad(fragment_unnamed_1537, 0.25f, 1.0f);
				float fragment_unnamed_1542 = fragment_unnamed_1540 * (fragment_unnamed_1540 * fragment_unnamed_1540);
				float fragment_unnamed_1547 = exp2(log2(max(fragment_unnamed_1537, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1548 = fragment_unnamed_1547 + fragment_unnamed_1547;
				float fragment_unnamed_1559 = asfloat((0.5f < fragment_unnamed_1547) ? asuint(mad(log2(mad(log2(fragment_unnamed_1548), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1548)) * 0.5f;
				float fragment_unnamed_1565 = dot(float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1707;
				float fragment_unnamed_1708;
				float fragment_unnamed_1709;
				if (1.0f >= fragment_unnamed_1565)
				{
					float fragment_unnamed_1586 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].x) + 1.0f), fragment_unnamed_1522, 1.0f);
					float fragment_unnamed_1587 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].y) + 1.0f), fragment_unnamed_1523, 1.0f);
					float fragment_unnamed_1588 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].z) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1604 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].x) + 1.0f), fragment_unnamed_1522, 1.0f);
					float fragment_unnamed_1605 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].y) + 1.0f), fragment_unnamed_1523, 1.0f);
					float fragment_unnamed_1606 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].z) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1635 = clamp((fragment_unnamed_1565 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1636 = clamp((fragment_unnamed_1565 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1637 = clamp((fragment_unnamed_1565 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1638 = clamp((fragment_unnamed_1565 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1661 = 0.20000000298023223876953125f < fragment_unnamed_1565;
					bool fragment_unnamed_1662 = 0.100000001490116119384765625f < fragment_unnamed_1565;
					bool fragment_unnamed_1663 = (-0.100000001490116119384765625f) < fragment_unnamed_1565;
					float fragment_unnamed_1664 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].x) + 1.0f), fragment_unnamed_1522, 1.0f) * 1.5f;
					float fragment_unnamed_1666 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].y) + 1.0f), fragment_unnamed_1523, 1.0f) * 1.5f;
					float fragment_unnamed_1667 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].z) + 1.0f), fragment_unnamed_1524, 1.0f) * 1.5f;
					fragment_unnamed_1707 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1586) + 1.0f, fragment_unnamed_1586)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1604, 1.25f, fragment_unnamed_1586), fragment_unnamed_1604 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1604, 1.25f, (-0.0f) - fragment_unnamed_1664), fragment_unnamed_1664)) : asuint(fragment_unnamed_1664 * fragment_unnamed_1638))));
					fragment_unnamed_1708 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1587) + 1.0f, fragment_unnamed_1587)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1605, 1.25f, fragment_unnamed_1587), fragment_unnamed_1605 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1605, 1.25f, (-0.0f) - fragment_unnamed_1666), fragment_unnamed_1666)) : asuint(fragment_unnamed_1666 * fragment_unnamed_1638))));
					fragment_unnamed_1709 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1588) + 1.0f, fragment_unnamed_1588)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1606, 1.25f, fragment_unnamed_1588), fragment_unnamed_1606 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1606, 1.25f, (-0.0f) - fragment_unnamed_1667), fragment_unnamed_1667)) : asuint(fragment_unnamed_1667 * fragment_unnamed_1638))));
				}
				else
				{
					fragment_unnamed_1707 = asfloat(1065353216u);
					fragment_unnamed_1708 = asfloat(1065353216u);
					fragment_unnamed_1709 = asfloat(1065353216u);
				}
				float fragment_unnamed_1717 = clamp(fragment_unnamed_1565 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1721 = mad(clamp(fragment_unnamed_1565 * 0.1500000059604644775390625f, 0.0f, 1.0f), ((-0.0f) - fragment_unnamed_1468) + 1.0f, fragment_unnamed_1468) * 0.800000011920928955078125f;
				float fragment_unnamed_1733 = min(max((((-0.0f) - fragment_uniform_buffer_0[11u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1742 = mad(clamp(mad(log2(fragment_uniform_buffer_0[11u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1758 = mad(exp2(log2(fragment_uniform_buffer_0[6u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1761 = mad(exp2(log2(fragment_uniform_buffer_0[6u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1762 = mad(exp2(log2(fragment_uniform_buffer_0[6u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1793 = mad(exp2(log2(fragment_uniform_buffer_0[7u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1794 = mad(exp2(log2(fragment_uniform_buffer_0[7u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1795 = mad(exp2(log2(fragment_uniform_buffer_0[7u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1805 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1793) + 0.0240000002086162567138671875f, fragment_unnamed_1793);
				float fragment_unnamed_1806 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1794) + 0.0240000002086162567138671875f, fragment_unnamed_1794);
				float fragment_unnamed_1807 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1795) + 0.0240000002086162567138671875f, fragment_unnamed_1795);
				float fragment_unnamed_1822 = mad(exp2(log2(fragment_uniform_buffer_0[8u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1823 = mad(exp2(log2(fragment_uniform_buffer_0[8u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1824 = mad(exp2(log2(fragment_uniform_buffer_0[8u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1837 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1822, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1822);
				float fragment_unnamed_1838 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1823, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1823);
				float fragment_unnamed_1839 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1824, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1824);
				float fragment_unnamed_1840 = dot(float3(fragment_unnamed_1805, fragment_unnamed_1806, fragment_unnamed_1807), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1849 = mad(((-0.0f) - fragment_unnamed_1805) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1805);
				float fragment_unnamed_1850 = mad(((-0.0f) - fragment_unnamed_1806) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1806);
				float fragment_unnamed_1851 = mad(((-0.0f) - fragment_unnamed_1807) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1807);
				float fragment_unnamed_1852 = dot(float3(fragment_unnamed_1837, fragment_unnamed_1838, fragment_unnamed_1839), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1861 = mad(((-0.0f) - fragment_unnamed_1837) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1837);
				float fragment_unnamed_1862 = mad(((-0.0f) - fragment_unnamed_1838) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1838);
				float fragment_unnamed_1863 = mad(((-0.0f) - fragment_unnamed_1839) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1839);
				bool fragment_unnamed_1864 = 0.0f < fragment_unnamed_1565;
				float fragment_unnamed_1877 = clamp(mad(fragment_unnamed_1565, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1878 = clamp(mad(fragment_unnamed_1565, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1902 = clamp(mad(dot(float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1906 = asfloat(asuint(fragment_uniform_buffer_0[10u]).x) + 1.0f;
				float fragment_unnamed_1913 = dot(float3((-0.0f) - fragment_unnamed_1244, (-0.0f) - fragment_unnamed_1245, (-0.0f) - fragment_unnamed_1246), float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502));
				float fragment_unnamed_1917 = (-0.0f) - (fragment_unnamed_1913 + fragment_unnamed_1913);
				float fragment_unnamed_1921 = mad(fragment_unnamed_1500, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1244);
				float fragment_unnamed_1922 = mad(fragment_unnamed_1501, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1245);
				float fragment_unnamed_1923 = mad(fragment_unnamed_1502, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1246);
				uint fragment_unnamed_1939 = (fragment_uniform_buffer_0[25u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1954 = sqrt(dot(float3(fragment_uniform_buffer_0[25u].xyz), float3(fragment_uniform_buffer_0[25u].xyz))) + (-5.0f);
				float fragment_unnamed_1970 = clamp(fragment_unnamed_1954, 0.0f, 1.0f) * clamp(dot(float3((-0.0f) - fragment_unnamed_1156, (-0.0f) - fragment_unnamed_1157, (-0.0f) - fragment_unnamed_1158), float3(fragment_uniform_buffer_0[12u].xyz)) * 5.0f, 0.0f, 1.0f);
				float fragment_unnamed_1979 = mad((-0.0f) - fragment_unnamed_1156, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].x);
				float fragment_unnamed_1980 = mad((-0.0f) - fragment_unnamed_1157, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].y);
				float fragment_unnamed_1981 = mad((-0.0f) - fragment_unnamed_1158, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].z);
				float fragment_unnamed_1985 = sqrt(dot(float3(fragment_unnamed_1979, fragment_unnamed_1980, fragment_unnamed_1981), float3(fragment_unnamed_1979, fragment_unnamed_1980, fragment_unnamed_1981)));
				float fragment_unnamed_1991 = max((((-0.0f) - fragment_unnamed_1985) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1993 = fragment_unnamed_1985 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_2009 = fragment_unnamed_1970 * ((fragment_unnamed_1991 * fragment_unnamed_1991) * clamp(dot(float3(fragment_unnamed_1979 / fragment_unnamed_1985, fragment_unnamed_1980 / fragment_unnamed_1985, fragment_unnamed_1981 / fragment_unnamed_1985), float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502)), 0.0f, 1.0f));
				float fragment_unnamed_2027 = clamp(fragment_unnamed_1208 * mad(fragment_unnamed_848.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_924) + 1.0f, fragment_unnamed_924), 0.0f, 1.0f);
				float fragment_unnamed_2033 = exp2(log2(fragment_unnamed_1878 * max(dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_uniform_buffer_0[12u].xyz)), 0.0f)) * exp2(fragment_unnamed_2027 * 6.906890392303466796875f));
				uint fragment_unnamed_2050 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158))) ? 4294967295u : 0u;
				float fragment_unnamed_2058 = mad(fragment_unnamed_1156, 1.0f, (-0.0f) - (fragment_unnamed_1157 * 0.0f));
				float fragment_unnamed_2059 = mad(fragment_unnamed_1157, 0.0f, (-0.0f) - (fragment_unnamed_1158 * 1.0f));
				float fragment_unnamed_2064 = rsqrt(dot(float2(fragment_unnamed_2058, fragment_unnamed_2059), float2(fragment_unnamed_2058, fragment_unnamed_2059)));
				bool fragment_unnamed_2068 = (fragment_unnamed_2050 & ((fragment_unnamed_1157 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2073 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * fragment_unnamed_2058) : 0u);
				float fragment_unnamed_2075 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * fragment_unnamed_2059) : 1065353216u);
				float fragment_unnamed_2077 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * mad(fragment_unnamed_1158, 0.0f, (-0.0f) - (fragment_unnamed_1156 * 0.0f))) : 0u);
				float fragment_unnamed_2090 = mad(fragment_unnamed_2077, fragment_unnamed_1158, (-0.0f) - (fragment_unnamed_1157 * fragment_unnamed_2073));
				float fragment_unnamed_2091 = mad(fragment_unnamed_2073, fragment_unnamed_1156, (-0.0f) - (fragment_unnamed_1158 * fragment_unnamed_2075));
				float fragment_unnamed_2092 = mad(fragment_unnamed_2075, fragment_unnamed_1157, (-0.0f) - (fragment_unnamed_1156 * fragment_unnamed_2077));
				float fragment_unnamed_2096 = rsqrt(dot(float3(fragment_unnamed_2090, fragment_unnamed_2091, fragment_unnamed_2092), float3(fragment_unnamed_2090, fragment_unnamed_2091, fragment_unnamed_2092)));
				bool fragment_unnamed_2108 = (fragment_unnamed_2050 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2073, fragment_unnamed_2075), float2(fragment_unnamed_2073, fragment_unnamed_2075))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2126 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1923, fragment_unnamed_1921), float2((-0.0f) - fragment_unnamed_2073, (-0.0f) - fragment_unnamed_2075)), dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158)), dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2090)) : (-0.0f), fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2091)) : (-0.0f), fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2092)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2027) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2145 = mad(fragment_unnamed_1878, ((-0.0f) - fragment_uniform_buffer_0[9u].y) + fragment_uniform_buffer_0[9u].x, fragment_uniform_buffer_0[9u].y);
				float fragment_unnamed_2149 = dot(float3(fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.x), fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.y), fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2170 = fragment_unnamed_2149 + mad(fragment_unnamed_1201, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 1.2999999523162841796875f) : asuint(fragment_unnamed_2009 * 1.2999999523162841796875f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1522, 1.0f) * fragment_unnamed_1707), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1758, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1758) + ((-0.0f) - fragment_unnamed_1849), fragment_unnamed_1849)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1861) + fragment_unnamed_1849, fragment_unnamed_1861)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].x), fragment_uniform_buffer_0[4u].x)) * fragment_unnamed_2033)) * 0.5f);
				float fragment_unnamed_2171 = fragment_unnamed_2149 + mad(fragment_unnamed_1202, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 1.10000002384185791015625f) : asuint(fragment_unnamed_2009 * 1.10000002384185791015625f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1523, 1.0f) * fragment_unnamed_1708), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1761, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1761) + ((-0.0f) - fragment_unnamed_1850), fragment_unnamed_1850)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1862) + fragment_unnamed_1850, fragment_unnamed_1862)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].y), fragment_uniform_buffer_0[4u].y)) * fragment_unnamed_2033)) * 0.5f);
				float fragment_unnamed_2172 = fragment_unnamed_2149 + mad(fragment_unnamed_1203, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 0.60000002384185791015625f) : asuint(fragment_unnamed_2009 * 0.60000002384185791015625f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1524, 1.0f) * fragment_unnamed_1709), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1762, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1762) + ((-0.0f) - fragment_unnamed_1851), fragment_unnamed_1851)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1863) + fragment_unnamed_1851, fragment_unnamed_1863)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].z), fragment_uniform_buffer_0[4u].z)) * fragment_unnamed_2033)) * 0.5f);
				fragment_output_0.x = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_830) + fragment_unnamed_836, fragment_unnamed_830)) + mad(fragment_unnamed_1201, fragment_input_11.x, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1051) + fragment_unnamed_2170, fragment_unnamed_1051));
				fragment_output_0.y = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_832) + fragment_unnamed_838, fragment_unnamed_832)) + mad(fragment_unnamed_1202, fragment_input_11.y, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1052) + fragment_unnamed_2171, fragment_unnamed_1052));
				fragment_output_0.z = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_834) + fragment_unnamed_840, fragment_unnamed_834)) + mad(fragment_unnamed_1203, fragment_input_11.z, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1053) + fragment_unnamed_2172, fragment_unnamed_1053));
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[2] = float4(_LightColor0[0], _LightColor0[1], _LightColor0[2], _LightColor0[3]);

				fragment_uniform_buffer_0[4] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[5] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[6] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[7] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[8] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[9] = float4(_GIStrengthDay, fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], _GIStrengthNight, fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], _Multiplier);

				fragment_uniform_buffer_0[10] = float4(_AmbientInc, fragment_uniform_buffer_0[10][1], fragment_uniform_buffer_0[10][2], fragment_uniform_buffer_0[10][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], fragment_uniform_buffer_0[11][1], _Distance, fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[12] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[12][3]);

				fragment_uniform_buffer_0[13] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[15][1], fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[17] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[18] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[25] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // !LIGHTPROBE_SH
			#endif // !SHADOWS_SCREEN


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifndef SHADOWS_SCREEN
			#define ANY_SHADER_VARIANT_ACTIVE

			float4 _LightColor0;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[26];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _EmissionTex1;
			SamplerState sampler_EmissionTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _EmissionTex2;
			SamplerState sampler_EmissionTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _EmissionTex3;
			SamplerState sampler_EmissionTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float4 fragment_input_1;
			static float4 fragment_input_2;
			static float4 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float4 fragment_input_9;
			static float3 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float4 fragment_input_1 : TEXCOORD; // TEXCOORD
				float4 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float4 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float4 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float3 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD12; // TEXCOORD_12
				float4 fragment_input_13 : TEXCOORD13; // TEXCOORD_13
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2213)
			{
				if (fragment_unnamed_2213)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_133 = rsqrt(dot(float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z), float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z)));
				float fragment_unnamed_140 = fragment_unnamed_133 * fragment_input_4.y;
				float fragment_unnamed_141 = fragment_unnamed_133 * fragment_input_4.x;
				float fragment_unnamed_142 = fragment_unnamed_133 * fragment_input_4.z;
				uint fragment_unnamed_151 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_157 = sqrt(((-0.0f) - abs(fragment_unnamed_140)) + 1.0f);
				float fragment_unnamed_166 = mad(mad(mad(abs(fragment_unnamed_140), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_140), -0.212114393711090087890625f), abs(fragment_unnamed_140), 1.570728778839111328125f);
				float fragment_unnamed_191 = (1.0f / max(abs(fragment_unnamed_142), abs(fragment_unnamed_141))) * min(abs(fragment_unnamed_142), abs(fragment_unnamed_141));
				float fragment_unnamed_192 = fragment_unnamed_191 * fragment_unnamed_191;
				float fragment_unnamed_200 = mad(fragment_unnamed_192, mad(fragment_unnamed_192, mad(fragment_unnamed_192, mad(fragment_unnamed_192, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_218 = asfloat(((((-0.0f) - fragment_unnamed_142) < fragment_unnamed_142) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_191, fragment_unnamed_200, asfloat(((abs(fragment_unnamed_142) < abs(fragment_unnamed_141)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_200 * fragment_unnamed_191, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_220 = min((-0.0f) - fragment_unnamed_142, fragment_unnamed_141);
				float fragment_unnamed_222 = max((-0.0f) - fragment_unnamed_142, fragment_unnamed_141);
				float fragment_unnamed_236 = (((-0.0f) - mad(fragment_unnamed_166, fragment_unnamed_157, asfloat(((fragment_unnamed_140 < ((-0.0f) - fragment_unnamed_140)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_157 * fragment_unnamed_166, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_237 = fragment_unnamed_236 * 0.3183098733425140380859375f;
				bool fragment_unnamed_239 = 0.0f < fragment_unnamed_236;
				float fragment_unnamed_246 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_237)) : asuint(floor(fragment_unnamed_237)));
				float fragment_unnamed_250 = float(fragment_unnamed_151);
				uint fragment_unnamed_258 = uint(asfloat((0.0f < fragment_unnamed_246) ? asuint(fragment_unnamed_246 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_246) + fragment_unnamed_250) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_260 = _OffsetsBuffer.Load(fragment_unnamed_258);
				uint fragment_unnamed_261 = fragment_unnamed_260.x;
				float fragment_unnamed_268 = float((-fragment_unnamed_261) + _OffsetsBuffer.Load(fragment_unnamed_258 + 1u).x);
				float fragment_unnamed_269 = mad(((((fragment_unnamed_222 >= ((-0.0f) - fragment_unnamed_222)) ? 4294967295u : 0u) & ((fragment_unnamed_220 < ((-0.0f) - fragment_unnamed_220)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_218) : fragment_unnamed_218, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_271 = fragment_unnamed_268 * fragment_unnamed_269;
				bool fragment_unnamed_272 = 0.0f < fragment_unnamed_271;
				float fragment_unnamed_278 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_271)) : asuint(floor(fragment_unnamed_271)));
				float fragment_unnamed_279 = mad(fragment_unnamed_268, 0.5f, 0.5f);
				float fragment_unnamed_295 = float(fragment_unnamed_261 + uint(asfloat((fragment_unnamed_279 < fragment_unnamed_278) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_278) + (-1.0f)) : asuint(fragment_unnamed_268 + ((-0.0f) - fragment_unnamed_278))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_298 = frac(fragment_unnamed_295);
				uint4 fragment_unnamed_300 = _DataBuffer.Load(uint(floor(fragment_unnamed_295)));
				uint fragment_unnamed_301 = fragment_unnamed_300.x;
				uint fragment_unnamed_313 = 16u & 31u;
				uint fragment_unnamed_320 = 8u & 31u;
				uint fragment_unnamed_328 = (0.625f < fragment_unnamed_298) ? (fragment_unnamed_301 >> 24u) : ((0.375f < fragment_unnamed_298) ? spvBitfieldUExtract(fragment_unnamed_301, fragment_unnamed_313, min((8u & 31u), (32u - fragment_unnamed_313))) : ((0.125f < fragment_unnamed_298) ? spvBitfieldUExtract(fragment_unnamed_301, fragment_unnamed_320, min((8u & 31u), (32u - fragment_unnamed_320))) : (fragment_unnamed_301 & 255u)));
				float fragment_unnamed_330 = float(fragment_unnamed_328 >> 5u);
				float fragment_unnamed_335 = asfloat((6.5f < fragment_unnamed_330) ? 0u : asuint(fragment_unnamed_330));
				float fragment_unnamed_342 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(fragment_unnamed_335 < (fragment_unnamed_342 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_342 + 3.9900000095367431640625f) < fragment_unnamed_335);
				float fragment_unnamed_361 = mad(fragment_unnamed_236, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_362 = mad(fragment_unnamed_236, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_373 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_361)) : asuint(floor(fragment_unnamed_361)));
				float fragment_unnamed_375 = asfloat(fragment_unnamed_239 ? asuint(ceil(fragment_unnamed_362)) : asuint(floor(fragment_unnamed_362)));
				uint fragment_unnamed_377 = uint(ceil(max(abs(fragment_unnamed_237) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_396 = uint(asfloat((0.0f < fragment_unnamed_373) ? asuint(fragment_unnamed_373 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_250 + ((-0.0f) - fragment_unnamed_373)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_397 = uint(asfloat((0.0f < fragment_unnamed_375) ? asuint(fragment_unnamed_375 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_250 + ((-0.0f) - fragment_unnamed_375)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_398 = _OffsetsBuffer.Load(fragment_unnamed_396);
				uint fragment_unnamed_399 = fragment_unnamed_398.x;
				uint4 fragment_unnamed_400 = _OffsetsBuffer.Load(fragment_unnamed_397);
				uint fragment_unnamed_401 = fragment_unnamed_400.x;
				uint fragment_unnamed_412 = (fragment_unnamed_258 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_415 = (fragment_unnamed_258 != (fragment_unnamed_151 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_418 = (fragment_unnamed_151 != fragment_unnamed_258) ? 4294967295u : 0u;
				uint fragment_unnamed_422 = (fragment_unnamed_258 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_438 = (fragment_unnamed_422 & (fragment_unnamed_418 & (fragment_unnamed_412 & fragment_unnamed_415))) != 0u;
				uint fragment_unnamed_441 = asuint(fragment_unnamed_268);
				uint fragment_unnamed_442 = fragment_unnamed_438 ? asuint(float((-fragment_unnamed_399) + _OffsetsBuffer.Load(fragment_unnamed_396 + 1u).x)) : fragment_unnamed_441;
				float fragment_unnamed_444 = asfloat(fragment_unnamed_438 ? asuint(float((-fragment_unnamed_401) + _OffsetsBuffer.Load(fragment_unnamed_397 + 1u).x)) : fragment_unnamed_441);
				float fragment_unnamed_447 = fragment_unnamed_269 * asfloat(fragment_unnamed_442);
				float fragment_unnamed_448 = fragment_unnamed_269 * fragment_unnamed_444;
				float fragment_unnamed_449 = mad(fragment_unnamed_269, fragment_unnamed_268, 0.5f);
				float fragment_unnamed_450 = mad(fragment_unnamed_269, fragment_unnamed_268, -0.5f);
				float fragment_unnamed_457 = asfloat((fragment_unnamed_268 < fragment_unnamed_449) ? asuint(((-0.0f) - fragment_unnamed_268) + fragment_unnamed_449) : asuint(fragment_unnamed_449));
				float fragment_unnamed_463 = asfloat((fragment_unnamed_450 < 0.0f) ? asuint(fragment_unnamed_268 + fragment_unnamed_450) : asuint(fragment_unnamed_450));
				float fragment_unnamed_473 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_447)) : asuint(floor(fragment_unnamed_447)));
				float fragment_unnamed_475 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_448)) : asuint(floor(fragment_unnamed_448)));
				float fragment_unnamed_481 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_457)) : asuint(floor(fragment_unnamed_457)));
				float fragment_unnamed_487 = asfloat(fragment_unnamed_272 ? asuint(ceil(fragment_unnamed_463)) : asuint(floor(fragment_unnamed_463)));
				float fragment_unnamed_488 = frac(fragment_unnamed_237);
				float fragment_unnamed_489 = frac(fragment_unnamed_271);
				float fragment_unnamed_490 = fragment_unnamed_488 + (-0.5f);
				float fragment_unnamed_499 = min((((-0.0f) - fragment_unnamed_489) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_501 = min(fragment_unnamed_489 * 40.0f, 1.0f);
				float fragment_unnamed_502 = min(fragment_unnamed_488 * 40.0f, 1.0f);
				float fragment_unnamed_561 = float(fragment_unnamed_399 + uint(asfloat((mad(asfloat(fragment_unnamed_442), 0.5f, 0.5f) < fragment_unnamed_473) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_442), 0.5f, fragment_unnamed_473) + (-1.0f)) : asuint(asfloat(fragment_unnamed_442) + ((-0.0f) - fragment_unnamed_473))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_563 = frac(fragment_unnamed_561);
				uint4 fragment_unnamed_565 = _DataBuffer.Load(uint(floor(fragment_unnamed_561)));
				uint fragment_unnamed_566 = fragment_unnamed_565.x;
				uint fragment_unnamed_572 = 16u & 31u;
				uint fragment_unnamed_577 = 8u & 31u;
				float fragment_unnamed_587 = float(uint(asfloat((mad(fragment_unnamed_444, 0.5f, 0.5f) < fragment_unnamed_475) ? asuint(mad((-0.0f) - fragment_unnamed_444, 0.5f, fragment_unnamed_475) + (-1.0f)) : asuint(fragment_unnamed_444 + ((-0.0f) - fragment_unnamed_475))) + 0.100000001490116119384765625f) + fragment_unnamed_401) * 0.25f;
				float fragment_unnamed_589 = frac(fragment_unnamed_587);
				uint4 fragment_unnamed_591 = _DataBuffer.Load(uint(floor(fragment_unnamed_587)));
				uint fragment_unnamed_592 = fragment_unnamed_591.x;
				uint fragment_unnamed_598 = 16u & 31u;
				uint fragment_unnamed_603 = 8u & 31u;
				float fragment_unnamed_613 = float(uint(asfloat((fragment_unnamed_279 < fragment_unnamed_481) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_481) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_481) + fragment_unnamed_268)) + 0.100000001490116119384765625f) + fragment_unnamed_261) * 0.25f;
				float fragment_unnamed_615 = frac(fragment_unnamed_613);
				uint4 fragment_unnamed_617 = _DataBuffer.Load(uint(floor(fragment_unnamed_613)));
				uint fragment_unnamed_618 = fragment_unnamed_617.x;
				uint fragment_unnamed_624 = 16u & 31u;
				uint fragment_unnamed_629 = 8u & 31u;
				float fragment_unnamed_639 = float(uint(asfloat((fragment_unnamed_279 < fragment_unnamed_487) ? asuint(mad((-0.0f) - fragment_unnamed_268, 0.5f, fragment_unnamed_487) + (-1.0f)) : asuint(fragment_unnamed_268 + ((-0.0f) - fragment_unnamed_487))) + 0.100000001490116119384765625f) + fragment_unnamed_261) * 0.25f;
				float fragment_unnamed_641 = frac(fragment_unnamed_639);
				uint4 fragment_unnamed_643 = _DataBuffer.Load(uint(floor(fragment_unnamed_639)));
				uint fragment_unnamed_644 = fragment_unnamed_643.x;
				uint fragment_unnamed_650 = 16u & 31u;
				uint fragment_unnamed_655 = 8u & 31u;
				float fragment_unnamed_665 = float(((0.625f < fragment_unnamed_589) ? (fragment_unnamed_592 >> 24u) : ((0.375f < fragment_unnamed_589) ? spvBitfieldUExtract(fragment_unnamed_592, fragment_unnamed_598, min((8u & 31u), (32u - fragment_unnamed_598))) : ((0.125f < fragment_unnamed_589) ? spvBitfieldUExtract(fragment_unnamed_592, fragment_unnamed_603, min((8u & 31u), (32u - fragment_unnamed_603))) : (fragment_unnamed_592 & 255u)))) >> 5u);
				float fragment_unnamed_667 = float(((0.625f < fragment_unnamed_615) ? (fragment_unnamed_618 >> 24u) : ((0.375f < fragment_unnamed_615) ? spvBitfieldUExtract(fragment_unnamed_618, fragment_unnamed_624, min((8u & 31u), (32u - fragment_unnamed_624))) : ((0.125f < fragment_unnamed_615) ? spvBitfieldUExtract(fragment_unnamed_618, fragment_unnamed_629, min((8u & 31u), (32u - fragment_unnamed_629))) : (fragment_unnamed_618 & 255u)))) >> 5u);
				float fragment_unnamed_669 = float(((0.625f < fragment_unnamed_641) ? (fragment_unnamed_644 >> 24u) : ((0.375f < fragment_unnamed_641) ? spvBitfieldUExtract(fragment_unnamed_644, fragment_unnamed_650, min((8u & 31u), (32u - fragment_unnamed_650))) : ((0.125f < fragment_unnamed_641) ? spvBitfieldUExtract(fragment_unnamed_644, fragment_unnamed_655, min((8u & 31u), (32u - fragment_unnamed_655))) : (fragment_unnamed_644 & 255u)))) >> 5u);
				float fragment_unnamed_670 = float(((0.625f < fragment_unnamed_563) ? (fragment_unnamed_566 >> 24u) : ((0.375f < fragment_unnamed_563) ? spvBitfieldUExtract(fragment_unnamed_566, fragment_unnamed_572, min((8u & 31u), (32u - fragment_unnamed_572))) : ((0.125f < fragment_unnamed_563) ? spvBitfieldUExtract(fragment_unnamed_566, fragment_unnamed_577, min((8u & 31u), (32u - fragment_unnamed_577))) : (fragment_unnamed_566 & 255u)))) >> 5u);
				float fragment_unnamed_681 = fragment_unnamed_271 * 0.20000000298023223876953125f;
				float fragment_unnamed_683 = fragment_unnamed_236 * 0.06366197764873504638671875f;
				float fragment_unnamed_685 = (fragment_unnamed_269 * float((-_OffsetsBuffer.Load(fragment_unnamed_377).x) + _OffsetsBuffer.Load(fragment_unnamed_377 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_692 = ddx_coarse(fragment_input_10.x);
				float fragment_unnamed_693 = ddx_coarse(fragment_input_10.y);
				float fragment_unnamed_694 = ddx_coarse(fragment_input_10.z);
				float fragment_unnamed_698 = sqrt(dot(float3(fragment_unnamed_692, fragment_unnamed_693, fragment_unnamed_694), float3(fragment_unnamed_692, fragment_unnamed_693, fragment_unnamed_694)));
				float fragment_unnamed_705 = ddy_coarse(fragment_input_10.x);
				float fragment_unnamed_706 = ddy_coarse(fragment_input_10.y);
				float fragment_unnamed_707 = ddy_coarse(fragment_input_10.z);
				float fragment_unnamed_711 = sqrt(dot(float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707), float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707)));
				float fragment_unnamed_722 = min(max(log2(sqrt(dot(float2(fragment_unnamed_698, fragment_unnamed_711), float2(fragment_unnamed_698, fragment_unnamed_711))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_724 = min((((-0.0f) - fragment_unnamed_488) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_802;
				float fragment_unnamed_804;
				float fragment_unnamed_806;
				float fragment_unnamed_808;
				float fragment_unnamed_810;
				float fragment_unnamed_812;
				float fragment_unnamed_814;
				float fragment_unnamed_816;
				float fragment_unnamed_818;
				float fragment_unnamed_820;
				float fragment_unnamed_822;
				float fragment_unnamed_824;
				float fragment_unnamed_826;
				float fragment_unnamed_828;
				float fragment_unnamed_830;
				float fragment_unnamed_832;
				float fragment_unnamed_834;
				float fragment_unnamed_836;
				float fragment_unnamed_838;
				float fragment_unnamed_840;
				if (((((fragment_unnamed_342 + 0.9900000095367431640625f) < fragment_unnamed_335) ? 4294967295u : 0u) & ((fragment_unnamed_335 < (fragment_unnamed_342 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_737 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float4 fragment_unnamed_743 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					float4 fragment_unnamed_750 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float fragment_unnamed_756 = mad(fragment_unnamed_750.w * fragment_unnamed_750.x, 2.0f, -1.0f);
					float fragment_unnamed_758 = mad(fragment_unnamed_750.y, 2.0f, -1.0f);
					float4 fragment_unnamed_766 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					float fragment_unnamed_772 = mad(fragment_unnamed_766.w * fragment_unnamed_766.x, 2.0f, -1.0f);
					float fragment_unnamed_773 = mad(fragment_unnamed_766.y, 2.0f, -1.0f);
					float4 fragment_unnamed_782 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
					float4 fragment_unnamed_787 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
					fragment_unnamed_802 = fragment_unnamed_737.x;
					fragment_unnamed_804 = fragment_unnamed_737.y;
					fragment_unnamed_806 = fragment_unnamed_737.z;
					fragment_unnamed_808 = fragment_unnamed_743.x;
					fragment_unnamed_810 = fragment_unnamed_743.y;
					fragment_unnamed_812 = fragment_unnamed_743.z;
					fragment_unnamed_814 = fragment_unnamed_737.w;
					fragment_unnamed_816 = fragment_unnamed_743.w;
					fragment_unnamed_818 = fragment_unnamed_756;
					fragment_unnamed_820 = fragment_unnamed_758;
					fragment_unnamed_822 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_756, fragment_unnamed_758), float2(fragment_unnamed_756, fragment_unnamed_758)), 1.0f)) + 1.0f);
					fragment_unnamed_824 = fragment_unnamed_772;
					fragment_unnamed_826 = fragment_unnamed_773;
					fragment_unnamed_828 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_772, fragment_unnamed_773), float2(fragment_unnamed_772, fragment_unnamed_773)), 1.0f)) + 1.0f);
					fragment_unnamed_830 = fragment_unnamed_782.x;
					fragment_unnamed_832 = fragment_unnamed_782.y;
					fragment_unnamed_834 = fragment_unnamed_782.z;
					fragment_unnamed_836 = fragment_unnamed_787.x;
					fragment_unnamed_838 = fragment_unnamed_787.y;
					fragment_unnamed_840 = fragment_unnamed_787.z;
				}
				else
				{
					float fragment_unnamed_803;
					float fragment_unnamed_805;
					float fragment_unnamed_807;
					float fragment_unnamed_809;
					float fragment_unnamed_811;
					float fragment_unnamed_813;
					float fragment_unnamed_815;
					float fragment_unnamed_817;
					float fragment_unnamed_819;
					float fragment_unnamed_821;
					float fragment_unnamed_823;
					float fragment_unnamed_825;
					float fragment_unnamed_827;
					float fragment_unnamed_829;
					float fragment_unnamed_831;
					float fragment_unnamed_833;
					float fragment_unnamed_835;
					float fragment_unnamed_837;
					float fragment_unnamed_839;
					float fragment_unnamed_841;
					if (((((fragment_unnamed_342 + 1.9900000095367431640625f) < fragment_unnamed_335) ? 4294967295u : 0u) & ((fragment_unnamed_335 < (fragment_unnamed_342 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1252 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1258 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float4 fragment_unnamed_1265 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float fragment_unnamed_1271 = mad(fragment_unnamed_1265.w * fragment_unnamed_1265.x, 2.0f, -1.0f);
						float fragment_unnamed_1272 = mad(fragment_unnamed_1265.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1280 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float fragment_unnamed_1286 = mad(fragment_unnamed_1280.w * fragment_unnamed_1280.x, 2.0f, -1.0f);
						float fragment_unnamed_1287 = mad(fragment_unnamed_1280.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1296 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1301 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						fragment_unnamed_803 = fragment_unnamed_1252.x;
						fragment_unnamed_805 = fragment_unnamed_1252.y;
						fragment_unnamed_807 = fragment_unnamed_1252.z;
						fragment_unnamed_809 = fragment_unnamed_1258.x;
						fragment_unnamed_811 = fragment_unnamed_1258.y;
						fragment_unnamed_813 = fragment_unnamed_1258.z;
						fragment_unnamed_815 = fragment_unnamed_1252.w;
						fragment_unnamed_817 = fragment_unnamed_1258.w;
						fragment_unnamed_819 = fragment_unnamed_1271;
						fragment_unnamed_821 = fragment_unnamed_1272;
						fragment_unnamed_823 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1271, fragment_unnamed_1272), float2(fragment_unnamed_1271, fragment_unnamed_1272)), 1.0f)) + 1.0f);
						fragment_unnamed_825 = fragment_unnamed_1286;
						fragment_unnamed_827 = fragment_unnamed_1287;
						fragment_unnamed_829 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1286, fragment_unnamed_1287), float2(fragment_unnamed_1286, fragment_unnamed_1287)), 1.0f)) + 1.0f);
						fragment_unnamed_831 = fragment_unnamed_1296.x;
						fragment_unnamed_833 = fragment_unnamed_1296.y;
						fragment_unnamed_835 = fragment_unnamed_1296.z;
						fragment_unnamed_837 = fragment_unnamed_1301.x;
						fragment_unnamed_839 = fragment_unnamed_1301.y;
						fragment_unnamed_841 = fragment_unnamed_1301.z;
					}
					else
					{
						float4 fragment_unnamed_1307 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1313 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float4 fragment_unnamed_1320 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float fragment_unnamed_1326 = mad(fragment_unnamed_1320.w * fragment_unnamed_1320.x, 2.0f, -1.0f);
						float fragment_unnamed_1327 = mad(fragment_unnamed_1320.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1335 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						float fragment_unnamed_1341 = mad(fragment_unnamed_1335.w * fragment_unnamed_1335.x, 2.0f, -1.0f);
						float fragment_unnamed_1342 = mad(fragment_unnamed_1335.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1351 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_683, fragment_unnamed_681), fragment_unnamed_722);
						float4 fragment_unnamed_1356 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_683, fragment_unnamed_685), fragment_unnamed_722);
						fragment_unnamed_803 = fragment_unnamed_1307.x;
						fragment_unnamed_805 = fragment_unnamed_1307.y;
						fragment_unnamed_807 = fragment_unnamed_1307.z;
						fragment_unnamed_809 = fragment_unnamed_1313.x;
						fragment_unnamed_811 = fragment_unnamed_1313.y;
						fragment_unnamed_813 = fragment_unnamed_1313.z;
						fragment_unnamed_815 = fragment_unnamed_1307.w;
						fragment_unnamed_817 = fragment_unnamed_1313.w;
						fragment_unnamed_819 = fragment_unnamed_1326;
						fragment_unnamed_821 = fragment_unnamed_1327;
						fragment_unnamed_823 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1326, fragment_unnamed_1327), float2(fragment_unnamed_1326, fragment_unnamed_1327)), 1.0f)) + 1.0f);
						fragment_unnamed_825 = fragment_unnamed_1341;
						fragment_unnamed_827 = fragment_unnamed_1342;
						fragment_unnamed_829 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1341, fragment_unnamed_1342), float2(fragment_unnamed_1341, fragment_unnamed_1342)), 1.0f)) + 1.0f);
						fragment_unnamed_831 = fragment_unnamed_1351.x;
						fragment_unnamed_833 = fragment_unnamed_1351.y;
						fragment_unnamed_835 = fragment_unnamed_1351.z;
						fragment_unnamed_837 = fragment_unnamed_1356.x;
						fragment_unnamed_839 = fragment_unnamed_1356.y;
						fragment_unnamed_841 = fragment_unnamed_1356.z;
					}
					fragment_unnamed_802 = fragment_unnamed_803;
					fragment_unnamed_804 = fragment_unnamed_805;
					fragment_unnamed_806 = fragment_unnamed_807;
					fragment_unnamed_808 = fragment_unnamed_809;
					fragment_unnamed_810 = fragment_unnamed_811;
					fragment_unnamed_812 = fragment_unnamed_813;
					fragment_unnamed_814 = fragment_unnamed_815;
					fragment_unnamed_816 = fragment_unnamed_817;
					fragment_unnamed_818 = fragment_unnamed_819;
					fragment_unnamed_820 = fragment_unnamed_821;
					fragment_unnamed_822 = fragment_unnamed_823;
					fragment_unnamed_824 = fragment_unnamed_825;
					fragment_unnamed_826 = fragment_unnamed_827;
					fragment_unnamed_828 = fragment_unnamed_829;
					fragment_unnamed_830 = fragment_unnamed_831;
					fragment_unnamed_832 = fragment_unnamed_833;
					fragment_unnamed_834 = fragment_unnamed_835;
					fragment_unnamed_836 = fragment_unnamed_837;
					fragment_unnamed_838 = fragment_unnamed_839;
					fragment_unnamed_840 = fragment_unnamed_841;
				}
				float4 fragment_unnamed_848 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_328 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_856 = fragment_unnamed_848.w * 0.800000011920928955078125f;
				float fragment_unnamed_858 = mad(fragment_unnamed_848.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_866 = exp2(log2(abs(fragment_unnamed_490) + abs(fragment_unnamed_490)) * 10.0f);
				float fragment_unnamed_885 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_820) + fragment_unnamed_826, fragment_unnamed_820);
				float fragment_unnamed_886 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_818) + fragment_unnamed_824, fragment_unnamed_818);
				float fragment_unnamed_887 = mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_822) + fragment_unnamed_828, fragment_unnamed_822);
				float fragment_unnamed_897 = (fragment_unnamed_858 * fragment_unnamed_848.x) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_802) + fragment_unnamed_808, fragment_unnamed_802);
				float fragment_unnamed_898 = (fragment_unnamed_858 * fragment_unnamed_848.y) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_804) + fragment_unnamed_810, fragment_unnamed_804);
				float fragment_unnamed_899 = (fragment_unnamed_858 * fragment_unnamed_848.z) * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_806) + fragment_unnamed_812, fragment_unnamed_806);
				float fragment_unnamed_906 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_unnamed_897), fragment_unnamed_897);
				float fragment_unnamed_907 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_unnamed_898), fragment_unnamed_898);
				float fragment_unnamed_908 = mad(fragment_unnamed_848.w, mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_unnamed_899), fragment_unnamed_899);
				float fragment_unnamed_910 = ((-0.0f) - mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_814) + fragment_unnamed_816, fragment_unnamed_814)) + 1.0f;
				float fragment_unnamed_915 = fragment_unnamed_910 * fragment_uniform_buffer_0[4u].w;
				float fragment_unnamed_924 = mad(fragment_unnamed_848.w, mad((-0.0f) - fragment_unnamed_910, fragment_uniform_buffer_0[4u].w, clamp(fragment_unnamed_915 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_915);
				bool fragment_unnamed_958 = (fragment_unnamed_415 & (fragment_unnamed_418 & (((fragment_unnamed_670 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_670) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_966 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_906) : asuint(fragment_unnamed_906);
				uint fragment_unnamed_968 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_907) : asuint(fragment_unnamed_907);
				uint fragment_unnamed_970 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * fragment_unnamed_908) : asuint(fragment_unnamed_908);
				uint fragment_unnamed_972 = fragment_unnamed_958 ? asuint(fragment_unnamed_724 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_983 = (fragment_unnamed_422 & (fragment_unnamed_412 & (((fragment_unnamed_665 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_665) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_988 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_966)) : fragment_unnamed_966;
				uint fragment_unnamed_990 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_968)) : fragment_unnamed_968;
				uint fragment_unnamed_992 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_970)) : fragment_unnamed_970;
				uint fragment_unnamed_994 = fragment_unnamed_983 ? asuint(fragment_unnamed_502 * asfloat(fragment_unnamed_972)) : fragment_unnamed_972;
				bool fragment_unnamed_1003 = (((fragment_unnamed_667 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_667) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_1008 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_988)) : fragment_unnamed_988;
				uint fragment_unnamed_1010 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_990)) : fragment_unnamed_990;
				uint fragment_unnamed_1012 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_992)) : fragment_unnamed_992;
				uint fragment_unnamed_1014 = fragment_unnamed_1003 ? asuint(fragment_unnamed_499 * asfloat(fragment_unnamed_994)) : fragment_unnamed_994;
				bool fragment_unnamed_1023 = (((fragment_unnamed_669 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_669) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_1029 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1014)) : fragment_unnamed_1014);
				discard_cond((fragment_unnamed_1029 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1049 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_9.x / fragment_input_9.w, fragment_input_9.y / fragment_input_9.w));
				float fragment_unnamed_1051 = fragment_unnamed_1049.x;
				float fragment_unnamed_1052 = fragment_unnamed_1049.y;
				float fragment_unnamed_1053 = fragment_unnamed_1049.z;
				float fragment_unnamed_1058 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1008)) : fragment_unnamed_1008) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1059 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1010)) : fragment_unnamed_1010) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1060 = asfloat(fragment_unnamed_1023 ? asuint(fragment_unnamed_501 * asfloat(fragment_unnamed_1012)) : fragment_unnamed_1012) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1072 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1073 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1074 = fragment_uniform_buffer_0[13u].x + fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1075 = fragment_uniform_buffer_0[13u].y + fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1081 = fragment_unnamed_1074 * fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1082 = fragment_unnamed_1075 * fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1083 = fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1091 = fragment_unnamed_1074 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1092 = fragment_unnamed_1075 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1096 = fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1127 = mad(fragment_unnamed_1092 + (fragment_unnamed_1072 * fragment_uniform_buffer_0[13u].x), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1075, (-0.0f) - fragment_unnamed_1096), fragment_input_4.y, (((-0.0f) - (fragment_unnamed_1083 + fragment_unnamed_1082)) + 1.0f) * fragment_input_4.x));
				float fragment_unnamed_1145 = mad(mad(fragment_uniform_buffer_0[13u].y, fragment_unnamed_1073, (-0.0f) - fragment_unnamed_1091), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1075, fragment_unnamed_1096), fragment_input_4.x, (((-0.0f) - (fragment_unnamed_1083 + fragment_unnamed_1081)) + 1.0f) * fragment_input_4.y));
				float fragment_unnamed_1151 = mad(((-0.0f) - (fragment_unnamed_1082 + fragment_unnamed_1081)) + 1.0f, fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1072, (-0.0f) - fragment_unnamed_1092), fragment_input_4.x, (fragment_unnamed_1091 + (fragment_unnamed_1073 * fragment_uniform_buffer_0[13u].y)) * fragment_input_4.y));
				float fragment_unnamed_1155 = rsqrt(dot(float3(fragment_unnamed_1127, fragment_unnamed_1145, fragment_unnamed_1151), float3(fragment_unnamed_1127, fragment_unnamed_1145, fragment_unnamed_1151)));
				float fragment_unnamed_1156 = fragment_unnamed_1155 * fragment_unnamed_1127;
				float fragment_unnamed_1157 = fragment_unnamed_1155 * fragment_unnamed_1145;
				float fragment_unnamed_1158 = fragment_unnamed_1155 * fragment_unnamed_1151;
				float fragment_unnamed_1165 = mad(mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1058), 0.5f, fragment_unnamed_1058);
				float fragment_unnamed_1166 = mad(mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1059), 0.5f, fragment_unnamed_1059);
				float fragment_unnamed_1167 = mad(mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_unnamed_1060), 0.5f, fragment_unnamed_1060);
				float fragment_unnamed_1168 = dot(float3(fragment_unnamed_1165, fragment_unnamed_1166, fragment_unnamed_1167), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1174 = mad(((-0.0f) - fragment_unnamed_1168) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1168);
				float fragment_unnamed_1180 = (-0.0f) - fragment_unnamed_1174;
				float fragment_unnamed_1201 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 0.7200000286102294921875f, fragment_unnamed_1165), 0.14000000059604644775390625f, fragment_unnamed_1174 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1058), fragment_unnamed_1058);
				float fragment_unnamed_1202 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 0.85000002384185791015625f, fragment_unnamed_1166), 0.14000000059604644775390625f, fragment_unnamed_1174 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1059), fragment_unnamed_1059);
				float fragment_unnamed_1203 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1180, 1.0f, fragment_unnamed_1167), 0.14000000059604644775390625f, fragment_unnamed_1174 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1060), fragment_unnamed_1060);
				float fragment_unnamed_1208 = mad((-0.0f) - fragment_uniform_buffer_0[15u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1237 = ((-0.0f) - fragment_input_1.w) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1238 = ((-0.0f) - fragment_input_2.w) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1239 = ((-0.0f) - fragment_input_3.w) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1243 = rsqrt(dot(float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239), float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239)));
				float fragment_unnamed_1244 = fragment_unnamed_1243 * fragment_unnamed_1237;
				float fragment_unnamed_1245 = fragment_unnamed_1243 * fragment_unnamed_1238;
				float fragment_unnamed_1246 = fragment_unnamed_1243 * fragment_unnamed_1239;
				float fragment_unnamed_1454;
				float fragment_unnamed_1455;
				float fragment_unnamed_1456;
				float fragment_unnamed_1457;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1364 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1444 = _Global_PGI.Sample(sampler_Global_PGI, float3(max(mad((asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].x, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].x, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : asuint(fragment_input_1.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), (asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].y, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].y, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : asuint(fragment_input_2.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, (asfloat(fragment_unnamed_1364 ? asuint(mad(fragment_uniform_buffer_3[3u].z, fragment_input_3.w, mad(fragment_uniform_buffer_3[1u].z, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : asuint(fragment_input_3.w)) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1454 = fragment_unnamed_1444.x;
					fragment_unnamed_1455 = fragment_unnamed_1444.y;
					fragment_unnamed_1456 = fragment_unnamed_1444.z;
					fragment_unnamed_1457 = fragment_unnamed_1444.w;
				}
				else
				{
					fragment_unnamed_1454 = asfloat(1065353216u);
					fragment_unnamed_1455 = asfloat(1065353216u);
					fragment_unnamed_1456 = asfloat(1065353216u);
					fragment_unnamed_1457 = asfloat(1065353216u);
				}
				float fragment_unnamed_1468 = clamp(dot(float4(fragment_unnamed_1454, fragment_unnamed_1455, fragment_unnamed_1456, fragment_unnamed_1457), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float fragment_unnamed_1475 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1484 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1493 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_885, fragment_unnamed_886, fragment_unnamed_887));
				float fragment_unnamed_1499 = rsqrt(dot(float3(fragment_unnamed_1475, fragment_unnamed_1484, fragment_unnamed_1493), float3(fragment_unnamed_1475, fragment_unnamed_1484, fragment_unnamed_1493)));
				float fragment_unnamed_1500 = fragment_unnamed_1499 * fragment_unnamed_1475;
				float fragment_unnamed_1501 = fragment_unnamed_1499 * fragment_unnamed_1484;
				float fragment_unnamed_1502 = fragment_unnamed_1499 * fragment_unnamed_1493;
				float fragment_unnamed_1522 = ((-0.0f) - fragment_uniform_buffer_0[5u].x) + 1.0f;
				float fragment_unnamed_1523 = ((-0.0f) - fragment_uniform_buffer_0[5u].y) + 1.0f;
				float fragment_unnamed_1524 = ((-0.0f) - fragment_uniform_buffer_0[5u].z) + 1.0f;
				float fragment_unnamed_1537 = dot(float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1540 = mad(fragment_unnamed_1537, 0.25f, 1.0f);
				float fragment_unnamed_1542 = fragment_unnamed_1540 * (fragment_unnamed_1540 * fragment_unnamed_1540);
				float fragment_unnamed_1547 = exp2(log2(max(fragment_unnamed_1537, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1548 = fragment_unnamed_1547 + fragment_unnamed_1547;
				float fragment_unnamed_1559 = asfloat((0.5f < fragment_unnamed_1547) ? asuint(mad(log2(mad(log2(fragment_unnamed_1548), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1548)) * 0.5f;
				float fragment_unnamed_1565 = dot(float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1707;
				float fragment_unnamed_1708;
				float fragment_unnamed_1709;
				if (1.0f >= fragment_unnamed_1565)
				{
					float fragment_unnamed_1586 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].x) + 1.0f), fragment_unnamed_1522, 1.0f);
					float fragment_unnamed_1587 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].y) + 1.0f), fragment_unnamed_1523, 1.0f);
					float fragment_unnamed_1588 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].z) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1604 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].x) + 1.0f), fragment_unnamed_1522, 1.0f);
					float fragment_unnamed_1605 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].y) + 1.0f), fragment_unnamed_1523, 1.0f);
					float fragment_unnamed_1606 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].z) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1635 = clamp((fragment_unnamed_1565 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1636 = clamp((fragment_unnamed_1565 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1637 = clamp((fragment_unnamed_1565 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1638 = clamp((fragment_unnamed_1565 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1661 = 0.20000000298023223876953125f < fragment_unnamed_1565;
					bool fragment_unnamed_1662 = 0.100000001490116119384765625f < fragment_unnamed_1565;
					bool fragment_unnamed_1663 = (-0.100000001490116119384765625f) < fragment_unnamed_1565;
					float fragment_unnamed_1664 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].x) + 1.0f), fragment_unnamed_1522, 1.0f) * 1.5f;
					float fragment_unnamed_1666 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].y) + 1.0f), fragment_unnamed_1523, 1.0f) * 1.5f;
					float fragment_unnamed_1667 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].z) + 1.0f), fragment_unnamed_1524, 1.0f) * 1.5f;
					fragment_unnamed_1707 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1586) + 1.0f, fragment_unnamed_1586)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1604, 1.25f, fragment_unnamed_1586), fragment_unnamed_1604 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1604, 1.25f, (-0.0f) - fragment_unnamed_1664), fragment_unnamed_1664)) : asuint(fragment_unnamed_1664 * fragment_unnamed_1638))));
					fragment_unnamed_1708 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1587) + 1.0f, fragment_unnamed_1587)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1605, 1.25f, fragment_unnamed_1587), fragment_unnamed_1605 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1605, 1.25f, (-0.0f) - fragment_unnamed_1666), fragment_unnamed_1666)) : asuint(fragment_unnamed_1666 * fragment_unnamed_1638))));
					fragment_unnamed_1709 = asfloat(fragment_unnamed_1661 ? asuint(mad(fragment_unnamed_1635, ((-0.0f) - fragment_unnamed_1588) + 1.0f, fragment_unnamed_1588)) : (fragment_unnamed_1662 ? asuint(mad(fragment_unnamed_1636, mad((-0.0f) - fragment_unnamed_1606, 1.25f, fragment_unnamed_1588), fragment_unnamed_1606 * 1.25f)) : (fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, mad(fragment_unnamed_1606, 1.25f, (-0.0f) - fragment_unnamed_1667), fragment_unnamed_1667)) : asuint(fragment_unnamed_1667 * fragment_unnamed_1638))));
				}
				else
				{
					fragment_unnamed_1707 = asfloat(1065353216u);
					fragment_unnamed_1708 = asfloat(1065353216u);
					fragment_unnamed_1709 = asfloat(1065353216u);
				}
				float fragment_unnamed_1717 = clamp(fragment_unnamed_1565 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1721 = mad(clamp(fragment_unnamed_1565 * 0.1500000059604644775390625f, 0.0f, 1.0f), ((-0.0f) - fragment_unnamed_1468) + 1.0f, fragment_unnamed_1468) * 0.800000011920928955078125f;
				float fragment_unnamed_1733 = min(max((((-0.0f) - fragment_uniform_buffer_0[11u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1742 = mad(clamp(mad(log2(fragment_uniform_buffer_0[11u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1758 = mad(exp2(log2(fragment_uniform_buffer_0[6u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1761 = mad(exp2(log2(fragment_uniform_buffer_0[6u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1762 = mad(exp2(log2(fragment_uniform_buffer_0[6u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1793 = mad(exp2(log2(fragment_uniform_buffer_0[7u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1794 = mad(exp2(log2(fragment_uniform_buffer_0[7u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1795 = mad(exp2(log2(fragment_uniform_buffer_0[7u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1805 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1793) + 0.0240000002086162567138671875f, fragment_unnamed_1793);
				float fragment_unnamed_1806 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1794) + 0.0240000002086162567138671875f, fragment_unnamed_1794);
				float fragment_unnamed_1807 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1795) + 0.0240000002086162567138671875f, fragment_unnamed_1795);
				float fragment_unnamed_1822 = mad(exp2(log2(fragment_uniform_buffer_0[8u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1823 = mad(exp2(log2(fragment_uniform_buffer_0[8u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1824 = mad(exp2(log2(fragment_uniform_buffer_0[8u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1837 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1822, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1822);
				float fragment_unnamed_1838 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1823, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1823);
				float fragment_unnamed_1839 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1824, fragment_unnamed_1733, 0.0240000002086162567138671875f), fragment_unnamed_1733 * fragment_unnamed_1824);
				float fragment_unnamed_1840 = dot(float3(fragment_unnamed_1805, fragment_unnamed_1806, fragment_unnamed_1807), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1849 = mad(((-0.0f) - fragment_unnamed_1805) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1805);
				float fragment_unnamed_1850 = mad(((-0.0f) - fragment_unnamed_1806) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1806);
				float fragment_unnamed_1851 = mad(((-0.0f) - fragment_unnamed_1807) + fragment_unnamed_1840, 0.300000011920928955078125f, fragment_unnamed_1807);
				float fragment_unnamed_1852 = dot(float3(fragment_unnamed_1837, fragment_unnamed_1838, fragment_unnamed_1839), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1861 = mad(((-0.0f) - fragment_unnamed_1837) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1837);
				float fragment_unnamed_1862 = mad(((-0.0f) - fragment_unnamed_1838) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1838);
				float fragment_unnamed_1863 = mad(((-0.0f) - fragment_unnamed_1839) + fragment_unnamed_1852, 0.300000011920928955078125f, fragment_unnamed_1839);
				bool fragment_unnamed_1864 = 0.0f < fragment_unnamed_1565;
				float fragment_unnamed_1877 = clamp(mad(fragment_unnamed_1565, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1878 = clamp(mad(fragment_unnamed_1565, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1902 = clamp(mad(dot(float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1906 = asfloat(asuint(fragment_uniform_buffer_0[10u]).x) + 1.0f;
				float fragment_unnamed_1913 = dot(float3((-0.0f) - fragment_unnamed_1244, (-0.0f) - fragment_unnamed_1245, (-0.0f) - fragment_unnamed_1246), float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502));
				float fragment_unnamed_1917 = (-0.0f) - (fragment_unnamed_1913 + fragment_unnamed_1913);
				float fragment_unnamed_1921 = mad(fragment_unnamed_1500, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1244);
				float fragment_unnamed_1922 = mad(fragment_unnamed_1501, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1245);
				float fragment_unnamed_1923 = mad(fragment_unnamed_1502, fragment_unnamed_1917, (-0.0f) - fragment_unnamed_1246);
				uint fragment_unnamed_1939 = (fragment_uniform_buffer_0[25u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1954 = sqrt(dot(float3(fragment_uniform_buffer_0[25u].xyz), float3(fragment_uniform_buffer_0[25u].xyz))) + (-5.0f);
				float fragment_unnamed_1970 = clamp(fragment_unnamed_1954, 0.0f, 1.0f) * clamp(dot(float3((-0.0f) - fragment_unnamed_1156, (-0.0f) - fragment_unnamed_1157, (-0.0f) - fragment_unnamed_1158), float3(fragment_uniform_buffer_0[12u].xyz)) * 5.0f, 0.0f, 1.0f);
				float fragment_unnamed_1979 = mad((-0.0f) - fragment_unnamed_1156, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].x);
				float fragment_unnamed_1980 = mad((-0.0f) - fragment_unnamed_1157, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].y);
				float fragment_unnamed_1981 = mad((-0.0f) - fragment_unnamed_1158, fragment_unnamed_1954, fragment_uniform_buffer_0[25u].z);
				float fragment_unnamed_1985 = sqrt(dot(float3(fragment_unnamed_1979, fragment_unnamed_1980, fragment_unnamed_1981), float3(fragment_unnamed_1979, fragment_unnamed_1980, fragment_unnamed_1981)));
				float fragment_unnamed_1991 = max((((-0.0f) - fragment_unnamed_1985) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1993 = fragment_unnamed_1985 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_2009 = fragment_unnamed_1970 * ((fragment_unnamed_1991 * fragment_unnamed_1991) * clamp(dot(float3(fragment_unnamed_1979 / fragment_unnamed_1985, fragment_unnamed_1980 / fragment_unnamed_1985, fragment_unnamed_1981 / fragment_unnamed_1985), float3(fragment_unnamed_1500, fragment_unnamed_1501, fragment_unnamed_1502)), 0.0f, 1.0f));
				float fragment_unnamed_2027 = clamp(fragment_unnamed_1208 * mad(fragment_unnamed_848.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_924) + 1.0f, fragment_unnamed_924), 0.0f, 1.0f);
				float fragment_unnamed_2033 = exp2(log2(fragment_unnamed_1878 * max(dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_uniform_buffer_0[12u].xyz)), 0.0f)) * exp2(fragment_unnamed_2027 * 6.906890392303466796875f));
				uint fragment_unnamed_2050 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158))) ? 4294967295u : 0u;
				float fragment_unnamed_2058 = mad(fragment_unnamed_1156, 1.0f, (-0.0f) - (fragment_unnamed_1157 * 0.0f));
				float fragment_unnamed_2059 = mad(fragment_unnamed_1157, 0.0f, (-0.0f) - (fragment_unnamed_1158 * 1.0f));
				float fragment_unnamed_2064 = rsqrt(dot(float2(fragment_unnamed_2058, fragment_unnamed_2059), float2(fragment_unnamed_2058, fragment_unnamed_2059)));
				bool fragment_unnamed_2068 = (fragment_unnamed_2050 & ((fragment_unnamed_1157 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2073 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * fragment_unnamed_2058) : 0u);
				float fragment_unnamed_2075 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * fragment_unnamed_2059) : 1065353216u);
				float fragment_unnamed_2077 = asfloat(fragment_unnamed_2068 ? asuint(fragment_unnamed_2064 * mad(fragment_unnamed_1158, 0.0f, (-0.0f) - (fragment_unnamed_1156 * 0.0f))) : 0u);
				float fragment_unnamed_2090 = mad(fragment_unnamed_2077, fragment_unnamed_1158, (-0.0f) - (fragment_unnamed_1157 * fragment_unnamed_2073));
				float fragment_unnamed_2091 = mad(fragment_unnamed_2073, fragment_unnamed_1156, (-0.0f) - (fragment_unnamed_1158 * fragment_unnamed_2075));
				float fragment_unnamed_2092 = mad(fragment_unnamed_2075, fragment_unnamed_1157, (-0.0f) - (fragment_unnamed_1156 * fragment_unnamed_2077));
				float fragment_unnamed_2096 = rsqrt(dot(float3(fragment_unnamed_2090, fragment_unnamed_2091, fragment_unnamed_2092), float3(fragment_unnamed_2090, fragment_unnamed_2091, fragment_unnamed_2092)));
				bool fragment_unnamed_2108 = (fragment_unnamed_2050 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2073, fragment_unnamed_2075), float2(fragment_unnamed_2073, fragment_unnamed_2075))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2126 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1923, fragment_unnamed_1921), float2((-0.0f) - fragment_unnamed_2073, (-0.0f) - fragment_unnamed_2075)), dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_unnamed_1156, fragment_unnamed_1157, fragment_unnamed_1158)), dot(float3(fragment_unnamed_1921, fragment_unnamed_1922, fragment_unnamed_1923), float3(fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2090)) : (-0.0f), fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2091)) : (-0.0f), fragment_unnamed_2108 ? ((-0.0f) - (fragment_unnamed_2096 * fragment_unnamed_2092)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2027) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2145 = mad(fragment_unnamed_1878, ((-0.0f) - fragment_uniform_buffer_0[9u].y) + fragment_uniform_buffer_0[9u].x, fragment_uniform_buffer_0[9u].y);
				float fragment_unnamed_2149 = dot(float3(fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.x), fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.y), fragment_unnamed_2145 * (fragment_unnamed_2027 * fragment_unnamed_2126.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2170 = fragment_unnamed_2149 + mad(fragment_unnamed_1201, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 1.2999999523162841796875f) : asuint(fragment_unnamed_2009 * 1.2999999523162841796875f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1522, 1.0f) * fragment_unnamed_1707), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1758, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1758) + ((-0.0f) - fragment_unnamed_1849), fragment_unnamed_1849)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1861) + fragment_unnamed_1849, fragment_unnamed_1861)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.x, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].x), fragment_uniform_buffer_0[4u].x)) * fragment_unnamed_2033)) * 0.5f);
				float fragment_unnamed_2171 = fragment_unnamed_2149 + mad(fragment_unnamed_1202, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 1.10000002384185791015625f) : asuint(fragment_unnamed_2009 * 1.10000002384185791015625f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1523, 1.0f) * fragment_unnamed_1708), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1761, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1761) + ((-0.0f) - fragment_unnamed_1850), fragment_unnamed_1850)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1862) + fragment_unnamed_1850, fragment_unnamed_1862)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.y, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].y), fragment_uniform_buffer_0[4u].y)) * fragment_unnamed_2033)) * 0.5f);
				float fragment_unnamed_2172 = fragment_unnamed_2149 + mad(fragment_unnamed_1203, asfloat((fragment_unnamed_1993 ? asuint(fragment_unnamed_1970 * 0.60000002384185791015625f) : asuint(fragment_unnamed_2009 * 0.60000002384185791015625f)) & fragment_unnamed_1939) + mad(fragment_unnamed_1559 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1524, 1.0f) * fragment_unnamed_1709), fragment_unnamed_1721, fragment_unnamed_1542 * (fragment_unnamed_1906 * (fragment_unnamed_1902 * asfloat(fragment_unnamed_1864 ? asuint(mad(fragment_unnamed_1717, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1762, fragment_unnamed_1742, 0.0240000002086162567138671875f), fragment_unnamed_1742 * fragment_unnamed_1762) + ((-0.0f) - fragment_unnamed_1851), fragment_unnamed_1851)) : asuint(mad(fragment_unnamed_1877, ((-0.0f) - fragment_unnamed_1863) + fragment_unnamed_1851, fragment_unnamed_1863)))))), (fragment_unnamed_2027 * ((fragment_unnamed_1208 * mad(fragment_unnamed_856, mad(fragment_unnamed_848.z, fragment_unnamed_858, (-0.0f) - fragment_uniform_buffer_0[4u].z), fragment_uniform_buffer_0[4u].z)) * fragment_unnamed_2033)) * 0.5f);
				fragment_output_0.x = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_830) + fragment_unnamed_836, fragment_unnamed_830)) + mad(fragment_unnamed_1201, fragment_input_11.x, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1051) + fragment_unnamed_2170, fragment_unnamed_1051));
				fragment_output_0.y = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_832) + fragment_unnamed_838, fragment_unnamed_832)) + mad(fragment_unnamed_1202, fragment_input_11.y, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1052) + fragment_unnamed_2171, fragment_unnamed_1052));
				fragment_output_0.z = (fragment_unnamed_1208 * mad(fragment_unnamed_866, ((-0.0f) - fragment_unnamed_834) + fragment_unnamed_840, fragment_unnamed_834)) + mad(fragment_unnamed_1203, fragment_input_11.z, mad(fragment_unnamed_1029, ((-0.0f) - fragment_unnamed_1053) + fragment_unnamed_2172, fragment_unnamed_1053));
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[2] = float4(_LightColor0[0], _LightColor0[1], _LightColor0[2], _LightColor0[3]);

				fragment_uniform_buffer_0[4] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[5] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[6] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[7] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[8] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[9] = float4(_GIStrengthDay, fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], _GIStrengthNight, fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], _Multiplier);

				fragment_uniform_buffer_0[10] = float4(_AmbientInc, fragment_uniform_buffer_0[10][1], fragment_uniform_buffer_0[10][2], fragment_uniform_buffer_0[10][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], fragment_uniform_buffer_0[11][1], _Distance, fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[12] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[12][3]);

				fragment_uniform_buffer_0[13] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[15][1], fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[17] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[18] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[25] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // !SHADOWS_SCREEN


			#ifdef DIRECTIONAL
			#ifdef SHADOWS_SCREEN
			#ifndef LIGHTPROBE_SH
			#define ANY_SHADER_VARIANT_ACTIVE

			float4 _LightColor0;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 _LightShadowData;
			float4 unity_ShadowFadeCenterAndType;
			float4x4 unity_MatrixV;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[26];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[26];
			static float4 fragment_uniform_buffer_4[13];
			static float4 fragment_uniform_buffer_5[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _EmissionTex1;
			SamplerState sampler_EmissionTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _EmissionTex2;
			SamplerState sampler_EmissionTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _EmissionTex3;
			SamplerState sampler_EmissionTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _ShadowMapTexture;
			SamplerState sampler_ShadowMapTexture;
			Texture2D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float4 fragment_input_1;
			static float4 fragment_input_2;
			static float4 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float4 fragment_input_9;
			static float3 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float4 fragment_input_1 : TEXCOORD; // TEXCOORD
				float4 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float4 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float4 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float3 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD12; // TEXCOORD_12
				float4 fragment_input_13 : TEXCOORD13; // TEXCOORD_13
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2287)
			{
				if (fragment_unnamed_2287)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_146 = rsqrt(dot(float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z), float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z)));
				float fragment_unnamed_153 = fragment_unnamed_146 * fragment_input_4.y;
				float fragment_unnamed_154 = fragment_unnamed_146 * fragment_input_4.x;
				float fragment_unnamed_155 = fragment_unnamed_146 * fragment_input_4.z;
				uint fragment_unnamed_164 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_170 = sqrt(((-0.0f) - abs(fragment_unnamed_153)) + 1.0f);
				float fragment_unnamed_179 = mad(mad(mad(abs(fragment_unnamed_153), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_153), -0.212114393711090087890625f), abs(fragment_unnamed_153), 1.570728778839111328125f);
				float fragment_unnamed_204 = (1.0f / max(abs(fragment_unnamed_155), abs(fragment_unnamed_154))) * min(abs(fragment_unnamed_155), abs(fragment_unnamed_154));
				float fragment_unnamed_205 = fragment_unnamed_204 * fragment_unnamed_204;
				float fragment_unnamed_213 = mad(fragment_unnamed_205, mad(fragment_unnamed_205, mad(fragment_unnamed_205, mad(fragment_unnamed_205, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_231 = asfloat(((((-0.0f) - fragment_unnamed_155) < fragment_unnamed_155) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_204, fragment_unnamed_213, asfloat(((abs(fragment_unnamed_155) < abs(fragment_unnamed_154)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_213 * fragment_unnamed_204, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_233 = min((-0.0f) - fragment_unnamed_155, fragment_unnamed_154);
				float fragment_unnamed_235 = max((-0.0f) - fragment_unnamed_155, fragment_unnamed_154);
				float fragment_unnamed_249 = (((-0.0f) - mad(fragment_unnamed_179, fragment_unnamed_170, asfloat(((fragment_unnamed_153 < ((-0.0f) - fragment_unnamed_153)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_170 * fragment_unnamed_179, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_250 = fragment_unnamed_249 * 0.3183098733425140380859375f;
				bool fragment_unnamed_252 = 0.0f < fragment_unnamed_249;
				float fragment_unnamed_259 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_250)) : asuint(floor(fragment_unnamed_250)));
				float fragment_unnamed_263 = float(fragment_unnamed_164);
				uint fragment_unnamed_271 = uint(asfloat((0.0f < fragment_unnamed_259) ? asuint(fragment_unnamed_259 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_259) + fragment_unnamed_263) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_273 = _OffsetsBuffer.Load(fragment_unnamed_271);
				uint fragment_unnamed_274 = fragment_unnamed_273.x;
				float fragment_unnamed_281 = float((-fragment_unnamed_274) + _OffsetsBuffer.Load(fragment_unnamed_271 + 1u).x);
				float fragment_unnamed_282 = mad(((((fragment_unnamed_235 >= ((-0.0f) - fragment_unnamed_235)) ? 4294967295u : 0u) & ((fragment_unnamed_233 < ((-0.0f) - fragment_unnamed_233)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_231) : fragment_unnamed_231, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_284 = fragment_unnamed_281 * fragment_unnamed_282;
				bool fragment_unnamed_285 = 0.0f < fragment_unnamed_284;
				float fragment_unnamed_291 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_284)) : asuint(floor(fragment_unnamed_284)));
				float fragment_unnamed_292 = mad(fragment_unnamed_281, 0.5f, 0.5f);
				float fragment_unnamed_308 = float(fragment_unnamed_274 + uint(asfloat((fragment_unnamed_292 < fragment_unnamed_291) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_291) + (-1.0f)) : asuint(fragment_unnamed_281 + ((-0.0f) - fragment_unnamed_291))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_311 = frac(fragment_unnamed_308);
				uint4 fragment_unnamed_313 = _DataBuffer.Load(uint(floor(fragment_unnamed_308)));
				uint fragment_unnamed_314 = fragment_unnamed_313.x;
				uint fragment_unnamed_326 = 16u & 31u;
				uint fragment_unnamed_333 = 8u & 31u;
				uint fragment_unnamed_341 = (0.625f < fragment_unnamed_311) ? (fragment_unnamed_314 >> 24u) : ((0.375f < fragment_unnamed_311) ? spvBitfieldUExtract(fragment_unnamed_314, fragment_unnamed_326, min((8u & 31u), (32u - fragment_unnamed_326))) : ((0.125f < fragment_unnamed_311) ? spvBitfieldUExtract(fragment_unnamed_314, fragment_unnamed_333, min((8u & 31u), (32u - fragment_unnamed_333))) : (fragment_unnamed_314 & 255u)));
				float fragment_unnamed_343 = float(fragment_unnamed_341 >> 5u);
				float fragment_unnamed_348 = asfloat((6.5f < fragment_unnamed_343) ? 0u : asuint(fragment_unnamed_343));
				float fragment_unnamed_355 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(fragment_unnamed_348 < (fragment_unnamed_355 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_355 + 3.9900000095367431640625f) < fragment_unnamed_348);
				float fragment_unnamed_374 = mad(fragment_unnamed_249, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_375 = mad(fragment_unnamed_249, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_386 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_374)) : asuint(floor(fragment_unnamed_374)));
				float fragment_unnamed_388 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_375)) : asuint(floor(fragment_unnamed_375)));
				uint fragment_unnamed_390 = uint(ceil(max(abs(fragment_unnamed_250) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_409 = uint(asfloat((0.0f < fragment_unnamed_386) ? asuint(fragment_unnamed_386 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_263 + ((-0.0f) - fragment_unnamed_386)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_410 = uint(asfloat((0.0f < fragment_unnamed_388) ? asuint(fragment_unnamed_388 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_263 + ((-0.0f) - fragment_unnamed_388)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_411 = _OffsetsBuffer.Load(fragment_unnamed_409);
				uint fragment_unnamed_412 = fragment_unnamed_411.x;
				uint4 fragment_unnamed_413 = _OffsetsBuffer.Load(fragment_unnamed_410);
				uint fragment_unnamed_414 = fragment_unnamed_413.x;
				uint fragment_unnamed_425 = (fragment_unnamed_271 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_428 = (fragment_unnamed_271 != (fragment_unnamed_164 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_431 = (fragment_unnamed_164 != fragment_unnamed_271) ? 4294967295u : 0u;
				uint fragment_unnamed_435 = (fragment_unnamed_271 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_451 = (fragment_unnamed_435 & (fragment_unnamed_431 & (fragment_unnamed_425 & fragment_unnamed_428))) != 0u;
				uint fragment_unnamed_454 = asuint(fragment_unnamed_281);
				uint fragment_unnamed_455 = fragment_unnamed_451 ? asuint(float((-fragment_unnamed_412) + _OffsetsBuffer.Load(fragment_unnamed_409 + 1u).x)) : fragment_unnamed_454;
				float fragment_unnamed_457 = asfloat(fragment_unnamed_451 ? asuint(float((-fragment_unnamed_414) + _OffsetsBuffer.Load(fragment_unnamed_410 + 1u).x)) : fragment_unnamed_454);
				float fragment_unnamed_460 = fragment_unnamed_282 * asfloat(fragment_unnamed_455);
				float fragment_unnamed_461 = fragment_unnamed_282 * fragment_unnamed_457;
				float fragment_unnamed_462 = mad(fragment_unnamed_282, fragment_unnamed_281, 0.5f);
				float fragment_unnamed_463 = mad(fragment_unnamed_282, fragment_unnamed_281, -0.5f);
				float fragment_unnamed_470 = asfloat((fragment_unnamed_281 < fragment_unnamed_462) ? asuint(((-0.0f) - fragment_unnamed_281) + fragment_unnamed_462) : asuint(fragment_unnamed_462));
				float fragment_unnamed_476 = asfloat((fragment_unnamed_463 < 0.0f) ? asuint(fragment_unnamed_281 + fragment_unnamed_463) : asuint(fragment_unnamed_463));
				float fragment_unnamed_486 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_460)) : asuint(floor(fragment_unnamed_460)));
				float fragment_unnamed_488 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_461)) : asuint(floor(fragment_unnamed_461)));
				float fragment_unnamed_494 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_470)) : asuint(floor(fragment_unnamed_470)));
				float fragment_unnamed_500 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_476)) : asuint(floor(fragment_unnamed_476)));
				float fragment_unnamed_501 = frac(fragment_unnamed_250);
				float fragment_unnamed_502 = frac(fragment_unnamed_284);
				float fragment_unnamed_503 = fragment_unnamed_501 + (-0.5f);
				float fragment_unnamed_512 = min((((-0.0f) - fragment_unnamed_502) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_514 = min(fragment_unnamed_502 * 40.0f, 1.0f);
				float fragment_unnamed_515 = min(fragment_unnamed_501 * 40.0f, 1.0f);
				float fragment_unnamed_574 = float(fragment_unnamed_412 + uint(asfloat((mad(asfloat(fragment_unnamed_455), 0.5f, 0.5f) < fragment_unnamed_486) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_455), 0.5f, fragment_unnamed_486) + (-1.0f)) : asuint(asfloat(fragment_unnamed_455) + ((-0.0f) - fragment_unnamed_486))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_576 = frac(fragment_unnamed_574);
				uint4 fragment_unnamed_578 = _DataBuffer.Load(uint(floor(fragment_unnamed_574)));
				uint fragment_unnamed_579 = fragment_unnamed_578.x;
				uint fragment_unnamed_585 = 16u & 31u;
				uint fragment_unnamed_590 = 8u & 31u;
				float fragment_unnamed_600 = float(uint(asfloat((mad(fragment_unnamed_457, 0.5f, 0.5f) < fragment_unnamed_488) ? asuint(mad((-0.0f) - fragment_unnamed_457, 0.5f, fragment_unnamed_488) + (-1.0f)) : asuint(fragment_unnamed_457 + ((-0.0f) - fragment_unnamed_488))) + 0.100000001490116119384765625f) + fragment_unnamed_414) * 0.25f;
				float fragment_unnamed_602 = frac(fragment_unnamed_600);
				uint4 fragment_unnamed_604 = _DataBuffer.Load(uint(floor(fragment_unnamed_600)));
				uint fragment_unnamed_605 = fragment_unnamed_604.x;
				uint fragment_unnamed_611 = 16u & 31u;
				uint fragment_unnamed_616 = 8u & 31u;
				float fragment_unnamed_626 = float(uint(asfloat((fragment_unnamed_292 < fragment_unnamed_494) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_494) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_494) + fragment_unnamed_281)) + 0.100000001490116119384765625f) + fragment_unnamed_274) * 0.25f;
				float fragment_unnamed_628 = frac(fragment_unnamed_626);
				uint4 fragment_unnamed_630 = _DataBuffer.Load(uint(floor(fragment_unnamed_626)));
				uint fragment_unnamed_631 = fragment_unnamed_630.x;
				uint fragment_unnamed_637 = 16u & 31u;
				uint fragment_unnamed_642 = 8u & 31u;
				float fragment_unnamed_652 = float(uint(asfloat((fragment_unnamed_292 < fragment_unnamed_500) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_500) + (-1.0f)) : asuint(fragment_unnamed_281 + ((-0.0f) - fragment_unnamed_500))) + 0.100000001490116119384765625f) + fragment_unnamed_274) * 0.25f;
				float fragment_unnamed_654 = frac(fragment_unnamed_652);
				uint4 fragment_unnamed_656 = _DataBuffer.Load(uint(floor(fragment_unnamed_652)));
				uint fragment_unnamed_657 = fragment_unnamed_656.x;
				uint fragment_unnamed_663 = 16u & 31u;
				uint fragment_unnamed_668 = 8u & 31u;
				float fragment_unnamed_678 = float(((0.625f < fragment_unnamed_602) ? (fragment_unnamed_605 >> 24u) : ((0.375f < fragment_unnamed_602) ? spvBitfieldUExtract(fragment_unnamed_605, fragment_unnamed_611, min((8u & 31u), (32u - fragment_unnamed_611))) : ((0.125f < fragment_unnamed_602) ? spvBitfieldUExtract(fragment_unnamed_605, fragment_unnamed_616, min((8u & 31u), (32u - fragment_unnamed_616))) : (fragment_unnamed_605 & 255u)))) >> 5u);
				float fragment_unnamed_680 = float(((0.625f < fragment_unnamed_628) ? (fragment_unnamed_631 >> 24u) : ((0.375f < fragment_unnamed_628) ? spvBitfieldUExtract(fragment_unnamed_631, fragment_unnamed_637, min((8u & 31u), (32u - fragment_unnamed_637))) : ((0.125f < fragment_unnamed_628) ? spvBitfieldUExtract(fragment_unnamed_631, fragment_unnamed_642, min((8u & 31u), (32u - fragment_unnamed_642))) : (fragment_unnamed_631 & 255u)))) >> 5u);
				float fragment_unnamed_682 = float(((0.625f < fragment_unnamed_654) ? (fragment_unnamed_657 >> 24u) : ((0.375f < fragment_unnamed_654) ? spvBitfieldUExtract(fragment_unnamed_657, fragment_unnamed_663, min((8u & 31u), (32u - fragment_unnamed_663))) : ((0.125f < fragment_unnamed_654) ? spvBitfieldUExtract(fragment_unnamed_657, fragment_unnamed_668, min((8u & 31u), (32u - fragment_unnamed_668))) : (fragment_unnamed_657 & 255u)))) >> 5u);
				float fragment_unnamed_683 = float(((0.625f < fragment_unnamed_576) ? (fragment_unnamed_579 >> 24u) : ((0.375f < fragment_unnamed_576) ? spvBitfieldUExtract(fragment_unnamed_579, fragment_unnamed_585, min((8u & 31u), (32u - fragment_unnamed_585))) : ((0.125f < fragment_unnamed_576) ? spvBitfieldUExtract(fragment_unnamed_579, fragment_unnamed_590, min((8u & 31u), (32u - fragment_unnamed_590))) : (fragment_unnamed_579 & 255u)))) >> 5u);
				float fragment_unnamed_694 = fragment_unnamed_284 * 0.20000000298023223876953125f;
				float fragment_unnamed_696 = fragment_unnamed_249 * 0.06366197764873504638671875f;
				float fragment_unnamed_698 = (fragment_unnamed_282 * float((-_OffsetsBuffer.Load(fragment_unnamed_390).x) + _OffsetsBuffer.Load(fragment_unnamed_390 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_705 = ddx_coarse(fragment_input_10.x);
				float fragment_unnamed_706 = ddx_coarse(fragment_input_10.y);
				float fragment_unnamed_707 = ddx_coarse(fragment_input_10.z);
				float fragment_unnamed_711 = sqrt(dot(float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707), float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707)));
				float fragment_unnamed_718 = ddy_coarse(fragment_input_10.x);
				float fragment_unnamed_719 = ddy_coarse(fragment_input_10.y);
				float fragment_unnamed_720 = ddy_coarse(fragment_input_10.z);
				float fragment_unnamed_724 = sqrt(dot(float3(fragment_unnamed_718, fragment_unnamed_719, fragment_unnamed_720), float3(fragment_unnamed_718, fragment_unnamed_719, fragment_unnamed_720)));
				float fragment_unnamed_735 = min(max(log2(sqrt(dot(float2(fragment_unnamed_711, fragment_unnamed_724), float2(fragment_unnamed_711, fragment_unnamed_724))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_737 = min((((-0.0f) - fragment_unnamed_501) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_815;
				float fragment_unnamed_817;
				float fragment_unnamed_819;
				float fragment_unnamed_821;
				float fragment_unnamed_823;
				float fragment_unnamed_825;
				float fragment_unnamed_827;
				float fragment_unnamed_829;
				float fragment_unnamed_831;
				float fragment_unnamed_833;
				float fragment_unnamed_835;
				float fragment_unnamed_837;
				float fragment_unnamed_839;
				float fragment_unnamed_841;
				float fragment_unnamed_843;
				float fragment_unnamed_845;
				float fragment_unnamed_847;
				float fragment_unnamed_849;
				float fragment_unnamed_851;
				float fragment_unnamed_853;
				if (((((fragment_unnamed_355 + 0.9900000095367431640625f) < fragment_unnamed_348) ? 4294967295u : 0u) & ((fragment_unnamed_348 < (fragment_unnamed_355 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_750 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float4 fragment_unnamed_756 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					float4 fragment_unnamed_763 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float fragment_unnamed_769 = mad(fragment_unnamed_763.w * fragment_unnamed_763.x, 2.0f, -1.0f);
					float fragment_unnamed_771 = mad(fragment_unnamed_763.y, 2.0f, -1.0f);
					float4 fragment_unnamed_779 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					float fragment_unnamed_785 = mad(fragment_unnamed_779.w * fragment_unnamed_779.x, 2.0f, -1.0f);
					float fragment_unnamed_786 = mad(fragment_unnamed_779.y, 2.0f, -1.0f);
					float4 fragment_unnamed_795 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float4 fragment_unnamed_800 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					fragment_unnamed_815 = fragment_unnamed_750.x;
					fragment_unnamed_817 = fragment_unnamed_750.y;
					fragment_unnamed_819 = fragment_unnamed_750.z;
					fragment_unnamed_821 = fragment_unnamed_756.x;
					fragment_unnamed_823 = fragment_unnamed_756.y;
					fragment_unnamed_825 = fragment_unnamed_756.z;
					fragment_unnamed_827 = fragment_unnamed_750.w;
					fragment_unnamed_829 = fragment_unnamed_756.w;
					fragment_unnamed_831 = fragment_unnamed_769;
					fragment_unnamed_833 = fragment_unnamed_771;
					fragment_unnamed_835 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_769, fragment_unnamed_771), float2(fragment_unnamed_769, fragment_unnamed_771)), 1.0f)) + 1.0f);
					fragment_unnamed_837 = fragment_unnamed_785;
					fragment_unnamed_839 = fragment_unnamed_786;
					fragment_unnamed_841 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_785, fragment_unnamed_786), float2(fragment_unnamed_785, fragment_unnamed_786)), 1.0f)) + 1.0f);
					fragment_unnamed_843 = fragment_unnamed_795.x;
					fragment_unnamed_845 = fragment_unnamed_795.y;
					fragment_unnamed_847 = fragment_unnamed_795.z;
					fragment_unnamed_849 = fragment_unnamed_800.x;
					fragment_unnamed_851 = fragment_unnamed_800.y;
					fragment_unnamed_853 = fragment_unnamed_800.z;
				}
				else
				{
					float fragment_unnamed_816;
					float fragment_unnamed_818;
					float fragment_unnamed_820;
					float fragment_unnamed_822;
					float fragment_unnamed_824;
					float fragment_unnamed_826;
					float fragment_unnamed_828;
					float fragment_unnamed_830;
					float fragment_unnamed_832;
					float fragment_unnamed_834;
					float fragment_unnamed_836;
					float fragment_unnamed_838;
					float fragment_unnamed_840;
					float fragment_unnamed_842;
					float fragment_unnamed_844;
					float fragment_unnamed_846;
					float fragment_unnamed_848;
					float fragment_unnamed_850;
					float fragment_unnamed_852;
					float fragment_unnamed_854;
					if (((((fragment_unnamed_355 + 1.9900000095367431640625f) < fragment_unnamed_348) ? 4294967295u : 0u) & ((fragment_unnamed_348 < (fragment_unnamed_355 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1313 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1319 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float4 fragment_unnamed_1326 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float fragment_unnamed_1332 = mad(fragment_unnamed_1326.w * fragment_unnamed_1326.x, 2.0f, -1.0f);
						float fragment_unnamed_1333 = mad(fragment_unnamed_1326.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1341 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float fragment_unnamed_1347 = mad(fragment_unnamed_1341.w * fragment_unnamed_1341.x, 2.0f, -1.0f);
						float fragment_unnamed_1348 = mad(fragment_unnamed_1341.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1357 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1362 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						fragment_unnamed_816 = fragment_unnamed_1313.x;
						fragment_unnamed_818 = fragment_unnamed_1313.y;
						fragment_unnamed_820 = fragment_unnamed_1313.z;
						fragment_unnamed_822 = fragment_unnamed_1319.x;
						fragment_unnamed_824 = fragment_unnamed_1319.y;
						fragment_unnamed_826 = fragment_unnamed_1319.z;
						fragment_unnamed_828 = fragment_unnamed_1313.w;
						fragment_unnamed_830 = fragment_unnamed_1319.w;
						fragment_unnamed_832 = fragment_unnamed_1332;
						fragment_unnamed_834 = fragment_unnamed_1333;
						fragment_unnamed_836 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1332, fragment_unnamed_1333), float2(fragment_unnamed_1332, fragment_unnamed_1333)), 1.0f)) + 1.0f);
						fragment_unnamed_838 = fragment_unnamed_1347;
						fragment_unnamed_840 = fragment_unnamed_1348;
						fragment_unnamed_842 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1347, fragment_unnamed_1348), float2(fragment_unnamed_1347, fragment_unnamed_1348)), 1.0f)) + 1.0f);
						fragment_unnamed_844 = fragment_unnamed_1357.x;
						fragment_unnamed_846 = fragment_unnamed_1357.y;
						fragment_unnamed_848 = fragment_unnamed_1357.z;
						fragment_unnamed_850 = fragment_unnamed_1362.x;
						fragment_unnamed_852 = fragment_unnamed_1362.y;
						fragment_unnamed_854 = fragment_unnamed_1362.z;
					}
					else
					{
						float4 fragment_unnamed_1368 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1374 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float4 fragment_unnamed_1381 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float fragment_unnamed_1387 = mad(fragment_unnamed_1381.w * fragment_unnamed_1381.x, 2.0f, -1.0f);
						float fragment_unnamed_1388 = mad(fragment_unnamed_1381.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1396 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float fragment_unnamed_1402 = mad(fragment_unnamed_1396.w * fragment_unnamed_1396.x, 2.0f, -1.0f);
						float fragment_unnamed_1403 = mad(fragment_unnamed_1396.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1412 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1417 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						fragment_unnamed_816 = fragment_unnamed_1368.x;
						fragment_unnamed_818 = fragment_unnamed_1368.y;
						fragment_unnamed_820 = fragment_unnamed_1368.z;
						fragment_unnamed_822 = fragment_unnamed_1374.x;
						fragment_unnamed_824 = fragment_unnamed_1374.y;
						fragment_unnamed_826 = fragment_unnamed_1374.z;
						fragment_unnamed_828 = fragment_unnamed_1368.w;
						fragment_unnamed_830 = fragment_unnamed_1374.w;
						fragment_unnamed_832 = fragment_unnamed_1387;
						fragment_unnamed_834 = fragment_unnamed_1388;
						fragment_unnamed_836 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1387, fragment_unnamed_1388), float2(fragment_unnamed_1387, fragment_unnamed_1388)), 1.0f)) + 1.0f);
						fragment_unnamed_838 = fragment_unnamed_1402;
						fragment_unnamed_840 = fragment_unnamed_1403;
						fragment_unnamed_842 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1402, fragment_unnamed_1403), float2(fragment_unnamed_1402, fragment_unnamed_1403)), 1.0f)) + 1.0f);
						fragment_unnamed_844 = fragment_unnamed_1412.x;
						fragment_unnamed_846 = fragment_unnamed_1412.y;
						fragment_unnamed_848 = fragment_unnamed_1412.z;
						fragment_unnamed_850 = fragment_unnamed_1417.x;
						fragment_unnamed_852 = fragment_unnamed_1417.y;
						fragment_unnamed_854 = fragment_unnamed_1417.z;
					}
					fragment_unnamed_815 = fragment_unnamed_816;
					fragment_unnamed_817 = fragment_unnamed_818;
					fragment_unnamed_819 = fragment_unnamed_820;
					fragment_unnamed_821 = fragment_unnamed_822;
					fragment_unnamed_823 = fragment_unnamed_824;
					fragment_unnamed_825 = fragment_unnamed_826;
					fragment_unnamed_827 = fragment_unnamed_828;
					fragment_unnamed_829 = fragment_unnamed_830;
					fragment_unnamed_831 = fragment_unnamed_832;
					fragment_unnamed_833 = fragment_unnamed_834;
					fragment_unnamed_835 = fragment_unnamed_836;
					fragment_unnamed_837 = fragment_unnamed_838;
					fragment_unnamed_839 = fragment_unnamed_840;
					fragment_unnamed_841 = fragment_unnamed_842;
					fragment_unnamed_843 = fragment_unnamed_844;
					fragment_unnamed_845 = fragment_unnamed_846;
					fragment_unnamed_847 = fragment_unnamed_848;
					fragment_unnamed_849 = fragment_unnamed_850;
					fragment_unnamed_851 = fragment_unnamed_852;
					fragment_unnamed_853 = fragment_unnamed_854;
				}
				float4 fragment_unnamed_861 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_341 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_869 = fragment_unnamed_861.w * 0.800000011920928955078125f;
				float fragment_unnamed_871 = mad(fragment_unnamed_861.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_879 = exp2(log2(abs(fragment_unnamed_503) + abs(fragment_unnamed_503)) * 10.0f);
				float fragment_unnamed_898 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_833) + fragment_unnamed_839, fragment_unnamed_833);
				float fragment_unnamed_899 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_831) + fragment_unnamed_837, fragment_unnamed_831);
				float fragment_unnamed_900 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_835) + fragment_unnamed_841, fragment_unnamed_835);
				float fragment_unnamed_910 = (fragment_unnamed_871 * fragment_unnamed_861.x) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_815) + fragment_unnamed_821, fragment_unnamed_815);
				float fragment_unnamed_911 = (fragment_unnamed_871 * fragment_unnamed_861.y) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_817) + fragment_unnamed_823, fragment_unnamed_817);
				float fragment_unnamed_912 = (fragment_unnamed_871 * fragment_unnamed_861.z) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_819) + fragment_unnamed_825, fragment_unnamed_819);
				float fragment_unnamed_919 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_unnamed_910), fragment_unnamed_910);
				float fragment_unnamed_920 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_unnamed_911), fragment_unnamed_911);
				float fragment_unnamed_921 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_unnamed_912), fragment_unnamed_912);
				float fragment_unnamed_923 = ((-0.0f) - mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_827) + fragment_unnamed_829, fragment_unnamed_827)) + 1.0f;
				float fragment_unnamed_928 = fragment_unnamed_923 * fragment_uniform_buffer_0[4u].w;
				float fragment_unnamed_937 = mad(fragment_unnamed_861.w, mad((-0.0f) - fragment_unnamed_923, fragment_uniform_buffer_0[4u].w, clamp(fragment_unnamed_928 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_928);
				bool fragment_unnamed_971 = (fragment_unnamed_428 & (fragment_unnamed_431 & (((fragment_unnamed_683 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_683) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_979 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_919) : asuint(fragment_unnamed_919);
				uint fragment_unnamed_981 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_920) : asuint(fragment_unnamed_920);
				uint fragment_unnamed_983 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_921) : asuint(fragment_unnamed_921);
				uint fragment_unnamed_985 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_996 = (fragment_unnamed_435 & (fragment_unnamed_425 & (((fragment_unnamed_678 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_678) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_1001 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_979)) : fragment_unnamed_979;
				uint fragment_unnamed_1003 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_981)) : fragment_unnamed_981;
				uint fragment_unnamed_1005 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_983)) : fragment_unnamed_983;
				uint fragment_unnamed_1007 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_985)) : fragment_unnamed_985;
				bool fragment_unnamed_1016 = (((fragment_unnamed_680 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_680) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_1021 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1001)) : fragment_unnamed_1001;
				uint fragment_unnamed_1023 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1003)) : fragment_unnamed_1003;
				uint fragment_unnamed_1025 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1005)) : fragment_unnamed_1005;
				uint fragment_unnamed_1027 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1007)) : fragment_unnamed_1007;
				bool fragment_unnamed_1036 = (((fragment_unnamed_682 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_682) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_1042 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1027)) : fragment_unnamed_1027);
				discard_cond((fragment_unnamed_1042 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1062 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_9.x / fragment_input_9.w, fragment_input_9.y / fragment_input_9.w));
				float fragment_unnamed_1064 = fragment_unnamed_1062.x;
				float fragment_unnamed_1065 = fragment_unnamed_1062.y;
				float fragment_unnamed_1066 = fragment_unnamed_1062.z;
				float fragment_unnamed_1071 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1021)) : fragment_unnamed_1021) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1072 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1023)) : fragment_unnamed_1023) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1073 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1025)) : fragment_unnamed_1025) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1085 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1086 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1087 = fragment_uniform_buffer_0[13u].x + fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1088 = fragment_uniform_buffer_0[13u].y + fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1094 = fragment_unnamed_1087 * fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1095 = fragment_unnamed_1088 * fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1096 = fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1104 = fragment_unnamed_1087 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1105 = fragment_unnamed_1088 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1109 = fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1140 = mad(fragment_unnamed_1105 + (fragment_unnamed_1085 * fragment_uniform_buffer_0[13u].x), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1088, (-0.0f) - fragment_unnamed_1109), fragment_input_4.y, (((-0.0f) - (fragment_unnamed_1096 + fragment_unnamed_1095)) + 1.0f) * fragment_input_4.x));
				float fragment_unnamed_1158 = mad(mad(fragment_uniform_buffer_0[13u].y, fragment_unnamed_1086, (-0.0f) - fragment_unnamed_1104), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1088, fragment_unnamed_1109), fragment_input_4.x, (((-0.0f) - (fragment_unnamed_1096 + fragment_unnamed_1094)) + 1.0f) * fragment_input_4.y));
				float fragment_unnamed_1164 = mad(((-0.0f) - (fragment_unnamed_1095 + fragment_unnamed_1094)) + 1.0f, fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1085, (-0.0f) - fragment_unnamed_1105), fragment_input_4.x, (fragment_unnamed_1104 + (fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].y)) * fragment_input_4.y));
				float fragment_unnamed_1168 = rsqrt(dot(float3(fragment_unnamed_1140, fragment_unnamed_1158, fragment_unnamed_1164), float3(fragment_unnamed_1140, fragment_unnamed_1158, fragment_unnamed_1164)));
				float fragment_unnamed_1169 = fragment_unnamed_1168 * fragment_unnamed_1140;
				float fragment_unnamed_1170 = fragment_unnamed_1168 * fragment_unnamed_1158;
				float fragment_unnamed_1171 = fragment_unnamed_1168 * fragment_unnamed_1164;
				float fragment_unnamed_1178 = mad(mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1071), 0.5f, fragment_unnamed_1071);
				float fragment_unnamed_1179 = mad(mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1072), 0.5f, fragment_unnamed_1072);
				float fragment_unnamed_1180 = mad(mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1073), 0.5f, fragment_unnamed_1073);
				float fragment_unnamed_1181 = dot(float3(fragment_unnamed_1178, fragment_unnamed_1179, fragment_unnamed_1180), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1187 = mad(((-0.0f) - fragment_unnamed_1181) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1181);
				float fragment_unnamed_1193 = (-0.0f) - fragment_unnamed_1187;
				float fragment_unnamed_1214 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 0.7200000286102294921875f, fragment_unnamed_1178), 0.14000000059604644775390625f, fragment_unnamed_1187 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1071), fragment_unnamed_1071);
				float fragment_unnamed_1215 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 0.85000002384185791015625f, fragment_unnamed_1179), 0.14000000059604644775390625f, fragment_unnamed_1187 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1072), fragment_unnamed_1072);
				float fragment_unnamed_1216 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 1.0f, fragment_unnamed_1180), 0.14000000059604644775390625f, fragment_unnamed_1187 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1073), fragment_unnamed_1073);
				float fragment_unnamed_1221 = mad((-0.0f) - fragment_uniform_buffer_0[15u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1250 = ((-0.0f) - fragment_input_1.w) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1251 = ((-0.0f) - fragment_input_2.w) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1252 = ((-0.0f) - fragment_input_3.w) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1256 = rsqrt(dot(float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252), float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252)));
				float fragment_unnamed_1257 = fragment_unnamed_1256 * fragment_unnamed_1250;
				float fragment_unnamed_1258 = fragment_unnamed_1256 * fragment_unnamed_1251;
				float fragment_unnamed_1259 = fragment_unnamed_1256 * fragment_unnamed_1252;
				float fragment_unnamed_1275 = dot(float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252), float3(asfloat(asuint(fragment_uniform_buffer_4[9u]).z), asfloat(asuint(fragment_uniform_buffer_4[10u]).z), asfloat(asuint(fragment_uniform_buffer_4[11u]).z)));
				float fragment_unnamed_1287 = fragment_input_1.w + ((-0.0f) - fragment_uniform_buffer_3[25u].x);
				float fragment_unnamed_1288 = fragment_input_2.w + ((-0.0f) - fragment_uniform_buffer_3[25u].y);
				float fragment_unnamed_1289 = fragment_input_3.w + ((-0.0f) - fragment_uniform_buffer_3[25u].z);
				float fragment_unnamed_1515;
				float fragment_unnamed_1516;
				float fragment_unnamed_1517;
				float fragment_unnamed_1518;
				if (fragment_uniform_buffer_5[0u].x == 1.0f)
				{
					bool fragment_unnamed_1425 = fragment_uniform_buffer_5[0u].y == 1.0f;
					float4 fragment_unnamed_1505 = _ShadowMapTexture.Sample(sampler_ShadowMapTexture, float3(max(mad((asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].x, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].x, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].x)) + fragment_uniform_buffer_5[4u].x) : asuint(fragment_input_1.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].x)) * fragment_uniform_buffer_5[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_5[0u].z, 0.5f, 0.75f)), (asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].y, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].y, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].y)) + fragment_uniform_buffer_5[4u].y) : asuint(fragment_input_2.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].y)) * fragment_uniform_buffer_5[5u].y, (asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].z, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].z, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].z)) + fragment_uniform_buffer_5[4u].z) : asuint(fragment_input_3.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].z)) * fragment_uniform_buffer_5[5u].z));
					fragment_unnamed_1515 = fragment_unnamed_1505.x;
					fragment_unnamed_1516 = fragment_unnamed_1505.y;
					fragment_unnamed_1517 = fragment_unnamed_1505.z;
					fragment_unnamed_1518 = fragment_unnamed_1505.w;
				}
				else
				{
					fragment_unnamed_1515 = asfloat(1065353216u);
					fragment_unnamed_1516 = asfloat(1065353216u);
					fragment_unnamed_1517 = asfloat(1065353216u);
					fragment_unnamed_1518 = asfloat(1065353216u);
				}
				float4 fragment_unnamed_1539 = _Global_PGI.Sample(sampler_Global_PGI, float2(fragment_input_12.x / fragment_input_12.w, fragment_input_12.y / fragment_input_12.w));
				float fragment_unnamed_1541 = fragment_unnamed_1539.x;
				float fragment_unnamed_1544 = mad(clamp(mad(mad(fragment_uniform_buffer_3[25u].w, ((-0.0f) - fragment_unnamed_1275) + sqrt(dot(float3(fragment_unnamed_1287, fragment_unnamed_1288, fragment_unnamed_1289), float3(fragment_unnamed_1287, fragment_unnamed_1288, fragment_unnamed_1289))), fragment_unnamed_1275), fragment_uniform_buffer_3[24u].z, fragment_uniform_buffer_3[24u].w), 0.0f, 1.0f), clamp(dot(float4(fragment_unnamed_1515, fragment_unnamed_1516, fragment_unnamed_1517, fragment_unnamed_1518), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f) + ((-0.0f) - fragment_unnamed_1541), fragment_unnamed_1541);
				float fragment_unnamed_1551 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1560 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1569 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1575 = rsqrt(dot(float3(fragment_unnamed_1551, fragment_unnamed_1560, fragment_unnamed_1569), float3(fragment_unnamed_1551, fragment_unnamed_1560, fragment_unnamed_1569)));
				float fragment_unnamed_1576 = fragment_unnamed_1575 * fragment_unnamed_1551;
				float fragment_unnamed_1577 = fragment_unnamed_1575 * fragment_unnamed_1560;
				float fragment_unnamed_1578 = fragment_unnamed_1575 * fragment_unnamed_1569;
				float fragment_unnamed_1598 = ((-0.0f) - fragment_uniform_buffer_0[5u].x) + 1.0f;
				float fragment_unnamed_1599 = ((-0.0f) - fragment_uniform_buffer_0[5u].y) + 1.0f;
				float fragment_unnamed_1600 = ((-0.0f) - fragment_uniform_buffer_0[5u].z) + 1.0f;
				float fragment_unnamed_1612 = dot(float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1615 = mad(fragment_unnamed_1612, 0.25f, 1.0f);
				float fragment_unnamed_1617 = fragment_unnamed_1615 * (fragment_unnamed_1615 * fragment_unnamed_1615);
				float fragment_unnamed_1622 = exp2(log2(max(fragment_unnamed_1612, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1623 = fragment_unnamed_1622 + fragment_unnamed_1622;
				float fragment_unnamed_1634 = asfloat((0.5f < fragment_unnamed_1622) ? asuint(mad(log2(mad(log2(fragment_unnamed_1623), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1623)) * 0.5f;
				float fragment_unnamed_1640 = dot(float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1782;
				float fragment_unnamed_1783;
				float fragment_unnamed_1784;
				if (1.0f >= fragment_unnamed_1640)
				{
					float fragment_unnamed_1661 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].x) + 1.0f), fragment_unnamed_1598, 1.0f);
					float fragment_unnamed_1662 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].y) + 1.0f), fragment_unnamed_1599, 1.0f);
					float fragment_unnamed_1663 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].z) + 1.0f), fragment_unnamed_1600, 1.0f);
					float fragment_unnamed_1679 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].x) + 1.0f), fragment_unnamed_1598, 1.0f);
					float fragment_unnamed_1680 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].y) + 1.0f), fragment_unnamed_1599, 1.0f);
					float fragment_unnamed_1681 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].z) + 1.0f), fragment_unnamed_1600, 1.0f);
					float fragment_unnamed_1710 = clamp((fragment_unnamed_1640 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1711 = clamp((fragment_unnamed_1640 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1712 = clamp((fragment_unnamed_1640 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1713 = clamp((fragment_unnamed_1640 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1736 = 0.20000000298023223876953125f < fragment_unnamed_1640;
					bool fragment_unnamed_1737 = 0.100000001490116119384765625f < fragment_unnamed_1640;
					bool fragment_unnamed_1738 = (-0.100000001490116119384765625f) < fragment_unnamed_1640;
					float fragment_unnamed_1739 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].x) + 1.0f), fragment_unnamed_1598, 1.0f) * 1.5f;
					float fragment_unnamed_1741 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].y) + 1.0f), fragment_unnamed_1599, 1.0f) * 1.5f;
					float fragment_unnamed_1742 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].z) + 1.0f), fragment_unnamed_1600, 1.0f) * 1.5f;
					fragment_unnamed_1782 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1661) + 1.0f, fragment_unnamed_1661)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1679, 1.25f, fragment_unnamed_1661), fragment_unnamed_1679 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1679, 1.25f, (-0.0f) - fragment_unnamed_1739), fragment_unnamed_1739)) : asuint(fragment_unnamed_1739 * fragment_unnamed_1713))));
					fragment_unnamed_1783 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1662) + 1.0f, fragment_unnamed_1662)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1680, 1.25f, fragment_unnamed_1662), fragment_unnamed_1680 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1680, 1.25f, (-0.0f) - fragment_unnamed_1741), fragment_unnamed_1741)) : asuint(fragment_unnamed_1741 * fragment_unnamed_1713))));
					fragment_unnamed_1784 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1663) + 1.0f, fragment_unnamed_1663)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1681, 1.25f, fragment_unnamed_1663), fragment_unnamed_1681 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1681, 1.25f, (-0.0f) - fragment_unnamed_1742), fragment_unnamed_1742)) : asuint(fragment_unnamed_1742 * fragment_unnamed_1713))));
				}
				else
				{
					fragment_unnamed_1782 = asfloat(1065353216u);
					fragment_unnamed_1783 = asfloat(1065353216u);
					fragment_unnamed_1784 = asfloat(1065353216u);
				}
				float fragment_unnamed_1792 = clamp(fragment_unnamed_1640 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1796 = mad(clamp(fragment_unnamed_1640 * 0.1500000059604644775390625f, 0.0f, 1.0f), ((-0.0f) - fragment_unnamed_1544) + 1.0f, fragment_unnamed_1544) * 0.800000011920928955078125f;
				float fragment_unnamed_1808 = min(max((((-0.0f) - fragment_uniform_buffer_0[11u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1817 = mad(clamp(mad(log2(fragment_uniform_buffer_0[11u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1833 = mad(exp2(log2(fragment_uniform_buffer_0[6u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1836 = mad(exp2(log2(fragment_uniform_buffer_0[6u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1837 = mad(exp2(log2(fragment_uniform_buffer_0[6u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1868 = mad(exp2(log2(fragment_uniform_buffer_0[7u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1869 = mad(exp2(log2(fragment_uniform_buffer_0[7u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1870 = mad(exp2(log2(fragment_uniform_buffer_0[7u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1880 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1868) + 0.0240000002086162567138671875f, fragment_unnamed_1868);
				float fragment_unnamed_1881 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1869) + 0.0240000002086162567138671875f, fragment_unnamed_1869);
				float fragment_unnamed_1882 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1870) + 0.0240000002086162567138671875f, fragment_unnamed_1870);
				float fragment_unnamed_1897 = mad(exp2(log2(fragment_uniform_buffer_0[8u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1898 = mad(exp2(log2(fragment_uniform_buffer_0[8u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1899 = mad(exp2(log2(fragment_uniform_buffer_0[8u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1912 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1897, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1897);
				float fragment_unnamed_1913 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1898, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1898);
				float fragment_unnamed_1914 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1899, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1899);
				float fragment_unnamed_1915 = dot(float3(fragment_unnamed_1880, fragment_unnamed_1881, fragment_unnamed_1882), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1924 = mad(((-0.0f) - fragment_unnamed_1880) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1880);
				float fragment_unnamed_1925 = mad(((-0.0f) - fragment_unnamed_1881) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1881);
				float fragment_unnamed_1926 = mad(((-0.0f) - fragment_unnamed_1882) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1882);
				float fragment_unnamed_1927 = dot(float3(fragment_unnamed_1912, fragment_unnamed_1913, fragment_unnamed_1914), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1936 = mad(((-0.0f) - fragment_unnamed_1912) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1912);
				float fragment_unnamed_1937 = mad(((-0.0f) - fragment_unnamed_1913) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1913);
				float fragment_unnamed_1938 = mad(((-0.0f) - fragment_unnamed_1914) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1914);
				bool fragment_unnamed_1939 = 0.0f < fragment_unnamed_1640;
				float fragment_unnamed_1952 = clamp(mad(fragment_unnamed_1640, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1953 = clamp(mad(fragment_unnamed_1640, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1977 = clamp(mad(dot(float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1981 = asfloat(asuint(fragment_uniform_buffer_0[10u]).x) + 1.0f;
				float fragment_unnamed_1988 = dot(float3((-0.0f) - fragment_unnamed_1257, (-0.0f) - fragment_unnamed_1258, (-0.0f) - fragment_unnamed_1259), float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578));
				float fragment_unnamed_1992 = (-0.0f) - (fragment_unnamed_1988 + fragment_unnamed_1988);
				float fragment_unnamed_1996 = mad(fragment_unnamed_1576, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1257);
				float fragment_unnamed_1997 = mad(fragment_unnamed_1577, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1258);
				float fragment_unnamed_1998 = mad(fragment_unnamed_1578, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1259);
				uint fragment_unnamed_2013 = (fragment_uniform_buffer_0[25u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_2028 = sqrt(dot(float3(fragment_uniform_buffer_0[25u].xyz), float3(fragment_uniform_buffer_0[25u].xyz))) + (-5.0f);
				float fragment_unnamed_2044 = clamp(dot(float3((-0.0f) - fragment_unnamed_1169, (-0.0f) - fragment_unnamed_1170, (-0.0f) - fragment_unnamed_1171), float3(fragment_uniform_buffer_0[12u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_2028, 0.0f, 1.0f);
				float fragment_unnamed_2053 = mad((-0.0f) - fragment_unnamed_1169, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].x);
				float fragment_unnamed_2054 = mad((-0.0f) - fragment_unnamed_1170, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].y);
				float fragment_unnamed_2055 = mad((-0.0f) - fragment_unnamed_1171, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].z);
				float fragment_unnamed_2059 = sqrt(dot(float3(fragment_unnamed_2053, fragment_unnamed_2054, fragment_unnamed_2055), float3(fragment_unnamed_2053, fragment_unnamed_2054, fragment_unnamed_2055)));
				float fragment_unnamed_2065 = max((((-0.0f) - fragment_unnamed_2059) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_2067 = fragment_unnamed_2059 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_2082 = fragment_unnamed_2044 * ((fragment_unnamed_2065 * fragment_unnamed_2065) * clamp(dot(float3(fragment_unnamed_2053 / fragment_unnamed_2059, fragment_unnamed_2054 / fragment_unnamed_2059, fragment_unnamed_2055 / fragment_unnamed_2059), float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578)), 0.0f, 1.0f));
				float fragment_unnamed_2101 = clamp(fragment_unnamed_1221 * mad(fragment_unnamed_861.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_937) + 1.0f, fragment_unnamed_937), 0.0f, 1.0f);
				float fragment_unnamed_2107 = exp2(log2(fragment_unnamed_1953 * max(dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_uniform_buffer_0[12u].xyz)), 0.0f)) * exp2(fragment_unnamed_2101 * 6.906890392303466796875f));
				uint fragment_unnamed_2124 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171))) ? 4294967295u : 0u;
				float fragment_unnamed_2132 = mad(fragment_unnamed_1169, 1.0f, (-0.0f) - (fragment_unnamed_1170 * 0.0f));
				float fragment_unnamed_2133 = mad(fragment_unnamed_1170, 0.0f, (-0.0f) - (fragment_unnamed_1171 * 1.0f));
				float fragment_unnamed_2138 = rsqrt(dot(float2(fragment_unnamed_2132, fragment_unnamed_2133), float2(fragment_unnamed_2132, fragment_unnamed_2133)));
				bool fragment_unnamed_2142 = (fragment_unnamed_2124 & ((fragment_unnamed_1170 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2147 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * fragment_unnamed_2132) : 0u);
				float fragment_unnamed_2149 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * fragment_unnamed_2133) : 1065353216u);
				float fragment_unnamed_2151 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * mad(fragment_unnamed_1171, 0.0f, (-0.0f) - (fragment_unnamed_1169 * 0.0f))) : 0u);
				float fragment_unnamed_2164 = mad(fragment_unnamed_2151, fragment_unnamed_1171, (-0.0f) - (fragment_unnamed_1170 * fragment_unnamed_2147));
				float fragment_unnamed_2165 = mad(fragment_unnamed_2147, fragment_unnamed_1169, (-0.0f) - (fragment_unnamed_1171 * fragment_unnamed_2149));
				float fragment_unnamed_2166 = mad(fragment_unnamed_2149, fragment_unnamed_1170, (-0.0f) - (fragment_unnamed_1169 * fragment_unnamed_2151));
				float fragment_unnamed_2170 = rsqrt(dot(float3(fragment_unnamed_2164, fragment_unnamed_2165, fragment_unnamed_2166), float3(fragment_unnamed_2164, fragment_unnamed_2165, fragment_unnamed_2166)));
				bool fragment_unnamed_2182 = (fragment_unnamed_2124 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2147, fragment_unnamed_2149), float2(fragment_unnamed_2147, fragment_unnamed_2149))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2200 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1998, fragment_unnamed_1996), float2((-0.0f) - fragment_unnamed_2147, (-0.0f) - fragment_unnamed_2149)), dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171)), dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2164)) : (-0.0f), fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2165)) : (-0.0f), fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2166)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2101) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2219 = mad(fragment_unnamed_1953, ((-0.0f) - fragment_uniform_buffer_0[9u].y) + fragment_uniform_buffer_0[9u].x, fragment_uniform_buffer_0[9u].y);
				float fragment_unnamed_2223 = dot(float3(fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.x), fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.y), fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2244 = fragment_unnamed_2223 + mad(fragment_unnamed_1214, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 1.2999999523162841796875f) : asuint(fragment_unnamed_2082 * 1.2999999523162841796875f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1598, 1.0f) * fragment_unnamed_1782), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1833, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1833) + ((-0.0f) - fragment_unnamed_1924), fragment_unnamed_1924)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1924 + ((-0.0f) - fragment_unnamed_1936), fragment_unnamed_1936)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].x), fragment_uniform_buffer_0[4u].x)) * fragment_unnamed_2107)) * 0.5f);
				float fragment_unnamed_2245 = fragment_unnamed_2223 + mad(fragment_unnamed_1215, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 1.10000002384185791015625f) : asuint(fragment_unnamed_2082 * 1.10000002384185791015625f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1599, 1.0f) * fragment_unnamed_1783), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1836, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1836) + ((-0.0f) - fragment_unnamed_1925), fragment_unnamed_1925)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1925 + ((-0.0f) - fragment_unnamed_1937), fragment_unnamed_1937)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].y), fragment_uniform_buffer_0[4u].y)) * fragment_unnamed_2107)) * 0.5f);
				float fragment_unnamed_2246 = fragment_unnamed_2223 + mad(fragment_unnamed_1216, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 0.60000002384185791015625f) : asuint(fragment_unnamed_2082 * 0.60000002384185791015625f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1600, 1.0f) * fragment_unnamed_1784), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1837, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1837) + ((-0.0f) - fragment_unnamed_1926), fragment_unnamed_1926)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1926 + ((-0.0f) - fragment_unnamed_1938), fragment_unnamed_1938)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].z), fragment_uniform_buffer_0[4u].z)) * fragment_unnamed_2107)) * 0.5f);
				fragment_output_0.x = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_843) + fragment_unnamed_849, fragment_unnamed_843)) + mad(fragment_unnamed_1214, fragment_input_11.x, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1064) + fragment_unnamed_2244, fragment_unnamed_1064));
				fragment_output_0.y = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_845) + fragment_unnamed_851, fragment_unnamed_845)) + mad(fragment_unnamed_1215, fragment_input_11.y, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1065) + fragment_unnamed_2245, fragment_unnamed_1065));
				fragment_output_0.z = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_847) + fragment_unnamed_853, fragment_unnamed_847)) + mad(fragment_unnamed_1216, fragment_input_11.z, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1066) + fragment_unnamed_2246, fragment_unnamed_1066));
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[2] = float4(_LightColor0[0], _LightColor0[1], _LightColor0[2], _LightColor0[3]);

				fragment_uniform_buffer_0[4] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[5] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[6] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[7] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[8] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[9] = float4(_GIStrengthDay, fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], _GIStrengthNight, fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], _Multiplier);

				fragment_uniform_buffer_0[10] = float4(_AmbientInc, fragment_uniform_buffer_0[10][1], fragment_uniform_buffer_0[10][2], fragment_uniform_buffer_0[10][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], fragment_uniform_buffer_0[11][1], _Distance, fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[12] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[12][3]);

				fragment_uniform_buffer_0[13] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[15][1], fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[17] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[18] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[25] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[24] = float4(_LightShadowData[0], _LightShadowData[1], _LightShadowData[2], _LightShadowData[3]);

				fragment_uniform_buffer_3[25] = float4(unity_ShadowFadeCenterAndType[0], unity_ShadowFadeCenterAndType[1], unity_ShadowFadeCenterAndType[2], unity_ShadowFadeCenterAndType[3]);

				fragment_uniform_buffer_4[9] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
				fragment_uniform_buffer_4[10] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
				fragment_uniform_buffer_4[11] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
				fragment_uniform_buffer_4[12] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);

				fragment_uniform_buffer_5[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_5[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_5[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_5[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_5[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_5[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_5[5][3]);

				fragment_uniform_buffer_5[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_5[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // SHADOWS_SCREEN
			#endif // !LIGHTPROBE_SH


			#ifdef DIRECTIONAL
			#ifdef LIGHTPROBE_SH
			#ifdef SHADOWS_SCREEN
			#define ANY_SHADER_VARIANT_ACTIVE

			float4 _LightColor0;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 _LightShadowData;
			float4 unity_ShadowFadeCenterAndType;
			float4x4 unity_MatrixV;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[26];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[26];
			static float4 fragment_uniform_buffer_4[13];
			static float4 fragment_uniform_buffer_5[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _EmissionTex1;
			SamplerState sampler_EmissionTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _EmissionTex2;
			SamplerState sampler_EmissionTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _EmissionTex3;
			SamplerState sampler_EmissionTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _ShadowMapTexture;
			SamplerState sampler_ShadowMapTexture;
			Texture2D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float4 fragment_input_1;
			static float4 fragment_input_2;
			static float4 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float4 fragment_input_9;
			static float3 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float4 fragment_input_1 : TEXCOORD; // TEXCOORD
				float4 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float4 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float4 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float3 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD12; // TEXCOORD_12
				float4 fragment_input_13 : TEXCOORD13; // TEXCOORD_13
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2287)
			{
				if (fragment_unnamed_2287)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_146 = rsqrt(dot(float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z), float3(fragment_input_4.x, fragment_input_4.y, fragment_input_4.z)));
				float fragment_unnamed_153 = fragment_unnamed_146 * fragment_input_4.y;
				float fragment_unnamed_154 = fragment_unnamed_146 * fragment_input_4.x;
				float fragment_unnamed_155 = fragment_unnamed_146 * fragment_input_4.z;
				uint fragment_unnamed_164 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_170 = sqrt(((-0.0f) - abs(fragment_unnamed_153)) + 1.0f);
				float fragment_unnamed_179 = mad(mad(mad(abs(fragment_unnamed_153), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_153), -0.212114393711090087890625f), abs(fragment_unnamed_153), 1.570728778839111328125f);
				float fragment_unnamed_204 = (1.0f / max(abs(fragment_unnamed_155), abs(fragment_unnamed_154))) * min(abs(fragment_unnamed_155), abs(fragment_unnamed_154));
				float fragment_unnamed_205 = fragment_unnamed_204 * fragment_unnamed_204;
				float fragment_unnamed_213 = mad(fragment_unnamed_205, mad(fragment_unnamed_205, mad(fragment_unnamed_205, mad(fragment_unnamed_205, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_231 = asfloat(((((-0.0f) - fragment_unnamed_155) < fragment_unnamed_155) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_204, fragment_unnamed_213, asfloat(((abs(fragment_unnamed_155) < abs(fragment_unnamed_154)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_213 * fragment_unnamed_204, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_233 = min((-0.0f) - fragment_unnamed_155, fragment_unnamed_154);
				float fragment_unnamed_235 = max((-0.0f) - fragment_unnamed_155, fragment_unnamed_154);
				float fragment_unnamed_249 = (((-0.0f) - mad(fragment_unnamed_179, fragment_unnamed_170, asfloat(((fragment_unnamed_153 < ((-0.0f) - fragment_unnamed_153)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_170 * fragment_unnamed_179, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_250 = fragment_unnamed_249 * 0.3183098733425140380859375f;
				bool fragment_unnamed_252 = 0.0f < fragment_unnamed_249;
				float fragment_unnamed_259 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_250)) : asuint(floor(fragment_unnamed_250)));
				float fragment_unnamed_263 = float(fragment_unnamed_164);
				uint fragment_unnamed_271 = uint(asfloat((0.0f < fragment_unnamed_259) ? asuint(fragment_unnamed_259 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_259) + fragment_unnamed_263) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_273 = _OffsetsBuffer.Load(fragment_unnamed_271);
				uint fragment_unnamed_274 = fragment_unnamed_273.x;
				float fragment_unnamed_281 = float((-fragment_unnamed_274) + _OffsetsBuffer.Load(fragment_unnamed_271 + 1u).x);
				float fragment_unnamed_282 = mad(((((fragment_unnamed_235 >= ((-0.0f) - fragment_unnamed_235)) ? 4294967295u : 0u) & ((fragment_unnamed_233 < ((-0.0f) - fragment_unnamed_233)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_231) : fragment_unnamed_231, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_284 = fragment_unnamed_281 * fragment_unnamed_282;
				bool fragment_unnamed_285 = 0.0f < fragment_unnamed_284;
				float fragment_unnamed_291 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_284)) : asuint(floor(fragment_unnamed_284)));
				float fragment_unnamed_292 = mad(fragment_unnamed_281, 0.5f, 0.5f);
				float fragment_unnamed_308 = float(fragment_unnamed_274 + uint(asfloat((fragment_unnamed_292 < fragment_unnamed_291) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_291) + (-1.0f)) : asuint(fragment_unnamed_281 + ((-0.0f) - fragment_unnamed_291))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_311 = frac(fragment_unnamed_308);
				uint4 fragment_unnamed_313 = _DataBuffer.Load(uint(floor(fragment_unnamed_308)));
				uint fragment_unnamed_314 = fragment_unnamed_313.x;
				uint fragment_unnamed_326 = 16u & 31u;
				uint fragment_unnamed_333 = 8u & 31u;
				uint fragment_unnamed_341 = (0.625f < fragment_unnamed_311) ? (fragment_unnamed_314 >> 24u) : ((0.375f < fragment_unnamed_311) ? spvBitfieldUExtract(fragment_unnamed_314, fragment_unnamed_326, min((8u & 31u), (32u - fragment_unnamed_326))) : ((0.125f < fragment_unnamed_311) ? spvBitfieldUExtract(fragment_unnamed_314, fragment_unnamed_333, min((8u & 31u), (32u - fragment_unnamed_333))) : (fragment_unnamed_314 & 255u)));
				float fragment_unnamed_343 = float(fragment_unnamed_341 >> 5u);
				float fragment_unnamed_348 = asfloat((6.5f < fragment_unnamed_343) ? 0u : asuint(fragment_unnamed_343));
				float fragment_unnamed_355 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(fragment_unnamed_348 < (fragment_unnamed_355 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_355 + 3.9900000095367431640625f) < fragment_unnamed_348);
				float fragment_unnamed_374 = mad(fragment_unnamed_249, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_375 = mad(fragment_unnamed_249, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_386 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_374)) : asuint(floor(fragment_unnamed_374)));
				float fragment_unnamed_388 = asfloat(fragment_unnamed_252 ? asuint(ceil(fragment_unnamed_375)) : asuint(floor(fragment_unnamed_375)));
				uint fragment_unnamed_390 = uint(ceil(max(abs(fragment_unnamed_250) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_409 = uint(asfloat((0.0f < fragment_unnamed_386) ? asuint(fragment_unnamed_386 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_263 + ((-0.0f) - fragment_unnamed_386)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_410 = uint(asfloat((0.0f < fragment_unnamed_388) ? asuint(fragment_unnamed_388 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_263 + ((-0.0f) - fragment_unnamed_388)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_411 = _OffsetsBuffer.Load(fragment_unnamed_409);
				uint fragment_unnamed_412 = fragment_unnamed_411.x;
				uint4 fragment_unnamed_413 = _OffsetsBuffer.Load(fragment_unnamed_410);
				uint fragment_unnamed_414 = fragment_unnamed_413.x;
				uint fragment_unnamed_425 = (fragment_unnamed_271 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_428 = (fragment_unnamed_271 != (fragment_unnamed_164 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_431 = (fragment_unnamed_164 != fragment_unnamed_271) ? 4294967295u : 0u;
				uint fragment_unnamed_435 = (fragment_unnamed_271 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_451 = (fragment_unnamed_435 & (fragment_unnamed_431 & (fragment_unnamed_425 & fragment_unnamed_428))) != 0u;
				uint fragment_unnamed_454 = asuint(fragment_unnamed_281);
				uint fragment_unnamed_455 = fragment_unnamed_451 ? asuint(float((-fragment_unnamed_412) + _OffsetsBuffer.Load(fragment_unnamed_409 + 1u).x)) : fragment_unnamed_454;
				float fragment_unnamed_457 = asfloat(fragment_unnamed_451 ? asuint(float((-fragment_unnamed_414) + _OffsetsBuffer.Load(fragment_unnamed_410 + 1u).x)) : fragment_unnamed_454);
				float fragment_unnamed_460 = fragment_unnamed_282 * asfloat(fragment_unnamed_455);
				float fragment_unnamed_461 = fragment_unnamed_282 * fragment_unnamed_457;
				float fragment_unnamed_462 = mad(fragment_unnamed_282, fragment_unnamed_281, 0.5f);
				float fragment_unnamed_463 = mad(fragment_unnamed_282, fragment_unnamed_281, -0.5f);
				float fragment_unnamed_470 = asfloat((fragment_unnamed_281 < fragment_unnamed_462) ? asuint(((-0.0f) - fragment_unnamed_281) + fragment_unnamed_462) : asuint(fragment_unnamed_462));
				float fragment_unnamed_476 = asfloat((fragment_unnamed_463 < 0.0f) ? asuint(fragment_unnamed_281 + fragment_unnamed_463) : asuint(fragment_unnamed_463));
				float fragment_unnamed_486 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_460)) : asuint(floor(fragment_unnamed_460)));
				float fragment_unnamed_488 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_461)) : asuint(floor(fragment_unnamed_461)));
				float fragment_unnamed_494 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_470)) : asuint(floor(fragment_unnamed_470)));
				float fragment_unnamed_500 = asfloat(fragment_unnamed_285 ? asuint(ceil(fragment_unnamed_476)) : asuint(floor(fragment_unnamed_476)));
				float fragment_unnamed_501 = frac(fragment_unnamed_250);
				float fragment_unnamed_502 = frac(fragment_unnamed_284);
				float fragment_unnamed_503 = fragment_unnamed_501 + (-0.5f);
				float fragment_unnamed_512 = min((((-0.0f) - fragment_unnamed_502) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_514 = min(fragment_unnamed_502 * 40.0f, 1.0f);
				float fragment_unnamed_515 = min(fragment_unnamed_501 * 40.0f, 1.0f);
				float fragment_unnamed_574 = float(fragment_unnamed_412 + uint(asfloat((mad(asfloat(fragment_unnamed_455), 0.5f, 0.5f) < fragment_unnamed_486) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_455), 0.5f, fragment_unnamed_486) + (-1.0f)) : asuint(asfloat(fragment_unnamed_455) + ((-0.0f) - fragment_unnamed_486))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_576 = frac(fragment_unnamed_574);
				uint4 fragment_unnamed_578 = _DataBuffer.Load(uint(floor(fragment_unnamed_574)));
				uint fragment_unnamed_579 = fragment_unnamed_578.x;
				uint fragment_unnamed_585 = 16u & 31u;
				uint fragment_unnamed_590 = 8u & 31u;
				float fragment_unnamed_600 = float(uint(asfloat((mad(fragment_unnamed_457, 0.5f, 0.5f) < fragment_unnamed_488) ? asuint(mad((-0.0f) - fragment_unnamed_457, 0.5f, fragment_unnamed_488) + (-1.0f)) : asuint(fragment_unnamed_457 + ((-0.0f) - fragment_unnamed_488))) + 0.100000001490116119384765625f) + fragment_unnamed_414) * 0.25f;
				float fragment_unnamed_602 = frac(fragment_unnamed_600);
				uint4 fragment_unnamed_604 = _DataBuffer.Load(uint(floor(fragment_unnamed_600)));
				uint fragment_unnamed_605 = fragment_unnamed_604.x;
				uint fragment_unnamed_611 = 16u & 31u;
				uint fragment_unnamed_616 = 8u & 31u;
				float fragment_unnamed_626 = float(uint(asfloat((fragment_unnamed_292 < fragment_unnamed_494) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_494) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_494) + fragment_unnamed_281)) + 0.100000001490116119384765625f) + fragment_unnamed_274) * 0.25f;
				float fragment_unnamed_628 = frac(fragment_unnamed_626);
				uint4 fragment_unnamed_630 = _DataBuffer.Load(uint(floor(fragment_unnamed_626)));
				uint fragment_unnamed_631 = fragment_unnamed_630.x;
				uint fragment_unnamed_637 = 16u & 31u;
				uint fragment_unnamed_642 = 8u & 31u;
				float fragment_unnamed_652 = float(uint(asfloat((fragment_unnamed_292 < fragment_unnamed_500) ? asuint(mad((-0.0f) - fragment_unnamed_281, 0.5f, fragment_unnamed_500) + (-1.0f)) : asuint(fragment_unnamed_281 + ((-0.0f) - fragment_unnamed_500))) + 0.100000001490116119384765625f) + fragment_unnamed_274) * 0.25f;
				float fragment_unnamed_654 = frac(fragment_unnamed_652);
				uint4 fragment_unnamed_656 = _DataBuffer.Load(uint(floor(fragment_unnamed_652)));
				uint fragment_unnamed_657 = fragment_unnamed_656.x;
				uint fragment_unnamed_663 = 16u & 31u;
				uint fragment_unnamed_668 = 8u & 31u;
				float fragment_unnamed_678 = float(((0.625f < fragment_unnamed_602) ? (fragment_unnamed_605 >> 24u) : ((0.375f < fragment_unnamed_602) ? spvBitfieldUExtract(fragment_unnamed_605, fragment_unnamed_611, min((8u & 31u), (32u - fragment_unnamed_611))) : ((0.125f < fragment_unnamed_602) ? spvBitfieldUExtract(fragment_unnamed_605, fragment_unnamed_616, min((8u & 31u), (32u - fragment_unnamed_616))) : (fragment_unnamed_605 & 255u)))) >> 5u);
				float fragment_unnamed_680 = float(((0.625f < fragment_unnamed_628) ? (fragment_unnamed_631 >> 24u) : ((0.375f < fragment_unnamed_628) ? spvBitfieldUExtract(fragment_unnamed_631, fragment_unnamed_637, min((8u & 31u), (32u - fragment_unnamed_637))) : ((0.125f < fragment_unnamed_628) ? spvBitfieldUExtract(fragment_unnamed_631, fragment_unnamed_642, min((8u & 31u), (32u - fragment_unnamed_642))) : (fragment_unnamed_631 & 255u)))) >> 5u);
				float fragment_unnamed_682 = float(((0.625f < fragment_unnamed_654) ? (fragment_unnamed_657 >> 24u) : ((0.375f < fragment_unnamed_654) ? spvBitfieldUExtract(fragment_unnamed_657, fragment_unnamed_663, min((8u & 31u), (32u - fragment_unnamed_663))) : ((0.125f < fragment_unnamed_654) ? spvBitfieldUExtract(fragment_unnamed_657, fragment_unnamed_668, min((8u & 31u), (32u - fragment_unnamed_668))) : (fragment_unnamed_657 & 255u)))) >> 5u);
				float fragment_unnamed_683 = float(((0.625f < fragment_unnamed_576) ? (fragment_unnamed_579 >> 24u) : ((0.375f < fragment_unnamed_576) ? spvBitfieldUExtract(fragment_unnamed_579, fragment_unnamed_585, min((8u & 31u), (32u - fragment_unnamed_585))) : ((0.125f < fragment_unnamed_576) ? spvBitfieldUExtract(fragment_unnamed_579, fragment_unnamed_590, min((8u & 31u), (32u - fragment_unnamed_590))) : (fragment_unnamed_579 & 255u)))) >> 5u);
				float fragment_unnamed_694 = fragment_unnamed_284 * 0.20000000298023223876953125f;
				float fragment_unnamed_696 = fragment_unnamed_249 * 0.06366197764873504638671875f;
				float fragment_unnamed_698 = (fragment_unnamed_282 * float((-_OffsetsBuffer.Load(fragment_unnamed_390).x) + _OffsetsBuffer.Load(fragment_unnamed_390 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_705 = ddx_coarse(fragment_input_10.x);
				float fragment_unnamed_706 = ddx_coarse(fragment_input_10.y);
				float fragment_unnamed_707 = ddx_coarse(fragment_input_10.z);
				float fragment_unnamed_711 = sqrt(dot(float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707), float3(fragment_unnamed_705, fragment_unnamed_706, fragment_unnamed_707)));
				float fragment_unnamed_718 = ddy_coarse(fragment_input_10.x);
				float fragment_unnamed_719 = ddy_coarse(fragment_input_10.y);
				float fragment_unnamed_720 = ddy_coarse(fragment_input_10.z);
				float fragment_unnamed_724 = sqrt(dot(float3(fragment_unnamed_718, fragment_unnamed_719, fragment_unnamed_720), float3(fragment_unnamed_718, fragment_unnamed_719, fragment_unnamed_720)));
				float fragment_unnamed_735 = min(max(log2(sqrt(dot(float2(fragment_unnamed_711, fragment_unnamed_724), float2(fragment_unnamed_711, fragment_unnamed_724))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_737 = min((((-0.0f) - fragment_unnamed_501) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_815;
				float fragment_unnamed_817;
				float fragment_unnamed_819;
				float fragment_unnamed_821;
				float fragment_unnamed_823;
				float fragment_unnamed_825;
				float fragment_unnamed_827;
				float fragment_unnamed_829;
				float fragment_unnamed_831;
				float fragment_unnamed_833;
				float fragment_unnamed_835;
				float fragment_unnamed_837;
				float fragment_unnamed_839;
				float fragment_unnamed_841;
				float fragment_unnamed_843;
				float fragment_unnamed_845;
				float fragment_unnamed_847;
				float fragment_unnamed_849;
				float fragment_unnamed_851;
				float fragment_unnamed_853;
				if (((((fragment_unnamed_355 + 0.9900000095367431640625f) < fragment_unnamed_348) ? 4294967295u : 0u) & ((fragment_unnamed_348 < (fragment_unnamed_355 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_750 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float4 fragment_unnamed_756 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					float4 fragment_unnamed_763 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float fragment_unnamed_769 = mad(fragment_unnamed_763.w * fragment_unnamed_763.x, 2.0f, -1.0f);
					float fragment_unnamed_771 = mad(fragment_unnamed_763.y, 2.0f, -1.0f);
					float4 fragment_unnamed_779 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					float fragment_unnamed_785 = mad(fragment_unnamed_779.w * fragment_unnamed_779.x, 2.0f, -1.0f);
					float fragment_unnamed_786 = mad(fragment_unnamed_779.y, 2.0f, -1.0f);
					float4 fragment_unnamed_795 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
					float4 fragment_unnamed_800 = _EmissionTex1.SampleLevel(sampler_EmissionTex1, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
					fragment_unnamed_815 = fragment_unnamed_750.x;
					fragment_unnamed_817 = fragment_unnamed_750.y;
					fragment_unnamed_819 = fragment_unnamed_750.z;
					fragment_unnamed_821 = fragment_unnamed_756.x;
					fragment_unnamed_823 = fragment_unnamed_756.y;
					fragment_unnamed_825 = fragment_unnamed_756.z;
					fragment_unnamed_827 = fragment_unnamed_750.w;
					fragment_unnamed_829 = fragment_unnamed_756.w;
					fragment_unnamed_831 = fragment_unnamed_769;
					fragment_unnamed_833 = fragment_unnamed_771;
					fragment_unnamed_835 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_769, fragment_unnamed_771), float2(fragment_unnamed_769, fragment_unnamed_771)), 1.0f)) + 1.0f);
					fragment_unnamed_837 = fragment_unnamed_785;
					fragment_unnamed_839 = fragment_unnamed_786;
					fragment_unnamed_841 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_785, fragment_unnamed_786), float2(fragment_unnamed_785, fragment_unnamed_786)), 1.0f)) + 1.0f);
					fragment_unnamed_843 = fragment_unnamed_795.x;
					fragment_unnamed_845 = fragment_unnamed_795.y;
					fragment_unnamed_847 = fragment_unnamed_795.z;
					fragment_unnamed_849 = fragment_unnamed_800.x;
					fragment_unnamed_851 = fragment_unnamed_800.y;
					fragment_unnamed_853 = fragment_unnamed_800.z;
				}
				else
				{
					float fragment_unnamed_816;
					float fragment_unnamed_818;
					float fragment_unnamed_820;
					float fragment_unnamed_822;
					float fragment_unnamed_824;
					float fragment_unnamed_826;
					float fragment_unnamed_828;
					float fragment_unnamed_830;
					float fragment_unnamed_832;
					float fragment_unnamed_834;
					float fragment_unnamed_836;
					float fragment_unnamed_838;
					float fragment_unnamed_840;
					float fragment_unnamed_842;
					float fragment_unnamed_844;
					float fragment_unnamed_846;
					float fragment_unnamed_848;
					float fragment_unnamed_850;
					float fragment_unnamed_852;
					float fragment_unnamed_854;
					if (((((fragment_unnamed_355 + 1.9900000095367431640625f) < fragment_unnamed_348) ? 4294967295u : 0u) & ((fragment_unnamed_348 < (fragment_unnamed_355 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1313 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1319 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float4 fragment_unnamed_1326 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float fragment_unnamed_1332 = mad(fragment_unnamed_1326.w * fragment_unnamed_1326.x, 2.0f, -1.0f);
						float fragment_unnamed_1333 = mad(fragment_unnamed_1326.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1341 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float fragment_unnamed_1347 = mad(fragment_unnamed_1341.w * fragment_unnamed_1341.x, 2.0f, -1.0f);
						float fragment_unnamed_1348 = mad(fragment_unnamed_1341.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1357 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1362 = _EmissionTex2.SampleLevel(sampler_EmissionTex2, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						fragment_unnamed_816 = fragment_unnamed_1313.x;
						fragment_unnamed_818 = fragment_unnamed_1313.y;
						fragment_unnamed_820 = fragment_unnamed_1313.z;
						fragment_unnamed_822 = fragment_unnamed_1319.x;
						fragment_unnamed_824 = fragment_unnamed_1319.y;
						fragment_unnamed_826 = fragment_unnamed_1319.z;
						fragment_unnamed_828 = fragment_unnamed_1313.w;
						fragment_unnamed_830 = fragment_unnamed_1319.w;
						fragment_unnamed_832 = fragment_unnamed_1332;
						fragment_unnamed_834 = fragment_unnamed_1333;
						fragment_unnamed_836 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1332, fragment_unnamed_1333), float2(fragment_unnamed_1332, fragment_unnamed_1333)), 1.0f)) + 1.0f);
						fragment_unnamed_838 = fragment_unnamed_1347;
						fragment_unnamed_840 = fragment_unnamed_1348;
						fragment_unnamed_842 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1347, fragment_unnamed_1348), float2(fragment_unnamed_1347, fragment_unnamed_1348)), 1.0f)) + 1.0f);
						fragment_unnamed_844 = fragment_unnamed_1357.x;
						fragment_unnamed_846 = fragment_unnamed_1357.y;
						fragment_unnamed_848 = fragment_unnamed_1357.z;
						fragment_unnamed_850 = fragment_unnamed_1362.x;
						fragment_unnamed_852 = fragment_unnamed_1362.y;
						fragment_unnamed_854 = fragment_unnamed_1362.z;
					}
					else
					{
						float4 fragment_unnamed_1368 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1374 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float4 fragment_unnamed_1381 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float fragment_unnamed_1387 = mad(fragment_unnamed_1381.w * fragment_unnamed_1381.x, 2.0f, -1.0f);
						float fragment_unnamed_1388 = mad(fragment_unnamed_1381.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1396 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						float fragment_unnamed_1402 = mad(fragment_unnamed_1396.w * fragment_unnamed_1396.x, 2.0f, -1.0f);
						float fragment_unnamed_1403 = mad(fragment_unnamed_1396.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1412 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_696, fragment_unnamed_694), fragment_unnamed_735);
						float4 fragment_unnamed_1417 = _EmissionTex3.SampleLevel(sampler_EmissionTex3, float2(fragment_unnamed_696, fragment_unnamed_698), fragment_unnamed_735);
						fragment_unnamed_816 = fragment_unnamed_1368.x;
						fragment_unnamed_818 = fragment_unnamed_1368.y;
						fragment_unnamed_820 = fragment_unnamed_1368.z;
						fragment_unnamed_822 = fragment_unnamed_1374.x;
						fragment_unnamed_824 = fragment_unnamed_1374.y;
						fragment_unnamed_826 = fragment_unnamed_1374.z;
						fragment_unnamed_828 = fragment_unnamed_1368.w;
						fragment_unnamed_830 = fragment_unnamed_1374.w;
						fragment_unnamed_832 = fragment_unnamed_1387;
						fragment_unnamed_834 = fragment_unnamed_1388;
						fragment_unnamed_836 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1387, fragment_unnamed_1388), float2(fragment_unnamed_1387, fragment_unnamed_1388)), 1.0f)) + 1.0f);
						fragment_unnamed_838 = fragment_unnamed_1402;
						fragment_unnamed_840 = fragment_unnamed_1403;
						fragment_unnamed_842 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1402, fragment_unnamed_1403), float2(fragment_unnamed_1402, fragment_unnamed_1403)), 1.0f)) + 1.0f);
						fragment_unnamed_844 = fragment_unnamed_1412.x;
						fragment_unnamed_846 = fragment_unnamed_1412.y;
						fragment_unnamed_848 = fragment_unnamed_1412.z;
						fragment_unnamed_850 = fragment_unnamed_1417.x;
						fragment_unnamed_852 = fragment_unnamed_1417.y;
						fragment_unnamed_854 = fragment_unnamed_1417.z;
					}
					fragment_unnamed_815 = fragment_unnamed_816;
					fragment_unnamed_817 = fragment_unnamed_818;
					fragment_unnamed_819 = fragment_unnamed_820;
					fragment_unnamed_821 = fragment_unnamed_822;
					fragment_unnamed_823 = fragment_unnamed_824;
					fragment_unnamed_825 = fragment_unnamed_826;
					fragment_unnamed_827 = fragment_unnamed_828;
					fragment_unnamed_829 = fragment_unnamed_830;
					fragment_unnamed_831 = fragment_unnamed_832;
					fragment_unnamed_833 = fragment_unnamed_834;
					fragment_unnamed_835 = fragment_unnamed_836;
					fragment_unnamed_837 = fragment_unnamed_838;
					fragment_unnamed_839 = fragment_unnamed_840;
					fragment_unnamed_841 = fragment_unnamed_842;
					fragment_unnamed_843 = fragment_unnamed_844;
					fragment_unnamed_845 = fragment_unnamed_846;
					fragment_unnamed_847 = fragment_unnamed_848;
					fragment_unnamed_849 = fragment_unnamed_850;
					fragment_unnamed_851 = fragment_unnamed_852;
					fragment_unnamed_853 = fragment_unnamed_854;
				}
				float4 fragment_unnamed_861 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_341 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_869 = fragment_unnamed_861.w * 0.800000011920928955078125f;
				float fragment_unnamed_871 = mad(fragment_unnamed_861.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_879 = exp2(log2(abs(fragment_unnamed_503) + abs(fragment_unnamed_503)) * 10.0f);
				float fragment_unnamed_898 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_833) + fragment_unnamed_839, fragment_unnamed_833);
				float fragment_unnamed_899 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_831) + fragment_unnamed_837, fragment_unnamed_831);
				float fragment_unnamed_900 = mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_835) + fragment_unnamed_841, fragment_unnamed_835);
				float fragment_unnamed_910 = (fragment_unnamed_871 * fragment_unnamed_861.x) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_815) + fragment_unnamed_821, fragment_unnamed_815);
				float fragment_unnamed_911 = (fragment_unnamed_871 * fragment_unnamed_861.y) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_817) + fragment_unnamed_823, fragment_unnamed_817);
				float fragment_unnamed_912 = (fragment_unnamed_871 * fragment_unnamed_861.z) * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_819) + fragment_unnamed_825, fragment_unnamed_819);
				float fragment_unnamed_919 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_unnamed_910), fragment_unnamed_910);
				float fragment_unnamed_920 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_unnamed_911), fragment_unnamed_911);
				float fragment_unnamed_921 = mad(fragment_unnamed_861.w, mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_unnamed_912), fragment_unnamed_912);
				float fragment_unnamed_923 = ((-0.0f) - mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_827) + fragment_unnamed_829, fragment_unnamed_827)) + 1.0f;
				float fragment_unnamed_928 = fragment_unnamed_923 * fragment_uniform_buffer_0[4u].w;
				float fragment_unnamed_937 = mad(fragment_unnamed_861.w, mad((-0.0f) - fragment_unnamed_923, fragment_uniform_buffer_0[4u].w, clamp(fragment_unnamed_928 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_928);
				bool fragment_unnamed_971 = (fragment_unnamed_428 & (fragment_unnamed_431 & (((fragment_unnamed_683 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_683) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_979 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_919) : asuint(fragment_unnamed_919);
				uint fragment_unnamed_981 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_920) : asuint(fragment_unnamed_920);
				uint fragment_unnamed_983 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * fragment_unnamed_921) : asuint(fragment_unnamed_921);
				uint fragment_unnamed_985 = fragment_unnamed_971 ? asuint(fragment_unnamed_737 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_996 = (fragment_unnamed_435 & (fragment_unnamed_425 & (((fragment_unnamed_678 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_678) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_1001 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_979)) : fragment_unnamed_979;
				uint fragment_unnamed_1003 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_981)) : fragment_unnamed_981;
				uint fragment_unnamed_1005 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_983)) : fragment_unnamed_983;
				uint fragment_unnamed_1007 = fragment_unnamed_996 ? asuint(fragment_unnamed_515 * asfloat(fragment_unnamed_985)) : fragment_unnamed_985;
				bool fragment_unnamed_1016 = (((fragment_unnamed_680 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_680) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_1021 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1001)) : fragment_unnamed_1001;
				uint fragment_unnamed_1023 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1003)) : fragment_unnamed_1003;
				uint fragment_unnamed_1025 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1005)) : fragment_unnamed_1005;
				uint fragment_unnamed_1027 = fragment_unnamed_1016 ? asuint(fragment_unnamed_512 * asfloat(fragment_unnamed_1007)) : fragment_unnamed_1007;
				bool fragment_unnamed_1036 = (((fragment_unnamed_682 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_682) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_1042 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1027)) : fragment_unnamed_1027);
				discard_cond((fragment_unnamed_1042 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1062 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_9.x / fragment_input_9.w, fragment_input_9.y / fragment_input_9.w));
				float fragment_unnamed_1064 = fragment_unnamed_1062.x;
				float fragment_unnamed_1065 = fragment_unnamed_1062.y;
				float fragment_unnamed_1066 = fragment_unnamed_1062.z;
				float fragment_unnamed_1071 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1021)) : fragment_unnamed_1021) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1072 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1023)) : fragment_unnamed_1023) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1073 = asfloat(fragment_unnamed_1036 ? asuint(fragment_unnamed_514 * asfloat(fragment_unnamed_1025)) : fragment_unnamed_1025) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1085 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1086 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1087 = fragment_uniform_buffer_0[13u].x + fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1088 = fragment_uniform_buffer_0[13u].y + fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1094 = fragment_unnamed_1087 * fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1095 = fragment_unnamed_1088 * fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1096 = fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1104 = fragment_unnamed_1087 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1105 = fragment_unnamed_1088 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1109 = fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1140 = mad(fragment_unnamed_1105 + (fragment_unnamed_1085 * fragment_uniform_buffer_0[13u].x), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1088, (-0.0f) - fragment_unnamed_1109), fragment_input_4.y, (((-0.0f) - (fragment_unnamed_1096 + fragment_unnamed_1095)) + 1.0f) * fragment_input_4.x));
				float fragment_unnamed_1158 = mad(mad(fragment_uniform_buffer_0[13u].y, fragment_unnamed_1086, (-0.0f) - fragment_unnamed_1104), fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1088, fragment_unnamed_1109), fragment_input_4.x, (((-0.0f) - (fragment_unnamed_1096 + fragment_unnamed_1094)) + 1.0f) * fragment_input_4.y));
				float fragment_unnamed_1164 = mad(((-0.0f) - (fragment_unnamed_1095 + fragment_unnamed_1094)) + 1.0f, fragment_input_4.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1085, (-0.0f) - fragment_unnamed_1105), fragment_input_4.x, (fragment_unnamed_1104 + (fragment_unnamed_1086 * fragment_uniform_buffer_0[13u].y)) * fragment_input_4.y));
				float fragment_unnamed_1168 = rsqrt(dot(float3(fragment_unnamed_1140, fragment_unnamed_1158, fragment_unnamed_1164), float3(fragment_unnamed_1140, fragment_unnamed_1158, fragment_unnamed_1164)));
				float fragment_unnamed_1169 = fragment_unnamed_1168 * fragment_unnamed_1140;
				float fragment_unnamed_1170 = fragment_unnamed_1168 * fragment_unnamed_1158;
				float fragment_unnamed_1171 = fragment_unnamed_1168 * fragment_unnamed_1164;
				float fragment_unnamed_1178 = mad(mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1071), 0.5f, fragment_unnamed_1071);
				float fragment_unnamed_1179 = mad(mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1072), 0.5f, fragment_unnamed_1072);
				float fragment_unnamed_1180 = mad(mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_unnamed_1073), 0.5f, fragment_unnamed_1073);
				float fragment_unnamed_1181 = dot(float3(fragment_unnamed_1178, fragment_unnamed_1179, fragment_unnamed_1180), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1187 = mad(((-0.0f) - fragment_unnamed_1181) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1181);
				float fragment_unnamed_1193 = (-0.0f) - fragment_unnamed_1187;
				float fragment_unnamed_1214 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 0.7200000286102294921875f, fragment_unnamed_1178), 0.14000000059604644775390625f, fragment_unnamed_1187 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1071), fragment_unnamed_1071);
				float fragment_unnamed_1215 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 0.85000002384185791015625f, fragment_unnamed_1179), 0.14000000059604644775390625f, fragment_unnamed_1187 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1072), fragment_unnamed_1072);
				float fragment_unnamed_1216 = mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1193, 1.0f, fragment_unnamed_1180), 0.14000000059604644775390625f, fragment_unnamed_1187 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1073), fragment_unnamed_1073);
				float fragment_unnamed_1221 = mad((-0.0f) - fragment_uniform_buffer_0[15u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1250 = ((-0.0f) - fragment_input_1.w) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1251 = ((-0.0f) - fragment_input_2.w) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1252 = ((-0.0f) - fragment_input_3.w) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1256 = rsqrt(dot(float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252), float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252)));
				float fragment_unnamed_1257 = fragment_unnamed_1256 * fragment_unnamed_1250;
				float fragment_unnamed_1258 = fragment_unnamed_1256 * fragment_unnamed_1251;
				float fragment_unnamed_1259 = fragment_unnamed_1256 * fragment_unnamed_1252;
				float fragment_unnamed_1275 = dot(float3(fragment_unnamed_1250, fragment_unnamed_1251, fragment_unnamed_1252), float3(asfloat(asuint(fragment_uniform_buffer_4[9u]).z), asfloat(asuint(fragment_uniform_buffer_4[10u]).z), asfloat(asuint(fragment_uniform_buffer_4[11u]).z)));
				float fragment_unnamed_1287 = fragment_input_1.w + ((-0.0f) - fragment_uniform_buffer_3[25u].x);
				float fragment_unnamed_1288 = fragment_input_2.w + ((-0.0f) - fragment_uniform_buffer_3[25u].y);
				float fragment_unnamed_1289 = fragment_input_3.w + ((-0.0f) - fragment_uniform_buffer_3[25u].z);
				float fragment_unnamed_1515;
				float fragment_unnamed_1516;
				float fragment_unnamed_1517;
				float fragment_unnamed_1518;
				if (fragment_uniform_buffer_5[0u].x == 1.0f)
				{
					bool fragment_unnamed_1425 = fragment_uniform_buffer_5[0u].y == 1.0f;
					float4 fragment_unnamed_1505 = _ShadowMapTexture.Sample(sampler_ShadowMapTexture, float3(max(mad((asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].x, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].x, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].x)) + fragment_uniform_buffer_5[4u].x) : asuint(fragment_input_1.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].x)) * fragment_uniform_buffer_5[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_5[0u].z, 0.5f, 0.75f)), (asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].y, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].y, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].y)) + fragment_uniform_buffer_5[4u].y) : asuint(fragment_input_2.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].y)) * fragment_uniform_buffer_5[5u].y, (asfloat(fragment_unnamed_1425 ? asuint(mad(fragment_uniform_buffer_5[3u].z, fragment_input_3.w, mad(fragment_uniform_buffer_5[1u].z, fragment_input_1.w, fragment_input_2.w * fragment_uniform_buffer_5[2u].z)) + fragment_uniform_buffer_5[4u].z) : asuint(fragment_input_3.w)) + ((-0.0f) - fragment_uniform_buffer_5[6u].z)) * fragment_uniform_buffer_5[5u].z));
					fragment_unnamed_1515 = fragment_unnamed_1505.x;
					fragment_unnamed_1516 = fragment_unnamed_1505.y;
					fragment_unnamed_1517 = fragment_unnamed_1505.z;
					fragment_unnamed_1518 = fragment_unnamed_1505.w;
				}
				else
				{
					fragment_unnamed_1515 = asfloat(1065353216u);
					fragment_unnamed_1516 = asfloat(1065353216u);
					fragment_unnamed_1517 = asfloat(1065353216u);
					fragment_unnamed_1518 = asfloat(1065353216u);
				}
				float4 fragment_unnamed_1539 = _Global_PGI.Sample(sampler_Global_PGI, float2(fragment_input_12.x / fragment_input_12.w, fragment_input_12.y / fragment_input_12.w));
				float fragment_unnamed_1541 = fragment_unnamed_1539.x;
				float fragment_unnamed_1544 = mad(clamp(mad(mad(fragment_uniform_buffer_3[25u].w, ((-0.0f) - fragment_unnamed_1275) + sqrt(dot(float3(fragment_unnamed_1287, fragment_unnamed_1288, fragment_unnamed_1289), float3(fragment_unnamed_1287, fragment_unnamed_1288, fragment_unnamed_1289))), fragment_unnamed_1275), fragment_uniform_buffer_3[24u].z, fragment_uniform_buffer_3[24u].w), 0.0f, 1.0f), clamp(dot(float4(fragment_unnamed_1515, fragment_unnamed_1516, fragment_unnamed_1517, fragment_unnamed_1518), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f) + ((-0.0f) - fragment_unnamed_1541), fragment_unnamed_1541);
				float fragment_unnamed_1551 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1560 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1569 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_898, fragment_unnamed_899, fragment_unnamed_900));
				float fragment_unnamed_1575 = rsqrt(dot(float3(fragment_unnamed_1551, fragment_unnamed_1560, fragment_unnamed_1569), float3(fragment_unnamed_1551, fragment_unnamed_1560, fragment_unnamed_1569)));
				float fragment_unnamed_1576 = fragment_unnamed_1575 * fragment_unnamed_1551;
				float fragment_unnamed_1577 = fragment_unnamed_1575 * fragment_unnamed_1560;
				float fragment_unnamed_1578 = fragment_unnamed_1575 * fragment_unnamed_1569;
				float fragment_unnamed_1598 = ((-0.0f) - fragment_uniform_buffer_0[5u].x) + 1.0f;
				float fragment_unnamed_1599 = ((-0.0f) - fragment_uniform_buffer_0[5u].y) + 1.0f;
				float fragment_unnamed_1600 = ((-0.0f) - fragment_uniform_buffer_0[5u].z) + 1.0f;
				float fragment_unnamed_1612 = dot(float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1615 = mad(fragment_unnamed_1612, 0.25f, 1.0f);
				float fragment_unnamed_1617 = fragment_unnamed_1615 * (fragment_unnamed_1615 * fragment_unnamed_1615);
				float fragment_unnamed_1622 = exp2(log2(max(fragment_unnamed_1612, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1623 = fragment_unnamed_1622 + fragment_unnamed_1622;
				float fragment_unnamed_1634 = asfloat((0.5f < fragment_unnamed_1622) ? asuint(mad(log2(mad(log2(fragment_unnamed_1623), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1623)) * 0.5f;
				float fragment_unnamed_1640 = dot(float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1782;
				float fragment_unnamed_1783;
				float fragment_unnamed_1784;
				if (1.0f >= fragment_unnamed_1640)
				{
					float fragment_unnamed_1661 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].x) + 1.0f), fragment_unnamed_1598, 1.0f);
					float fragment_unnamed_1662 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].y) + 1.0f), fragment_unnamed_1599, 1.0f);
					float fragment_unnamed_1663 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].z) + 1.0f), fragment_unnamed_1600, 1.0f);
					float fragment_unnamed_1679 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].x) + 1.0f), fragment_unnamed_1598, 1.0f);
					float fragment_unnamed_1680 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].y) + 1.0f), fragment_unnamed_1599, 1.0f);
					float fragment_unnamed_1681 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].z) + 1.0f), fragment_unnamed_1600, 1.0f);
					float fragment_unnamed_1710 = clamp((fragment_unnamed_1640 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1711 = clamp((fragment_unnamed_1640 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1712 = clamp((fragment_unnamed_1640 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1713 = clamp((fragment_unnamed_1640 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1736 = 0.20000000298023223876953125f < fragment_unnamed_1640;
					bool fragment_unnamed_1737 = 0.100000001490116119384765625f < fragment_unnamed_1640;
					bool fragment_unnamed_1738 = (-0.100000001490116119384765625f) < fragment_unnamed_1640;
					float fragment_unnamed_1739 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].x) + 1.0f), fragment_unnamed_1598, 1.0f) * 1.5f;
					float fragment_unnamed_1741 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].y) + 1.0f), fragment_unnamed_1599, 1.0f) * 1.5f;
					float fragment_unnamed_1742 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].z) + 1.0f), fragment_unnamed_1600, 1.0f) * 1.5f;
					fragment_unnamed_1782 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1661) + 1.0f, fragment_unnamed_1661)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1679, 1.25f, fragment_unnamed_1661), fragment_unnamed_1679 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1679, 1.25f, (-0.0f) - fragment_unnamed_1739), fragment_unnamed_1739)) : asuint(fragment_unnamed_1739 * fragment_unnamed_1713))));
					fragment_unnamed_1783 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1662) + 1.0f, fragment_unnamed_1662)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1680, 1.25f, fragment_unnamed_1662), fragment_unnamed_1680 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1680, 1.25f, (-0.0f) - fragment_unnamed_1741), fragment_unnamed_1741)) : asuint(fragment_unnamed_1741 * fragment_unnamed_1713))));
					fragment_unnamed_1784 = asfloat(fragment_unnamed_1736 ? asuint(mad(fragment_unnamed_1710, ((-0.0f) - fragment_unnamed_1663) + 1.0f, fragment_unnamed_1663)) : (fragment_unnamed_1737 ? asuint(mad(fragment_unnamed_1711, mad((-0.0f) - fragment_unnamed_1681, 1.25f, fragment_unnamed_1663), fragment_unnamed_1681 * 1.25f)) : (fragment_unnamed_1738 ? asuint(mad(fragment_unnamed_1712, mad(fragment_unnamed_1681, 1.25f, (-0.0f) - fragment_unnamed_1742), fragment_unnamed_1742)) : asuint(fragment_unnamed_1742 * fragment_unnamed_1713))));
				}
				else
				{
					fragment_unnamed_1782 = asfloat(1065353216u);
					fragment_unnamed_1783 = asfloat(1065353216u);
					fragment_unnamed_1784 = asfloat(1065353216u);
				}
				float fragment_unnamed_1792 = clamp(fragment_unnamed_1640 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1796 = mad(clamp(fragment_unnamed_1640 * 0.1500000059604644775390625f, 0.0f, 1.0f), ((-0.0f) - fragment_unnamed_1544) + 1.0f, fragment_unnamed_1544) * 0.800000011920928955078125f;
				float fragment_unnamed_1808 = min(max((((-0.0f) - fragment_uniform_buffer_0[11u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1817 = mad(clamp(mad(log2(fragment_uniform_buffer_0[11u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1833 = mad(exp2(log2(fragment_uniform_buffer_0[6u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1836 = mad(exp2(log2(fragment_uniform_buffer_0[6u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1837 = mad(exp2(log2(fragment_uniform_buffer_0[6u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1868 = mad(exp2(log2(fragment_uniform_buffer_0[7u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1869 = mad(exp2(log2(fragment_uniform_buffer_0[7u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1870 = mad(exp2(log2(fragment_uniform_buffer_0[7u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1880 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1868) + 0.0240000002086162567138671875f, fragment_unnamed_1868);
				float fragment_unnamed_1881 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1869) + 0.0240000002086162567138671875f, fragment_unnamed_1869);
				float fragment_unnamed_1882 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1870) + 0.0240000002086162567138671875f, fragment_unnamed_1870);
				float fragment_unnamed_1897 = mad(exp2(log2(fragment_uniform_buffer_0[8u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1898 = mad(exp2(log2(fragment_uniform_buffer_0[8u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1899 = mad(exp2(log2(fragment_uniform_buffer_0[8u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1912 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1897, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1897);
				float fragment_unnamed_1913 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1898, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1898);
				float fragment_unnamed_1914 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1899, fragment_unnamed_1808, 0.0240000002086162567138671875f), fragment_unnamed_1808 * fragment_unnamed_1899);
				float fragment_unnamed_1915 = dot(float3(fragment_unnamed_1880, fragment_unnamed_1881, fragment_unnamed_1882), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1924 = mad(((-0.0f) - fragment_unnamed_1880) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1880);
				float fragment_unnamed_1925 = mad(((-0.0f) - fragment_unnamed_1881) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1881);
				float fragment_unnamed_1926 = mad(((-0.0f) - fragment_unnamed_1882) + fragment_unnamed_1915, 0.300000011920928955078125f, fragment_unnamed_1882);
				float fragment_unnamed_1927 = dot(float3(fragment_unnamed_1912, fragment_unnamed_1913, fragment_unnamed_1914), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1936 = mad(((-0.0f) - fragment_unnamed_1912) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1912);
				float fragment_unnamed_1937 = mad(((-0.0f) - fragment_unnamed_1913) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1913);
				float fragment_unnamed_1938 = mad(((-0.0f) - fragment_unnamed_1914) + fragment_unnamed_1927, 0.300000011920928955078125f, fragment_unnamed_1914);
				bool fragment_unnamed_1939 = 0.0f < fragment_unnamed_1640;
				float fragment_unnamed_1952 = clamp(mad(fragment_unnamed_1640, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1953 = clamp(mad(fragment_unnamed_1640, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1977 = clamp(mad(dot(float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1981 = asfloat(asuint(fragment_uniform_buffer_0[10u]).x) + 1.0f;
				float fragment_unnamed_1988 = dot(float3((-0.0f) - fragment_unnamed_1257, (-0.0f) - fragment_unnamed_1258, (-0.0f) - fragment_unnamed_1259), float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578));
				float fragment_unnamed_1992 = (-0.0f) - (fragment_unnamed_1988 + fragment_unnamed_1988);
				float fragment_unnamed_1996 = mad(fragment_unnamed_1576, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1257);
				float fragment_unnamed_1997 = mad(fragment_unnamed_1577, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1258);
				float fragment_unnamed_1998 = mad(fragment_unnamed_1578, fragment_unnamed_1992, (-0.0f) - fragment_unnamed_1259);
				uint fragment_unnamed_2013 = (fragment_uniform_buffer_0[25u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_2028 = sqrt(dot(float3(fragment_uniform_buffer_0[25u].xyz), float3(fragment_uniform_buffer_0[25u].xyz))) + (-5.0f);
				float fragment_unnamed_2044 = clamp(dot(float3((-0.0f) - fragment_unnamed_1169, (-0.0f) - fragment_unnamed_1170, (-0.0f) - fragment_unnamed_1171), float3(fragment_uniform_buffer_0[12u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_2028, 0.0f, 1.0f);
				float fragment_unnamed_2053 = mad((-0.0f) - fragment_unnamed_1169, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].x);
				float fragment_unnamed_2054 = mad((-0.0f) - fragment_unnamed_1170, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].y);
				float fragment_unnamed_2055 = mad((-0.0f) - fragment_unnamed_1171, fragment_unnamed_2028, fragment_uniform_buffer_0[25u].z);
				float fragment_unnamed_2059 = sqrt(dot(float3(fragment_unnamed_2053, fragment_unnamed_2054, fragment_unnamed_2055), float3(fragment_unnamed_2053, fragment_unnamed_2054, fragment_unnamed_2055)));
				float fragment_unnamed_2065 = max((((-0.0f) - fragment_unnamed_2059) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_2067 = fragment_unnamed_2059 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_2082 = fragment_unnamed_2044 * ((fragment_unnamed_2065 * fragment_unnamed_2065) * clamp(dot(float3(fragment_unnamed_2053 / fragment_unnamed_2059, fragment_unnamed_2054 / fragment_unnamed_2059, fragment_unnamed_2055 / fragment_unnamed_2059), float3(fragment_unnamed_1576, fragment_unnamed_1577, fragment_unnamed_1578)), 0.0f, 1.0f));
				float fragment_unnamed_2101 = clamp(fragment_unnamed_1221 * mad(fragment_unnamed_861.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_937) + 1.0f, fragment_unnamed_937), 0.0f, 1.0f);
				float fragment_unnamed_2107 = exp2(log2(fragment_unnamed_1953 * max(dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_uniform_buffer_0[12u].xyz)), 0.0f)) * exp2(fragment_unnamed_2101 * 6.906890392303466796875f));
				uint fragment_unnamed_2124 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171))) ? 4294967295u : 0u;
				float fragment_unnamed_2132 = mad(fragment_unnamed_1169, 1.0f, (-0.0f) - (fragment_unnamed_1170 * 0.0f));
				float fragment_unnamed_2133 = mad(fragment_unnamed_1170, 0.0f, (-0.0f) - (fragment_unnamed_1171 * 1.0f));
				float fragment_unnamed_2138 = rsqrt(dot(float2(fragment_unnamed_2132, fragment_unnamed_2133), float2(fragment_unnamed_2132, fragment_unnamed_2133)));
				bool fragment_unnamed_2142 = (fragment_unnamed_2124 & ((fragment_unnamed_1170 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2147 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * fragment_unnamed_2132) : 0u);
				float fragment_unnamed_2149 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * fragment_unnamed_2133) : 1065353216u);
				float fragment_unnamed_2151 = asfloat(fragment_unnamed_2142 ? asuint(fragment_unnamed_2138 * mad(fragment_unnamed_1171, 0.0f, (-0.0f) - (fragment_unnamed_1169 * 0.0f))) : 0u);
				float fragment_unnamed_2164 = mad(fragment_unnamed_2151, fragment_unnamed_1171, (-0.0f) - (fragment_unnamed_1170 * fragment_unnamed_2147));
				float fragment_unnamed_2165 = mad(fragment_unnamed_2147, fragment_unnamed_1169, (-0.0f) - (fragment_unnamed_1171 * fragment_unnamed_2149));
				float fragment_unnamed_2166 = mad(fragment_unnamed_2149, fragment_unnamed_1170, (-0.0f) - (fragment_unnamed_1169 * fragment_unnamed_2151));
				float fragment_unnamed_2170 = rsqrt(dot(float3(fragment_unnamed_2164, fragment_unnamed_2165, fragment_unnamed_2166), float3(fragment_unnamed_2164, fragment_unnamed_2165, fragment_unnamed_2166)));
				bool fragment_unnamed_2182 = (fragment_unnamed_2124 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2147, fragment_unnamed_2149), float2(fragment_unnamed_2147, fragment_unnamed_2149))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2200 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1998, fragment_unnamed_1996), float2((-0.0f) - fragment_unnamed_2147, (-0.0f) - fragment_unnamed_2149)), dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_unnamed_1169, fragment_unnamed_1170, fragment_unnamed_1171)), dot(float3(fragment_unnamed_1996, fragment_unnamed_1997, fragment_unnamed_1998), float3(fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2164)) : (-0.0f), fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2165)) : (-0.0f), fragment_unnamed_2182 ? ((-0.0f) - (fragment_unnamed_2170 * fragment_unnamed_2166)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2101) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2219 = mad(fragment_unnamed_1953, ((-0.0f) - fragment_uniform_buffer_0[9u].y) + fragment_uniform_buffer_0[9u].x, fragment_uniform_buffer_0[9u].y);
				float fragment_unnamed_2223 = dot(float3(fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.x), fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.y), fragment_unnamed_2219 * (fragment_unnamed_2101 * fragment_unnamed_2200.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2244 = fragment_unnamed_2223 + mad(fragment_unnamed_1214, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 1.2999999523162841796875f) : asuint(fragment_unnamed_2082 * 1.2999999523162841796875f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1598, 1.0f) * fragment_unnamed_1782), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1833, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1833) + ((-0.0f) - fragment_unnamed_1924), fragment_unnamed_1924)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1924 + ((-0.0f) - fragment_unnamed_1936), fragment_unnamed_1936)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.x, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].x), fragment_uniform_buffer_0[4u].x)) * fragment_unnamed_2107)) * 0.5f);
				float fragment_unnamed_2245 = fragment_unnamed_2223 + mad(fragment_unnamed_1215, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 1.10000002384185791015625f) : asuint(fragment_unnamed_2082 * 1.10000002384185791015625f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1599, 1.0f) * fragment_unnamed_1783), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1836, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1836) + ((-0.0f) - fragment_unnamed_1925), fragment_unnamed_1925)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1925 + ((-0.0f) - fragment_unnamed_1937), fragment_unnamed_1937)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.y, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].y), fragment_uniform_buffer_0[4u].y)) * fragment_unnamed_2107)) * 0.5f);
				float fragment_unnamed_2246 = fragment_unnamed_2223 + mad(fragment_unnamed_1216, asfloat((fragment_unnamed_2067 ? asuint(fragment_unnamed_2044 * 0.60000002384185791015625f) : asuint(fragment_unnamed_2082 * 0.60000002384185791015625f)) & fragment_unnamed_2013) + mad(fragment_unnamed_1634 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1600, 1.0f) * fragment_unnamed_1784), fragment_unnamed_1796, fragment_unnamed_1617 * (fragment_unnamed_1981 * (fragment_unnamed_1977 * asfloat(fragment_unnamed_1939 ? asuint(mad(fragment_unnamed_1792, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1837, fragment_unnamed_1817, 0.0240000002086162567138671875f), fragment_unnamed_1817 * fragment_unnamed_1837) + ((-0.0f) - fragment_unnamed_1926), fragment_unnamed_1926)) : asuint(mad(fragment_unnamed_1952, fragment_unnamed_1926 + ((-0.0f) - fragment_unnamed_1938), fragment_unnamed_1938)))))), (fragment_unnamed_2101 * ((fragment_unnamed_1221 * mad(fragment_unnamed_869, mad(fragment_unnamed_861.z, fragment_unnamed_871, (-0.0f) - fragment_uniform_buffer_0[4u].z), fragment_uniform_buffer_0[4u].z)) * fragment_unnamed_2107)) * 0.5f);
				fragment_output_0.x = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_843) + fragment_unnamed_849, fragment_unnamed_843)) + mad(fragment_unnamed_1214, fragment_input_11.x, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1064) + fragment_unnamed_2244, fragment_unnamed_1064));
				fragment_output_0.y = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_845) + fragment_unnamed_851, fragment_unnamed_845)) + mad(fragment_unnamed_1215, fragment_input_11.y, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1065) + fragment_unnamed_2245, fragment_unnamed_1065));
				fragment_output_0.z = (fragment_unnamed_1221 * mad(fragment_unnamed_879, ((-0.0f) - fragment_unnamed_847) + fragment_unnamed_853, fragment_unnamed_847)) + mad(fragment_unnamed_1216, fragment_input_11.z, mad(fragment_unnamed_1042, ((-0.0f) - fragment_unnamed_1066) + fragment_unnamed_2246, fragment_unnamed_1066));
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[2] = float4(_LightColor0[0], _LightColor0[1], _LightColor0[2], _LightColor0[3]);

				fragment_uniform_buffer_0[4] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[5] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[6] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[7] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[8] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[9] = float4(_GIStrengthDay, fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], _GIStrengthNight, fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], _Multiplier);

				fragment_uniform_buffer_0[10] = float4(_AmbientInc, fragment_uniform_buffer_0[10][1], fragment_uniform_buffer_0[10][2], fragment_uniform_buffer_0[10][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], fragment_uniform_buffer_0[11][1], _Distance, fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[12] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[12][3]);

				fragment_uniform_buffer_0[13] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[15][1], fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[17] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[18] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[25] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[24] = float4(_LightShadowData[0], _LightShadowData[1], _LightShadowData[2], _LightShadowData[3]);

				fragment_uniform_buffer_3[25] = float4(unity_ShadowFadeCenterAndType[0], unity_ShadowFadeCenterAndType[1], unity_ShadowFadeCenterAndType[2], unity_ShadowFadeCenterAndType[3]);

				fragment_uniform_buffer_4[9] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
				fragment_uniform_buffer_4[10] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
				fragment_uniform_buffer_4[11] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
				fragment_uniform_buffer_4[12] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);

				fragment_uniform_buffer_5[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_5[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_5[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_5[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_5[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_5[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_5[5][3]);

				fragment_uniform_buffer_5[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_5[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // LIGHTPROBE_SH
			#endif // SHADOWS_SCREEN


			// Fallback Shader Code
			#ifndef ANY_SHADER_VARIANT_ACTIVE

			// https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
			float4x4 unity_MatrixMVP;

			struct Vertex_Stage_Input
			{
				float3 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixMVP, float4(input.pos, 1.0));
				return output;
			}

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				// Output solid grey color (e.g., 50% grey)
				return float4(0.5, 0.5, 0.5, 1.0); // RGBA
			}

			#endif // !ANY_SHADER_VARIANT_ACTIVE


			ENDHLSL
		}
		Pass
		{
			Name "FORWARD"
			LOD 200
			Tags { "DisableBatching" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off

			HLSLPROGRAM

			// https://docs.unity3d.com/Manual/SL-PragmaDirectives.html
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			/*#pragma shader_feature DIRECTIONAL
			#pragma shader_feature DIRECTIONAL_COOKIE
			#pragma shader_feature POINT
			#pragma shader_feature POINT_COOKIE
			#pragma shader_feature SPOT*/
			#define DIRECTIONAL


			#ifdef POINT
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			float4x4 unity_WorldToLight;
			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[20];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float3 vertex_output_9;
			static float4 vertex_output_10;
			static float3 vertex_output_11;
			static float3 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD; // TEXCOORD
				float3 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float3 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float4 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float3 vertex_output_12 : TEXCOORD11; // TEXCOORD_11
				float4 vertex_output_13 : TEXCOORD12; // TEXCOORD_12
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_76 = mad(vertex_input_0.x * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_78 = mad(vertex_input_0.y * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_79 = mad(vertex_input_0.z * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_106 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_108 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_109 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].w));
				float vertex_unnamed_117 = vertex_unnamed_106 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_119 = vertex_unnamed_108 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_120 = vertex_unnamed_109 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_159 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_159;
				gl_Position.y = vertex_unnamed_160;
				gl_Position.z = vertex_unnamed_161;
				gl_Position.w = vertex_unnamed_162;
				float vertex_unnamed_171 = rsqrt(dot(float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79), float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79)));
				float vertex_unnamed_172 = vertex_unnamed_171 * vertex_unnamed_79;
				float vertex_unnamed_173 = vertex_unnamed_171 * vertex_unnamed_76;
				float vertex_unnamed_174 = vertex_unnamed_171 * vertex_unnamed_78;
				vertex_output_5.x = vertex_unnamed_76;
				vertex_output_5.y = vertex_unnamed_78;
				vertex_output_5.z = vertex_unnamed_79;
				float vertex_unnamed_187 = mad(vertex_unnamed_174, 0.0f, (-0.0f) - (vertex_unnamed_172 * 1.0f));
				float vertex_unnamed_189 = mad(vertex_unnamed_173, 1.0f, (-0.0f) - (vertex_unnamed_174 * 0.0f));
				bool vertex_unnamed_195 = sqrt(dot(float2(vertex_unnamed_187, vertex_unnamed_189), float2(vertex_unnamed_187, vertex_unnamed_189))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_202 = asfloat(vertex_unnamed_195 ? 1065353216u : asuint(vertex_unnamed_187));
				float vertex_unnamed_206 = asfloat(vertex_unnamed_195 ? 0u : asuint(vertex_unnamed_189));
				float vertex_unnamed_210 = rsqrt(dot(float2(vertex_unnamed_202, vertex_unnamed_206), float2(vertex_unnamed_202, vertex_unnamed_206)));
				float vertex_unnamed_211 = vertex_unnamed_210 * vertex_unnamed_202;
				float vertex_unnamed_212 = vertex_unnamed_210 * asfloat(vertex_unnamed_195 ? 0u : asuint(mad(vertex_unnamed_172, 0.0f, (-0.0f) - (vertex_unnamed_173 * 0.0f))));
				float vertex_unnamed_213 = vertex_unnamed_210 * vertex_unnamed_206;
				float vertex_unnamed_227 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_228 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_229 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_233 = rsqrt(dot(float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229), float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229)));
				float vertex_unnamed_234 = vertex_unnamed_233 * vertex_unnamed_227;
				float vertex_unnamed_235 = vertex_unnamed_233 * vertex_unnamed_228;
				float vertex_unnamed_236 = vertex_unnamed_233 * vertex_unnamed_229;
				vertex_output_1.x = vertex_unnamed_236;
				float vertex_unnamed_250 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_265 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_280 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_286 = rsqrt(dot(float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265), float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265)));
				float vertex_unnamed_287 = vertex_unnamed_286 * vertex_unnamed_280;
				float vertex_unnamed_288 = vertex_unnamed_286 * vertex_unnamed_250;
				float vertex_unnamed_289 = vertex_unnamed_286 * vertex_unnamed_265;
				float vertex_unnamed_305 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_305 * mad(vertex_unnamed_289, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_unnamed_287));
				vertex_output_1.z = vertex_unnamed_288;
				vertex_output_2.z = vertex_unnamed_289;
				vertex_output_3.z = vertex_unnamed_287;
				vertex_output_2.x = vertex_unnamed_234;
				vertex_output_3.x = vertex_unnamed_235;
				vertex_output_2.y = vertex_unnamed_305 * mad(vertex_unnamed_287, vertex_unnamed_236, (-0.0f) - (vertex_unnamed_235 * vertex_unnamed_288));
				vertex_output_3.y = vertex_unnamed_305 * mad(vertex_unnamed_288, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_236 * vertex_unnamed_289));
				float vertex_unnamed_324 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_325 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_326 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_335 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_336 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_337 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_338 = mad(vertex_uniform_buffer_1[3u].w, vertex_input_0.w, vertex_unnamed_109);
				vertex_output_4.x = vertex_unnamed_324;
				vertex_output_4.y = vertex_unnamed_325;
				vertex_output_4.z = vertex_unnamed_326;
				vertex_output_11.x = vertex_unnamed_324;
				vertex_output_11.y = vertex_unnamed_325;
				vertex_output_11.z = vertex_unnamed_326;
				vertex_output_6.x = vertex_input_1.x;
				vertex_output_6.y = vertex_input_1.y;
				vertex_output_6.z = vertex_input_1.z;
				vertex_output_7.x = vertex_unnamed_211;
				vertex_output_7.y = vertex_unnamed_212;
				vertex_output_7.z = vertex_unnamed_213;
				float vertex_unnamed_375 = mad(vertex_input_1.y, vertex_unnamed_213, (-0.0f) - (vertex_unnamed_212 * vertex_input_1.z));
				float vertex_unnamed_376 = mad(vertex_input_1.z, vertex_unnamed_211, (-0.0f) - (vertex_unnamed_213 * vertex_input_1.x));
				float vertex_unnamed_377 = mad(vertex_input_1.x, vertex_unnamed_212, (-0.0f) - (vertex_unnamed_211 * vertex_input_1.y));
				float vertex_unnamed_381 = rsqrt(dot(float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377), float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377)));
				vertex_output_8.x = vertex_unnamed_381 * vertex_unnamed_375;
				vertex_output_8.y = vertex_unnamed_381 * vertex_unnamed_376;
				vertex_output_8.z = vertex_unnamed_381 * vertex_unnamed_377;
				vertex_output_9.x = vertex_input_3.x;
				vertex_output_9.y = vertex_input_3.y;
				vertex_output_9.z = vertex_input_3.z;
				float vertex_unnamed_399 = vertex_unnamed_162 * 0.5f;
				vertex_output_10.z = vertex_unnamed_161;
				vertex_output_10.w = vertex_unnamed_162;
				vertex_output_10.x = vertex_unnamed_399 + (vertex_unnamed_159 * 0.5f);
				vertex_output_10.y = vertex_unnamed_399 + (vertex_unnamed_160 * (-0.5f));
				vertex_output_12.x = mad(vertex_uniform_buffer_0[7u].x, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].x, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].x, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].x)));
				vertex_output_12.y = mad(vertex_uniform_buffer_0[7u].y, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].y, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].y, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].y)));
				vertex_output_12.z = mad(vertex_uniform_buffer_0[7u].z, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].z, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].z, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].z)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				vertex_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				vertex_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				vertex_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				vertex_uniform_buffer_0[19] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[19][1], vertex_uniform_buffer_0[19][2], vertex_uniform_buffer_0[19][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // POINT
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT_COOKIE
			#endif // !SPOT


			#ifdef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float3 vertex_output_9;
			static float4 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD; // TEXCOORD
				float3 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float3 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float4 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD12; // TEXCOORD_12
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_75 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_77 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_78 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_105 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_78, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_75, vertex_unnamed_77 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_106 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_78, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_75, vertex_unnamed_77 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_78, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_75, vertex_unnamed_77 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_116 = vertex_unnamed_105 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_117 = vertex_unnamed_106 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_119 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_78, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_75, vertex_unnamed_77 * vertex_uniform_buffer_1[1u].w)) + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_127 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_105);
				float vertex_unnamed_128 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_129 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_170 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_119, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_118, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_116, vertex_unnamed_117 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_171 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_119, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_118, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_116, vertex_unnamed_117 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_172 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_119, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_118, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_116, vertex_unnamed_117 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_173 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_119, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_118, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_116, vertex_unnamed_117 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_170;
				gl_Position.y = vertex_unnamed_171;
				gl_Position.z = vertex_unnamed_172;
				gl_Position.w = vertex_unnamed_173;
				float vertex_unnamed_182 = rsqrt(dot(float3(vertex_unnamed_75, vertex_unnamed_77, vertex_unnamed_78), float3(vertex_unnamed_75, vertex_unnamed_77, vertex_unnamed_78)));
				float vertex_unnamed_183 = vertex_unnamed_182 * vertex_unnamed_78;
				float vertex_unnamed_184 = vertex_unnamed_182 * vertex_unnamed_75;
				float vertex_unnamed_185 = vertex_unnamed_182 * vertex_unnamed_77;
				vertex_output_5.x = vertex_unnamed_75;
				vertex_output_5.y = vertex_unnamed_77;
				vertex_output_5.z = vertex_unnamed_78;
				float vertex_unnamed_198 = mad(vertex_unnamed_185, 0.0f, (-0.0f) - (vertex_unnamed_183 * 1.0f));
				float vertex_unnamed_200 = mad(vertex_unnamed_184, 1.0f, (-0.0f) - (vertex_unnamed_185 * 0.0f));
				bool vertex_unnamed_206 = sqrt(dot(float2(vertex_unnamed_198, vertex_unnamed_200), float2(vertex_unnamed_198, vertex_unnamed_200))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_213 = asfloat(vertex_unnamed_206 ? 1065353216u : asuint(vertex_unnamed_198));
				float vertex_unnamed_217 = asfloat(vertex_unnamed_206 ? 0u : asuint(vertex_unnamed_200));
				float vertex_unnamed_221 = rsqrt(dot(float2(vertex_unnamed_213, vertex_unnamed_217), float2(vertex_unnamed_213, vertex_unnamed_217)));
				float vertex_unnamed_222 = vertex_unnamed_221 * vertex_unnamed_213;
				float vertex_unnamed_223 = vertex_unnamed_221 * asfloat(vertex_unnamed_206 ? 0u : asuint(mad(vertex_unnamed_183, 0.0f, (-0.0f) - (vertex_unnamed_184 * 0.0f))));
				float vertex_unnamed_224 = vertex_unnamed_221 * vertex_unnamed_217;
				float vertex_unnamed_238 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_222, vertex_unnamed_224 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_239 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_222, vertex_unnamed_224 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_240 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_222, vertex_unnamed_224 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_244 = rsqrt(dot(float3(vertex_unnamed_238, vertex_unnamed_239, vertex_unnamed_240), float3(vertex_unnamed_238, vertex_unnamed_239, vertex_unnamed_240)));
				float vertex_unnamed_245 = vertex_unnamed_244 * vertex_unnamed_238;
				float vertex_unnamed_246 = vertex_unnamed_244 * vertex_unnamed_239;
				float vertex_unnamed_247 = vertex_unnamed_244 * vertex_unnamed_240;
				vertex_output_1.x = vertex_unnamed_247;
				float vertex_unnamed_261 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_276 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_291 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_297 = rsqrt(dot(float3(vertex_unnamed_291, vertex_unnamed_261, vertex_unnamed_276), float3(vertex_unnamed_291, vertex_unnamed_261, vertex_unnamed_276)));
				float vertex_unnamed_298 = vertex_unnamed_297 * vertex_unnamed_291;
				float vertex_unnamed_299 = vertex_unnamed_297 * vertex_unnamed_261;
				float vertex_unnamed_300 = vertex_unnamed_297 * vertex_unnamed_276;
				float vertex_unnamed_316 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_316 * mad(vertex_unnamed_300, vertex_unnamed_246, (-0.0f) - (vertex_unnamed_245 * vertex_unnamed_298));
				vertex_output_1.z = vertex_unnamed_299;
				vertex_output_2.z = vertex_unnamed_300;
				vertex_output_3.z = vertex_unnamed_298;
				vertex_output_2.x = vertex_unnamed_245;
				vertex_output_3.x = vertex_unnamed_246;
				vertex_output_2.y = vertex_unnamed_316 * mad(vertex_unnamed_298, vertex_unnamed_247, (-0.0f) - (vertex_unnamed_246 * vertex_unnamed_299));
				vertex_output_3.y = vertex_unnamed_316 * mad(vertex_unnamed_299, vertex_unnamed_245, (-0.0f) - (vertex_unnamed_247 * vertex_unnamed_300));
				vertex_output_4.x = vertex_unnamed_127;
				vertex_output_4.y = vertex_unnamed_128;
				vertex_output_4.z = vertex_unnamed_129;
				vertex_output_11.x = vertex_unnamed_127;
				vertex_output_11.y = vertex_unnamed_128;
				vertex_output_11.z = vertex_unnamed_129;
				vertex_output_6.x = vertex_input_1.x;
				vertex_output_6.y = vertex_input_1.y;
				vertex_output_6.z = vertex_input_1.z;
				vertex_output_7.x = vertex_unnamed_222;
				vertex_output_7.y = vertex_unnamed_223;
				vertex_output_7.z = vertex_unnamed_224;
				float vertex_unnamed_364 = mad(vertex_input_1.y, vertex_unnamed_224, (-0.0f) - (vertex_unnamed_223 * vertex_input_1.z));
				float vertex_unnamed_365 = mad(vertex_input_1.z, vertex_unnamed_222, (-0.0f) - (vertex_unnamed_224 * vertex_input_1.x));
				float vertex_unnamed_366 = mad(vertex_input_1.x, vertex_unnamed_223, (-0.0f) - (vertex_unnamed_222 * vertex_input_1.y));
				float vertex_unnamed_370 = rsqrt(dot(float3(vertex_unnamed_364, vertex_unnamed_365, vertex_unnamed_366), float3(vertex_unnamed_364, vertex_unnamed_365, vertex_unnamed_366)));
				vertex_output_8.x = vertex_unnamed_370 * vertex_unnamed_364;
				vertex_output_8.y = vertex_unnamed_370 * vertex_unnamed_365;
				vertex_output_8.z = vertex_unnamed_370 * vertex_unnamed_366;
				vertex_output_9.x = vertex_input_3.x;
				vertex_output_9.y = vertex_input_3.y;
				vertex_output_9.z = vertex_input_3.z;
				float vertex_unnamed_388 = vertex_unnamed_173 * 0.5f;
				vertex_output_10.z = vertex_unnamed_172;
				vertex_output_10.w = vertex_unnamed_173;
				vertex_output_10.x = vertex_unnamed_388 + (vertex_unnamed_170 * 0.5f);
				vertex_output_10.y = vertex_unnamed_388 + (vertex_unnamed_171 * (-0.5f));
				vertex_output_12.x = 0.0f;
				vertex_output_12.y = 0.0f;
				vertex_output_12.z = 0.0f;
				vertex_output_12.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !POINT_COOKIE
			#endif // !SPOT


			#ifdef SPOT
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef POINT_COOKIE
			#define ANY_SHADER_VARIANT_ACTIVE

			float4x4 unity_WorldToLight;
			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[20];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float3 vertex_output_9;
			static float4 vertex_output_10;
			static float3 vertex_output_11;
			static float4 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD; // TEXCOORD
				float3 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float3 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float4 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float4 vertex_output_12 : TEXCOORD11; // TEXCOORD_11
				float4 vertex_output_13 : TEXCOORD12; // TEXCOORD_12
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_76 = mad(vertex_input_0.x * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_78 = mad(vertex_input_0.y * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_79 = mad(vertex_input_0.z * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_106 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_108 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_109 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].w));
				float vertex_unnamed_117 = vertex_unnamed_106 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_119 = vertex_unnamed_108 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_120 = vertex_unnamed_109 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_159 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_159;
				gl_Position.y = vertex_unnamed_160;
				gl_Position.z = vertex_unnamed_161;
				gl_Position.w = vertex_unnamed_162;
				float vertex_unnamed_171 = rsqrt(dot(float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79), float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79)));
				float vertex_unnamed_172 = vertex_unnamed_171 * vertex_unnamed_79;
				float vertex_unnamed_173 = vertex_unnamed_171 * vertex_unnamed_76;
				float vertex_unnamed_174 = vertex_unnamed_171 * vertex_unnamed_78;
				vertex_output_5.x = vertex_unnamed_76;
				vertex_output_5.y = vertex_unnamed_78;
				vertex_output_5.z = vertex_unnamed_79;
				float vertex_unnamed_187 = mad(vertex_unnamed_174, 0.0f, (-0.0f) - (vertex_unnamed_172 * 1.0f));
				float vertex_unnamed_189 = mad(vertex_unnamed_173, 1.0f, (-0.0f) - (vertex_unnamed_174 * 0.0f));
				bool vertex_unnamed_195 = sqrt(dot(float2(vertex_unnamed_187, vertex_unnamed_189), float2(vertex_unnamed_187, vertex_unnamed_189))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_202 = asfloat(vertex_unnamed_195 ? 1065353216u : asuint(vertex_unnamed_187));
				float vertex_unnamed_206 = asfloat(vertex_unnamed_195 ? 0u : asuint(vertex_unnamed_189));
				float vertex_unnamed_210 = rsqrt(dot(float2(vertex_unnamed_202, vertex_unnamed_206), float2(vertex_unnamed_202, vertex_unnamed_206)));
				float vertex_unnamed_211 = vertex_unnamed_210 * vertex_unnamed_202;
				float vertex_unnamed_212 = vertex_unnamed_210 * asfloat(vertex_unnamed_195 ? 0u : asuint(mad(vertex_unnamed_172, 0.0f, (-0.0f) - (vertex_unnamed_173 * 0.0f))));
				float vertex_unnamed_213 = vertex_unnamed_210 * vertex_unnamed_206;
				float vertex_unnamed_227 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_228 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_229 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_233 = rsqrt(dot(float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229), float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229)));
				float vertex_unnamed_234 = vertex_unnamed_233 * vertex_unnamed_227;
				float vertex_unnamed_235 = vertex_unnamed_233 * vertex_unnamed_228;
				float vertex_unnamed_236 = vertex_unnamed_233 * vertex_unnamed_229;
				vertex_output_1.x = vertex_unnamed_236;
				float vertex_unnamed_250 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_265 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_280 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_286 = rsqrt(dot(float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265), float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265)));
				float vertex_unnamed_287 = vertex_unnamed_286 * vertex_unnamed_280;
				float vertex_unnamed_288 = vertex_unnamed_286 * vertex_unnamed_250;
				float vertex_unnamed_289 = vertex_unnamed_286 * vertex_unnamed_265;
				float vertex_unnamed_305 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_305 * mad(vertex_unnamed_289, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_unnamed_287));
				vertex_output_1.z = vertex_unnamed_288;
				vertex_output_2.z = vertex_unnamed_289;
				vertex_output_3.z = vertex_unnamed_287;
				vertex_output_2.x = vertex_unnamed_234;
				vertex_output_3.x = vertex_unnamed_235;
				vertex_output_2.y = vertex_unnamed_305 * mad(vertex_unnamed_287, vertex_unnamed_236, (-0.0f) - (vertex_unnamed_235 * vertex_unnamed_288));
				vertex_output_3.y = vertex_unnamed_305 * mad(vertex_unnamed_288, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_236 * vertex_unnamed_289));
				float vertex_unnamed_324 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_325 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_326 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_335 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_336 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_337 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_338 = mad(vertex_uniform_buffer_1[3u].w, vertex_input_0.w, vertex_unnamed_109);
				vertex_output_4.x = vertex_unnamed_324;
				vertex_output_4.y = vertex_unnamed_325;
				vertex_output_4.z = vertex_unnamed_326;
				vertex_output_11.x = vertex_unnamed_324;
				vertex_output_11.y = vertex_unnamed_325;
				vertex_output_11.z = vertex_unnamed_326;
				vertex_output_6.x = vertex_input_1.x;
				vertex_output_6.y = vertex_input_1.y;
				vertex_output_6.z = vertex_input_1.z;
				vertex_output_7.x = vertex_unnamed_211;
				vertex_output_7.y = vertex_unnamed_212;
				vertex_output_7.z = vertex_unnamed_213;
				float vertex_unnamed_375 = mad(vertex_input_1.y, vertex_unnamed_213, (-0.0f) - (vertex_unnamed_212 * vertex_input_1.z));
				float vertex_unnamed_376 = mad(vertex_input_1.z, vertex_unnamed_211, (-0.0f) - (vertex_unnamed_213 * vertex_input_1.x));
				float vertex_unnamed_377 = mad(vertex_input_1.x, vertex_unnamed_212, (-0.0f) - (vertex_unnamed_211 * vertex_input_1.y));
				float vertex_unnamed_381 = rsqrt(dot(float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377), float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377)));
				vertex_output_8.x = vertex_unnamed_381 * vertex_unnamed_375;
				vertex_output_8.y = vertex_unnamed_381 * vertex_unnamed_376;
				vertex_output_8.z = vertex_unnamed_381 * vertex_unnamed_377;
				vertex_output_9.x = vertex_input_3.x;
				vertex_output_9.y = vertex_input_3.y;
				vertex_output_9.z = vertex_input_3.z;
				float vertex_unnamed_399 = vertex_unnamed_162 * 0.5f;
				vertex_output_10.z = vertex_unnamed_161;
				vertex_output_10.w = vertex_unnamed_162;
				vertex_output_10.x = vertex_unnamed_399 + (vertex_unnamed_159 * 0.5f);
				vertex_output_10.y = vertex_unnamed_399 + (vertex_unnamed_160 * (-0.5f));
				vertex_output_12.x = mad(vertex_uniform_buffer_0[7u].x, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].x, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].x, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].x)));
				vertex_output_12.y = mad(vertex_uniform_buffer_0[7u].y, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].y, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].y, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].y)));
				vertex_output_12.z = mad(vertex_uniform_buffer_0[7u].z, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].z, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].z, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].z)));
				vertex_output_12.w = mad(vertex_uniform_buffer_0[7u].w, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].w, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].w, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].w)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				vertex_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				vertex_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				vertex_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				vertex_uniform_buffer_0[19] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[19][1], vertex_uniform_buffer_0[19][2], vertex_uniform_buffer_0[19][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // SPOT
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !POINT_COOKIE


			#ifdef POINT_COOKIE
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			float4x4 unity_WorldToLight;
			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[20];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float3 vertex_output_9;
			static float4 vertex_output_10;
			static float3 vertex_output_11;
			static float3 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD; // TEXCOORD
				float3 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float3 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float4 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float3 vertex_output_12 : TEXCOORD11; // TEXCOORD_11
				float4 vertex_output_13 : TEXCOORD12; // TEXCOORD_12
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_76 = mad(vertex_input_0.x * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_78 = mad(vertex_input_0.y * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_79 = mad(vertex_input_0.z * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_106 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_108 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_109 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_79, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_76, vertex_unnamed_78 * vertex_uniform_buffer_1[1u].w));
				float vertex_unnamed_117 = vertex_unnamed_106 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_119 = vertex_unnamed_108 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_120 = vertex_unnamed_109 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_159 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_120, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_119, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_117, vertex_unnamed_118 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_159;
				gl_Position.y = vertex_unnamed_160;
				gl_Position.z = vertex_unnamed_161;
				gl_Position.w = vertex_unnamed_162;
				float vertex_unnamed_171 = rsqrt(dot(float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79), float3(vertex_unnamed_76, vertex_unnamed_78, vertex_unnamed_79)));
				float vertex_unnamed_172 = vertex_unnamed_171 * vertex_unnamed_79;
				float vertex_unnamed_173 = vertex_unnamed_171 * vertex_unnamed_76;
				float vertex_unnamed_174 = vertex_unnamed_171 * vertex_unnamed_78;
				vertex_output_5.x = vertex_unnamed_76;
				vertex_output_5.y = vertex_unnamed_78;
				vertex_output_5.z = vertex_unnamed_79;
				float vertex_unnamed_187 = mad(vertex_unnamed_174, 0.0f, (-0.0f) - (vertex_unnamed_172 * 1.0f));
				float vertex_unnamed_189 = mad(vertex_unnamed_173, 1.0f, (-0.0f) - (vertex_unnamed_174 * 0.0f));
				bool vertex_unnamed_195 = sqrt(dot(float2(vertex_unnamed_187, vertex_unnamed_189), float2(vertex_unnamed_187, vertex_unnamed_189))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_202 = asfloat(vertex_unnamed_195 ? 1065353216u : asuint(vertex_unnamed_187));
				float vertex_unnamed_206 = asfloat(vertex_unnamed_195 ? 0u : asuint(vertex_unnamed_189));
				float vertex_unnamed_210 = rsqrt(dot(float2(vertex_unnamed_202, vertex_unnamed_206), float2(vertex_unnamed_202, vertex_unnamed_206)));
				float vertex_unnamed_211 = vertex_unnamed_210 * vertex_unnamed_202;
				float vertex_unnamed_212 = vertex_unnamed_210 * asfloat(vertex_unnamed_195 ? 0u : asuint(mad(vertex_unnamed_172, 0.0f, (-0.0f) - (vertex_unnamed_173 * 0.0f))));
				float vertex_unnamed_213 = vertex_unnamed_210 * vertex_unnamed_206;
				float vertex_unnamed_227 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_228 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_229 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_211, vertex_unnamed_213 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_233 = rsqrt(dot(float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229), float3(vertex_unnamed_227, vertex_unnamed_228, vertex_unnamed_229)));
				float vertex_unnamed_234 = vertex_unnamed_233 * vertex_unnamed_227;
				float vertex_unnamed_235 = vertex_unnamed_233 * vertex_unnamed_228;
				float vertex_unnamed_236 = vertex_unnamed_233 * vertex_unnamed_229;
				vertex_output_1.x = vertex_unnamed_236;
				float vertex_unnamed_250 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_265 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_280 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_286 = rsqrt(dot(float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265), float3(vertex_unnamed_280, vertex_unnamed_250, vertex_unnamed_265)));
				float vertex_unnamed_287 = vertex_unnamed_286 * vertex_unnamed_280;
				float vertex_unnamed_288 = vertex_unnamed_286 * vertex_unnamed_250;
				float vertex_unnamed_289 = vertex_unnamed_286 * vertex_unnamed_265;
				float vertex_unnamed_305 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_305 * mad(vertex_unnamed_289, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_234 * vertex_unnamed_287));
				vertex_output_1.z = vertex_unnamed_288;
				vertex_output_2.z = vertex_unnamed_289;
				vertex_output_3.z = vertex_unnamed_287;
				vertex_output_2.x = vertex_unnamed_234;
				vertex_output_3.x = vertex_unnamed_235;
				vertex_output_2.y = vertex_unnamed_305 * mad(vertex_unnamed_287, vertex_unnamed_236, (-0.0f) - (vertex_unnamed_235 * vertex_unnamed_288));
				vertex_output_3.y = vertex_unnamed_305 * mad(vertex_unnamed_288, vertex_unnamed_234, (-0.0f) - (vertex_unnamed_236 * vertex_unnamed_289));
				float vertex_unnamed_324 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_325 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_326 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_335 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_106);
				float vertex_unnamed_336 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_337 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_338 = mad(vertex_uniform_buffer_1[3u].w, vertex_input_0.w, vertex_unnamed_109);
				vertex_output_4.x = vertex_unnamed_324;
				vertex_output_4.y = vertex_unnamed_325;
				vertex_output_4.z = vertex_unnamed_326;
				vertex_output_11.x = vertex_unnamed_324;
				vertex_output_11.y = vertex_unnamed_325;
				vertex_output_11.z = vertex_unnamed_326;
				vertex_output_6.x = vertex_input_1.x;
				vertex_output_6.y = vertex_input_1.y;
				vertex_output_6.z = vertex_input_1.z;
				vertex_output_7.x = vertex_unnamed_211;
				vertex_output_7.y = vertex_unnamed_212;
				vertex_output_7.z = vertex_unnamed_213;
				float vertex_unnamed_375 = mad(vertex_input_1.y, vertex_unnamed_213, (-0.0f) - (vertex_unnamed_212 * vertex_input_1.z));
				float vertex_unnamed_376 = mad(vertex_input_1.z, vertex_unnamed_211, (-0.0f) - (vertex_unnamed_213 * vertex_input_1.x));
				float vertex_unnamed_377 = mad(vertex_input_1.x, vertex_unnamed_212, (-0.0f) - (vertex_unnamed_211 * vertex_input_1.y));
				float vertex_unnamed_381 = rsqrt(dot(float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377), float3(vertex_unnamed_375, vertex_unnamed_376, vertex_unnamed_377)));
				vertex_output_8.x = vertex_unnamed_381 * vertex_unnamed_375;
				vertex_output_8.y = vertex_unnamed_381 * vertex_unnamed_376;
				vertex_output_8.z = vertex_unnamed_381 * vertex_unnamed_377;
				vertex_output_9.x = vertex_input_3.x;
				vertex_output_9.y = vertex_input_3.y;
				vertex_output_9.z = vertex_input_3.z;
				float vertex_unnamed_399 = vertex_unnamed_162 * 0.5f;
				vertex_output_10.z = vertex_unnamed_161;
				vertex_output_10.w = vertex_unnamed_162;
				vertex_output_10.x = vertex_unnamed_399 + (vertex_unnamed_159 * 0.5f);
				vertex_output_10.y = vertex_unnamed_399 + (vertex_unnamed_160 * (-0.5f));
				vertex_output_12.x = mad(vertex_uniform_buffer_0[7u].x, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].x, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].x, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].x)));
				vertex_output_12.y = mad(vertex_uniform_buffer_0[7u].y, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].y, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].y, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].y)));
				vertex_output_12.z = mad(vertex_uniform_buffer_0[7u].z, vertex_unnamed_338, mad(vertex_uniform_buffer_0[6u].z, vertex_unnamed_337, mad(vertex_uniform_buffer_0[4u].z, vertex_unnamed_335, vertex_unnamed_336 * vertex_uniform_buffer_0[5u].z)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				vertex_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				vertex_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				vertex_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				vertex_uniform_buffer_0[19] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[19][1], vertex_uniform_buffer_0[19][2], vertex_uniform_buffer_0[19][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // POINT_COOKIE
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !SPOT


			#ifdef DIRECTIONAL_COOKIE
			#ifndef DIRECTIONAL
			#ifndef POINT
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			float4x4 unity_WorldToLight;
			float _Global_WhiteMode0;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4 unity_WorldTransformParams;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[20];
			static float4 vertex_uniform_buffer_1[10];
			static float4 vertex_uniform_buffer_2[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float3 vertex_output_6;
			static float3 vertex_output_7;
			static float3 vertex_output_8;
			static float3 vertex_output_9;
			static float4 vertex_output_10;
			static float3 vertex_output_11;
			static float2 vertex_output_12;
			static float4 vertex_output_13;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD; // TEXCOORD
				float3 vertex_output_2 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_3 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_4 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_5 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_6 : TEXCOORD5; // TEXCOORD_5
				float3 vertex_output_7 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_8 : TEXCOORD7; // TEXCOORD_7
				float3 vertex_output_9 : TEXCOORD8; // TEXCOORD_8
				float4 vertex_output_10 : TEXCOORD9; // TEXCOORD_9
				float3 vertex_output_11 : TEXCOORD10; // TEXCOORD_10
				float2 vertex_output_12 : TEXCOORD11; // TEXCOORD_11
				float4 vertex_output_13 : TEXCOORD12; // TEXCOORD_12
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_77 = mad(vertex_input_0.x * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_79 = mad(vertex_input_0.y * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_80 = mad(vertex_input_0.z * vertex_uniform_buffer_0[19u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_107 = mad(vertex_uniform_buffer_1[2u].x, vertex_unnamed_80, mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_77, vertex_unnamed_79 * vertex_uniform_buffer_1[1u].x));
				float vertex_unnamed_108 = mad(vertex_uniform_buffer_1[2u].y, vertex_unnamed_80, mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_77, vertex_unnamed_79 * vertex_uniform_buffer_1[1u].y));
				float vertex_unnamed_109 = mad(vertex_uniform_buffer_1[2u].z, vertex_unnamed_80, mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_77, vertex_unnamed_79 * vertex_uniform_buffer_1[1u].z));
				float vertex_unnamed_110 = mad(vertex_uniform_buffer_1[2u].w, vertex_unnamed_80, mad(vertex_uniform_buffer_1[0u].w, vertex_unnamed_77, vertex_unnamed_79 * vertex_uniform_buffer_1[1u].w));
				float vertex_unnamed_118 = vertex_unnamed_107 + vertex_uniform_buffer_1[3u].x;
				float vertex_unnamed_119 = vertex_unnamed_108 + vertex_uniform_buffer_1[3u].y;
				float vertex_unnamed_120 = vertex_unnamed_109 + vertex_uniform_buffer_1[3u].z;
				float vertex_unnamed_121 = vertex_unnamed_110 + vertex_uniform_buffer_1[3u].w;
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_2[20u].x, vertex_unnamed_121, mad(vertex_uniform_buffer_2[19u].x, vertex_unnamed_120, mad(vertex_uniform_buffer_2[17u].x, vertex_unnamed_118, vertex_unnamed_119 * vertex_uniform_buffer_2[18u].x)));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_2[20u].y, vertex_unnamed_121, mad(vertex_uniform_buffer_2[19u].y, vertex_unnamed_120, mad(vertex_uniform_buffer_2[17u].y, vertex_unnamed_118, vertex_unnamed_119 * vertex_uniform_buffer_2[18u].y)));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_2[20u].z, vertex_unnamed_121, mad(vertex_uniform_buffer_2[19u].z, vertex_unnamed_120, mad(vertex_uniform_buffer_2[17u].z, vertex_unnamed_118, vertex_unnamed_119 * vertex_uniform_buffer_2[18u].z)));
				float vertex_unnamed_163 = mad(vertex_uniform_buffer_2[20u].w, vertex_unnamed_121, mad(vertex_uniform_buffer_2[19u].w, vertex_unnamed_120, mad(vertex_uniform_buffer_2[17u].w, vertex_unnamed_118, vertex_unnamed_119 * vertex_uniform_buffer_2[18u].w)));
				gl_Position.x = vertex_unnamed_160;
				gl_Position.y = vertex_unnamed_161;
				gl_Position.z = vertex_unnamed_162;
				gl_Position.w = vertex_unnamed_163;
				float vertex_unnamed_172 = rsqrt(dot(float3(vertex_unnamed_77, vertex_unnamed_79, vertex_unnamed_80), float3(vertex_unnamed_77, vertex_unnamed_79, vertex_unnamed_80)));
				float vertex_unnamed_173 = vertex_unnamed_172 * vertex_unnamed_80;
				float vertex_unnamed_174 = vertex_unnamed_172 * vertex_unnamed_77;
				float vertex_unnamed_175 = vertex_unnamed_172 * vertex_unnamed_79;
				vertex_output_5.x = vertex_unnamed_77;
				vertex_output_5.y = vertex_unnamed_79;
				vertex_output_5.z = vertex_unnamed_80;
				float vertex_unnamed_188 = mad(vertex_unnamed_175, 0.0f, (-0.0f) - (vertex_unnamed_173 * 1.0f));
				float vertex_unnamed_190 = mad(vertex_unnamed_174, 1.0f, (-0.0f) - (vertex_unnamed_175 * 0.0f));
				bool vertex_unnamed_196 = sqrt(dot(float2(vertex_unnamed_188, vertex_unnamed_190), float2(vertex_unnamed_188, vertex_unnamed_190))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_203 = asfloat(vertex_unnamed_196 ? 1065353216u : asuint(vertex_unnamed_188));
				float vertex_unnamed_207 = asfloat(vertex_unnamed_196 ? 0u : asuint(vertex_unnamed_190));
				float vertex_unnamed_211 = rsqrt(dot(float2(vertex_unnamed_203, vertex_unnamed_207), float2(vertex_unnamed_203, vertex_unnamed_207)));
				float vertex_unnamed_212 = vertex_unnamed_211 * vertex_unnamed_203;
				float vertex_unnamed_213 = vertex_unnamed_211 * asfloat(vertex_unnamed_196 ? 0u : asuint(mad(vertex_unnamed_173, 0.0f, (-0.0f) - (vertex_unnamed_174 * 0.0f))));
				float vertex_unnamed_214 = vertex_unnamed_211 * vertex_unnamed_207;
				float vertex_unnamed_228 = mad(vertex_uniform_buffer_1[0u].y, vertex_unnamed_212, vertex_unnamed_214 * vertex_uniform_buffer_1[2u].y);
				float vertex_unnamed_229 = mad(vertex_uniform_buffer_1[0u].z, vertex_unnamed_212, vertex_unnamed_214 * vertex_uniform_buffer_1[2u].z);
				float vertex_unnamed_230 = mad(vertex_uniform_buffer_1[0u].x, vertex_unnamed_212, vertex_unnamed_214 * vertex_uniform_buffer_1[2u].x);
				float vertex_unnamed_234 = rsqrt(dot(float3(vertex_unnamed_228, vertex_unnamed_229, vertex_unnamed_230), float3(vertex_unnamed_228, vertex_unnamed_229, vertex_unnamed_230)));
				float vertex_unnamed_235 = vertex_unnamed_234 * vertex_unnamed_228;
				float vertex_unnamed_236 = vertex_unnamed_234 * vertex_unnamed_229;
				float vertex_unnamed_237 = vertex_unnamed_234 * vertex_unnamed_230;
				vertex_output_1.x = vertex_unnamed_237;
				float vertex_unnamed_251 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[4u].xyz));
				float vertex_unnamed_266 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[5u].xyz));
				float vertex_unnamed_281 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_1[6u].xyz));
				float vertex_unnamed_287 = rsqrt(dot(float3(vertex_unnamed_281, vertex_unnamed_251, vertex_unnamed_266), float3(vertex_unnamed_281, vertex_unnamed_251, vertex_unnamed_266)));
				float vertex_unnamed_288 = vertex_unnamed_287 * vertex_unnamed_281;
				float vertex_unnamed_289 = vertex_unnamed_287 * vertex_unnamed_251;
				float vertex_unnamed_290 = vertex_unnamed_287 * vertex_unnamed_266;
				float vertex_unnamed_306 = vertex_input_2.w * vertex_uniform_buffer_1[9u].w;
				vertex_output_1.y = vertex_unnamed_306 * mad(vertex_unnamed_290, vertex_unnamed_236, (-0.0f) - (vertex_unnamed_235 * vertex_unnamed_288));
				vertex_output_1.z = vertex_unnamed_289;
				vertex_output_2.z = vertex_unnamed_290;
				vertex_output_3.z = vertex_unnamed_288;
				vertex_output_2.x = vertex_unnamed_235;
				vertex_output_3.x = vertex_unnamed_236;
				vertex_output_2.y = vertex_unnamed_306 * mad(vertex_unnamed_288, vertex_unnamed_237, (-0.0f) - (vertex_unnamed_236 * vertex_unnamed_289));
				vertex_output_3.y = vertex_unnamed_306 * mad(vertex_unnamed_289, vertex_unnamed_235, (-0.0f) - (vertex_unnamed_237 * vertex_unnamed_290));
				float vertex_unnamed_325 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_326 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_327 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_109);
				float vertex_unnamed_336 = mad(vertex_uniform_buffer_1[3u].x, vertex_input_0.w, vertex_unnamed_107);
				float vertex_unnamed_337 = mad(vertex_uniform_buffer_1[3u].y, vertex_input_0.w, vertex_unnamed_108);
				float vertex_unnamed_338 = mad(vertex_uniform_buffer_1[3u].z, vertex_input_0.w, vertex_unnamed_109);
				float vertex_unnamed_339 = mad(vertex_uniform_buffer_1[3u].w, vertex_input_0.w, vertex_unnamed_110);
				vertex_output_4.x = vertex_unnamed_325;
				vertex_output_4.y = vertex_unnamed_326;
				vertex_output_4.z = vertex_unnamed_327;
				vertex_output_11.x = vertex_unnamed_325;
				vertex_output_11.y = vertex_unnamed_326;
				vertex_output_11.z = vertex_unnamed_327;
				vertex_output_6.x = vertex_input_1.x;
				vertex_output_6.y = vertex_input_1.y;
				vertex_output_6.z = vertex_input_1.z;
				vertex_output_7.x = vertex_unnamed_212;
				vertex_output_7.y = vertex_unnamed_213;
				vertex_output_7.z = vertex_unnamed_214;
				float vertex_unnamed_376 = mad(vertex_input_1.y, vertex_unnamed_214, (-0.0f) - (vertex_unnamed_213 * vertex_input_1.z));
				float vertex_unnamed_377 = mad(vertex_input_1.z, vertex_unnamed_212, (-0.0f) - (vertex_unnamed_214 * vertex_input_1.x));
				float vertex_unnamed_378 = mad(vertex_input_1.x, vertex_unnamed_213, (-0.0f) - (vertex_unnamed_212 * vertex_input_1.y));
				float vertex_unnamed_382 = rsqrt(dot(float3(vertex_unnamed_376, vertex_unnamed_377, vertex_unnamed_378), float3(vertex_unnamed_376, vertex_unnamed_377, vertex_unnamed_378)));
				vertex_output_8.x = vertex_unnamed_382 * vertex_unnamed_376;
				vertex_output_8.y = vertex_unnamed_382 * vertex_unnamed_377;
				vertex_output_8.z = vertex_unnamed_382 * vertex_unnamed_378;
				vertex_output_9.x = vertex_input_3.x;
				vertex_output_9.y = vertex_input_3.y;
				vertex_output_9.z = vertex_input_3.z;
				float vertex_unnamed_400 = vertex_unnamed_163 * 0.5f;
				vertex_output_10.z = vertex_unnamed_162;
				vertex_output_10.w = vertex_unnamed_163;
				vertex_output_10.x = vertex_unnamed_400 + (vertex_unnamed_160 * 0.5f);
				vertex_output_10.y = vertex_unnamed_400 + (vertex_unnamed_161 * (-0.5f));
				vertex_output_12.x = mad(vertex_uniform_buffer_0[7u].x, vertex_unnamed_339, mad(vertex_uniform_buffer_0[6u].x, vertex_unnamed_338, mad(vertex_uniform_buffer_0[4u].x, vertex_unnamed_336, vertex_unnamed_337 * vertex_uniform_buffer_0[5u].x)));
				vertex_output_12.y = mad(vertex_uniform_buffer_0[7u].y, vertex_unnamed_339, mad(vertex_uniform_buffer_0[6u].y, vertex_unnamed_338, mad(vertex_uniform_buffer_0[4u].y, vertex_unnamed_336, vertex_unnamed_337 * vertex_uniform_buffer_0[5u].y)));
				vertex_output_13.x = 0.0f;
				vertex_output_13.y = 0.0f;
				vertex_output_13.z = 0.0f;
				vertex_output_13.w = 0.0f;
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				vertex_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				vertex_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				vertex_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				vertex_uniform_buffer_0[19] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[19][1], vertex_uniform_buffer_0[19][2], vertex_uniform_buffer_0[19][3]);

				vertex_uniform_buffer_1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_1[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_1[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_1[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_1[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_1[9] = float4(unity_WorldTransformParams[0], unity_WorldTransformParams[1], unity_WorldTransformParams[2], unity_WorldTransformParams[3]);

				vertex_uniform_buffer_2[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_2[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_2[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_2[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				stage_output.vertex_output_8 = vertex_output_8;
				stage_output.vertex_output_9 = vertex_output_9;
				stage_output.vertex_output_10 = vertex_output_10;
				stage_output.vertex_output_11 = vertex_output_11;
				stage_output.vertex_output_12 = vertex_output_12;
				stage_output.vertex_output_13 = vertex_output_13;
				return stage_output;
			}

			#endif // DIRECTIONAL_COOKIE
			#endif // !DIRECTIONAL
			#endif // !POINT
			#endif // !POINT_COOKIE
			#endif // !SPOT


			#ifdef POINT
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			//float4x4 unity_WorldToLight;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[30];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _LightTexture0;
			SamplerState sampler_LightTexture0;
			Texture2D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float3 fragment_input_9;
			static float4 fragment_input_10;
			static float3 fragment_input_11;
			static float3 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD; // TEXCOORD
				float3 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float3 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float4 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float3 fragment_input_12 : TEXCOORD11; // TEXCOORD_11
				float4 fragment_input_13 : TEXCOORD12; // TEXCOORD_12
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2180)
			{
				if (fragment_unnamed_2180)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_125 = rsqrt(dot(float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z), float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z)));
				float fragment_unnamed_132 = fragment_unnamed_125 * fragment_input_5.y;
				float fragment_unnamed_133 = fragment_unnamed_125 * fragment_input_5.x;
				float fragment_unnamed_134 = fragment_unnamed_125 * fragment_input_5.z;
				uint fragment_unnamed_143 = uint(mad(fragment_uniform_buffer_0[18u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_149 = sqrt(((-0.0f) - abs(fragment_unnamed_132)) + 1.0f);
				float fragment_unnamed_158 = mad(mad(mad(abs(fragment_unnamed_132), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_132), -0.212114393711090087890625f), abs(fragment_unnamed_132), 1.570728778839111328125f);
				float fragment_unnamed_183 = (1.0f / max(abs(fragment_unnamed_134), abs(fragment_unnamed_133))) * min(abs(fragment_unnamed_134), abs(fragment_unnamed_133));
				float fragment_unnamed_184 = fragment_unnamed_183 * fragment_unnamed_183;
				float fragment_unnamed_192 = mad(fragment_unnamed_184, mad(fragment_unnamed_184, mad(fragment_unnamed_184, mad(fragment_unnamed_184, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_210 = asfloat(((((-0.0f) - fragment_unnamed_134) < fragment_unnamed_134) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_183, fragment_unnamed_192, asfloat(((abs(fragment_unnamed_134) < abs(fragment_unnamed_133)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_192 * fragment_unnamed_183, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_212 = min((-0.0f) - fragment_unnamed_134, fragment_unnamed_133);
				float fragment_unnamed_214 = max((-0.0f) - fragment_unnamed_134, fragment_unnamed_133);
				float fragment_unnamed_228 = (((-0.0f) - mad(fragment_unnamed_158, fragment_unnamed_149, asfloat(((fragment_unnamed_132 < ((-0.0f) - fragment_unnamed_132)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_149 * fragment_unnamed_158, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[18u].x;
				float fragment_unnamed_229 = fragment_unnamed_228 * 0.3183098733425140380859375f;
				bool fragment_unnamed_231 = 0.0f < fragment_unnamed_228;
				float fragment_unnamed_238 = asfloat(fragment_unnamed_231 ? asuint(ceil(fragment_unnamed_229)) : asuint(floor(fragment_unnamed_229)));
				float fragment_unnamed_242 = float(fragment_unnamed_143);
				uint fragment_unnamed_250 = uint(asfloat((0.0f < fragment_unnamed_238) ? asuint(fragment_unnamed_238 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_238) + fragment_unnamed_242) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_252 = _OffsetsBuffer.Load(fragment_unnamed_250);
				uint fragment_unnamed_253 = fragment_unnamed_252.x;
				float fragment_unnamed_260 = float((-fragment_unnamed_253) + _OffsetsBuffer.Load(fragment_unnamed_250 + 1u).x);
				float fragment_unnamed_261 = mad(((((fragment_unnamed_214 >= ((-0.0f) - fragment_unnamed_214)) ? 4294967295u : 0u) & ((fragment_unnamed_212 < ((-0.0f) - fragment_unnamed_212)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_210) : fragment_unnamed_210, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_263 = fragment_unnamed_260 * fragment_unnamed_261;
				bool fragment_unnamed_264 = 0.0f < fragment_unnamed_263;
				float fragment_unnamed_270 = asfloat(fragment_unnamed_264 ? asuint(ceil(fragment_unnamed_263)) : asuint(floor(fragment_unnamed_263)));
				float fragment_unnamed_271 = mad(fragment_unnamed_260, 0.5f, 0.5f);
				float fragment_unnamed_287 = float(fragment_unnamed_253 + uint(asfloat((fragment_unnamed_271 < fragment_unnamed_270) ? asuint(mad((-0.0f) - fragment_unnamed_260, 0.5f, fragment_unnamed_270) + (-1.0f)) : asuint(fragment_unnamed_260 + ((-0.0f) - fragment_unnamed_270))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_290 = frac(fragment_unnamed_287);
				uint4 fragment_unnamed_292 = _DataBuffer.Load(uint(floor(fragment_unnamed_287)));
				uint fragment_unnamed_293 = fragment_unnamed_292.x;
				uint fragment_unnamed_305 = 16u & 31u;
				uint fragment_unnamed_312 = 8u & 31u;
				uint fragment_unnamed_320 = (0.625f < fragment_unnamed_290) ? (fragment_unnamed_293 >> 24u) : ((0.375f < fragment_unnamed_290) ? spvBitfieldUExtract(fragment_unnamed_293, fragment_unnamed_305, min((8u & 31u), (32u - fragment_unnamed_305))) : ((0.125f < fragment_unnamed_290) ? spvBitfieldUExtract(fragment_unnamed_293, fragment_unnamed_312, min((8u & 31u), (32u - fragment_unnamed_312))) : (fragment_unnamed_293 & 255u)));
				float fragment_unnamed_322 = float(fragment_unnamed_320 >> 5u);
				float fragment_unnamed_327 = asfloat((6.5f < fragment_unnamed_322) ? 0u : asuint(fragment_unnamed_322));
				float fragment_unnamed_334 = round(fragment_uniform_buffer_0[15u].y * 3.0f);
				discard_cond(fragment_unnamed_327 < (fragment_unnamed_334 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_334 + 3.9900000095367431640625f) < fragment_unnamed_327);
				float fragment_unnamed_353 = mad(fragment_unnamed_228, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_354 = mad(fragment_unnamed_228, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_365 = asfloat(fragment_unnamed_231 ? asuint(ceil(fragment_unnamed_353)) : asuint(floor(fragment_unnamed_353)));
				float fragment_unnamed_367 = asfloat(fragment_unnamed_231 ? asuint(ceil(fragment_unnamed_354)) : asuint(floor(fragment_unnamed_354)));
				uint fragment_unnamed_369 = uint(ceil(max(abs(fragment_unnamed_229) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_388 = uint(asfloat((0.0f < fragment_unnamed_365) ? asuint(fragment_unnamed_365 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_242 + ((-0.0f) - fragment_unnamed_365)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_389 = uint(asfloat((0.0f < fragment_unnamed_367) ? asuint(fragment_unnamed_367 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_242 + ((-0.0f) - fragment_unnamed_367)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_390 = _OffsetsBuffer.Load(fragment_unnamed_388);
				uint fragment_unnamed_391 = fragment_unnamed_390.x;
				uint4 fragment_unnamed_392 = _OffsetsBuffer.Load(fragment_unnamed_389);
				uint fragment_unnamed_393 = fragment_unnamed_392.x;
				uint fragment_unnamed_404 = (fragment_unnamed_250 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_407 = (fragment_unnamed_250 != (fragment_unnamed_143 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_410 = (fragment_unnamed_143 != fragment_unnamed_250) ? 4294967295u : 0u;
				uint fragment_unnamed_414 = (fragment_unnamed_250 != (uint(fragment_uniform_buffer_0[18u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_430 = (fragment_unnamed_414 & (fragment_unnamed_410 & (fragment_unnamed_404 & fragment_unnamed_407))) != 0u;
				uint fragment_unnamed_433 = asuint(fragment_unnamed_260);
				float fragment_unnamed_435 = asfloat(fragment_unnamed_430 ? asuint(float((-fragment_unnamed_391) + _OffsetsBuffer.Load(fragment_unnamed_388 + 1u).x)) : fragment_unnamed_433);
				float fragment_unnamed_437 = asfloat(fragment_unnamed_430 ? asuint(float((-fragment_unnamed_393) + _OffsetsBuffer.Load(fragment_unnamed_389 + 1u).x)) : fragment_unnamed_433);
				float fragment_unnamed_439 = fragment_unnamed_261 * fragment_unnamed_435;
				float fragment_unnamed_440 = fragment_unnamed_261 * fragment_unnamed_437;
				float fragment_unnamed_441 = mad(fragment_unnamed_261, fragment_unnamed_260, 0.5f);
				float fragment_unnamed_442 = mad(fragment_unnamed_261, fragment_unnamed_260, -0.5f);
				float fragment_unnamed_449 = asfloat((fragment_unnamed_260 < fragment_unnamed_441) ? asuint(((-0.0f) - fragment_unnamed_260) + fragment_unnamed_441) : asuint(fragment_unnamed_441));
				float fragment_unnamed_455 = asfloat((fragment_unnamed_442 < 0.0f) ? asuint(fragment_unnamed_260 + fragment_unnamed_442) : asuint(fragment_unnamed_442));
				float fragment_unnamed_465 = asfloat(fragment_unnamed_264 ? asuint(ceil(fragment_unnamed_439)) : asuint(floor(fragment_unnamed_439)));
				float fragment_unnamed_467 = asfloat(fragment_unnamed_264 ? asuint(ceil(fragment_unnamed_440)) : asuint(floor(fragment_unnamed_440)));
				float fragment_unnamed_473 = asfloat(fragment_unnamed_264 ? asuint(ceil(fragment_unnamed_449)) : asuint(floor(fragment_unnamed_449)));
				float fragment_unnamed_479 = asfloat(fragment_unnamed_264 ? asuint(ceil(fragment_unnamed_455)) : asuint(floor(fragment_unnamed_455)));
				float fragment_unnamed_480 = frac(fragment_unnamed_229);
				float fragment_unnamed_481 = frac(fragment_unnamed_263);
				float fragment_unnamed_482 = fragment_unnamed_480 + (-0.5f);
				float fragment_unnamed_491 = min((((-0.0f) - fragment_unnamed_481) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_493 = min(fragment_unnamed_481 * 40.0f, 1.0f);
				float fragment_unnamed_494 = min(fragment_unnamed_480 * 40.0f, 1.0f);
				float fragment_unnamed_550 = float(fragment_unnamed_391 + uint(asfloat((mad(fragment_unnamed_435, 0.5f, 0.5f) < fragment_unnamed_465) ? asuint(mad((-0.0f) - fragment_unnamed_435, 0.5f, fragment_unnamed_465) + (-1.0f)) : asuint(fragment_unnamed_435 + ((-0.0f) - fragment_unnamed_465))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_552 = frac(fragment_unnamed_550);
				uint4 fragment_unnamed_554 = _DataBuffer.Load(uint(floor(fragment_unnamed_550)));
				uint fragment_unnamed_555 = fragment_unnamed_554.x;
				uint fragment_unnamed_561 = 16u & 31u;
				uint fragment_unnamed_566 = 8u & 31u;
				float fragment_unnamed_576 = float(uint(asfloat((mad(fragment_unnamed_437, 0.5f, 0.5f) < fragment_unnamed_467) ? asuint(mad((-0.0f) - fragment_unnamed_437, 0.5f, fragment_unnamed_467) + (-1.0f)) : asuint(fragment_unnamed_437 + ((-0.0f) - fragment_unnamed_467))) + 0.100000001490116119384765625f) + fragment_unnamed_393) * 0.25f;
				float fragment_unnamed_578 = frac(fragment_unnamed_576);
				uint4 fragment_unnamed_580 = _DataBuffer.Load(uint(floor(fragment_unnamed_576)));
				uint fragment_unnamed_581 = fragment_unnamed_580.x;
				uint fragment_unnamed_587 = 16u & 31u;
				uint fragment_unnamed_592 = 8u & 31u;
				float fragment_unnamed_602 = float(uint(asfloat((fragment_unnamed_271 < fragment_unnamed_473) ? asuint(mad((-0.0f) - fragment_unnamed_260, 0.5f, fragment_unnamed_473) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_473) + fragment_unnamed_260)) + 0.100000001490116119384765625f) + fragment_unnamed_253) * 0.25f;
				float fragment_unnamed_604 = frac(fragment_unnamed_602);
				uint4 fragment_unnamed_606 = _DataBuffer.Load(uint(floor(fragment_unnamed_602)));
				uint fragment_unnamed_607 = fragment_unnamed_606.x;
				uint fragment_unnamed_613 = 16u & 31u;
				uint fragment_unnamed_618 = 8u & 31u;
				float fragment_unnamed_628 = float(uint(asfloat((fragment_unnamed_271 < fragment_unnamed_479) ? asuint(mad((-0.0f) - fragment_unnamed_260, 0.5f, fragment_unnamed_479) + (-1.0f)) : asuint(fragment_unnamed_260 + ((-0.0f) - fragment_unnamed_479))) + 0.100000001490116119384765625f) + fragment_unnamed_253) * 0.25f;
				float fragment_unnamed_630 = frac(fragment_unnamed_628);
				uint4 fragment_unnamed_632 = _DataBuffer.Load(uint(floor(fragment_unnamed_628)));
				uint fragment_unnamed_633 = fragment_unnamed_632.x;
				uint fragment_unnamed_639 = 16u & 31u;
				uint fragment_unnamed_644 = 8u & 31u;
				float fragment_unnamed_654 = float(((0.625f < fragment_unnamed_578) ? (fragment_unnamed_581 >> 24u) : ((0.375f < fragment_unnamed_578) ? spvBitfieldUExtract(fragment_unnamed_581, fragment_unnamed_587, min((8u & 31u), (32u - fragment_unnamed_587))) : ((0.125f < fragment_unnamed_578) ? spvBitfieldUExtract(fragment_unnamed_581, fragment_unnamed_592, min((8u & 31u), (32u - fragment_unnamed_592))) : (fragment_unnamed_581 & 255u)))) >> 5u);
				float fragment_unnamed_656 = float(((0.625f < fragment_unnamed_604) ? (fragment_unnamed_607 >> 24u) : ((0.375f < fragment_unnamed_604) ? spvBitfieldUExtract(fragment_unnamed_607, fragment_unnamed_613, min((8u & 31u), (32u - fragment_unnamed_613))) : ((0.125f < fragment_unnamed_604) ? spvBitfieldUExtract(fragment_unnamed_607, fragment_unnamed_618, min((8u & 31u), (32u - fragment_unnamed_618))) : (fragment_unnamed_607 & 255u)))) >> 5u);
				float fragment_unnamed_658 = float(((0.625f < fragment_unnamed_630) ? (fragment_unnamed_633 >> 24u) : ((0.375f < fragment_unnamed_630) ? spvBitfieldUExtract(fragment_unnamed_633, fragment_unnamed_639, min((8u & 31u), (32u - fragment_unnamed_639))) : ((0.125f < fragment_unnamed_630) ? spvBitfieldUExtract(fragment_unnamed_633, fragment_unnamed_644, min((8u & 31u), (32u - fragment_unnamed_644))) : (fragment_unnamed_633 & 255u)))) >> 5u);
				float fragment_unnamed_659 = float(((0.625f < fragment_unnamed_552) ? (fragment_unnamed_555 >> 24u) : ((0.375f < fragment_unnamed_552) ? spvBitfieldUExtract(fragment_unnamed_555, fragment_unnamed_561, min((8u & 31u), (32u - fragment_unnamed_561))) : ((0.125f < fragment_unnamed_552) ? spvBitfieldUExtract(fragment_unnamed_555, fragment_unnamed_566, min((8u & 31u), (32u - fragment_unnamed_566))) : (fragment_unnamed_555 & 255u)))) >> 5u);
				float fragment_unnamed_670 = fragment_unnamed_263 * 0.20000000298023223876953125f;
				float fragment_unnamed_672 = fragment_unnamed_228 * 0.06366197764873504638671875f;
				float fragment_unnamed_674 = (fragment_unnamed_261 * float((-_OffsetsBuffer.Load(fragment_unnamed_369).x) + _OffsetsBuffer.Load(fragment_unnamed_369 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_681 = ddx_coarse(fragment_input_11.x);
				float fragment_unnamed_682 = ddx_coarse(fragment_input_11.y);
				float fragment_unnamed_683 = ddx_coarse(fragment_input_11.z);
				float fragment_unnamed_687 = sqrt(dot(float3(fragment_unnamed_681, fragment_unnamed_682, fragment_unnamed_683), float3(fragment_unnamed_681, fragment_unnamed_682, fragment_unnamed_683)));
				float fragment_unnamed_694 = ddy_coarse(fragment_input_11.x);
				float fragment_unnamed_695 = ddy_coarse(fragment_input_11.y);
				float fragment_unnamed_696 = ddy_coarse(fragment_input_11.z);
				float fragment_unnamed_700 = sqrt(dot(float3(fragment_unnamed_694, fragment_unnamed_695, fragment_unnamed_696), float3(fragment_unnamed_694, fragment_unnamed_695, fragment_unnamed_696)));
				float fragment_unnamed_711 = min(max(log2(sqrt(dot(float2(fragment_unnamed_687, fragment_unnamed_700), float2(fragment_unnamed_687, fragment_unnamed_700))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_713 = min((((-0.0f) - fragment_unnamed_480) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_780;
				float fragment_unnamed_782;
				float fragment_unnamed_784;
				float fragment_unnamed_786;
				float fragment_unnamed_788;
				float fragment_unnamed_790;
				float fragment_unnamed_792;
				float fragment_unnamed_794;
				float fragment_unnamed_796;
				float fragment_unnamed_798;
				float fragment_unnamed_800;
				float fragment_unnamed_802;
				float fragment_unnamed_804;
				float fragment_unnamed_806;
				if (((((fragment_unnamed_334 + 0.9900000095367431640625f) < fragment_unnamed_327) ? 4294967295u : 0u) & ((fragment_unnamed_327 < (fragment_unnamed_334 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_726 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
					float4 fragment_unnamed_732 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
					float4 fragment_unnamed_739 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
					float fragment_unnamed_745 = mad(fragment_unnamed_739.w * fragment_unnamed_739.x, 2.0f, -1.0f);
					float fragment_unnamed_747 = mad(fragment_unnamed_739.y, 2.0f, -1.0f);
					float4 fragment_unnamed_755 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
					float fragment_unnamed_761 = mad(fragment_unnamed_755.w * fragment_unnamed_755.x, 2.0f, -1.0f);
					float fragment_unnamed_762 = mad(fragment_unnamed_755.y, 2.0f, -1.0f);
					fragment_unnamed_780 = fragment_unnamed_726.x;
					fragment_unnamed_782 = fragment_unnamed_726.y;
					fragment_unnamed_784 = fragment_unnamed_726.z;
					fragment_unnamed_786 = fragment_unnamed_732.x;
					fragment_unnamed_788 = fragment_unnamed_732.y;
					fragment_unnamed_790 = fragment_unnamed_732.z;
					fragment_unnamed_792 = fragment_unnamed_726.w;
					fragment_unnamed_794 = fragment_unnamed_732.w;
					fragment_unnamed_796 = fragment_unnamed_745;
					fragment_unnamed_798 = fragment_unnamed_747;
					fragment_unnamed_800 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_745, fragment_unnamed_747), float2(fragment_unnamed_745, fragment_unnamed_747)), 1.0f)) + 1.0f);
					fragment_unnamed_802 = fragment_unnamed_761;
					fragment_unnamed_804 = fragment_unnamed_762;
					fragment_unnamed_806 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_761, fragment_unnamed_762), float2(fragment_unnamed_761, fragment_unnamed_762)), 1.0f)) + 1.0f);
				}
				else
				{
					float fragment_unnamed_781;
					float fragment_unnamed_783;
					float fragment_unnamed_785;
					float fragment_unnamed_787;
					float fragment_unnamed_789;
					float fragment_unnamed_791;
					float fragment_unnamed_793;
					float fragment_unnamed_795;
					float fragment_unnamed_797;
					float fragment_unnamed_799;
					float fragment_unnamed_801;
					float fragment_unnamed_803;
					float fragment_unnamed_805;
					float fragment_unnamed_807;
					if (((((fragment_unnamed_334 + 1.9900000095367431640625f) < fragment_unnamed_327) ? 4294967295u : 0u) & ((fragment_unnamed_327 < (fragment_unnamed_334 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1245 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
						float4 fragment_unnamed_1251 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
						float4 fragment_unnamed_1258 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
						float fragment_unnamed_1264 = mad(fragment_unnamed_1258.w * fragment_unnamed_1258.x, 2.0f, -1.0f);
						float fragment_unnamed_1265 = mad(fragment_unnamed_1258.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1273 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
						float fragment_unnamed_1279 = mad(fragment_unnamed_1273.w * fragment_unnamed_1273.x, 2.0f, -1.0f);
						float fragment_unnamed_1280 = mad(fragment_unnamed_1273.y, 2.0f, -1.0f);
						fragment_unnamed_781 = fragment_unnamed_1245.x;
						fragment_unnamed_783 = fragment_unnamed_1245.y;
						fragment_unnamed_785 = fragment_unnamed_1245.z;
						fragment_unnamed_787 = fragment_unnamed_1251.x;
						fragment_unnamed_789 = fragment_unnamed_1251.y;
						fragment_unnamed_791 = fragment_unnamed_1251.z;
						fragment_unnamed_793 = fragment_unnamed_1245.w;
						fragment_unnamed_795 = fragment_unnamed_1251.w;
						fragment_unnamed_797 = fragment_unnamed_1264;
						fragment_unnamed_799 = fragment_unnamed_1265;
						fragment_unnamed_801 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1264, fragment_unnamed_1265), float2(fragment_unnamed_1264, fragment_unnamed_1265)), 1.0f)) + 1.0f);
						fragment_unnamed_803 = fragment_unnamed_1279;
						fragment_unnamed_805 = fragment_unnamed_1280;
						fragment_unnamed_807 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1279, fragment_unnamed_1280), float2(fragment_unnamed_1279, fragment_unnamed_1280)), 1.0f)) + 1.0f);
					}
					else
					{
						float4 fragment_unnamed_1289 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
						float4 fragment_unnamed_1295 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
						float4 fragment_unnamed_1302 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_672, fragment_unnamed_670), fragment_unnamed_711);
						float fragment_unnamed_1308 = mad(fragment_unnamed_1302.w * fragment_unnamed_1302.x, 2.0f, -1.0f);
						float fragment_unnamed_1309 = mad(fragment_unnamed_1302.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1317 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_672, fragment_unnamed_674), fragment_unnamed_711);
						float fragment_unnamed_1323 = mad(fragment_unnamed_1317.w * fragment_unnamed_1317.x, 2.0f, -1.0f);
						float fragment_unnamed_1324 = mad(fragment_unnamed_1317.y, 2.0f, -1.0f);
						fragment_unnamed_781 = fragment_unnamed_1289.x;
						fragment_unnamed_783 = fragment_unnamed_1289.y;
						fragment_unnamed_785 = fragment_unnamed_1289.z;
						fragment_unnamed_787 = fragment_unnamed_1295.x;
						fragment_unnamed_789 = fragment_unnamed_1295.y;
						fragment_unnamed_791 = fragment_unnamed_1295.z;
						fragment_unnamed_793 = fragment_unnamed_1289.w;
						fragment_unnamed_795 = fragment_unnamed_1295.w;
						fragment_unnamed_797 = fragment_unnamed_1308;
						fragment_unnamed_799 = fragment_unnamed_1309;
						fragment_unnamed_801 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1308, fragment_unnamed_1309), float2(fragment_unnamed_1308, fragment_unnamed_1309)), 1.0f)) + 1.0f);
						fragment_unnamed_803 = fragment_unnamed_1323;
						fragment_unnamed_805 = fragment_unnamed_1324;
						fragment_unnamed_807 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1323, fragment_unnamed_1324), float2(fragment_unnamed_1323, fragment_unnamed_1324)), 1.0f)) + 1.0f);
					}
					fragment_unnamed_780 = fragment_unnamed_781;
					fragment_unnamed_782 = fragment_unnamed_783;
					fragment_unnamed_784 = fragment_unnamed_785;
					fragment_unnamed_786 = fragment_unnamed_787;
					fragment_unnamed_788 = fragment_unnamed_789;
					fragment_unnamed_790 = fragment_unnamed_791;
					fragment_unnamed_792 = fragment_unnamed_793;
					fragment_unnamed_794 = fragment_unnamed_795;
					fragment_unnamed_796 = fragment_unnamed_797;
					fragment_unnamed_798 = fragment_unnamed_799;
					fragment_unnamed_800 = fragment_unnamed_801;
					fragment_unnamed_802 = fragment_unnamed_803;
					fragment_unnamed_804 = fragment_unnamed_805;
					fragment_unnamed_806 = fragment_unnamed_807;
				}
				float4 fragment_unnamed_814 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_320 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_822 = fragment_unnamed_814.w * 0.800000011920928955078125f;
				float fragment_unnamed_824 = mad(fragment_unnamed_814.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_832 = exp2(log2(abs(fragment_unnamed_482) + abs(fragment_unnamed_482)) * 10.0f);
				float fragment_unnamed_851 = mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_798) + fragment_unnamed_804, fragment_unnamed_798);
				float fragment_unnamed_852 = mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_796) + fragment_unnamed_802, fragment_unnamed_796);
				float fragment_unnamed_853 = mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_800) + fragment_unnamed_806, fragment_unnamed_800);
				float fragment_unnamed_854 = (fragment_unnamed_824 * fragment_unnamed_814.x) * mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_780) + fragment_unnamed_786, fragment_unnamed_780);
				float fragment_unnamed_855 = (fragment_unnamed_824 * fragment_unnamed_814.y) * mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_782) + fragment_unnamed_788, fragment_unnamed_782);
				float fragment_unnamed_856 = (fragment_unnamed_824 * fragment_unnamed_814.z) * mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_784) + fragment_unnamed_790, fragment_unnamed_784);
				float fragment_unnamed_863 = mad(fragment_unnamed_814.w, mad(fragment_unnamed_814.x, fragment_unnamed_824, (-0.0f) - fragment_unnamed_854), fragment_unnamed_854);
				float fragment_unnamed_864 = mad(fragment_unnamed_814.w, mad(fragment_unnamed_814.y, fragment_unnamed_824, (-0.0f) - fragment_unnamed_855), fragment_unnamed_855);
				float fragment_unnamed_865 = mad(fragment_unnamed_814.w, mad(fragment_unnamed_814.z, fragment_unnamed_824, (-0.0f) - fragment_unnamed_856), fragment_unnamed_856);
				float fragment_unnamed_867 = ((-0.0f) - mad(fragment_unnamed_832, ((-0.0f) - fragment_unnamed_792) + fragment_unnamed_794, fragment_unnamed_792)) + 1.0f;
				float fragment_unnamed_871 = fragment_unnamed_867 * fragment_uniform_buffer_0[8u].w;
				float fragment_unnamed_880 = mad(fragment_unnamed_814.w, mad((-0.0f) - fragment_unnamed_867, fragment_uniform_buffer_0[8u].w, clamp(fragment_unnamed_871 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_871);
				bool fragment_unnamed_914 = (fragment_unnamed_407 & (fragment_unnamed_410 & (((fragment_unnamed_659 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_659) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_922 = fragment_unnamed_914 ? asuint(fragment_unnamed_713 * fragment_unnamed_863) : asuint(fragment_unnamed_863);
				uint fragment_unnamed_924 = fragment_unnamed_914 ? asuint(fragment_unnamed_713 * fragment_unnamed_864) : asuint(fragment_unnamed_864);
				uint fragment_unnamed_926 = fragment_unnamed_914 ? asuint(fragment_unnamed_713 * fragment_unnamed_865) : asuint(fragment_unnamed_865);
				uint fragment_unnamed_928 = fragment_unnamed_914 ? asuint(fragment_unnamed_713 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_939 = (fragment_unnamed_414 & (fragment_unnamed_404 & (((fragment_unnamed_654 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_654) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_944 = fragment_unnamed_939 ? asuint(fragment_unnamed_494 * asfloat(fragment_unnamed_922)) : fragment_unnamed_922;
				uint fragment_unnamed_946 = fragment_unnamed_939 ? asuint(fragment_unnamed_494 * asfloat(fragment_unnamed_924)) : fragment_unnamed_924;
				uint fragment_unnamed_948 = fragment_unnamed_939 ? asuint(fragment_unnamed_494 * asfloat(fragment_unnamed_926)) : fragment_unnamed_926;
				uint fragment_unnamed_950 = fragment_unnamed_939 ? asuint(fragment_unnamed_494 * asfloat(fragment_unnamed_928)) : fragment_unnamed_928;
				bool fragment_unnamed_959 = (((fragment_unnamed_656 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_656) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_964 = fragment_unnamed_959 ? asuint(fragment_unnamed_491 * asfloat(fragment_unnamed_944)) : fragment_unnamed_944;
				uint fragment_unnamed_966 = fragment_unnamed_959 ? asuint(fragment_unnamed_491 * asfloat(fragment_unnamed_946)) : fragment_unnamed_946;
				uint fragment_unnamed_968 = fragment_unnamed_959 ? asuint(fragment_unnamed_491 * asfloat(fragment_unnamed_948)) : fragment_unnamed_948;
				uint fragment_unnamed_970 = fragment_unnamed_959 ? asuint(fragment_unnamed_491 * asfloat(fragment_unnamed_950)) : fragment_unnamed_950;
				bool fragment_unnamed_979 = (((fragment_unnamed_658 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_658) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_985 = asfloat(fragment_unnamed_979 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_970)) : fragment_unnamed_970);
				discard_cond((fragment_unnamed_985 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1005 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_10.x / fragment_input_10.w, fragment_input_10.y / fragment_input_10.w));
				float fragment_unnamed_1007 = fragment_unnamed_1005.x;
				float fragment_unnamed_1008 = fragment_unnamed_1005.y;
				float fragment_unnamed_1009 = fragment_unnamed_1005.z;
				float fragment_unnamed_1014 = asfloat(fragment_unnamed_979 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_964)) : fragment_unnamed_964) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1015 = asfloat(fragment_unnamed_979 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_966)) : fragment_unnamed_966) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1016 = asfloat(fragment_unnamed_979 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_968)) : fragment_unnamed_968) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1028 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1029 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1030 = fragment_uniform_buffer_0[17u].x + fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1031 = fragment_uniform_buffer_0[17u].y + fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1037 = fragment_unnamed_1030 * fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1038 = fragment_unnamed_1031 * fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1039 = fragment_unnamed_1029 * fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1047 = fragment_unnamed_1030 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1048 = fragment_unnamed_1031 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1052 = fragment_unnamed_1029 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1083 = mad(fragment_unnamed_1048 + (fragment_unnamed_1028 * fragment_uniform_buffer_0[17u].x), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1031, (-0.0f) - fragment_unnamed_1052), fragment_input_5.y, (((-0.0f) - (fragment_unnamed_1039 + fragment_unnamed_1038)) + 1.0f) * fragment_input_5.x));
				float fragment_unnamed_1101 = mad(mad(fragment_uniform_buffer_0[17u].y, fragment_unnamed_1029, (-0.0f) - fragment_unnamed_1047), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1031, fragment_unnamed_1052), fragment_input_5.x, (((-0.0f) - (fragment_unnamed_1039 + fragment_unnamed_1037)) + 1.0f) * fragment_input_5.y));
				float fragment_unnamed_1107 = mad(((-0.0f) - (fragment_unnamed_1038 + fragment_unnamed_1037)) + 1.0f, fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1028, (-0.0f) - fragment_unnamed_1048), fragment_input_5.x, (fragment_unnamed_1047 + (fragment_unnamed_1029 * fragment_uniform_buffer_0[17u].y)) * fragment_input_5.y));
				float fragment_unnamed_1111 = rsqrt(dot(float3(fragment_unnamed_1083, fragment_unnamed_1101, fragment_unnamed_1107), float3(fragment_unnamed_1083, fragment_unnamed_1101, fragment_unnamed_1107)));
				float fragment_unnamed_1112 = fragment_unnamed_1111 * fragment_unnamed_1083;
				float fragment_unnamed_1113 = fragment_unnamed_1111 * fragment_unnamed_1101;
				float fragment_unnamed_1114 = fragment_unnamed_1111 * fragment_unnamed_1107;
				float fragment_unnamed_1121 = mad(mad(fragment_unnamed_814.x, fragment_unnamed_824, (-0.0f) - fragment_unnamed_1014), 0.5f, fragment_unnamed_1014);
				float fragment_unnamed_1122 = mad(mad(fragment_unnamed_814.y, fragment_unnamed_824, (-0.0f) - fragment_unnamed_1015), 0.5f, fragment_unnamed_1015);
				float fragment_unnamed_1123 = mad(mad(fragment_unnamed_814.z, fragment_unnamed_824, (-0.0f) - fragment_unnamed_1016), 0.5f, fragment_unnamed_1016);
				float fragment_unnamed_1124 = dot(float3(fragment_unnamed_1121, fragment_unnamed_1122, fragment_unnamed_1123), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1130 = mad(((-0.0f) - fragment_unnamed_1124) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1124);
				float fragment_unnamed_1136 = (-0.0f) - fragment_unnamed_1130;
				float fragment_unnamed_1164 = mad((-0.0f) - fragment_uniform_buffer_0[19u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1191 = ((-0.0f) - fragment_input_4.x) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1192 = ((-0.0f) - fragment_input_4.y) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1193 = ((-0.0f) - fragment_input_4.z) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1197 = rsqrt(dot(float3(fragment_unnamed_1191, fragment_unnamed_1192, fragment_unnamed_1193), float3(fragment_unnamed_1191, fragment_unnamed_1192, fragment_unnamed_1193)));
				float fragment_unnamed_1198 = fragment_unnamed_1197 * fragment_unnamed_1191;
				float fragment_unnamed_1199 = fragment_unnamed_1197 * fragment_unnamed_1192;
				float fragment_unnamed_1200 = fragment_unnamed_1197 * fragment_unnamed_1193;
				float fragment_unnamed_1237 = mad(fragment_uniform_buffer_0[6u].x, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].x)) + fragment_uniform_buffer_0[7u].x;
				float fragment_unnamed_1238 = mad(fragment_uniform_buffer_0[6u].y, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].y)) + fragment_uniform_buffer_0[7u].y;
				float fragment_unnamed_1239 = mad(fragment_uniform_buffer_0[6u].z, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].z)) + fragment_uniform_buffer_0[7u].z;
				float fragment_unnamed_1421;
				float fragment_unnamed_1422;
				float fragment_unnamed_1423;
				float fragment_unnamed_1424;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1335 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1411 = _LightTexture0.Sample(sampler_LightTexture0, float3(max(mad(((fragment_unnamed_1335 ? (mad(fragment_uniform_buffer_3[3u].x, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : fragment_input_4.x) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), ((fragment_unnamed_1335 ? (mad(fragment_uniform_buffer_3[3u].y, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : fragment_input_4.y) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, ((fragment_unnamed_1335 ? (mad(fragment_uniform_buffer_3[3u].z, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : fragment_input_4.z) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1421 = fragment_unnamed_1411.x;
					fragment_unnamed_1422 = fragment_unnamed_1411.y;
					fragment_unnamed_1423 = fragment_unnamed_1411.z;
					fragment_unnamed_1424 = fragment_unnamed_1411.w;
				}
				else
				{
					fragment_unnamed_1421 = asfloat(1065353216u);
					fragment_unnamed_1422 = asfloat(1065353216u);
					fragment_unnamed_1423 = asfloat(1065353216u);
					fragment_unnamed_1424 = asfloat(1065353216u);
				}
				float fragment_unnamed_1435 = clamp(dot(float4(fragment_unnamed_1421, fragment_unnamed_1422, fragment_unnamed_1423, fragment_unnamed_1424), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float4 fragment_unnamed_1440 = _Global_PGI.Sample(sampler_Global_PGI, dot(float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239), float3(fragment_unnamed_1237, fragment_unnamed_1238, fragment_unnamed_1239)).xx);
				float fragment_unnamed_1442 = fragment_unnamed_1440.x;
				float fragment_unnamed_1450 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_851, fragment_unnamed_852, fragment_unnamed_853));
				float fragment_unnamed_1459 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_851, fragment_unnamed_852, fragment_unnamed_853));
				float fragment_unnamed_1468 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_851, fragment_unnamed_852, fragment_unnamed_853));
				float fragment_unnamed_1474 = rsqrt(dot(float3(fragment_unnamed_1450, fragment_unnamed_1459, fragment_unnamed_1468), float3(fragment_unnamed_1450, fragment_unnamed_1459, fragment_unnamed_1468)));
				float fragment_unnamed_1475 = fragment_unnamed_1474 * fragment_unnamed_1450;
				float fragment_unnamed_1476 = fragment_unnamed_1474 * fragment_unnamed_1459;
				float fragment_unnamed_1477 = fragment_unnamed_1474 * fragment_unnamed_1468;
				float fragment_unnamed_1498 = ((-0.0f) - fragment_uniform_buffer_0[9u].x) + 1.0f;
				float fragment_unnamed_1499 = ((-0.0f) - fragment_uniform_buffer_0[9u].y) + 1.0f;
				float fragment_unnamed_1500 = ((-0.0f) - fragment_uniform_buffer_0[9u].z) + 1.0f;
				float fragment_unnamed_1512 = dot(float3(fragment_unnamed_1475, fragment_unnamed_1476, fragment_unnamed_1477), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1515 = mad(fragment_unnamed_1512, 0.25f, 1.0f);
				float fragment_unnamed_1517 = fragment_unnamed_1515 * (fragment_unnamed_1515 * fragment_unnamed_1515);
				float fragment_unnamed_1522 = exp2(log2(max(fragment_unnamed_1512, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1523 = fragment_unnamed_1522 + fragment_unnamed_1522;
				float fragment_unnamed_1534 = asfloat((0.5f < fragment_unnamed_1522) ? asuint(mad(log2(mad(log2(fragment_unnamed_1523), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1523)) * 0.5f;
				float fragment_unnamed_1540 = dot(float3(fragment_unnamed_1112, fragment_unnamed_1113, fragment_unnamed_1114), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1683;
				float fragment_unnamed_1684;
				float fragment_unnamed_1685;
				if (1.0f >= fragment_unnamed_1540)
				{
					float fragment_unnamed_1562 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].x) + 1.0f), fragment_unnamed_1498, 1.0f);
					float fragment_unnamed_1563 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].y) + 1.0f), fragment_unnamed_1499, 1.0f);
					float fragment_unnamed_1564 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].z) + 1.0f), fragment_unnamed_1500, 1.0f);
					float fragment_unnamed_1580 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].x) + 1.0f), fragment_unnamed_1498, 1.0f);
					float fragment_unnamed_1581 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].y) + 1.0f), fragment_unnamed_1499, 1.0f);
					float fragment_unnamed_1582 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].z) + 1.0f), fragment_unnamed_1500, 1.0f);
					float fragment_unnamed_1611 = clamp((fragment_unnamed_1540 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1612 = clamp((fragment_unnamed_1540 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1613 = clamp((fragment_unnamed_1540 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1614 = clamp((fragment_unnamed_1540 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1637 = 0.20000000298023223876953125f < fragment_unnamed_1540;
					bool fragment_unnamed_1638 = 0.100000001490116119384765625f < fragment_unnamed_1540;
					bool fragment_unnamed_1639 = (-0.100000001490116119384765625f) < fragment_unnamed_1540;
					float fragment_unnamed_1640 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].x) + 1.0f), fragment_unnamed_1498, 1.0f) * 1.5f;
					float fragment_unnamed_1642 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].y) + 1.0f), fragment_unnamed_1499, 1.0f) * 1.5f;
					float fragment_unnamed_1643 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].z) + 1.0f), fragment_unnamed_1500, 1.0f) * 1.5f;
					fragment_unnamed_1683 = asfloat(fragment_unnamed_1637 ? asuint(mad(fragment_unnamed_1611, ((-0.0f) - fragment_unnamed_1562) + 1.0f, fragment_unnamed_1562)) : (fragment_unnamed_1638 ? asuint(mad(fragment_unnamed_1612, mad((-0.0f) - fragment_unnamed_1580, 1.25f, fragment_unnamed_1562), fragment_unnamed_1580 * 1.25f)) : (fragment_unnamed_1639 ? asuint(mad(fragment_unnamed_1613, mad(fragment_unnamed_1580, 1.25f, (-0.0f) - fragment_unnamed_1640), fragment_unnamed_1640)) : asuint(fragment_unnamed_1640 * fragment_unnamed_1614))));
					fragment_unnamed_1684 = asfloat(fragment_unnamed_1637 ? asuint(mad(fragment_unnamed_1611, ((-0.0f) - fragment_unnamed_1563) + 1.0f, fragment_unnamed_1563)) : (fragment_unnamed_1638 ? asuint(mad(fragment_unnamed_1612, mad((-0.0f) - fragment_unnamed_1581, 1.25f, fragment_unnamed_1563), fragment_unnamed_1581 * 1.25f)) : (fragment_unnamed_1639 ? asuint(mad(fragment_unnamed_1613, mad(fragment_unnamed_1581, 1.25f, (-0.0f) - fragment_unnamed_1642), fragment_unnamed_1642)) : asuint(fragment_unnamed_1642 * fragment_unnamed_1614))));
					fragment_unnamed_1685 = asfloat(fragment_unnamed_1637 ? asuint(mad(fragment_unnamed_1611, ((-0.0f) - fragment_unnamed_1564) + 1.0f, fragment_unnamed_1564)) : (fragment_unnamed_1638 ? asuint(mad(fragment_unnamed_1612, mad((-0.0f) - fragment_unnamed_1582, 1.25f, fragment_unnamed_1564), fragment_unnamed_1582 * 1.25f)) : (fragment_unnamed_1639 ? asuint(mad(fragment_unnamed_1613, mad(fragment_unnamed_1582, 1.25f, (-0.0f) - fragment_unnamed_1643), fragment_unnamed_1643)) : asuint(fragment_unnamed_1643 * fragment_unnamed_1614))));
				}
				else
				{
					fragment_unnamed_1683 = asfloat(1065353216u);
					fragment_unnamed_1684 = asfloat(1065353216u);
					fragment_unnamed_1685 = asfloat(1065353216u);
				}
				float fragment_unnamed_1693 = clamp(fragment_unnamed_1540 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1697 = mad(clamp(fragment_unnamed_1540 * 0.1500000059604644775390625f, 0.0f, 1.0f), mad((-0.0f) - fragment_unnamed_1442, fragment_unnamed_1435, 1.0f), fragment_unnamed_1435 * fragment_unnamed_1442) * 0.800000011920928955078125f;
				float fragment_unnamed_1709 = min(max((((-0.0f) - fragment_uniform_buffer_0[15u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1718 = mad(clamp(mad(log2(fragment_uniform_buffer_0[15u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1735 = mad(exp2(log2(fragment_uniform_buffer_0[10u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1738 = mad(exp2(log2(fragment_uniform_buffer_0[10u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1739 = mad(exp2(log2(fragment_uniform_buffer_0[10u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1771 = mad(exp2(log2(fragment_uniform_buffer_0[11u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1772 = mad(exp2(log2(fragment_uniform_buffer_0[11u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1773 = mad(exp2(log2(fragment_uniform_buffer_0[11u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1783 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1771) + 0.0240000002086162567138671875f, fragment_unnamed_1771);
				float fragment_unnamed_1784 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1772) + 0.0240000002086162567138671875f, fragment_unnamed_1772);
				float fragment_unnamed_1785 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1773) + 0.0240000002086162567138671875f, fragment_unnamed_1773);
				float fragment_unnamed_1801 = mad(exp2(log2(fragment_uniform_buffer_0[12u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1802 = mad(exp2(log2(fragment_uniform_buffer_0[12u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1803 = mad(exp2(log2(fragment_uniform_buffer_0[12u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1816 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1801, fragment_unnamed_1709, 0.0240000002086162567138671875f), fragment_unnamed_1709 * fragment_unnamed_1801);
				float fragment_unnamed_1817 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1802, fragment_unnamed_1709, 0.0240000002086162567138671875f), fragment_unnamed_1709 * fragment_unnamed_1802);
				float fragment_unnamed_1818 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1803, fragment_unnamed_1709, 0.0240000002086162567138671875f), fragment_unnamed_1709 * fragment_unnamed_1803);
				float fragment_unnamed_1819 = dot(float3(fragment_unnamed_1783, fragment_unnamed_1784, fragment_unnamed_1785), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1828 = mad(((-0.0f) - fragment_unnamed_1783) + fragment_unnamed_1819, 0.300000011920928955078125f, fragment_unnamed_1783);
				float fragment_unnamed_1829 = mad(((-0.0f) - fragment_unnamed_1784) + fragment_unnamed_1819, 0.300000011920928955078125f, fragment_unnamed_1784);
				float fragment_unnamed_1830 = mad(((-0.0f) - fragment_unnamed_1785) + fragment_unnamed_1819, 0.300000011920928955078125f, fragment_unnamed_1785);
				float fragment_unnamed_1831 = dot(float3(fragment_unnamed_1816, fragment_unnamed_1817, fragment_unnamed_1818), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1840 = mad(((-0.0f) - fragment_unnamed_1816) + fragment_unnamed_1831, 0.300000011920928955078125f, fragment_unnamed_1816);
				float fragment_unnamed_1841 = mad(((-0.0f) - fragment_unnamed_1817) + fragment_unnamed_1831, 0.300000011920928955078125f, fragment_unnamed_1817);
				float fragment_unnamed_1842 = mad(((-0.0f) - fragment_unnamed_1818) + fragment_unnamed_1831, 0.300000011920928955078125f, fragment_unnamed_1818);
				bool fragment_unnamed_1843 = 0.0f < fragment_unnamed_1540;
				float fragment_unnamed_1856 = clamp(mad(fragment_unnamed_1540, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1857 = clamp(mad(fragment_unnamed_1540, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1881 = clamp(mad(dot(float3(fragment_unnamed_1475, fragment_unnamed_1476, fragment_unnamed_1477), float3(fragment_unnamed_1112, fragment_unnamed_1113, fragment_unnamed_1114)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1885 = asfloat(asuint(fragment_uniform_buffer_0[14u]).x) + 1.0f;
				float fragment_unnamed_1892 = dot(float3((-0.0f) - fragment_unnamed_1198, (-0.0f) - fragment_unnamed_1199, (-0.0f) - fragment_unnamed_1200), float3(fragment_unnamed_1475, fragment_unnamed_1476, fragment_unnamed_1477));
				float fragment_unnamed_1896 = (-0.0f) - (fragment_unnamed_1892 + fragment_unnamed_1892);
				float fragment_unnamed_1900 = mad(fragment_unnamed_1475, fragment_unnamed_1896, (-0.0f) - fragment_unnamed_1198);
				float fragment_unnamed_1901 = mad(fragment_unnamed_1476, fragment_unnamed_1896, (-0.0f) - fragment_unnamed_1199);
				float fragment_unnamed_1902 = mad(fragment_unnamed_1477, fragment_unnamed_1896, (-0.0f) - fragment_unnamed_1200);
				uint fragment_unnamed_1918 = (fragment_uniform_buffer_0[29u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1933 = sqrt(dot(float3(fragment_uniform_buffer_0[29u].xyz), float3(fragment_uniform_buffer_0[29u].xyz))) + (-5.0f);
				float fragment_unnamed_1949 = clamp(dot(float3((-0.0f) - fragment_unnamed_1112, (-0.0f) - fragment_unnamed_1113, (-0.0f) - fragment_unnamed_1114), float3(fragment_uniform_buffer_0[16u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_1933, 0.0f, 1.0f);
				float fragment_unnamed_1958 = mad((-0.0f) - fragment_unnamed_1112, fragment_unnamed_1933, fragment_uniform_buffer_0[29u].x);
				float fragment_unnamed_1959 = mad((-0.0f) - fragment_unnamed_1113, fragment_unnamed_1933, fragment_uniform_buffer_0[29u].y);
				float fragment_unnamed_1960 = mad((-0.0f) - fragment_unnamed_1114, fragment_unnamed_1933, fragment_uniform_buffer_0[29u].z);
				float fragment_unnamed_1964 = sqrt(dot(float3(fragment_unnamed_1958, fragment_unnamed_1959, fragment_unnamed_1960), float3(fragment_unnamed_1958, fragment_unnamed_1959, fragment_unnamed_1960)));
				float fragment_unnamed_1970 = max((((-0.0f) - fragment_unnamed_1964) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1972 = fragment_unnamed_1964 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_1987 = fragment_unnamed_1949 * ((fragment_unnamed_1970 * fragment_unnamed_1970) * clamp(dot(float3(fragment_unnamed_1958 / fragment_unnamed_1964, fragment_unnamed_1959 / fragment_unnamed_1964, fragment_unnamed_1960 / fragment_unnamed_1964), float3(fragment_unnamed_1475, fragment_unnamed_1476, fragment_unnamed_1477)), 0.0f, 1.0f));
				float fragment_unnamed_2006 = clamp(fragment_unnamed_1164 * mad(fragment_unnamed_814.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_880) + 1.0f, fragment_unnamed_880), 0.0f, 1.0f);
				float fragment_unnamed_2012 = exp2(log2(fragment_unnamed_1857 * max(dot(float3(fragment_unnamed_1900, fragment_unnamed_1901, fragment_unnamed_1902), float3(fragment_uniform_buffer_0[16u].xyz)), 0.0f)) * exp2(fragment_unnamed_2006 * 6.906890392303466796875f));
				uint fragment_unnamed_2029 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1112, fragment_unnamed_1113, fragment_unnamed_1114), float3(fragment_unnamed_1112, fragment_unnamed_1113, fragment_unnamed_1114))) ? 4294967295u : 0u;
				float fragment_unnamed_2037 = mad(fragment_unnamed_1112, 1.0f, (-0.0f) - (fragment_unnamed_1113 * 0.0f));
				float fragment_unnamed_2038 = mad(fragment_unnamed_1113, 0.0f, (-0.0f) - (fragment_unnamed_1114 * 1.0f));
				float fragment_unnamed_2043 = rsqrt(dot(float2(fragment_unnamed_2037, fragment_unnamed_2038), float2(fragment_unnamed_2037, fragment_unnamed_2038)));
				bool fragment_unnamed_2047 = (fragment_unnamed_2029 & ((fragment_unnamed_1113 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2052 = asfloat(fragment_unnamed_2047 ? asuint(fragment_unnamed_2043 * fragment_unnamed_2037) : 0u);
				float fragment_unnamed_2054 = asfloat(fragment_unnamed_2047 ? asuint(fragment_unnamed_2043 * fragment_unnamed_2038) : 1065353216u);
				float fragment_unnamed_2056 = asfloat(fragment_unnamed_2047 ? asuint(fragment_unnamed_2043 * mad(fragment_unnamed_1114, 0.0f, (-0.0f) - (fragment_unnamed_1112 * 0.0f))) : 0u);
				float fragment_unnamed_2069 = mad(fragment_unnamed_2056, fragment_unnamed_1114, (-0.0f) - (fragment_unnamed_1113 * fragment_unnamed_2052));
				float fragment_unnamed_2070 = mad(fragment_unnamed_2052, fragment_unnamed_1112, (-0.0f) - (fragment_unnamed_1114 * fragment_unnamed_2054));
				float fragment_unnamed_2071 = mad(fragment_unnamed_2054, fragment_unnamed_1113, (-0.0f) - (fragment_unnamed_1112 * fragment_unnamed_2056));
				float fragment_unnamed_2075 = rsqrt(dot(float3(fragment_unnamed_2069, fragment_unnamed_2070, fragment_unnamed_2071), float3(fragment_unnamed_2069, fragment_unnamed_2070, fragment_unnamed_2071)));
				bool fragment_unnamed_2087 = (fragment_unnamed_2029 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2052, fragment_unnamed_2054), float2(fragment_unnamed_2052, fragment_unnamed_2054))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2105 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1902, fragment_unnamed_1900), float2((-0.0f) - fragment_unnamed_2052, (-0.0f) - fragment_unnamed_2054)), dot(float3(fragment_unnamed_1900, fragment_unnamed_1901, fragment_unnamed_1902), float3(fragment_unnamed_1112, fragment_unnamed_1113, fragment_unnamed_1114)), dot(float3(fragment_unnamed_1900, fragment_unnamed_1901, fragment_unnamed_1902), float3(fragment_unnamed_2087 ? ((-0.0f) - (fragment_unnamed_2075 * fragment_unnamed_2069)) : (-0.0f), fragment_unnamed_2087 ? ((-0.0f) - (fragment_unnamed_2075 * fragment_unnamed_2070)) : (-0.0f), fragment_unnamed_2087 ? ((-0.0f) - (fragment_unnamed_2075 * fragment_unnamed_2071)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2006) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2124 = mad(fragment_unnamed_1857, ((-0.0f) - fragment_uniform_buffer_0[13u].y) + fragment_uniform_buffer_0[13u].x, fragment_uniform_buffer_0[13u].y);
				float fragment_unnamed_2128 = dot(float3(fragment_unnamed_2124 * (fragment_unnamed_2006 * fragment_unnamed_2105.x), fragment_unnamed_2124 * (fragment_unnamed_2006 * fragment_unnamed_2105.y), fragment_unnamed_2124 * (fragment_unnamed_2006 * fragment_unnamed_2105.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2149 = fragment_unnamed_2128 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1136, 0.7200000286102294921875f, fragment_unnamed_1121), 0.14000000059604644775390625f, fragment_unnamed_1130 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1014), fragment_unnamed_1014), asfloat(fragment_unnamed_1918 & (fragment_unnamed_1972 ? asuint(fragment_unnamed_1949 * 1.2999999523162841796875f) : asuint(fragment_unnamed_1987 * 1.2999999523162841796875f))) + mad(fragment_unnamed_1534 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1498, 1.0f) * fragment_unnamed_1683), fragment_unnamed_1697, fragment_unnamed_1517 * (fragment_unnamed_1885 * (fragment_unnamed_1881 * asfloat(fragment_unnamed_1843 ? asuint(mad(fragment_unnamed_1693, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1735, fragment_unnamed_1718, 0.0240000002086162567138671875f), fragment_unnamed_1718 * fragment_unnamed_1735) + ((-0.0f) - fragment_unnamed_1828), fragment_unnamed_1828)) : asuint(mad(fragment_unnamed_1856, fragment_unnamed_1828 + ((-0.0f) - fragment_unnamed_1840), fragment_unnamed_1840)))))), (fragment_unnamed_2006 * ((fragment_unnamed_1164 * mad(fragment_unnamed_822, mad(fragment_unnamed_814.x, fragment_unnamed_824, (-0.0f) - fragment_uniform_buffer_0[8u].x), fragment_uniform_buffer_0[8u].x)) * fragment_unnamed_2012)) * 0.5f);
				float fragment_unnamed_2150 = fragment_unnamed_2128 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1136, 0.85000002384185791015625f, fragment_unnamed_1122), 0.14000000059604644775390625f, fragment_unnamed_1130 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1015), fragment_unnamed_1015), asfloat(fragment_unnamed_1918 & (fragment_unnamed_1972 ? asuint(fragment_unnamed_1949 * 1.10000002384185791015625f) : asuint(fragment_unnamed_1987 * 1.10000002384185791015625f))) + mad(fragment_unnamed_1534 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1499, 1.0f) * fragment_unnamed_1684), fragment_unnamed_1697, fragment_unnamed_1517 * (fragment_unnamed_1885 * (fragment_unnamed_1881 * asfloat(fragment_unnamed_1843 ? asuint(mad(fragment_unnamed_1693, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1738, fragment_unnamed_1718, 0.0240000002086162567138671875f), fragment_unnamed_1718 * fragment_unnamed_1738) + ((-0.0f) - fragment_unnamed_1829), fragment_unnamed_1829)) : asuint(mad(fragment_unnamed_1856, fragment_unnamed_1829 + ((-0.0f) - fragment_unnamed_1841), fragment_unnamed_1841)))))), (fragment_unnamed_2006 * ((fragment_unnamed_1164 * mad(fragment_unnamed_822, mad(fragment_unnamed_814.y, fragment_unnamed_824, (-0.0f) - fragment_uniform_buffer_0[8u].y), fragment_uniform_buffer_0[8u].y)) * fragment_unnamed_2012)) * 0.5f);
				float fragment_unnamed_2151 = fragment_unnamed_2128 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1136, 1.0f, fragment_unnamed_1123), 0.14000000059604644775390625f, fragment_unnamed_1130 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1016), fragment_unnamed_1016), asfloat(fragment_unnamed_1918 & (fragment_unnamed_1972 ? asuint(fragment_unnamed_1949 * 0.60000002384185791015625f) : asuint(fragment_unnamed_1987 * 0.60000002384185791015625f))) + mad(fragment_unnamed_1534 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1500, 1.0f) * fragment_unnamed_1685), fragment_unnamed_1697, fragment_unnamed_1517 * (fragment_unnamed_1885 * (fragment_unnamed_1881 * asfloat(fragment_unnamed_1843 ? asuint(mad(fragment_unnamed_1693, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1739, fragment_unnamed_1718, 0.0240000002086162567138671875f), fragment_unnamed_1718 * fragment_unnamed_1739) + ((-0.0f) - fragment_unnamed_1830), fragment_unnamed_1830)) : asuint(mad(fragment_unnamed_1856, fragment_unnamed_1830 + ((-0.0f) - fragment_unnamed_1842), fragment_unnamed_1842)))))), (fragment_unnamed_2006 * ((fragment_unnamed_1164 * mad(fragment_unnamed_822, mad(fragment_unnamed_814.z, fragment_unnamed_824, (-0.0f) - fragment_uniform_buffer_0[8u].z), fragment_uniform_buffer_0[8u].z)) * fragment_unnamed_2012)) * 0.5f);
				fragment_output_0.x = mad(fragment_unnamed_985, ((-0.0f) - fragment_unnamed_1007) + fragment_unnamed_2149, fragment_unnamed_1007);
				fragment_output_0.y = mad(fragment_unnamed_985, ((-0.0f) - fragment_unnamed_1008) + fragment_unnamed_2150, fragment_unnamed_1008);
				fragment_output_0.z = mad(fragment_unnamed_985, ((-0.0f) - fragment_unnamed_1009) + fragment_unnamed_2151, fragment_unnamed_1009);
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				fragment_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				fragment_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				fragment_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				fragment_uniform_buffer_0[8] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[9] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[10] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[11] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[12] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[13] = float4(_GIStrengthDay, fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], _GIStrengthNight, fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], _Multiplier);

				fragment_uniform_buffer_0[14] = float4(_AmbientInc, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], _MaterialIndex, fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], fragment_uniform_buffer_0[15][1], _Distance, fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[16][3]);

				fragment_uniform_buffer_0[17] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[18] = float4(_LatitudeCount, fragment_uniform_buffer_0[18][1], fragment_uniform_buffer_0[18][2], fragment_uniform_buffer_0[18][3]);

				fragment_uniform_buffer_0[19] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[19][1], fragment_uniform_buffer_0[19][2], fragment_uniform_buffer_0[19][3]);

				fragment_uniform_buffer_0[20] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[21] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[22] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[29] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // POINT
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT_COOKIE
			#endif // !SPOT


			#ifdef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[26];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;
			Texture2D<float4> _PaintingTexture;
			SamplerState sampler_PaintingTexture;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float3 fragment_input_9;
			static float4 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD; // TEXCOORD
				float3 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float3 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float4 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD12; // TEXCOORD_12
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2125)
			{
				if (fragment_unnamed_2125)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_120 = rsqrt(dot(float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z), float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z)));
				float fragment_unnamed_127 = fragment_unnamed_120 * fragment_input_5.y;
				float fragment_unnamed_128 = fragment_unnamed_120 * fragment_input_5.x;
				float fragment_unnamed_129 = fragment_unnamed_120 * fragment_input_5.z;
				uint fragment_unnamed_138 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_144 = sqrt(((-0.0f) - abs(fragment_unnamed_127)) + 1.0f);
				float fragment_unnamed_153 = mad(mad(mad(abs(fragment_unnamed_127), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_127), -0.212114393711090087890625f), abs(fragment_unnamed_127), 1.570728778839111328125f);
				float fragment_unnamed_178 = (1.0f / max(abs(fragment_unnamed_129), abs(fragment_unnamed_128))) * min(abs(fragment_unnamed_129), abs(fragment_unnamed_128));
				float fragment_unnamed_179 = fragment_unnamed_178 * fragment_unnamed_178;
				float fragment_unnamed_187 = mad(fragment_unnamed_179, mad(fragment_unnamed_179, mad(fragment_unnamed_179, mad(fragment_unnamed_179, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_205 = asfloat(((((-0.0f) - fragment_unnamed_129) < fragment_unnamed_129) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_178, fragment_unnamed_187, asfloat(((abs(fragment_unnamed_129) < abs(fragment_unnamed_128)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_187 * fragment_unnamed_178, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_207 = min((-0.0f) - fragment_unnamed_129, fragment_unnamed_128);
				float fragment_unnamed_209 = max((-0.0f) - fragment_unnamed_129, fragment_unnamed_128);
				float fragment_unnamed_223 = (((-0.0f) - mad(fragment_unnamed_153, fragment_unnamed_144, asfloat(((fragment_unnamed_127 < ((-0.0f) - fragment_unnamed_127)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_144 * fragment_unnamed_153, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_224 = fragment_unnamed_223 * 0.3183098733425140380859375f;
				bool fragment_unnamed_226 = 0.0f < fragment_unnamed_223;
				float fragment_unnamed_233 = asfloat(fragment_unnamed_226 ? asuint(ceil(fragment_unnamed_224)) : asuint(floor(fragment_unnamed_224)));
				float fragment_unnamed_237 = float(fragment_unnamed_138);
				uint fragment_unnamed_245 = uint(asfloat((0.0f < fragment_unnamed_233) ? asuint(fragment_unnamed_233 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_233) + fragment_unnamed_237) + (-0.89999997615814208984375f))));
				int fragment_unnamed_248 = _OffsetsBuffer.Load(fragment_unnamed_245);
				float fragment_unnamed_255 = float((-fragment_unnamed_248) + _OffsetsBuffer.Load(fragment_unnamed_245 + 1u));
				float fragment_unnamed_256 = mad(((((fragment_unnamed_209 >= ((-0.0f) - fragment_unnamed_209)) ? 4294967295u : 0u) & ((fragment_unnamed_207 < ((-0.0f) - fragment_unnamed_207)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_205) : fragment_unnamed_205, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_258 = fragment_unnamed_255 * fragment_unnamed_256;
				bool fragment_unnamed_259 = 0.0f < fragment_unnamed_258;
				float fragment_unnamed_265 = asfloat(fragment_unnamed_259 ? asuint(ceil(fragment_unnamed_258)) : asuint(floor(fragment_unnamed_258)));
				float fragment_unnamed_266 = mad(fragment_unnamed_255, 0.5f, 0.5f);
				float fragment_unnamed_282 = float(fragment_unnamed_248 + uint(asfloat((fragment_unnamed_266 < fragment_unnamed_265) ? asuint(mad((-0.0f) - fragment_unnamed_255, 0.5f, fragment_unnamed_265) + (-1.0f)) : asuint(fragment_unnamed_255 + ((-0.0f) - fragment_unnamed_265))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_285 = frac(fragment_unnamed_282);
				uint fragment_unnamed_288 = _DataBuffer.Load(uint(floor(fragment_unnamed_282)));
				uint fragment_unnamed_300 = 16u & 31u;
				uint fragment_unnamed_307 = 8u & 31u;
				uint fragment_unnamed_315 = (0.625f < fragment_unnamed_285) ? (fragment_unnamed_288 >> 24u) : ((0.375f < fragment_unnamed_285) ? spvBitfieldUExtract(fragment_unnamed_288, fragment_unnamed_300, min((8u & 31u), (32u - fragment_unnamed_300))) : ((0.125f < fragment_unnamed_285) ? spvBitfieldUExtract(fragment_unnamed_288, fragment_unnamed_307, min((8u & 31u), (32u - fragment_unnamed_307))) : (fragment_unnamed_288 & 255u)));
				float fragment_unnamed_322 = float(fragment_unnamed_315 >> 5u);
				float fragment_unnamed_329 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(fragment_unnamed_322 < (fragment_unnamed_329 + 0.00999999977648258209228515625f));
				uint reform_index = fragment_unnamed_282 * 4;
				bool is_reform_transparent = (fragment_unnamed_329 + 3.9900000095367431640625f) < fragment_unnamed_322;
				uint n_index = frac(fragment_uniform_buffer_0[14u].x / 2 - fragment_unnamed_224) * 8;
				uint m_index = frac(fragment_unnamed_258) * 8;
				float4 fragment_unnamed_809 = is_reform_transparent ? _PaintingTexture.Sample(sampler_ColorsTexture, float2((reform_index % 512 * 8 + m_index + 0.5f) / 4096.0f, 1 - (reform_index / 512 * 8 + n_index + 0.5f) / 5088.0f)) : _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_315 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				discard_cond(is_reform_transparent && fragment_unnamed_809.w < 0.0001);
				float fragment_unnamed_348 = mad(fragment_unnamed_223, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_349 = mad(fragment_unnamed_223, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_360 = asfloat(fragment_unnamed_226 ? asuint(ceil(fragment_unnamed_348)) : asuint(floor(fragment_unnamed_348)));
				float fragment_unnamed_362 = asfloat(fragment_unnamed_226 ? asuint(ceil(fragment_unnamed_349)) : asuint(floor(fragment_unnamed_349)));
				uint fragment_unnamed_364 = uint(ceil(max(abs(fragment_unnamed_224) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_383 = uint(asfloat((0.0f < fragment_unnamed_360) ? asuint(fragment_unnamed_360 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_237 + ((-0.0f) - fragment_unnamed_360)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_384 = uint(asfloat((0.0f < fragment_unnamed_362) ? asuint(fragment_unnamed_362 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_237 + ((-0.0f) - fragment_unnamed_362)) + (-0.89999997615814208984375f))));
				int fragment_unnamed_386 = _OffsetsBuffer.Load(fragment_unnamed_383);
				int fragment_unnamed_388 = _OffsetsBuffer.Load(fragment_unnamed_384);
				uint fragment_unnamed_399 = (fragment_unnamed_245 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_402 = (fragment_unnamed_245 != (fragment_unnamed_138 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_405 = (fragment_unnamed_138 != fragment_unnamed_245) ? 4294967295u : 0u;
				uint fragment_unnamed_409 = (fragment_unnamed_245 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_425 = (fragment_unnamed_409 & (fragment_unnamed_405 & (fragment_unnamed_399 & fragment_unnamed_402))) != 0u;
				uint fragment_unnamed_428 = asuint(fragment_unnamed_255);
				float fragment_unnamed_430 = asfloat(fragment_unnamed_425 ? asuint(float((-fragment_unnamed_386) + _OffsetsBuffer.Load(fragment_unnamed_383 + 1u))) : fragment_unnamed_428);
				float fragment_unnamed_432 = asfloat(fragment_unnamed_425 ? asuint(float((-fragment_unnamed_388) + _OffsetsBuffer.Load(fragment_unnamed_384 + 1u))) : fragment_unnamed_428);
				float fragment_unnamed_434 = fragment_unnamed_256 * fragment_unnamed_430;
				float fragment_unnamed_435 = fragment_unnamed_256 * fragment_unnamed_432;
				float fragment_unnamed_436 = mad(fragment_unnamed_256, fragment_unnamed_255, 0.5f);
				float fragment_unnamed_437 = mad(fragment_unnamed_256, fragment_unnamed_255, -0.5f);
				float fragment_unnamed_444 = asfloat((fragment_unnamed_255 < fragment_unnamed_436) ? asuint(((-0.0f) - fragment_unnamed_255) + fragment_unnamed_436) : asuint(fragment_unnamed_436));
				float fragment_unnamed_450 = asfloat((fragment_unnamed_437 < 0.0f) ? asuint(fragment_unnamed_255 + fragment_unnamed_437) : asuint(fragment_unnamed_437));
				float fragment_unnamed_460 = asfloat(fragment_unnamed_259 ? asuint(ceil(fragment_unnamed_434)) : asuint(floor(fragment_unnamed_434)));
				float fragment_unnamed_462 = asfloat(fragment_unnamed_259 ? asuint(ceil(fragment_unnamed_435)) : asuint(floor(fragment_unnamed_435)));
				float fragment_unnamed_468 = asfloat(fragment_unnamed_259 ? asuint(ceil(fragment_unnamed_444)) : asuint(floor(fragment_unnamed_444)));
				float fragment_unnamed_474 = asfloat(fragment_unnamed_259 ? asuint(ceil(fragment_unnamed_450)) : asuint(floor(fragment_unnamed_450)));
				float fragment_unnamed_475 = frac(fragment_unnamed_224);
				float fragment_unnamed_476 = frac(fragment_unnamed_258);
				float fragment_unnamed_477 = fragment_unnamed_475 + (-0.5f);
				float fragment_unnamed_486 = min((((-0.0f) - fragment_unnamed_476) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_488 = min(fragment_unnamed_476 * 40.0f, 1.0f);
				float fragment_unnamed_489 = min(fragment_unnamed_475 * 40.0f, 1.0f);
				float fragment_unnamed_545 = float(fragment_unnamed_386 + uint(asfloat((mad(fragment_unnamed_430, 0.5f, 0.5f) < fragment_unnamed_460) ? asuint(mad((-0.0f) - fragment_unnamed_430, 0.5f, fragment_unnamed_460) + (-1.0f)) : asuint(fragment_unnamed_430 + ((-0.0f) - fragment_unnamed_460))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_547 = frac(fragment_unnamed_545);
				uint fragment_unnamed_550 = _DataBuffer.Load(uint(floor(fragment_unnamed_545)));
				uint fragment_unnamed_556 = 16u & 31u;
				uint fragment_unnamed_561 = 8u & 31u;
				float fragment_unnamed_571 = float(uint(asfloat((mad(fragment_unnamed_432, 0.5f, 0.5f) < fragment_unnamed_462) ? asuint(mad((-0.0f) - fragment_unnamed_432, 0.5f, fragment_unnamed_462) + (-1.0f)) : asuint(fragment_unnamed_432 + ((-0.0f) - fragment_unnamed_462))) + 0.100000001490116119384765625f) + fragment_unnamed_388) * 0.25f;
				float fragment_unnamed_573 = frac(fragment_unnamed_571);
				uint fragment_unnamed_576 = _DataBuffer.Load(uint(floor(fragment_unnamed_571)));
				uint fragment_unnamed_582 = 16u & 31u;
				uint fragment_unnamed_587 = 8u & 31u;
				float fragment_unnamed_597 = float(uint(asfloat((fragment_unnamed_266 < fragment_unnamed_468) ? asuint(mad((-0.0f) - fragment_unnamed_255, 0.5f, fragment_unnamed_468) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_468) + fragment_unnamed_255)) + 0.100000001490116119384765625f) + fragment_unnamed_248) * 0.25f;
				float fragment_unnamed_599 = frac(fragment_unnamed_597);
				uint fragment_unnamed_602 = _DataBuffer.Load(uint(floor(fragment_unnamed_597)));
				uint fragment_unnamed_608 = 16u & 31u;
				uint fragment_unnamed_613 = 8u & 31u;
				float fragment_unnamed_623 = float(uint(asfloat((fragment_unnamed_266 < fragment_unnamed_474) ? asuint(mad((-0.0f) - fragment_unnamed_255, 0.5f, fragment_unnamed_474) + (-1.0f)) : asuint(fragment_unnamed_255 + ((-0.0f) - fragment_unnamed_474))) + 0.100000001490116119384765625f) + fragment_unnamed_248) * 0.25f;
				float fragment_unnamed_625 = frac(fragment_unnamed_623);
				uint fragment_unnamed_628 = _DataBuffer.Load(uint(floor(fragment_unnamed_623)));
				uint fragment_unnamed_634 = 16u & 31u;
				uint fragment_unnamed_639 = 8u & 31u;
				float fragment_unnamed_649 = float(((0.625f < fragment_unnamed_573) ? (fragment_unnamed_576 >> 24u) : ((0.375f < fragment_unnamed_573) ? spvBitfieldUExtract(fragment_unnamed_576, fragment_unnamed_582, min((8u & 31u), (32u - fragment_unnamed_582))) : ((0.125f < fragment_unnamed_573) ? spvBitfieldUExtract(fragment_unnamed_576, fragment_unnamed_587, min((8u & 31u), (32u - fragment_unnamed_587))) : (fragment_unnamed_576 & 255u)))) >> 5u);
				float fragment_unnamed_651 = float(((0.625f < fragment_unnamed_599) ? (fragment_unnamed_602 >> 24u) : ((0.375f < fragment_unnamed_599) ? spvBitfieldUExtract(fragment_unnamed_602, fragment_unnamed_608, min((8u & 31u), (32u - fragment_unnamed_608))) : ((0.125f < fragment_unnamed_599) ? spvBitfieldUExtract(fragment_unnamed_602, fragment_unnamed_613, min((8u & 31u), (32u - fragment_unnamed_613))) : (fragment_unnamed_602 & 255u)))) >> 5u);
				float fragment_unnamed_653 = float(((0.625f < fragment_unnamed_625) ? (fragment_unnamed_628 >> 24u) : ((0.375f < fragment_unnamed_625) ? spvBitfieldUExtract(fragment_unnamed_628, fragment_unnamed_634, min((8u & 31u), (32u - fragment_unnamed_634))) : ((0.125f < fragment_unnamed_625) ? spvBitfieldUExtract(fragment_unnamed_628, fragment_unnamed_639, min((8u & 31u), (32u - fragment_unnamed_639))) : (fragment_unnamed_628 & 255u)))) >> 5u);
				float fragment_unnamed_654 = float(((0.625f < fragment_unnamed_547) ? (fragment_unnamed_550 >> 24u) : ((0.375f < fragment_unnamed_547) ? spvBitfieldUExtract(fragment_unnamed_550, fragment_unnamed_556, min((8u & 31u), (32u - fragment_unnamed_556))) : ((0.125f < fragment_unnamed_547) ? spvBitfieldUExtract(fragment_unnamed_550, fragment_unnamed_561, min((8u & 31u), (32u - fragment_unnamed_561))) : (fragment_unnamed_550 & 255u)))) >> 5u);
				float fragment_unnamed_665 = fragment_unnamed_258 * 0.20000000298023223876953125f;
				float fragment_unnamed_667 = fragment_unnamed_223 * 0.06366197764873504638671875f;
				float fragment_unnamed_669 = (fragment_unnamed_256 * float((-_OffsetsBuffer.Load(fragment_unnamed_364)) + _OffsetsBuffer.Load(fragment_unnamed_364 + 1u))) * 0.20000000298023223876953125f;
				float fragment_unnamed_676 = ddx_coarse(fragment_input_11.x);
				float fragment_unnamed_677 = ddx_coarse(fragment_input_11.y);
				float fragment_unnamed_678 = ddx_coarse(fragment_input_11.z);
				float fragment_unnamed_682 = sqrt(dot(float3(fragment_unnamed_676, fragment_unnamed_677, fragment_unnamed_678), float3(fragment_unnamed_676, fragment_unnamed_677, fragment_unnamed_678)));
				float fragment_unnamed_689 = ddy_coarse(fragment_input_11.x);
				float fragment_unnamed_690 = ddy_coarse(fragment_input_11.y);
				float fragment_unnamed_691 = ddy_coarse(fragment_input_11.z);
				float fragment_unnamed_695 = sqrt(dot(float3(fragment_unnamed_689, fragment_unnamed_690, fragment_unnamed_691), float3(fragment_unnamed_689, fragment_unnamed_690, fragment_unnamed_691)));
				float fragment_unnamed_706 = min(max(log2(sqrt(dot(float2(fragment_unnamed_682, fragment_unnamed_695), float2(fragment_unnamed_682, fragment_unnamed_695))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_708 = min((((-0.0f) - fragment_unnamed_475) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_775;
				float fragment_unnamed_777;
				float fragment_unnamed_779;
				float fragment_unnamed_781;
				float fragment_unnamed_783;
				float fragment_unnamed_785;
				float fragment_unnamed_787;
				float fragment_unnamed_789;
				float fragment_unnamed_791;
				float fragment_unnamed_793;
				float fragment_unnamed_795;
				float fragment_unnamed_797;
				float fragment_unnamed_799;
				float fragment_unnamed_801;
				if ((((((fragment_unnamed_329 + 0.9900000095367431640625f) < fragment_unnamed_322) ? 4294967295u : 0u) & ((fragment_unnamed_322 < (fragment_unnamed_329 + 1.0099999904632568359375f)) ? 4294967295u : 0u))) | (((fragment_unnamed_329 + 3.9900000095367431640625f) < fragment_unnamed_322) ? 4294967295u : 0u) != 0u)
				{
					float4 fragment_unnamed_721 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
					float4 fragment_unnamed_727 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
					float4 fragment_unnamed_734 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
					float fragment_unnamed_740 = mad(fragment_unnamed_734.w * fragment_unnamed_734.x, 2.0f, -1.0f);
					float fragment_unnamed_742 = mad(fragment_unnamed_734.y, 2.0f, -1.0f);
					float4 fragment_unnamed_750 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
					float fragment_unnamed_756 = mad(fragment_unnamed_750.w * fragment_unnamed_750.x, 2.0f, -1.0f);
					float fragment_unnamed_757 = mad(fragment_unnamed_750.y, 2.0f, -1.0f);
					fragment_unnamed_775 = fragment_unnamed_721.x;
					fragment_unnamed_777 = fragment_unnamed_721.y;
					fragment_unnamed_779 = fragment_unnamed_721.z;
					fragment_unnamed_781 = fragment_unnamed_727.x;
					fragment_unnamed_783 = fragment_unnamed_727.y;
					fragment_unnamed_785 = fragment_unnamed_727.z;
					fragment_unnamed_787 = fragment_unnamed_721.w;
					fragment_unnamed_789 = fragment_unnamed_727.w;
					fragment_unnamed_791 = fragment_unnamed_740;
					fragment_unnamed_793 = fragment_unnamed_742;
					fragment_unnamed_795 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_740, fragment_unnamed_742), float2(fragment_unnamed_740, fragment_unnamed_742)), 1.0f)) + 1.0f);
					fragment_unnamed_797 = fragment_unnamed_756;
					fragment_unnamed_799 = fragment_unnamed_757;
					fragment_unnamed_801 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_756, fragment_unnamed_757), float2(fragment_unnamed_756, fragment_unnamed_757)), 1.0f)) + 1.0f);
				}
				else
				{
					float fragment_unnamed_776;
					float fragment_unnamed_778;
					float fragment_unnamed_780;
					float fragment_unnamed_782;
					float fragment_unnamed_784;
					float fragment_unnamed_786;
					float fragment_unnamed_788;
					float fragment_unnamed_790;
					float fragment_unnamed_792;
					float fragment_unnamed_794;
					float fragment_unnamed_796;
					float fragment_unnamed_798;
					float fragment_unnamed_800;
					float fragment_unnamed_802;
					if (((((fragment_unnamed_329 + 1.9900000095367431640625f) < fragment_unnamed_322) ? 4294967295u : 0u) & ((fragment_unnamed_322 < (fragment_unnamed_329 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1201 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
						float4 fragment_unnamed_1207 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
						float4 fragment_unnamed_1214 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
						float fragment_unnamed_1220 = mad(fragment_unnamed_1214.w * fragment_unnamed_1214.x, 2.0f, -1.0f);
						float fragment_unnamed_1221 = mad(fragment_unnamed_1214.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1229 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
						float fragment_unnamed_1235 = mad(fragment_unnamed_1229.w * fragment_unnamed_1229.x, 2.0f, -1.0f);
						float fragment_unnamed_1236 = mad(fragment_unnamed_1229.y, 2.0f, -1.0f);
						fragment_unnamed_776 = fragment_unnamed_1201.x;
						fragment_unnamed_778 = fragment_unnamed_1201.y;
						fragment_unnamed_780 = fragment_unnamed_1201.z;
						fragment_unnamed_782 = fragment_unnamed_1207.x;
						fragment_unnamed_784 = fragment_unnamed_1207.y;
						fragment_unnamed_786 = fragment_unnamed_1207.z;
						fragment_unnamed_788 = fragment_unnamed_1201.w;
						fragment_unnamed_790 = fragment_unnamed_1207.w;
						fragment_unnamed_792 = fragment_unnamed_1220;
						fragment_unnamed_794 = fragment_unnamed_1221;
						fragment_unnamed_796 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1220, fragment_unnamed_1221), float2(fragment_unnamed_1220, fragment_unnamed_1221)), 1.0f)) + 1.0f);
						fragment_unnamed_798 = fragment_unnamed_1235;
						fragment_unnamed_800 = fragment_unnamed_1236;
						fragment_unnamed_802 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1235, fragment_unnamed_1236), float2(fragment_unnamed_1235, fragment_unnamed_1236)), 1.0f)) + 1.0f);
					}
					else
					{
						float4 fragment_unnamed_1245 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
						float4 fragment_unnamed_1251 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
						float4 fragment_unnamed_1258 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_667, fragment_unnamed_665), fragment_unnamed_706);
						float fragment_unnamed_1264 = mad(fragment_unnamed_1258.w * fragment_unnamed_1258.x, 2.0f, -1.0f);
						float fragment_unnamed_1265 = mad(fragment_unnamed_1258.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1273 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_667, fragment_unnamed_669), fragment_unnamed_706);
						float fragment_unnamed_1279 = mad(fragment_unnamed_1273.w * fragment_unnamed_1273.x, 2.0f, -1.0f);
						float fragment_unnamed_1280 = mad(fragment_unnamed_1273.y, 2.0f, -1.0f);
						fragment_unnamed_776 = fragment_unnamed_1245.x;
						fragment_unnamed_778 = fragment_unnamed_1245.y;
						fragment_unnamed_780 = fragment_unnamed_1245.z;
						fragment_unnamed_782 = fragment_unnamed_1251.x;
						fragment_unnamed_784 = fragment_unnamed_1251.y;
						fragment_unnamed_786 = fragment_unnamed_1251.z;
						fragment_unnamed_788 = fragment_unnamed_1245.w;
						fragment_unnamed_790 = fragment_unnamed_1251.w;
						fragment_unnamed_792 = fragment_unnamed_1264;
						fragment_unnamed_794 = fragment_unnamed_1265;
						fragment_unnamed_796 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1264, fragment_unnamed_1265), float2(fragment_unnamed_1264, fragment_unnamed_1265)), 1.0f)) + 1.0f);
						fragment_unnamed_798 = fragment_unnamed_1279;
						fragment_unnamed_800 = fragment_unnamed_1280;
						fragment_unnamed_802 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1279, fragment_unnamed_1280), float2(fragment_unnamed_1279, fragment_unnamed_1280)), 1.0f)) + 1.0f);
					}
					fragment_unnamed_775 = fragment_unnamed_776;
					fragment_unnamed_777 = fragment_unnamed_778;
					fragment_unnamed_779 = fragment_unnamed_780;
					fragment_unnamed_781 = fragment_unnamed_782;
					fragment_unnamed_783 = fragment_unnamed_784;
					fragment_unnamed_785 = fragment_unnamed_786;
					fragment_unnamed_787 = fragment_unnamed_788;
					fragment_unnamed_789 = fragment_unnamed_790;
					fragment_unnamed_791 = fragment_unnamed_792;
					fragment_unnamed_793 = fragment_unnamed_794;
					fragment_unnamed_795 = fragment_unnamed_796;
					fragment_unnamed_797 = fragment_unnamed_798;
					fragment_unnamed_799 = fragment_unnamed_800;
					fragment_unnamed_801 = fragment_unnamed_802;
				}
				float fragment_unnamed_817 = fragment_unnamed_809.w * 0.800000011920928955078125f;
				float fragment_unnamed_819 = mad(fragment_unnamed_809.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_827 = exp2(log2(abs(fragment_unnamed_477) + abs(fragment_unnamed_477)) * 10.0f);
				float fragment_unnamed_846 = mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_793) + fragment_unnamed_799, fragment_unnamed_793);
				float fragment_unnamed_847 = mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_791) + fragment_unnamed_797, fragment_unnamed_791);
				float fragment_unnamed_848 = mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_795) + fragment_unnamed_801, fragment_unnamed_795);
				float fragment_unnamed_849 = (fragment_unnamed_819 * fragment_unnamed_809.x) * mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_775) + fragment_unnamed_781, fragment_unnamed_775);
				float fragment_unnamed_850 = (fragment_unnamed_819 * fragment_unnamed_809.y) * mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_777) + fragment_unnamed_783, fragment_unnamed_777);
				float fragment_unnamed_851 = (fragment_unnamed_819 * fragment_unnamed_809.z) * mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_779) + fragment_unnamed_785, fragment_unnamed_779);
				float fragment_unnamed_858 = mad(fragment_unnamed_809.w, mad(fragment_unnamed_809.x, fragment_unnamed_819, (-0.0f) - fragment_unnamed_849), fragment_unnamed_849);
				float fragment_unnamed_859 = mad(fragment_unnamed_809.w, mad(fragment_unnamed_809.y, fragment_unnamed_819, (-0.0f) - fragment_unnamed_850), fragment_unnamed_850);
				float fragment_unnamed_860 = mad(fragment_unnamed_809.w, mad(fragment_unnamed_809.z, fragment_unnamed_819, (-0.0f) - fragment_unnamed_851), fragment_unnamed_851);
				float fragment_unnamed_862 = ((-0.0f) - mad(fragment_unnamed_827, ((-0.0f) - fragment_unnamed_787) + fragment_unnamed_789, fragment_unnamed_787)) + 1.0f;
				float fragment_unnamed_867 = fragment_unnamed_862 * fragment_uniform_buffer_0[4u].w;
				float fragment_unnamed_876 = mad(fragment_unnamed_809.w, mad((-0.0f) - fragment_unnamed_862, fragment_uniform_buffer_0[4u].w, clamp(fragment_unnamed_867 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_867);
				bool fragment_unnamed_910 = (fragment_unnamed_402 & (fragment_unnamed_405 & (((fragment_unnamed_654 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_918 = fragment_unnamed_910 ? asuint(fragment_unnamed_708 * fragment_unnamed_858) : asuint(fragment_unnamed_858);
				uint fragment_unnamed_920 = fragment_unnamed_910 ? asuint(fragment_unnamed_708 * fragment_unnamed_859) : asuint(fragment_unnamed_859);
				uint fragment_unnamed_922 = fragment_unnamed_910 ? asuint(fragment_unnamed_708 * fragment_unnamed_860) : asuint(fragment_unnamed_860);
				uint fragment_unnamed_924 = fragment_unnamed_910 ? asuint(fragment_unnamed_708 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_935 = (fragment_unnamed_409 & (fragment_unnamed_399 & (((fragment_unnamed_649 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_940 = fragment_unnamed_935 ? asuint(fragment_unnamed_489 * asfloat(fragment_unnamed_918)) : fragment_unnamed_918;
				uint fragment_unnamed_942 = fragment_unnamed_935 ? asuint(fragment_unnamed_489 * asfloat(fragment_unnamed_920)) : fragment_unnamed_920;
				uint fragment_unnamed_944 = fragment_unnamed_935 ? asuint(fragment_unnamed_489 * asfloat(fragment_unnamed_922)) : fragment_unnamed_922;
				uint fragment_unnamed_946 = fragment_unnamed_935 ? asuint(fragment_unnamed_489 * asfloat(fragment_unnamed_924)) : fragment_unnamed_924;
				bool fragment_unnamed_955 = (((fragment_unnamed_651 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_960 = fragment_unnamed_955 ? asuint(fragment_unnamed_486 * asfloat(fragment_unnamed_940)) : fragment_unnamed_940;
				uint fragment_unnamed_962 = fragment_unnamed_955 ? asuint(fragment_unnamed_486 * asfloat(fragment_unnamed_942)) : fragment_unnamed_942;
				uint fragment_unnamed_964 = fragment_unnamed_955 ? asuint(fragment_unnamed_486 * asfloat(fragment_unnamed_944)) : fragment_unnamed_944;
				uint fragment_unnamed_966 = fragment_unnamed_955 ? asuint(fragment_unnamed_486 * asfloat(fragment_unnamed_946)) : fragment_unnamed_946;
				bool fragment_unnamed_975 = (((fragment_unnamed_653 < 0.00999999977648258209228515625f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_981 = asfloat(fragment_unnamed_975 ? asuint(fragment_unnamed_488 * asfloat(fragment_unnamed_966)) : fragment_unnamed_966);
				discard_cond((fragment_unnamed_981 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1001 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_10.x / fragment_input_10.w, fragment_input_10.y / fragment_input_10.w));
				float fragment_unnamed_1003 = fragment_unnamed_1001.x;
				float fragment_unnamed_1004 = fragment_unnamed_1001.y;
				float fragment_unnamed_1005 = fragment_unnamed_1001.z;
				float fragment_unnamed_1010 = asfloat(fragment_unnamed_975 ? asuint(fragment_unnamed_488 * asfloat(fragment_unnamed_960)) : fragment_unnamed_960) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1011 = asfloat(fragment_unnamed_975 ? asuint(fragment_unnamed_488 * asfloat(fragment_unnamed_962)) : fragment_unnamed_962) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1012 = asfloat(fragment_unnamed_975 ? asuint(fragment_unnamed_488 * asfloat(fragment_unnamed_964)) : fragment_unnamed_964) * fragment_uniform_buffer_0[9u].w;
				float fragment_unnamed_1024 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1025 = fragment_uniform_buffer_0[13u].z + fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1026 = fragment_uniform_buffer_0[13u].x + fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1027 = fragment_uniform_buffer_0[13u].y + fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1033 = fragment_unnamed_1026 * fragment_uniform_buffer_0[13u].x;
				float fragment_unnamed_1034 = fragment_unnamed_1027 * fragment_uniform_buffer_0[13u].y;
				float fragment_unnamed_1035 = fragment_unnamed_1025 * fragment_uniform_buffer_0[13u].z;
				float fragment_unnamed_1043 = fragment_unnamed_1026 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1044 = fragment_unnamed_1027 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1048 = fragment_unnamed_1025 * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1079 = mad(fragment_unnamed_1044 + (fragment_unnamed_1024 * fragment_uniform_buffer_0[13u].x), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1027, (-0.0f) - fragment_unnamed_1048), fragment_input_5.y, (((-0.0f) - (fragment_unnamed_1035 + fragment_unnamed_1034)) + 1.0f) * fragment_input_5.x));
				float fragment_unnamed_1097 = mad(mad(fragment_uniform_buffer_0[13u].y, fragment_unnamed_1025, (-0.0f) - fragment_unnamed_1043), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1027, fragment_unnamed_1048), fragment_input_5.x, (((-0.0f) - (fragment_unnamed_1035 + fragment_unnamed_1033)) + 1.0f) * fragment_input_5.y));
				float fragment_unnamed_1103 = mad(((-0.0f) - (fragment_unnamed_1034 + fragment_unnamed_1033)) + 1.0f, fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[13u].x, fragment_unnamed_1024, (-0.0f) - fragment_unnamed_1044), fragment_input_5.x, (fragment_unnamed_1043 + (fragment_unnamed_1025 * fragment_uniform_buffer_0[13u].y)) * fragment_input_5.y));
				float fragment_unnamed_1107 = rsqrt(dot(float3(fragment_unnamed_1079, fragment_unnamed_1097, fragment_unnamed_1103), float3(fragment_unnamed_1079, fragment_unnamed_1097, fragment_unnamed_1103)));
				float fragment_unnamed_1108 = fragment_unnamed_1107 * fragment_unnamed_1079;
				float fragment_unnamed_1109 = fragment_unnamed_1107 * fragment_unnamed_1097;
				float fragment_unnamed_1110 = fragment_unnamed_1107 * fragment_unnamed_1103;
				float fragment_unnamed_1117 = mad(mad(fragment_unnamed_809.x, fragment_unnamed_819, (-0.0f) - fragment_unnamed_1010), 0.5f, fragment_unnamed_1010);
				float fragment_unnamed_1118 = mad(mad(fragment_unnamed_809.y, fragment_unnamed_819, (-0.0f) - fragment_unnamed_1011), 0.5f, fragment_unnamed_1011);
				float fragment_unnamed_1119 = mad(mad(fragment_unnamed_809.z, fragment_unnamed_819, (-0.0f) - fragment_unnamed_1012), 0.5f, fragment_unnamed_1012);
				float fragment_unnamed_1120 = dot(float3(fragment_unnamed_1117, fragment_unnamed_1118, fragment_unnamed_1119), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1126 = mad(((-0.0f) - fragment_unnamed_1120) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1120);
				float fragment_unnamed_1132 = (-0.0f) - fragment_unnamed_1126;
				float fragment_unnamed_1160 = mad((-0.0f) - fragment_uniform_buffer_0[15u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1186 = ((-0.0f) - fragment_input_4.x) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1187 = ((-0.0f) - fragment_input_4.y) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1188 = ((-0.0f) - fragment_input_4.z) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1192 = rsqrt(dot(float3(fragment_unnamed_1186, fragment_unnamed_1187, fragment_unnamed_1188), float3(fragment_unnamed_1186, fragment_unnamed_1187, fragment_unnamed_1188)));
				float fragment_unnamed_1193 = fragment_unnamed_1192 * fragment_unnamed_1186;
				float fragment_unnamed_1194 = fragment_unnamed_1192 * fragment_unnamed_1187;
				float fragment_unnamed_1195 = fragment_unnamed_1192 * fragment_unnamed_1188;
				float fragment_unnamed_1378;
				float fragment_unnamed_1379;
				float fragment_unnamed_1380;
				float fragment_unnamed_1381;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1291 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1368 = _Global_PGI.Sample(sampler_Global_PGI, float3(max(mad(((fragment_unnamed_1291 ? (mad(fragment_uniform_buffer_3[3u].x, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : fragment_input_4.x) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), ((fragment_unnamed_1291 ? (mad(fragment_uniform_buffer_3[3u].y, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : fragment_input_4.y) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, ((fragment_unnamed_1291 ? (mad(fragment_uniform_buffer_3[3u].z, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : fragment_input_4.z) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1378 = fragment_unnamed_1368.x;
					fragment_unnamed_1379 = fragment_unnamed_1368.y;
					fragment_unnamed_1380 = fragment_unnamed_1368.z;
					fragment_unnamed_1381 = fragment_unnamed_1368.w;
				}
				else
				{
					fragment_unnamed_1378 = asfloat(1065353216u);
					fragment_unnamed_1379 = asfloat(1065353216u);
					fragment_unnamed_1380 = asfloat(1065353216u);
					fragment_unnamed_1381 = asfloat(1065353216u);
				}
				float fragment_unnamed_1392 = clamp(dot(float4(fragment_unnamed_1378, fragment_unnamed_1379, fragment_unnamed_1380, fragment_unnamed_1381), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float fragment_unnamed_1399 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_846, fragment_unnamed_847, fragment_unnamed_848));
				float fragment_unnamed_1408 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_846, fragment_unnamed_847, fragment_unnamed_848));
				float fragment_unnamed_1417 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_846, fragment_unnamed_847, fragment_unnamed_848));
				float fragment_unnamed_1423 = rsqrt(dot(float3(fragment_unnamed_1399, fragment_unnamed_1408, fragment_unnamed_1417), float3(fragment_unnamed_1399, fragment_unnamed_1408, fragment_unnamed_1417)));
				float fragment_unnamed_1424 = fragment_unnamed_1423 * fragment_unnamed_1399;
				float fragment_unnamed_1425 = fragment_unnamed_1423 * fragment_unnamed_1408;
				float fragment_unnamed_1426 = fragment_unnamed_1423 * fragment_unnamed_1417;
				float fragment_unnamed_1446 = ((-0.0f) - fragment_uniform_buffer_0[5u].x) + 1.0f;
				float fragment_unnamed_1447 = ((-0.0f) - fragment_uniform_buffer_0[5u].y) + 1.0f;
				float fragment_unnamed_1448 = ((-0.0f) - fragment_uniform_buffer_0[5u].z) + 1.0f;
				float fragment_unnamed_1461 = dot(float3(fragment_unnamed_1424, fragment_unnamed_1425, fragment_unnamed_1426), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1464 = mad(fragment_unnamed_1461, 0.25f, 1.0f);
				float fragment_unnamed_1466 = fragment_unnamed_1464 * (fragment_unnamed_1464 * fragment_unnamed_1464);
				float fragment_unnamed_1471 = exp2(log2(max(fragment_unnamed_1461, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1472 = fragment_unnamed_1471 + fragment_unnamed_1471;
				float fragment_unnamed_1483 = asfloat((0.5f < fragment_unnamed_1471) ? asuint(mad(log2(mad(log2(fragment_unnamed_1472), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1472)) * 0.5f;
				float fragment_unnamed_1489 = dot(float3(fragment_unnamed_1108, fragment_unnamed_1109, fragment_unnamed_1110), float3(fragment_uniform_buffer_0[12u].xyz));
				float fragment_unnamed_1631;
				float fragment_unnamed_1632;
				float fragment_unnamed_1633;
				if (1.0f >= fragment_unnamed_1489)
				{
					float fragment_unnamed_1510 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].x) + 1.0f), fragment_unnamed_1446, 1.0f);
					float fragment_unnamed_1511 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].y) + 1.0f), fragment_unnamed_1447, 1.0f);
					float fragment_unnamed_1512 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[16u].z) + 1.0f), fragment_unnamed_1448, 1.0f);
					float fragment_unnamed_1528 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].x) + 1.0f), fragment_unnamed_1446, 1.0f);
					float fragment_unnamed_1529 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].y) + 1.0f), fragment_unnamed_1447, 1.0f);
					float fragment_unnamed_1530 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[17u].z) + 1.0f), fragment_unnamed_1448, 1.0f);
					float fragment_unnamed_1559 = clamp((fragment_unnamed_1489 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1560 = clamp((fragment_unnamed_1489 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1561 = clamp((fragment_unnamed_1489 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1562 = clamp((fragment_unnamed_1489 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1585 = 0.20000000298023223876953125f < fragment_unnamed_1489;
					bool fragment_unnamed_1586 = 0.100000001490116119384765625f < fragment_unnamed_1489;
					bool fragment_unnamed_1587 = (-0.100000001490116119384765625f) < fragment_unnamed_1489;
					float fragment_unnamed_1588 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].x) + 1.0f), fragment_unnamed_1446, 1.0f) * 1.5f;
					float fragment_unnamed_1590 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].y) + 1.0f), fragment_unnamed_1447, 1.0f) * 1.5f;
					float fragment_unnamed_1591 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[18u].z) + 1.0f), fragment_unnamed_1448, 1.0f) * 1.5f;
					fragment_unnamed_1631 = asfloat(fragment_unnamed_1585 ? asuint(mad(fragment_unnamed_1559, ((-0.0f) - fragment_unnamed_1510) + 1.0f, fragment_unnamed_1510)) : (fragment_unnamed_1586 ? asuint(mad(fragment_unnamed_1560, mad((-0.0f) - fragment_unnamed_1528, 1.25f, fragment_unnamed_1510), fragment_unnamed_1528 * 1.25f)) : (fragment_unnamed_1587 ? asuint(mad(fragment_unnamed_1561, mad(fragment_unnamed_1528, 1.25f, (-0.0f) - fragment_unnamed_1588), fragment_unnamed_1588)) : asuint(fragment_unnamed_1588 * fragment_unnamed_1562))));
					fragment_unnamed_1632 = asfloat(fragment_unnamed_1585 ? asuint(mad(fragment_unnamed_1559, ((-0.0f) - fragment_unnamed_1511) + 1.0f, fragment_unnamed_1511)) : (fragment_unnamed_1586 ? asuint(mad(fragment_unnamed_1560, mad((-0.0f) - fragment_unnamed_1529, 1.25f, fragment_unnamed_1511), fragment_unnamed_1529 * 1.25f)) : (fragment_unnamed_1587 ? asuint(mad(fragment_unnamed_1561, mad(fragment_unnamed_1529, 1.25f, (-0.0f) - fragment_unnamed_1590), fragment_unnamed_1590)) : asuint(fragment_unnamed_1590 * fragment_unnamed_1562))));
					fragment_unnamed_1633 = asfloat(fragment_unnamed_1585 ? asuint(mad(fragment_unnamed_1559, ((-0.0f) - fragment_unnamed_1512) + 1.0f, fragment_unnamed_1512)) : (fragment_unnamed_1586 ? asuint(mad(fragment_unnamed_1560, mad((-0.0f) - fragment_unnamed_1530, 1.25f, fragment_unnamed_1512), fragment_unnamed_1530 * 1.25f)) : (fragment_unnamed_1587 ? asuint(mad(fragment_unnamed_1561, mad(fragment_unnamed_1530, 1.25f, (-0.0f) - fragment_unnamed_1591), fragment_unnamed_1591)) : asuint(fragment_unnamed_1591 * fragment_unnamed_1562))));
				}
				else
				{
					fragment_unnamed_1631 = asfloat(1065353216u);
					fragment_unnamed_1632 = asfloat(1065353216u);
					fragment_unnamed_1633 = asfloat(1065353216u);
				}
				float fragment_unnamed_1641 = clamp(fragment_unnamed_1489 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1645 = mad(clamp(fragment_unnamed_1489 * 0.1500000059604644775390625f, 0.0f, 1.0f), ((-0.0f) - fragment_unnamed_1392) + 1.0f, fragment_unnamed_1392) * 0.800000011920928955078125f;
				float fragment_unnamed_1657 = min(max((((-0.0f) - fragment_uniform_buffer_0[11u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1666 = mad(clamp(mad(log2(fragment_uniform_buffer_0[11u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1682 = mad(exp2(log2(fragment_uniform_buffer_0[6u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1685 = mad(exp2(log2(fragment_uniform_buffer_0[6u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1686 = mad(exp2(log2(fragment_uniform_buffer_0[6u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1717 = mad(exp2(log2(fragment_uniform_buffer_0[7u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1718 = mad(exp2(log2(fragment_uniform_buffer_0[7u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1719 = mad(exp2(log2(fragment_uniform_buffer_0[7u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1729 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1717) + 0.0240000002086162567138671875f, fragment_unnamed_1717);
				float fragment_unnamed_1730 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1718) + 0.0240000002086162567138671875f, fragment_unnamed_1718);
				float fragment_unnamed_1731 = mad(fragment_uniform_buffer_0[15u].x, ((-0.0f) - fragment_unnamed_1719) + 0.0240000002086162567138671875f, fragment_unnamed_1719);
				float fragment_unnamed_1746 = mad(exp2(log2(fragment_uniform_buffer_0[8u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1747 = mad(exp2(log2(fragment_uniform_buffer_0[8u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1748 = mad(exp2(log2(fragment_uniform_buffer_0[8u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1761 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1746, fragment_unnamed_1657, 0.0240000002086162567138671875f), fragment_unnamed_1657 * fragment_unnamed_1746);
				float fragment_unnamed_1762 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1747, fragment_unnamed_1657, 0.0240000002086162567138671875f), fragment_unnamed_1657 * fragment_unnamed_1747);
				float fragment_unnamed_1763 = mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1748, fragment_unnamed_1657, 0.0240000002086162567138671875f), fragment_unnamed_1657 * fragment_unnamed_1748);
				float fragment_unnamed_1764 = dot(float3(fragment_unnamed_1729, fragment_unnamed_1730, fragment_unnamed_1731), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1773 = mad(((-0.0f) - fragment_unnamed_1729) + fragment_unnamed_1764, 0.300000011920928955078125f, fragment_unnamed_1729);
				float fragment_unnamed_1774 = mad(((-0.0f) - fragment_unnamed_1730) + fragment_unnamed_1764, 0.300000011920928955078125f, fragment_unnamed_1730);
				float fragment_unnamed_1775 = mad(((-0.0f) - fragment_unnamed_1731) + fragment_unnamed_1764, 0.300000011920928955078125f, fragment_unnamed_1731);
				float fragment_unnamed_1776 = dot(float3(fragment_unnamed_1761, fragment_unnamed_1762, fragment_unnamed_1763), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1785 = mad(((-0.0f) - fragment_unnamed_1761) + fragment_unnamed_1776, 0.300000011920928955078125f, fragment_unnamed_1761);
				float fragment_unnamed_1786 = mad(((-0.0f) - fragment_unnamed_1762) + fragment_unnamed_1776, 0.300000011920928955078125f, fragment_unnamed_1762);
				float fragment_unnamed_1787 = mad(((-0.0f) - fragment_unnamed_1763) + fragment_unnamed_1776, 0.300000011920928955078125f, fragment_unnamed_1763);
				bool fragment_unnamed_1788 = 0.0f < fragment_unnamed_1489;
				float fragment_unnamed_1801 = clamp(mad(fragment_unnamed_1489, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1802 = clamp(mad(fragment_unnamed_1489, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1826 = clamp(mad(dot(float3(fragment_unnamed_1424, fragment_unnamed_1425, fragment_unnamed_1426), float3(fragment_unnamed_1108, fragment_unnamed_1109, fragment_unnamed_1110)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1830 = asfloat(asuint(fragment_uniform_buffer_0[10u]).x) + 1.0f;
				float fragment_unnamed_1837 = dot(float3((-0.0f) - fragment_unnamed_1193, (-0.0f) - fragment_unnamed_1194, (-0.0f) - fragment_unnamed_1195), float3(fragment_unnamed_1424, fragment_unnamed_1425, fragment_unnamed_1426));
				float fragment_unnamed_1841 = (-0.0f) - (fragment_unnamed_1837 + fragment_unnamed_1837);
				float fragment_unnamed_1845 = mad(fragment_unnamed_1424, fragment_unnamed_1841, (-0.0f) - fragment_unnamed_1193);
				float fragment_unnamed_1846 = mad(fragment_unnamed_1425, fragment_unnamed_1841, (-0.0f) - fragment_unnamed_1194);
				float fragment_unnamed_1847 = mad(fragment_unnamed_1426, fragment_unnamed_1841, (-0.0f) - fragment_unnamed_1195);
				uint fragment_unnamed_1863 = (fragment_uniform_buffer_0[25u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1878 = sqrt(dot(float3(fragment_uniform_buffer_0[25u].xyz), float3(fragment_uniform_buffer_0[25u].xyz))) + (-5.0f);
				float fragment_unnamed_1894 = clamp(dot(float3((-0.0f) - fragment_unnamed_1108, (-0.0f) - fragment_unnamed_1109, (-0.0f) - fragment_unnamed_1110), float3(fragment_uniform_buffer_0[12u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_1878, 0.0f, 1.0f);
				float fragment_unnamed_1903 = mad((-0.0f) - fragment_unnamed_1108, fragment_unnamed_1878, fragment_uniform_buffer_0[25u].x);
				float fragment_unnamed_1904 = mad((-0.0f) - fragment_unnamed_1109, fragment_unnamed_1878, fragment_uniform_buffer_0[25u].y);
				float fragment_unnamed_1905 = mad((-0.0f) - fragment_unnamed_1110, fragment_unnamed_1878, fragment_uniform_buffer_0[25u].z);
				float fragment_unnamed_1909 = sqrt(dot(float3(fragment_unnamed_1903, fragment_unnamed_1904, fragment_unnamed_1905), float3(fragment_unnamed_1903, fragment_unnamed_1904, fragment_unnamed_1905)));
				float fragment_unnamed_1915 = max((((-0.0f) - fragment_unnamed_1909) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1917 = fragment_unnamed_1909 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_1932 = fragment_unnamed_1894 * ((fragment_unnamed_1915 * fragment_unnamed_1915) * clamp(dot(float3(fragment_unnamed_1903 / fragment_unnamed_1909, fragment_unnamed_1904 / fragment_unnamed_1909, fragment_unnamed_1905 / fragment_unnamed_1909), float3(fragment_unnamed_1424, fragment_unnamed_1425, fragment_unnamed_1426)), 0.0f, 1.0f));
				float fragment_unnamed_1951 = clamp(fragment_unnamed_1160 * mad(fragment_unnamed_809.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_876) + 1.0f, fragment_unnamed_876), 0.0f, 1.0f);
				float fragment_unnamed_1957 = exp2(log2(fragment_unnamed_1802 * max(dot(float3(fragment_unnamed_1845, fragment_unnamed_1846, fragment_unnamed_1847), float3(fragment_uniform_buffer_0[12u].xyz)), 0.0f)) * exp2(fragment_unnamed_1951 * 6.906890392303466796875f));
				uint fragment_unnamed_1974 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1108, fragment_unnamed_1109, fragment_unnamed_1110), float3(fragment_unnamed_1108, fragment_unnamed_1109, fragment_unnamed_1110))) ? 4294967295u : 0u;
				float fragment_unnamed_1982 = mad(fragment_unnamed_1108, 1.0f, (-0.0f) - (fragment_unnamed_1109 * 0.0f));
				float fragment_unnamed_1983 = mad(fragment_unnamed_1109, 0.0f, (-0.0f) - (fragment_unnamed_1110 * 1.0f));
				float fragment_unnamed_1988 = rsqrt(dot(float2(fragment_unnamed_1982, fragment_unnamed_1983), float2(fragment_unnamed_1982, fragment_unnamed_1983)));
				bool fragment_unnamed_1992 = (fragment_unnamed_1974 & ((fragment_unnamed_1109 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_1997 = asfloat(fragment_unnamed_1992 ? asuint(fragment_unnamed_1988 * fragment_unnamed_1982) : 0u);
				float fragment_unnamed_1999 = asfloat(fragment_unnamed_1992 ? asuint(fragment_unnamed_1988 * fragment_unnamed_1983) : 1065353216u);
				float fragment_unnamed_2001 = asfloat(fragment_unnamed_1992 ? asuint(fragment_unnamed_1988 * mad(fragment_unnamed_1110, 0.0f, (-0.0f) - (fragment_unnamed_1108 * 0.0f))) : 0u);
				float fragment_unnamed_2014 = mad(fragment_unnamed_2001, fragment_unnamed_1110, (-0.0f) - (fragment_unnamed_1109 * fragment_unnamed_1997));
				float fragment_unnamed_2015 = mad(fragment_unnamed_1997, fragment_unnamed_1108, (-0.0f) - (fragment_unnamed_1110 * fragment_unnamed_1999));
				float fragment_unnamed_2016 = mad(fragment_unnamed_1999, fragment_unnamed_1109, (-0.0f) - (fragment_unnamed_1108 * fragment_unnamed_2001));
				float fragment_unnamed_2020 = rsqrt(dot(float3(fragment_unnamed_2014, fragment_unnamed_2015, fragment_unnamed_2016), float3(fragment_unnamed_2014, fragment_unnamed_2015, fragment_unnamed_2016)));
				bool fragment_unnamed_2032 = (fragment_unnamed_1974 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_1997, fragment_unnamed_1999), float2(fragment_unnamed_1997, fragment_unnamed_1999))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2050 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1847, fragment_unnamed_1845), float2((-0.0f) - fragment_unnamed_1997, (-0.0f) - fragment_unnamed_1999)), dot(float3(fragment_unnamed_1845, fragment_unnamed_1846, fragment_unnamed_1847), float3(fragment_unnamed_1108, fragment_unnamed_1109, fragment_unnamed_1110)), dot(float3(fragment_unnamed_1845, fragment_unnamed_1846, fragment_unnamed_1847), float3(fragment_unnamed_2032 ? ((-0.0f) - (fragment_unnamed_2020 * fragment_unnamed_2014)) : (-0.0f), fragment_unnamed_2032 ? ((-0.0f) - (fragment_unnamed_2020 * fragment_unnamed_2015)) : (-0.0f), fragment_unnamed_2032 ? ((-0.0f) - (fragment_unnamed_2020 * fragment_unnamed_2016)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_1951) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2069 = mad(fragment_unnamed_1802, ((-0.0f) - fragment_uniform_buffer_0[9u].y) + fragment_uniform_buffer_0[9u].x, fragment_uniform_buffer_0[9u].y);
				float fragment_unnamed_2073 = dot(float3(fragment_unnamed_2069 * (fragment_unnamed_1951 * fragment_unnamed_2050.x), fragment_unnamed_2069 * (fragment_unnamed_1951 * fragment_unnamed_2050.y), fragment_unnamed_2069 * (fragment_unnamed_1951 * fragment_unnamed_2050.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2094 = fragment_unnamed_2073 + mad(mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1132, 0.7200000286102294921875f, fragment_unnamed_1117), 0.14000000059604644775390625f, fragment_unnamed_1126 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1010), fragment_unnamed_1010), asfloat((fragment_unnamed_1917 ? asuint(fragment_unnamed_1894 * 1.2999999523162841796875f) : asuint(fragment_unnamed_1932 * 1.2999999523162841796875f)) & fragment_unnamed_1863) + mad(fragment_unnamed_1483 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1446, 1.0f) * fragment_unnamed_1631), fragment_unnamed_1645, fragment_unnamed_1466 * (fragment_unnamed_1830 * (fragment_unnamed_1826 * asfloat(fragment_unnamed_1788 ? asuint(mad(fragment_unnamed_1641, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1682, fragment_unnamed_1666, 0.0240000002086162567138671875f), fragment_unnamed_1666 * fragment_unnamed_1682) + ((-0.0f) - fragment_unnamed_1773), fragment_unnamed_1773)) : asuint(mad(fragment_unnamed_1801, fragment_unnamed_1773 + ((-0.0f) - fragment_unnamed_1785), fragment_unnamed_1785)))))), (fragment_unnamed_1951 * ((fragment_unnamed_1160 * mad(fragment_unnamed_817, mad(fragment_unnamed_809.x, fragment_unnamed_819, (-0.0f) - fragment_uniform_buffer_0[4u].x), fragment_uniform_buffer_0[4u].x)) * fragment_unnamed_1957)) * 0.5f);
				float fragment_unnamed_2095 = fragment_unnamed_2073 + mad(mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1132, 0.85000002384185791015625f, fragment_unnamed_1118), 0.14000000059604644775390625f, fragment_unnamed_1126 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1011), fragment_unnamed_1011), asfloat((fragment_unnamed_1917 ? asuint(fragment_unnamed_1894 * 1.10000002384185791015625f) : asuint(fragment_unnamed_1932 * 1.10000002384185791015625f)) & fragment_unnamed_1863) + mad(fragment_unnamed_1483 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1447, 1.0f) * fragment_unnamed_1632), fragment_unnamed_1645, fragment_unnamed_1466 * (fragment_unnamed_1830 * (fragment_unnamed_1826 * asfloat(fragment_unnamed_1788 ? asuint(mad(fragment_unnamed_1641, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1685, fragment_unnamed_1666, 0.0240000002086162567138671875f), fragment_unnamed_1666 * fragment_unnamed_1685) + ((-0.0f) - fragment_unnamed_1774), fragment_unnamed_1774)) : asuint(mad(fragment_unnamed_1801, fragment_unnamed_1774 + ((-0.0f) - fragment_unnamed_1786), fragment_unnamed_1786)))))), (fragment_unnamed_1951 * ((fragment_unnamed_1160 * mad(fragment_unnamed_817, mad(fragment_unnamed_809.y, fragment_unnamed_819, (-0.0f) - fragment_uniform_buffer_0[4u].y), fragment_uniform_buffer_0[4u].y)) * fragment_unnamed_1957)) * 0.5f);
				float fragment_unnamed_2096 = fragment_unnamed_2073 + mad(mad(fragment_uniform_buffer_0[15u].x, mad(mad(mad(fragment_unnamed_1132, 1.0f, fragment_unnamed_1119), 0.14000000059604644775390625f, fragment_unnamed_1126 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1012), fragment_unnamed_1012), asfloat((fragment_unnamed_1917 ? asuint(fragment_unnamed_1894 * 0.60000002384185791015625f) : asuint(fragment_unnamed_1932 * 0.60000002384185791015625f)) & fragment_unnamed_1863) + mad(fragment_unnamed_1483 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1448, 1.0f) * fragment_unnamed_1633), fragment_unnamed_1645, fragment_unnamed_1466 * (fragment_unnamed_1830 * (fragment_unnamed_1826 * asfloat(fragment_unnamed_1788 ? asuint(mad(fragment_unnamed_1641, mad(fragment_uniform_buffer_0[15u].x, mad((-0.0f) - fragment_unnamed_1686, fragment_unnamed_1666, 0.0240000002086162567138671875f), fragment_unnamed_1666 * fragment_unnamed_1686) + ((-0.0f) - fragment_unnamed_1775), fragment_unnamed_1775)) : asuint(mad(fragment_unnamed_1801, fragment_unnamed_1775 + ((-0.0f) - fragment_unnamed_1787), fragment_unnamed_1787)))))), (fragment_unnamed_1951 * ((fragment_unnamed_1160 * mad(fragment_unnamed_817, mad(fragment_unnamed_809.z, fragment_unnamed_819, (-0.0f) - fragment_uniform_buffer_0[4u].z), fragment_uniform_buffer_0[4u].z)) * fragment_unnamed_1957)) * 0.5f);
				fragment_output_0.x = mad(fragment_unnamed_981, ((-0.0f) - fragment_unnamed_1003) + fragment_unnamed_2094, fragment_unnamed_1003);
				fragment_output_0.y = mad(fragment_unnamed_981, ((-0.0f) - fragment_unnamed_1004) + fragment_unnamed_2095, fragment_unnamed_1004);
				fragment_output_0.z = mad(fragment_unnamed_981, ((-0.0f) - fragment_unnamed_1005) + fragment_unnamed_2096, fragment_unnamed_1005);
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[4] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[5] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[6] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[7] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[8] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[9] = float4(_GIStrengthDay, fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], _GIStrengthNight, fragment_uniform_buffer_0[9][2], fragment_uniform_buffer_0[9][3]);

				fragment_uniform_buffer_0[9] = float4(fragment_uniform_buffer_0[9][0], fragment_uniform_buffer_0[9][1], fragment_uniform_buffer_0[9][2], _Multiplier);

				fragment_uniform_buffer_0[10] = float4(_AmbientInc, fragment_uniform_buffer_0[10][1], fragment_uniform_buffer_0[10][2], fragment_uniform_buffer_0[10][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], fragment_uniform_buffer_0[11][1], _Distance, fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[12] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[12][3]);

				fragment_uniform_buffer_0[13] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[15][1], fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[17] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[18] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[25] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !POINT_COOKIE
			#endif // !SPOT


			#ifdef SPOT
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef POINT_COOKIE
			#define ANY_SHADER_VARIANT_ACTIVE

			//float4x4 unity_WorldToLight;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[30];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _LightTexture0;
			SamplerState sampler_LightTexture0;
			Texture2D<float4> _LightTextureB0;
			SamplerState sampler_LightTextureB0;
			Texture2D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float3 fragment_input_9;
			static float4 fragment_input_10;
			static float3 fragment_input_11;
			static float4 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD; // TEXCOORD
				float3 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float3 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float4 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float4 fragment_input_12 : TEXCOORD11; // TEXCOORD_11
				float4 fragment_input_13 : TEXCOORD12; // TEXCOORD_12
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2206)
			{
				if (fragment_unnamed_2206)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_129 = rsqrt(dot(float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z), float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z)));
				float fragment_unnamed_136 = fragment_unnamed_129 * fragment_input_5.y;
				float fragment_unnamed_137 = fragment_unnamed_129 * fragment_input_5.x;
				float fragment_unnamed_138 = fragment_unnamed_129 * fragment_input_5.z;
				uint fragment_unnamed_147 = uint(mad(fragment_uniform_buffer_0[18u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_153 = sqrt(((-0.0f) - abs(fragment_unnamed_136)) + 1.0f);
				float fragment_unnamed_162 = mad(mad(mad(abs(fragment_unnamed_136), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_136), -0.212114393711090087890625f), abs(fragment_unnamed_136), 1.570728778839111328125f);
				float fragment_unnamed_187 = (1.0f / max(abs(fragment_unnamed_138), abs(fragment_unnamed_137))) * min(abs(fragment_unnamed_138), abs(fragment_unnamed_137));
				float fragment_unnamed_188 = fragment_unnamed_187 * fragment_unnamed_187;
				float fragment_unnamed_196 = mad(fragment_unnamed_188, mad(fragment_unnamed_188, mad(fragment_unnamed_188, mad(fragment_unnamed_188, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_214 = asfloat(((((-0.0f) - fragment_unnamed_138) < fragment_unnamed_138) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_187, fragment_unnamed_196, asfloat(((abs(fragment_unnamed_138) < abs(fragment_unnamed_137)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_196 * fragment_unnamed_187, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_216 = min((-0.0f) - fragment_unnamed_138, fragment_unnamed_137);
				float fragment_unnamed_218 = max((-0.0f) - fragment_unnamed_138, fragment_unnamed_137);
				float fragment_unnamed_232 = (((-0.0f) - mad(fragment_unnamed_162, fragment_unnamed_153, asfloat(((fragment_unnamed_136 < ((-0.0f) - fragment_unnamed_136)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_153 * fragment_unnamed_162, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[18u].x;
				float fragment_unnamed_233 = fragment_unnamed_232 * 0.3183098733425140380859375f;
				bool fragment_unnamed_235 = 0.0f < fragment_unnamed_232;
				float fragment_unnamed_242 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_233)) : asuint(floor(fragment_unnamed_233)));
				float fragment_unnamed_246 = float(fragment_unnamed_147);
				uint fragment_unnamed_254 = uint(asfloat((0.0f < fragment_unnamed_242) ? asuint(fragment_unnamed_242 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_242) + fragment_unnamed_246) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_256 = _OffsetsBuffer.Load(fragment_unnamed_254);
				uint fragment_unnamed_257 = fragment_unnamed_256.x;
				float fragment_unnamed_264 = float((-fragment_unnamed_257) + _OffsetsBuffer.Load(fragment_unnamed_254 + 1u).x);
				float fragment_unnamed_265 = mad(((((fragment_unnamed_218 >= ((-0.0f) - fragment_unnamed_218)) ? 4294967295u : 0u) & ((fragment_unnamed_216 < ((-0.0f) - fragment_unnamed_216)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_214) : fragment_unnamed_214, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_267 = fragment_unnamed_264 * fragment_unnamed_265;
				bool fragment_unnamed_268 = 0.0f < fragment_unnamed_267;
				float fragment_unnamed_274 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_267)) : asuint(floor(fragment_unnamed_267)));
				float fragment_unnamed_275 = mad(fragment_unnamed_264, 0.5f, 0.5f);
				float fragment_unnamed_291 = float(fragment_unnamed_257 + uint(asfloat((fragment_unnamed_275 < fragment_unnamed_274) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_274) + (-1.0f)) : asuint(fragment_unnamed_264 + ((-0.0f) - fragment_unnamed_274))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_294 = frac(fragment_unnamed_291);
				uint4 fragment_unnamed_296 = _DataBuffer.Load(uint(floor(fragment_unnamed_291)));
				uint fragment_unnamed_297 = fragment_unnamed_296.x;
				uint fragment_unnamed_309 = 16u & 31u;
				uint fragment_unnamed_316 = 8u & 31u;
				uint fragment_unnamed_324 = (0.625f < fragment_unnamed_294) ? (fragment_unnamed_297 >> 24u) : ((0.375f < fragment_unnamed_294) ? spvBitfieldUExtract(fragment_unnamed_297, fragment_unnamed_309, min((8u & 31u), (32u - fragment_unnamed_309))) : ((0.125f < fragment_unnamed_294) ? spvBitfieldUExtract(fragment_unnamed_297, fragment_unnamed_316, min((8u & 31u), (32u - fragment_unnamed_316))) : (fragment_unnamed_297 & 255u)));
				float fragment_unnamed_326 = float(fragment_unnamed_324 >> 5u);
				float fragment_unnamed_331 = asfloat((6.5f < fragment_unnamed_326) ? 0u : asuint(fragment_unnamed_326));
				float fragment_unnamed_338 = round(fragment_uniform_buffer_0[15u].y * 3.0f);
				discard_cond(fragment_unnamed_331 < (fragment_unnamed_338 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_338 + 3.9900000095367431640625f) < fragment_unnamed_331);
				float fragment_unnamed_357 = mad(fragment_unnamed_232, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_358 = mad(fragment_unnamed_232, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_369 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_357)) : asuint(floor(fragment_unnamed_357)));
				float fragment_unnamed_371 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_358)) : asuint(floor(fragment_unnamed_358)));
				uint fragment_unnamed_373 = uint(ceil(max(abs(fragment_unnamed_233) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_392 = uint(asfloat((0.0f < fragment_unnamed_369) ? asuint(fragment_unnamed_369 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_246 + ((-0.0f) - fragment_unnamed_369)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_393 = uint(asfloat((0.0f < fragment_unnamed_371) ? asuint(fragment_unnamed_371 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_246 + ((-0.0f) - fragment_unnamed_371)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_394 = _OffsetsBuffer.Load(fragment_unnamed_392);
				uint fragment_unnamed_395 = fragment_unnamed_394.x;
				uint4 fragment_unnamed_396 = _OffsetsBuffer.Load(fragment_unnamed_393);
				uint fragment_unnamed_397 = fragment_unnamed_396.x;
				uint fragment_unnamed_408 = (fragment_unnamed_254 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_411 = (fragment_unnamed_254 != (fragment_unnamed_147 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_414 = (fragment_unnamed_147 != fragment_unnamed_254) ? 4294967295u : 0u;
				uint fragment_unnamed_418 = (fragment_unnamed_254 != (uint(fragment_uniform_buffer_0[18u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_434 = (fragment_unnamed_418 & (fragment_unnamed_414 & (fragment_unnamed_408 & fragment_unnamed_411))) != 0u;
				uint fragment_unnamed_437 = asuint(fragment_unnamed_264);
				float fragment_unnamed_439 = asfloat(fragment_unnamed_434 ? asuint(float((-fragment_unnamed_395) + _OffsetsBuffer.Load(fragment_unnamed_392 + 1u).x)) : fragment_unnamed_437);
				float fragment_unnamed_441 = asfloat(fragment_unnamed_434 ? asuint(float((-fragment_unnamed_397) + _OffsetsBuffer.Load(fragment_unnamed_393 + 1u).x)) : fragment_unnamed_437);
				float fragment_unnamed_443 = fragment_unnamed_265 * fragment_unnamed_439;
				float fragment_unnamed_444 = fragment_unnamed_265 * fragment_unnamed_441;
				float fragment_unnamed_445 = mad(fragment_unnamed_265, fragment_unnamed_264, 0.5f);
				float fragment_unnamed_446 = mad(fragment_unnamed_265, fragment_unnamed_264, -0.5f);
				float fragment_unnamed_453 = asfloat((fragment_unnamed_264 < fragment_unnamed_445) ? asuint(((-0.0f) - fragment_unnamed_264) + fragment_unnamed_445) : asuint(fragment_unnamed_445));
				float fragment_unnamed_459 = asfloat((fragment_unnamed_446 < 0.0f) ? asuint(fragment_unnamed_264 + fragment_unnamed_446) : asuint(fragment_unnamed_446));
				float fragment_unnamed_469 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_443)) : asuint(floor(fragment_unnamed_443)));
				float fragment_unnamed_471 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_444)) : asuint(floor(fragment_unnamed_444)));
				float fragment_unnamed_477 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_453)) : asuint(floor(fragment_unnamed_453)));
				float fragment_unnamed_483 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_459)) : asuint(floor(fragment_unnamed_459)));
				float fragment_unnamed_484 = frac(fragment_unnamed_233);
				float fragment_unnamed_485 = frac(fragment_unnamed_267);
				float fragment_unnamed_486 = fragment_unnamed_484 + (-0.5f);
				float fragment_unnamed_495 = min((((-0.0f) - fragment_unnamed_485) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_497 = min(fragment_unnamed_485 * 40.0f, 1.0f);
				float fragment_unnamed_498 = min(fragment_unnamed_484 * 40.0f, 1.0f);
				float fragment_unnamed_554 = float(fragment_unnamed_395 + uint(asfloat((mad(fragment_unnamed_439, 0.5f, 0.5f) < fragment_unnamed_469) ? asuint(mad((-0.0f) - fragment_unnamed_439, 0.5f, fragment_unnamed_469) + (-1.0f)) : asuint(fragment_unnamed_439 + ((-0.0f) - fragment_unnamed_469))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_556 = frac(fragment_unnamed_554);
				uint4 fragment_unnamed_558 = _DataBuffer.Load(uint(floor(fragment_unnamed_554)));
				uint fragment_unnamed_559 = fragment_unnamed_558.x;
				uint fragment_unnamed_565 = 16u & 31u;
				uint fragment_unnamed_570 = 8u & 31u;
				float fragment_unnamed_580 = float(uint(asfloat((mad(fragment_unnamed_441, 0.5f, 0.5f) < fragment_unnamed_471) ? asuint(mad((-0.0f) - fragment_unnamed_441, 0.5f, fragment_unnamed_471) + (-1.0f)) : asuint(fragment_unnamed_441 + ((-0.0f) - fragment_unnamed_471))) + 0.100000001490116119384765625f) + fragment_unnamed_397) * 0.25f;
				float fragment_unnamed_582 = frac(fragment_unnamed_580);
				uint4 fragment_unnamed_584 = _DataBuffer.Load(uint(floor(fragment_unnamed_580)));
				uint fragment_unnamed_585 = fragment_unnamed_584.x;
				uint fragment_unnamed_591 = 16u & 31u;
				uint fragment_unnamed_596 = 8u & 31u;
				float fragment_unnamed_606 = float(uint(asfloat((fragment_unnamed_275 < fragment_unnamed_477) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_477) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_477) + fragment_unnamed_264)) + 0.100000001490116119384765625f) + fragment_unnamed_257) * 0.25f;
				float fragment_unnamed_608 = frac(fragment_unnamed_606);
				uint4 fragment_unnamed_610 = _DataBuffer.Load(uint(floor(fragment_unnamed_606)));
				uint fragment_unnamed_611 = fragment_unnamed_610.x;
				uint fragment_unnamed_617 = 16u & 31u;
				uint fragment_unnamed_622 = 8u & 31u;
				float fragment_unnamed_632 = float(uint(asfloat((fragment_unnamed_275 < fragment_unnamed_483) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_483) + (-1.0f)) : asuint(fragment_unnamed_264 + ((-0.0f) - fragment_unnamed_483))) + 0.100000001490116119384765625f) + fragment_unnamed_257) * 0.25f;
				float fragment_unnamed_634 = frac(fragment_unnamed_632);
				uint4 fragment_unnamed_636 = _DataBuffer.Load(uint(floor(fragment_unnamed_632)));
				uint fragment_unnamed_637 = fragment_unnamed_636.x;
				uint fragment_unnamed_643 = 16u & 31u;
				uint fragment_unnamed_648 = 8u & 31u;
				float fragment_unnamed_658 = float(((0.625f < fragment_unnamed_582) ? (fragment_unnamed_585 >> 24u) : ((0.375f < fragment_unnamed_582) ? spvBitfieldUExtract(fragment_unnamed_585, fragment_unnamed_591, min((8u & 31u), (32u - fragment_unnamed_591))) : ((0.125f < fragment_unnamed_582) ? spvBitfieldUExtract(fragment_unnamed_585, fragment_unnamed_596, min((8u & 31u), (32u - fragment_unnamed_596))) : (fragment_unnamed_585 & 255u)))) >> 5u);
				float fragment_unnamed_660 = float(((0.625f < fragment_unnamed_608) ? (fragment_unnamed_611 >> 24u) : ((0.375f < fragment_unnamed_608) ? spvBitfieldUExtract(fragment_unnamed_611, fragment_unnamed_617, min((8u & 31u), (32u - fragment_unnamed_617))) : ((0.125f < fragment_unnamed_608) ? spvBitfieldUExtract(fragment_unnamed_611, fragment_unnamed_622, min((8u & 31u), (32u - fragment_unnamed_622))) : (fragment_unnamed_611 & 255u)))) >> 5u);
				float fragment_unnamed_662 = float(((0.625f < fragment_unnamed_634) ? (fragment_unnamed_637 >> 24u) : ((0.375f < fragment_unnamed_634) ? spvBitfieldUExtract(fragment_unnamed_637, fragment_unnamed_643, min((8u & 31u), (32u - fragment_unnamed_643))) : ((0.125f < fragment_unnamed_634) ? spvBitfieldUExtract(fragment_unnamed_637, fragment_unnamed_648, min((8u & 31u), (32u - fragment_unnamed_648))) : (fragment_unnamed_637 & 255u)))) >> 5u);
				float fragment_unnamed_663 = float(((0.625f < fragment_unnamed_556) ? (fragment_unnamed_559 >> 24u) : ((0.375f < fragment_unnamed_556) ? spvBitfieldUExtract(fragment_unnamed_559, fragment_unnamed_565, min((8u & 31u), (32u - fragment_unnamed_565))) : ((0.125f < fragment_unnamed_556) ? spvBitfieldUExtract(fragment_unnamed_559, fragment_unnamed_570, min((8u & 31u), (32u - fragment_unnamed_570))) : (fragment_unnamed_559 & 255u)))) >> 5u);
				float fragment_unnamed_674 = fragment_unnamed_267 * 0.20000000298023223876953125f;
				float fragment_unnamed_676 = fragment_unnamed_232 * 0.06366197764873504638671875f;
				float fragment_unnamed_678 = (fragment_unnamed_265 * float((-_OffsetsBuffer.Load(fragment_unnamed_373).x) + _OffsetsBuffer.Load(fragment_unnamed_373 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_685 = ddx_coarse(fragment_input_11.x);
				float fragment_unnamed_686 = ddx_coarse(fragment_input_11.y);
				float fragment_unnamed_687 = ddx_coarse(fragment_input_11.z);
				float fragment_unnamed_691 = sqrt(dot(float3(fragment_unnamed_685, fragment_unnamed_686, fragment_unnamed_687), float3(fragment_unnamed_685, fragment_unnamed_686, fragment_unnamed_687)));
				float fragment_unnamed_698 = ddy_coarse(fragment_input_11.x);
				float fragment_unnamed_699 = ddy_coarse(fragment_input_11.y);
				float fragment_unnamed_700 = ddy_coarse(fragment_input_11.z);
				float fragment_unnamed_704 = sqrt(dot(float3(fragment_unnamed_698, fragment_unnamed_699, fragment_unnamed_700), float3(fragment_unnamed_698, fragment_unnamed_699, fragment_unnamed_700)));
				float fragment_unnamed_715 = min(max(log2(sqrt(dot(float2(fragment_unnamed_691, fragment_unnamed_704), float2(fragment_unnamed_691, fragment_unnamed_704))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_717 = min((((-0.0f) - fragment_unnamed_484) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_784;
				float fragment_unnamed_786;
				float fragment_unnamed_788;
				float fragment_unnamed_790;
				float fragment_unnamed_792;
				float fragment_unnamed_794;
				float fragment_unnamed_796;
				float fragment_unnamed_798;
				float fragment_unnamed_800;
				float fragment_unnamed_802;
				float fragment_unnamed_804;
				float fragment_unnamed_806;
				float fragment_unnamed_808;
				float fragment_unnamed_810;
				if (((((fragment_unnamed_338 + 0.9900000095367431640625f) < fragment_unnamed_331) ? 4294967295u : 0u) & ((fragment_unnamed_331 < (fragment_unnamed_338 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_730 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
					float4 fragment_unnamed_736 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
					float4 fragment_unnamed_743 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
					float fragment_unnamed_749 = mad(fragment_unnamed_743.w * fragment_unnamed_743.x, 2.0f, -1.0f);
					float fragment_unnamed_751 = mad(fragment_unnamed_743.y, 2.0f, -1.0f);
					float4 fragment_unnamed_759 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
					float fragment_unnamed_765 = mad(fragment_unnamed_759.w * fragment_unnamed_759.x, 2.0f, -1.0f);
					float fragment_unnamed_766 = mad(fragment_unnamed_759.y, 2.0f, -1.0f);
					fragment_unnamed_784 = fragment_unnamed_730.x;
					fragment_unnamed_786 = fragment_unnamed_730.y;
					fragment_unnamed_788 = fragment_unnamed_730.z;
					fragment_unnamed_790 = fragment_unnamed_736.x;
					fragment_unnamed_792 = fragment_unnamed_736.y;
					fragment_unnamed_794 = fragment_unnamed_736.z;
					fragment_unnamed_796 = fragment_unnamed_730.w;
					fragment_unnamed_798 = fragment_unnamed_736.w;
					fragment_unnamed_800 = fragment_unnamed_749;
					fragment_unnamed_802 = fragment_unnamed_751;
					fragment_unnamed_804 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_749, fragment_unnamed_751), float2(fragment_unnamed_749, fragment_unnamed_751)), 1.0f)) + 1.0f);
					fragment_unnamed_806 = fragment_unnamed_765;
					fragment_unnamed_808 = fragment_unnamed_766;
					fragment_unnamed_810 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_765, fragment_unnamed_766), float2(fragment_unnamed_765, fragment_unnamed_766)), 1.0f)) + 1.0f);
				}
				else
				{
					float fragment_unnamed_785;
					float fragment_unnamed_787;
					float fragment_unnamed_789;
					float fragment_unnamed_791;
					float fragment_unnamed_793;
					float fragment_unnamed_795;
					float fragment_unnamed_797;
					float fragment_unnamed_799;
					float fragment_unnamed_801;
					float fragment_unnamed_803;
					float fragment_unnamed_805;
					float fragment_unnamed_807;
					float fragment_unnamed_809;
					float fragment_unnamed_811;
					if (((((fragment_unnamed_338 + 1.9900000095367431640625f) < fragment_unnamed_331) ? 4294967295u : 0u) & ((fragment_unnamed_331 < (fragment_unnamed_338 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1257 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float4 fragment_unnamed_1263 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float4 fragment_unnamed_1270 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float fragment_unnamed_1276 = mad(fragment_unnamed_1270.w * fragment_unnamed_1270.x, 2.0f, -1.0f);
						float fragment_unnamed_1277 = mad(fragment_unnamed_1270.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1285 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float fragment_unnamed_1291 = mad(fragment_unnamed_1285.w * fragment_unnamed_1285.x, 2.0f, -1.0f);
						float fragment_unnamed_1292 = mad(fragment_unnamed_1285.y, 2.0f, -1.0f);
						fragment_unnamed_785 = fragment_unnamed_1257.x;
						fragment_unnamed_787 = fragment_unnamed_1257.y;
						fragment_unnamed_789 = fragment_unnamed_1257.z;
						fragment_unnamed_791 = fragment_unnamed_1263.x;
						fragment_unnamed_793 = fragment_unnamed_1263.y;
						fragment_unnamed_795 = fragment_unnamed_1263.z;
						fragment_unnamed_797 = fragment_unnamed_1257.w;
						fragment_unnamed_799 = fragment_unnamed_1263.w;
						fragment_unnamed_801 = fragment_unnamed_1276;
						fragment_unnamed_803 = fragment_unnamed_1277;
						fragment_unnamed_805 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1276, fragment_unnamed_1277), float2(fragment_unnamed_1276, fragment_unnamed_1277)), 1.0f)) + 1.0f);
						fragment_unnamed_807 = fragment_unnamed_1291;
						fragment_unnamed_809 = fragment_unnamed_1292;
						fragment_unnamed_811 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1291, fragment_unnamed_1292), float2(fragment_unnamed_1291, fragment_unnamed_1292)), 1.0f)) + 1.0f);
					}
					else
					{
						float4 fragment_unnamed_1301 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float4 fragment_unnamed_1307 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float4 fragment_unnamed_1314 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float fragment_unnamed_1320 = mad(fragment_unnamed_1314.w * fragment_unnamed_1314.x, 2.0f, -1.0f);
						float fragment_unnamed_1321 = mad(fragment_unnamed_1314.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1329 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float fragment_unnamed_1335 = mad(fragment_unnamed_1329.w * fragment_unnamed_1329.x, 2.0f, -1.0f);
						float fragment_unnamed_1336 = mad(fragment_unnamed_1329.y, 2.0f, -1.0f);
						fragment_unnamed_785 = fragment_unnamed_1301.x;
						fragment_unnamed_787 = fragment_unnamed_1301.y;
						fragment_unnamed_789 = fragment_unnamed_1301.z;
						fragment_unnamed_791 = fragment_unnamed_1307.x;
						fragment_unnamed_793 = fragment_unnamed_1307.y;
						fragment_unnamed_795 = fragment_unnamed_1307.z;
						fragment_unnamed_797 = fragment_unnamed_1301.w;
						fragment_unnamed_799 = fragment_unnamed_1307.w;
						fragment_unnamed_801 = fragment_unnamed_1320;
						fragment_unnamed_803 = fragment_unnamed_1321;
						fragment_unnamed_805 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1320, fragment_unnamed_1321), float2(fragment_unnamed_1320, fragment_unnamed_1321)), 1.0f)) + 1.0f);
						fragment_unnamed_807 = fragment_unnamed_1335;
						fragment_unnamed_809 = fragment_unnamed_1336;
						fragment_unnamed_811 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1335, fragment_unnamed_1336), float2(fragment_unnamed_1335, fragment_unnamed_1336)), 1.0f)) + 1.0f);
					}
					fragment_unnamed_784 = fragment_unnamed_785;
					fragment_unnamed_786 = fragment_unnamed_787;
					fragment_unnamed_788 = fragment_unnamed_789;
					fragment_unnamed_790 = fragment_unnamed_791;
					fragment_unnamed_792 = fragment_unnamed_793;
					fragment_unnamed_794 = fragment_unnamed_795;
					fragment_unnamed_796 = fragment_unnamed_797;
					fragment_unnamed_798 = fragment_unnamed_799;
					fragment_unnamed_800 = fragment_unnamed_801;
					fragment_unnamed_802 = fragment_unnamed_803;
					fragment_unnamed_804 = fragment_unnamed_805;
					fragment_unnamed_806 = fragment_unnamed_807;
					fragment_unnamed_808 = fragment_unnamed_809;
					fragment_unnamed_810 = fragment_unnamed_811;
				}
				float4 fragment_unnamed_818 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_324 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_826 = fragment_unnamed_818.w * 0.800000011920928955078125f;
				float fragment_unnamed_828 = mad(fragment_unnamed_818.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_836 = exp2(log2(abs(fragment_unnamed_486) + abs(fragment_unnamed_486)) * 10.0f);
				float fragment_unnamed_855 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_802) + fragment_unnamed_808, fragment_unnamed_802);
				float fragment_unnamed_856 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_800) + fragment_unnamed_806, fragment_unnamed_800);
				float fragment_unnamed_857 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_804) + fragment_unnamed_810, fragment_unnamed_804);
				float fragment_unnamed_858 = (fragment_unnamed_828 * fragment_unnamed_818.x) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_784) + fragment_unnamed_790, fragment_unnamed_784);
				float fragment_unnamed_859 = (fragment_unnamed_828 * fragment_unnamed_818.y) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_786) + fragment_unnamed_792, fragment_unnamed_786);
				float fragment_unnamed_860 = (fragment_unnamed_828 * fragment_unnamed_818.z) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_788) + fragment_unnamed_794, fragment_unnamed_788);
				float fragment_unnamed_867 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_unnamed_858), fragment_unnamed_858);
				float fragment_unnamed_868 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_unnamed_859), fragment_unnamed_859);
				float fragment_unnamed_869 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_unnamed_860), fragment_unnamed_860);
				float fragment_unnamed_871 = ((-0.0f) - mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_796) + fragment_unnamed_798, fragment_unnamed_796)) + 1.0f;
				float fragment_unnamed_875 = fragment_unnamed_871 * fragment_uniform_buffer_0[8u].w;
				float fragment_unnamed_884 = mad(fragment_unnamed_818.w, mad((-0.0f) - fragment_unnamed_871, fragment_uniform_buffer_0[8u].w, clamp(fragment_unnamed_875 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_875);
				bool fragment_unnamed_918 = (fragment_unnamed_411 & (fragment_unnamed_414 & (((fragment_unnamed_663 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_663) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_926 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_867) : asuint(fragment_unnamed_867);
				uint fragment_unnamed_928 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_868) : asuint(fragment_unnamed_868);
				uint fragment_unnamed_930 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_869) : asuint(fragment_unnamed_869);
				uint fragment_unnamed_932 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_943 = (fragment_unnamed_418 & (fragment_unnamed_408 & (((fragment_unnamed_658 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_658) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_948 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_926)) : fragment_unnamed_926;
				uint fragment_unnamed_950 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_928)) : fragment_unnamed_928;
				uint fragment_unnamed_952 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_930)) : fragment_unnamed_930;
				uint fragment_unnamed_954 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_932)) : fragment_unnamed_932;
				bool fragment_unnamed_963 = (((fragment_unnamed_660 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_660) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_968 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_948)) : fragment_unnamed_948;
				uint fragment_unnamed_970 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_950)) : fragment_unnamed_950;
				uint fragment_unnamed_972 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_952)) : fragment_unnamed_952;
				uint fragment_unnamed_974 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_954)) : fragment_unnamed_954;
				bool fragment_unnamed_983 = (((fragment_unnamed_662 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_662) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_989 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_974)) : fragment_unnamed_974);
				discard_cond((fragment_unnamed_989 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1009 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_10.x / fragment_input_10.w, fragment_input_10.y / fragment_input_10.w));
				float fragment_unnamed_1011 = fragment_unnamed_1009.x;
				float fragment_unnamed_1012 = fragment_unnamed_1009.y;
				float fragment_unnamed_1013 = fragment_unnamed_1009.z;
				float fragment_unnamed_1018 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_968)) : fragment_unnamed_968) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1019 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_970)) : fragment_unnamed_970) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1020 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_972)) : fragment_unnamed_972) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1032 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1033 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1034 = fragment_uniform_buffer_0[17u].x + fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1035 = fragment_uniform_buffer_0[17u].y + fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1041 = fragment_unnamed_1034 * fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1042 = fragment_unnamed_1035 * fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1043 = fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1051 = fragment_unnamed_1034 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1052 = fragment_unnamed_1035 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1056 = fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1087 = mad(fragment_unnamed_1052 + (fragment_unnamed_1032 * fragment_uniform_buffer_0[17u].x), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1035, (-0.0f) - fragment_unnamed_1056), fragment_input_5.y, (((-0.0f) - (fragment_unnamed_1043 + fragment_unnamed_1042)) + 1.0f) * fragment_input_5.x));
				float fragment_unnamed_1105 = mad(mad(fragment_uniform_buffer_0[17u].y, fragment_unnamed_1033, (-0.0f) - fragment_unnamed_1051), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1035, fragment_unnamed_1056), fragment_input_5.x, (((-0.0f) - (fragment_unnamed_1043 + fragment_unnamed_1041)) + 1.0f) * fragment_input_5.y));
				float fragment_unnamed_1111 = mad(((-0.0f) - (fragment_unnamed_1042 + fragment_unnamed_1041)) + 1.0f, fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1032, (-0.0f) - fragment_unnamed_1052), fragment_input_5.x, (fragment_unnamed_1051 + (fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].y)) * fragment_input_5.y));
				float fragment_unnamed_1115 = rsqrt(dot(float3(fragment_unnamed_1087, fragment_unnamed_1105, fragment_unnamed_1111), float3(fragment_unnamed_1087, fragment_unnamed_1105, fragment_unnamed_1111)));
				float fragment_unnamed_1116 = fragment_unnamed_1115 * fragment_unnamed_1087;
				float fragment_unnamed_1117 = fragment_unnamed_1115 * fragment_unnamed_1105;
				float fragment_unnamed_1118 = fragment_unnamed_1115 * fragment_unnamed_1111;
				float fragment_unnamed_1125 = mad(mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1018), 0.5f, fragment_unnamed_1018);
				float fragment_unnamed_1126 = mad(mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1019), 0.5f, fragment_unnamed_1019);
				float fragment_unnamed_1127 = mad(mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1020), 0.5f, fragment_unnamed_1020);
				float fragment_unnamed_1128 = dot(float3(fragment_unnamed_1125, fragment_unnamed_1126, fragment_unnamed_1127), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1134 = mad(((-0.0f) - fragment_unnamed_1128) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1128);
				float fragment_unnamed_1140 = (-0.0f) - fragment_unnamed_1134;
				float fragment_unnamed_1168 = mad((-0.0f) - fragment_uniform_buffer_0[19u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1195 = ((-0.0f) - fragment_input_4.x) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1196 = ((-0.0f) - fragment_input_4.y) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1197 = ((-0.0f) - fragment_input_4.z) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1201 = rsqrt(dot(float3(fragment_unnamed_1195, fragment_unnamed_1196, fragment_unnamed_1197), float3(fragment_unnamed_1195, fragment_unnamed_1196, fragment_unnamed_1197)));
				float fragment_unnamed_1202 = fragment_unnamed_1201 * fragment_unnamed_1195;
				float fragment_unnamed_1203 = fragment_unnamed_1201 * fragment_unnamed_1196;
				float fragment_unnamed_1204 = fragment_unnamed_1201 * fragment_unnamed_1197;
				float fragment_unnamed_1248 = mad(fragment_uniform_buffer_0[6u].x, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].x)) + fragment_uniform_buffer_0[7u].x;
				float fragment_unnamed_1249 = mad(fragment_uniform_buffer_0[6u].y, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].y)) + fragment_uniform_buffer_0[7u].y;
				float fragment_unnamed_1250 = mad(fragment_uniform_buffer_0[6u].z, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].z)) + fragment_uniform_buffer_0[7u].z;
				float fragment_unnamed_1251 = mad(fragment_uniform_buffer_0[6u].w, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].w, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].w)) + fragment_uniform_buffer_0[7u].w;
				float fragment_unnamed_1433;
				float fragment_unnamed_1434;
				float fragment_unnamed_1435;
				float fragment_unnamed_1436;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1347 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1423 = _LightTexture0.Sample(sampler_LightTexture0, float3(max(mad(((fragment_unnamed_1347 ? (mad(fragment_uniform_buffer_3[3u].x, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : fragment_input_4.x) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), ((fragment_unnamed_1347 ? (mad(fragment_uniform_buffer_3[3u].y, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : fragment_input_4.y) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, ((fragment_unnamed_1347 ? (mad(fragment_uniform_buffer_3[3u].z, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : fragment_input_4.z) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1433 = fragment_unnamed_1423.x;
					fragment_unnamed_1434 = fragment_unnamed_1423.y;
					fragment_unnamed_1435 = fragment_unnamed_1423.z;
					fragment_unnamed_1436 = fragment_unnamed_1423.w;
				}
				else
				{
					fragment_unnamed_1433 = asfloat(1065353216u);
					fragment_unnamed_1434 = asfloat(1065353216u);
					fragment_unnamed_1435 = asfloat(1065353216u);
					fragment_unnamed_1436 = asfloat(1065353216u);
				}
				float fragment_unnamed_1447 = clamp(dot(float4(fragment_unnamed_1433, fragment_unnamed_1434, fragment_unnamed_1435, fragment_unnamed_1436), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float4 fragment_unnamed_1457 = _LightTextureB0.Sample(sampler_LightTextureB0, float2((fragment_unnamed_1248 / fragment_unnamed_1251) + 0.5f, (fragment_unnamed_1249 / fragment_unnamed_1251) + 0.5f));
				float4 fragment_unnamed_1465 = _Global_PGI.Sample(sampler_Global_PGI, dot(float3(fragment_unnamed_1248, fragment_unnamed_1249, fragment_unnamed_1250), float3(fragment_unnamed_1248, fragment_unnamed_1249, fragment_unnamed_1250)).xx);
				float fragment_unnamed_1468 = (asfloat(((0.0f < fragment_unnamed_1250) ? 4294967295u : 0u) & 1065353216u) * fragment_unnamed_1457.w) * fragment_unnamed_1465.x;
				float fragment_unnamed_1476 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1485 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1494 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1500 = rsqrt(dot(float3(fragment_unnamed_1476, fragment_unnamed_1485, fragment_unnamed_1494), float3(fragment_unnamed_1476, fragment_unnamed_1485, fragment_unnamed_1494)));
				float fragment_unnamed_1501 = fragment_unnamed_1500 * fragment_unnamed_1476;
				float fragment_unnamed_1502 = fragment_unnamed_1500 * fragment_unnamed_1485;
				float fragment_unnamed_1503 = fragment_unnamed_1500 * fragment_unnamed_1494;
				float fragment_unnamed_1524 = ((-0.0f) - fragment_uniform_buffer_0[9u].x) + 1.0f;
				float fragment_unnamed_1525 = ((-0.0f) - fragment_uniform_buffer_0[9u].y) + 1.0f;
				float fragment_unnamed_1526 = ((-0.0f) - fragment_uniform_buffer_0[9u].z) + 1.0f;
				float fragment_unnamed_1538 = dot(float3(fragment_unnamed_1501, fragment_unnamed_1502, fragment_unnamed_1503), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1541 = mad(fragment_unnamed_1538, 0.25f, 1.0f);
				float fragment_unnamed_1543 = fragment_unnamed_1541 * (fragment_unnamed_1541 * fragment_unnamed_1541);
				float fragment_unnamed_1548 = exp2(log2(max(fragment_unnamed_1538, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1549 = fragment_unnamed_1548 + fragment_unnamed_1548;
				float fragment_unnamed_1560 = asfloat((0.5f < fragment_unnamed_1548) ? asuint(mad(log2(mad(log2(fragment_unnamed_1549), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1549)) * 0.5f;
				float fragment_unnamed_1566 = dot(float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1709;
				float fragment_unnamed_1710;
				float fragment_unnamed_1711;
				if (1.0f >= fragment_unnamed_1566)
				{
					float fragment_unnamed_1588 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].x) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1589 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].y) + 1.0f), fragment_unnamed_1525, 1.0f);
					float fragment_unnamed_1590 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].z) + 1.0f), fragment_unnamed_1526, 1.0f);
					float fragment_unnamed_1606 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].x) + 1.0f), fragment_unnamed_1524, 1.0f);
					float fragment_unnamed_1607 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].y) + 1.0f), fragment_unnamed_1525, 1.0f);
					float fragment_unnamed_1608 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].z) + 1.0f), fragment_unnamed_1526, 1.0f);
					float fragment_unnamed_1637 = clamp((fragment_unnamed_1566 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1638 = clamp((fragment_unnamed_1566 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1639 = clamp((fragment_unnamed_1566 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1640 = clamp((fragment_unnamed_1566 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1663 = 0.20000000298023223876953125f < fragment_unnamed_1566;
					bool fragment_unnamed_1664 = 0.100000001490116119384765625f < fragment_unnamed_1566;
					bool fragment_unnamed_1665 = (-0.100000001490116119384765625f) < fragment_unnamed_1566;
					float fragment_unnamed_1666 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].x) + 1.0f), fragment_unnamed_1524, 1.0f) * 1.5f;
					float fragment_unnamed_1668 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].y) + 1.0f), fragment_unnamed_1525, 1.0f) * 1.5f;
					float fragment_unnamed_1669 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].z) + 1.0f), fragment_unnamed_1526, 1.0f) * 1.5f;
					fragment_unnamed_1709 = asfloat(fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, ((-0.0f) - fragment_unnamed_1588) + 1.0f, fragment_unnamed_1588)) : (fragment_unnamed_1664 ? asuint(mad(fragment_unnamed_1638, mad((-0.0f) - fragment_unnamed_1606, 1.25f, fragment_unnamed_1588), fragment_unnamed_1606 * 1.25f)) : (fragment_unnamed_1665 ? asuint(mad(fragment_unnamed_1639, mad(fragment_unnamed_1606, 1.25f, (-0.0f) - fragment_unnamed_1666), fragment_unnamed_1666)) : asuint(fragment_unnamed_1666 * fragment_unnamed_1640))));
					fragment_unnamed_1710 = asfloat(fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, ((-0.0f) - fragment_unnamed_1589) + 1.0f, fragment_unnamed_1589)) : (fragment_unnamed_1664 ? asuint(mad(fragment_unnamed_1638, mad((-0.0f) - fragment_unnamed_1607, 1.25f, fragment_unnamed_1589), fragment_unnamed_1607 * 1.25f)) : (fragment_unnamed_1665 ? asuint(mad(fragment_unnamed_1639, mad(fragment_unnamed_1607, 1.25f, (-0.0f) - fragment_unnamed_1668), fragment_unnamed_1668)) : asuint(fragment_unnamed_1668 * fragment_unnamed_1640))));
					fragment_unnamed_1711 = asfloat(fragment_unnamed_1663 ? asuint(mad(fragment_unnamed_1637, ((-0.0f) - fragment_unnamed_1590) + 1.0f, fragment_unnamed_1590)) : (fragment_unnamed_1664 ? asuint(mad(fragment_unnamed_1638, mad((-0.0f) - fragment_unnamed_1608, 1.25f, fragment_unnamed_1590), fragment_unnamed_1608 * 1.25f)) : (fragment_unnamed_1665 ? asuint(mad(fragment_unnamed_1639, mad(fragment_unnamed_1608, 1.25f, (-0.0f) - fragment_unnamed_1669), fragment_unnamed_1669)) : asuint(fragment_unnamed_1669 * fragment_unnamed_1640))));
				}
				else
				{
					fragment_unnamed_1709 = asfloat(1065353216u);
					fragment_unnamed_1710 = asfloat(1065353216u);
					fragment_unnamed_1711 = asfloat(1065353216u);
				}
				float fragment_unnamed_1719 = clamp(fragment_unnamed_1566 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1723 = mad(clamp(fragment_unnamed_1566 * 0.1500000059604644775390625f, 0.0f, 1.0f), mad((-0.0f) - fragment_unnamed_1468, fragment_unnamed_1447, 1.0f), fragment_unnamed_1447 * fragment_unnamed_1468) * 0.800000011920928955078125f;
				float fragment_unnamed_1735 = min(max((((-0.0f) - fragment_uniform_buffer_0[15u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1744 = mad(clamp(mad(log2(fragment_uniform_buffer_0[15u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1761 = mad(exp2(log2(fragment_uniform_buffer_0[10u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1764 = mad(exp2(log2(fragment_uniform_buffer_0[10u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1765 = mad(exp2(log2(fragment_uniform_buffer_0[10u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1797 = mad(exp2(log2(fragment_uniform_buffer_0[11u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1798 = mad(exp2(log2(fragment_uniform_buffer_0[11u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1799 = mad(exp2(log2(fragment_uniform_buffer_0[11u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1809 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1797) + 0.0240000002086162567138671875f, fragment_unnamed_1797);
				float fragment_unnamed_1810 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1798) + 0.0240000002086162567138671875f, fragment_unnamed_1798);
				float fragment_unnamed_1811 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1799) + 0.0240000002086162567138671875f, fragment_unnamed_1799);
				float fragment_unnamed_1827 = mad(exp2(log2(fragment_uniform_buffer_0[12u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1828 = mad(exp2(log2(fragment_uniform_buffer_0[12u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1829 = mad(exp2(log2(fragment_uniform_buffer_0[12u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1842 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1827, fragment_unnamed_1735, 0.0240000002086162567138671875f), fragment_unnamed_1735 * fragment_unnamed_1827);
				float fragment_unnamed_1843 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1828, fragment_unnamed_1735, 0.0240000002086162567138671875f), fragment_unnamed_1735 * fragment_unnamed_1828);
				float fragment_unnamed_1844 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1829, fragment_unnamed_1735, 0.0240000002086162567138671875f), fragment_unnamed_1735 * fragment_unnamed_1829);
				float fragment_unnamed_1845 = dot(float3(fragment_unnamed_1809, fragment_unnamed_1810, fragment_unnamed_1811), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1854 = mad(((-0.0f) - fragment_unnamed_1809) + fragment_unnamed_1845, 0.300000011920928955078125f, fragment_unnamed_1809);
				float fragment_unnamed_1855 = mad(((-0.0f) - fragment_unnamed_1810) + fragment_unnamed_1845, 0.300000011920928955078125f, fragment_unnamed_1810);
				float fragment_unnamed_1856 = mad(((-0.0f) - fragment_unnamed_1811) + fragment_unnamed_1845, 0.300000011920928955078125f, fragment_unnamed_1811);
				float fragment_unnamed_1857 = dot(float3(fragment_unnamed_1842, fragment_unnamed_1843, fragment_unnamed_1844), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1866 = mad(((-0.0f) - fragment_unnamed_1842) + fragment_unnamed_1857, 0.300000011920928955078125f, fragment_unnamed_1842);
				float fragment_unnamed_1867 = mad(((-0.0f) - fragment_unnamed_1843) + fragment_unnamed_1857, 0.300000011920928955078125f, fragment_unnamed_1843);
				float fragment_unnamed_1868 = mad(((-0.0f) - fragment_unnamed_1844) + fragment_unnamed_1857, 0.300000011920928955078125f, fragment_unnamed_1844);
				bool fragment_unnamed_1869 = 0.0f < fragment_unnamed_1566;
				float fragment_unnamed_1882 = clamp(mad(fragment_unnamed_1566, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1883 = clamp(mad(fragment_unnamed_1566, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1907 = clamp(mad(dot(float3(fragment_unnamed_1501, fragment_unnamed_1502, fragment_unnamed_1503), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1911 = asfloat(asuint(fragment_uniform_buffer_0[14u]).x) + 1.0f;
				float fragment_unnamed_1918 = dot(float3((-0.0f) - fragment_unnamed_1202, (-0.0f) - fragment_unnamed_1203, (-0.0f) - fragment_unnamed_1204), float3(fragment_unnamed_1501, fragment_unnamed_1502, fragment_unnamed_1503));
				float fragment_unnamed_1922 = (-0.0f) - (fragment_unnamed_1918 + fragment_unnamed_1918);
				float fragment_unnamed_1926 = mad(fragment_unnamed_1501, fragment_unnamed_1922, (-0.0f) - fragment_unnamed_1202);
				float fragment_unnamed_1927 = mad(fragment_unnamed_1502, fragment_unnamed_1922, (-0.0f) - fragment_unnamed_1203);
				float fragment_unnamed_1928 = mad(fragment_unnamed_1503, fragment_unnamed_1922, (-0.0f) - fragment_unnamed_1204);
				uint fragment_unnamed_1944 = (fragment_uniform_buffer_0[29u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1959 = sqrt(dot(float3(fragment_uniform_buffer_0[29u].xyz), float3(fragment_uniform_buffer_0[29u].xyz))) + (-5.0f);
				float fragment_unnamed_1975 = clamp(dot(float3((-0.0f) - fragment_unnamed_1116, (-0.0f) - fragment_unnamed_1117, (-0.0f) - fragment_unnamed_1118), float3(fragment_uniform_buffer_0[16u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_1959, 0.0f, 1.0f);
				float fragment_unnamed_1984 = mad((-0.0f) - fragment_unnamed_1116, fragment_unnamed_1959, fragment_uniform_buffer_0[29u].x);
				float fragment_unnamed_1985 = mad((-0.0f) - fragment_unnamed_1117, fragment_unnamed_1959, fragment_uniform_buffer_0[29u].y);
				float fragment_unnamed_1986 = mad((-0.0f) - fragment_unnamed_1118, fragment_unnamed_1959, fragment_uniform_buffer_0[29u].z);
				float fragment_unnamed_1990 = sqrt(dot(float3(fragment_unnamed_1984, fragment_unnamed_1985, fragment_unnamed_1986), float3(fragment_unnamed_1984, fragment_unnamed_1985, fragment_unnamed_1986)));
				float fragment_unnamed_1996 = max((((-0.0f) - fragment_unnamed_1990) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1998 = fragment_unnamed_1990 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_2013 = fragment_unnamed_1975 * ((fragment_unnamed_1996 * fragment_unnamed_1996) * clamp(dot(float3(fragment_unnamed_1984 / fragment_unnamed_1990, fragment_unnamed_1985 / fragment_unnamed_1990, fragment_unnamed_1986 / fragment_unnamed_1990), float3(fragment_unnamed_1501, fragment_unnamed_1502, fragment_unnamed_1503)), 0.0f, 1.0f));
				float fragment_unnamed_2032 = clamp(fragment_unnamed_1168 * mad(fragment_unnamed_818.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_884) + 1.0f, fragment_unnamed_884), 0.0f, 1.0f);
				float fragment_unnamed_2038 = exp2(log2(fragment_unnamed_1883 * max(dot(float3(fragment_unnamed_1926, fragment_unnamed_1927, fragment_unnamed_1928), float3(fragment_uniform_buffer_0[16u].xyz)), 0.0f)) * exp2(fragment_unnamed_2032 * 6.906890392303466796875f));
				uint fragment_unnamed_2055 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118))) ? 4294967295u : 0u;
				float fragment_unnamed_2063 = mad(fragment_unnamed_1116, 1.0f, (-0.0f) - (fragment_unnamed_1117 * 0.0f));
				float fragment_unnamed_2064 = mad(fragment_unnamed_1117, 0.0f, (-0.0f) - (fragment_unnamed_1118 * 1.0f));
				float fragment_unnamed_2069 = rsqrt(dot(float2(fragment_unnamed_2063, fragment_unnamed_2064), float2(fragment_unnamed_2063, fragment_unnamed_2064)));
				bool fragment_unnamed_2073 = (fragment_unnamed_2055 & ((fragment_unnamed_1117 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2078 = asfloat(fragment_unnamed_2073 ? asuint(fragment_unnamed_2069 * fragment_unnamed_2063) : 0u);
				float fragment_unnamed_2080 = asfloat(fragment_unnamed_2073 ? asuint(fragment_unnamed_2069 * fragment_unnamed_2064) : 1065353216u);
				float fragment_unnamed_2082 = asfloat(fragment_unnamed_2073 ? asuint(fragment_unnamed_2069 * mad(fragment_unnamed_1118, 0.0f, (-0.0f) - (fragment_unnamed_1116 * 0.0f))) : 0u);
				float fragment_unnamed_2095 = mad(fragment_unnamed_2082, fragment_unnamed_1118, (-0.0f) - (fragment_unnamed_1117 * fragment_unnamed_2078));
				float fragment_unnamed_2096 = mad(fragment_unnamed_2078, fragment_unnamed_1116, (-0.0f) - (fragment_unnamed_1118 * fragment_unnamed_2080));
				float fragment_unnamed_2097 = mad(fragment_unnamed_2080, fragment_unnamed_1117, (-0.0f) - (fragment_unnamed_1116 * fragment_unnamed_2082));
				float fragment_unnamed_2101 = rsqrt(dot(float3(fragment_unnamed_2095, fragment_unnamed_2096, fragment_unnamed_2097), float3(fragment_unnamed_2095, fragment_unnamed_2096, fragment_unnamed_2097)));
				bool fragment_unnamed_2113 = (fragment_unnamed_2055 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2078, fragment_unnamed_2080), float2(fragment_unnamed_2078, fragment_unnamed_2080))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2131 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1928, fragment_unnamed_1926), float2((-0.0f) - fragment_unnamed_2078, (-0.0f) - fragment_unnamed_2080)), dot(float3(fragment_unnamed_1926, fragment_unnamed_1927, fragment_unnamed_1928), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118)), dot(float3(fragment_unnamed_1926, fragment_unnamed_1927, fragment_unnamed_1928), float3(fragment_unnamed_2113 ? ((-0.0f) - (fragment_unnamed_2101 * fragment_unnamed_2095)) : (-0.0f), fragment_unnamed_2113 ? ((-0.0f) - (fragment_unnamed_2101 * fragment_unnamed_2096)) : (-0.0f), fragment_unnamed_2113 ? ((-0.0f) - (fragment_unnamed_2101 * fragment_unnamed_2097)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2032) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2150 = mad(fragment_unnamed_1883, ((-0.0f) - fragment_uniform_buffer_0[13u].y) + fragment_uniform_buffer_0[13u].x, fragment_uniform_buffer_0[13u].y);
				float fragment_unnamed_2154 = dot(float3(fragment_unnamed_2150 * (fragment_unnamed_2032 * fragment_unnamed_2131.x), fragment_unnamed_2150 * (fragment_unnamed_2032 * fragment_unnamed_2131.y), fragment_unnamed_2150 * (fragment_unnamed_2032 * fragment_unnamed_2131.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2175 = fragment_unnamed_2154 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 0.7200000286102294921875f, fragment_unnamed_1125), 0.14000000059604644775390625f, fragment_unnamed_1134 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1018), fragment_unnamed_1018), asfloat(fragment_unnamed_1944 & (fragment_unnamed_1998 ? asuint(fragment_unnamed_1975 * 1.2999999523162841796875f) : asuint(fragment_unnamed_2013 * 1.2999999523162841796875f))) + mad(fragment_unnamed_1560 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1524, 1.0f) * fragment_unnamed_1709), fragment_unnamed_1723, fragment_unnamed_1543 * (fragment_unnamed_1911 * (fragment_unnamed_1907 * asfloat(fragment_unnamed_1869 ? asuint(mad(fragment_unnamed_1719, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1761, fragment_unnamed_1744, 0.0240000002086162567138671875f), fragment_unnamed_1744 * fragment_unnamed_1761) + ((-0.0f) - fragment_unnamed_1854), fragment_unnamed_1854)) : asuint(mad(fragment_unnamed_1882, fragment_unnamed_1854 + ((-0.0f) - fragment_unnamed_1866), fragment_unnamed_1866)))))), (fragment_unnamed_2032 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].x), fragment_uniform_buffer_0[8u].x)) * fragment_unnamed_2038)) * 0.5f);
				float fragment_unnamed_2176 = fragment_unnamed_2154 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 0.85000002384185791015625f, fragment_unnamed_1126), 0.14000000059604644775390625f, fragment_unnamed_1134 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1019), fragment_unnamed_1019), asfloat(fragment_unnamed_1944 & (fragment_unnamed_1998 ? asuint(fragment_unnamed_1975 * 1.10000002384185791015625f) : asuint(fragment_unnamed_2013 * 1.10000002384185791015625f))) + mad(fragment_unnamed_1560 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1525, 1.0f) * fragment_unnamed_1710), fragment_unnamed_1723, fragment_unnamed_1543 * (fragment_unnamed_1911 * (fragment_unnamed_1907 * asfloat(fragment_unnamed_1869 ? asuint(mad(fragment_unnamed_1719, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1764, fragment_unnamed_1744, 0.0240000002086162567138671875f), fragment_unnamed_1744 * fragment_unnamed_1764) + ((-0.0f) - fragment_unnamed_1855), fragment_unnamed_1855)) : asuint(mad(fragment_unnamed_1882, fragment_unnamed_1855 + ((-0.0f) - fragment_unnamed_1867), fragment_unnamed_1867)))))), (fragment_unnamed_2032 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].y), fragment_uniform_buffer_0[8u].y)) * fragment_unnamed_2038)) * 0.5f);
				float fragment_unnamed_2177 = fragment_unnamed_2154 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 1.0f, fragment_unnamed_1127), 0.14000000059604644775390625f, fragment_unnamed_1134 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1020), fragment_unnamed_1020), asfloat(fragment_unnamed_1944 & (fragment_unnamed_1998 ? asuint(fragment_unnamed_1975 * 0.60000002384185791015625f) : asuint(fragment_unnamed_2013 * 0.60000002384185791015625f))) + mad(fragment_unnamed_1560 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1526, 1.0f) * fragment_unnamed_1711), fragment_unnamed_1723, fragment_unnamed_1543 * (fragment_unnamed_1911 * (fragment_unnamed_1907 * asfloat(fragment_unnamed_1869 ? asuint(mad(fragment_unnamed_1719, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1765, fragment_unnamed_1744, 0.0240000002086162567138671875f), fragment_unnamed_1744 * fragment_unnamed_1765) + ((-0.0f) - fragment_unnamed_1856), fragment_unnamed_1856)) : asuint(mad(fragment_unnamed_1882, fragment_unnamed_1856 + ((-0.0f) - fragment_unnamed_1868), fragment_unnamed_1868)))))), (fragment_unnamed_2032 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].z), fragment_uniform_buffer_0[8u].z)) * fragment_unnamed_2038)) * 0.5f);
				fragment_output_0.x = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1011) + fragment_unnamed_2175, fragment_unnamed_1011);
				fragment_output_0.y = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1012) + fragment_unnamed_2176, fragment_unnamed_1012);
				fragment_output_0.z = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1013) + fragment_unnamed_2177, fragment_unnamed_1013);
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				fragment_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				fragment_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				fragment_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				fragment_uniform_buffer_0[8] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[9] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[10] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[11] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[12] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[13] = float4(_GIStrengthDay, fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], _GIStrengthNight, fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], _Multiplier);

				fragment_uniform_buffer_0[14] = float4(_AmbientInc, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], _MaterialIndex, fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], fragment_uniform_buffer_0[15][1], _Distance, fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[16][3]);

				fragment_uniform_buffer_0[17] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[18] = float4(_LatitudeCount, fragment_uniform_buffer_0[18][1], fragment_uniform_buffer_0[18][2], fragment_uniform_buffer_0[18][3]);

				fragment_uniform_buffer_0[19] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[19][1], fragment_uniform_buffer_0[19][2], fragment_uniform_buffer_0[19][3]);

				fragment_uniform_buffer_0[20] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[21] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[22] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[29] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // SPOT
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !POINT_COOKIE


			#ifdef POINT_COOKIE
			#ifndef DIRECTIONAL
			#ifndef DIRECTIONAL_COOKIE
			#ifndef POINT
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			//float4x4 unity_WorldToLight;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[30];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _LightTextureB0;
			SamplerState sampler_LightTextureB0;
			Texture2D<float4> _LightTexture0;
			SamplerState sampler_LightTexture0;
			TextureCube<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float3 fragment_input_9;
			static float4 fragment_input_10;
			static float3 fragment_input_11;
			static float3 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD; // TEXCOORD
				float3 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float3 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float4 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float3 fragment_input_12 : TEXCOORD11; // TEXCOORD_11
				float4 fragment_input_13 : TEXCOORD12; // TEXCOORD_12
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2189)
			{
				if (fragment_unnamed_2189)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_129 = rsqrt(dot(float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z), float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z)));
				float fragment_unnamed_136 = fragment_unnamed_129 * fragment_input_5.y;
				float fragment_unnamed_137 = fragment_unnamed_129 * fragment_input_5.x;
				float fragment_unnamed_138 = fragment_unnamed_129 * fragment_input_5.z;
				uint fragment_unnamed_147 = uint(mad(fragment_uniform_buffer_0[18u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_153 = sqrt(((-0.0f) - abs(fragment_unnamed_136)) + 1.0f);
				float fragment_unnamed_162 = mad(mad(mad(abs(fragment_unnamed_136), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_136), -0.212114393711090087890625f), abs(fragment_unnamed_136), 1.570728778839111328125f);
				float fragment_unnamed_187 = (1.0f / max(abs(fragment_unnamed_138), abs(fragment_unnamed_137))) * min(abs(fragment_unnamed_138), abs(fragment_unnamed_137));
				float fragment_unnamed_188 = fragment_unnamed_187 * fragment_unnamed_187;
				float fragment_unnamed_196 = mad(fragment_unnamed_188, mad(fragment_unnamed_188, mad(fragment_unnamed_188, mad(fragment_unnamed_188, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_214 = asfloat(((((-0.0f) - fragment_unnamed_138) < fragment_unnamed_138) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_187, fragment_unnamed_196, asfloat(((abs(fragment_unnamed_138) < abs(fragment_unnamed_137)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_196 * fragment_unnamed_187, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_216 = min((-0.0f) - fragment_unnamed_138, fragment_unnamed_137);
				float fragment_unnamed_218 = max((-0.0f) - fragment_unnamed_138, fragment_unnamed_137);
				float fragment_unnamed_232 = (((-0.0f) - mad(fragment_unnamed_162, fragment_unnamed_153, asfloat(((fragment_unnamed_136 < ((-0.0f) - fragment_unnamed_136)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_153 * fragment_unnamed_162, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[18u].x;
				float fragment_unnamed_233 = fragment_unnamed_232 * 0.3183098733425140380859375f;
				bool fragment_unnamed_235 = 0.0f < fragment_unnamed_232;
				float fragment_unnamed_242 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_233)) : asuint(floor(fragment_unnamed_233)));
				float fragment_unnamed_246 = float(fragment_unnamed_147);
				uint fragment_unnamed_254 = uint(asfloat((0.0f < fragment_unnamed_242) ? asuint(fragment_unnamed_242 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_242) + fragment_unnamed_246) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_256 = _OffsetsBuffer.Load(fragment_unnamed_254);
				uint fragment_unnamed_257 = fragment_unnamed_256.x;
				float fragment_unnamed_264 = float((-fragment_unnamed_257) + _OffsetsBuffer.Load(fragment_unnamed_254 + 1u).x);
				float fragment_unnamed_265 = mad(((((fragment_unnamed_218 >= ((-0.0f) - fragment_unnamed_218)) ? 4294967295u : 0u) & ((fragment_unnamed_216 < ((-0.0f) - fragment_unnamed_216)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_214) : fragment_unnamed_214, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_267 = fragment_unnamed_264 * fragment_unnamed_265;
				bool fragment_unnamed_268 = 0.0f < fragment_unnamed_267;
				float fragment_unnamed_274 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_267)) : asuint(floor(fragment_unnamed_267)));
				float fragment_unnamed_275 = mad(fragment_unnamed_264, 0.5f, 0.5f);
				float fragment_unnamed_291 = float(fragment_unnamed_257 + uint(asfloat((fragment_unnamed_275 < fragment_unnamed_274) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_274) + (-1.0f)) : asuint(fragment_unnamed_264 + ((-0.0f) - fragment_unnamed_274))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_294 = frac(fragment_unnamed_291);
				uint4 fragment_unnamed_296 = _DataBuffer.Load(uint(floor(fragment_unnamed_291)));
				uint fragment_unnamed_297 = fragment_unnamed_296.x;
				uint fragment_unnamed_309 = 16u & 31u;
				uint fragment_unnamed_316 = 8u & 31u;
				uint fragment_unnamed_324 = (0.625f < fragment_unnamed_294) ? (fragment_unnamed_297 >> 24u) : ((0.375f < fragment_unnamed_294) ? spvBitfieldUExtract(fragment_unnamed_297, fragment_unnamed_309, min((8u & 31u), (32u - fragment_unnamed_309))) : ((0.125f < fragment_unnamed_294) ? spvBitfieldUExtract(fragment_unnamed_297, fragment_unnamed_316, min((8u & 31u), (32u - fragment_unnamed_316))) : (fragment_unnamed_297 & 255u)));
				float fragment_unnamed_326 = float(fragment_unnamed_324 >> 5u);
				float fragment_unnamed_331 = asfloat((6.5f < fragment_unnamed_326) ? 0u : asuint(fragment_unnamed_326));
				float fragment_unnamed_338 = round(fragment_uniform_buffer_0[15u].y * 3.0f);
				discard_cond(fragment_unnamed_331 < (fragment_unnamed_338 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_338 + 3.9900000095367431640625f) < fragment_unnamed_331);
				float fragment_unnamed_357 = mad(fragment_unnamed_232, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_358 = mad(fragment_unnamed_232, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_369 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_357)) : asuint(floor(fragment_unnamed_357)));
				float fragment_unnamed_371 = asfloat(fragment_unnamed_235 ? asuint(ceil(fragment_unnamed_358)) : asuint(floor(fragment_unnamed_358)));
				uint fragment_unnamed_373 = uint(ceil(max(abs(fragment_unnamed_233) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_392 = uint(asfloat((0.0f < fragment_unnamed_369) ? asuint(fragment_unnamed_369 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_246 + ((-0.0f) - fragment_unnamed_369)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_393 = uint(asfloat((0.0f < fragment_unnamed_371) ? asuint(fragment_unnamed_371 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_246 + ((-0.0f) - fragment_unnamed_371)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_394 = _OffsetsBuffer.Load(fragment_unnamed_392);
				uint fragment_unnamed_395 = fragment_unnamed_394.x;
				uint4 fragment_unnamed_396 = _OffsetsBuffer.Load(fragment_unnamed_393);
				uint fragment_unnamed_397 = fragment_unnamed_396.x;
				uint fragment_unnamed_408 = (fragment_unnamed_254 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_411 = (fragment_unnamed_254 != (fragment_unnamed_147 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_414 = (fragment_unnamed_147 != fragment_unnamed_254) ? 4294967295u : 0u;
				uint fragment_unnamed_418 = (fragment_unnamed_254 != (uint(fragment_uniform_buffer_0[18u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_434 = (fragment_unnamed_418 & (fragment_unnamed_414 & (fragment_unnamed_408 & fragment_unnamed_411))) != 0u;
				uint fragment_unnamed_437 = asuint(fragment_unnamed_264);
				float fragment_unnamed_439 = asfloat(fragment_unnamed_434 ? asuint(float((-fragment_unnamed_395) + _OffsetsBuffer.Load(fragment_unnamed_392 + 1u).x)) : fragment_unnamed_437);
				float fragment_unnamed_441 = asfloat(fragment_unnamed_434 ? asuint(float((-fragment_unnamed_397) + _OffsetsBuffer.Load(fragment_unnamed_393 + 1u).x)) : fragment_unnamed_437);
				float fragment_unnamed_443 = fragment_unnamed_265 * fragment_unnamed_439;
				float fragment_unnamed_444 = fragment_unnamed_265 * fragment_unnamed_441;
				float fragment_unnamed_445 = mad(fragment_unnamed_265, fragment_unnamed_264, 0.5f);
				float fragment_unnamed_446 = mad(fragment_unnamed_265, fragment_unnamed_264, -0.5f);
				float fragment_unnamed_453 = asfloat((fragment_unnamed_264 < fragment_unnamed_445) ? asuint(((-0.0f) - fragment_unnamed_264) + fragment_unnamed_445) : asuint(fragment_unnamed_445));
				float fragment_unnamed_459 = asfloat((fragment_unnamed_446 < 0.0f) ? asuint(fragment_unnamed_264 + fragment_unnamed_446) : asuint(fragment_unnamed_446));
				float fragment_unnamed_469 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_443)) : asuint(floor(fragment_unnamed_443)));
				float fragment_unnamed_471 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_444)) : asuint(floor(fragment_unnamed_444)));
				float fragment_unnamed_477 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_453)) : asuint(floor(fragment_unnamed_453)));
				float fragment_unnamed_483 = asfloat(fragment_unnamed_268 ? asuint(ceil(fragment_unnamed_459)) : asuint(floor(fragment_unnamed_459)));
				float fragment_unnamed_484 = frac(fragment_unnamed_233);
				float fragment_unnamed_485 = frac(fragment_unnamed_267);
				float fragment_unnamed_486 = fragment_unnamed_484 + (-0.5f);
				float fragment_unnamed_495 = min((((-0.0f) - fragment_unnamed_485) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_497 = min(fragment_unnamed_485 * 40.0f, 1.0f);
				float fragment_unnamed_498 = min(fragment_unnamed_484 * 40.0f, 1.0f);
				float fragment_unnamed_554 = float(fragment_unnamed_395 + uint(asfloat((mad(fragment_unnamed_439, 0.5f, 0.5f) < fragment_unnamed_469) ? asuint(mad((-0.0f) - fragment_unnamed_439, 0.5f, fragment_unnamed_469) + (-1.0f)) : asuint(fragment_unnamed_439 + ((-0.0f) - fragment_unnamed_469))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_556 = frac(fragment_unnamed_554);
				uint4 fragment_unnamed_558 = _DataBuffer.Load(uint(floor(fragment_unnamed_554)));
				uint fragment_unnamed_559 = fragment_unnamed_558.x;
				uint fragment_unnamed_565 = 16u & 31u;
				uint fragment_unnamed_570 = 8u & 31u;
				float fragment_unnamed_580 = float(uint(asfloat((mad(fragment_unnamed_441, 0.5f, 0.5f) < fragment_unnamed_471) ? asuint(mad((-0.0f) - fragment_unnamed_441, 0.5f, fragment_unnamed_471) + (-1.0f)) : asuint(fragment_unnamed_441 + ((-0.0f) - fragment_unnamed_471))) + 0.100000001490116119384765625f) + fragment_unnamed_397) * 0.25f;
				float fragment_unnamed_582 = frac(fragment_unnamed_580);
				uint4 fragment_unnamed_584 = _DataBuffer.Load(uint(floor(fragment_unnamed_580)));
				uint fragment_unnamed_585 = fragment_unnamed_584.x;
				uint fragment_unnamed_591 = 16u & 31u;
				uint fragment_unnamed_596 = 8u & 31u;
				float fragment_unnamed_606 = float(uint(asfloat((fragment_unnamed_275 < fragment_unnamed_477) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_477) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_477) + fragment_unnamed_264)) + 0.100000001490116119384765625f) + fragment_unnamed_257) * 0.25f;
				float fragment_unnamed_608 = frac(fragment_unnamed_606);
				uint4 fragment_unnamed_610 = _DataBuffer.Load(uint(floor(fragment_unnamed_606)));
				uint fragment_unnamed_611 = fragment_unnamed_610.x;
				uint fragment_unnamed_617 = 16u & 31u;
				uint fragment_unnamed_622 = 8u & 31u;
				float fragment_unnamed_632 = float(uint(asfloat((fragment_unnamed_275 < fragment_unnamed_483) ? asuint(mad((-0.0f) - fragment_unnamed_264, 0.5f, fragment_unnamed_483) + (-1.0f)) : asuint(fragment_unnamed_264 + ((-0.0f) - fragment_unnamed_483))) + 0.100000001490116119384765625f) + fragment_unnamed_257) * 0.25f;
				float fragment_unnamed_634 = frac(fragment_unnamed_632);
				uint4 fragment_unnamed_636 = _DataBuffer.Load(uint(floor(fragment_unnamed_632)));
				uint fragment_unnamed_637 = fragment_unnamed_636.x;
				uint fragment_unnamed_643 = 16u & 31u;
				uint fragment_unnamed_648 = 8u & 31u;
				float fragment_unnamed_658 = float(((0.625f < fragment_unnamed_582) ? (fragment_unnamed_585 >> 24u) : ((0.375f < fragment_unnamed_582) ? spvBitfieldUExtract(fragment_unnamed_585, fragment_unnamed_591, min((8u & 31u), (32u - fragment_unnamed_591))) : ((0.125f < fragment_unnamed_582) ? spvBitfieldUExtract(fragment_unnamed_585, fragment_unnamed_596, min((8u & 31u), (32u - fragment_unnamed_596))) : (fragment_unnamed_585 & 255u)))) >> 5u);
				float fragment_unnamed_660 = float(((0.625f < fragment_unnamed_608) ? (fragment_unnamed_611 >> 24u) : ((0.375f < fragment_unnamed_608) ? spvBitfieldUExtract(fragment_unnamed_611, fragment_unnamed_617, min((8u & 31u), (32u - fragment_unnamed_617))) : ((0.125f < fragment_unnamed_608) ? spvBitfieldUExtract(fragment_unnamed_611, fragment_unnamed_622, min((8u & 31u), (32u - fragment_unnamed_622))) : (fragment_unnamed_611 & 255u)))) >> 5u);
				float fragment_unnamed_662 = float(((0.625f < fragment_unnamed_634) ? (fragment_unnamed_637 >> 24u) : ((0.375f < fragment_unnamed_634) ? spvBitfieldUExtract(fragment_unnamed_637, fragment_unnamed_643, min((8u & 31u), (32u - fragment_unnamed_643))) : ((0.125f < fragment_unnamed_634) ? spvBitfieldUExtract(fragment_unnamed_637, fragment_unnamed_648, min((8u & 31u), (32u - fragment_unnamed_648))) : (fragment_unnamed_637 & 255u)))) >> 5u);
				float fragment_unnamed_663 = float(((0.625f < fragment_unnamed_556) ? (fragment_unnamed_559 >> 24u) : ((0.375f < fragment_unnamed_556) ? spvBitfieldUExtract(fragment_unnamed_559, fragment_unnamed_565, min((8u & 31u), (32u - fragment_unnamed_565))) : ((0.125f < fragment_unnamed_556) ? spvBitfieldUExtract(fragment_unnamed_559, fragment_unnamed_570, min((8u & 31u), (32u - fragment_unnamed_570))) : (fragment_unnamed_559 & 255u)))) >> 5u);
				float fragment_unnamed_674 = fragment_unnamed_267 * 0.20000000298023223876953125f;
				float fragment_unnamed_676 = fragment_unnamed_232 * 0.06366197764873504638671875f;
				float fragment_unnamed_678 = (fragment_unnamed_265 * float((-_OffsetsBuffer.Load(fragment_unnamed_373).x) + _OffsetsBuffer.Load(fragment_unnamed_373 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_685 = ddx_coarse(fragment_input_11.x);
				float fragment_unnamed_686 = ddx_coarse(fragment_input_11.y);
				float fragment_unnamed_687 = ddx_coarse(fragment_input_11.z);
				float fragment_unnamed_691 = sqrt(dot(float3(fragment_unnamed_685, fragment_unnamed_686, fragment_unnamed_687), float3(fragment_unnamed_685, fragment_unnamed_686, fragment_unnamed_687)));
				float fragment_unnamed_698 = ddy_coarse(fragment_input_11.x);
				float fragment_unnamed_699 = ddy_coarse(fragment_input_11.y);
				float fragment_unnamed_700 = ddy_coarse(fragment_input_11.z);
				float fragment_unnamed_704 = sqrt(dot(float3(fragment_unnamed_698, fragment_unnamed_699, fragment_unnamed_700), float3(fragment_unnamed_698, fragment_unnamed_699, fragment_unnamed_700)));
				float fragment_unnamed_715 = min(max(log2(sqrt(dot(float2(fragment_unnamed_691, fragment_unnamed_704), float2(fragment_unnamed_691, fragment_unnamed_704))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_717 = min((((-0.0f) - fragment_unnamed_484) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_784;
				float fragment_unnamed_786;
				float fragment_unnamed_788;
				float fragment_unnamed_790;
				float fragment_unnamed_792;
				float fragment_unnamed_794;
				float fragment_unnamed_796;
				float fragment_unnamed_798;
				float fragment_unnamed_800;
				float fragment_unnamed_802;
				float fragment_unnamed_804;
				float fragment_unnamed_806;
				float fragment_unnamed_808;
				float fragment_unnamed_810;
				if (((((fragment_unnamed_338 + 0.9900000095367431640625f) < fragment_unnamed_331) ? 4294967295u : 0u) & ((fragment_unnamed_331 < (fragment_unnamed_338 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_730 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
					float4 fragment_unnamed_736 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
					float4 fragment_unnamed_743 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
					float fragment_unnamed_749 = mad(fragment_unnamed_743.w * fragment_unnamed_743.x, 2.0f, -1.0f);
					float fragment_unnamed_751 = mad(fragment_unnamed_743.y, 2.0f, -1.0f);
					float4 fragment_unnamed_759 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
					float fragment_unnamed_765 = mad(fragment_unnamed_759.w * fragment_unnamed_759.x, 2.0f, -1.0f);
					float fragment_unnamed_766 = mad(fragment_unnamed_759.y, 2.0f, -1.0f);
					fragment_unnamed_784 = fragment_unnamed_730.x;
					fragment_unnamed_786 = fragment_unnamed_730.y;
					fragment_unnamed_788 = fragment_unnamed_730.z;
					fragment_unnamed_790 = fragment_unnamed_736.x;
					fragment_unnamed_792 = fragment_unnamed_736.y;
					fragment_unnamed_794 = fragment_unnamed_736.z;
					fragment_unnamed_796 = fragment_unnamed_730.w;
					fragment_unnamed_798 = fragment_unnamed_736.w;
					fragment_unnamed_800 = fragment_unnamed_749;
					fragment_unnamed_802 = fragment_unnamed_751;
					fragment_unnamed_804 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_749, fragment_unnamed_751), float2(fragment_unnamed_749, fragment_unnamed_751)), 1.0f)) + 1.0f);
					fragment_unnamed_806 = fragment_unnamed_765;
					fragment_unnamed_808 = fragment_unnamed_766;
					fragment_unnamed_810 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_765, fragment_unnamed_766), float2(fragment_unnamed_765, fragment_unnamed_766)), 1.0f)) + 1.0f);
				}
				else
				{
					float fragment_unnamed_785;
					float fragment_unnamed_787;
					float fragment_unnamed_789;
					float fragment_unnamed_791;
					float fragment_unnamed_793;
					float fragment_unnamed_795;
					float fragment_unnamed_797;
					float fragment_unnamed_799;
					float fragment_unnamed_801;
					float fragment_unnamed_803;
					float fragment_unnamed_805;
					float fragment_unnamed_807;
					float fragment_unnamed_809;
					float fragment_unnamed_811;
					if (((((fragment_unnamed_338 + 1.9900000095367431640625f) < fragment_unnamed_331) ? 4294967295u : 0u) & ((fragment_unnamed_331 < (fragment_unnamed_338 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1249 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float4 fragment_unnamed_1255 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float4 fragment_unnamed_1262 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float fragment_unnamed_1268 = mad(fragment_unnamed_1262.w * fragment_unnamed_1262.x, 2.0f, -1.0f);
						float fragment_unnamed_1269 = mad(fragment_unnamed_1262.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1277 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float fragment_unnamed_1283 = mad(fragment_unnamed_1277.w * fragment_unnamed_1277.x, 2.0f, -1.0f);
						float fragment_unnamed_1284 = mad(fragment_unnamed_1277.y, 2.0f, -1.0f);
						fragment_unnamed_785 = fragment_unnamed_1249.x;
						fragment_unnamed_787 = fragment_unnamed_1249.y;
						fragment_unnamed_789 = fragment_unnamed_1249.z;
						fragment_unnamed_791 = fragment_unnamed_1255.x;
						fragment_unnamed_793 = fragment_unnamed_1255.y;
						fragment_unnamed_795 = fragment_unnamed_1255.z;
						fragment_unnamed_797 = fragment_unnamed_1249.w;
						fragment_unnamed_799 = fragment_unnamed_1255.w;
						fragment_unnamed_801 = fragment_unnamed_1268;
						fragment_unnamed_803 = fragment_unnamed_1269;
						fragment_unnamed_805 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1268, fragment_unnamed_1269), float2(fragment_unnamed_1268, fragment_unnamed_1269)), 1.0f)) + 1.0f);
						fragment_unnamed_807 = fragment_unnamed_1283;
						fragment_unnamed_809 = fragment_unnamed_1284;
						fragment_unnamed_811 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1283, fragment_unnamed_1284), float2(fragment_unnamed_1283, fragment_unnamed_1284)), 1.0f)) + 1.0f);
					}
					else
					{
						float4 fragment_unnamed_1293 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float4 fragment_unnamed_1299 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float4 fragment_unnamed_1306 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_676, fragment_unnamed_674), fragment_unnamed_715);
						float fragment_unnamed_1312 = mad(fragment_unnamed_1306.w * fragment_unnamed_1306.x, 2.0f, -1.0f);
						float fragment_unnamed_1313 = mad(fragment_unnamed_1306.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1321 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_676, fragment_unnamed_678), fragment_unnamed_715);
						float fragment_unnamed_1327 = mad(fragment_unnamed_1321.w * fragment_unnamed_1321.x, 2.0f, -1.0f);
						float fragment_unnamed_1328 = mad(fragment_unnamed_1321.y, 2.0f, -1.0f);
						fragment_unnamed_785 = fragment_unnamed_1293.x;
						fragment_unnamed_787 = fragment_unnamed_1293.y;
						fragment_unnamed_789 = fragment_unnamed_1293.z;
						fragment_unnamed_791 = fragment_unnamed_1299.x;
						fragment_unnamed_793 = fragment_unnamed_1299.y;
						fragment_unnamed_795 = fragment_unnamed_1299.z;
						fragment_unnamed_797 = fragment_unnamed_1293.w;
						fragment_unnamed_799 = fragment_unnamed_1299.w;
						fragment_unnamed_801 = fragment_unnamed_1312;
						fragment_unnamed_803 = fragment_unnamed_1313;
						fragment_unnamed_805 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1312, fragment_unnamed_1313), float2(fragment_unnamed_1312, fragment_unnamed_1313)), 1.0f)) + 1.0f);
						fragment_unnamed_807 = fragment_unnamed_1327;
						fragment_unnamed_809 = fragment_unnamed_1328;
						fragment_unnamed_811 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1327, fragment_unnamed_1328), float2(fragment_unnamed_1327, fragment_unnamed_1328)), 1.0f)) + 1.0f);
					}
					fragment_unnamed_784 = fragment_unnamed_785;
					fragment_unnamed_786 = fragment_unnamed_787;
					fragment_unnamed_788 = fragment_unnamed_789;
					fragment_unnamed_790 = fragment_unnamed_791;
					fragment_unnamed_792 = fragment_unnamed_793;
					fragment_unnamed_794 = fragment_unnamed_795;
					fragment_unnamed_796 = fragment_unnamed_797;
					fragment_unnamed_798 = fragment_unnamed_799;
					fragment_unnamed_800 = fragment_unnamed_801;
					fragment_unnamed_802 = fragment_unnamed_803;
					fragment_unnamed_804 = fragment_unnamed_805;
					fragment_unnamed_806 = fragment_unnamed_807;
					fragment_unnamed_808 = fragment_unnamed_809;
					fragment_unnamed_810 = fragment_unnamed_811;
				}
				float4 fragment_unnamed_818 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_324 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_826 = fragment_unnamed_818.w * 0.800000011920928955078125f;
				float fragment_unnamed_828 = mad(fragment_unnamed_818.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_836 = exp2(log2(abs(fragment_unnamed_486) + abs(fragment_unnamed_486)) * 10.0f);
				float fragment_unnamed_855 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_802) + fragment_unnamed_808, fragment_unnamed_802);
				float fragment_unnamed_856 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_800) + fragment_unnamed_806, fragment_unnamed_800);
				float fragment_unnamed_857 = mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_804) + fragment_unnamed_810, fragment_unnamed_804);
				float fragment_unnamed_858 = (fragment_unnamed_828 * fragment_unnamed_818.x) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_784) + fragment_unnamed_790, fragment_unnamed_784);
				float fragment_unnamed_859 = (fragment_unnamed_828 * fragment_unnamed_818.y) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_786) + fragment_unnamed_792, fragment_unnamed_786);
				float fragment_unnamed_860 = (fragment_unnamed_828 * fragment_unnamed_818.z) * mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_788) + fragment_unnamed_794, fragment_unnamed_788);
				float fragment_unnamed_867 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_unnamed_858), fragment_unnamed_858);
				float fragment_unnamed_868 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_unnamed_859), fragment_unnamed_859);
				float fragment_unnamed_869 = mad(fragment_unnamed_818.w, mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_unnamed_860), fragment_unnamed_860);
				float fragment_unnamed_871 = ((-0.0f) - mad(fragment_unnamed_836, ((-0.0f) - fragment_unnamed_796) + fragment_unnamed_798, fragment_unnamed_796)) + 1.0f;
				float fragment_unnamed_875 = fragment_unnamed_871 * fragment_uniform_buffer_0[8u].w;
				float fragment_unnamed_884 = mad(fragment_unnamed_818.w, mad((-0.0f) - fragment_unnamed_871, fragment_uniform_buffer_0[8u].w, clamp(fragment_unnamed_875 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_875);
				bool fragment_unnamed_918 = (fragment_unnamed_411 & (fragment_unnamed_414 & (((fragment_unnamed_663 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_663) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_926 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_867) : asuint(fragment_unnamed_867);
				uint fragment_unnamed_928 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_868) : asuint(fragment_unnamed_868);
				uint fragment_unnamed_930 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * fragment_unnamed_869) : asuint(fragment_unnamed_869);
				uint fragment_unnamed_932 = fragment_unnamed_918 ? asuint(fragment_unnamed_717 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_943 = (fragment_unnamed_418 & (fragment_unnamed_408 & (((fragment_unnamed_658 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_658) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_948 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_926)) : fragment_unnamed_926;
				uint fragment_unnamed_950 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_928)) : fragment_unnamed_928;
				uint fragment_unnamed_952 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_930)) : fragment_unnamed_930;
				uint fragment_unnamed_954 = fragment_unnamed_943 ? asuint(fragment_unnamed_498 * asfloat(fragment_unnamed_932)) : fragment_unnamed_932;
				bool fragment_unnamed_963 = (((fragment_unnamed_660 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_660) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_968 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_948)) : fragment_unnamed_948;
				uint fragment_unnamed_970 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_950)) : fragment_unnamed_950;
				uint fragment_unnamed_972 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_952)) : fragment_unnamed_952;
				uint fragment_unnamed_974 = fragment_unnamed_963 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_954)) : fragment_unnamed_954;
				bool fragment_unnamed_983 = (((fragment_unnamed_662 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_662) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_989 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_974)) : fragment_unnamed_974);
				discard_cond((fragment_unnamed_989 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1009 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_10.x / fragment_input_10.w, fragment_input_10.y / fragment_input_10.w));
				float fragment_unnamed_1011 = fragment_unnamed_1009.x;
				float fragment_unnamed_1012 = fragment_unnamed_1009.y;
				float fragment_unnamed_1013 = fragment_unnamed_1009.z;
				float fragment_unnamed_1018 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_968)) : fragment_unnamed_968) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1019 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_970)) : fragment_unnamed_970) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1020 = asfloat(fragment_unnamed_983 ? asuint(fragment_unnamed_497 * asfloat(fragment_unnamed_972)) : fragment_unnamed_972) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1032 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1033 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1034 = fragment_uniform_buffer_0[17u].x + fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1035 = fragment_uniform_buffer_0[17u].y + fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1041 = fragment_unnamed_1034 * fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1042 = fragment_unnamed_1035 * fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1043 = fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1051 = fragment_unnamed_1034 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1052 = fragment_unnamed_1035 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1056 = fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1087 = mad(fragment_unnamed_1052 + (fragment_unnamed_1032 * fragment_uniform_buffer_0[17u].x), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1035, (-0.0f) - fragment_unnamed_1056), fragment_input_5.y, (((-0.0f) - (fragment_unnamed_1043 + fragment_unnamed_1042)) + 1.0f) * fragment_input_5.x));
				float fragment_unnamed_1105 = mad(mad(fragment_uniform_buffer_0[17u].y, fragment_unnamed_1033, (-0.0f) - fragment_unnamed_1051), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1035, fragment_unnamed_1056), fragment_input_5.x, (((-0.0f) - (fragment_unnamed_1043 + fragment_unnamed_1041)) + 1.0f) * fragment_input_5.y));
				float fragment_unnamed_1111 = mad(((-0.0f) - (fragment_unnamed_1042 + fragment_unnamed_1041)) + 1.0f, fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1032, (-0.0f) - fragment_unnamed_1052), fragment_input_5.x, (fragment_unnamed_1051 + (fragment_unnamed_1033 * fragment_uniform_buffer_0[17u].y)) * fragment_input_5.y));
				float fragment_unnamed_1115 = rsqrt(dot(float3(fragment_unnamed_1087, fragment_unnamed_1105, fragment_unnamed_1111), float3(fragment_unnamed_1087, fragment_unnamed_1105, fragment_unnamed_1111)));
				float fragment_unnamed_1116 = fragment_unnamed_1115 * fragment_unnamed_1087;
				float fragment_unnamed_1117 = fragment_unnamed_1115 * fragment_unnamed_1105;
				float fragment_unnamed_1118 = fragment_unnamed_1115 * fragment_unnamed_1111;
				float fragment_unnamed_1125 = mad(mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1018), 0.5f, fragment_unnamed_1018);
				float fragment_unnamed_1126 = mad(mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1019), 0.5f, fragment_unnamed_1019);
				float fragment_unnamed_1127 = mad(mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_unnamed_1020), 0.5f, fragment_unnamed_1020);
				float fragment_unnamed_1128 = dot(float3(fragment_unnamed_1125, fragment_unnamed_1126, fragment_unnamed_1127), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1134 = mad(((-0.0f) - fragment_unnamed_1128) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1128);
				float fragment_unnamed_1140 = (-0.0f) - fragment_unnamed_1134;
				float fragment_unnamed_1168 = mad((-0.0f) - fragment_uniform_buffer_0[19u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1195 = ((-0.0f) - fragment_input_4.x) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1196 = ((-0.0f) - fragment_input_4.y) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1197 = ((-0.0f) - fragment_input_4.z) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1201 = rsqrt(dot(float3(fragment_unnamed_1195, fragment_unnamed_1196, fragment_unnamed_1197), float3(fragment_unnamed_1195, fragment_unnamed_1196, fragment_unnamed_1197)));
				float fragment_unnamed_1202 = fragment_unnamed_1201 * fragment_unnamed_1195;
				float fragment_unnamed_1203 = fragment_unnamed_1201 * fragment_unnamed_1196;
				float fragment_unnamed_1204 = fragment_unnamed_1201 * fragment_unnamed_1197;
				float fragment_unnamed_1241 = mad(fragment_uniform_buffer_0[6u].x, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].x)) + fragment_uniform_buffer_0[7u].x;
				float fragment_unnamed_1242 = mad(fragment_uniform_buffer_0[6u].y, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].y)) + fragment_uniform_buffer_0[7u].y;
				float fragment_unnamed_1243 = mad(fragment_uniform_buffer_0[6u].z, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].z)) + fragment_uniform_buffer_0[7u].z;
				float fragment_unnamed_1425;
				float fragment_unnamed_1426;
				float fragment_unnamed_1427;
				float fragment_unnamed_1428;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1339 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1415 = _LightTextureB0.Sample(sampler_LightTextureB0, float3(max(mad(((fragment_unnamed_1339 ? (mad(fragment_uniform_buffer_3[3u].x, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : fragment_input_4.x) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), ((fragment_unnamed_1339 ? (mad(fragment_uniform_buffer_3[3u].y, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : fragment_input_4.y) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, ((fragment_unnamed_1339 ? (mad(fragment_uniform_buffer_3[3u].z, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : fragment_input_4.z) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1425 = fragment_unnamed_1415.x;
					fragment_unnamed_1426 = fragment_unnamed_1415.y;
					fragment_unnamed_1427 = fragment_unnamed_1415.z;
					fragment_unnamed_1428 = fragment_unnamed_1415.w;
				}
				else
				{
					fragment_unnamed_1425 = asfloat(1065353216u);
					fragment_unnamed_1426 = asfloat(1065353216u);
					fragment_unnamed_1427 = asfloat(1065353216u);
					fragment_unnamed_1428 = asfloat(1065353216u);
				}
				float fragment_unnamed_1439 = clamp(dot(float4(fragment_unnamed_1425, fragment_unnamed_1426, fragment_unnamed_1427, fragment_unnamed_1428), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float4 fragment_unnamed_1444 = _LightTexture0.Sample(sampler_LightTexture0, dot(float3(fragment_unnamed_1241, fragment_unnamed_1242, fragment_unnamed_1243), float3(fragment_unnamed_1241, fragment_unnamed_1242, fragment_unnamed_1243)).xx);
				float4 fragment_unnamed_1449 = _Global_PGI.Sample(sampler_Global_PGI, float3(fragment_unnamed_1241, fragment_unnamed_1242, fragment_unnamed_1243));
				float fragment_unnamed_1452 = fragment_unnamed_1444.x * fragment_unnamed_1449.w;
				float fragment_unnamed_1460 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1469 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1478 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_855, fragment_unnamed_856, fragment_unnamed_857));
				float fragment_unnamed_1484 = rsqrt(dot(float3(fragment_unnamed_1460, fragment_unnamed_1469, fragment_unnamed_1478), float3(fragment_unnamed_1460, fragment_unnamed_1469, fragment_unnamed_1478)));
				float fragment_unnamed_1485 = fragment_unnamed_1484 * fragment_unnamed_1460;
				float fragment_unnamed_1486 = fragment_unnamed_1484 * fragment_unnamed_1469;
				float fragment_unnamed_1487 = fragment_unnamed_1484 * fragment_unnamed_1478;
				float fragment_unnamed_1508 = ((-0.0f) - fragment_uniform_buffer_0[9u].x) + 1.0f;
				float fragment_unnamed_1509 = ((-0.0f) - fragment_uniform_buffer_0[9u].y) + 1.0f;
				float fragment_unnamed_1510 = ((-0.0f) - fragment_uniform_buffer_0[9u].z) + 1.0f;
				float fragment_unnamed_1522 = dot(float3(fragment_unnamed_1485, fragment_unnamed_1486, fragment_unnamed_1487), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1525 = mad(fragment_unnamed_1522, 0.25f, 1.0f);
				float fragment_unnamed_1527 = fragment_unnamed_1525 * (fragment_unnamed_1525 * fragment_unnamed_1525);
				float fragment_unnamed_1532 = exp2(log2(max(fragment_unnamed_1522, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1533 = fragment_unnamed_1532 + fragment_unnamed_1532;
				float fragment_unnamed_1544 = asfloat((0.5f < fragment_unnamed_1532) ? asuint(mad(log2(mad(log2(fragment_unnamed_1533), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1533)) * 0.5f;
				float fragment_unnamed_1550 = dot(float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1693;
				float fragment_unnamed_1694;
				float fragment_unnamed_1695;
				if (1.0f >= fragment_unnamed_1550)
				{
					float fragment_unnamed_1572 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].x) + 1.0f), fragment_unnamed_1508, 1.0f);
					float fragment_unnamed_1573 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].y) + 1.0f), fragment_unnamed_1509, 1.0f);
					float fragment_unnamed_1574 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].z) + 1.0f), fragment_unnamed_1510, 1.0f);
					float fragment_unnamed_1590 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].x) + 1.0f), fragment_unnamed_1508, 1.0f);
					float fragment_unnamed_1591 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].y) + 1.0f), fragment_unnamed_1509, 1.0f);
					float fragment_unnamed_1592 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].z) + 1.0f), fragment_unnamed_1510, 1.0f);
					float fragment_unnamed_1621 = clamp((fragment_unnamed_1550 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1622 = clamp((fragment_unnamed_1550 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1623 = clamp((fragment_unnamed_1550 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1624 = clamp((fragment_unnamed_1550 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1647 = 0.20000000298023223876953125f < fragment_unnamed_1550;
					bool fragment_unnamed_1648 = 0.100000001490116119384765625f < fragment_unnamed_1550;
					bool fragment_unnamed_1649 = (-0.100000001490116119384765625f) < fragment_unnamed_1550;
					float fragment_unnamed_1650 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].x) + 1.0f), fragment_unnamed_1508, 1.0f) * 1.5f;
					float fragment_unnamed_1652 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].y) + 1.0f), fragment_unnamed_1509, 1.0f) * 1.5f;
					float fragment_unnamed_1653 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].z) + 1.0f), fragment_unnamed_1510, 1.0f) * 1.5f;
					fragment_unnamed_1693 = asfloat(fragment_unnamed_1647 ? asuint(mad(fragment_unnamed_1621, ((-0.0f) - fragment_unnamed_1572) + 1.0f, fragment_unnamed_1572)) : (fragment_unnamed_1648 ? asuint(mad(fragment_unnamed_1622, mad((-0.0f) - fragment_unnamed_1590, 1.25f, fragment_unnamed_1572), fragment_unnamed_1590 * 1.25f)) : (fragment_unnamed_1649 ? asuint(mad(fragment_unnamed_1623, mad(fragment_unnamed_1590, 1.25f, (-0.0f) - fragment_unnamed_1650), fragment_unnamed_1650)) : asuint(fragment_unnamed_1650 * fragment_unnamed_1624))));
					fragment_unnamed_1694 = asfloat(fragment_unnamed_1647 ? asuint(mad(fragment_unnamed_1621, ((-0.0f) - fragment_unnamed_1573) + 1.0f, fragment_unnamed_1573)) : (fragment_unnamed_1648 ? asuint(mad(fragment_unnamed_1622, mad((-0.0f) - fragment_unnamed_1591, 1.25f, fragment_unnamed_1573), fragment_unnamed_1591 * 1.25f)) : (fragment_unnamed_1649 ? asuint(mad(fragment_unnamed_1623, mad(fragment_unnamed_1591, 1.25f, (-0.0f) - fragment_unnamed_1652), fragment_unnamed_1652)) : asuint(fragment_unnamed_1652 * fragment_unnamed_1624))));
					fragment_unnamed_1695 = asfloat(fragment_unnamed_1647 ? asuint(mad(fragment_unnamed_1621, ((-0.0f) - fragment_unnamed_1574) + 1.0f, fragment_unnamed_1574)) : (fragment_unnamed_1648 ? asuint(mad(fragment_unnamed_1622, mad((-0.0f) - fragment_unnamed_1592, 1.25f, fragment_unnamed_1574), fragment_unnamed_1592 * 1.25f)) : (fragment_unnamed_1649 ? asuint(mad(fragment_unnamed_1623, mad(fragment_unnamed_1592, 1.25f, (-0.0f) - fragment_unnamed_1653), fragment_unnamed_1653)) : asuint(fragment_unnamed_1653 * fragment_unnamed_1624))));
				}
				else
				{
					fragment_unnamed_1693 = asfloat(1065353216u);
					fragment_unnamed_1694 = asfloat(1065353216u);
					fragment_unnamed_1695 = asfloat(1065353216u);
				}
				float fragment_unnamed_1703 = clamp(fragment_unnamed_1550 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1707 = mad(clamp(fragment_unnamed_1550 * 0.1500000059604644775390625f, 0.0f, 1.0f), mad((-0.0f) - fragment_unnamed_1452, fragment_unnamed_1439, 1.0f), fragment_unnamed_1439 * fragment_unnamed_1452) * 0.800000011920928955078125f;
				float fragment_unnamed_1719 = min(max((((-0.0f) - fragment_uniform_buffer_0[15u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1728 = mad(clamp(mad(log2(fragment_uniform_buffer_0[15u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1745 = mad(exp2(log2(fragment_uniform_buffer_0[10u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1748 = mad(exp2(log2(fragment_uniform_buffer_0[10u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1749 = mad(exp2(log2(fragment_uniform_buffer_0[10u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1781 = mad(exp2(log2(fragment_uniform_buffer_0[11u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1782 = mad(exp2(log2(fragment_uniform_buffer_0[11u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1783 = mad(exp2(log2(fragment_uniform_buffer_0[11u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1793 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1781) + 0.0240000002086162567138671875f, fragment_unnamed_1781);
				float fragment_unnamed_1794 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1782) + 0.0240000002086162567138671875f, fragment_unnamed_1782);
				float fragment_unnamed_1795 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1783) + 0.0240000002086162567138671875f, fragment_unnamed_1783);
				float fragment_unnamed_1811 = mad(exp2(log2(fragment_uniform_buffer_0[12u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1812 = mad(exp2(log2(fragment_uniform_buffer_0[12u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1813 = mad(exp2(log2(fragment_uniform_buffer_0[12u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1826 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1811, fragment_unnamed_1719, 0.0240000002086162567138671875f), fragment_unnamed_1719 * fragment_unnamed_1811);
				float fragment_unnamed_1827 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1812, fragment_unnamed_1719, 0.0240000002086162567138671875f), fragment_unnamed_1719 * fragment_unnamed_1812);
				float fragment_unnamed_1828 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1813, fragment_unnamed_1719, 0.0240000002086162567138671875f), fragment_unnamed_1719 * fragment_unnamed_1813);
				float fragment_unnamed_1829 = dot(float3(fragment_unnamed_1793, fragment_unnamed_1794, fragment_unnamed_1795), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1838 = mad(((-0.0f) - fragment_unnamed_1793) + fragment_unnamed_1829, 0.300000011920928955078125f, fragment_unnamed_1793);
				float fragment_unnamed_1839 = mad(((-0.0f) - fragment_unnamed_1794) + fragment_unnamed_1829, 0.300000011920928955078125f, fragment_unnamed_1794);
				float fragment_unnamed_1840 = mad(((-0.0f) - fragment_unnamed_1795) + fragment_unnamed_1829, 0.300000011920928955078125f, fragment_unnamed_1795);
				float fragment_unnamed_1841 = dot(float3(fragment_unnamed_1826, fragment_unnamed_1827, fragment_unnamed_1828), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1850 = mad(((-0.0f) - fragment_unnamed_1826) + fragment_unnamed_1841, 0.300000011920928955078125f, fragment_unnamed_1826);
				float fragment_unnamed_1851 = mad(((-0.0f) - fragment_unnamed_1827) + fragment_unnamed_1841, 0.300000011920928955078125f, fragment_unnamed_1827);
				float fragment_unnamed_1852 = mad(((-0.0f) - fragment_unnamed_1828) + fragment_unnamed_1841, 0.300000011920928955078125f, fragment_unnamed_1828);
				bool fragment_unnamed_1853 = 0.0f < fragment_unnamed_1550;
				float fragment_unnamed_1866 = clamp(mad(fragment_unnamed_1550, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1867 = clamp(mad(fragment_unnamed_1550, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1891 = clamp(mad(dot(float3(fragment_unnamed_1485, fragment_unnamed_1486, fragment_unnamed_1487), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1895 = asfloat(asuint(fragment_uniform_buffer_0[14u]).x) + 1.0f;
				float fragment_unnamed_1902 = dot(float3((-0.0f) - fragment_unnamed_1202, (-0.0f) - fragment_unnamed_1203, (-0.0f) - fragment_unnamed_1204), float3(fragment_unnamed_1485, fragment_unnamed_1486, fragment_unnamed_1487));
				float fragment_unnamed_1906 = (-0.0f) - (fragment_unnamed_1902 + fragment_unnamed_1902);
				float fragment_unnamed_1910 = mad(fragment_unnamed_1485, fragment_unnamed_1906, (-0.0f) - fragment_unnamed_1202);
				float fragment_unnamed_1911 = mad(fragment_unnamed_1486, fragment_unnamed_1906, (-0.0f) - fragment_unnamed_1203);
				float fragment_unnamed_1912 = mad(fragment_unnamed_1487, fragment_unnamed_1906, (-0.0f) - fragment_unnamed_1204);
				uint fragment_unnamed_1928 = (fragment_uniform_buffer_0[29u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1943 = sqrt(dot(float3(fragment_uniform_buffer_0[29u].xyz), float3(fragment_uniform_buffer_0[29u].xyz))) + (-5.0f);
				float fragment_unnamed_1959 = clamp(dot(float3((-0.0f) - fragment_unnamed_1116, (-0.0f) - fragment_unnamed_1117, (-0.0f) - fragment_unnamed_1118), float3(fragment_uniform_buffer_0[16u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_1943, 0.0f, 1.0f);
				float fragment_unnamed_1968 = mad((-0.0f) - fragment_unnamed_1116, fragment_unnamed_1943, fragment_uniform_buffer_0[29u].x);
				float fragment_unnamed_1969 = mad((-0.0f) - fragment_unnamed_1117, fragment_unnamed_1943, fragment_uniform_buffer_0[29u].y);
				float fragment_unnamed_1970 = mad((-0.0f) - fragment_unnamed_1118, fragment_unnamed_1943, fragment_uniform_buffer_0[29u].z);
				float fragment_unnamed_1974 = sqrt(dot(float3(fragment_unnamed_1968, fragment_unnamed_1969, fragment_unnamed_1970), float3(fragment_unnamed_1968, fragment_unnamed_1969, fragment_unnamed_1970)));
				float fragment_unnamed_1980 = max((((-0.0f) - fragment_unnamed_1974) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1982 = fragment_unnamed_1974 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_1997 = fragment_unnamed_1959 * ((fragment_unnamed_1980 * fragment_unnamed_1980) * clamp(dot(float3(fragment_unnamed_1968 / fragment_unnamed_1974, fragment_unnamed_1969 / fragment_unnamed_1974, fragment_unnamed_1970 / fragment_unnamed_1974), float3(fragment_unnamed_1485, fragment_unnamed_1486, fragment_unnamed_1487)), 0.0f, 1.0f));
				float fragment_unnamed_2016 = clamp(fragment_unnamed_1168 * mad(fragment_unnamed_818.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_884) + 1.0f, fragment_unnamed_884), 0.0f, 1.0f);
				float fragment_unnamed_2022 = exp2(log2(fragment_unnamed_1867 * max(dot(float3(fragment_unnamed_1910, fragment_unnamed_1911, fragment_unnamed_1912), float3(fragment_uniform_buffer_0[16u].xyz)), 0.0f)) * exp2(fragment_unnamed_2016 * 6.906890392303466796875f));
				uint fragment_unnamed_2039 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118))) ? 4294967295u : 0u;
				float fragment_unnamed_2047 = mad(fragment_unnamed_1116, 1.0f, (-0.0f) - (fragment_unnamed_1117 * 0.0f));
				float fragment_unnamed_2048 = mad(fragment_unnamed_1117, 0.0f, (-0.0f) - (fragment_unnamed_1118 * 1.0f));
				float fragment_unnamed_2053 = rsqrt(dot(float2(fragment_unnamed_2047, fragment_unnamed_2048), float2(fragment_unnamed_2047, fragment_unnamed_2048)));
				bool fragment_unnamed_2057 = (fragment_unnamed_2039 & ((fragment_unnamed_1117 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2062 = asfloat(fragment_unnamed_2057 ? asuint(fragment_unnamed_2053 * fragment_unnamed_2047) : 0u);
				float fragment_unnamed_2064 = asfloat(fragment_unnamed_2057 ? asuint(fragment_unnamed_2053 * fragment_unnamed_2048) : 1065353216u);
				float fragment_unnamed_2066 = asfloat(fragment_unnamed_2057 ? asuint(fragment_unnamed_2053 * mad(fragment_unnamed_1118, 0.0f, (-0.0f) - (fragment_unnamed_1116 * 0.0f))) : 0u);
				float fragment_unnamed_2079 = mad(fragment_unnamed_2066, fragment_unnamed_1118, (-0.0f) - (fragment_unnamed_1117 * fragment_unnamed_2062));
				float fragment_unnamed_2080 = mad(fragment_unnamed_2062, fragment_unnamed_1116, (-0.0f) - (fragment_unnamed_1118 * fragment_unnamed_2064));
				float fragment_unnamed_2081 = mad(fragment_unnamed_2064, fragment_unnamed_1117, (-0.0f) - (fragment_unnamed_1116 * fragment_unnamed_2066));
				float fragment_unnamed_2085 = rsqrt(dot(float3(fragment_unnamed_2079, fragment_unnamed_2080, fragment_unnamed_2081), float3(fragment_unnamed_2079, fragment_unnamed_2080, fragment_unnamed_2081)));
				bool fragment_unnamed_2097 = (fragment_unnamed_2039 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2062, fragment_unnamed_2064), float2(fragment_unnamed_2062, fragment_unnamed_2064))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2114 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1912, fragment_unnamed_1910), float2((-0.0f) - fragment_unnamed_2062, (-0.0f) - fragment_unnamed_2064)), dot(float3(fragment_unnamed_1910, fragment_unnamed_1911, fragment_unnamed_1912), float3(fragment_unnamed_1116, fragment_unnamed_1117, fragment_unnamed_1118)), dot(float3(fragment_unnamed_1910, fragment_unnamed_1911, fragment_unnamed_1912), float3(fragment_unnamed_2097 ? ((-0.0f) - (fragment_unnamed_2085 * fragment_unnamed_2079)) : (-0.0f), fragment_unnamed_2097 ? ((-0.0f) - (fragment_unnamed_2085 * fragment_unnamed_2080)) : (-0.0f), fragment_unnamed_2097 ? ((-0.0f) - (fragment_unnamed_2085 * fragment_unnamed_2081)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_2016) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2133 = mad(fragment_unnamed_1867, ((-0.0f) - fragment_uniform_buffer_0[13u].y) + fragment_uniform_buffer_0[13u].x, fragment_uniform_buffer_0[13u].y);
				float fragment_unnamed_2137 = dot(float3(fragment_unnamed_2133 * (fragment_unnamed_2016 * fragment_unnamed_2114.x), fragment_unnamed_2133 * (fragment_unnamed_2016 * fragment_unnamed_2114.y), fragment_unnamed_2133 * (fragment_unnamed_2016 * fragment_unnamed_2114.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2158 = fragment_unnamed_2137 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 0.7200000286102294921875f, fragment_unnamed_1125), 0.14000000059604644775390625f, fragment_unnamed_1134 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1018), fragment_unnamed_1018), asfloat(fragment_unnamed_1928 & (fragment_unnamed_1982 ? asuint(fragment_unnamed_1959 * 1.2999999523162841796875f) : asuint(fragment_unnamed_1997 * 1.2999999523162841796875f))) + mad(fragment_unnamed_1544 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1508, 1.0f) * fragment_unnamed_1693), fragment_unnamed_1707, fragment_unnamed_1527 * (fragment_unnamed_1895 * (fragment_unnamed_1891 * asfloat(fragment_unnamed_1853 ? asuint(mad(fragment_unnamed_1703, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1745, fragment_unnamed_1728, 0.0240000002086162567138671875f), fragment_unnamed_1728 * fragment_unnamed_1745) + ((-0.0f) - fragment_unnamed_1838), fragment_unnamed_1838)) : asuint(mad(fragment_unnamed_1866, fragment_unnamed_1838 + ((-0.0f) - fragment_unnamed_1850), fragment_unnamed_1850)))))), (fragment_unnamed_2016 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.x, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].x), fragment_uniform_buffer_0[8u].x)) * fragment_unnamed_2022)) * 0.5f);
				float fragment_unnamed_2159 = fragment_unnamed_2137 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 0.85000002384185791015625f, fragment_unnamed_1126), 0.14000000059604644775390625f, fragment_unnamed_1134 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1019), fragment_unnamed_1019), asfloat(fragment_unnamed_1928 & (fragment_unnamed_1982 ? asuint(fragment_unnamed_1959 * 1.10000002384185791015625f) : asuint(fragment_unnamed_1997 * 1.10000002384185791015625f))) + mad(fragment_unnamed_1544 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1509, 1.0f) * fragment_unnamed_1694), fragment_unnamed_1707, fragment_unnamed_1527 * (fragment_unnamed_1895 * (fragment_unnamed_1891 * asfloat(fragment_unnamed_1853 ? asuint(mad(fragment_unnamed_1703, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1748, fragment_unnamed_1728, 0.0240000002086162567138671875f), fragment_unnamed_1728 * fragment_unnamed_1748) + ((-0.0f) - fragment_unnamed_1839), fragment_unnamed_1839)) : asuint(mad(fragment_unnamed_1866, fragment_unnamed_1839 + ((-0.0f) - fragment_unnamed_1851), fragment_unnamed_1851)))))), (fragment_unnamed_2016 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.y, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].y), fragment_uniform_buffer_0[8u].y)) * fragment_unnamed_2022)) * 0.5f);
				float fragment_unnamed_2160 = fragment_unnamed_2137 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1140, 1.0f, fragment_unnamed_1127), 0.14000000059604644775390625f, fragment_unnamed_1134 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1020), fragment_unnamed_1020), asfloat(fragment_unnamed_1928 & (fragment_unnamed_1982 ? asuint(fragment_unnamed_1959 * 0.60000002384185791015625f) : asuint(fragment_unnamed_1997 * 0.60000002384185791015625f))) + mad(fragment_unnamed_1544 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1510, 1.0f) * fragment_unnamed_1695), fragment_unnamed_1707, fragment_unnamed_1527 * (fragment_unnamed_1895 * (fragment_unnamed_1891 * asfloat(fragment_unnamed_1853 ? asuint(mad(fragment_unnamed_1703, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1749, fragment_unnamed_1728, 0.0240000002086162567138671875f), fragment_unnamed_1728 * fragment_unnamed_1749) + ((-0.0f) - fragment_unnamed_1840), fragment_unnamed_1840)) : asuint(mad(fragment_unnamed_1866, fragment_unnamed_1840 + ((-0.0f) - fragment_unnamed_1852), fragment_unnamed_1852)))))), (fragment_unnamed_2016 * ((fragment_unnamed_1168 * mad(fragment_unnamed_826, mad(fragment_unnamed_818.z, fragment_unnamed_828, (-0.0f) - fragment_uniform_buffer_0[8u].z), fragment_uniform_buffer_0[8u].z)) * fragment_unnamed_2022)) * 0.5f);
				fragment_output_0.x = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1011) + fragment_unnamed_2158, fragment_unnamed_1011);
				fragment_output_0.y = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1012) + fragment_unnamed_2159, fragment_unnamed_1012);
				fragment_output_0.z = mad(fragment_unnamed_989, ((-0.0f) - fragment_unnamed_1013) + fragment_unnamed_2160, fragment_unnamed_1013);
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				fragment_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				fragment_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				fragment_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				fragment_uniform_buffer_0[8] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[9] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[10] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[11] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[12] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[13] = float4(_GIStrengthDay, fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], _GIStrengthNight, fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], _Multiplier);

				fragment_uniform_buffer_0[14] = float4(_AmbientInc, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], _MaterialIndex, fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], fragment_uniform_buffer_0[15][1], _Distance, fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[16][3]);

				fragment_uniform_buffer_0[17] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[18] = float4(_LatitudeCount, fragment_uniform_buffer_0[18][1], fragment_uniform_buffer_0[18][2], fragment_uniform_buffer_0[18][3]);

				fragment_uniform_buffer_0[19] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[19][1], fragment_uniform_buffer_0[19][2], fragment_uniform_buffer_0[19][3]);

				fragment_uniform_buffer_0[20] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[21] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[22] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[29] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // POINT_COOKIE
			#endif // !DIRECTIONAL
			#endif // !DIRECTIONAL_COOKIE
			#endif // !POINT
			#endif // !SPOT


			#ifdef DIRECTIONAL_COOKIE
			#ifndef DIRECTIONAL
			#ifndef POINT
			#ifndef POINT_COOKIE
			#ifndef SPOT
			#define ANY_SHADER_VARIANT_ACTIVE

			//float4x4 unity_WorldToLight;
			float4 _SpeclColor;
			float4 _LightColorScreen;
			float4 _AmbientColor0;
			float4 _AmbientColor1;
			float4 _AmbientColor2;
			float _GIStrengthDay;
			float _GIStrengthNight;
			float _Multiplier;
			float _AmbientInc;
			float _MaterialIndex;
			float _Distance;
			float3 _SunDir;
			float4 _Rotation;
			float _LatitudeCount;
			//float _Global_WhiteMode0;
			float4 _Global_SunsetColor0;
			float4 _Global_SunsetColor1;
			float4 _Global_SunsetColor2;
			float4 _Global_PointLightPos;
			float3 _WorldSpaceCameraPos;
			float4 unity_OcclusionMaskSelector;
			float4 unity_ProbeVolumeParams;
			float4x4 unity_ProbeVolumeWorldToObject;
			float3 unity_ProbeVolumeSizeInv;
			float3 unity_ProbeVolumeMin;

			static float4 fragment_uniform_buffer_0[30];
			static float4 fragment_uniform_buffer_1[5];
			static float4 fragment_uniform_buffer_2[47];
			static float4 fragment_uniform_buffer_3[7];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;
			Texture2D<float4> _AlbedoTex1;
			SamplerState sampler_AlbedoTex1;
			Texture2D<float4> _NormalTex1;
			SamplerState sampler_NormalTex1;
			Texture2D<float4> _AlbedoTex2;
			SamplerState sampler_AlbedoTex2;
			Texture2D<float4> _NormalTex2;
			SamplerState sampler_NormalTex2;
			Texture2D<float4> _AlbedoTex3;
			SamplerState sampler_AlbedoTex3;
			Texture2D<float4> _NormalTex3;
			SamplerState sampler_NormalTex3;
			Texture2D<float4> _ColorsTexture;
			SamplerState sampler_ColorsTexture;
			Texture2D<float4> _ReformGrab;
			SamplerState sampler_ReformGrab;
			Texture3D<float4> _LightTexture0;
			SamplerState sampler_LightTexture0;
			Texture2D<float4> _Global_PGI;
			SamplerState sampler_Global_PGI;
			TextureCube<float4> unity_ProbeVolumeSH;
			SamplerState samplerunity_ProbeVolumeSH;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float3 fragment_input_6;
			static float3 fragment_input_7;
			static float3 fragment_input_8;
			static float3 fragment_input_9;
			static float4 fragment_input_10;
			static float3 fragment_input_11;
			static float2 fragment_input_12;
			static float4 fragment_input_13;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD; // TEXCOORD
				float3 fragment_input_2 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_3 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_4 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_5 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_6 : TEXCOORD5; // TEXCOORD_5
				float3 fragment_input_7 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_8 : TEXCOORD7; // TEXCOORD_7
				float3 fragment_input_9 : TEXCOORD8; // TEXCOORD_8
				float4 fragment_input_10 : TEXCOORD9; // TEXCOORD_9
				float3 fragment_input_11 : TEXCOORD10; // TEXCOORD_10
				float2 fragment_input_12 : TEXCOORD11; // TEXCOORD_11
				float4 fragment_input_13 : TEXCOORD12; // TEXCOORD_12
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_2170)
			{
				if (fragment_unnamed_2170)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_127 = rsqrt(dot(float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z), float3(fragment_input_5.x, fragment_input_5.y, fragment_input_5.z)));
				float fragment_unnamed_134 = fragment_unnamed_127 * fragment_input_5.y;
				float fragment_unnamed_135 = fragment_unnamed_127 * fragment_input_5.x;
				float fragment_unnamed_136 = fragment_unnamed_127 * fragment_input_5.z;
				uint fragment_unnamed_145 = uint(mad(fragment_uniform_buffer_0[18u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_151 = sqrt(((-0.0f) - abs(fragment_unnamed_134)) + 1.0f);
				float fragment_unnamed_160 = mad(mad(mad(abs(fragment_unnamed_134), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_134), -0.212114393711090087890625f), abs(fragment_unnamed_134), 1.570728778839111328125f);
				float fragment_unnamed_185 = (1.0f / max(abs(fragment_unnamed_136), abs(fragment_unnamed_135))) * min(abs(fragment_unnamed_136), abs(fragment_unnamed_135));
				float fragment_unnamed_186 = fragment_unnamed_185 * fragment_unnamed_185;
				float fragment_unnamed_194 = mad(fragment_unnamed_186, mad(fragment_unnamed_186, mad(fragment_unnamed_186, mad(fragment_unnamed_186, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_212 = asfloat(((((-0.0f) - fragment_unnamed_136) < fragment_unnamed_136) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_185, fragment_unnamed_194, asfloat(((abs(fragment_unnamed_136) < abs(fragment_unnamed_135)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_194 * fragment_unnamed_185, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_214 = min((-0.0f) - fragment_unnamed_136, fragment_unnamed_135);
				float fragment_unnamed_216 = max((-0.0f) - fragment_unnamed_136, fragment_unnamed_135);
				float fragment_unnamed_230 = (((-0.0f) - mad(fragment_unnamed_160, fragment_unnamed_151, asfloat(((fragment_unnamed_134 < ((-0.0f) - fragment_unnamed_134)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_151 * fragment_unnamed_160, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[18u].x;
				float fragment_unnamed_231 = fragment_unnamed_230 * 0.3183098733425140380859375f;
				bool fragment_unnamed_233 = 0.0f < fragment_unnamed_230;
				float fragment_unnamed_240 = asfloat(fragment_unnamed_233 ? asuint(ceil(fragment_unnamed_231)) : asuint(floor(fragment_unnamed_231)));
				float fragment_unnamed_244 = float(fragment_unnamed_145);
				uint fragment_unnamed_252 = uint(asfloat((0.0f < fragment_unnamed_240) ? asuint(fragment_unnamed_240 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_240) + fragment_unnamed_244) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_254 = _OffsetsBuffer.Load(fragment_unnamed_252);
				uint fragment_unnamed_255 = fragment_unnamed_254.x;
				float fragment_unnamed_262 = float((-fragment_unnamed_255) + _OffsetsBuffer.Load(fragment_unnamed_252 + 1u).x);
				float fragment_unnamed_263 = mad(((((fragment_unnamed_216 >= ((-0.0f) - fragment_unnamed_216)) ? 4294967295u : 0u) & ((fragment_unnamed_214 < ((-0.0f) - fragment_unnamed_214)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_212) : fragment_unnamed_212, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_265 = fragment_unnamed_262 * fragment_unnamed_263;
				bool fragment_unnamed_266 = 0.0f < fragment_unnamed_265;
				float fragment_unnamed_272 = asfloat(fragment_unnamed_266 ? asuint(ceil(fragment_unnamed_265)) : asuint(floor(fragment_unnamed_265)));
				float fragment_unnamed_273 = mad(fragment_unnamed_262, 0.5f, 0.5f);
				float fragment_unnamed_289 = float(fragment_unnamed_255 + uint(asfloat((fragment_unnamed_273 < fragment_unnamed_272) ? asuint(mad((-0.0f) - fragment_unnamed_262, 0.5f, fragment_unnamed_272) + (-1.0f)) : asuint(fragment_unnamed_262 + ((-0.0f) - fragment_unnamed_272))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_292 = frac(fragment_unnamed_289);
				uint4 fragment_unnamed_294 = _DataBuffer.Load(uint(floor(fragment_unnamed_289)));
				uint fragment_unnamed_295 = fragment_unnamed_294.x;
				uint fragment_unnamed_307 = 16u & 31u;
				uint fragment_unnamed_314 = 8u & 31u;
				uint fragment_unnamed_322 = (0.625f < fragment_unnamed_292) ? (fragment_unnamed_295 >> 24u) : ((0.375f < fragment_unnamed_292) ? spvBitfieldUExtract(fragment_unnamed_295, fragment_unnamed_307, min((8u & 31u), (32u - fragment_unnamed_307))) : ((0.125f < fragment_unnamed_292) ? spvBitfieldUExtract(fragment_unnamed_295, fragment_unnamed_314, min((8u & 31u), (32u - fragment_unnamed_314))) : (fragment_unnamed_295 & 255u)));
				float fragment_unnamed_324 = float(fragment_unnamed_322 >> 5u);
				float fragment_unnamed_329 = asfloat((6.5f < fragment_unnamed_324) ? 0u : asuint(fragment_unnamed_324));
				float fragment_unnamed_336 = round(fragment_uniform_buffer_0[15u].y * 3.0f);
				discard_cond(fragment_unnamed_329 < (fragment_unnamed_336 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_336 + 3.9900000095367431640625f) < fragment_unnamed_329);
				float fragment_unnamed_355 = mad(fragment_unnamed_230, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_356 = mad(fragment_unnamed_230, 0.3183098733425140380859375f, -0.5f);
				float fragment_unnamed_367 = asfloat(fragment_unnamed_233 ? asuint(ceil(fragment_unnamed_355)) : asuint(floor(fragment_unnamed_355)));
				float fragment_unnamed_369 = asfloat(fragment_unnamed_233 ? asuint(ceil(fragment_unnamed_356)) : asuint(floor(fragment_unnamed_356)));
				uint fragment_unnamed_371 = uint(ceil(max(abs(fragment_unnamed_231) + (-0.5f), 0.0f)) + (-0.89999997615814208984375f));
				uint fragment_unnamed_390 = uint(asfloat((0.0f < fragment_unnamed_367) ? asuint(fragment_unnamed_367 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_244 + ((-0.0f) - fragment_unnamed_367)) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_391 = uint(asfloat((0.0f < fragment_unnamed_369) ? asuint(fragment_unnamed_369 + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_244 + ((-0.0f) - fragment_unnamed_369)) + (-0.89999997615814208984375f))));
				uint4 fragment_unnamed_392 = _OffsetsBuffer.Load(fragment_unnamed_390);
				uint fragment_unnamed_393 = fragment_unnamed_392.x;
				uint4 fragment_unnamed_394 = _OffsetsBuffer.Load(fragment_unnamed_391);
				uint fragment_unnamed_395 = fragment_unnamed_394.x;
				uint fragment_unnamed_406 = (fragment_unnamed_252 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_409 = (fragment_unnamed_252 != (fragment_unnamed_145 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_412 = (fragment_unnamed_145 != fragment_unnamed_252) ? 4294967295u : 0u;
				uint fragment_unnamed_416 = (fragment_unnamed_252 != (uint(fragment_uniform_buffer_0[18u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_432 = (fragment_unnamed_416 & (fragment_unnamed_412 & (fragment_unnamed_406 & fragment_unnamed_409))) != 0u;
				uint fragment_unnamed_435 = asuint(fragment_unnamed_262);
				float fragment_unnamed_437 = asfloat(fragment_unnamed_432 ? asuint(float((-fragment_unnamed_393) + _OffsetsBuffer.Load(fragment_unnamed_390 + 1u).x)) : fragment_unnamed_435);
				float fragment_unnamed_439 = asfloat(fragment_unnamed_432 ? asuint(float((-fragment_unnamed_395) + _OffsetsBuffer.Load(fragment_unnamed_391 + 1u).x)) : fragment_unnamed_435);
				float fragment_unnamed_441 = fragment_unnamed_263 * fragment_unnamed_437;
				float fragment_unnamed_442 = fragment_unnamed_263 * fragment_unnamed_439;
				float fragment_unnamed_443 = mad(fragment_unnamed_263, fragment_unnamed_262, 0.5f);
				float fragment_unnamed_444 = mad(fragment_unnamed_263, fragment_unnamed_262, -0.5f);
				float fragment_unnamed_451 = asfloat((fragment_unnamed_262 < fragment_unnamed_443) ? asuint(((-0.0f) - fragment_unnamed_262) + fragment_unnamed_443) : asuint(fragment_unnamed_443));
				float fragment_unnamed_457 = asfloat((fragment_unnamed_444 < 0.0f) ? asuint(fragment_unnamed_262 + fragment_unnamed_444) : asuint(fragment_unnamed_444));
				float fragment_unnamed_467 = asfloat(fragment_unnamed_266 ? asuint(ceil(fragment_unnamed_441)) : asuint(floor(fragment_unnamed_441)));
				float fragment_unnamed_469 = asfloat(fragment_unnamed_266 ? asuint(ceil(fragment_unnamed_442)) : asuint(floor(fragment_unnamed_442)));
				float fragment_unnamed_475 = asfloat(fragment_unnamed_266 ? asuint(ceil(fragment_unnamed_451)) : asuint(floor(fragment_unnamed_451)));
				float fragment_unnamed_481 = asfloat(fragment_unnamed_266 ? asuint(ceil(fragment_unnamed_457)) : asuint(floor(fragment_unnamed_457)));
				float fragment_unnamed_482 = frac(fragment_unnamed_231);
				float fragment_unnamed_483 = frac(fragment_unnamed_265);
				float fragment_unnamed_484 = fragment_unnamed_482 + (-0.5f);
				float fragment_unnamed_493 = min((((-0.0f) - fragment_unnamed_483) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_495 = min(fragment_unnamed_483 * 40.0f, 1.0f);
				float fragment_unnamed_496 = min(fragment_unnamed_482 * 40.0f, 1.0f);
				float fragment_unnamed_552 = float(fragment_unnamed_393 + uint(asfloat((mad(fragment_unnamed_437, 0.5f, 0.5f) < fragment_unnamed_467) ? asuint(mad((-0.0f) - fragment_unnamed_437, 0.5f, fragment_unnamed_467) + (-1.0f)) : asuint(fragment_unnamed_437 + ((-0.0f) - fragment_unnamed_467))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_554 = frac(fragment_unnamed_552);
				uint4 fragment_unnamed_556 = _DataBuffer.Load(uint(floor(fragment_unnamed_552)));
				uint fragment_unnamed_557 = fragment_unnamed_556.x;
				uint fragment_unnamed_563 = 16u & 31u;
				uint fragment_unnamed_568 = 8u & 31u;
				float fragment_unnamed_578 = float(uint(asfloat((mad(fragment_unnamed_439, 0.5f, 0.5f) < fragment_unnamed_469) ? asuint(mad((-0.0f) - fragment_unnamed_439, 0.5f, fragment_unnamed_469) + (-1.0f)) : asuint(fragment_unnamed_439 + ((-0.0f) - fragment_unnamed_469))) + 0.100000001490116119384765625f) + fragment_unnamed_395) * 0.25f;
				float fragment_unnamed_580 = frac(fragment_unnamed_578);
				uint4 fragment_unnamed_582 = _DataBuffer.Load(uint(floor(fragment_unnamed_578)));
				uint fragment_unnamed_583 = fragment_unnamed_582.x;
				uint fragment_unnamed_589 = 16u & 31u;
				uint fragment_unnamed_594 = 8u & 31u;
				float fragment_unnamed_604 = float(uint(asfloat((fragment_unnamed_273 < fragment_unnamed_475) ? asuint(mad((-0.0f) - fragment_unnamed_262, 0.5f, fragment_unnamed_475) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_475) + fragment_unnamed_262)) + 0.100000001490116119384765625f) + fragment_unnamed_255) * 0.25f;
				float fragment_unnamed_606 = frac(fragment_unnamed_604);
				uint4 fragment_unnamed_608 = _DataBuffer.Load(uint(floor(fragment_unnamed_604)));
				uint fragment_unnamed_609 = fragment_unnamed_608.x;
				uint fragment_unnamed_615 = 16u & 31u;
				uint fragment_unnamed_620 = 8u & 31u;
				float fragment_unnamed_630 = float(uint(asfloat((fragment_unnamed_273 < fragment_unnamed_481) ? asuint(mad((-0.0f) - fragment_unnamed_262, 0.5f, fragment_unnamed_481) + (-1.0f)) : asuint(fragment_unnamed_262 + ((-0.0f) - fragment_unnamed_481))) + 0.100000001490116119384765625f) + fragment_unnamed_255) * 0.25f;
				float fragment_unnamed_632 = frac(fragment_unnamed_630);
				uint4 fragment_unnamed_634 = _DataBuffer.Load(uint(floor(fragment_unnamed_630)));
				uint fragment_unnamed_635 = fragment_unnamed_634.x;
				uint fragment_unnamed_641 = 16u & 31u;
				uint fragment_unnamed_646 = 8u & 31u;
				float fragment_unnamed_656 = float(((0.625f < fragment_unnamed_580) ? (fragment_unnamed_583 >> 24u) : ((0.375f < fragment_unnamed_580) ? spvBitfieldUExtract(fragment_unnamed_583, fragment_unnamed_589, min((8u & 31u), (32u - fragment_unnamed_589))) : ((0.125f < fragment_unnamed_580) ? spvBitfieldUExtract(fragment_unnamed_583, fragment_unnamed_594, min((8u & 31u), (32u - fragment_unnamed_594))) : (fragment_unnamed_583 & 255u)))) >> 5u);
				float fragment_unnamed_658 = float(((0.625f < fragment_unnamed_606) ? (fragment_unnamed_609 >> 24u) : ((0.375f < fragment_unnamed_606) ? spvBitfieldUExtract(fragment_unnamed_609, fragment_unnamed_615, min((8u & 31u), (32u - fragment_unnamed_615))) : ((0.125f < fragment_unnamed_606) ? spvBitfieldUExtract(fragment_unnamed_609, fragment_unnamed_620, min((8u & 31u), (32u - fragment_unnamed_620))) : (fragment_unnamed_609 & 255u)))) >> 5u);
				float fragment_unnamed_660 = float(((0.625f < fragment_unnamed_632) ? (fragment_unnamed_635 >> 24u) : ((0.375f < fragment_unnamed_632) ? spvBitfieldUExtract(fragment_unnamed_635, fragment_unnamed_641, min((8u & 31u), (32u - fragment_unnamed_641))) : ((0.125f < fragment_unnamed_632) ? spvBitfieldUExtract(fragment_unnamed_635, fragment_unnamed_646, min((8u & 31u), (32u - fragment_unnamed_646))) : (fragment_unnamed_635 & 255u)))) >> 5u);
				float fragment_unnamed_661 = float(((0.625f < fragment_unnamed_554) ? (fragment_unnamed_557 >> 24u) : ((0.375f < fragment_unnamed_554) ? spvBitfieldUExtract(fragment_unnamed_557, fragment_unnamed_563, min((8u & 31u), (32u - fragment_unnamed_563))) : ((0.125f < fragment_unnamed_554) ? spvBitfieldUExtract(fragment_unnamed_557, fragment_unnamed_568, min((8u & 31u), (32u - fragment_unnamed_568))) : (fragment_unnamed_557 & 255u)))) >> 5u);
				float fragment_unnamed_672 = fragment_unnamed_265 * 0.20000000298023223876953125f;
				float fragment_unnamed_674 = fragment_unnamed_230 * 0.06366197764873504638671875f;
				float fragment_unnamed_676 = (fragment_unnamed_263 * float((-_OffsetsBuffer.Load(fragment_unnamed_371).x) + _OffsetsBuffer.Load(fragment_unnamed_371 + 1u).x)) * 0.20000000298023223876953125f;
				float fragment_unnamed_683 = ddx_coarse(fragment_input_11.x);
				float fragment_unnamed_684 = ddx_coarse(fragment_input_11.y);
				float fragment_unnamed_685 = ddx_coarse(fragment_input_11.z);
				float fragment_unnamed_689 = sqrt(dot(float3(fragment_unnamed_683, fragment_unnamed_684, fragment_unnamed_685), float3(fragment_unnamed_683, fragment_unnamed_684, fragment_unnamed_685)));
				float fragment_unnamed_696 = ddy_coarse(fragment_input_11.x);
				float fragment_unnamed_697 = ddy_coarse(fragment_input_11.y);
				float fragment_unnamed_698 = ddy_coarse(fragment_input_11.z);
				float fragment_unnamed_702 = sqrt(dot(float3(fragment_unnamed_696, fragment_unnamed_697, fragment_unnamed_698), float3(fragment_unnamed_696, fragment_unnamed_697, fragment_unnamed_698)));
				float fragment_unnamed_712 = min(max(log2(sqrt(dot(float2(fragment_unnamed_689, fragment_unnamed_702), float2(fragment_unnamed_689, fragment_unnamed_702))) * 499.999969482421875f) + (-1.0f), 0.0f), 7.0f);
				float fragment_unnamed_714 = min((((-0.0f) - fragment_unnamed_482) + 1.0f) * 40.0f, 1.0f);
				float fragment_unnamed_781;
				float fragment_unnamed_783;
				float fragment_unnamed_785;
				float fragment_unnamed_787;
				float fragment_unnamed_789;
				float fragment_unnamed_791;
				float fragment_unnamed_793;
				float fragment_unnamed_795;
				float fragment_unnamed_797;
				float fragment_unnamed_799;
				float fragment_unnamed_801;
				float fragment_unnamed_803;
				float fragment_unnamed_805;
				float fragment_unnamed_807;
				if (((((fragment_unnamed_336 + 0.9900000095367431640625f) < fragment_unnamed_329) ? 4294967295u : 0u) & ((fragment_unnamed_329 < (fragment_unnamed_336 + 1.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
				{
					float4 fragment_unnamed_727 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
					float4 fragment_unnamed_733 = _AlbedoTex1.SampleLevel(sampler_AlbedoTex1, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
					float4 fragment_unnamed_740 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
					float fragment_unnamed_746 = mad(fragment_unnamed_740.w * fragment_unnamed_740.x, 2.0f, -1.0f);
					float fragment_unnamed_748 = mad(fragment_unnamed_740.y, 2.0f, -1.0f);
					float4 fragment_unnamed_756 = _NormalTex1.SampleLevel(sampler_NormalTex1, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
					float fragment_unnamed_762 = mad(fragment_unnamed_756.w * fragment_unnamed_756.x, 2.0f, -1.0f);
					float fragment_unnamed_763 = mad(fragment_unnamed_756.y, 2.0f, -1.0f);
					fragment_unnamed_781 = fragment_unnamed_727.x;
					fragment_unnamed_783 = fragment_unnamed_727.y;
					fragment_unnamed_785 = fragment_unnamed_727.z;
					fragment_unnamed_787 = fragment_unnamed_733.x;
					fragment_unnamed_789 = fragment_unnamed_733.y;
					fragment_unnamed_791 = fragment_unnamed_733.z;
					fragment_unnamed_793 = fragment_unnamed_727.w;
					fragment_unnamed_795 = fragment_unnamed_733.w;
					fragment_unnamed_797 = fragment_unnamed_746;
					fragment_unnamed_799 = fragment_unnamed_748;
					fragment_unnamed_801 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_746, fragment_unnamed_748), float2(fragment_unnamed_746, fragment_unnamed_748)), 1.0f)) + 1.0f);
					fragment_unnamed_803 = fragment_unnamed_762;
					fragment_unnamed_805 = fragment_unnamed_763;
					fragment_unnamed_807 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_762, fragment_unnamed_763), float2(fragment_unnamed_762, fragment_unnamed_763)), 1.0f)) + 1.0f);
				}
				else
				{
					float fragment_unnamed_782;
					float fragment_unnamed_784;
					float fragment_unnamed_786;
					float fragment_unnamed_788;
					float fragment_unnamed_790;
					float fragment_unnamed_792;
					float fragment_unnamed_794;
					float fragment_unnamed_796;
					float fragment_unnamed_798;
					float fragment_unnamed_800;
					float fragment_unnamed_802;
					float fragment_unnamed_804;
					float fragment_unnamed_806;
					float fragment_unnamed_808;
					if (((((fragment_unnamed_336 + 1.9900000095367431640625f) < fragment_unnamed_329) ? 4294967295u : 0u) & ((fragment_unnamed_329 < (fragment_unnamed_336 + 2.0099999904632568359375f)) ? 4294967295u : 0u)) != 0u)
					{
						float4 fragment_unnamed_1238 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
						float4 fragment_unnamed_1244 = _AlbedoTex2.SampleLevel(sampler_AlbedoTex2, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
						float4 fragment_unnamed_1251 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
						float fragment_unnamed_1257 = mad(fragment_unnamed_1251.w * fragment_unnamed_1251.x, 2.0f, -1.0f);
						float fragment_unnamed_1258 = mad(fragment_unnamed_1251.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1266 = _NormalTex2.SampleLevel(sampler_NormalTex2, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
						float fragment_unnamed_1272 = mad(fragment_unnamed_1266.w * fragment_unnamed_1266.x, 2.0f, -1.0f);
						float fragment_unnamed_1273 = mad(fragment_unnamed_1266.y, 2.0f, -1.0f);
						fragment_unnamed_782 = fragment_unnamed_1238.x;
						fragment_unnamed_784 = fragment_unnamed_1238.y;
						fragment_unnamed_786 = fragment_unnamed_1238.z;
						fragment_unnamed_788 = fragment_unnamed_1244.x;
						fragment_unnamed_790 = fragment_unnamed_1244.y;
						fragment_unnamed_792 = fragment_unnamed_1244.z;
						fragment_unnamed_794 = fragment_unnamed_1238.w;
						fragment_unnamed_796 = fragment_unnamed_1244.w;
						fragment_unnamed_798 = fragment_unnamed_1257;
						fragment_unnamed_800 = fragment_unnamed_1258;
						fragment_unnamed_802 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1257, fragment_unnamed_1258), float2(fragment_unnamed_1257, fragment_unnamed_1258)), 1.0f)) + 1.0f);
						fragment_unnamed_804 = fragment_unnamed_1272;
						fragment_unnamed_806 = fragment_unnamed_1273;
						fragment_unnamed_808 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1272, fragment_unnamed_1273), float2(fragment_unnamed_1272, fragment_unnamed_1273)), 1.0f)) + 1.0f);
					}
					else
					{
						float4 fragment_unnamed_1282 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
						float4 fragment_unnamed_1288 = _AlbedoTex3.SampleLevel(sampler_AlbedoTex3, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
						float4 fragment_unnamed_1295 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_674, fragment_unnamed_672), fragment_unnamed_712);
						float fragment_unnamed_1301 = mad(fragment_unnamed_1295.w * fragment_unnamed_1295.x, 2.0f, -1.0f);
						float fragment_unnamed_1302 = mad(fragment_unnamed_1295.y, 2.0f, -1.0f);
						float4 fragment_unnamed_1310 = _NormalTex3.SampleLevel(sampler_NormalTex3, float2(fragment_unnamed_674, fragment_unnamed_676), fragment_unnamed_712);
						float fragment_unnamed_1316 = mad(fragment_unnamed_1310.w * fragment_unnamed_1310.x, 2.0f, -1.0f);
						float fragment_unnamed_1317 = mad(fragment_unnamed_1310.y, 2.0f, -1.0f);
						fragment_unnamed_782 = fragment_unnamed_1282.x;
						fragment_unnamed_784 = fragment_unnamed_1282.y;
						fragment_unnamed_786 = fragment_unnamed_1282.z;
						fragment_unnamed_788 = fragment_unnamed_1288.x;
						fragment_unnamed_790 = fragment_unnamed_1288.y;
						fragment_unnamed_792 = fragment_unnamed_1288.z;
						fragment_unnamed_794 = fragment_unnamed_1282.w;
						fragment_unnamed_796 = fragment_unnamed_1288.w;
						fragment_unnamed_798 = fragment_unnamed_1301;
						fragment_unnamed_800 = fragment_unnamed_1302;
						fragment_unnamed_802 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1301, fragment_unnamed_1302), float2(fragment_unnamed_1301, fragment_unnamed_1302)), 1.0f)) + 1.0f);
						fragment_unnamed_804 = fragment_unnamed_1316;
						fragment_unnamed_806 = fragment_unnamed_1317;
						fragment_unnamed_808 = sqrt(((-0.0f) - min(dot(float2(fragment_unnamed_1316, fragment_unnamed_1317), float2(fragment_unnamed_1316, fragment_unnamed_1317)), 1.0f)) + 1.0f);
					}
					fragment_unnamed_781 = fragment_unnamed_782;
					fragment_unnamed_783 = fragment_unnamed_784;
					fragment_unnamed_785 = fragment_unnamed_786;
					fragment_unnamed_787 = fragment_unnamed_788;
					fragment_unnamed_789 = fragment_unnamed_790;
					fragment_unnamed_791 = fragment_unnamed_792;
					fragment_unnamed_793 = fragment_unnamed_794;
					fragment_unnamed_795 = fragment_unnamed_796;
					fragment_unnamed_797 = fragment_unnamed_798;
					fragment_unnamed_799 = fragment_unnamed_800;
					fragment_unnamed_801 = fragment_unnamed_802;
					fragment_unnamed_803 = fragment_unnamed_804;
					fragment_unnamed_805 = fragment_unnamed_806;
					fragment_unnamed_807 = fragment_unnamed_808;
				}
				float4 fragment_unnamed_815 = _ColorsTexture.Sample(sampler_ColorsTexture, float2((float(fragment_unnamed_322 & 31u) + 0.5f) * 0.03125f, asfloat(1056964608u)));
				float fragment_unnamed_823 = fragment_unnamed_815.w * 0.800000011920928955078125f;
				float fragment_unnamed_825 = mad(fragment_unnamed_815.w, -0.560000002384185791015625f, 1.0f);
				float fragment_unnamed_833 = exp2(log2(abs(fragment_unnamed_484) + abs(fragment_unnamed_484)) * 10.0f);
				float fragment_unnamed_852 = mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_799) + fragment_unnamed_805, fragment_unnamed_799);
				float fragment_unnamed_853 = mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_797) + fragment_unnamed_803, fragment_unnamed_797);
				float fragment_unnamed_854 = mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_801) + fragment_unnamed_807, fragment_unnamed_801);
				float fragment_unnamed_855 = (fragment_unnamed_825 * fragment_unnamed_815.x) * mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_781) + fragment_unnamed_787, fragment_unnamed_781);
				float fragment_unnamed_856 = (fragment_unnamed_825 * fragment_unnamed_815.y) * mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_783) + fragment_unnamed_789, fragment_unnamed_783);
				float fragment_unnamed_857 = (fragment_unnamed_825 * fragment_unnamed_815.z) * mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_785) + fragment_unnamed_791, fragment_unnamed_785);
				float fragment_unnamed_864 = mad(fragment_unnamed_815.w, mad(fragment_unnamed_815.x, fragment_unnamed_825, (-0.0f) - fragment_unnamed_855), fragment_unnamed_855);
				float fragment_unnamed_865 = mad(fragment_unnamed_815.w, mad(fragment_unnamed_815.y, fragment_unnamed_825, (-0.0f) - fragment_unnamed_856), fragment_unnamed_856);
				float fragment_unnamed_866 = mad(fragment_unnamed_815.w, mad(fragment_unnamed_815.z, fragment_unnamed_825, (-0.0f) - fragment_unnamed_857), fragment_unnamed_857);
				float fragment_unnamed_868 = ((-0.0f) - mad(fragment_unnamed_833, ((-0.0f) - fragment_unnamed_793) + fragment_unnamed_795, fragment_unnamed_793)) + 1.0f;
				float fragment_unnamed_872 = fragment_unnamed_868 * fragment_uniform_buffer_0[8u].w;
				float fragment_unnamed_881 = mad(fragment_unnamed_815.w, mad((-0.0f) - fragment_unnamed_868, fragment_uniform_buffer_0[8u].w, clamp(fragment_unnamed_872 * 5.0f, 0.0f, 1.0f)), fragment_unnamed_872);
				bool fragment_unnamed_915 = (fragment_unnamed_409 & (fragment_unnamed_412 & (((fragment_unnamed_661 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_661) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_923 = fragment_unnamed_915 ? asuint(fragment_unnamed_714 * fragment_unnamed_864) : asuint(fragment_unnamed_864);
				uint fragment_unnamed_925 = fragment_unnamed_915 ? asuint(fragment_unnamed_714 * fragment_unnamed_865) : asuint(fragment_unnamed_865);
				uint fragment_unnamed_927 = fragment_unnamed_915 ? asuint(fragment_unnamed_714 * fragment_unnamed_866) : asuint(fragment_unnamed_866);
				uint fragment_unnamed_929 = fragment_unnamed_915 ? asuint(fragment_unnamed_714 * asfloat(1065353216u)) : 1065353216u;
				bool fragment_unnamed_940 = (fragment_unnamed_416 & (fragment_unnamed_406 & (((fragment_unnamed_656 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_656) ? 4294967295u : 0u)))) != 0u;
				uint fragment_unnamed_945 = fragment_unnamed_940 ? asuint(fragment_unnamed_496 * asfloat(fragment_unnamed_923)) : fragment_unnamed_923;
				uint fragment_unnamed_947 = fragment_unnamed_940 ? asuint(fragment_unnamed_496 * asfloat(fragment_unnamed_925)) : fragment_unnamed_925;
				uint fragment_unnamed_949 = fragment_unnamed_940 ? asuint(fragment_unnamed_496 * asfloat(fragment_unnamed_927)) : fragment_unnamed_927;
				uint fragment_unnamed_951 = fragment_unnamed_940 ? asuint(fragment_unnamed_496 * asfloat(fragment_unnamed_929)) : fragment_unnamed_929;
				bool fragment_unnamed_960 = (((fragment_unnamed_658 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_658) ? 4294967295u : 0u)) != 0u;
				uint fragment_unnamed_965 = fragment_unnamed_960 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_945)) : fragment_unnamed_945;
				uint fragment_unnamed_967 = fragment_unnamed_960 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_947)) : fragment_unnamed_947;
				uint fragment_unnamed_969 = fragment_unnamed_960 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_949)) : fragment_unnamed_949;
				uint fragment_unnamed_971 = fragment_unnamed_960 ? asuint(fragment_unnamed_493 * asfloat(fragment_unnamed_951)) : fragment_unnamed_951;
				bool fragment_unnamed_980 = (((fragment_unnamed_660 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_660) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_986 = asfloat(fragment_unnamed_980 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_971)) : fragment_unnamed_971);
				discard_cond((fragment_unnamed_986 + (-0.00999999977648258209228515625f)) < 0.0f);
				float4 fragment_unnamed_1006 = _ReformGrab.Sample(sampler_ReformGrab, float2(fragment_input_10.x / fragment_input_10.w, fragment_input_10.y / fragment_input_10.w));
				float fragment_unnamed_1008 = fragment_unnamed_1006.x;
				float fragment_unnamed_1009 = fragment_unnamed_1006.y;
				float fragment_unnamed_1010 = fragment_unnamed_1006.z;
				float fragment_unnamed_1015 = asfloat(fragment_unnamed_980 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_965)) : fragment_unnamed_965) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1016 = asfloat(fragment_unnamed_980 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_967)) : fragment_unnamed_967) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1017 = asfloat(fragment_unnamed_980 ? asuint(fragment_unnamed_495 * asfloat(fragment_unnamed_969)) : fragment_unnamed_969) * fragment_uniform_buffer_0[13u].w;
				float fragment_unnamed_1029 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1030 = fragment_uniform_buffer_0[17u].z + fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1031 = fragment_uniform_buffer_0[17u].x + fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1032 = fragment_uniform_buffer_0[17u].y + fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1038 = fragment_unnamed_1031 * fragment_uniform_buffer_0[17u].x;
				float fragment_unnamed_1039 = fragment_unnamed_1032 * fragment_uniform_buffer_0[17u].y;
				float fragment_unnamed_1040 = fragment_unnamed_1030 * fragment_uniform_buffer_0[17u].z;
				float fragment_unnamed_1048 = fragment_unnamed_1031 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1049 = fragment_unnamed_1032 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1053 = fragment_unnamed_1030 * fragment_uniform_buffer_0[17u].w;
				float fragment_unnamed_1084 = mad(fragment_unnamed_1049 + (fragment_unnamed_1029 * fragment_uniform_buffer_0[17u].x), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1032, (-0.0f) - fragment_unnamed_1053), fragment_input_5.y, (((-0.0f) - (fragment_unnamed_1040 + fragment_unnamed_1039)) + 1.0f) * fragment_input_5.x));
				float fragment_unnamed_1102 = mad(mad(fragment_uniform_buffer_0[17u].y, fragment_unnamed_1030, (-0.0f) - fragment_unnamed_1048), fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1032, fragment_unnamed_1053), fragment_input_5.x, (((-0.0f) - (fragment_unnamed_1040 + fragment_unnamed_1038)) + 1.0f) * fragment_input_5.y));
				float fragment_unnamed_1108 = mad(((-0.0f) - (fragment_unnamed_1039 + fragment_unnamed_1038)) + 1.0f, fragment_input_5.z, mad(mad(fragment_uniform_buffer_0[17u].x, fragment_unnamed_1029, (-0.0f) - fragment_unnamed_1049), fragment_input_5.x, (fragment_unnamed_1048 + (fragment_unnamed_1030 * fragment_uniform_buffer_0[17u].y)) * fragment_input_5.y));
				float fragment_unnamed_1112 = rsqrt(dot(float3(fragment_unnamed_1084, fragment_unnamed_1102, fragment_unnamed_1108), float3(fragment_unnamed_1084, fragment_unnamed_1102, fragment_unnamed_1108)));
				float fragment_unnamed_1113 = fragment_unnamed_1112 * fragment_unnamed_1084;
				float fragment_unnamed_1114 = fragment_unnamed_1112 * fragment_unnamed_1102;
				float fragment_unnamed_1115 = fragment_unnamed_1112 * fragment_unnamed_1108;
				float fragment_unnamed_1122 = mad(mad(fragment_unnamed_815.x, fragment_unnamed_825, (-0.0f) - fragment_unnamed_1015), 0.5f, fragment_unnamed_1015);
				float fragment_unnamed_1123 = mad(mad(fragment_unnamed_815.y, fragment_unnamed_825, (-0.0f) - fragment_unnamed_1016), 0.5f, fragment_unnamed_1016);
				float fragment_unnamed_1124 = mad(mad(fragment_unnamed_815.z, fragment_unnamed_825, (-0.0f) - fragment_unnamed_1017), 0.5f, fragment_unnamed_1017);
				float fragment_unnamed_1125 = dot(float3(fragment_unnamed_1122, fragment_unnamed_1123, fragment_unnamed_1124), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1131 = mad(((-0.0f) - fragment_unnamed_1125) + 0.5f, 0.60000002384185791015625f, fragment_unnamed_1125);
				float fragment_unnamed_1137 = (-0.0f) - fragment_unnamed_1131;
				float fragment_unnamed_1165 = mad((-0.0f) - fragment_uniform_buffer_0[19u].x, 0.89999997615814208984375f, 1.0f);
				float fragment_unnamed_1192 = ((-0.0f) - fragment_input_4.x) + fragment_uniform_buffer_1[4u].x;
				float fragment_unnamed_1193 = ((-0.0f) - fragment_input_4.y) + fragment_uniform_buffer_1[4u].y;
				float fragment_unnamed_1194 = ((-0.0f) - fragment_input_4.z) + fragment_uniform_buffer_1[4u].z;
				float fragment_unnamed_1198 = rsqrt(dot(float3(fragment_unnamed_1192, fragment_unnamed_1193, fragment_unnamed_1194), float3(fragment_unnamed_1192, fragment_unnamed_1193, fragment_unnamed_1194)));
				float fragment_unnamed_1199 = fragment_unnamed_1198 * fragment_unnamed_1192;
				float fragment_unnamed_1200 = fragment_unnamed_1198 * fragment_unnamed_1193;
				float fragment_unnamed_1201 = fragment_unnamed_1198 * fragment_unnamed_1194;
				float fragment_unnamed_1414;
				float fragment_unnamed_1415;
				float fragment_unnamed_1416;
				float fragment_unnamed_1417;
				if (fragment_uniform_buffer_3[0u].x == 1.0f)
				{
					bool fragment_unnamed_1328 = fragment_uniform_buffer_3[0u].y == 1.0f;
					float4 fragment_unnamed_1404 = _LightTexture0.Sample(sampler_LightTexture0, float3(max(mad(((fragment_unnamed_1328 ? (mad(fragment_uniform_buffer_3[3u].x, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].x)) + fragment_uniform_buffer_3[4u].x) : fragment_input_4.x) + ((-0.0f) - fragment_uniform_buffer_3[6u].x)) * fragment_uniform_buffer_3[5u].x, 0.25f, 0.75f), mad(fragment_uniform_buffer_3[0u].z, 0.5f, 0.75f)), ((fragment_unnamed_1328 ? (mad(fragment_uniform_buffer_3[3u].y, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].y)) + fragment_uniform_buffer_3[4u].y) : fragment_input_4.y) + ((-0.0f) - fragment_uniform_buffer_3[6u].y)) * fragment_uniform_buffer_3[5u].y, ((fragment_unnamed_1328 ? (mad(fragment_uniform_buffer_3[3u].z, fragment_input_4.z, mad(fragment_uniform_buffer_3[1u].z, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_3[2u].z)) + fragment_uniform_buffer_3[4u].z) : fragment_input_4.z) + ((-0.0f) - fragment_uniform_buffer_3[6u].z)) * fragment_uniform_buffer_3[5u].z));
					fragment_unnamed_1414 = fragment_unnamed_1404.x;
					fragment_unnamed_1415 = fragment_unnamed_1404.y;
					fragment_unnamed_1416 = fragment_unnamed_1404.z;
					fragment_unnamed_1417 = fragment_unnamed_1404.w;
				}
				else
				{
					fragment_unnamed_1414 = asfloat(1065353216u);
					fragment_unnamed_1415 = asfloat(1065353216u);
					fragment_unnamed_1416 = asfloat(1065353216u);
					fragment_unnamed_1417 = asfloat(1065353216u);
				}
				float fragment_unnamed_1428 = clamp(dot(float4(fragment_unnamed_1414, fragment_unnamed_1415, fragment_unnamed_1416, fragment_unnamed_1417), float4(fragment_uniform_buffer_2[46u])), 0.0f, 1.0f);
				float4 fragment_unnamed_1430 = _Global_PGI.Sample(sampler_Global_PGI, float2(mad(fragment_uniform_buffer_0[6u].x, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].x, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].x)) + fragment_uniform_buffer_0[7u].x, mad(fragment_uniform_buffer_0[6u].y, fragment_input_4.z, mad(fragment_uniform_buffer_0[4u].y, fragment_input_4.x, fragment_input_4.y * fragment_uniform_buffer_0[5u].y)) + fragment_uniform_buffer_0[7u].y));
				float fragment_unnamed_1432 = fragment_unnamed_1430.w;
				float fragment_unnamed_1440 = dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_unnamed_852, fragment_unnamed_853, fragment_unnamed_854));
				float fragment_unnamed_1449 = dot(float3(fragment_input_2.x, fragment_input_2.y, fragment_input_2.z), float3(fragment_unnamed_852, fragment_unnamed_853, fragment_unnamed_854));
				float fragment_unnamed_1458 = dot(float3(fragment_input_3.x, fragment_input_3.y, fragment_input_3.z), float3(fragment_unnamed_852, fragment_unnamed_853, fragment_unnamed_854));
				float fragment_unnamed_1464 = rsqrt(dot(float3(fragment_unnamed_1440, fragment_unnamed_1449, fragment_unnamed_1458), float3(fragment_unnamed_1440, fragment_unnamed_1449, fragment_unnamed_1458)));
				float fragment_unnamed_1465 = fragment_unnamed_1464 * fragment_unnamed_1440;
				float fragment_unnamed_1466 = fragment_unnamed_1464 * fragment_unnamed_1449;
				float fragment_unnamed_1467 = fragment_unnamed_1464 * fragment_unnamed_1458;
				float fragment_unnamed_1488 = ((-0.0f) - fragment_uniform_buffer_0[9u].x) + 1.0f;
				float fragment_unnamed_1489 = ((-0.0f) - fragment_uniform_buffer_0[9u].y) + 1.0f;
				float fragment_unnamed_1490 = ((-0.0f) - fragment_uniform_buffer_0[9u].z) + 1.0f;
				float fragment_unnamed_1502 = dot(float3(fragment_unnamed_1465, fragment_unnamed_1466, fragment_unnamed_1467), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1505 = mad(fragment_unnamed_1502, 0.25f, 1.0f);
				float fragment_unnamed_1507 = fragment_unnamed_1505 * (fragment_unnamed_1505 * fragment_unnamed_1505);
				float fragment_unnamed_1512 = exp2(log2(max(fragment_unnamed_1502, 0.0f)) * 0.62999999523162841796875f);
				float fragment_unnamed_1513 = fragment_unnamed_1512 + fragment_unnamed_1512;
				float fragment_unnamed_1524 = asfloat((0.5f < fragment_unnamed_1512) ? asuint(mad(log2(mad(log2(fragment_unnamed_1513), 0.693147182464599609375f, 1.0f)), 0.693147182464599609375f, 1.0f)) : asuint(fragment_unnamed_1513)) * 0.5f;
				float fragment_unnamed_1530 = dot(float3(fragment_unnamed_1113, fragment_unnamed_1114, fragment_unnamed_1115), float3(fragment_uniform_buffer_0[16u].xyz));
				float fragment_unnamed_1673;
				float fragment_unnamed_1674;
				float fragment_unnamed_1675;
				if (1.0f >= fragment_unnamed_1530)
				{
					float fragment_unnamed_1552 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].x) + 1.0f), fragment_unnamed_1488, 1.0f);
					float fragment_unnamed_1553 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].y) + 1.0f), fragment_unnamed_1489, 1.0f);
					float fragment_unnamed_1554 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[20u].z) + 1.0f), fragment_unnamed_1490, 1.0f);
					float fragment_unnamed_1570 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].x) + 1.0f), fragment_unnamed_1488, 1.0f);
					float fragment_unnamed_1571 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].y) + 1.0f), fragment_unnamed_1489, 1.0f);
					float fragment_unnamed_1572 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[21u].z) + 1.0f), fragment_unnamed_1490, 1.0f);
					float fragment_unnamed_1601 = clamp((fragment_unnamed_1530 + (-0.20000000298023223876953125f)) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1602 = clamp((fragment_unnamed_1530 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
					float fragment_unnamed_1603 = clamp((fragment_unnamed_1530 + 0.100000001490116119384765625f) * 5.0f, 0.0f, 1.0f);
					float fragment_unnamed_1604 = clamp((fragment_unnamed_1530 + 0.300000011920928955078125f) * 5.0f, 0.0f, 1.0f);
					bool fragment_unnamed_1627 = 0.20000000298023223876953125f < fragment_unnamed_1530;
					bool fragment_unnamed_1628 = 0.100000001490116119384765625f < fragment_unnamed_1530;
					bool fragment_unnamed_1629 = (-0.100000001490116119384765625f) < fragment_unnamed_1530;
					float fragment_unnamed_1630 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].x) + 1.0f), fragment_unnamed_1488, 1.0f) * 1.5f;
					float fragment_unnamed_1632 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].y) + 1.0f), fragment_unnamed_1489, 1.0f) * 1.5f;
					float fragment_unnamed_1633 = mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[22u].z) + 1.0f), fragment_unnamed_1490, 1.0f) * 1.5f;
					fragment_unnamed_1673 = asfloat(fragment_unnamed_1627 ? asuint(mad(fragment_unnamed_1601, ((-0.0f) - fragment_unnamed_1552) + 1.0f, fragment_unnamed_1552)) : (fragment_unnamed_1628 ? asuint(mad(fragment_unnamed_1602, mad((-0.0f) - fragment_unnamed_1570, 1.25f, fragment_unnamed_1552), fragment_unnamed_1570 * 1.25f)) : (fragment_unnamed_1629 ? asuint(mad(fragment_unnamed_1603, mad(fragment_unnamed_1570, 1.25f, (-0.0f) - fragment_unnamed_1630), fragment_unnamed_1630)) : asuint(fragment_unnamed_1630 * fragment_unnamed_1604))));
					fragment_unnamed_1674 = asfloat(fragment_unnamed_1627 ? asuint(mad(fragment_unnamed_1601, ((-0.0f) - fragment_unnamed_1553) + 1.0f, fragment_unnamed_1553)) : (fragment_unnamed_1628 ? asuint(mad(fragment_unnamed_1602, mad((-0.0f) - fragment_unnamed_1571, 1.25f, fragment_unnamed_1553), fragment_unnamed_1571 * 1.25f)) : (fragment_unnamed_1629 ? asuint(mad(fragment_unnamed_1603, mad(fragment_unnamed_1571, 1.25f, (-0.0f) - fragment_unnamed_1632), fragment_unnamed_1632)) : asuint(fragment_unnamed_1632 * fragment_unnamed_1604))));
					fragment_unnamed_1675 = asfloat(fragment_unnamed_1627 ? asuint(mad(fragment_unnamed_1601, ((-0.0f) - fragment_unnamed_1554) + 1.0f, fragment_unnamed_1554)) : (fragment_unnamed_1628 ? asuint(mad(fragment_unnamed_1602, mad((-0.0f) - fragment_unnamed_1572, 1.25f, fragment_unnamed_1554), fragment_unnamed_1572 * 1.25f)) : (fragment_unnamed_1629 ? asuint(mad(fragment_unnamed_1603, mad(fragment_unnamed_1572, 1.25f, (-0.0f) - fragment_unnamed_1633), fragment_unnamed_1633)) : asuint(fragment_unnamed_1633 * fragment_unnamed_1604))));
				}
				else
				{
					fragment_unnamed_1673 = asfloat(1065353216u);
					fragment_unnamed_1674 = asfloat(1065353216u);
					fragment_unnamed_1675 = asfloat(1065353216u);
				}
				float fragment_unnamed_1683 = clamp(fragment_unnamed_1530 * 3.0f, 0.0f, 1.0f);
				float fragment_unnamed_1687 = mad(clamp(fragment_unnamed_1530 * 0.1500000059604644775390625f, 0.0f, 1.0f), mad((-0.0f) - fragment_unnamed_1432, fragment_unnamed_1428, 1.0f), fragment_unnamed_1428 * fragment_unnamed_1432) * 0.800000011920928955078125f;
				float fragment_unnamed_1699 = min(max((((-0.0f) - fragment_uniform_buffer_0[15u].z) + 400.0f) * 0.006666666828095912933349609375f, 0.0f) + 0.4000000059604644775390625f, 1.0f);
				float fragment_unnamed_1708 = mad(clamp(mad(log2(fragment_uniform_buffer_0[15u].z), 0.3465735912322998046875f, -4.19999980926513671875f), 0.0f, 1.0f), 2.0f, 1.0f);
				float fragment_unnamed_1725 = mad(exp2(log2(fragment_uniform_buffer_0[10u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1728 = mad(exp2(log2(fragment_uniform_buffer_0[10u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1729 = mad(exp2(log2(fragment_uniform_buffer_0[10u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1761 = mad(exp2(log2(fragment_uniform_buffer_0[11u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1762 = mad(exp2(log2(fragment_uniform_buffer_0[11u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1763 = mad(exp2(log2(fragment_uniform_buffer_0[11u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1773 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1761) + 0.0240000002086162567138671875f, fragment_unnamed_1761);
				float fragment_unnamed_1774 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1762) + 0.0240000002086162567138671875f, fragment_unnamed_1762);
				float fragment_unnamed_1775 = mad(fragment_uniform_buffer_0[19u].x, ((-0.0f) - fragment_unnamed_1763) + 0.0240000002086162567138671875f, fragment_unnamed_1763);
				float fragment_unnamed_1791 = mad(exp2(log2(fragment_uniform_buffer_0[12u].x) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1792 = mad(exp2(log2(fragment_uniform_buffer_0[12u].y) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1793 = mad(exp2(log2(fragment_uniform_buffer_0[12u].z) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
				float fragment_unnamed_1806 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1791, fragment_unnamed_1699, 0.0240000002086162567138671875f), fragment_unnamed_1699 * fragment_unnamed_1791);
				float fragment_unnamed_1807 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1792, fragment_unnamed_1699, 0.0240000002086162567138671875f), fragment_unnamed_1699 * fragment_unnamed_1792);
				float fragment_unnamed_1808 = mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1793, fragment_unnamed_1699, 0.0240000002086162567138671875f), fragment_unnamed_1699 * fragment_unnamed_1793);
				float fragment_unnamed_1809 = dot(float3(fragment_unnamed_1773, fragment_unnamed_1774, fragment_unnamed_1775), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1818 = mad(((-0.0f) - fragment_unnamed_1773) + fragment_unnamed_1809, 0.300000011920928955078125f, fragment_unnamed_1773);
				float fragment_unnamed_1819 = mad(((-0.0f) - fragment_unnamed_1774) + fragment_unnamed_1809, 0.300000011920928955078125f, fragment_unnamed_1774);
				float fragment_unnamed_1820 = mad(((-0.0f) - fragment_unnamed_1775) + fragment_unnamed_1809, 0.300000011920928955078125f, fragment_unnamed_1775);
				float fragment_unnamed_1821 = dot(float3(fragment_unnamed_1806, fragment_unnamed_1807, fragment_unnamed_1808), float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.100000001490116119384765625f));
				float fragment_unnamed_1830 = mad(((-0.0f) - fragment_unnamed_1806) + fragment_unnamed_1821, 0.300000011920928955078125f, fragment_unnamed_1806);
				float fragment_unnamed_1831 = mad(((-0.0f) - fragment_unnamed_1807) + fragment_unnamed_1821, 0.300000011920928955078125f, fragment_unnamed_1807);
				float fragment_unnamed_1832 = mad(((-0.0f) - fragment_unnamed_1808) + fragment_unnamed_1821, 0.300000011920928955078125f, fragment_unnamed_1808);
				bool fragment_unnamed_1833 = 0.0f < fragment_unnamed_1530;
				float fragment_unnamed_1846 = clamp(mad(fragment_unnamed_1530, 3.0f, 1.0f), 0.0f, 1.0f);
				float fragment_unnamed_1847 = clamp(mad(fragment_unnamed_1530, 6.0f, 0.5f), 0.0f, 1.0f);
				float fragment_unnamed_1871 = clamp(mad(dot(float3(fragment_unnamed_1465, fragment_unnamed_1466, fragment_unnamed_1467), float3(fragment_unnamed_1113, fragment_unnamed_1114, fragment_unnamed_1115)), 0.300000011920928955078125f, 0.699999988079071044921875f), 0.0f, 1.0f);
				float fragment_unnamed_1875 = asfloat(asuint(fragment_uniform_buffer_0[14u]).x) + 1.0f;
				float fragment_unnamed_1882 = dot(float3((-0.0f) - fragment_unnamed_1199, (-0.0f) - fragment_unnamed_1200, (-0.0f) - fragment_unnamed_1201), float3(fragment_unnamed_1465, fragment_unnamed_1466, fragment_unnamed_1467));
				float fragment_unnamed_1886 = (-0.0f) - (fragment_unnamed_1882 + fragment_unnamed_1882);
				float fragment_unnamed_1890 = mad(fragment_unnamed_1465, fragment_unnamed_1886, (-0.0f) - fragment_unnamed_1199);
				float fragment_unnamed_1891 = mad(fragment_unnamed_1466, fragment_unnamed_1886, (-0.0f) - fragment_unnamed_1200);
				float fragment_unnamed_1892 = mad(fragment_unnamed_1467, fragment_unnamed_1886, (-0.0f) - fragment_unnamed_1201);
				uint fragment_unnamed_1908 = (fragment_uniform_buffer_0[29u].w >= 0.5f) ? 4294967295u : 0u;
				float fragment_unnamed_1923 = sqrt(dot(float3(fragment_uniform_buffer_0[29u].xyz), float3(fragment_uniform_buffer_0[29u].xyz))) + (-5.0f);
				float fragment_unnamed_1939 = clamp(dot(float3((-0.0f) - fragment_unnamed_1113, (-0.0f) - fragment_unnamed_1114, (-0.0f) - fragment_unnamed_1115), float3(fragment_uniform_buffer_0[16u].xyz)) * 5.0f, 0.0f, 1.0f) * clamp(fragment_unnamed_1923, 0.0f, 1.0f);
				float fragment_unnamed_1948 = mad((-0.0f) - fragment_unnamed_1113, fragment_unnamed_1923, fragment_uniform_buffer_0[29u].x);
				float fragment_unnamed_1949 = mad((-0.0f) - fragment_unnamed_1114, fragment_unnamed_1923, fragment_uniform_buffer_0[29u].y);
				float fragment_unnamed_1950 = mad((-0.0f) - fragment_unnamed_1115, fragment_unnamed_1923, fragment_uniform_buffer_0[29u].z);
				float fragment_unnamed_1954 = sqrt(dot(float3(fragment_unnamed_1948, fragment_unnamed_1949, fragment_unnamed_1950), float3(fragment_unnamed_1948, fragment_unnamed_1949, fragment_unnamed_1950)));
				float fragment_unnamed_1960 = max((((-0.0f) - fragment_unnamed_1954) + 20.0f) * 0.0500000007450580596923828125f, 0.0f);
				bool fragment_unnamed_1962 = fragment_unnamed_1954 < 0.001000000047497451305389404296875f;
				float fragment_unnamed_1977 = fragment_unnamed_1939 * ((fragment_unnamed_1960 * fragment_unnamed_1960) * clamp(dot(float3(fragment_unnamed_1948 / fragment_unnamed_1954, fragment_unnamed_1949 / fragment_unnamed_1954, fragment_unnamed_1950 / fragment_unnamed_1954), float3(fragment_unnamed_1465, fragment_unnamed_1466, fragment_unnamed_1467)), 0.0f, 1.0f));
				float fragment_unnamed_1996 = clamp(fragment_unnamed_1165 * mad(fragment_unnamed_815.w * 0.60000002384185791015625f, ((-0.0f) - fragment_unnamed_881) + 1.0f, fragment_unnamed_881), 0.0f, 1.0f);
				float fragment_unnamed_2002 = exp2(log2(fragment_unnamed_1847 * max(dot(float3(fragment_unnamed_1890, fragment_unnamed_1891, fragment_unnamed_1892), float3(fragment_uniform_buffer_0[16u].xyz)), 0.0f)) * exp2(fragment_unnamed_1996 * 6.906890392303466796875f));
				uint fragment_unnamed_2019 = (0.00999999977648258209228515625f < dot(float3(fragment_unnamed_1113, fragment_unnamed_1114, fragment_unnamed_1115), float3(fragment_unnamed_1113, fragment_unnamed_1114, fragment_unnamed_1115))) ? 4294967295u : 0u;
				float fragment_unnamed_2027 = mad(fragment_unnamed_1113, 1.0f, (-0.0f) - (fragment_unnamed_1114 * 0.0f));
				float fragment_unnamed_2028 = mad(fragment_unnamed_1114, 0.0f, (-0.0f) - (fragment_unnamed_1115 * 1.0f));
				float fragment_unnamed_2033 = rsqrt(dot(float2(fragment_unnamed_2027, fragment_unnamed_2028), float2(fragment_unnamed_2027, fragment_unnamed_2028)));
				bool fragment_unnamed_2037 = (fragment_unnamed_2019 & ((fragment_unnamed_1114 < 0.99989998340606689453125f) ? 4294967295u : 0u)) != 0u;
				float fragment_unnamed_2042 = asfloat(fragment_unnamed_2037 ? asuint(fragment_unnamed_2033 * fragment_unnamed_2027) : 0u);
				float fragment_unnamed_2044 = asfloat(fragment_unnamed_2037 ? asuint(fragment_unnamed_2033 * fragment_unnamed_2028) : 1065353216u);
				float fragment_unnamed_2046 = asfloat(fragment_unnamed_2037 ? asuint(fragment_unnamed_2033 * mad(fragment_unnamed_1115, 0.0f, (-0.0f) - (fragment_unnamed_1113 * 0.0f))) : 0u);
				float fragment_unnamed_2059 = mad(fragment_unnamed_2046, fragment_unnamed_1115, (-0.0f) - (fragment_unnamed_1114 * fragment_unnamed_2042));
				float fragment_unnamed_2060 = mad(fragment_unnamed_2042, fragment_unnamed_1113, (-0.0f) - (fragment_unnamed_1115 * fragment_unnamed_2044));
				float fragment_unnamed_2061 = mad(fragment_unnamed_2044, fragment_unnamed_1114, (-0.0f) - (fragment_unnamed_1113 * fragment_unnamed_2046));
				float fragment_unnamed_2065 = rsqrt(dot(float3(fragment_unnamed_2059, fragment_unnamed_2060, fragment_unnamed_2061), float3(fragment_unnamed_2059, fragment_unnamed_2060, fragment_unnamed_2061)));
				bool fragment_unnamed_2077 = (fragment_unnamed_2019 & ((0.00999999977648258209228515625f < dot(float2(fragment_unnamed_2042, fragment_unnamed_2044), float2(fragment_unnamed_2042, fragment_unnamed_2044))) ? 4294967295u : 0u)) != 0u;
				float4 fragment_unnamed_2095 = unity_ProbeVolumeSH.SampleLevel(samplerunity_ProbeVolumeSH, float3(dot(float2(fragment_unnamed_1892, fragment_unnamed_1890), float2((-0.0f) - fragment_unnamed_2042, (-0.0f) - fragment_unnamed_2044)), dot(float3(fragment_unnamed_1890, fragment_unnamed_1891, fragment_unnamed_1892), float3(fragment_unnamed_1113, fragment_unnamed_1114, fragment_unnamed_1115)), dot(float3(fragment_unnamed_1890, fragment_unnamed_1891, fragment_unnamed_1892), float3(fragment_unnamed_2077 ? ((-0.0f) - (fragment_unnamed_2065 * fragment_unnamed_2059)) : (-0.0f), fragment_unnamed_2077 ? ((-0.0f) - (fragment_unnamed_2065 * fragment_unnamed_2060)) : (-0.0f), fragment_unnamed_2077 ? ((-0.0f) - (fragment_unnamed_2065 * fragment_unnamed_2061)) : (-1.0f)))), exp2(log2(((-0.0f) - fragment_unnamed_1996) + 1.0f) * 0.4000000059604644775390625f) * 10.0f);
				float fragment_unnamed_2114 = mad(fragment_unnamed_1847, ((-0.0f) - fragment_uniform_buffer_0[13u].y) + fragment_uniform_buffer_0[13u].x, fragment_uniform_buffer_0[13u].y);
				float fragment_unnamed_2118 = dot(float3(fragment_unnamed_2114 * (fragment_unnamed_1996 * fragment_unnamed_2095.x), fragment_unnamed_2114 * (fragment_unnamed_1996 * fragment_unnamed_2095.y), fragment_unnamed_2114 * (fragment_unnamed_1996 * fragment_unnamed_2095.z)), float3(0.04500000178813934326171875f, 0.0900000035762786865234375f, 0.01500000059604644775390625f));
				float fragment_unnamed_2139 = fragment_unnamed_2118 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1137, 0.7200000286102294921875f, fragment_unnamed_1122), 0.14000000059604644775390625f, fragment_unnamed_1131 * 0.7200000286102294921875f), 0.15129999816417694091796875f, (-0.0f) - fragment_unnamed_1015), fragment_unnamed_1015), asfloat(fragment_unnamed_1908 & (fragment_unnamed_1962 ? asuint(fragment_unnamed_1939 * 1.2999999523162841796875f) : asuint(fragment_unnamed_1977 * 1.2999999523162841796875f))) + mad(fragment_unnamed_1524 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].x) + 1.0f), fragment_unnamed_1488, 1.0f) * fragment_unnamed_1673), fragment_unnamed_1687, fragment_unnamed_1507 * (fragment_unnamed_1875 * (fragment_unnamed_1871 * asfloat(fragment_unnamed_1833 ? asuint(mad(fragment_unnamed_1683, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1725, fragment_unnamed_1708, 0.0240000002086162567138671875f), fragment_unnamed_1708 * fragment_unnamed_1725) + ((-0.0f) - fragment_unnamed_1818), fragment_unnamed_1818)) : asuint(mad(fragment_unnamed_1846, fragment_unnamed_1818 + ((-0.0f) - fragment_unnamed_1830), fragment_unnamed_1830)))))), (fragment_unnamed_1996 * ((fragment_unnamed_1165 * mad(fragment_unnamed_823, mad(fragment_unnamed_815.x, fragment_unnamed_825, (-0.0f) - fragment_uniform_buffer_0[8u].x), fragment_uniform_buffer_0[8u].x)) * fragment_unnamed_2002)) * 0.5f);
				float fragment_unnamed_2140 = fragment_unnamed_2118 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1137, 0.85000002384185791015625f, fragment_unnamed_1123), 0.14000000059604644775390625f, fragment_unnamed_1131 * 0.85000002384185791015625f), 0.15980000793933868408203125f, (-0.0f) - fragment_unnamed_1016), fragment_unnamed_1016), asfloat(fragment_unnamed_1908 & (fragment_unnamed_1962 ? asuint(fragment_unnamed_1939 * 1.10000002384185791015625f) : asuint(fragment_unnamed_1977 * 1.10000002384185791015625f))) + mad(fragment_unnamed_1524 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].y) + 1.0f), fragment_unnamed_1489, 1.0f) * fragment_unnamed_1674), fragment_unnamed_1687, fragment_unnamed_1507 * (fragment_unnamed_1875 * (fragment_unnamed_1871 * asfloat(fragment_unnamed_1833 ? asuint(mad(fragment_unnamed_1683, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1728, fragment_unnamed_1708, 0.0240000002086162567138671875f), fragment_unnamed_1708 * fragment_unnamed_1728) + ((-0.0f) - fragment_unnamed_1819), fragment_unnamed_1819)) : asuint(mad(fragment_unnamed_1846, fragment_unnamed_1819 + ((-0.0f) - fragment_unnamed_1831), fragment_unnamed_1831)))))), (fragment_unnamed_1996 * ((fragment_unnamed_1165 * mad(fragment_unnamed_823, mad(fragment_unnamed_815.y, fragment_unnamed_825, (-0.0f) - fragment_uniform_buffer_0[8u].y), fragment_uniform_buffer_0[8u].y)) * fragment_unnamed_2002)) * 0.5f);
				float fragment_unnamed_2141 = fragment_unnamed_2118 + mad(mad(fragment_uniform_buffer_0[19u].x, mad(mad(mad(fragment_unnamed_1137, 1.0f, fragment_unnamed_1124), 0.14000000059604644775390625f, fragment_unnamed_1131 * 1.0f), 0.17000000178813934326171875f, (-0.0f) - fragment_unnamed_1017), fragment_unnamed_1017), asfloat(fragment_unnamed_1908 & (fragment_unnamed_1962 ? asuint(fragment_unnamed_1939 * 0.60000002384185791015625f) : asuint(fragment_unnamed_1977 * 0.60000002384185791015625f))) + mad(fragment_unnamed_1524 * (mad((-0.0f) - (((-0.0f) - fragment_uniform_buffer_0[2u].z) + 1.0f), fragment_unnamed_1490, 1.0f) * fragment_unnamed_1675), fragment_unnamed_1687, fragment_unnamed_1507 * (fragment_unnamed_1875 * (fragment_unnamed_1871 * asfloat(fragment_unnamed_1833 ? asuint(mad(fragment_unnamed_1683, mad(fragment_uniform_buffer_0[19u].x, mad((-0.0f) - fragment_unnamed_1729, fragment_unnamed_1708, 0.0240000002086162567138671875f), fragment_unnamed_1708 * fragment_unnamed_1729) + ((-0.0f) - fragment_unnamed_1820), fragment_unnamed_1820)) : asuint(mad(fragment_unnamed_1846, fragment_unnamed_1820 + ((-0.0f) - fragment_unnamed_1832), fragment_unnamed_1832)))))), (fragment_unnamed_1996 * ((fragment_unnamed_1165 * mad(fragment_unnamed_823, mad(fragment_unnamed_815.z, fragment_unnamed_825, (-0.0f) - fragment_uniform_buffer_0[8u].z), fragment_uniform_buffer_0[8u].z)) * fragment_unnamed_2002)) * 0.5f);
				fragment_output_0.x = mad(fragment_unnamed_986, ((-0.0f) - fragment_unnamed_1008) + fragment_unnamed_2139, fragment_unnamed_1008);
				fragment_output_0.y = mad(fragment_unnamed_986, ((-0.0f) - fragment_unnamed_1009) + fragment_unnamed_2140, fragment_unnamed_1009);
				fragment_output_0.z = mad(fragment_unnamed_986, ((-0.0f) - fragment_unnamed_1010) + fragment_unnamed_2141, fragment_unnamed_1010);
				fragment_output_0.w = 1.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[4] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
				fragment_uniform_buffer_0[5] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
				fragment_uniform_buffer_0[6] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
				fragment_uniform_buffer_0[7] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);

				fragment_uniform_buffer_0[8] = float4(_SpeclColor[0], _SpeclColor[1], _SpeclColor[2], _SpeclColor[3]);

				fragment_uniform_buffer_0[9] = float4(_LightColorScreen[0], _LightColorScreen[1], _LightColorScreen[2], _LightColorScreen[3]);

				fragment_uniform_buffer_0[10] = float4(_AmbientColor0[0], _AmbientColor0[1], _AmbientColor0[2], _AmbientColor0[3]);

				fragment_uniform_buffer_0[11] = float4(_AmbientColor1[0], _AmbientColor1[1], _AmbientColor1[2], _AmbientColor1[3]);

				fragment_uniform_buffer_0[12] = float4(_AmbientColor2[0], _AmbientColor2[1], _AmbientColor2[2], _AmbientColor2[3]);

				fragment_uniform_buffer_0[13] = float4(_GIStrengthDay, fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], _GIStrengthNight, fragment_uniform_buffer_0[13][2], fragment_uniform_buffer_0[13][3]);

				fragment_uniform_buffer_0[13] = float4(fragment_uniform_buffer_0[13][0], fragment_uniform_buffer_0[13][1], fragment_uniform_buffer_0[13][2], _Multiplier);

				fragment_uniform_buffer_0[14] = float4(_AmbientInc, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], _MaterialIndex, fragment_uniform_buffer_0[15][2], fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[15] = float4(fragment_uniform_buffer_0[15][0], fragment_uniform_buffer_0[15][1], _Distance, fragment_uniform_buffer_0[15][3]);

				fragment_uniform_buffer_0[16] = float4(_SunDir[0], _SunDir[1], _SunDir[2], fragment_uniform_buffer_0[16][3]);

				fragment_uniform_buffer_0[17] = float4(_Rotation[0], _Rotation[1], _Rotation[2], _Rotation[3]);

				fragment_uniform_buffer_0[18] = float4(_LatitudeCount, fragment_uniform_buffer_0[18][1], fragment_uniform_buffer_0[18][2], fragment_uniform_buffer_0[18][3]);

				fragment_uniform_buffer_0[19] = float4(_Global_WhiteMode0, fragment_uniform_buffer_0[19][1], fragment_uniform_buffer_0[19][2], fragment_uniform_buffer_0[19][3]);

				fragment_uniform_buffer_0[20] = float4(_Global_SunsetColor0[0], _Global_SunsetColor0[1], _Global_SunsetColor0[2], _Global_SunsetColor0[3]);

				fragment_uniform_buffer_0[21] = float4(_Global_SunsetColor1[0], _Global_SunsetColor1[1], _Global_SunsetColor1[2], _Global_SunsetColor1[3]);

				fragment_uniform_buffer_0[22] = float4(_Global_SunsetColor2[0], _Global_SunsetColor2[1], _Global_SunsetColor2[2], _Global_SunsetColor2[3]);

				fragment_uniform_buffer_0[29] = float4(_Global_PointLightPos[0], _Global_PointLightPos[1], _Global_PointLightPos[2], _Global_PointLightPos[3]);

				fragment_uniform_buffer_1[4] = float4(_WorldSpaceCameraPos[0], _WorldSpaceCameraPos[1], _WorldSpaceCameraPos[2], fragment_uniform_buffer_1[4][3]);

				fragment_uniform_buffer_2[46] = float4(unity_OcclusionMaskSelector[0], unity_OcclusionMaskSelector[1], unity_OcclusionMaskSelector[2], unity_OcclusionMaskSelector[3]);

				fragment_uniform_buffer_3[0] = float4(unity_ProbeVolumeParams[0], unity_ProbeVolumeParams[1], unity_ProbeVolumeParams[2], unity_ProbeVolumeParams[3]);

				fragment_uniform_buffer_3[1] = float4(unity_ProbeVolumeWorldToObject[0][0], unity_ProbeVolumeWorldToObject[1][0], unity_ProbeVolumeWorldToObject[2][0], unity_ProbeVolumeWorldToObject[3][0]);
				fragment_uniform_buffer_3[2] = float4(unity_ProbeVolumeWorldToObject[0][1], unity_ProbeVolumeWorldToObject[1][1], unity_ProbeVolumeWorldToObject[2][1], unity_ProbeVolumeWorldToObject[3][1]);
				fragment_uniform_buffer_3[3] = float4(unity_ProbeVolumeWorldToObject[0][2], unity_ProbeVolumeWorldToObject[1][2], unity_ProbeVolumeWorldToObject[2][2], unity_ProbeVolumeWorldToObject[3][2]);
				fragment_uniform_buffer_3[4] = float4(unity_ProbeVolumeWorldToObject[0][3], unity_ProbeVolumeWorldToObject[1][3], unity_ProbeVolumeWorldToObject[2][3], unity_ProbeVolumeWorldToObject[3][3]);

				fragment_uniform_buffer_3[5] = float4(unity_ProbeVolumeSizeInv[0], unity_ProbeVolumeSizeInv[1], unity_ProbeVolumeSizeInv[2], fragment_uniform_buffer_3[5][3]);

				fragment_uniform_buffer_3[6] = float4(unity_ProbeVolumeMin[0], unity_ProbeVolumeMin[1], unity_ProbeVolumeMin[2], fragment_uniform_buffer_3[6][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				fragment_input_8 = stage_input.fragment_input_8;
				fragment_input_9 = stage_input.fragment_input_9;
				fragment_input_10 = stage_input.fragment_input_10;
				fragment_input_11 = stage_input.fragment_input_11;
				fragment_input_12 = stage_input.fragment_input_12;
				fragment_input_13 = stage_input.fragment_input_13;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // DIRECTIONAL_COOKIE
			#endif // !DIRECTIONAL
			#endif // !POINT
			#endif // !POINT_COOKIE
			#endif // !SPOT


			// Fallback Shader Code
			#ifndef ANY_SHADER_VARIANT_ACTIVE

			// https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
			float4x4 unity_MatrixMVP;

			struct Vertex_Stage_Input
			{
				float3 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixMVP, float4(input.pos, 1.0));
				return output;
			}

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				// Output solid grey color (e.g., 50% grey)
				return float4(0.5, 0.5, 0.5, 1.0); // RGBA
			}

			#endif // !ANY_SHADER_VARIANT_ACTIVE


			ENDHLSL
		}
		Pass
		{
			Name "ShadowCaster"
			LOD 200
			Tags { "DisableBatching" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry+1" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }

			HLSLPROGRAM

			// https://docs.unity3d.com/Manual/SL-PragmaDirectives.html
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			/*#pragma shader_feature SHADOWS_CUBE
			#pragma shader_feature SHADOWS_DEPTH*/
			#define SHADOWS_CUBE


			#ifdef SHADOWS_DEPTH
			#ifndef SHADOWS_CUBE
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _WorldSpaceLightPos0;
			float4 unity_LightShadowBias;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[1];
			static float4 vertex_uniform_buffer_2[6];
			static float4 vertex_uniform_buffer_3[8];
			static float4 vertex_uniform_buffer_4[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float4 vertex_output_6;
			static float3 vertex_output_7;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_2 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_3 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_4 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_5 : TEXCOORD5; // TEXCOORD_5
				float4 vertex_output_6 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_7 : TEXCOORD7; // TEXCOORD_7
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_71 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[4u].xyz));
				float vertex_unnamed_86 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[5u].xyz));
				float vertex_unnamed_100 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[6u].xyz));
				float vertex_unnamed_107 = rsqrt(dot(float3(vertex_unnamed_71, vertex_unnamed_86, vertex_unnamed_100), float3(vertex_unnamed_71, vertex_unnamed_86, vertex_unnamed_100)));
				float vertex_unnamed_108 = vertex_unnamed_107 * vertex_unnamed_71;
				float vertex_unnamed_109 = vertex_unnamed_107 * vertex_unnamed_86;
				float vertex_unnamed_110 = vertex_unnamed_107 * vertex_unnamed_100;
				float vertex_unnamed_130 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_132 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_133 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_3[2u].x, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].x));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_3[2u].y, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].y));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_3[2u].z, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].z));
				float vertex_unnamed_163 = mad(vertex_uniform_buffer_3[2u].w, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].w, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].w));
				float vertex_unnamed_173 = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_160);
				float vertex_unnamed_174 = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_161);
				float vertex_unnamed_175 = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_162);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[3u].w, vertex_input_0.w, vertex_unnamed_163);
				float vertex_unnamed_189 = mad((-0.0f) - vertex_unnamed_173, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].x);
				float vertex_unnamed_190 = mad((-0.0f) - vertex_unnamed_174, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].y);
				float vertex_unnamed_191 = mad((-0.0f) - vertex_unnamed_175, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].z);
				float vertex_unnamed_195 = rsqrt(dot(float3(vertex_unnamed_189, vertex_unnamed_190, vertex_unnamed_191), float3(vertex_unnamed_189, vertex_unnamed_190, vertex_unnamed_191)));
				float vertex_unnamed_199 = dot(float3(vertex_unnamed_108, vertex_unnamed_109, vertex_unnamed_110), float3(vertex_unnamed_195 * vertex_unnamed_189, vertex_unnamed_195 * vertex_unnamed_190, vertex_unnamed_195 * vertex_unnamed_191));
				float vertex_unnamed_209 = sqrt(mad((-0.0f) - vertex_unnamed_199, vertex_unnamed_199, 1.0f)) * vertex_uniform_buffer_2[5u].z;
				bool vertex_unnamed_220 = vertex_uniform_buffer_2[5u].z != 0.0f;
				float vertex_unnamed_229 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_108, vertex_unnamed_209, vertex_unnamed_173)) : asuint(vertex_unnamed_173));
				float vertex_unnamed_231 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_109, vertex_unnamed_209, vertex_unnamed_174)) : asuint(vertex_unnamed_174));
				float vertex_unnamed_233 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_110, vertex_unnamed_209, vertex_unnamed_175)) : asuint(vertex_unnamed_175));
				float vertex_unnamed_277 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].w)));
				float vertex_unnamed_285 = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].z))) + max(min(vertex_uniform_buffer_2[5u].x / vertex_unnamed_277, 0.0f), -1.0f);
				gl_Position.x = mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].x)));
				gl_Position.y = mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].y)));
				gl_Position.w = vertex_unnamed_277;
				gl_Position.z = mad(vertex_uniform_buffer_2[5u].y, ((-0.0f) - vertex_unnamed_285) + min(vertex_unnamed_277, vertex_unnamed_285), vertex_unnamed_285);
				vertex_output_1.x = vertex_unnamed_130;
				vertex_output_1.y = vertex_unnamed_132;
				vertex_output_1.z = vertex_unnamed_133;
				vertex_output_2.x = vertex_input_1.x;
				vertex_output_2.y = vertex_input_1.y;
				vertex_output_2.z = vertex_input_1.z;
				float vertex_unnamed_313 = rsqrt(dot(float3(vertex_unnamed_130, vertex_unnamed_132, vertex_unnamed_133), float3(vertex_unnamed_130, vertex_unnamed_132, vertex_unnamed_133)));
				float vertex_unnamed_314 = vertex_unnamed_313 * vertex_unnamed_133;
				float vertex_unnamed_315 = vertex_unnamed_313 * vertex_unnamed_130;
				float vertex_unnamed_316 = vertex_unnamed_313 * vertex_unnamed_132;
				float vertex_unnamed_323 = mad(vertex_unnamed_316, 0.0f, (-0.0f) - (vertex_unnamed_314 * 1.0f));
				float vertex_unnamed_325 = mad(vertex_unnamed_315, 1.0f, (-0.0f) - (vertex_unnamed_316 * 0.0f));
				bool vertex_unnamed_330 = sqrt(dot(float2(vertex_unnamed_323, vertex_unnamed_325), float2(vertex_unnamed_323, vertex_unnamed_325))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_337 = asfloat(vertex_unnamed_330 ? 1065353216u : asuint(vertex_unnamed_323));
				float vertex_unnamed_341 = asfloat(vertex_unnamed_330 ? 0u : asuint(vertex_unnamed_325));
				float vertex_unnamed_345 = rsqrt(dot(float2(vertex_unnamed_337, vertex_unnamed_341), float2(vertex_unnamed_337, vertex_unnamed_341)));
				float vertex_unnamed_346 = vertex_unnamed_345 * vertex_unnamed_337;
				float vertex_unnamed_347 = vertex_unnamed_345 * asfloat(vertex_unnamed_330 ? 0u : asuint(mad(vertex_unnamed_314, 0.0f, (-0.0f) - (vertex_unnamed_315 * 0.0f))));
				float vertex_unnamed_348 = vertex_unnamed_345 * vertex_unnamed_341;
				vertex_output_3.x = vertex_unnamed_346;
				vertex_output_3.y = vertex_unnamed_347;
				vertex_output_3.z = vertex_unnamed_348;
				float vertex_unnamed_370 = mad(vertex_input_1.y, vertex_unnamed_348, (-0.0f) - (vertex_unnamed_347 * vertex_input_1.z));
				float vertex_unnamed_371 = mad(vertex_input_1.z, vertex_unnamed_346, (-0.0f) - (vertex_unnamed_348 * vertex_input_1.x));
				float vertex_unnamed_372 = mad(vertex_input_1.x, vertex_unnamed_347, (-0.0f) - (vertex_unnamed_346 * vertex_input_1.y));
				float vertex_unnamed_376 = rsqrt(dot(float3(vertex_unnamed_370, vertex_unnamed_371, vertex_unnamed_372), float3(vertex_unnamed_370, vertex_unnamed_371, vertex_unnamed_372)));
				vertex_output_4.x = vertex_unnamed_376 * vertex_unnamed_370;
				vertex_output_4.y = vertex_unnamed_376 * vertex_unnamed_371;
				vertex_output_4.z = vertex_unnamed_376 * vertex_unnamed_372;
				vertex_output_5.x = vertex_input_3.x;
				vertex_output_5.y = vertex_input_3.y;
				vertex_output_5.z = vertex_input_3.z;
				float vertex_unnamed_398 = vertex_unnamed_160 + vertex_uniform_buffer_3[3u].x;
				float vertex_unnamed_399 = vertex_unnamed_161 + vertex_uniform_buffer_3[3u].y;
				float vertex_unnamed_400 = vertex_unnamed_162 + vertex_uniform_buffer_3[3u].z;
				float vertex_unnamed_401 = vertex_unnamed_163 + vertex_uniform_buffer_3[3u].w;
				vertex_output_7.x = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_160);
				vertex_output_7.y = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_161);
				vertex_output_7.z = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_162);
				float vertex_unnamed_454 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_401, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_400, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_398, vertex_unnamed_399 * vertex_uniform_buffer_4[18u].w)));
				float vertex_unnamed_457 = vertex_unnamed_454 * 0.5f;
				vertex_output_6.z = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_401, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_400, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_398, vertex_unnamed_399 * vertex_uniform_buffer_4[18u].z)));
				vertex_output_6.w = vertex_unnamed_454;
				vertex_output_6.x = vertex_unnamed_457 + (mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_401, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_400, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_398, vertex_unnamed_399 * vertex_uniform_buffer_4[18u].x))) * 0.5f);
				vertex_output_6.y = vertex_unnamed_457 + (mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_401, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_400, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_398, vertex_unnamed_399 * vertex_uniform_buffer_4[18u].y))) * (-0.5f));
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[0] = float4(_WorldSpaceLightPos0[0], _WorldSpaceLightPos0[1], _WorldSpaceLightPos0[2], _WorldSpaceLightPos0[3]);

				vertex_uniform_buffer_2[5] = float4(unity_LightShadowBias[0], unity_LightShadowBias[1], unity_LightShadowBias[2], unity_LightShadowBias[3]);

				vertex_uniform_buffer_3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_3[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_3[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_3[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_3[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_4[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_4[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_4[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_4[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				return stage_output;
			}

			#endif // SHADOWS_DEPTH
			#endif // !SHADOWS_CUBE


			#ifdef SHADOWS_CUBE
			#ifndef SHADOWS_DEPTH
			#define ANY_SHADER_VARIANT_ACTIVE

			float _Global_WhiteMode0;
			float4 _WorldSpaceLightPos0;
			float4 unity_LightShadowBias;
			float4x4 unity_ObjectToWorld;
			float4x4 unity_WorldToObject;
			float4x4 unity_MatrixVP;

			static float4 vertex_uniform_buffer_0[16];
			static float4 vertex_uniform_buffer_1[1];
			static float4 vertex_uniform_buffer_2[6];
			static float4 vertex_uniform_buffer_3[8];
			static float4 vertex_uniform_buffer_4[21];
			static float4 gl_Position;
			static float4 vertex_input_0;
			static float3 vertex_input_1;
			static float4 vertex_input_2;
			static float3 vertex_input_3;
			static float2 vertex_input_4;
			static float2 vertex_input_5;
			static float2 vertex_input_6;
			static float3 vertex_output_1;
			static float3 vertex_output_2;
			static float3 vertex_output_3;
			static float3 vertex_output_4;
			static float3 vertex_output_5;
			static float4 vertex_output_6;
			static float3 vertex_output_7;

			struct Vertex_Stage_Input
			{
				float4 vertex_input_0 : POSITION; // POSITION
				float3 vertex_input_1 : NORMAL; // NORMAL
				float4 vertex_input_2 : TANGENT; // TANGENT
				float3 vertex_input_3 : COLOR; // COLOR
				float2 vertex_input_4 : TEXCOORD; // TEXCOORD
				float2 vertex_input_5 : TEXCOORD1; // TEXCOORD_1
				float2 vertex_input_6 : TEXCOORD2; // TEXCOORD_2
			};

			struct Vertex_Stage_Output
			{
				float3 vertex_output_1 : TEXCOORD1; // TEXCOORD_1
				float3 vertex_output_2 : TEXCOORD2; // TEXCOORD_2
				float3 vertex_output_3 : TEXCOORD3; // TEXCOORD_3
				float3 vertex_output_4 : TEXCOORD4; // TEXCOORD_4
				float3 vertex_output_5 : TEXCOORD5; // TEXCOORD_5
				float4 vertex_output_6 : TEXCOORD6; // TEXCOORD_6
				float3 vertex_output_7 : TEXCOORD7; // TEXCOORD_7
				float4 gl_Position : SV_Position;
			};

			void vert_main()
			{
				float vertex_unnamed_71 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[4u].xyz));
				float vertex_unnamed_86 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[5u].xyz));
				float vertex_unnamed_100 = dot(float3(vertex_input_1.x, vertex_input_1.y, vertex_input_1.z), float3(vertex_uniform_buffer_3[6u].xyz));
				float vertex_unnamed_107 = rsqrt(dot(float3(vertex_unnamed_71, vertex_unnamed_86, vertex_unnamed_100), float3(vertex_unnamed_71, vertex_unnamed_86, vertex_unnamed_100)));
				float vertex_unnamed_108 = vertex_unnamed_107 * vertex_unnamed_71;
				float vertex_unnamed_109 = vertex_unnamed_107 * vertex_unnamed_86;
				float vertex_unnamed_110 = vertex_unnamed_107 * vertex_unnamed_100;
				float vertex_unnamed_130 = mad(vertex_input_0.x * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.x);
				float vertex_unnamed_132 = mad(vertex_input_0.y * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.y);
				float vertex_unnamed_133 = mad(vertex_input_0.z * vertex_uniform_buffer_0[15u].x, -0.000500023365020751953125f, vertex_input_0.z);
				float vertex_unnamed_160 = mad(vertex_uniform_buffer_3[2u].x, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].x, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].x));
				float vertex_unnamed_161 = mad(vertex_uniform_buffer_3[2u].y, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].y, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].y));
				float vertex_unnamed_162 = mad(vertex_uniform_buffer_3[2u].z, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].z, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].z));
				float vertex_unnamed_163 = mad(vertex_uniform_buffer_3[2u].w, vertex_unnamed_133, mad(vertex_uniform_buffer_3[0u].w, vertex_unnamed_130, vertex_unnamed_132 * vertex_uniform_buffer_3[1u].w));
				float vertex_unnamed_173 = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_160);
				float vertex_unnamed_174 = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_161);
				float vertex_unnamed_175 = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_162);
				float vertex_unnamed_176 = mad(vertex_uniform_buffer_3[3u].w, vertex_input_0.w, vertex_unnamed_163);
				float vertex_unnamed_189 = mad((-0.0f) - vertex_unnamed_173, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].x);
				float vertex_unnamed_190 = mad((-0.0f) - vertex_unnamed_174, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].y);
				float vertex_unnamed_191 = mad((-0.0f) - vertex_unnamed_175, vertex_uniform_buffer_1[0u].w, vertex_uniform_buffer_1[0u].z);
				float vertex_unnamed_195 = rsqrt(dot(float3(vertex_unnamed_189, vertex_unnamed_190, vertex_unnamed_191), float3(vertex_unnamed_189, vertex_unnamed_190, vertex_unnamed_191)));
				float vertex_unnamed_199 = dot(float3(vertex_unnamed_108, vertex_unnamed_109, vertex_unnamed_110), float3(vertex_unnamed_195 * vertex_unnamed_189, vertex_unnamed_195 * vertex_unnamed_190, vertex_unnamed_195 * vertex_unnamed_191));
				float vertex_unnamed_209 = sqrt(mad((-0.0f) - vertex_unnamed_199, vertex_unnamed_199, 1.0f)) * vertex_uniform_buffer_2[5u].z;
				bool vertex_unnamed_220 = vertex_uniform_buffer_2[5u].z != 0.0f;
				float vertex_unnamed_229 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_108, vertex_unnamed_209, vertex_unnamed_173)) : asuint(vertex_unnamed_173));
				float vertex_unnamed_231 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_109, vertex_unnamed_209, vertex_unnamed_174)) : asuint(vertex_unnamed_174));
				float vertex_unnamed_233 = asfloat(vertex_unnamed_220 ? asuint(mad((-0.0f) - vertex_unnamed_110, vertex_unnamed_209, vertex_unnamed_175)) : asuint(vertex_unnamed_175));
				float vertex_unnamed_276 = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].z)));
				float vertex_unnamed_277 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].w)));
				gl_Position.z = mad(vertex_uniform_buffer_2[5u].y, ((-0.0f) - vertex_unnamed_276) + min(vertex_unnamed_277, vertex_unnamed_276), vertex_unnamed_276);
				gl_Position.x = mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].x)));
				gl_Position.y = mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_176, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_233, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_229, vertex_unnamed_231 * vertex_uniform_buffer_4[18u].y)));
				gl_Position.w = vertex_unnamed_277;
				vertex_output_1.x = vertex_unnamed_130;
				vertex_output_1.y = vertex_unnamed_132;
				vertex_output_1.z = vertex_unnamed_133;
				vertex_output_2.x = vertex_input_1.x;
				vertex_output_2.y = vertex_input_1.y;
				vertex_output_2.z = vertex_input_1.z;
				float vertex_unnamed_305 = rsqrt(dot(float3(vertex_unnamed_130, vertex_unnamed_132, vertex_unnamed_133), float3(vertex_unnamed_130, vertex_unnamed_132, vertex_unnamed_133)));
				float vertex_unnamed_306 = vertex_unnamed_305 * vertex_unnamed_133;
				float vertex_unnamed_307 = vertex_unnamed_305 * vertex_unnamed_130;
				float vertex_unnamed_308 = vertex_unnamed_305 * vertex_unnamed_132;
				float vertex_unnamed_315 = mad(vertex_unnamed_308, 0.0f, (-0.0f) - (vertex_unnamed_306 * 1.0f));
				float vertex_unnamed_317 = mad(vertex_unnamed_307, 1.0f, (-0.0f) - (vertex_unnamed_308 * 0.0f));
				bool vertex_unnamed_322 = sqrt(dot(float2(vertex_unnamed_315, vertex_unnamed_317), float2(vertex_unnamed_315, vertex_unnamed_317))) < 9.9999999392252902907785028219223e-09f;
				float vertex_unnamed_329 = asfloat(vertex_unnamed_322 ? 1065353216u : asuint(vertex_unnamed_315));
				float vertex_unnamed_333 = asfloat(vertex_unnamed_322 ? 0u : asuint(vertex_unnamed_317));
				float vertex_unnamed_337 = rsqrt(dot(float2(vertex_unnamed_329, vertex_unnamed_333), float2(vertex_unnamed_329, vertex_unnamed_333)));
				float vertex_unnamed_338 = vertex_unnamed_337 * vertex_unnamed_329;
				float vertex_unnamed_339 = vertex_unnamed_337 * asfloat(vertex_unnamed_322 ? 0u : asuint(mad(vertex_unnamed_306, 0.0f, (-0.0f) - (vertex_unnamed_307 * 0.0f))));
				float vertex_unnamed_340 = vertex_unnamed_337 * vertex_unnamed_333;
				vertex_output_3.x = vertex_unnamed_338;
				vertex_output_3.y = vertex_unnamed_339;
				vertex_output_3.z = vertex_unnamed_340;
				float vertex_unnamed_362 = mad(vertex_input_1.y, vertex_unnamed_340, (-0.0f) - (vertex_unnamed_339 * vertex_input_1.z));
				float vertex_unnamed_363 = mad(vertex_input_1.z, vertex_unnamed_338, (-0.0f) - (vertex_unnamed_340 * vertex_input_1.x));
				float vertex_unnamed_364 = mad(vertex_input_1.x, vertex_unnamed_339, (-0.0f) - (vertex_unnamed_338 * vertex_input_1.y));
				float vertex_unnamed_368 = rsqrt(dot(float3(vertex_unnamed_362, vertex_unnamed_363, vertex_unnamed_364), float3(vertex_unnamed_362, vertex_unnamed_363, vertex_unnamed_364)));
				vertex_output_4.x = vertex_unnamed_368 * vertex_unnamed_362;
				vertex_output_4.y = vertex_unnamed_368 * vertex_unnamed_363;
				vertex_output_4.z = vertex_unnamed_368 * vertex_unnamed_364;
				vertex_output_5.x = vertex_input_3.x;
				vertex_output_5.y = vertex_input_3.y;
				vertex_output_5.z = vertex_input_3.z;
				float vertex_unnamed_390 = vertex_unnamed_160 + vertex_uniform_buffer_3[3u].x;
				float vertex_unnamed_391 = vertex_unnamed_161 + vertex_uniform_buffer_3[3u].y;
				float vertex_unnamed_392 = vertex_unnamed_162 + vertex_uniform_buffer_3[3u].z;
				float vertex_unnamed_393 = vertex_unnamed_163 + vertex_uniform_buffer_3[3u].w;
				vertex_output_7.x = mad(vertex_uniform_buffer_3[3u].x, vertex_input_0.w, vertex_unnamed_160);
				vertex_output_7.y = mad(vertex_uniform_buffer_3[3u].y, vertex_input_0.w, vertex_unnamed_161);
				vertex_output_7.z = mad(vertex_uniform_buffer_3[3u].z, vertex_input_0.w, vertex_unnamed_162);
				float vertex_unnamed_446 = mad(vertex_uniform_buffer_4[20u].w, vertex_unnamed_393, mad(vertex_uniform_buffer_4[19u].w, vertex_unnamed_392, mad(vertex_uniform_buffer_4[17u].w, vertex_unnamed_390, vertex_unnamed_391 * vertex_uniform_buffer_4[18u].w)));
				float vertex_unnamed_449 = vertex_unnamed_446 * 0.5f;
				vertex_output_6.z = mad(vertex_uniform_buffer_4[20u].z, vertex_unnamed_393, mad(vertex_uniform_buffer_4[19u].z, vertex_unnamed_392, mad(vertex_uniform_buffer_4[17u].z, vertex_unnamed_390, vertex_unnamed_391 * vertex_uniform_buffer_4[18u].z)));
				vertex_output_6.w = vertex_unnamed_446;
				vertex_output_6.x = vertex_unnamed_449 + (mad(vertex_uniform_buffer_4[20u].x, vertex_unnamed_393, mad(vertex_uniform_buffer_4[19u].x, vertex_unnamed_392, mad(vertex_uniform_buffer_4[17u].x, vertex_unnamed_390, vertex_unnamed_391 * vertex_uniform_buffer_4[18u].x))) * 0.5f);
				vertex_output_6.y = vertex_unnamed_449 + (mad(vertex_uniform_buffer_4[20u].y, vertex_unnamed_393, mad(vertex_uniform_buffer_4[19u].y, vertex_unnamed_392, mad(vertex_uniform_buffer_4[17u].y, vertex_unnamed_390, vertex_unnamed_391 * vertex_uniform_buffer_4[18u].y))) * (-0.5f));
			}

			Vertex_Stage_Output vert(Vertex_Stage_Input stage_input)
			{
				vertex_uniform_buffer_0[15] = float4(_Global_WhiteMode0, vertex_uniform_buffer_0[15][1], vertex_uniform_buffer_0[15][2], vertex_uniform_buffer_0[15][3]);

				vertex_uniform_buffer_1[0] = float4(_WorldSpaceLightPos0[0], _WorldSpaceLightPos0[1], _WorldSpaceLightPos0[2], _WorldSpaceLightPos0[3]);

				vertex_uniform_buffer_2[5] = float4(unity_LightShadowBias[0], unity_LightShadowBias[1], unity_LightShadowBias[2], unity_LightShadowBias[3]);

				vertex_uniform_buffer_3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
				vertex_uniform_buffer_3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
				vertex_uniform_buffer_3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
				vertex_uniform_buffer_3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);

				vertex_uniform_buffer_3[4] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
				vertex_uniform_buffer_3[5] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
				vertex_uniform_buffer_3[6] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
				vertex_uniform_buffer_3[7] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);

				vertex_uniform_buffer_4[17] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
				vertex_uniform_buffer_4[18] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
				vertex_uniform_buffer_4[19] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
				vertex_uniform_buffer_4[20] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);

				vertex_input_0 = stage_input.vertex_input_0;
				vertex_input_1 = stage_input.vertex_input_1;
				vertex_input_2 = stage_input.vertex_input_2;
				vertex_input_3 = stage_input.vertex_input_3;
				vertex_input_4 = stage_input.vertex_input_4;
				vertex_input_5 = stage_input.vertex_input_5;
				vertex_input_6 = stage_input.vertex_input_6;
				vert_main();
				Vertex_Stage_Output stage_output;
				stage_output.gl_Position = gl_Position;
				stage_output.vertex_output_1 = vertex_output_1;
				stage_output.vertex_output_2 = vertex_output_2;
				stage_output.vertex_output_3 = vertex_output_3;
				stage_output.vertex_output_4 = vertex_output_4;
				stage_output.vertex_output_5 = vertex_output_5;
				stage_output.vertex_output_6 = vertex_output_6;
				stage_output.vertex_output_7 = vertex_output_7;
				return stage_output;
			}

			#endif // SHADOWS_CUBE
			#endif // !SHADOWS_DEPTH


			#ifdef SHADOWS_DEPTH
			#ifndef SHADOWS_CUBE
			#define ANY_SHADER_VARIANT_ACTIVE

			float _MaterialIndex;
			float _LatitudeCount;

			static float4 fragment_uniform_buffer_0[15];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float4 fragment_input_6;
			static float3 fragment_input_7;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_2 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_3 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_4 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_5 : TEXCOORD5; // TEXCOORD_5
				float4 fragment_input_6 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_7 : TEXCOORD7; // TEXCOORD_7
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_644)
			{
				if (fragment_unnamed_644)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_52 = rsqrt(dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z)));
				float fragment_unnamed_59 = fragment_unnamed_52 * fragment_input_1.y;
				float fragment_unnamed_60 = fragment_unnamed_52 * fragment_input_1.x;
				float fragment_unnamed_61 = fragment_unnamed_52 * fragment_input_1.z;
				uint fragment_unnamed_70 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_76 = sqrt(((-0.0f) - abs(fragment_unnamed_59)) + 1.0f);
				float fragment_unnamed_85 = mad(mad(mad(abs(fragment_unnamed_59), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_59), -0.212114393711090087890625f), abs(fragment_unnamed_59), 1.570728778839111328125f);
				float fragment_unnamed_110 = (1.0f / max(abs(fragment_unnamed_61), abs(fragment_unnamed_60))) * min(abs(fragment_unnamed_61), abs(fragment_unnamed_60));
				float fragment_unnamed_111 = fragment_unnamed_110 * fragment_unnamed_110;
				float fragment_unnamed_119 = mad(fragment_unnamed_111, mad(fragment_unnamed_111, mad(fragment_unnamed_111, mad(fragment_unnamed_111, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_137 = asfloat(((((-0.0f) - fragment_unnamed_61) < fragment_unnamed_61) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_110, fragment_unnamed_119, asfloat(((abs(fragment_unnamed_61) < abs(fragment_unnamed_60)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_119 * fragment_unnamed_110, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_139 = min((-0.0f) - fragment_unnamed_61, fragment_unnamed_60);
				float fragment_unnamed_141 = max((-0.0f) - fragment_unnamed_61, fragment_unnamed_60);
				float fragment_unnamed_155 = (((-0.0f) - mad(fragment_unnamed_85, fragment_unnamed_76, asfloat(((fragment_unnamed_59 < ((-0.0f) - fragment_unnamed_59)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_76 * fragment_unnamed_85, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_156 = fragment_unnamed_155 * 0.3183098733425140380859375f;
				bool fragment_unnamed_158 = 0.0f < fragment_unnamed_155;
				float fragment_unnamed_165 = asfloat(fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_156)) : asuint(floor(fragment_unnamed_156)));
				float fragment_unnamed_170 = float(fragment_unnamed_70);
				uint fragment_unnamed_177 = uint(asfloat((0.0f < fragment_unnamed_165) ? asuint(fragment_unnamed_165 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_165) + fragment_unnamed_170) + (-0.89999997615814208984375f))));
				int fragment_unnamed_180 = _OffsetsBuffer.Load(fragment_unnamed_177);
				float fragment_unnamed_187 = float((-fragment_unnamed_180) + _OffsetsBuffer.Load(fragment_unnamed_177 + 1u));
				uint fragment_unnamed_188 = asuint(fragment_unnamed_187);
				float fragment_unnamed_189 = mad(((((fragment_unnamed_141 >= ((-0.0f) - fragment_unnamed_141)) ? 4294967295u : 0u) & ((fragment_unnamed_139 < ((-0.0f) - fragment_unnamed_139)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_137) : fragment_unnamed_137, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_191 = fragment_unnamed_187 * fragment_unnamed_189;
				bool fragment_unnamed_192 = 0.0f < fragment_unnamed_191;
				uint fragment_unnamed_197 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_191)) : asuint(floor(fragment_unnamed_191));
				float fragment_unnamed_198 = mad(fragment_unnamed_187, 0.5f, 0.5f);
				float fragment_unnamed_217 = float(fragment_unnamed_180 + uint(asfloat((fragment_unnamed_198 < asfloat(fragment_unnamed_197)) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, asfloat(fragment_unnamed_197)) + (-1.0f)) : asuint(fragment_unnamed_187 + ((-0.0f) - asfloat(fragment_unnamed_197)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_220 = frac(fragment_unnamed_217);
				uint fragment_unnamed_223 = _DataBuffer.Load(uint(floor(fragment_unnamed_217)));
				uint fragment_unnamed_235 = 16u & 31u;
				uint fragment_unnamed_242 = 8u & 31u;
				float fragment_unnamed_253 = float(((0.625f < fragment_unnamed_220) ? (fragment_unnamed_223 >> 24u) : ((0.375f < fragment_unnamed_220) ? spvBitfieldUExtract(fragment_unnamed_223, fragment_unnamed_235, min((8u & 31u), (32u - fragment_unnamed_235))) : ((0.125f < fragment_unnamed_220) ? spvBitfieldUExtract(fragment_unnamed_223, fragment_unnamed_242, min((8u & 31u), (32u - fragment_unnamed_242))) : (fragment_unnamed_223 & 255u)))) >> 5u);
				uint fragment_unnamed_257 = (6.5f < fragment_unnamed_253) ? 0u : asuint(fragment_unnamed_253);
				float fragment_unnamed_264 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(asfloat(fragment_unnamed_257) < (fragment_unnamed_264 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_264 + 3.9900000095367431640625f) < asfloat(fragment_unnamed_257));
				float fragment_unnamed_281 = mad(fragment_unnamed_155, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_282 = mad(fragment_unnamed_155, 0.3183098733425140380859375f, -0.5f);
				uint fragment_unnamed_292 = fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_281)) : asuint(floor(fragment_unnamed_281));
				uint fragment_unnamed_293 = fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_282)) : asuint(floor(fragment_unnamed_282));
				uint fragment_unnamed_318 = uint(asfloat((0.0f < asfloat(fragment_unnamed_292)) ? asuint(asfloat(fragment_unnamed_292) + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_170 + ((-0.0f) - asfloat(fragment_unnamed_292))) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_319 = uint(asfloat((0.0f < asfloat(fragment_unnamed_293)) ? asuint(asfloat(fragment_unnamed_293) + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_170 + ((-0.0f) - asfloat(fragment_unnamed_293))) + (-0.89999997615814208984375f))));
				int fragment_unnamed_321 = _OffsetsBuffer.Load(fragment_unnamed_318);
				int fragment_unnamed_323 = _OffsetsBuffer.Load(fragment_unnamed_319);
				uint fragment_unnamed_325 = (fragment_unnamed_177 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_328 = (fragment_unnamed_177 != (fragment_unnamed_70 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_331 = (fragment_unnamed_70 != fragment_unnamed_177) ? 4294967295u : 0u;
				uint fragment_unnamed_335 = (fragment_unnamed_177 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_353 = (fragment_unnamed_335 & (fragment_unnamed_331 & (fragment_unnamed_325 & fragment_unnamed_328))) != 0u;
				uint fragment_unnamed_354 = fragment_unnamed_353 ? asuint(float((-fragment_unnamed_321) + _OffsetsBuffer.Load(fragment_unnamed_318 + 1u))) : fragment_unnamed_188;
				uint fragment_unnamed_355 = fragment_unnamed_353 ? asuint(float((-fragment_unnamed_323) + _OffsetsBuffer.Load(fragment_unnamed_319 + 1u))) : fragment_unnamed_188;
				float fragment_unnamed_358 = fragment_unnamed_189 * asfloat(fragment_unnamed_354);
				float fragment_unnamed_359 = fragment_unnamed_189 * asfloat(fragment_unnamed_355);
				float fragment_unnamed_360 = mad(fragment_unnamed_189, fragment_unnamed_187, 0.5f);
				float fragment_unnamed_361 = mad(fragment_unnamed_189, fragment_unnamed_187, -0.5f);
				float fragment_unnamed_369 = asfloat((fragment_unnamed_187 < fragment_unnamed_360) ? asuint(((-0.0f) - fragment_unnamed_187) + fragment_unnamed_360) : asuint(fragment_unnamed_360));
				uint fragment_unnamed_373 = (fragment_unnamed_361 < 0.0f) ? asuint(fragment_unnamed_187 + fragment_unnamed_361) : asuint(fragment_unnamed_361);
				uint fragment_unnamed_382 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_358)) : asuint(floor(fragment_unnamed_358));
				uint fragment_unnamed_383 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_359)) : asuint(floor(fragment_unnamed_359));
				float fragment_unnamed_389 = asfloat(fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_369)) : asuint(floor(fragment_unnamed_369)));
				uint fragment_unnamed_396 = fragment_unnamed_192 ? asuint(ceil(asfloat(fragment_unnamed_373))) : asuint(floor(asfloat(fragment_unnamed_373)));
				float fragment_unnamed_397 = frac(fragment_unnamed_156);
				float fragment_unnamed_398 = frac(fragment_unnamed_191);
				float fragment_unnamed_479 = float(fragment_unnamed_321 + uint(asfloat((mad(asfloat(fragment_unnamed_354), 0.5f, 0.5f) < asfloat(fragment_unnamed_382)) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_354), 0.5f, asfloat(fragment_unnamed_382)) + (-1.0f)) : asuint(asfloat(fragment_unnamed_354) + ((-0.0f) - asfloat(fragment_unnamed_382)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_481 = frac(fragment_unnamed_479);
				uint fragment_unnamed_484 = _DataBuffer.Load(uint(floor(fragment_unnamed_479)));
				uint fragment_unnamed_490 = 16u & 31u;
				uint fragment_unnamed_495 = 8u & 31u;
				float fragment_unnamed_505 = float(fragment_unnamed_323 + uint(asfloat((mad(asfloat(fragment_unnamed_355), 0.5f, 0.5f) < asfloat(fragment_unnamed_383)) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_355), 0.5f, asfloat(fragment_unnamed_383)) + (-1.0f)) : asuint(asfloat(fragment_unnamed_355) + ((-0.0f) - asfloat(fragment_unnamed_383)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_507 = frac(fragment_unnamed_505);
				uint fragment_unnamed_510 = _DataBuffer.Load(uint(floor(fragment_unnamed_505)));
				uint fragment_unnamed_516 = 16u & 31u;
				uint fragment_unnamed_521 = 8u & 31u;
				float fragment_unnamed_531 = float(uint(asfloat((fragment_unnamed_198 < fragment_unnamed_389) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, fragment_unnamed_389) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_389) + fragment_unnamed_187)) + 0.100000001490116119384765625f) + fragment_unnamed_180) * 0.25f;
				float fragment_unnamed_533 = frac(fragment_unnamed_531);
				uint fragment_unnamed_536 = _DataBuffer.Load(uint(floor(fragment_unnamed_531)));
				uint fragment_unnamed_542 = 16u & 31u;
				uint fragment_unnamed_547 = 8u & 31u;
				float fragment_unnamed_557 = float(uint(asfloat((fragment_unnamed_198 < asfloat(fragment_unnamed_396)) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, asfloat(fragment_unnamed_396)) + (-1.0f)) : asuint(fragment_unnamed_187 + ((-0.0f) - asfloat(fragment_unnamed_396)))) + 0.100000001490116119384765625f) + fragment_unnamed_180) * 0.25f;
				float fragment_unnamed_559 = frac(fragment_unnamed_557);
				uint fragment_unnamed_562 = _DataBuffer.Load(uint(floor(fragment_unnamed_557)));
				uint fragment_unnamed_568 = 16u & 31u;
				uint fragment_unnamed_573 = 8u & 31u;
				float fragment_unnamed_583 = float(((0.625f < fragment_unnamed_481) ? (fragment_unnamed_484 >> 24u) : ((0.375f < fragment_unnamed_481) ? spvBitfieldUExtract(fragment_unnamed_484, fragment_unnamed_490, min((8u & 31u), (32u - fragment_unnamed_490))) : ((0.125f < fragment_unnamed_481) ? spvBitfieldUExtract(fragment_unnamed_484, fragment_unnamed_495, min((8u & 31u), (32u - fragment_unnamed_495))) : (fragment_unnamed_484 & 255u)))) >> 5u);
				float fragment_unnamed_584 = float(((0.625f < fragment_unnamed_533) ? (fragment_unnamed_536 >> 24u) : ((0.375f < fragment_unnamed_533) ? spvBitfieldUExtract(fragment_unnamed_536, fragment_unnamed_542, min((8u & 31u), (32u - fragment_unnamed_542))) : ((0.125f < fragment_unnamed_533) ? spvBitfieldUExtract(fragment_unnamed_536, fragment_unnamed_547, min((8u & 31u), (32u - fragment_unnamed_547))) : (fragment_unnamed_536 & 255u)))) >> 5u);
				float fragment_unnamed_587 = float(((0.625f < fragment_unnamed_507) ? (fragment_unnamed_510 >> 24u) : ((0.375f < fragment_unnamed_507) ? spvBitfieldUExtract(fragment_unnamed_510, fragment_unnamed_516, min((8u & 31u), (32u - fragment_unnamed_516))) : ((0.125f < fragment_unnamed_507) ? spvBitfieldUExtract(fragment_unnamed_510, fragment_unnamed_521, min((8u & 31u), (32u - fragment_unnamed_521))) : (fragment_unnamed_510 & 255u)))) >> 5u);
				float fragment_unnamed_588 = float(((0.625f < fragment_unnamed_559) ? (fragment_unnamed_562 >> 24u) : ((0.375f < fragment_unnamed_559) ? spvBitfieldUExtract(fragment_unnamed_562, fragment_unnamed_568, min((8u & 31u), (32u - fragment_unnamed_568))) : ((0.125f < fragment_unnamed_559) ? spvBitfieldUExtract(fragment_unnamed_562, fragment_unnamed_573, min((8u & 31u), (32u - fragment_unnamed_573))) : (fragment_unnamed_562 & 255u)))) >> 5u);
				uint fragment_unnamed_606 = ((fragment_unnamed_328 & (fragment_unnamed_331 & (((fragment_unnamed_583 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_583) ? 4294967295u : 0u)))) != 0u) ? asuint(min((((-0.0f) - fragment_unnamed_397) + 1.0f) * 40.0f, 1.0f)) : 1065353216u;
				uint fragment_unnamed_617 = ((fragment_unnamed_335 & (fragment_unnamed_325 & (((fragment_unnamed_587 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_587) ? 4294967295u : 0u)))) != 0u) ? asuint(min(fragment_unnamed_397 * 40.0f, 1.0f) * asfloat(fragment_unnamed_606)) : fragment_unnamed_606;
				uint fragment_unnamed_623 = ((((fragment_unnamed_584 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_584) ? 4294967295u : 0u)) != 0u) ? asuint(min((((-0.0f) - fragment_unnamed_398) + 1.0f) * 40.0f, 1.0f) * asfloat(fragment_unnamed_617)) : fragment_unnamed_617;
				discard_cond((asfloat(((((fragment_unnamed_588 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_588) ? 4294967295u : 0u)) != 0u) ? asuint(min(fragment_unnamed_398 * 40.0f, 1.0f) * asfloat(fragment_unnamed_623)) : fragment_unnamed_623) + (-0.00999999977648258209228515625f)) < 0.0f);
				fragment_output_0.x = 0.0f;
				fragment_output_0.y = 0.0f;
				fragment_output_0.z = 0.0f;
				fragment_output_0.w = 0.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // SHADOWS_DEPTH
			#endif // !SHADOWS_CUBE


			#ifdef SHADOWS_CUBE
			#ifndef SHADOWS_DEPTH
			#define ANY_SHADER_VARIANT_ACTIVE

			float _MaterialIndex;
			float _LatitudeCount;

			static float4 fragment_uniform_buffer_0[15];
			StructuredBuffer<int> _OffsetsBuffer;
			StructuredBuffer<uint> _DataBuffer;

			static float3 fragment_input_1;
			static float3 fragment_input_2;
			static float3 fragment_input_3;
			static float3 fragment_input_4;
			static float3 fragment_input_5;
			static float4 fragment_input_6;
			static float3 fragment_input_7;
			static float4 fragment_output_0;

			struct Fragment_Stage_Input
			{
				float3 fragment_input_1 : TEXCOORD1; // TEXCOORD_1
				float3 fragment_input_2 : TEXCOORD2; // TEXCOORD_2
				float3 fragment_input_3 : TEXCOORD3; // TEXCOORD_3
				float3 fragment_input_4 : TEXCOORD4; // TEXCOORD_4
				float3 fragment_input_5 : TEXCOORD5; // TEXCOORD_5
				float4 fragment_input_6 : TEXCOORD6; // TEXCOORD_6
				float3 fragment_input_7 : TEXCOORD7; // TEXCOORD_7
			};

			struct Fragment_Stage_Output
			{
				float4 fragment_output_0 : SV_Target0;
			};

			static bool discard_state;

			uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
			{
				uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
				return (Base >> Offset) & Mask;
			}

			int spvBitfieldSExtract(int Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int2 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int3 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
			{
				int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
				int4 Masked = (Base >> Offset) & Mask;
				int ExtendShift = (32 - Count) & 31;
				return (Masked << ExtendShift) >> ExtendShift;
			}

			void discard_cond(bool fragment_unnamed_644)
			{
				if (fragment_unnamed_644)
				{
					discard_state = true;
				}
			}

			void discard_exit()
			{
				if (discard_state)
				{
					discard;
				}
			}

			void frag_main()
			{
				discard_state = false;
				float fragment_unnamed_52 = rsqrt(dot(float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z), float3(fragment_input_1.x, fragment_input_1.y, fragment_input_1.z)));
				float fragment_unnamed_59 = fragment_unnamed_52 * fragment_input_1.y;
				float fragment_unnamed_60 = fragment_unnamed_52 * fragment_input_1.x;
				float fragment_unnamed_61 = fragment_unnamed_52 * fragment_input_1.z;
				uint fragment_unnamed_70 = uint(mad(fragment_uniform_buffer_0[14u].x, 0.5f, 0.100000001490116119384765625f));
				float fragment_unnamed_76 = sqrt(((-0.0f) - abs(fragment_unnamed_59)) + 1.0f);
				float fragment_unnamed_85 = mad(mad(mad(abs(fragment_unnamed_59), -0.0187292993068695068359375f, 0.074261002242565155029296875f), abs(fragment_unnamed_59), -0.212114393711090087890625f), abs(fragment_unnamed_59), 1.570728778839111328125f);
				float fragment_unnamed_110 = (1.0f / max(abs(fragment_unnamed_61), abs(fragment_unnamed_60))) * min(abs(fragment_unnamed_61), abs(fragment_unnamed_60));
				float fragment_unnamed_111 = fragment_unnamed_110 * fragment_unnamed_110;
				float fragment_unnamed_119 = mad(fragment_unnamed_111, mad(fragment_unnamed_111, mad(fragment_unnamed_111, mad(fragment_unnamed_111, 0.02083509974181652069091796875f, -0.08513300120830535888671875f), 0.1801410019397735595703125f), -0.33029949665069580078125f), 0.999866008758544921875f);
				float fragment_unnamed_137 = asfloat(((((-0.0f) - fragment_unnamed_61) < fragment_unnamed_61) ? 4294967295u : 0u) & 3226013659u) + mad(fragment_unnamed_110, fragment_unnamed_119, asfloat(((abs(fragment_unnamed_61) < abs(fragment_unnamed_60)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_119 * fragment_unnamed_110, -2.0f, 1.57079637050628662109375f))));
				float fragment_unnamed_139 = min((-0.0f) - fragment_unnamed_61, fragment_unnamed_60);
				float fragment_unnamed_141 = max((-0.0f) - fragment_unnamed_61, fragment_unnamed_60);
				float fragment_unnamed_155 = (((-0.0f) - mad(fragment_unnamed_85, fragment_unnamed_76, asfloat(((fragment_unnamed_59 < ((-0.0f) - fragment_unnamed_59)) ? 4294967295u : 0u) & asuint(mad(fragment_unnamed_76 * fragment_unnamed_85, -2.0f, 3.1415927410125732421875f))))) + 1.57079637050628662109375f) * fragment_uniform_buffer_0[14u].x;
				float fragment_unnamed_156 = fragment_unnamed_155 * 0.3183098733425140380859375f;
				bool fragment_unnamed_158 = 0.0f < fragment_unnamed_155;
				float fragment_unnamed_165 = asfloat(fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_156)) : asuint(floor(fragment_unnamed_156)));
				float fragment_unnamed_170 = float(fragment_unnamed_70);
				uint fragment_unnamed_177 = uint(asfloat((0.0f < fragment_unnamed_165) ? asuint(fragment_unnamed_165 + (-0.89999997615814208984375f)) : asuint((((-0.0f) - fragment_unnamed_165) + fragment_unnamed_170) + (-0.89999997615814208984375f))));
				int fragment_unnamed_180 = _OffsetsBuffer.Load(fragment_unnamed_177);
				float fragment_unnamed_187 = float((-fragment_unnamed_180) + _OffsetsBuffer.Load(fragment_unnamed_177 + 1u));
				uint fragment_unnamed_188 = asuint(fragment_unnamed_187);
				float fragment_unnamed_189 = mad(((((fragment_unnamed_141 >= ((-0.0f) - fragment_unnamed_141)) ? 4294967295u : 0u) & ((fragment_unnamed_139 < ((-0.0f) - fragment_unnamed_139)) ? 4294967295u : 0u)) != 0u) ? ((-0.0f) - fragment_unnamed_137) : fragment_unnamed_137, 0.15915493667125701904296875f, 0.5f);
				float fragment_unnamed_191 = fragment_unnamed_187 * fragment_unnamed_189;
				bool fragment_unnamed_192 = 0.0f < fragment_unnamed_191;
				uint fragment_unnamed_197 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_191)) : asuint(floor(fragment_unnamed_191));
				float fragment_unnamed_198 = mad(fragment_unnamed_187, 0.5f, 0.5f);
				float fragment_unnamed_217 = float(fragment_unnamed_180 + uint(asfloat((fragment_unnamed_198 < asfloat(fragment_unnamed_197)) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, asfloat(fragment_unnamed_197)) + (-1.0f)) : asuint(fragment_unnamed_187 + ((-0.0f) - asfloat(fragment_unnamed_197)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_220 = frac(fragment_unnamed_217);
				uint fragment_unnamed_223 = _DataBuffer.Load(uint(floor(fragment_unnamed_217)));
				uint fragment_unnamed_235 = 16u & 31u;
				uint fragment_unnamed_242 = 8u & 31u;
				float fragment_unnamed_253 = float(((0.625f < fragment_unnamed_220) ? (fragment_unnamed_223 >> 24u) : ((0.375f < fragment_unnamed_220) ? spvBitfieldUExtract(fragment_unnamed_223, fragment_unnamed_235, min((8u & 31u), (32u - fragment_unnamed_235))) : ((0.125f < fragment_unnamed_220) ? spvBitfieldUExtract(fragment_unnamed_223, fragment_unnamed_242, min((8u & 31u), (32u - fragment_unnamed_242))) : (fragment_unnamed_223 & 255u)))) >> 5u);
				uint fragment_unnamed_257 = (6.5f < fragment_unnamed_253) ? 0u : asuint(fragment_unnamed_253);
				float fragment_unnamed_264 = round(fragment_uniform_buffer_0[11u].y * 3.0f);
				discard_cond(asfloat(fragment_unnamed_257) < (fragment_unnamed_264 + 0.00999999977648258209228515625f));
				discard_cond((fragment_unnamed_264 + 3.9900000095367431640625f) < asfloat(fragment_unnamed_257));
				float fragment_unnamed_281 = mad(fragment_unnamed_155, 0.3183098733425140380859375f, 0.5f);
				float fragment_unnamed_282 = mad(fragment_unnamed_155, 0.3183098733425140380859375f, -0.5f);
				uint fragment_unnamed_292 = fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_281)) : asuint(floor(fragment_unnamed_281));
				uint fragment_unnamed_293 = fragment_unnamed_158 ? asuint(ceil(fragment_unnamed_282)) : asuint(floor(fragment_unnamed_282));
				uint fragment_unnamed_318 = uint(asfloat((0.0f < asfloat(fragment_unnamed_292)) ? asuint(asfloat(fragment_unnamed_292) + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_170 + ((-0.0f) - asfloat(fragment_unnamed_292))) + (-0.89999997615814208984375f))));
				uint fragment_unnamed_319 = uint(asfloat((0.0f < asfloat(fragment_unnamed_293)) ? asuint(asfloat(fragment_unnamed_293) + (-0.89999997615814208984375f)) : asuint((fragment_unnamed_170 + ((-0.0f) - asfloat(fragment_unnamed_293))) + (-0.89999997615814208984375f))));
				int fragment_unnamed_321 = _OffsetsBuffer.Load(fragment_unnamed_318);
				int fragment_unnamed_323 = _OffsetsBuffer.Load(fragment_unnamed_319);
				uint fragment_unnamed_325 = (fragment_unnamed_177 != 0u) ? 4294967295u : 0u;
				uint fragment_unnamed_328 = (fragment_unnamed_177 != (fragment_unnamed_70 + 4294967295u)) ? 4294967295u : 0u;
				uint fragment_unnamed_331 = (fragment_unnamed_70 != fragment_unnamed_177) ? 4294967295u : 0u;
				uint fragment_unnamed_335 = (fragment_unnamed_177 != (uint(fragment_uniform_buffer_0[14u].x + 0.100000001490116119384765625f) + 4294967295u)) ? 4294967295u : 0u;
				bool fragment_unnamed_353 = (fragment_unnamed_335 & (fragment_unnamed_331 & (fragment_unnamed_325 & fragment_unnamed_328))) != 0u;
				uint fragment_unnamed_354 = fragment_unnamed_353 ? asuint(float((-fragment_unnamed_321) + _OffsetsBuffer.Load(fragment_unnamed_318 + 1u))) : fragment_unnamed_188;
				uint fragment_unnamed_355 = fragment_unnamed_353 ? asuint(float((-fragment_unnamed_323) + _OffsetsBuffer.Load(fragment_unnamed_319 + 1u))) : fragment_unnamed_188;
				float fragment_unnamed_358 = fragment_unnamed_189 * asfloat(fragment_unnamed_354);
				float fragment_unnamed_359 = fragment_unnamed_189 * asfloat(fragment_unnamed_355);
				float fragment_unnamed_360 = mad(fragment_unnamed_189, fragment_unnamed_187, 0.5f);
				float fragment_unnamed_361 = mad(fragment_unnamed_189, fragment_unnamed_187, -0.5f);
				float fragment_unnamed_369 = asfloat((fragment_unnamed_187 < fragment_unnamed_360) ? asuint(((-0.0f) - fragment_unnamed_187) + fragment_unnamed_360) : asuint(fragment_unnamed_360));
				uint fragment_unnamed_373 = (fragment_unnamed_361 < 0.0f) ? asuint(fragment_unnamed_187 + fragment_unnamed_361) : asuint(fragment_unnamed_361);
				uint fragment_unnamed_382 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_358)) : asuint(floor(fragment_unnamed_358));
				uint fragment_unnamed_383 = fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_359)) : asuint(floor(fragment_unnamed_359));
				float fragment_unnamed_389 = asfloat(fragment_unnamed_192 ? asuint(ceil(fragment_unnamed_369)) : asuint(floor(fragment_unnamed_369)));
				uint fragment_unnamed_396 = fragment_unnamed_192 ? asuint(ceil(asfloat(fragment_unnamed_373))) : asuint(floor(asfloat(fragment_unnamed_373)));
				float fragment_unnamed_397 = frac(fragment_unnamed_156);
				float fragment_unnamed_398 = frac(fragment_unnamed_191);
				float fragment_unnamed_479 = float(fragment_unnamed_321 + uint(asfloat((mad(asfloat(fragment_unnamed_354), 0.5f, 0.5f) < asfloat(fragment_unnamed_382)) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_354), 0.5f, asfloat(fragment_unnamed_382)) + (-1.0f)) : asuint(asfloat(fragment_unnamed_354) + ((-0.0f) - asfloat(fragment_unnamed_382)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_481 = frac(fragment_unnamed_479);
				uint fragment_unnamed_484 = _DataBuffer.Load(uint(floor(fragment_unnamed_479)));
				uint fragment_unnamed_490 = 16u & 31u;
				uint fragment_unnamed_495 = 8u & 31u;
				float fragment_unnamed_505 = float(fragment_unnamed_323 + uint(asfloat((mad(asfloat(fragment_unnamed_355), 0.5f, 0.5f) < asfloat(fragment_unnamed_383)) ? asuint(mad((-0.0f) - asfloat(fragment_unnamed_355), 0.5f, asfloat(fragment_unnamed_383)) + (-1.0f)) : asuint(asfloat(fragment_unnamed_355) + ((-0.0f) - asfloat(fragment_unnamed_383)))) + 0.100000001490116119384765625f)) * 0.25f;
				float fragment_unnamed_507 = frac(fragment_unnamed_505);
				uint fragment_unnamed_510 = _DataBuffer.Load(uint(floor(fragment_unnamed_505)));
				uint fragment_unnamed_516 = 16u & 31u;
				uint fragment_unnamed_521 = 8u & 31u;
				float fragment_unnamed_531 = float(uint(asfloat((fragment_unnamed_198 < fragment_unnamed_389) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, fragment_unnamed_389) + (-1.0f)) : asuint(((-0.0f) - fragment_unnamed_389) + fragment_unnamed_187)) + 0.100000001490116119384765625f) + fragment_unnamed_180) * 0.25f;
				float fragment_unnamed_533 = frac(fragment_unnamed_531);
				uint fragment_unnamed_536 = _DataBuffer.Load(uint(floor(fragment_unnamed_531)));
				uint fragment_unnamed_542 = 16u & 31u;
				uint fragment_unnamed_547 = 8u & 31u;
				float fragment_unnamed_557 = float(uint(asfloat((fragment_unnamed_198 < asfloat(fragment_unnamed_396)) ? asuint(mad((-0.0f) - fragment_unnamed_187, 0.5f, asfloat(fragment_unnamed_396)) + (-1.0f)) : asuint(fragment_unnamed_187 + ((-0.0f) - asfloat(fragment_unnamed_396)))) + 0.100000001490116119384765625f) + fragment_unnamed_180) * 0.25f;
				float fragment_unnamed_559 = frac(fragment_unnamed_557);
				uint fragment_unnamed_562 = _DataBuffer.Load(uint(floor(fragment_unnamed_557)));
				uint fragment_unnamed_568 = 16u & 31u;
				uint fragment_unnamed_573 = 8u & 31u;
				float fragment_unnamed_583 = float(((0.625f < fragment_unnamed_481) ? (fragment_unnamed_484 >> 24u) : ((0.375f < fragment_unnamed_481) ? spvBitfieldUExtract(fragment_unnamed_484, fragment_unnamed_490, min((8u & 31u), (32u - fragment_unnamed_490))) : ((0.125f < fragment_unnamed_481) ? spvBitfieldUExtract(fragment_unnamed_484, fragment_unnamed_495, min((8u & 31u), (32u - fragment_unnamed_495))) : (fragment_unnamed_484 & 255u)))) >> 5u);
				float fragment_unnamed_584 = float(((0.625f < fragment_unnamed_533) ? (fragment_unnamed_536 >> 24u) : ((0.375f < fragment_unnamed_533) ? spvBitfieldUExtract(fragment_unnamed_536, fragment_unnamed_542, min((8u & 31u), (32u - fragment_unnamed_542))) : ((0.125f < fragment_unnamed_533) ? spvBitfieldUExtract(fragment_unnamed_536, fragment_unnamed_547, min((8u & 31u), (32u - fragment_unnamed_547))) : (fragment_unnamed_536 & 255u)))) >> 5u);
				float fragment_unnamed_587 = float(((0.625f < fragment_unnamed_507) ? (fragment_unnamed_510 >> 24u) : ((0.375f < fragment_unnamed_507) ? spvBitfieldUExtract(fragment_unnamed_510, fragment_unnamed_516, min((8u & 31u), (32u - fragment_unnamed_516))) : ((0.125f < fragment_unnamed_507) ? spvBitfieldUExtract(fragment_unnamed_510, fragment_unnamed_521, min((8u & 31u), (32u - fragment_unnamed_521))) : (fragment_unnamed_510 & 255u)))) >> 5u);
				float fragment_unnamed_588 = float(((0.625f < fragment_unnamed_559) ? (fragment_unnamed_562 >> 24u) : ((0.375f < fragment_unnamed_559) ? spvBitfieldUExtract(fragment_unnamed_562, fragment_unnamed_568, min((8u & 31u), (32u - fragment_unnamed_568))) : ((0.125f < fragment_unnamed_559) ? spvBitfieldUExtract(fragment_unnamed_562, fragment_unnamed_573, min((8u & 31u), (32u - fragment_unnamed_573))) : (fragment_unnamed_562 & 255u)))) >> 5u);
				uint fragment_unnamed_606 = ((fragment_unnamed_328 & (fragment_unnamed_331 & (((fragment_unnamed_583 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_583) ? 4294967295u : 0u)))) != 0u) ? asuint(min((((-0.0f) - fragment_unnamed_397) + 1.0f) * 40.0f, 1.0f)) : 1065353216u;
				uint fragment_unnamed_617 = ((fragment_unnamed_335 & (fragment_unnamed_325 & (((fragment_unnamed_587 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_587) ? 4294967295u : 0u)))) != 0u) ? asuint(min(fragment_unnamed_397 * 40.0f, 1.0f) * asfloat(fragment_unnamed_606)) : fragment_unnamed_606;
				uint fragment_unnamed_623 = ((((fragment_unnamed_584 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_584) ? 4294967295u : 0u)) != 0u) ? asuint(min((((-0.0f) - fragment_unnamed_398) + 1.0f) * 40.0f, 1.0f) * asfloat(fragment_unnamed_617)) : fragment_unnamed_617;
				discard_cond((asfloat(((((fragment_unnamed_588 < 0.00999999977648258209228515625f) ? 4294967295u : 0u) | ((6.5f < fragment_unnamed_588) ? 4294967295u : 0u)) != 0u) ? asuint(min(fragment_unnamed_398 * 40.0f, 1.0f) * asfloat(fragment_unnamed_623)) : fragment_unnamed_623) + (-0.00999999977648258209228515625f)) < 0.0f);
				fragment_output_0.x = 0.0f;
				fragment_output_0.y = 0.0f;
				fragment_output_0.z = 0.0f;
				fragment_output_0.w = 0.0f;
				discard_exit();
			}

			Fragment_Stage_Output frag(Fragment_Stage_Input stage_input)
			{
				fragment_uniform_buffer_0[11] = float4(fragment_uniform_buffer_0[11][0], _MaterialIndex, fragment_uniform_buffer_0[11][2], fragment_uniform_buffer_0[11][3]);

				fragment_uniform_buffer_0[14] = float4(_LatitudeCount, fragment_uniform_buffer_0[14][1], fragment_uniform_buffer_0[14][2], fragment_uniform_buffer_0[14][3]);

				fragment_input_1 = stage_input.fragment_input_1;
				fragment_input_2 = stage_input.fragment_input_2;
				fragment_input_3 = stage_input.fragment_input_3;
				fragment_input_4 = stage_input.fragment_input_4;
				fragment_input_5 = stage_input.fragment_input_5;
				fragment_input_6 = stage_input.fragment_input_6;
				fragment_input_7 = stage_input.fragment_input_7;
				frag_main();
				Fragment_Stage_Output stage_output;
				stage_output.fragment_output_0 = fragment_output_0;
				return stage_output;
			}

			#endif // SHADOWS_CUBE
			#endif // !SHADOWS_DEPTH


			// Fallback Shader Code
			#ifndef ANY_SHADER_VARIANT_ACTIVE

			// https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
			float4x4 unity_MatrixMVP;

			struct Vertex_Stage_Input
			{
				float3 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixMVP, float4(input.pos, 1.0));
				return output;
			}

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				// Output solid grey color (e.g., 50% grey)
				return float4(0.5, 0.5, 0.5, 1.0); // RGBA
			}

			#endif // !ANY_SHADER_VARIANT_ACTIVE


			ENDHLSL
		}
	}
	FallBack "Diffuse"
}
