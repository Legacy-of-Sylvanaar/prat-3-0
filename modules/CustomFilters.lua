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

  local PRAT_MODULE = Prat:RequestModuleName("CustomFilters")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "LibSink-2.0")

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["module_name"] = "CustomFilters",
    ["module_desc"] = "Module to support custom filters.",
    ["Add Pattern"] = true,
    ["Add a pattern to search for."] = true,
    ["Remove Pattern"] = true,
    ["Remove an existing pattern."] = true,
    ["Pattern Options"] = true,
    ["Inbound"] = true,
    ["Outbound"] = true,
    ["Search Pattern"] = true,
    ["Search Format String"] = true,
    ["Supplied pattern is a format string instead of a pattern"] = true,
    ["<string>"] = true,
    ["Replacement Text"] = true,
    ["Block Message"] = true,
    ["Prevent the message from being displayed"] = true,
    ["Hilight Match Text"] = true,
    ["Hilight Color"] = true,
    ["Secondary Output"] = true,
    ["Send to a secondary output"] = true,
    ["Play Sound"] = true,
    ["Play a sound when this message is output to the chatframe"] = true,
    ["Forward"] = true,
    ["ForwardMessage"] = true,
    ["Forward the message to a chat channel."] = true,
    ["Output Channel"] = true,
    ["Channel to send output text to."] = true,
    ["Channel Data"] = true,
    ["Extra data for WHISPER (target) and CHANNEL (channel name or num)"] = true,
    ["Output Message Only"] = true;
    ["Only output the message portion of the chat text, leave out the channel, and playername etc."] = true,
    ["Your name for this filter"] = true,
    ["Filter Name"] = true,
    ["Enabled"] = true,
    ["Is this pattern enabled for use?"] = true,
    ["Pattern Info"] = true,
    ["Match Options"] = true,
    ["inchannels_name"] = "Search Channels",
    ["inchannels_desc"] = "Search in certain channels",
    ["ForwardCustom"] = true,
    ["ForwardMessageCustom"] = "Private Channel",
    ["Forward the message to a custom chat channel."] = "Output to a private chat channel",
    chatframesink_name = "Chatframe",
    chatframesink_desc = "Output to a chat window"
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/

  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "enUS",L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "frFR",L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "deDE",L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "koKR",L)



--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "esMX",L)



--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "ruRU",L)



--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "zhCN",L)



--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "esES",L)



--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="CustomFilters")@

  PL:AddLocale(PRAT_MODULE, "zhTW",L)


end
--@end-non-debug@]===]


  local eventMap = {
    CHAT_MSG_CHANNEL_LIST = true,
    CHAT_MSG_SAY = true,
    CHAT_MSG_GUILD = true,
    CHAT_MSG_WHISPER_INFORM = true,
    CHAT_MSG_WHISPER = true,
    CHAT_MSG_YELL = true,
    CHAT_MSG_PARTY = true,
    CHAT_MSG_PARTY_LEADER = true,
    CHAT_MSG_OFFICER = true,
    CHAT_MSG_RAID = true,
    CHAT_MSG_RAID_LEADER = true,
    CHAT_MSG_INSTANCE_CHAT = true,
    CHAT_MSG_INSTANCE_CHAT_LEADER = true,
  }

  local eventTypes = {}
  local function getTypes()
    for k, v in pairs(ChatTypeGroup) do
      eventTypes[k] = _G["CHAT_MSG_" .. k]
    end
    for _, v in ipairs(Prat.GetChannelTable()) do
        eventTypes[v] = "Channel: " .. v
    end
    eventTypes.WHISPER_INFORM = CHAT_MSG_WHISPER_INFORM
    eventTypes.CHANNEL = CHANNEL
    return eventTypes
  end

  local newmap = {}
  for i, v in ipairs(eventMap) do
    newmap[v] = v
  end

  eventMap, newmap = newmap




  local patterndefaults = {
    ["*"] = {
      enabled = true,
      sink20OutputSink = "None",
      replacement_is_code = false,
      outputmessageonly = true,
      inchannels = {
        SYSTEM = true,
        SAY = true,
        EMOTE = true,
        YELL = true,
        WHISPER = true,
        WHISPER_INFORM = true,
        PARTY = true,
        RAID = true,
        RAID_LEADER = true,
        RAID_WARNING = true,
        INSTANCE_CHAT = true,
        INSTANCE_CHAT_LEADER = true,
        GUILD = true,
        GUILD_OFFICER = true,
        MONSTER_SAY = true,
        MONSTER_YELL = true,
        MONSTER_EMOTE = true,
        MONSTER_WHISPER = true,
        MONSTER_BOSS_EMOTE = true,
        MONSTER_BOSS_WHISPER = true,
        ERRORS = true,
        AFK = true,
        DND = true,
        IGNORED = true,
        BG_HORDE = true,
        BG_ALLIANCE = true,
        BG_NEUTRAL = true,
        COMBAT_XP_GAIN = true,
        COMBAT_HONOR_GAIN = true,
        COMBAT_FACTION_CHANGE = true,
        SKILL = true,
        MONEY = true,
        OPENING = true,
        TRADESKILLS = true,
        PET_INFO = true,
        COMBAT_MISC_INFO = true,
        ACHIEVEMENT = true,
        GUILD_ACHIEVEMENT = true,
        CHANNEL = true,
      }
    }
  }
  Prat:SetModuleDefaults(module, {
    profile = {
      on = false,
      inbound = patterndefaults,
      outbound = patterndefaults,
      outputchannel = CHAT_MSG_SAY,
      outputchanneldata = "",
      sinkoptions = {}
    }
  })

  local modeOptions = {
    mode = {
      inbound = {
        type = "group",
        name = PL["Inbound"],
        desc = PL["Inbound"],
        args = {}
      },
      outbound = {
        type = "group",
        name = PL["Outbound"],
        desc = PL["Outbound"],
        args = {}
      },
    }
  }

  Prat:SetModuleOptions(module, {
    name = PL["module_name"],
    desc = PL["module_desc"],
    type = "group",
    plugins = modeOptions,
    args = {
      outputchannel = {
        type = "select",
        name = PL["Output Channel"],
        desc = PL["Channel to send output text to."],
        order = 110,
        values = eventMap,
      },
      outputchanneldata = {
        type = "input",
        order = 115,
        name = PL["Channel Data"],
        desc = PL["Extra data for WHISPER (target) and CHANNEL (channel name or num)"],
        usage = "<string>",
        disabled = function(info) return not (info.handler.db.profile.outputchannel == CHAT_MSG_WHISPER_INFORM or
          info.handler.db.profile.outputchannel == CHAT_MSG_CHANNEL_LIST)
        end
      },
      outputmessageonly = {
        type = "toggle",
        name = PL["Output Message Only"],
        desc = PL["Only output the message portion of the chat text, leave out the channel, and playername etc."],
        order = 118,
      }
    }
  })


  function module:BuildModeOptions(mode, opts)
    local mode = mode
    local po = opts[mode].args


    self[mode] = {}
    self[mode].validate = {}

    --    po.pathdr = {
    --        type = "header",
    --        name = PL["Pattern Options"],
    --        order = 80,
    --    }

    for k, v in pairs(self.db.profile[mode]) do
      self:AddPatternOptions(po, v.name or k, mode, k)
      self[mode].validate[k] = v.name or k
    end

    --    po.opspc = {
    --        type = "header",
    --        order = 94,
    --    }

    po.addpattern = {
      name = PL["Add Pattern"],
      desc = PL["Add a pattern to search for."],
      type = "input",
      usage = PL["<string>"],
      get = false,
      set = "AddPattern"
    }

    po.removepattern = {
      name = PL["Remove Pattern"],
      desc = PL["Remove an existing pattern."],
      type = "select",
      get = function(info) return "" end,
      set = "RemovePattern",
      values = self[mode].validate,
      disabled = function(info)
        local mode = info[#info - 1]
        for k, v in pairs(info.handler.db.profile[mode]) do
          return false
        end return true
      end,
    }
  end

  function module:DisableOutputOption(info)
    return not self.db.profile[info[#info - 3]][info[#info - 2]].tosink
  end

  function module:AddPatternOptions(o, pattern, mode, key)
    key = key or pattern
    o[key] = o[key] or {}
    local po = o[key]
    local settings = self.db.profile[mode][key]
    local mode = mode
    local pattern = pattern
    po.type = "group"
    po.name = pattern
    po.desc = pattern
    po.order = 90

    po.args = {
      name = {
        order = 1,
        type = "input",
        name = PL["Filter Name"],
        desc = PL["Your name for this filter"],
        get = "GetPatternValue",
        set = "UpdatePatternValue",
      },
      enabled = {
        order = 5,
        type = "toggle",
        name = PL["Enabled"],
        desc = PL["Is this pattern enabled for use?"],
        get = "GetPatternValue",
        set = "UpdatePatternValue",
      },
      opspc9 = {
        name = PL["Pattern Info"],
        type = "header",
        order = 9,
      },
      searchfor = {
        order = 10,
        type = "input",
        name = PL["Search Pattern"],
        desc = PL["Search Pattern"],
        usage = PL["<string>"],
        get = "GetPatternValue",
        set = "UpdatePatternValue"
      },
      inchannels = {
        name = PL["inchannels_name"],
        desc = PL["inchannels_desc"],
        type = "multiselect",
        order = 110,
        values = getTypes(),
        get = "GetChannelPatternSubValue",
        set = "SetChannelPatternSubValue",
      },
      --        searchfordeformat = {
      --            type = "toggle",
      --            name = PL["Search Format String"],
      --            desc = PL["SuPLied pattern is a format string instead of a pattern"],
      --            get = "GetPatternValue",
      --            set = "UpdatePatternValue"
      --            },
      replacewith = {
        order = 20,
        type = "input",
        name = PL["Replacement Text"],
        desc = PL["Replacement Text"],
        usage = PL["<string>"],
        get = "GetPatternValue",
        set = "UpdatePatternValue",
        disabled = "GetDisableReplace",
      },
      opspc29 = {
        name = PL["Match Options"],
        type = "header",
        order = 29,
      },
      block = {
        type = "toggle",
        name = PL["Block Message"],
        desc = PL["Prevent the message from being displayed"],
        get = "GetPatternValue",
        set = "SetPatternValue"
      },
      tosink = {
        type = "toggle",
        name = PL["Secondary Output"],
        desc = PL["Send to a secondary output"],
        get = "GetPatternValue",
        set = "SetPatternValue"
      },
      sound = {
        type = "select",
        name = PL["Play Sound"],
        desc = PL["Play a sound when this message is output to the chatframe"],
        dialogControl = 'LSM30_Sound',
        get = "GetPatternValue",
        set = "SetPatternValue",
        values = AceGUIWidgetLSMlists.sound,
      },
      hilight = {
        type = "toggle",
        name = PL["Hilight Match Text"],
        desc = PL["Hilight Match Text"],
        get = "GetPatternValue",
        set = "UpdatePatternValue",
        disabled = "GetBlockMessage",
      },
      hilight_color = {
        type = "color",
        name = PL["Hilight Color"],
        desc = PL["Hilight Color"],
        get = "GetPatternColorValue",
        set = "SetPatternColorValue",
        disabled = "GetBlockMessage",
      },
      replacement_is_code = {
        type = "toggle",
        get = "GetPatternValue",
        set = "SetPatternValue",
        name = "Replacement is Lua code",
        desc = "Replacement is Lua code",
      }
    }

    self.SetSinkStorage(settings, settings)

    po.args.outputmessageonly = {
      type = "toggle",
      name = PL["Output Message Only"],
      desc = PL["Only output the message portion of the chat text, leave out the channel, and playername etc."],
      order = 190,
      get = "GetPatternValue",
      set = "UpdatePatternValue",
    }
    po.args.output = self.GetSinkAce3OptionsDataTable(settings)
    po.args.output.inline = true
    po.args.output.order = 200
    po.args.output.disabled = "DisableOutputOption"
  end

  local CLR = Prat.CLR

  local function match(text, matchopts, mode)
    if (not matchopts) or (not matchopts.enabled) then return end

    local matchtype
    if mode == "inbound" then
      matchtype = "FRAME"
    else
      matchtype = "OUTBOUND"
    end

    local textout = text

    if mode == "inbound" then
      local chatype = Prat.SplitMessage.CHATTYPE
      local typeopt = matchopts.inchannels[chatype]

      if Prat.SplitMessage.CHATTYPE == "CHANNEL" then
        local channelopt = matchopts.inchannels[Prat.SplitMessage.ORG.CHANNEL]

        if channelopt == false then return end
        if channelopt == nil and not typeopt then return end
      else
        if typeopt == false then
          return
        end
      end
    end

    if matchopts.replacewith and matchopts.replacewith ~= matchopts.searchfor then
      if matchopts.replacement_is_code then
        textout = loadstring(matchopts.replacewith)(text)
      else
        textout = textout:gsub(matchopts.searchfor, matchopts.replacewith)
      end
    end

    if matchopts.hilight then
      local hexcolor = CLR:GetHexColor(matchopts.hilight_color)
      textout = CLR:Colorize(hexcolor, textout)
    end

    if matchopts.sink20OutputSink then
      if mode == "inbound" then
        Prat.SplitMessage.CF_SINK_OUT = matchopts
      else
        Prat.SplitMessageOut.CF_SINK_OUT = matchopts
      end
    end

    if matchopts.tosink then
      if mode == "inbound" then
        Prat.SplitMessage.CF_SINK = true
      else
        Prat.SplitMessageOut.CF_SINK = true
      end
    end

    if matchopts.sound then
      if mode == "inbound" then
        Prat.SplitMessage.CF_SOUND = matchopts.sound
      else
        Prat.SplitMessageOut.CF_SOUND = matchopts.sound
      end
    end

    if matchopts.block then
      if mode == "inbound" then
        Prat.SplitMessage.DONOTPROCESS = true
      else
        Prat.SplitMessageOut.DONOTPROCESS = true
      end
    end


    textout = Prat:RegisterMatch(textout, matchtype)
    --  end

    return textout
  end



  function module:RegisterPattern(matchopts, mode)
    local mode = mode
    local matchopts = matchopts
    local matchtype
    if mode == "inbound" then
      matchtype = "FRAME"
    else
      matchtype = "OUTBOUND"
    end
    local patterninfo = {
      pattern = matchopts.searchfor,
      matchopts = matchopts,
      matchfunc =
      function(text, ...)
        local mode = mode
        local matchopts = matchopts
        return match(text, matchopts, mode)
      end,
      type = matchtype,
      deformat = matchopts.deformat,
      priority = 46
    }

    Prat.RegisterPattern(patterninfo, self.name)

    table.insert(self.modulePatterns, patterninfo)
  end

  function module:UnregisterPattern(matchopts)
    local patterninfo
    for _, v in pairs(self.modulePatterns) do
      if v.matchopts == matchopts then
        patterninfo = v
      end
    end

    if patterninfo == nil then return end

    if patterninfo.idx then
      Prat.UnregisterPattern(patterninfo.idx)
    end

    local idx
    for k, v in pairs(self.modulePatterns) do
      if v == patterninfo then
        idx = k
      end
    end

    table.remove(self.modulePatterns, idx)
  end

  function module:UpdatePattern(matchopts)
    local patterninfo
    for _, v in pairs(self.modulePatterns) do
      if v.matchopts == matchopts then
        patterninfo = v
      end
    end

    if patterninfo == nil then return end

    local mode
    local matchopts = matchopts
    if patterninfo.type == "FRAME" then
      mode = "inbound"
    else
      mode = "outbound"
    end

    patterninfo.pattern = matchopts.searchfor
    patterninfo.deformat = matchopts.deformat
    patterninfo.matchfunc =
    function(text, ...)
      return match(text, matchopts, mode)
    end
  end

  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  Prat:SetModuleInit(module,
    function(self)
      --      local function tailChan(t, cnum, cname, ...)
      --        if not cnum then return t end
      --        if Prat.IsPrivateChannel(cnum) then
      --          t[#t + 1] = cname
      --        end
      --        return tailChan(t, ...)
      --      end
      --
      --      self:RegisterSink(PL["ForwardCustom"],
      --        PL["ForwardMessageCustom"],
      --        PL["Forward the message to a custom chat channel."],
      --        "ForwardCustom",
      --        function() return tailChan({}, GetChannelList()) end)

      self:RegisterSink(PL.chatframesink_name,
        PL.chatframesink_name,
        PL.chatframesink_desc,
        "ChatframeSink",
        function()
          local keys = {}
          for k, v in pairs(Prat.HookedFrames) do
            if not v.isTemporary and (v:IsShown() or v.isDocked) then
              keys[#keys + 1] = v.name or k
            end
          end

          return keys
        end)


      local modeOpts = modeOptions.mode
      for k, v in pairs(modeOpts) do
        self:BuildModeOptions(k, modeOpts)
      end

      self:SetSinkStorage(self.db.profile.sinkoptions)
      modeOpts.output = self:GetSinkAce3OptionsDataTable()
      modeOpts.output.inline = true
    end)

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    self.modulePatterns = {}
    local modeOpts = modeOptions.mode
    local mode
    for mode, _ in pairs(modeOpts) do
      if type(self.db.profile[mode]) == "table" then
        local patopts
        for _, patopts in pairs(self.db.profile[mode]) do
          if patopts.enabled then
            self:RegisterPattern(patopts, mode)
          end
        end
      end
    end

    Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE)
    Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE_BLOCKED, "Prat_PostAddMessage")
  end


  function module:OnModuleDisable()
    self.modulePatterns = nil
    Prat.UnregisterAllChatEvents(self)
  end

  function module:Prat_PostAddMessage(info, message, frame, event, text, r, g, b, id)
    local uid = message.LINE_ID
    if uid and
      uid == self.lastevent and
      self.lasteventtype == event then
      return
    end

    self.lasteventtype = event
    self.lastevent = uid

    if message.CF_SINK or message.CF_SINK_OUT then
      if message.CF_SINK_OUT.outputmessageonly then
        self.Pour(message.CF_SINK_OUT or self, message.MESSAGE, r, g, b)
      else
        self.Pour(message.CF_SINK_OUT or self, text, r, g, b)
      end
    end

    if message.CF_SOUND then
      Prat:PlaySound(message.CF_SOUND)
    end
  end


  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function module:GetPatternValue(info)
    return self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
  end

  function module:UpdatePatternValue(info, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = v
    self:UpdatePattern(self.db.profile[info[#info - 2]][info[#info - 1]])
  end

  function module:SetPatternValue(info, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = v
  end

  function module:GetPatternSubValue(info, val)
    return self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]][val]
  end

  function module:SetPatternSubValue(info, val, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]][val] = v
  end

  function module:GetChannelPatternSubValue(info, val)
    local v = self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]][val]

    if ChatTypeGroup[val] or v ~= nil then return v end

    return  self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]["CHANNEL"]
  end

  function module:SetChannelPatternSubValue(info, val, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]][val] = v
  end

  function module:SetPatternName(info, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = v
  end

  local defclr = { r = 1, b = 1, g = 1, a = 1 }
  function module:GetPatternColorValue(info)
    local c = self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
    if c == nil then
      self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = { r = 1, g = 1, b = 1, a = 1 }
      c = self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
    end
    return c.r, c.g, c.b, c.a
  end

  function module:SetPatternColorValue(info, r, g, b, a)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = { r = r, g = g, b = b, a = a }
  end


  function module:GetPatternSearch(info)
    return self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
  end

  function module:SetPatternSearch(info, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = v
    self:UpdatePattern(self.db.profile[info[#info - 2]][info[#info - 1]])
  end

  function module:GetPatternReplace(info)
    return self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
  end

  function module:SetPatternReplace(info, v)
    self.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = v
    self:UpdatePattern(self.db.profile[info[#info - 2]][info[#info - 1]])
  end

  function module:GetPatternHilight(p)
    return p.hilight
  end

  function module:SetPatternHilight(p, v)
    p.hilight = v

    self:UpdatePattern(p)
  end

  function module:GetDisableReplace(p)
    return p.block or p.tosink
  end

  function module:GetBlockMessage(p)
    return p.block
  end

  function module:SetBlockMessage(p, v)
    p.block = v
  end

  function module:GetSinkMessage(p)
    return p.tosink
  end

  function module:SetSinkMessage(p, v)
    p.tosink = v
  end

  function module:GetSoundMessage(p)
    return p.sound
  end

  function module:SetSoundMessage(p, v)
    p.sound = v

    Prat:PlaySound(v)
  end


  local white_clr = { r = 1.0, b = 1.0, g = 1.0 }
  function module:GetPatternHilightClr(p)
    local h = p.hilight_color or white_clr
    return h.r or 1.0, h.g or 1.0, h.b or 1.0
  end

  function module:SetPatternHilightClr(p, r, g, b)
    p.hilight_color = p.hilight_color or {}
    local h = p.hilight_color
    h.r, h.g, h.b = r, g, b

    self:UpdatePattern(p)
  end



  function module:AddPattern(info, pattern)
    local mode = info[#info - 1]
    local p = self.db.profile[mode]

    for k, v in pairs(p) do
      if v.name == pattern then
        return
      end
    end


    self[mode].validate = self[mode].validate or {}
    local v = self[mode].validate


    local num = 0
    while rawget(p, "pat" .. num) ~= nil do
      num = num + 1
    end

    local key = "pat" .. num

    p[key] = p[key] or {}
    p[key].name = pattern
    p[key].searchfor = pattern
    p[key].replacewith = "%1"

    v[key] = pattern

    local o = modeOptions.mode[mode].args
    self:AddPatternOptions(o, pattern, mode, key)

    self:RegisterPattern(p[key], mode)

    self:RefreshOptions()
  end

  function module:RemovePattern(info, pattern)
    local mode = info[#info - 1]
    local p = self.db.profile[mode]

    local v = self[mode].validate
    local key, name

    if type(pattern) == "number" then
      name = v[pattern]
    else
      name = pattern
    end


    for k, v in pairs(p) do
      if k == name then
        key = k
        break
      end

      if v.name == name then
        key = k
        break
      end
    end

    if key == nil then return end

    self:UnregisterPattern(p[key])

    p[key] = nil

    modeOptions.mode[mode].args = {}

    self:BuildModeOptions(mode, modeOptions.mode)

    self:RefreshOptions()
  end

  function module:RefreshOptions()
    LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
  end

  --  local sink
  --  function module:ForwardCustom(source, text, ...)
  --    sink = sink or LibStub("LibSink-2.0")
  --    local s = sink.storageForAddon[source]
  --    local loc = s and s.sink20ScrollArea or ""
  --    local cnum = Prat.GetChannelName(loc)
  --
  --    if cnum and cnum > 0 then
  --      local cleantext = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
  --
  --      SendChatMessage(cleantext, "CHANNEL", GetDefaultLanguage("player"), cnum)
  --    end
  --  end
  --
  --  --msg, chatType, language, channel)
  --  function module:Forward(source, text, r, g, b, ...)
  --    local cleantext = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
  --
  --    if self.db.profile.outputchannel == CHAT_MSG_WHISPER_INFORM then
  --      SendChatMessage(cleantext, "WHISPER", GetDefaultLanguage("player"), self.db.profile.outputchanneldata)
  --    elseif self.db.profile.outputchannel == CHAT_MSG_CHANNEL_LIST then
  --      SendChatMessage(cleantext, "CHANNEL", GetDefaultLanguage("player"), Prat.GetChannelName(self.db.profile.outputchanneldata))
  --    else
  --      local chatType = strsub(self.db.profile.outputchannel, 10)
  --      SendChatMessage(cleantext, chatType, GetDefaultLanguage("player"))
  --    end
  --  end

  function module:ChatframeSink(source, text, r, g, b, ...)
    local sink = LibStub("LibSink-2.0")
    local s = sink.storageForAddon[source]
    local name = s and s.sink20ScrollArea or ""

    for k, v in pairs(Prat.HookedFrames) do
      if k == name or v.name == name then
        v:AddMessage(text, r, g, b)
        return
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad