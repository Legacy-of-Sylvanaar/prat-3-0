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

	"ACCEPT",
	"TIME_DAYHOURMINUTESECOND",
	"UNKNOWN",

	"ChatFrame1",
	"GameFontNormal",
	"StaticPopupDialogs",
	"StaticPopup_Show",

	"issecretvalue",
	"Ambiguate",
	"GetRaidTargetIndex",
	"IsCombatLog",
	"IsControlKeyDown",
	"IsInRaid",
	"IsShiftKeyDown",
	"UnitExists",
	"UnitHealth",
	"UnitHealthMax",
	"UnitIsPlayer",
	"UnitLevel",
	"UnitName",
	"UnitPower",
	"UnitPowerMax",
	"UnitRace",
	"UnitSex",
}
