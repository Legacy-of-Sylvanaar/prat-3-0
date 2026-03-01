std = "lua51"
max_line_length = false
exclude_files = {
	"**/Libs/**/*.lua",
	".luacheckrc",
}
ignore = {
	"11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
	"11./BINDING_.*", -- Setting an undefined (Keybinding header) global variable
	"21.", -- Unused argument
}
globals = {
	-- Saved Variables
	"Prat3DB",
	"Prat3CharDB",
	"Prat3HighCPUPerCharDB",

	-- Prat
	"Prat",
	"Prat_PopupFrame",
	"Prat_PopupFrameText",

	-- Libraries
	"LibStub",

	-- Lua
	"date",
	"table.wipe",
	"time",

	-- Utility functions
	"geterrorhandler",
	"strsplit",
	"tinsert",
	"tremove",

	-- WoW
	"CUSTOM_CLASS_COLORS",
	"DEFAULT_CHAT_FRAME",
	"LE_REALM_RELATION_SAME",
	"NUM_CHAT_WINDOWS",
	"RAID_CLASS_COLORS",
	"SELECTED_CHAT_FRAME",

	"ACCEPT",
	"TIME_DAYHOURMINUTESECOND",
	"UNKNOWN",

	"Constants.ChatFrameConstants.MaxChatWindows",
	"ChatFrameConstants.TruncatedCommunityNameLength",
	"ChatFrameConstants.TruncatedCommunityNameWithoutChannelLength",
	"ChatFrameConstants.WhisperSoundAlertCooldown",

	"ChatFrame1",
	"DevTools_Dump",
	"GameFontNormal",
	"StaticPopupDialogs",
	"StaticPopup_Show",
	"UIParentLoadAddOn",

	"C_ClassColor.GetClassColor",
	"issecretvalue",
	"issecurevariable",
	"Ambiguate",
	"CreateColor",
	"CreateFrame",
	"GetAverageItemLevel",
	"GetBattlefieldScore",
	"GetChannelList",
	"GetDifficultyColor",
	"GetGuildInfo",
	"GetGuildRosterInfo",
	"GetLocale",
	"GetMinimapZoneText",
	"GetNumBattlefieldScores",
	"GetNumGroupMembers",
	"GetNumSubgroupMembers",
	"GetQuestDifficultyColor",
	"GetRaidRosterInfo",
	"GetRaidTargetIndex",
	"GetRealZoneText",
	"GetServerTime",
	"GetTime",
	"IsActivePlayerGuide",
	"IsCombatLog",
	"IsControlKeyDown",
	"IsInGuild",
	"IsInRaid",
	"IsShiftKeyDown",
	"JoinChannelByName",
	"JoinTemporaryChannel",
	"PlaySound",
	"UnitClass",
	"UnitCreatureFamily",
	"UnitCreatureType",
	"UnitExists",
	"UnitHealth",
	"UnitHealthMax",
	"UnitIsFriend",
	"UnitIsPlayer",
	"UnitLevel",
	"UnitName",
	"UnitPower",
	"UnitPowerMax",
	"UnitRace",
	"UnitRealmRelationship",
	"UnitSex",
}
