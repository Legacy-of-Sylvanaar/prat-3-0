---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2018  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc., 
-- 51 Franklin Street, Fifth Floor, 
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------





Prat:AddModuleToLoad(function()

  local PRAT_MODULE = Prat:RequestModuleName("Filtering")

  if PRAT_MODULE == nil then
    return
  end

  local dbg = function() end
  --@debug@
--  dbg = function(...) Prat:PrintLiteral(...) end
  --@end-debug@

  local module = Prat:NewModule(PRAT_MODULE, "AceEvent-3.0")

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Filtering"] = true,
    ["A module to provide basic chat filtering."] = true,
    ["leavejoin_name"] = "Filter Channel Leave/Join",
    ["leavejoin_desc"] = "Filter out channel leave/join spam",
    ["notices_name"] = "Filter Channel Notices",
    ["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
    ["bgjoin_name"] = "Filter BG Leave/Join",
    ["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
    ["tradespam_name"] = "Throttle Spam",
    ["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
    ["afkdnd_name"] = "Throttle AFK and DND messages.",
    ["afkdnd_desc"] = "Throttle AFK and DND messages.",
    ["useai_desc"] = "Use a spam filter based on machine learning",
    ["useai_name"] = "AI Spam Filter",
    ["training_desc"] = "Show the AI training UI",
    ["training_name"] = "AI Training",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Filtering")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]



  Prat:SetModuleDefaults(module, {
    profile = {
      on = false,
      leavejoin = true,
      notices = true,
      tradespam = false,
      afkdnd = false,
      training = false,
      useai = true,
    }
  })

  Prat:SetModuleOptions(module, {
    name = PL["Filtering"],
    desc = PL["A module to provide basic chat filtering."],
    type = "group",
    args = {
      --		    leavejoin = {
      --				name = PL["leavejoin_name"],
      --				desc = PL["leavejoin_desc"],
      --				type = "toggle",
      --				order = 100
      --			},
      notices = {
        name = PL["notices_name"],
        desc = PL["notices_desc"],
        type = "toggle",
        order = 110
      },
      tradespam = {
        name = PL["tradespam_name"],
        desc = PL["tradespam_desc"],
        type = "toggle",
        order = 115
      },
      afkdnd = {
        name = PL["afkdnd_name"],
        desc = PL["afkdnd_desc"],
        type = "toggle",
        order = 115
      },
      useai = {
        name = PL["useai_name"],
        desc = PL["useai_desc"],
        type = "toggle",
        order = 117
      },
      training = {
        name = PL["training_name"],
        desc = PL["training_desc"],
        type = "toggle",
        order = 118
      },

      --		    bgjoin = {
      --				name = PL["bgjoin_name"],
      --				desc = PL["bgjoin_desc"],
      --				type = "toggle",
      --				order = 111
      --			},
    }
  })

  local THROTTLE_TIME = 120

  local MessageTime = {}

  local function cleanText(msg, author)
    local cleanmsg = msg:gsub("...hic!", ""):gsub("%d", ""):gsub("%c", ""):gsub("%p", ""):gsub("%s", ""):upper():gsub("SH", "S");
    return (author and author:upper() or "") .. cleanmsg;
  end

  --function tradeSpamFilter(frame, event, ...)
  --    local arg1, arg2 = ...
  --	local block = false;
  --	local msg = cleanText(arg1, arg2);
  --
  --	if arg2 == UnitName("player") then
  --		return false, ...
  --	end
  --
  --	if MessageTime[msg] then
  --		if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then
  --			block = true;
  --		else
  --		    MessageTime[msg] = nil
  --		end
  --	else
  --    	MessageTime[msg] = time();
  --	end
  --
  --	if block then
  --	    print("Filtered: "..msg)
  --		return true
  --	end
  --
  --
  --
  --	return false, ...
  --end


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --
  function module:OnModuleEnable()
    Prat.RegisterMessageItem("SPAMPROB", "PRE", "after")
    self.classifier = Prat.GetClassifier(self.db.global)
    self.throttleFrame = self.throttleFrame or CreateFrame("FRAME");
    self.lineTable = {}
    self.trainTable = {}
    self.throttle = THROTTLE_TIME

    self.throttleFrame:SetScript("OnUpdate",
      function(frame, elapsed)
        self.throttle = self.throttle - elapsed
        if frame:IsShown() and self.throttle < 0 then
          self.throttle = THROTTLE_TIME
          self:PruneMessages()
        end
      end)

    --    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
    --    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)

    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
    Prat.RegisterLinkType({ linkid = "pratfilter", linkfunc = module.PratFilter, handler = module }, module.name)
  end

  -- things to do when the module is disabled
  function module:OnModuleDisable()
    self.lineTable = nil
    self.trainTable = nil
    --    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
    --    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)

    Prat.UnregisterAllChatEvents(self)
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --


  function module:PratFilter(data, frame)
    local _, id, found = strsplit(":", data)
    found = tonumber(found) == 1 and true or false
    self:ToggleLearn(id, found, frame)
    return false
  end

  function module:GetDescription()
    return PL["A module to provide basic chat filtering."]
  end

  function module:PruneMessages()
    for k, v in pairs(MessageTime) do
      if difftime(time(), v) > THROTTLE_TIME then
        MessageTime[k] = nil
      end
    end
  end

  local function string_split(text, sep, pattern)
    local sep, fields = sep or " ", {}
    local patt = pattern or ("([^%s]+)"):format(sep)
    text:gsub(patt, function(c) fields[#fields + 1] = c:lower() end)
    return fields
  end

  local function tokenize(msg)
    return string_split(msg, nil, "([^%s%p%c]+)") -- obfuscations removal
  end

  local CLR = Prat.CLR

  function module:AdjustScore(id, frame)
    id = tonumber(id)
    local text = self.lineTable[id]
    local prob = self.classifier.getprob(tokenize(text))
    for i,v in ipairs(frame.visibleLines) do
      local mi = v.messageInfo
      local m = mi.message
      if m:match(("pratfilter:%d"):format(id)) then
        mi.message = m:gsub("|c%x-%d+%%%x-|r", CLR:Probability(FormatPercentage(prob), prob):gsub("%%", "%%%%"))
        break
      end
    end
  end

  function module:Learn(id, found, frame)
    id = tonumber(id)
    local text = self.lineTable[id]
    dbg(text, id)
    if not text then return end
    local learned = self.trainTable[id]
    if learned ~= nil then
      self.classifier.unlearn(tokenize(text), learned)
    end
    self:Output(frame, "learning " .. text .. " as " .. CLR:Probability(found and "SPAM" or "NOT SPAM", found and 1 or 0))
    self.trainTable[id] = found or false
    self.classifier.learn(tokenize(text), found)
    self:AdjustScore(id, frame)
  end

  function module:Unlearn(id, found, frame)
    id = tonumber(id)
    local text = self.lineTable[id]
    dbg(text, id)
    if not text then return end
    local learned = self.trainTable[id]
    self.trainTable[id] = nil
    if learned ~= nil then
      self.classifier.unlearn(tokenize(text), learned)
    end
    self:Output(frame, "Unlearning " .. text .. " as " .. CLR:Probability(found and "SPAM" or "NOT SPAM", found and 1 or 0))
    self.classifier.unlearn(tokenize(text), found)
    self:AdjustScore(id, frame)
  end

  function module:ToggleLearn(id, found, frame)
    id = tonumber(id)
    dbg("ToggleLearn", id, found)
    local learned = self.trainTable[id]
    if learned ~= nil then
      self:Unlearn(id, learned, frame)
      return
    end

    self:Learn(id, found, frame)
  end

  local SPAM_CUTOFF = 0.90
  local HAM_CUTOFF = 0.20


  function CLR:Bracket(text) return self:Colorize({
    r = 0.85,
    g = 0.85,
    b = 0.85,
    a = 1.0
  }, text)
  end

  function CLR:Probability(text, prob)
    local isHam = prob <= HAM_CUTOFF
    local isSpam = prob >= SPAM_CUTOFF

    local color = isHam and "40ff40" or isSpam and "ff4040" or "a0a0a0"
    return self:Colorize(color, text)
  end

  local eventsToHandle = {
    CHAT_MSG_CHANNEL = true
  }

  function module:Prat_FrameMessage(arg, message, frame, event)
    if self.db.profile.useai and  eventsToHandle[event] and message.GUID ~= UnitGUID("player") then
      local msg = tokenize(message.ORG.MESSAGE)
      local prob = self.classifier.getprob(msg)
      --    dbg("filter:fraee", prob, msg)
      local isHam = prob <= HAM_CUTOFF
      local isSpam = prob >= SPAM_CUTOFF
      if self.db.profile.training then
        self.lineTable[message.LINE_ID] = message.ORG.MESSAGE
        message.SPAMPROB = ("|cff40ff40|Hpratfilter:%d:0|h[--]|h|r" .. CLR:Bracket("[") .. "%s" .. CLR:Bracket("]") .. "|cffff4040|Hpratfilter:%d:1|h[++]|h|r ")
          :format(message.LINE_ID, CLR:Probability(FormatPercentage(prob), prob), message.LINE_ID)
      else
        if isSpam then
          message.DONOTPROCESS = true
        end
      end
    end

    local newEvent = true
    if message.LINE_ID and
      message.LINE_ID == self.lastevent and
      self.lasteventtype == event then
      newEvent = false
    end

    if self.db.profile.tradespam then
      if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" then
        local msg = cleanText(message.ORG.MESSAGE, message.ORG.PLAYER)

        if message.ORG.PLAYER ~= UnitName("player") then
          if newEvent and MessageTime[msg] then
            if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then
              message.DONOTPROCESS = true
            else
              MessageTime[msg] = nil
            end
          else
            self.lasteventtype = event
            self.lastevent = message.LINE_ID
            MessageTime[msg] = time();
          end
        end
      end
    end

    if self.db.profile.afkdnd then
      if event == "CHAT_MSG_AFK" or event == "CHAT_MSG_DND" then
        local msg = cleanText(message.ORG.MESSAGE, message.ORG.PLAYER)

        if newEvent and MessageTime[msg] then
          if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then
            message.DONOTPROCESS = true
          else
            MessageTime[msg] = nil
          end
        else
          self.lasteventtype = event
          self.lastevent = message.LINE_ID
          MessageTime[msg] = time();
        end
      end
    end



    if self.db.profile.notices then
      if event == "CHAT_MSG_CHANNEL_NOTICE_USER" or event == "CHAT_MSG_CHANNEL_NOTICE" then
        message.DONOTPROCESS = true
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad