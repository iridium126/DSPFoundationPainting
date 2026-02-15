using BepInEx;
using HarmonyLib;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.InteropServices;
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
			AssetBundle shadersBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.shaders"));
			shaderPatch = shadersBundle.LoadAsset<Shader>("VF Shaders_Forward_Terrain Reform");
			shadersBundle.Unload(false);
			//Debug.Log($"shader_patch.isSupported:{shaderPatch.isSupported}");
			/*ShaderVariantCollection svc = assetBundle.LoadAsset<ShaderVariantCollection>("ShaderVariants");
			svc.WarmUp();*/
			StartCoroutine(InitPaintButton());
		}
		private IEnumerator InitPaintButton()
		{
			var reform0RectTransform = GameObject.Find("UI Root/Overlay Canvas/In Game/Function Panel/Build Menu/reform-group/button-reform-0").GetComponent<RectTransform>();
			var paintRectTransform = Instantiate<RectTransform>(reform0RectTransform, reform0RectTransform.parent);
			Vector3 localPosition = reform0RectTransform.localPosition;
			localPosition.x -= 370f;
			paintRectTransform.localPosition = localPosition;
			AssetBundle iconBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.icon"));
			Sprite icon = iconBundle.LoadAsset<Sprite>("icon");
			iconBundle.Unload(false);
			paintRectTransform.Find("icon").GetComponent<Image>().sprite = icon;
			if (paintRectTransform.TryGetComponent<Button>(out var oldButton))
			{
				oldButton.onClick.RemoveAllListeners();
				Destroy(oldButton);
			}
			yield return null; // 等待一帧，确保旧的Button组件被销毁
			paintButton = paintRectTransform.GetComponent<UIButton>();
			paintButton.button = paintRectTransform.gameObject.AddComponent<Button>();
			paintButton.button.onClick.AddListener(() => { StartCoroutine(Painting()); });
			paintButton.tips.tipTitle = "一键铺设像素画";
			paintButton.tips.tipText = "一键在当前星球上铺设<color=\"#92E4FFC0\">像素画</color>，\r\n需要<color=\"#92E4FFC0\">大量地基</color>和<color=\"#92E4FFC0\">大量沙土</color>！";
		}
		private IEnumerator Painting()
		{
			FileDialog.OpenFileName ofn = new FileDialog.OpenFileName();
			ofn.structSize = Marshal.SizeOf(ofn);
			ofn.filter = "纹理文件(*.png)\0*.png\0"; // 只显示Calculator生成的纹理文件
			ofn.filterIndex = 2;
			ofn.file = new string(new char[256]);
			ofn.maxFile = ofn.file.Length;
			ofn.fileTitle = new string(new char[64]);
			ofn.maxFileTitle = ofn.fileTitle.Length;
			ofn.initialDir = Application.dataPath;
			ofn.title = "选择纹理文件";
			ofn.defExt = "png";
			ofn.flags = 0x00080000 | 0x00001000 | 0x00000800 | 0x00000008; // OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR
			ofn.dlgOwner = FileDialog.GetForegroundWindow(); // 设置对话框的父窗口为当前活动窗口
			if (!FileDialog.GetOpenFileName(ofn))
				yield break;
			Texture2D paintingTex = new Texture2D(4096, 5088, TextureFormat.RGBA32, false);
			bool load_success = paintingTex.LoadImage(File.ReadAllBytes(ofn.file));
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
		public static void PaintButtonSetActive(bool value)
		{
			paintButton.gameObject.SetActive(value);
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

	// 调用Windows API打开文件对话框
	public static class FileDialog
	{
		[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
		public class OpenFileName
		{
			public int structSize = 0;
			public IntPtr dlgOwner = IntPtr.Zero;
			public IntPtr instance = IntPtr.Zero;
			public String filter = null;
			public String customFilter = null;
			public int maxCustFilter = 0;
			public int filterIndex = 0;
			public String file = null;
			public int maxFile = 0;
			public String fileTitle = null;
			public int maxFileTitle = 0;
			public String initialDir = null; // default path
			public String title = null;
			public int flags = 0;
			public short fileOffset = 0;
			public short fileExtension = 0;
			public String defExt = null; // default file extension
			public IntPtr custData = IntPtr.Zero;
			public IntPtr hook = IntPtr.Zero;
			public String templateName = null;
			public IntPtr reservedPtr = IntPtr.Zero;
			public int reservedInt = 0;
			public int flagsEx = 0;
		}

		[DllImport("user32.dll")]
		public static extern IntPtr GetForegroundWindow();

		[DllImport("Comdlg32.dll", SetLastError = true, ThrowOnUnmappableChar = true, CharSet = CharSet.Auto)]
		public static extern bool GetOpenFileName([In, Out] OpenFileName ofn);
	}
}
