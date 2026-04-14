using HarmonyLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection.Emit;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Cryptography;
using UnityEngine;

namespace DSPBasePainter
{
	internal static class TextureStorage
	{
		// 纹理文件SHA256就是纹理图片文件名

		// 纹理文件SHA256 -> 引用计数
		private static Dictionary<string, int> textures;
		// PlanetData.id -> 纹理文件SHA256
		private static Dictionary<int, string> currentGame;
		public static string textureSaveFolder;
		private static bool textureChanged = false;

		public static void Init()
		{
			textures = LoadDictionary<string, int>(Path.Combine(textureSaveFolder, "texture_mapping.dat"));
			currentGame = new Dictionary<int, string>();
		}
		public static void SaveTexture(int planetId, string texturePath, byte[] textureBytes)
		{
			byte[] hashBytes;
			using (SHA256 sha256 = SHA256.Create())
			{
				hashBytes = sha256.ComputeHash(textureBytes);
			}
			string textureHash = BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
			currentGame[planetId] = textureHash;
			if (textures.ContainsKey(textureHash))
				textures[textureHash]++;
			else
			{
				textures[textureHash] = 1;
				Directory.CreateDirectory(Path.Combine(textureSaveFolder, "Texture"));
				File.Copy(texturePath, Path.Combine(textureSaveFolder, "Texture", Path.ChangeExtension(textureHash, ".png")));
			}
			textureChanged = true;
		}
		public static void LoadTexture(PlanetData planet)
		{
			if (currentGame.TryGetValue(planet.id, out string textureHash))
			{
				string texturePath = Path.Combine(textureSaveFolder, "Texture", Path.ChangeExtension(textureHash, ".png"));
				bool loadFailed = false;
				if (File.Exists(texturePath))
				{
					byte[] pngBytes = File.ReadAllBytes(texturePath);
					if (Painter.paintingTexs[planet.index].LoadImage(pngBytes))
					{
						Debug.Log($"Loaded texture for planet {planet.id} from {texturePath}");
						Material reformMat0 = planet.reformMaterial0;
						Material reformMat1 = planet.reformMaterial1;
						if (reformMat0.shader != Painter.shaderPatch || reformMat1.shader != Painter.shaderPatch)
						{
							reformMat0.shader = Painter.shaderPatch;
							reformMat1.shader = Painter.shaderPatch;
						}
						reformMat0.SetTexture("_PaintingTexture", Painter.paintingTexs[planet.index]);
						reformMat1.SetTexture("_PaintingTexture", Painter.paintingTexs[planet.index]);
					}
					else
					{
						Debug.LogWarning($"Failed to load texture for planet {planet.id} from {texturePath}");
						File.Delete(texturePath);
						loadFailed = true;
					}
				}
				else
				{
					Debug.LogWarning($"Texture file {texturePath} not found for planet {planet.id}");
					loadFailed = true;
				}
				if (loadFailed)
				{
					currentGame.Remove(planet.id);
					textureChanged = true;
					textures.Remove(textureHash);
				}
			}
		}

		[HarmonyTranspiler, HarmonyPatch(typeof(PlanetModelingManager), nameof(PlanetModelingManager.ModelingPlanetMain))]
		private static IEnumerable<CodeInstruction> ModelingPlanetMain_Patch(IEnumerable<CodeInstruction> instructions)
		{
			return new CodeMatcher(instructions)
				.MatchForward(true,
					new CodeMatch(OpCodes.Ldloc_S),
					new CodeMatch(OpCodes.Ldfld, AccessTools.Field(typeof(PlanetSimulator), "reformMat1")),
					new CodeMatch(OpCodes.Ldstr, "_AmbientInc"),
					new CodeMatch(OpCodes.Ldloc_S),
					new CodeMatch(OpCodes.Ldstr, "_AmbientInc"),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(Material), "GetFloat", new Type[] { typeof(string) })),
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(Material), "SetFloat", new Type[] { typeof(string), typeof(float) })))
				.Advance(1)
				.Insert(
					new CodeInstruction(OpCodes.Ldarg_0),
					new CodeInstruction(OpCodes.Call, AccessTools.Method(typeof(TextureStorage), "LoadTexture")))
				.InstructionEnumeration();
		}
		private static void SaveDictionary<TKey, TValue>(Dictionary<TKey, TValue> dict, string path)
		{
			if (dict.Count > 0)
			{
				Directory.CreateDirectory(Path.GetDirectoryName(path));
				using (FileStream fs = new FileStream(path, FileMode.Create))
				{
					new BinaryFormatter().Serialize(fs, dict);
				}
			}
		}
		private static Dictionary<TKey, TValue> LoadDictionary<TKey, TValue>(string path)
		{
			if (!File.Exists(path))
				return new Dictionary<TKey, TValue>();
			using (FileStream fs = new FileStream(path, FileMode.Open))
			{
				return (Dictionary<TKey, TValue>)new BinaryFormatter().Deserialize(fs);
			}
		}

		[HarmonyPostfix, HarmonyPatch(typeof(GameSave), nameof(GameSave.SaveCurrentGame))]
		private static void SaveCurrentGame_Postfix(bool __result, string saveName)
		{
			if (!__result)
				return;
			if (GameSave.AllowRecursive)
				saveName = saveName.ValidPathedFileName();
			else
				saveName = saveName.ValidFileName();
			SaveDictionary(currentGame, Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(saveName, ".dat")));
			if (textureChanged)
			{
				SaveDictionary(textures, Path.Combine(textureSaveFolder, "texture_mapping.dat"));
				textureChanged = false;
			}
		}

		[HarmonyPostfix, HarmonyPatch(typeof(GameSave), nameof(GameSave.AutoSave))]
		private static void AutoSave_Postfix(bool __result)
		{
			if (!__result)
				return;
			string AutoSaveTmp = Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(GameSave.AutoSaveTmp, ".dat"));
			if (File.Exists(AutoSaveTmp))
			{
				string AutoSave0 = Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(GameSave.AutoSave0, ".dat"));
				string AutoSave1 = Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(GameSave.AutoSave1, ".dat"));
				string AutoSave2 = Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(GameSave.AutoSave2, ".dat"));
				string AutoSave3 = Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(GameSave.AutoSave3, ".dat"));
				if (File.Exists(AutoSave3))
					File.Delete(AutoSave3);
				if (File.Exists(AutoSave2))
					File.Move(AutoSave2, AutoSave3);
				if (File.Exists(AutoSave1))
					File.Move(AutoSave1, AutoSave2);
				if (File.Exists(AutoSave0))
					File.Move(AutoSave0, AutoSave1);
				File.Move(AutoSaveTmp, AutoSave0);
			}
		}

		[HarmonyPostfix, HarmonyPatch(typeof(GameSave), nameof(GameSave.LoadCurrentGame))]
		private static void LoadCurrentGame_Postfix(bool __result, string saveName)
		{
			if (!__result)
				return;
			if (GameSave.AllowRecursive)
				saveName = saveName.ValidPathedFileName();
			else
				saveName = saveName.ValidFileName();
			currentGame = LoadDictionary<int, string>(Path.Combine(textureSaveFolder, "Save", Path.ChangeExtension(saveName, ".dat")));
		}
	}
}
