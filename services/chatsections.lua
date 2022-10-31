--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local _G = _G
local LibStub = LibStub

local setmetatable = setmetatable
local pairs, ipairs = pairs, ipairs
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat
local string = string
local strsub = string.sub
local strsplit = strsplit
local tonumber, tostring = tonumber, tostring
local strlower, strupper = strlower, strupper
local strlen = strlen
local type = type
local next, wipe = next, wipe
local select = select

--local function RunOldMessageEventFilters(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
--	local filter = false
--	local chatFilters = _G.ChatFrame_GetMessageEventFilters and _G.ChatFrame_GetMessageEventFilters(event)
--    local newarg1 = arg1
--
--	if chatFilters then
--		for _, filterFunc in next, chatFilters do
--			filter, newarg1 = filterFunc(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
--			if filter then
--				return true
--			end
--			arg1 = newarg1 or arg1
--		end
--	end
--
--    return filter, arg1
--end


-- arg1, filterthisout = RunMessageEventFilters(event, arg1)
local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newrg14, newarg15, newarg16, newarg17
local function RunMessageEventFilters(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
  local filter = false
  local chatFilters = _G.ChatFrame_GetMessageEventFilters and _G.ChatFrame_GetMessageEventFilters(event)

  if chatFilters then
    for _, filterFunc in next, chatFilters do
      if filterFunc ~= MessageEventFilter then
        filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newrg14, newarg15, newarg16, newarg17 =
        filterFunc(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
        if filter then
          return true
        elseif (newarg1) then
          arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 =
          newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newrg14, newarg15, newarg16, newarg17
        end
      end
    end
  end

  return filter, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17
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
  zZ = "",
  ZONE = "",
  Zz = "",
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
  -- Zone is not usually included
  --      "zZ",
  --          "ZONE",
  --      "Zz",

  "Cc",
  "TYPEPREFIX",
  "Nn",

  "fF",
  "FLAG",
  "Ff",
  "pP",
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


do
  local t = {}
  function BuildChatText(message, index)
    local index = index or SplitMessageIdx --todo
    local s = message

    for k in pairs(t) do
      t[k] = nil
    end

    for i, v in ipairs(index) do
      tinsert(t, s[v])
    end

    return tconcat(t, "")
  end
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

local function safestr(s) return s or "" end

function SplitChatMessage(frame, event, ...)
  local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...

  if (strsub((event or ""), 1, 8) == "CHAT_MSG") then
    local type = strsub(event, 10)

    if (arg16) then
      -- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
      return true;
    end

    local info
    local channelLength = arg4 and strlen(arg4) or 0
    local infoType = type;
    if ( (type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER"))) ) then
      local found = 0;
      for index, value in pairs(frame.channelList) do
        if ( channelLength > strlen(value) ) then
          -- arg9 is the channel name without the number in front...
          if ( ((arg7 > 0) and (frame.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
            found = 1;
            infoType = "CHANNEL"..arg8;
            info = _G.ChatTypeInfo[infoType];
            break;
          end
        end
      end
      if ( (found == 0) or not info ) then
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
    if arg2 then
      arg2 = arg2:trim()
    end

    s.GUID = arg12

    --@debug@
    s.ARGS = {
      ...
    }

    if CHAT_PLAYER_GUIDS then
      if s.GUID and s.GUID:len() > 0 and s.GUID ~= "0000000000000000" and s.GUID ~= "0x0300000000000000" then
        s.GUIDINFO = {
          _G.GetPlayerInfoByGUID(s.GUID)
        }
      end
    end

    s.FRAME = frame and frame:GetName()
    --@end-debug@

    --        if NEW_CHATFILTERS then
    local kill, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 =
    RunMessageEventFilters(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    if kill then
      return true
    end
    if newarg1 ~= nil then
      arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
      newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
    end
    --        else
    --            local kill, newarg1 = RunOldMessageEventFilters(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
    --            if kill then
    --                return true
    --            end
    --
    --            arg1 = newarg1 or arg1
    --        end


    s.CHATTYPE = type
    s.EVENT = event
    local chatGroup = _G.Chat_GetChatCategory(type)
    s.CHATGROUP = chatGroup



    local chatTarget;
    local presenceID
    if (chatGroup == "CHANNEL" or chatGroup == "BN_CONVERSATION") then
      chatTarget = tostring(arg8);
    elseif (chatGroup == "WHISPER" or chatGroup == "BN_WHISPER") then
      if (not (strsub(arg2, 1, 2) == "|K")) then
        chatTarget = strupper(arg2);
      else
        chatTarget = arg2;
      end
    end


    s.CHATTARGET = chatTarget
    s.MESSAGE = safestr(arg1):gsub("^%s*(.-)%s*$", "%1")  -- trim spaces


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

    local arg2 = safestr(arg2)
    if strlen(arg2) > 0 then

      if (strsub(type, 1, 7) == "MONSTER" or type == "RAID_BOSS_EMOTE" or
        type == "CHANNEL_NOTICE" or type == "CHANNEL_NOTICE_USER") then
        -- no link
        s.NONPLAYER = arg2
      elseif type == "EMOTE" then
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

        local playerLinkDisplayText = s.pP .. s.PLAYER .. s.Pp
        local isCommunityType = type == "COMMUNITIES_CHANNEL";
        local playerName, lineID, bnetIDAccount = arg2, arg11, arg13;
        if (isCommunityType) then
          --          local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0;
          --          local messageInfo, clubId, streamId, clubType = _G.C_Club.GetInfoFromLastCommunityChatLine();
          --          if (messageInfo ~= nil) then
          --            if ( isBattleNetCommunity ) then
          --              playerLink = _G.GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
          --            else
          --              playerLink = _G.GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
          --            end
          --          else
          --            playerLink = playerLinkDisplayText;
          --          end
        else
          if (type ~= "BN_WHISPER" and type ~= "BN_WHISPER_INFORM" and type ~= "BN_CONVERSATION") or arg2 == _G.UnitName("player") --[[or presenceID]] then
            s.PLAYERLINKDATA = ":" .. safestr(arg11) .. ":" .. chatGroup .. (chatTarget and (":" .. chatTarget) or "")
          else
            s.lL = "|HBNplayer:"
            local battleTag, _
            if _G.C_BattleNet and  _G.C_BattleNet.GetAccountInfoByID then
              battleTag =  _G.C_BattleNet.GetAccountInfoByID(arg13).battleTag
            else
              _, _, battleTag = _G. BNGetFriendInfoByID(arg13)
            end
            s.PLAYERLINKDATA = ":" .. safestr(arg13) .. ":" .. safestr(arg11) .. ":" .. chatGroup ..  ":" .. chatTarget ..  (battleTag and (":" .. battleTag) or "")
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
      if ( arg1 == "TRIAL_RESTRICTED" ) then
        globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL;
      else
        globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
        if ( not globalstring ) then
          globalstring = _G["CHAT_"..arg1.."_NOTICE"];
          if not globalstring then
            _G.GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE"));
            return;
          end
        end
      end
      s.MESSAGE = _G.format(globalstring, arg8, _G.ChatFrame_ResolvePrefixedChannelName(arg4))
    end

    local arg6 = safestr(arg6)
    if strlen(arg6) > 0 then
      s.fF = ""

      if arg6 == "GM" or arg6 == "DEV" then
        -- Add Blizzard Icon if this was sent by a GM/DEV
	      s.FLAG = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t "
      elseif arg6 == "GUIDE" then
        if _G.IsActivePlayerNewcomer() then
          -- Add guide text if player is a newcomer and this was sent by a mentor
          s.FLAG = _G.NPEV2_CHAT_USER_TAG_GUIDE .. " "
        end
      elseif arg6 == "NEWCOMER" then
        if _G.IsActivePlayerMentor() then
          -- Add murloc icon if player is a mentor and this was sent by a new player
          s.FLAG = _G.NPEV2_CHAT_USER_TAG_NEWCOMER
        end
      else
        s.FLAG = _G["CHAT_FLAG_" .. arg6]
      end

      s.Ff = ""
    end

    if arg15 then
      s.MOBILE = _G.ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)
    end

    local arg3 = safestr(arg3)
    if ((strlen(arg3) > 0) and (arg3 ~= "Universal") and (arg3 ~= frame.defaultLanguage)) then
      s.gG = "["
      s.LANGUAGE = arg3
      s.Gg = "] "
    else
      s.LANGUAGE_NOSHOW = arg3
    end

    local arg9 = safestr(arg9)
    if strlen(arg9) > 0 or chatGroup == "BN_CONVERSATION" then
      --            local bracket, post_bracket = string.match(s.TYPEPREFIX, "%[(.*)%](.*)")
      --            bracket = safestr(bracket)
      --            if strlen(bracket) > 0 then
      --                s.cC = "["
      --                s.Cc = "]"
      --                s.CHANNEL = bracket
      --                s.TYPEPREFIX = safestr(post_bracket)
      --            end



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
        s.CHANNEL, s.zZ, s.ZONE = string.match(arg9, "(.*)(%s%-%s)(.*)")

        if s.CHANNEL:len() == 0 then
          s.CHANNEL = arg9
        end

        s.CHANNEL = safestr(s.CHANNEL)
        s.zZ = safestr(s.zZ)
        s.ZONE = safestr(s.ZONE)
        s.Zz = ""
      elseif chatGroup == "COMMUNITIES_CHANNEL" then
        s.cC = "["
        s.Cc = "] "
        s.CHANNEL = _G.ChatFrame_ResolvePrefixedChannelName(arg4):match("%d%.%s+(.+)")
      else
        if strlen(arg9) > 0 then
          s.CHANNEL = arg9
          s.cC = "["
          s.Cc = "] "
        end
      end
    end


    --		local _, fontHeight = _G.GetChatWindowInfo(frame:GetID());
    --
    --		if ( fontHeight == 0 ) then
    --			--fontHeight will be 0 if it's still at the default (14)
    --			fontHeight = 14;
    --		end



    local arg7 = tonumber(arg7)
    -- 2.4
    -- Search for icon links and replace them with texture links.
    local term;

    for tag in string.gmatch(arg1, "%b{}") do
      term = strlower(string.gsub(tag, "[{}]", ""));
      if (not arg17 and _G.ICON_TAG_LIST[term] and _G.ICON_LIST[_G.ICON_TAG_LIST[term]]) then
        s.MESSAGE = string.gsub(s.MESSAGE, tag, _G.ICON_LIST[_G.ICON_TAG_LIST[term]] .. "0|t");
        --
        -- This would allow for ignoring unknown icon tags
        --
        --				else
        --					s.MESSAGE = string.gsub(s.MESSAGE, tag, "");
      elseif (_G.GROUP_TAG_LIST[term]) then
        local groupIndex = _G.GROUP_TAG_LIST[term];
        local groupList = "[";
        for i = 1, _G.GetNumGroupMembers() do
          local name, rank, subgroup, level, class, classFileName = _G.GetRaidRosterInfo(i);
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



    if type == "SYSTEM" or strsub(type, 1, 11) == "ACHIEVEMENT" or strsub(type, 1, 11) == "TARGETICONS" or strsub(type, 1, 18) == "GUILD_ACHIEVEMENT" then
      if strsub(type, 1, 11) == "ACHIEVEMENT" or strsub(type, 1, 18) == "GUILD_ACHIEVEMENT" then
        s.MESSAGE = s.MESSAGE:format("")
      end

      if (strsub(type, 1, 18) == "GUILD_ACHIEVEMENT") then
        if (_G.C_Social.IsSocialEnabled()) then
          local achieveID = _G.GetAchievementInfoFromHyperlink(arg1);
          if (achieveID) then
            local isGuildAchievement = select(12, _G.GetAchievementInfo(achieveID));
            if (isGuildAchievement) then
              s.MESSAGE = s.MESSAGE .. " " .. _G.Social_GetShareAchievementLink(achieveID, true);
            end
          end
        end
      end

      if (strsub(type, 1, 11) == "ACHIEVEMENT") then
        if (arg12 == _G.UnitGUID("player") and _G.C_Social.IsSocialEnabled()) then
          local achieveID = _G.GetAchievementInfoFromHyperlink(arg1);
          if (achieveID) then
            s.MESSAGE = s.MESSAGE .. " " .. _G.Social_GetShareAchievementLink(achieveID, true);
          end
        end
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

    s.ACCESSID = _G.ChatHistory_GetAccessID(chatGroup, chatTarget);
    s.TYPEID = _G.ChatHistory_GetAccessID(type, chatTarget, arg12 or arg13);

    SplitMessage.ORG = SplitMessageOrg

    s.INFO = info

    return SplitMessage, info
  end
end



