std = "lua51"
max_line_length = false
exclude_files = {
	"**/Libs/**/*.lua",
	".luacheckrc",
}
ignore = {
	"11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
	"11./BINDING_.*", -- Setting an undefined (Keybinding header) global variable
	"212/self", -- Unused argument 'self'
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
	"Prat_ToggleOptionsWindow",

	-- Libraries
	"AceGUIWidgetLSMlists",
	"LibStub",

	-- Utility functions
	"date",
	"difftime",
	"geterrorhandler",
	"strsplit",
	"time",
	"table.wipe",
	-- DEPRECATIONS
	"floor", -- math.floor
	--
	"format", -- string.format
	"strlen", -- string.len
	"strmatch", -- string.match
	"strsub", -- string.sub
	"strlower", -- string.lower
	"strupper", -- string.upper
	--
	"tinsert", -- table.insert
	"tremove", -- table.remove
	"wipe", -- table.wipe

	-- Global constants
	"CHAT_FRAMES",
	"CUSTOM_CLASS_COLORS",
	"DEFAULT_CHAT_FRAME",
	"GROUP_TAG_LIST",
	"ICON_LIST",
	"ICON_TAG_LIST",
	"LE_REALM_RELATION_SAME",
	"MAX_WOW_CHAT_CHANNELS",
	"NUM_CHAT_WINDOWS",
	"RAID_CLASS_COLORS",
	"SELECTED_CHAT_FRAME",
	"WOW_PROJECT_CLASSIC",
	"WOW_PROJECT_ID",
	"WOW_PROJECT_MAINLINE",
	"WOW_PROJECT_MISTS_CLASSIC",

	-- Global Strings
	"ACCEPT",
	"CHAT_BN_CONVERSATION_SEND",
	"CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL",
	"NPEV2_CHAT_USER_TAG_GUIDE",
	"NPEV2_CHAT_USER_TAG_NEWCOMER",
	"PLAYER_LIST_DELIMITER",
	"TIME_DAYHOURMINUTESECOND",
	"UNKNOWN",

	-- Misc
	"BackdropTemplateMixin",
	"BattlePetTooltip",
	"BattlePetToolTip_ShowLink",
	"ChatFrame1EditBox",
	"ChatFrame1",
	"ChatFrame2",
	"ChatFrame3",
	"ChatFrame4",
	"ChatFrame5",
	"ChatFrame6",
	"ChatFrame7",
	"ChatFrame8",
	"ChatFrame9",
	"ChatFrame10",
	"ChatTypeInfo",
	"DevTools_Dump",
	"FCF_Close",
	"FCF_DockUpdate",
	"FCF_GetCurrentChatFrame",
	"FCF_MaximizeFrame",
	"FCF_SetChatWindowFontSize",
	"FCF_SetWindowName",
	"FCFManager_ShouldSuppressMessage",
	"GameFontNormal",
	"GameTooltip",
	"SlashCmdList",
	"StaticPopupDialogs",
	"StaticPopup_Show",
	"UIParent",
	"UIParentLoadAddOn",

	-- Enums
	"Constants.ChatFrameConstants.MaxChatChannels",
	"Constants.ChatFrameConstants.MaxChatWindows",
	"ChatFrameConstants.TruncatedCommunityNameLength",
	"ChatFrameConstants.TruncatedCommunityNameWithoutChannelLength",
	"ChatFrameConstants.WhisperSoundAlertCooldown",
	"Enum.ClubStreamType.General",
	"Enum.ClubStreamType.Guild",
	"Enum.ClubStreamType.Officer",
	"Enum.PlayerMentorshipStatus.Mentor",
	"Enum.PlayerMentorshipStatus.Newcomer",

	-- Utils
	"Chat_GetChatCategory",
	"Chat_GetChatFrame",
	"ChatEdit_DeactivateChat",
	"ChatEdit_OnEscapePressed",
	"ChatFrame_AddMessageGroup",
	"ChatFrame_GetMentorChannelStatus",
	"ChatFrame_GetMessageEventFilters",
	"ChatFrame_GetMobileEmbeddedTexture",
	"ChatFrame_ReceiveAllPrivateMessages",
	"ChatFrame_RemoveAllChannels",
	"ChatFrame_RemoveAllMessageGroups",
	"ChatFrame_AddCommunitiesChannel",
	"ChatHistory_GetAccessID",
	--
	"ChatFrameMixin.AddMessageGroup",
	"ChatFrameMixin.ReceiveAllPrivateMessages",
	"ChatFrameMixin.RemoveAllChannels",
	"ChatFrameMixin.RemoveAllMessageGroups",
	--
	"ChatFrameUtil.AddCommunitiesChannel",
	"ChatFrameUtil.DeactivateChat",
	"ChatFrameUtil.GetChatCategory",
	"ChatFrameUtil.GetChatFrame",
	"ChatFrameUtil.GetMentorChannelStatus",
	"ChatFrameUtil.GetMobileEmbeddedTexture",
	"ChatFrameUtil.ProcessMessageEventFilters",
	"ChatFrameUtil.ProcessSenderNameFilters",
	"ChatFrameUtil.TruncateToMaxLength",
	--
	"TimerunningUtil.AddSmallIcon",

	-- Lua API
	"C_BattleNet.GetAccountInfoByID",
	"C_ChatInfo.GetChannelRulesetForChannelID",
	"C_ChatInfo.IsTimerunningPlayer",
	"C_ClassColor.GetClassColor",
	"C_Club.GetClubInfo",
	"C_Club.GetInfoFromLastCommunityChatLine",
	"C_Club.GetStreamInfo",
	"C_EncodingUtil.DecodeBase64",
	"C_EncodingUtil.DeserializeCBOR",
	"C_EncodingUtil.EncodeBase64",
	"C_EncodingUtil.SerializeCBOR",
	"hooksecurefunc",
	"issecretvalue",
	"issecurevariable",
	"Ambiguate",
	"BNGetFriendInfoByID",
	"CreateAtlasMarkup",
	"CreateColor",
	"CreateFrame",
	"GetAverageItemLevel",
	"GetBattlefieldScore",
	"GetChannelList",
	"GetChannelName",
	"GetChatWindowInfo",
	"GetDifficultyColor",
	"GetGuildInfo",
	"GetGuildRosterInfo",
	"GetLocale",
	"GetMinimapZoneText",
	"GetNumBattlefieldScores",
	"GetNumGroupMembers",
	"GetNumSubgroupMembers",
	"GetPlayerInfoByGUID",
	"GetQuestDifficultyColor",
	"GetRaidRosterInfo",
	"GetRaidTargetIndex",
	"GetRealmName",
	"GetRealZoneText",
	"GetServerTime",
	"GetTime",
	"IsActivePlayerGuide",
	"IsAltKeyDown",
	"IsCombatLog",
	"IsControlKeyDown",
	"IsInGuild",
	"IsInRaid",
	"IsSecureCmd",
	"IsShiftKeyDown",
	"JoinChannelByName",
	"JoinTemporaryChannel",
	"PlaySound",
	"ReloadUI",
	"SetChatWindowAlpha",
	"SetChatWindowColor",
	"SetChatWindowDocked",
	"SetChatWindowLocked",
	"SetChatWindowName",
	"SetChatWindowSavedDimensions",
	"SetChatWindowSavedPosition",
	"SetChatWindowShown",
	"SetChatWindowSize",
	"SetChatWindowUninteractable",
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
