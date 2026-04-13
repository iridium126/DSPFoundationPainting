using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;

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

		public static void Init()
		{
			textures = new Dictionary<string, int>();
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
				Directory.CreateDirectory(textureSaveFolder);
				File.Copy(texturePath, Path.Combine(textureSaveFolder, Path.ChangeExtension(textureHash, ".png")));
			}
		}
	}
}
