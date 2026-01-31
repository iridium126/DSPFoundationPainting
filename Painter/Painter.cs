using BepInEx;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Rendering;

namespace DSPBasePainter
{
	[BepInPlugin("Iridium126.Plugins.DSPBasePainter", "DSPBasePainter", "1.0.0")]
	public class Painter : BaseUnityPlugin
	{
		private static Shader shader_patch, reformMat0_shader, reformMat1_shader;
		private static Texture2D painting_tex;
		private void Start()
		{
			AssetBundle assetBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.shaders"));
			shader_patch = assetBundle.LoadAsset<Shader>("VF Shaders_Forward_Terrain Reform");
			Debug.Log($"shader_patch.isSupported:{shader_patch.isSupported}");
			/*ShaderVariantCollection svc = assetBundle.LoadAsset<ShaderVariantCollection>("ShaderVariants");
			svc.WarmUp();*/
			painting_tex = new Texture2D(4096, 5088, TextureFormat.RGBA32, false);
			bool load_success =  painting_tex.LoadImage(File.ReadAllBytes("D:/test_texture.png"));
			Debug.Log($"load_success:{load_success}");
		}
		private void Update()
		{
			if (Input.GetKeyDown(KeyCode.Alpha1))
			{
				Material reformMat0 = GameMain.localPlanet.reformMaterial0;
				Material reformMat1 = GameMain.localPlanet.reformMaterial1;

				/*Debug.Log($"reformMat0.shaderKeywords:{string.Join(",", reformMat0.shaderKeywords)}");
				Debug.Log($"reformMat1.shaderKeywords:{string.Join(",", reformMat1.shaderKeywords)}");

				Debug.Log($"reformMat0.enabledKeywords:{string.Join(",", reformMat0.enabledKeywords)}");
				Debug.Log($"reformMat1.enabledKeywords:{string.Join(",", reformMat1.enabledKeywords)}");

				Debug.Log($"reformMat0.IsKeywordEnabled DIRECTIONAL{reformMat0.IsKeywordEnabled("DIRECTIONAL")}");
				Debug.Log($"reformMat1.IsKeywordEnabled DIRECTIONAL{reformMat1.IsKeywordEnabled("DIRECTIONAL")}");
				Debug.Log($"reformMat0.IsKeywordEnabled LIGHTPROBE_SH{reformMat0.IsKeywordEnabled("LIGHTPROBE_SH")}");
				Debug.Log($"reformMat1.IsKeywordEnabled LIGHTPROBE_SH{reformMat1.IsKeywordEnabled("LIGHTPROBE_SH")}");
				Debug.Log($"reformMat0.IsKeywordEnabled SHADOWS_SCREEN{reformMat0.IsKeywordEnabled("SHADOWS_SCREEN")}");
				Debug.Log($"reformMat1.IsKeywordEnabled SHADOWS_SCREEN{reformMat1.IsKeywordEnabled("SHADOWS_SCREEN")}");
				Debug.Log($"reformMat0.IsKeywordEnabled VERTEXLIGHT_ON{reformMat0.IsKeywordEnabled("VERTEXLIGHT_ON")}");
				Debug.Log($"reformMat1.IsKeywordEnabled VERTEXLIGHT_ON{reformMat1.IsKeywordEnabled("VERTEXLIGHT_ON")}");
				reformMat0.shader.keywordSpace.keywords.ToList().ForEach(k => Debug.Log($"reformMat0 keyword:{k.name}"));
				reformMat1.shader.keywordSpace.keywords.ToList().ForEach(k => Debug.Log($"reformMat1 keyword:{k.name}"));
				reformMat0.shaderKeywords.ToList().ForEach(k => Debug.Log($"reformMat0 shaderKeyword:{k}"));
				reformMat1.shaderKeywords.ToList().ForEach(k => Debug.Log($"reformMat1 shaderKeyword:{k}"));

				float latitudeCount = reformMat0.GetFloat("_LatitudeCount");
				Vector3 sunDir = reformMat0.GetVector("_SunDir");
				float magnitude = reformMat0.GetFloat("_Distance");
				Vector3 rotation = reformMat0.GetVector("_Rotation");
				Texture2D reformColorsTex = reformMat0.GetTexture("_ColorsTexture") as Texture2D;
				Texture2D albedoTex1 = reformMat0.GetTexture("_AlbedoTex1") as Texture2D;
				Texture2D normalTex1 = reformMat0.GetTexture("_NormalTex1") as Texture2D;
				Texture2D emissionTex1 = reformMat0.GetTexture("_EmissionTex1") as Texture2D;
				Texture2D albedoTex2 = reformMat0.GetTexture("_AlbedoTex2") as Texture2D;
				Texture2D normalTex2 = reformMat0.GetTexture("_NormalTex2") as Texture2D;
				Texture2D emissionTex2 = reformMat0.GetTexture("_EmissionTex2") as Texture2D;
				Texture2D albedoTex3 = reformMat0.GetTexture("_AlbedoTex3") as Texture2D;
				Texture2D normalTex3 = reformMat0.GetTexture("_NormalTex3") as Texture2D;
				Texture2D emissionTex3 = reformMat0.GetTexture("_EmissionTex3") as Texture2D;*/
				if (reformMat0_shader == null)
					reformMat0_shader = reformMat0.shader;
				reformMat0.shader = shader_patch;
				/*reformMat0.SetFloat("_LatitudeCount", latitudeCount);
				reformMat0.SetVector("_SunDir", sunDir);
				reformMat0.SetFloat("_Distance", magnitude);
				reformMat0.SetVector("_Rotation", rotation);
				reformMat0.SetTexture("_ColorsTexture", reformColorsTex);
				reformMat0.SetTexture("_AlbedoTex1", albedoTex1);
				reformMat0.SetTexture("_NormalTex1", normalTex1);
				reformMat0.SetTexture("_EmissionTex1", emissionTex1);
				reformMat0.SetTexture("_AlbedoTex2", albedoTex2);
				reformMat0.SetTexture("_NormalTex2", normalTex2);
				reformMat0.SetTexture("_EmissionTex2", emissionTex2);
				reformMat0.SetTexture("_AlbedoTex3", albedoTex3);
				reformMat0.SetTexture("_NormalTex3", normalTex3);
				reformMat0.SetTexture("_EmissionTex3", emissionTex3);

				latitudeCount = reformMat1.GetFloat("_LatitudeCount");
				sunDir = reformMat1.GetVector("_SunDir");
				magnitude = reformMat1.GetFloat("_Distance");
				rotation = reformMat1.GetVector("_Rotation");
				reformColorsTex = reformMat1.GetTexture("_ColorsTexture") as Texture2D;
				albedoTex1 = reformMat1.GetTexture("_AlbedoTex1") as Texture2D;
				normalTex1 = reformMat1.GetTexture("_NormalTex1") as Texture2D;
				emissionTex1 = reformMat1.GetTexture("_EmissionTex1") as Texture2D;
				albedoTex2 = reformMat1.GetTexture("_AlbedoTex2") as Texture2D;
				normalTex2 = reformMat1.GetTexture("_NormalTex2") as Texture2D;
				emissionTex2 = reformMat1.GetTexture("_EmissionTex2") as Texture2D;
				albedoTex3 = reformMat1.GetTexture("_AlbedoTex3") as Texture2D;
				normalTex3 = reformMat1.GetTexture("_NormalTex3") as Texture2D;
				emissionTex3 = reformMat1.GetTexture("_EmissionTex3") as Texture2D;*/
				if (reformMat1_shader == null)
					reformMat1_shader = reformMat1.shader;
				reformMat1.shader = shader_patch;
				/*reformMat1.SetFloat("_LatitudeCount", latitudeCount);
				reformMat1.SetVector("_SunDir", sunDir);
				reformMat1.SetFloat("_Distance", magnitude);
				reformMat1.SetVector("_Rotation", rotation);
				reformMat1.SetTexture("_ColorsTexture", reformColorsTex);
				reformMat1.SetTexture("_AlbedoTex1", albedoTex1);
				reformMat1.SetTexture("_NormalTex1", normalTex1);
				reformMat1.SetTexture("_EmissionTex1", emissionTex1);
				reformMat1.SetTexture("_AlbedoTex2", albedoTex2);
				reformMat1.SetTexture("_NormalTex2", normalTex2);
				reformMat1.SetTexture("_EmissionTex2", emissionTex2);
				reformMat1.SetTexture("_AlbedoTex3", albedoTex3);
				reformMat1.SetTexture("_NormalTex3", normalTex3);
				reformMat1.SetTexture("_EmissionTex3", emissionTex3);*/

				PlatformSystem platformSystem = GameMain.localPlanet.factory.platformSystem;
				ComputeBuffer reformOffsetsBuffer = platformSystem.reformOffsetsBuffer;
				ComputeBuffer reformDataBuffer = platformSystem.reformDataBuffer;
				if (platformSystem.reformData != null && reformDataBuffer != null)
				{
					reformOffsetsBuffer.SetData(platformSystem.reformOffsets);
					reformDataBuffer.SetData(platformSystem.reformData);
					reformMat0.SetBuffer("_OffsetsBuffer", reformOffsetsBuffer);
					reformMat0.SetBuffer("_DataBuffer", reformDataBuffer);
					reformMat1.SetBuffer("_OffsetsBuffer", reformOffsetsBuffer);
					reformMat1.SetBuffer("_DataBuffer", reformDataBuffer);
				}
				reformMat0.SetTexture("_PaintingTexture", painting_tex);
				reformMat1.SetTexture("_PaintingTexture", painting_tex);

				//reformMat0.EnableKeyword("DIRECTIONAL");
				//reformMat1.EnableKeyword("DIRECTIONAL");


				/*Debug.Log($"reformMat0.shaderKeywords:{string.Join(",", reformMat0.shaderKeywords)}");
				Debug.Log($"reformMat1.shaderKeywords:{string.Join(",", reformMat1.shaderKeywords)}");

				Debug.Log($"reformMat0.enabledKeywords:{string.Join(",", reformMat0.enabledKeywords)}");
				Debug.Log($"reformMat1.enabledKeywords:{string.Join(",", reformMat1.enabledKeywords)}");

				Debug.Log($"reformMat0.IsKeywordEnabled DIRECTIONAL{reformMat0.IsKeywordEnabled("DIRECTIONAL")}");
				Debug.Log($"reformMat1.IsKeywordEnabled DIRECTIONAL{reformMat1.IsKeywordEnabled("DIRECTIONAL")}");
				Debug.Log($"reformMat0.IsKeywordEnabled LIGHTPROBE_SH{reformMat0.IsKeywordEnabled("LIGHTPROBE_SH")}");
				Debug.Log($"reformMat1.IsKeywordEnabled LIGHTPROBE_SH{reformMat1.IsKeywordEnabled("LIGHTPROBE_SH")}");
				Debug.Log($"reformMat0.IsKeywordEnabled SHADOWS_SCREEN{reformMat0.IsKeywordEnabled("SHADOWS_SCREEN")}");
				Debug.Log($"reformMat1.IsKeywordEnabled SHADOWS_SCREEN{reformMat1.IsKeywordEnabled("SHADOWS_SCREEN")}");
				Debug.Log($"reformMat0.IsKeywordEnabled VERTEXLIGHT_ON{reformMat0.IsKeywordEnabled("VERTEXLIGHT_ON")}");
				Debug.Log($"reformMat1.IsKeywordEnabled VERTEXLIGHT_ON{reformMat1.IsKeywordEnabled("VERTEXLIGHT_ON")}");
				reformMat0.shader.keywordSpace.keywords.ToList().ForEach(k => Debug.Log($"reformMat0 keyword:{k.name}"));
				reformMat1.shader.keywordSpace.keywords.ToList().ForEach(k => Debug.Log($"reformMat1 keyword:{k.name}"));
				reformMat0.shaderKeywords.ToList().ForEach(k => Debug.Log($"reformMat0 shaderKeyword:{k}"));
				reformMat1.shaderKeywords.ToList().ForEach(k => Debug.Log($"reformMat1 shaderKeyword:{k}"));*/
			}
			if (Input.GetKeyDown(KeyCode.Alpha0))
			{
				Material reformMat0 = GameMain.localPlanet.reformMaterial0;
				Material reformMat1 = GameMain.localPlanet.reformMaterial1;

				if (reformMat0_shader != null && reformMat1_shader != null)
				{
					reformMat0.shader = reformMat0_shader;
					reformMat1.shader = reformMat1_shader;
				}

				/*Debug.Log($"reformMat0.shaderKeywords:{string.Join(",", reformMat0.shaderKeywords)}");
				Debug.Log($"reformMat1.shaderKeywords:{string.Join(",", reformMat1.shaderKeywords)}");

				Debug.Log($"reformMat0.enabledKeywords:{string.Join(",", reformMat0.enabledKeywords)}");
				Debug.Log($"reformMat1.enabledKeywords:{string.Join(",", reformMat1.enabledKeywords)}");*/
			}
			if (Input.GetKeyDown(KeyCode.Alpha2))
			{
				Debug.Log($"reform index:{GameMain.mainPlayer.controller.actionBuild.reformTool.cursorIndices[0]}");
			}
		}
	}
}
