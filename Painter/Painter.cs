using BepInEx;
using HarmonyLib;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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
		private const int maxPlanetCount = 6;
		private static readonly Texture2D[] paintingTexs = new Texture2D[maxPlanetCount];
		private const string GameSave_CurrentGame = "_currentgame_";
		private static string textureSaveFolder;
		private void Start()
		{
			Harmony.CreateAndPatchAll(typeof(Painter));
			AssetBundle shadersBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("DSPBasePainter.shaders"));
			shaderPatch = shadersBundle.LoadAsset<Shader>("VF Shaders_Forward_Terrain Reform");
			shadersBundle.Unload(false);
			//Debug.Log($"shader_patch.isSupported:{shaderPatch.isSupported}");
			/*ShaderVariantCollection svc = assetBundle.LoadAsset<ShaderVariantCollection>("ShaderVariants");
			svc.WarmUp();*/
			for (int i = 0; i < maxPlanetCount; ++i)
				paintingTexs[i] = new Texture2D(4096, 5088, TextureFormat.RGBA32, false);
			textureSaveFolder = Config.ConfigFilePath.Substring(0, Config.ConfigFilePath.LastIndexOf('.')) + "/";
			StartCoroutine(InitPaintButton());
		}
		private IEnumerator InitPaintButton()
		{
			var reform0RectTransform = GameObject.Find("UI Root/Overlay Canvas/In Game/Function Panel/Build Menu/reform-group/button-reform-0").GetComponent<RectTransform>();
			var paintRectTransform = Instantiate<RectTransform>(reform0RectTransform, reform0RectTransform.parent);
			Vector3 localPosition = reform0RectTransform.localPosition;
			localPosition.x -= 358f;
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
			byte[] pngBytes = File.ReadAllBytes(ofn.file);
			if (pngBytes == null || pngBytes.Length < 8)
				yield break;
			byte[] pngSignature = new byte[8];
			Array.Copy(pngBytes, 0, pngSignature, 0, 8);
			if (!pngSignature.SequenceEqual(new byte[] { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A }))
				yield break;
			// 遍历PNG块（从第8字节开始）
			long position = 8;
			byte[] chunkName = { (byte)'f', (byte)'m', (byte)'s', (byte)'k' };
			byte[] chunkData = null;
			while (position + 12 <= pngBytes.Length) // 块最小长度：4(长度)+4(块名)+0(数据)+4(CRC)=12
			{
				// 读取块数据长度（4字节，大端序）
				byte[] lengthBytes = new byte[4];
				Array.Copy(pngBytes, position, lengthBytes, 0, 4);
				position += 4;
				uint chunkDataLength = (uint)((lengthBytes[0] << 24) | (lengthBytes[1] << 16) | (lengthBytes[2] << 8) | lengthBytes[3]);
				// 读取块名（4字节）
				byte[] currentChunkName = new byte[4];
				Array.Copy(pngBytes, position, currentChunkName, 0, 4);
				position += 4;
				// 匹配目标块名
				if (currentChunkName.SequenceEqual(chunkName))
				{
					// 读取块数据（跳过CRC）
					chunkData = new byte[chunkDataLength];
					Array.Copy(pngBytes, position, chunkData, 0, chunkDataLength);
					break;
				}
				else // 跳过当前块的数据和CRC
					position += chunkDataLength + 4;
			}
			if (chunkData == null || chunkData.Length != 40700)
				yield break;
			PlanetData localPlanet = GameMain.localPlanet;
			if (!paintingTexs[localPlanet.index].LoadImage(pngBytes))
				yield break;
			yield return null;
			PlayerAction_Build actionBuild = GameMain.mainPlayer.controller.actionBuild;
			BuildTool_BlueprintPaste buildTool_BlueprintPaste = actionBuild.blueprintPasteTool;
			buildTool_BlueprintPaste.planet = actionBuild.planet;
			buildTool_BlueprintPaste.factory = actionBuild.factory;
			if (buildTool_BlueprintPaste.tmpPackage == null)
				buildTool_BlueprintPaste.tmpPackage = new StorageComponent(GameMain.mainPlayer.package.size);
			if (buildTool_BlueprintPaste.tmpPackage.size != GameMain.mainPlayer.package.size)
				buildTool_BlueprintPaste.tmpPackage.SetSize(GameMain.mainPlayer.package.size);
			Array.Copy(GameMain.mainPlayer.package.grids, buildTool_BlueprintPaste.tmpPackage.grids, buildTool_BlueprintPaste.tmpPackage.size);
			buildTool_BlueprintPaste.tmpInhandId = GameMain.mainPlayer.inhandItemId;
			buildTool_BlueprintPaste.tmpInhandCount = GameMain.mainPlayer.inhandItemCount;

			buildTool_BlueprintPaste.latitudeCount = PlanetGrid.DetermineLongitudeSegmentCount(0, buildTool_BlueprintPaste.segment) * 5 / 2;
			if (buildTool_BlueprintPaste.reformGridIds == null)
				buildTool_BlueprintPaste.reformGridIds = new HashSet<int>();
			if (buildTool_BlueprintPaste.tmpModLevel == null)
				buildTool_BlueprintPaste.tmpModLevel = new Dictionary<int, int>();
			// 解包地基掩码并生成reformGridIds
			PlatformSystem platformSystem = localPlanet.factory.platformSystem;
			for (int byteIndex = 0, x = 0, y = 0; byteIndex < 40700; ++byteIndex)
			{
				int startIndex = byteIndex * 8;
				int endIndex = startIndex + 8;
				for (int index = startIndex; index < endIndex; ++index)
					if ((chunkData[byteIndex] & (1 << (index - startIndex))) != 0)
					{
						while (y < 500)
						{
							x = index - platformSystem.reformOffsets[y];
							if (0 <= x && x < platformSystem.reformOffsets[y + 1] - platformSystem.reformOffsets[y])
								break;
							y++;
						}
						buildTool_BlueprintPaste.reformGridIds.Add(x << 16 | y);
					}
			}
			BuildTool_Reform buildTool_Reform = actionBuild.reformTool;
			buildTool_Reform.brushType = 7;
			buildTool_Reform.buryVeins = true;
			buildTool_BlueprintPaste.result = EBlueprintPasteResult.BuildingNeedReform | (EBlueprintPasteResult)8;
			if (!buildTool_BlueprintPaste.DetermineReforms())
				yield break;
			yield return null;
			Material reformMat0 = localPlanet.reformMaterial0;
			Material reformMat1 = localPlanet.reformMaterial1;
			if (reformMat0.shader != shaderPatch || reformMat1.shader != shaderPatch)
			{
				reformMat0.shader = shaderPatch;
				reformMat1.shader = shaderPatch;
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
			}
			reformMat0.SetTexture("_PaintingTexture", paintingTexs[localPlanet.index]);
			reformMat1.SetTexture("_PaintingTexture", paintingTexs[localPlanet.index]);
			//Debug.Log($"receiveShadows : {GameMain.universeSimulator.FindPlanetSimulator(GameMain.localPlanet).reformRenderer.receiveShadows}");//true
			//Debug.Log($"lightProbeUsage : {GameMain.universeSimulator.FindPlanetSimulator(GameMain.localPlanet).reformRenderer.lightProbeUsage}");//Off
		}

		[HarmonyTranspiler, HarmonyPatch(typeof(BuildTool_BlueprintPaste), "DetermineReforms")]
		private static IEnumerable<CodeInstruction> DetermineReforms_Patch(IEnumerable<CodeInstruction> instructions, ILGenerator generator)
		{
			CodeMatcher codeMatcher = new CodeMatcher(instructions, generator)
				.MatchForward(false,
					new CodeMatch(OpCodes.Call, AccessTools.Method(typeof(BuildTool_BlueprintPaste), "GetLatAndLngRadByGridId")),
					new CodeMatch(OpCodes.Ldarg_0),
					new CodeMatch(OpCodes.Ldfld, AccessTools.Field(typeof(BuildTool_BlueprintPaste), "testModLevel")),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(Dictionary<int, int>), "Clear")))
				.Advance(15);
			return codeMatcher
				.CreateLabelAt(codeMatcher.Pos + 1, out Label label)
				.Insert(
					new CodeInstruction(OpCodes.Brtrue_S, label),
					new CodeInstruction(OpCodes.Ldarg_0),
					new CodeInstruction(OpCodes.Ldfld, AccessTools.Field(typeof(BuildTool_BlueprintPaste), "result")),
					new CodeInstruction(OpCodes.Ldc_I4_8),
					new CodeInstruction(OpCodes.And),
					new CodeInstruction(OpCodes.Ldc_I4_0),
					new CodeInstruction(OpCodes.Cgt))
				.InstructionEnumeration();
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
				.Advance(1)
				.InsertAndAdvance(
					new CodeInstruction(OpCodes.Ldc_I4_1),
					new CodeInstruction(OpCodes.Call, AccessTools.Method(typeof(Painter), "PaintButtonSetActive")))
				.MatchForward(true,
					new CodeMatch(OpCodes.Ldarg_0),
					new CodeMatch(OpCodes.Ldfld, AccessTools.Field(typeof(UIBuildMenu), "reformRevertButton")),
					new CodeMatch(OpCodes.Callvirt, AccessTools.PropertyGetter(typeof(Component), "gameObject")),
					new CodeMatch(OpCodes.Ldc_I4_0),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(GameObject), "SetActive")))
				.Advance(1)
				.Insert(
					new CodeInstruction(OpCodes.Ldc_I4_0),
					new CodeInstruction(OpCodes.Call, AccessTools.Method(typeof(Painter), "PaintButtonSetActive")))
				.InstructionEnumeration();
		}
		public static bool IsTerrainMapping(int index, int type)
		{
			if (type <= 0)
				return false;
			else if (type < 7)
				return true;
			else if (type == 7)
			{
				PlanetData localPlanet = GameMain.localPlanet;
				if (localPlanet.reformMaterial0.shader != shaderPatch || localPlanet.reformMaterial1.shader != shaderPatch)
					return false;
				// 选取地基中心像素，粗略判断
				if (paintingTexs[localPlanet.index].GetPixel(index % 512 * 8 + 4, 5087 - (index / 512 * 8 + 4)).a == 0f)
					return false;
				else
					return true;
			}
			else
				return false;
		}

		[HarmonyTranspiler, HarmonyPatch(typeof(PlayerFootsteps), "CheckPlayerInReform")]
		private static IEnumerable<CodeInstruction> CheckPlayerInReform_Patch(IEnumerable<CodeInstruction> instructions)
		{
			CodeMatcher codeMatcher = new CodeMatcher(instructions)
				.MatchForward(false,
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(PlatformSystem), "IsTerrainMapping")))
				.Set(
					OpCodes.Call, AccessTools.Method(typeof(Painter), "IsTerrainMapping"))
				.MatchBack(false,
					new CodeMatch(OpCodes.Ldloc_3));
			return codeMatcher
				.SetInstruction(codeMatcher.InstructionAt(-3))
				.InstructionEnumeration();
		}

		[HarmonyPostfix, HarmonyPatch(typeof(GameSave), "AutoSave")]
		private static void AutoSave_Postfix(bool __result)
		{
			if (!__result)
				return;
			string currentGame = textureSaveFolder + GameSave_CurrentGame;
			Debug.Log($"AutoSave_Postfix: currentGame={currentGame}");
			if (Directory.Exists(currentGame))
			{
				string autoSave0 = textureSaveFolder + GameSave.AutoSave0;
				string autoSave1 = textureSaveFolder + GameSave.AutoSave1;
				string autoSave2 = textureSaveFolder + GameSave.AutoSave2;
				string autoSave3 = textureSaveFolder + GameSave.AutoSave3;
				if (Directory.Exists(autoSave3))
					Directory.Delete(autoSave3, true);
				if (Directory.Exists(autoSave2))
					Directory.Move(autoSave2, autoSave3);
				if (Directory.Exists(autoSave1))
					Directory.Move(autoSave1, autoSave2);
				if (Directory.Exists(autoSave0))
					Directory.Move(autoSave0, autoSave1);
				Directory.Move(currentGame, autoSave0);
			}
		}
	}
}
