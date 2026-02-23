--[[ BEGIN STANDARD HEADER ]] --

local Chat_GetChatCategory = _G.Chat_GetChatCategory or _G.ChatFrameUtil.GetChatCategory
local ChatFrame_GetMentorChannelStatus = _G.ChatFrame_GetMentorChannelStatus or _G.ChatFrameUtil.GetMentorChannelStatus
local ChatFrame_GetMobileEmbeddedTexture = _G.ChatFrame_GetMobileEmbeddedTexture or _G.ChatFrameUtil.GetMobileEmbeddedTexture

-- Imports
local _G = _G

local setmetatable = setmetatable
local pairs, ipairs = pairs, ipairs
local tinsert, tremove = table.insert, table.remove
local string = string
local strsub = string.sub
local tostring = tostring
local strlower, strupper = strlower, strupper
local strlen = strlen
local type = type
local next, wipe = next, wipe
local select = select

local RunMessageEventFilters
if ChatFrameUtil.ProcessMessageEventFilters then
	RunMessageEventFilters = ChatFrameUtil.ProcessMessageEventFilters
else
	RunMessageEventFilters = function(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
		local filter = false
		local chatFilters = _G.ChatFrame_GetMessageEventFilters(event)
		if chatFilters then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
			for _, filterFunc in next, chatFilters do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
				if filter then
					return true
				elseif newarg1 then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
				end
			end
		end

		return filter, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17
	end
end

-- Isolate the environment
setfenv(1, select(2, ...))

--[[ END STANDARD HEADER ]] --


-- This is the structure of the chat message once it is split
-- section delimiters are uppercase inside and lower case outside
-- ie.   cC CHANNEL Cc =  [ channame ]
SplitMessageSrc = {
	-- todo, incidicate which module uses which field, and remove unused fields
	PRE = "",
	nN = "",
	CHANLINK = "",
	NN = "",
	cC = "",
	CHANNELNUM = "",
	CC = "",
	CHANNEL = "",
	Cc = "",
	TYPEPREFIX = "",
	Nn = "",
	fF = "",
	FLAG = "",
	Ff = "",
	pP = "",
	lL = "", -- link start
	PLAYERLINK = "",
	PLAYERLINKDATA = "",
	LL = "", --  link text start
	PLAYER = "",
	NONPLAYER = "",
	sS = "",
	SERVER = "",
	Ss = "",
	Ll = "", -- link text end
	Pp = "",
	TYPEPOSTFIX = "",
	mM = "",
	gG = "",
	LANGUAGE = "",
	Gg = "",
	MOBILE = "",
	MESSAGE = "",
	Mm = "",
	POST = "",
}

SplitMessageIdx = {
	"PRE",
	"nN",
	"CHANLINK",
	"NN",
	"cC",
	"CHANNELNUM",
	"CC",
	"CHANNEL",
	"Cc",
	"TYPEPREFIX",
	"Nn",
	"fF",
	"FLAG",
	"Ff",
	"pP",
	"TIMERUNNER",
	"lL",
	"PLAYERLINK",
	"PLAYERLINKDATA",
	"LL",
	"PLAYER",
	"NONPLAYER",
	"sS",
	"SERVER",
	"Ss",
	"Ll",
	"Pp",
	"TYPEPOSTFIX",
	"mM",
	"gG",
	"LANGUAGE",
	"Gg",
	"MOBILE",
	"MESSAGE",
	"Mm",
	"POST",
}

SplitMessage = {}
SplitMessageOrg = {}

SplitMessageOut = {
	MESSAGE = "",
	TYPE = "",
	TARGET = "",
	CHANNEL = "",
	LANGUAGE = "",
}

setmetatable(SplitMessageOrg, {
	__index = SplitMessageSrc
})

setmetatable(SplitMessage, {
	__index = SplitMessageOrg
})

function BuildChatText(message)
	local out = ''
	for _, v in ipairs(SplitMessageIdx) do
		if message[v] then
			out = out .. message[v]
		end
	end
	return out
end

function RegisterMessageItem(itemname, anchorvar, relativepos)
	--[[ RegisterMessageItem:

	API to allow other modules to inject new items into the components
	making up a chat message. Primarily intended to help resolve
	conflicts between modules.

	 - itemname  = name of the variable to be injected

	 - aftervar  = the position in the chat message after which the item
				   will be displayed

	 - relativepos = "before" or "after"
	Leave aftervar blank to position the item at the beginning of the list.

	If you would like to change the item's position in the chat message,
	call :RegisterMessageItem() again with a different value for aftervar.

	Example:
	--------

	The mod Prat_ExampleMod counts the number of times people
	say the word "Example" and you would like to display the count
	for a player before their name in a chat message. Default chat
	message structure contains:

		... cC CHANNEL Cc .. pP PLAYER Pp ...

	This means that the module should use the following:

		RegisterMessageItem('NUMEXAMPLES', 'Cc')

	Which would then alter the structure of chat messages to be:

		.. CHANNEL Cc .. NUMEXAMPLES .. pP PLAYER ...

	]]

	local pos = 1

	if SplitMessageSrc[itemname] then
		--		ResetSeparators(itemname)

		local oldpos = GetMessageItemIdx(itemname)

		if oldpos ~= 0 then
			tremove(SplitMessageIdx, oldpos)
		end
	end

	if anchorvar then
		pos = GetMessageItemIdx(anchorvar) + (relativepos == "before" and 0 or 1)
	end

	tinsert(SplitMessageIdx, pos, itemname)
	SplitMessageSrc[itemname] = ""
end

function GetMessageItemIdx(itemname)
	for i, v in ipairs(SplitMessageIdx) do
		if v == itemname then
			return i
		end
	end

	return 0
end

function ClearChatSections(message)
	wipe(message)
end

local function safestr(s)
	return s or ""
end

local function GetDecoratedSenderName(event, ...)
	local _, senderName, _, _, _, _, _, channelIndex, _, _, _, senderGUID = ...;
	local chatType = string.sub(event, 10);

	if string.find(chatType, "^WHISPER") then
		chatType = "WHISPER";
	end

	if string.find(chatType, "^CHANNEL") then
		chatType = "CHANNEL" .. channelIndex;
	end

	local chatTypeInfo = _G.ChatTypeInfo[chatType];
	local decoratedPlayerName = senderName;

	local localizedClass, englishClass, localizedRace, englishRace, sex, firstName
	if senderGUID then
		localizedClass, englishClass, localizedRace, englishRace, sex, firstName = _G.GetPlayerInfoByGUID(senderGUID);
	end

	-- Ambiguate guild chat names
	if _G.Ambiguate and (not _G.issecretvalue or not _G.issecretvalue(senderName)) then
		if chatType == "GUILD" then
			decoratedPlayerName = _G.Ambiguate(decoratedPlayerName, "guild");
		else
			decoratedPlayerName = _G.Ambiguate(decoratedPlayerName, "none");
		end
	elseif firstName then
		decoratedPlayerName = firstName
	end

	-- Add timerunning icon when necessary based on player guid
	if senderGUID and (not _G.issecretvalue or not _G.issecretvalue(senderGUID)) and _G.C_ChatInfo.IsTimerunningPlayer(senderGUID) then
		decoratedPlayerName = _G.TimerunningUtil.AddSmallIcon(decoratedPlayerName);
	end

	if senderGUID and chatTypeInfo and _G.GetPlayerInfoByGUID ~= nil then
		if englishClass then
			local classColor = GetClassGetColorNew(englishClass)

			if classColor then
				decoratedPlayerName = classColor:WrapTextInColorCode(decoratedPlayerName);
			end
		end
	end

	if _G.ChatFrameUtil.ProcessSenderNameFilters then
		decoratedPlayerName = _G.ChatFrameUtil.ProcessSenderNameFilters(event, decoratedPlayerName, ...);
	end
	if decoratedPlayerName then
		if (not _G.issecretvalue or not _G.issecretvalue(decoratedPlayerName)) and decoratedPlayerName == "" then
			return decoratedPlayerName
		end
		return "[" .. decoratedPlayerName .. "]";
	end
end

local function SanitizeCommunityData(clubId, streamId, epoch, position)
	if type(clubId) == "number" then
		clubId = ("%.f"):format(clubId);
	end
	if type(streamId) == "number" then
		streamId = ("%.f"):format(streamId);
	end
	epoch = ("%.f"):format(epoch);
	position = ("%.f"):format(position);

	return clubId, streamId, epoch, position;
end

local function GetBNPlayerCommunityLink(playerName, linkDisplayText, bnetIDAccount, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position);
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s:%s|h%s|h", playerName, bnetIDAccount, clubId, streamId, epoch, position, linkDisplayText)
end

local function GetPlayerCommunityLink(playerName, linkDisplayText, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position);
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s|h%s|h", playerName, clubId, streamId, epoch, position, linkDisplayText)
end

local function GetPlayerLink(characterName, linkDisplayText, lineID, chatType, chatTarget)
	return string.format("|Hplayer:%s:%s:%s:%s|h%s|h", characterName, lineID or 0, chatType or 0, chatTarget or "", linkDisplayText);
end

local function GetBNPlayerLink(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
	return string.format("|HBNplayer:%s:%s:%s:%s:%s|h%s|h", name, bnetIDAccount, lineID, chatType, chatTarget, linkDisplayText);
end

function SplitChatMessage(frame, event, ...)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...
	local isSecret = _G.issecretvalue and _G.issecretvalue(arg1)

	if (strsub((event or ""), 1, 8) == "CHAT_MSG") then
		type = strsub(event, 10)

		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true;
		end

		local info

		local coloredName = GetDecoratedSenderName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
		local channelLength = arg4 and strlen(arg4) or 0
		local infoType = type;
		if ((type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((not isSecret and arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER")))) then
			local found = 0;
			for index, value in pairs(frame.channelList) do
				if (channelLength > strlen(value)) then
					-- arg9 is the channel name without the number in front...
					if (((arg7 > 0) and (frame.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9))) then
						found = 1;
						infoType = "CHANNEL" .. arg8;
						info = _G.ChatTypeInfo[infoType];
						break ;
					end
				end
			end
			if ((found == 0) or not info) then
				return true;
			end
		end

		ClearChatSections(SplitMessageOrg)
		ClearChatSections(SplitMessage)

		local s = SplitMessageOrg

		s.LINE_ID = arg11
		s.INFOTYPE = infoType
		info = _G.ChatTypeInfo[infoType]
		-- blizzard bug, arg2 (player name) can have an extra space
		if not isSecret and arg2 then
			arg2 = arg2:trim()
		end

		s.GUID = arg12

		s.ARGS = {
			...
		}

		local kill, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = RunMessageEventFilters(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
		if kill then
			return true
		end
		if newarg1 ~= nil then
			arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
		end

		s.CHATTYPE = type
		s.EVENT = event
		local chatGroup = Chat_GetChatCategory(type)
		s.CHATGROUP = chatGroup

		local chatTarget
		if (chatGroup == "CHANNEL" or chatGroup == "BN_CONVERSATION") then
			chatTarget = tostring(arg8)
		elseif (chatGroup == "WHISPER" or chatGroup == "BN_WHISPER") then
			if (not _G.issecretvalue or not _G.issecretvalue(arg2)) and (not (strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2)
			else
				chatTarget = arg2
			end
		end

		s.CHATTARGET = chatTarget
		s.MESSAGE = isSecret and arg1 or safestr(arg1):gsub("^%s*(.-)%s*$", "%1")  -- trim spaces


		if (_G.FCFManager_ShouldSuppressMessage(frame, s.CHATGROUP, s.CHATTARGET)) then
			s.DONOTPROCESS = true
		end

		if (chatGroup == "WHISPER" or chatGroup == "BN_WHISPER") then
			if (frame.privateMessageList and not frame.privateMessageList[strlower(arg2)]) then
				s.DONOTPROCESS = true
			elseif (frame.excludePrivateMessageList and frame.excludePrivateMessageList[strlower(arg2)]) then
				s.DONOTPROCESS = true
			end
		elseif (chatGroup == "BN_CONVERSATION") then
			if (frame.bnConversationList and not frame.bnConversationList[arg8]) then
				s.DONOTPROCESS = true
			elseif (frame.excludeBNConversationList and frame.excludeBNConversationList[arg8]) then
				s.DONOTPROCESS = true
			end
		end

		local chatget = _G["CHAT_" .. type .. "_GET"]

		if chatget then
			local chatlink = chatget:match("|H(channel:[^|]-)|h[^|]-|h")

			if chatlink then
				s.CHANLINK = chatlink
				s.nN = "|H"
				s.NN = "|h"
				s.Nn = "|h"

				chatget = chatget:gsub("|Hchannel:[^|]-|h([^|]-)|h", "%1")
			end

			s.TYPEPREFIX, s.TYPEPOSTFIX = string.match(chatget, "(.*)%%s(.*)")
		end

		s.TYPEPOSTFIX = safestr(s.TYPEPOSTFIX)
		s.TYPEPREFIX = safestr(s.TYPEPREFIX)

		arg2 = isSecret and arg2 or safestr(arg2)
		if (strsub(type, 1, 7) == "MONSTER" or type == "SYSTEM" or type == "RAID_BOSS_EMOTE" or type == "CHANNEL_NOTICE" or type == "CHANNEL_NOTICE_USER") then
			s.NONPLAYER = arg2
		elseif isSecret and coloredName then
			local isCommunityType = type == "COMMUNITIES_CHANNEL"
			if strsub(type, 1, 11) == 'ACHIEVEMENT' or strsub(type, 1, 18) == 'GUILD_ACHIEVEMENT' then
				s.PLAYER = string.format("|Hplayer:%s|h%s|h", arg2, coloredName)
			elseif isCommunityType then
				local isBattleNetCommunity = arg13 ~= nil and (_G.issecretvalue and _G.issecretvalue(arg13) or arg13 ~= 0)
				local messageInfo, clubId, streamId, _ = _G.C_Club.GetInfoFromLastCommunityChatLine()
				if messageInfo ~= nil then
					if isBattleNetCommunity then
						s.PLAYER = GetBNPlayerCommunityLink(arg2, coloredName, arg13, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					else
						s.PLAYER = GetPlayerCommunityLink(arg2, coloredName, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					end
				else
					s.PLAYER = coloredName
				end
			elseif type == "BN_WHISPER" or type == "BN_WHISPER_INFORM" then
				s.PLAYER = GetBNPlayerLink(arg2, coloredName, arg13, arg11, chatGroup, chatTarget)
			else
				s.PLAYER = GetPlayerLink(arg2, coloredName, arg11, chatGroup, chatTarget)
			end
		elseif not isSecret and strlen(arg2) > 0 then
			if type == "EMOTE" then
				s.PLAYER = _G.Ambiguate(arg2, "none"):match("([^%-]+)%-?(.*)")
			elseif type == "TEXT_EMOTE" then
			else
				s.PLAYERLINK = arg2

				--ambiguate guild chat names
				if (type == "GUILD") then
					arg2 = _G.Ambiguate(arg2, "guild")
				else
					arg2 = _G.Ambiguate(arg2, "none")
				end

				local plr, svr = arg2:match("([^%-]+)%-?(.*)")

				s.pP = "["
				s.lL = "|Hplayer:"

				s.LL = "|h"
				s.PLAYER = plr

				if svr and strlen(svr) > 0 then
					s.sS = "-"
					s.SERVER = svr
				end
				s.Ll = "|h"
				s.Pp = "]"

				local isCommunityType = type == "COMMUNITIES_CHANNEL";
				if (isCommunityType) then
				else
					if (type ~= "BN_WHISPER" and type ~= "BN_WHISPER_INFORM" and type ~= "BN_CONVERSATION") or arg2 == _G.UnitName("player") --[[or presenceID]] then
						s.PLAYERLINKDATA = ":" .. safestr(arg11) .. ":" .. chatGroup .. (chatTarget and (":" .. chatTarget) or "")
					else
						s.lL = "|HBNplayer:"
						local battleTag, _
						if _G.C_BattleNet and _G.C_BattleNet.GetAccountInfoByID then
							battleTag = _G.C_BattleNet.GetAccountInfoByID(arg13).battleTag
						else
							_, _, battleTag = _G.BNGetFriendInfoByID(arg13)
						end
						s.PLAYERLINKDATA = ":" .. safestr(arg13) .. ":" .. safestr(arg11) .. ":" .. chatGroup .. ":" .. chatTarget .. (battleTag and (":" .. battleTag) or "")
						s.PRESENCE_ID = arg13
					end
				end
			end
		end

		-- If we are handling notices, format them like bliz
		if (type == "CHANNEL_NOTICE_USER") then
			s.NOTICE = arg1
			local globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"];
			local chatnotice
			if globalstring then
				chatnotice = globalstring:gsub("|Hchannel:CHANNEL[^|]-|h[^|]-|h", ""):trim();
			else
				globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"];
				chatnotice = globalstring:gsub("|Hchannel:[^|]-|h[^|]-|h", ""):trim()
			end

			if strlen(arg5) > 0 then
				-- TWO users in this notice (E.G. x kicked y)
				if _G.GetLocale() == "koKR" then
					s.MESSAGE = chatnotice:format("", "", arg2, arg5)
				else
					s.MESSAGE = chatnotice:format(arg2, arg5)
				end
			elseif (arg1 == "INVITE") then
				s.MESSAGE = chatnotice:format(arg4, arg2)
			else
				s.MESSAGE = chatnotice:format(arg2)
			end
		elseif type == "CHANNEL_NOTICE" then
			local globalstring;
			s.NOTICE = arg1
			if (arg1 == "TRIAL_RESTRICTED") then
				globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL;
			else
				globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"];
				if (not globalstring) then
					globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"];
					if not globalstring then
						_G.GMError(("Missing global string for %q"):format("CHAT_" .. arg1 .. "_NOTICE"));
						return ;
					end
				end
			end
			s.MESSAGE = _G.format(globalstring, arg8, ResolvePrefixedChannelName(arg4))
		end

		arg6 = safestr(arg6)
		if strlen(arg6) > 0 then
			s.fF = ""

			if arg6 == "GM" or arg6 == "DEV" then
				-- Add Blizzard Icon if this was sent by a GM/DEV
				s.FLAG = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t "
			elseif arg6 == "GUIDE" and ChatFrame_GetMentorChannelStatus(_G.Enum.PlayerMentorshipStatus.Mentor, _G.C_ChatInfo.GetChannelRulesetForChannelID(arg7)) == _G.Enum.PlayerMentorshipStatus.Mentor then
				-- Add guide text if the sender is a guide in the newcomer chat
				s.FLAG = _G.NPEV2_CHAT_USER_TAG_GUIDE .. " "
			elseif arg6 == "NEWCOMER" then
				if ChatFrame_GetMentorChannelStatus(_G.Enum.PlayerMentorshipStatus.Newcomer, _G.C_ChatInfo.GetChannelRulesetForChannelID(arg7)) == _G.Enum.PlayerMentorshipStatus.Newcomer then
					-- Add murloc icon for messages from new players in the newcomer chat
					s.FLAG = _G.NPEV2_CHAT_USER_TAG_NEWCOMER
				end
			else
				s.FLAG = _G["CHAT_FLAG_" .. arg6]
			end

			s.Ff = ""
		end

		if not isSecret and arg12 and _G.C_ChatInfo.IsTimerunningPlayer and _G.C_ChatInfo.IsTimerunningPlayer(arg12) then
			s.TIMERUNNER = _G.CreateAtlasMarkup("timerunning-glues-icon", 12, 12)
		else
			s.TIMERUNNER = ""
		end

		if arg15 then
			s.MOBILE = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)
		end

		arg3 = safestr(arg3)
		if ((strlen(arg3) > 0) and (arg3 ~= "Universal") and (arg3 ~= frame.defaultLanguage)) then
			s.gG = "["
			s.LANGUAGE = arg3
			s.Gg = "] "
		else
			s.LANGUAGE_NOSHOW = arg3
		end

		arg9 = safestr(arg9)
		if strlen(arg9) > 0 or chatGroup == "BN_CONVERSATION" then
			if strlen(safestr(arg8)) > 0 and arg8 > 0 then
				s.CC = ". "

				s.nN = "|H"
				s.NN = "|h"
				s.Nn = "|h"

				if chatGroup == "BN_CONVERSATION" then
					s.CHANLINK = "channel:BN_CONVERSATION:" .. arg8
				else
					s.CHANNELNUM = tostring(arg8)
					s.CHANLINK = "channel:channel:" .. tostring(arg8)
				end
			end

			if chatGroup == "BN_CONVERSATION" then
				s.cC = "["
				s.Cc = "] "
				s.CHANNELNUM = tostring(_G.MAX_WOW_CHAT_CHANNELS + arg8)
				s.CHANNEL = _G.CHAT_BN_CONVERSATION_SEND:match("%[%%d%. (.*)%]")
			elseif arg7 > 0 then
				s.cC = "["
				s.Cc = "] "
				s.CHANNEL = string.match(arg9, "(.*)%s%-%s.*")

				if s.CHANNEL:len() == 0 then
					s.CHANNEL = arg9
				end

				s.CHANNEL = safestr(s.CHANNEL)
			elseif chatGroup == "COMMUNITIES_CHANNEL" then
				s.cC = "["
				s.Cc = "] "
				local _chanName = ResolveChannelName(arg4)
				if _G.issecretvalue and _G.issecretvalue(_chanName) then
					s.CHANNEL = _chanName
				else
					s.CHANNEL = ResolvePrefixedChannelName(arg4):match("%d%.%s+(.+)")
				end
			else
				if strlen(arg9) > 0 then
					s.CHANNEL = arg9
					s.cC = "["
					s.Cc = "] "
				end
			end
		end

		-- 2.4
		-- Search for icon links and replace them with texture links.
		local term;

		if not isSecret then
			for tag in string.gmatch(arg1, "%b{}") do
				term = strlower(string.gsub(tag, "[{}]", ""));
				if (not arg17 and _G.ICON_TAG_LIST[term] and _G.ICON_LIST[_G.ICON_TAG_LIST[term]]) then
					s.MESSAGE = string.gsub(s.MESSAGE, tag, _G.ICON_LIST[_G.ICON_TAG_LIST[term]] .. "0|t");
				elseif (_G.GROUP_TAG_LIST[term]) then
					local groupIndex = _G.GROUP_TAG_LIST[term];
					local groupList = "[";
					for i = 1, _G.GetNumGroupMembers() do
						local name, _, subgroup, _, _, classFileName = _G.GetRaidRosterInfo(i);
						if (name and subgroup == groupIndex) then
							local t = _G.RAID_CLASS_COLORS[classFileName];
							name = string.format("\124cff%.2x%.2x%.2x%s\124r", t.r * 255, t.g * 255, t.b * 255, name);
							groupList = groupList .. (groupList == "[" and "" or _G.PLAYER_LIST_DELIMITER) .. name;
						end
					end
					groupList = groupList .. "]";
					s.MESSAGE = string.gsub(s.MESSAGE, tag, groupList);
				end
			end
		end

		if not isSecret and (type == "SYSTEM" or strsub(type, 1, 11) == "ACHIEVEMENT" or strsub(type, 1, 11) == "TARGETICONS" or strsub(type, 1, 18) == "GUILD_ACHIEVEMENT") then
			if strsub(type, 1, 11) == "ACHIEVEMENT" or strsub(type, 1, 18) == "GUILD_ACHIEVEMENT" then
				s.MESSAGE = s.MESSAGE:format("")
			end

			local pl, p, rest = string.match(s.MESSAGE, "|Hplayer:(.-)|h%[(.-)%]|h(.+)")
			if pl and p then
				local plr, svr = pl:match("([^%-]+)%-?(.*)")
				s.pP = "["
				s.lL = "|Hplayer:"
				s.PLAYERLINK = pl
				s.LL = "|h"
				s.PLAYER = plr
				s.Ll = "|h"
				s.Pp = "]"
				s.MESSAGE = rest

				if svr and strlen(svr) > 0 then
					s.sS = "-"
					s.SERVER = svr
				end

				if arg11 then
					s.PLAYERLINKDATA = ":" .. safestr(arg11)
				end
			end
		end

		s.ACCESSID = not isSecret and _G.ChatHistory_GetAccessID(chatGroup, chatTarget);
		s.TYPEID = not isSecret and _G.ChatHistory_GetAccessID(type, chatTarget, arg12 or arg13);

		SplitMessage.ORG = SplitMessageOrg

		s.INFO = info

		return SplitMessage, info
	end
end



