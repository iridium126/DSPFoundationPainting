using BepInEx;
using HarmonyLib;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Reflection.Emit;
using UnityEngine;
using UnityEngine.UI;

namespace DSPBasePainter
{
	[BepInPlugin("Iridium126.Plugins.DSPBasePainter", "DSPBasePainter", "1.0.0")]
	public class Painter : BaseUnityPlugin
	{
		private static Shader shaderPatch;
		private static UIButton paintButton;
		private void Start()
		{
			Harmony.CreateAndPatchAll(typeof(Painter));
			AssetBundle assetBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.shaders"));
			shaderPatch = assetBundle.LoadAsset<Shader>("VF Shaders_Forward_Terrain Reform");
			//Debug.Log($"shader_patch.isSupported:{shaderPatch.isSupported}");
			/*ShaderVariantCollection svc = assetBundle.LoadAsset<ShaderVariantCollection>("ShaderVariants");
			svc.WarmUp();*/
			StartCoroutine(PaintButtonInit());
		}
		public static void PaintButtonSetActive(bool value)
		{
			paintButton.gameObject.SetActive(value);
		}
		private IEnumerator PaintButtonInit()
		{
			var reformAllRectTransform = GameObject.Find("UI Root/Overlay Canvas/In Game/Function Panel/Build Menu/reform-group/button-reform-all").GetComponent<RectTransform>();
			var paintRectTransform = Instantiate<RectTransform>(reformAllRectTransform, reformAllRectTransform.parent);
			Vector3 localPosition = reformAllRectTransform.localPosition;
			localPosition.x -= 104f;
			paintRectTransform.localPosition = localPosition;
			Sprite icon = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.icon")).LoadAsset<Sprite>("icon");
			paintRectTransform.Find("icon").GetComponent<Image>().sprite = icon;
			Destroy(paintRectTransform.GetComponent<Button>());
			yield return null;
			paintButton = paintRectTransform.GetComponent<UIButton>();
			paintButton.button = paintRectTransform.gameObject.AddComponent<Button>();
			paintButton.button.onClick.AddListener(() => { StartCoroutine(Painting()); });
			paintButton.tips.tipTitle = "一键铺设像素画";
			paintButton.tips.tipText = "一键在当前星球上铺设<color=\"#92E4FFC0\">像素画</color>，\r\n需要<color=\"#92E4FFC0\">大量地基</color>和<color=\"#92E4FFC0\">大量沙土</color>！";
		}
		private IEnumerator Painting()
		{
			Texture2D paintingTex = new Texture2D(4096, 5088, TextureFormat.RGBA32, false);
			bool load_success = paintingTex.LoadImage(File.ReadAllBytes("D:/test_texture.png"));
			//Debug.Log($"load_success:{load_success}");
			Material reformMat0 = GameMain.localPlanet.reformMaterial0;
			Material reformMat1 = GameMain.localPlanet.reformMaterial1;
			reformMat0.shader = shaderPatch;
			reformMat1.shader = shaderPatch;
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
			reformMat0.SetTexture("_PaintingTexture", paintingTex);
			reformMat1.SetTexture("_PaintingTexture", paintingTex);

			yield return null;
		}
		[HarmonyTranspiler, HarmonyPatch(typeof(UIBuildMenu), "_OnUpdate")]
		private static IEnumerable<CodeInstruction> OnUpdate_Patch(IEnumerable<CodeInstruction> instructions)
		{
			return new CodeMatcher(instructions)
				.MatchForward(true,
					new CodeMatch(OpCodes.Ldarg_0),
					new CodeMatch(OpCodes.Ldfld, AccessTools.Field(typeof(UIBuildMenu), "reformRevertButton")),
					new CodeMatch(OpCodes.Callvirt, AccessTools.PropertyGetter(typeof(Component), "gameObject")),
					new CodeMatch(OpCodes.Call, AccessTools.PropertyGetter(typeof(GameMain), "sandboxToolsEnabled")),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(GameObject), "SetActive")))
				.InsertAndAdvance(
					new CodeInstruction(OpCodes.Ldc_I4_1),
					new CodeInstruction(OpCodes.Call, AccessTools.Method(typeof(Painter), "PaintButtonSetActive")))
				.MatchForward(true,
					new CodeMatch(OpCodes.Ldarg_0),
					new CodeMatch(OpCodes.Ldfld, AccessTools.Field(typeof(UIBuildMenu), "reformRevertButton")),
					new CodeMatch(OpCodes.Callvirt, AccessTools.PropertyGetter(typeof(Component), "gameObject")),
					new CodeMatch(OpCodes.Ldc_I4_0),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(GameObject), "SetActive")))
				.InsertAndAdvance(
					new CodeInstruction(OpCodes.Ldc_I4_0),
					new CodeInstruction(OpCodes.Call, AccessTools.Method(typeof(Painter), "PaintButtonSetActive")))
				.InstructionEnumeration();
		}
	}
}
