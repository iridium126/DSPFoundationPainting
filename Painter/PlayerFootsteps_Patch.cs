using HarmonyLib;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace DSPFoundationPainter
{
	internal static class PlayerFootsteps_Patch
	{
		public static bool IsTerrainMapping(int index, int type)
		{
			if (type <= 0)
				return false;
			else if (type < 7)
				return true;
			else if (type == 7)
			{
				PlanetData localPlanet = GameMain.localPlanet;
				if (localPlanet.reformMaterial0.shader != Painter.shaderPatch || localPlanet.reformMaterial1.shader != Painter.shaderPatch)
					return false;
				// 选取地基中心像素，粗略判断
				if (Painter.paintingTexs[localPlanet.index].GetPixel(index % 512 * 8 + 4, 5087 - (index / 512 * 8 + 4)).a == 0f)
					return false;
				else
					return true;
			}
			else
				return false;
		}

		[HarmonyTranspiler, HarmonyPatch(typeof(PlayerFootsteps), nameof(PlayerFootsteps.CheckPlayerInReform))]
		private static IEnumerable<CodeInstruction> CheckPlayerInReform_Patch(IEnumerable<CodeInstruction> instructions)
		{
			CodeMatcher codeMatcher = new CodeMatcher(instructions)
				.MatchForward(false,
					new CodeMatch(OpCodes.Callvirt, AccessTools.Method(typeof(PlatformSystem), "IsTerrainMapping")))
				.Set(
					OpCodes.Call, AccessTools.Method(typeof(PlayerFootsteps_Patch), "IsTerrainMapping"))
				.MatchBack(false,
					new CodeMatch(OpCodes.Ldloc_3));
			return codeMatcher
				.SetInstruction(codeMatcher.InstructionAt(-3))
				.InstructionEnumeration();
		}
	}
}
