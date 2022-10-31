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
  local function dbg(...) end

  --@debug@
  function dbg(...) Prat:PrintLiteral(...) end

  --@end-debug@

  local PRAT_MODULE = Prat:RequestModuleName("Timestamps")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  -- define localized strings
  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Timestamps"] = true,
    ["Chat window timestamp options."] = true,
    ["Show Timestamp"] = true,
    ["Toggle showing timestamp for each window."] = true,
    ["show_name"] = "Show Timestamp",
    ["show_desc"] = "Toggle showing timestamp on and off for each window.",
    ["Set the timestamp format"] = true,
    ["Format All Timestamps"] = true,
    ["colortimestamp_name"] = "Color Timestamp",
    ["colortimestamp_desc"] = "Toggle coloring the timestamp on and off.",
    ["Set Timestamp Color"] = true,
    ["Sets the color of the timestamp."] = true,
    ["localtime_name"] = "Use Local Time",
    ["localtime_desc"] = "Toggle using local time on and off.",
    ["space_name"] = "Show Space",
    ["space_desc"] = "Toggle adding space after timestamp on and off.",
    ["twocolumn_name"] = "2 Column Chat",
    ["twocolumn_desc"] = "Place the timestamps in a separate column so the text does not wrap underneath them",
    ["HH:MM:SS AM (12-hour)"] = true,
    ["HH:MM:SS (12-hour)"] = true,
    ["HH:MM:SS (24-hour)"] = true,
    ["HH:MM AM (12-hour)"] = true,
    ["HH:MM (12-hour)"] = true,
    ["HH:MM (24-hour)"] = true,
    ["MM:SS"] = true,
    ["Post-Timestamp"] = true,
    ["Pre-Timestamp"] = true,
    ["Timestamp Text Format"] = true,
    ["Other Formatting Options"] = true,
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --[===[@non-debug@
  do
      local L

  
--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "enUS",L)


  
--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "frFR",L)


  
--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "deDE",L)


  
--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "koKR",L)


  
--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "esMX",L)


  
--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "ruRU",L)


  
--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "zhCN",L)


  
--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "esES",L)


  
--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Timestamps")@

    PL:AddLocale(PRAT_MODULE, "zhTW",L)


  end
  --@end-non-debug@]===]

  module.pluginopts = {}

  -- Chatter (Antiarc)
  local FORMATS = {
    ["%I:%M:%S %p"] = PL["HH:MM:SS AM (12-hour)"],
    ["%I:%M:%S"] = PL["HH:MM:SS (12-hour)"],
    ["%X"] = PL["HH:MM:SS (24-hour)"],
    ["%I:%M %p"] = PL["HH:MM AM (12-hour)"],
    ["%I:%M"] = PL["HH:MM (12-hour)"],
    ["%H:%M"] = PL["HH:MM (24-hour)"],
    ["%M:%S"] = PL["MM:SS"],
  }

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      show = { ["*"] = true },
      formatcode = "%X",
      formatpre = "[",
      formatpost = "]",
      ["timestampcolor"] = {
        ["b"] = 0.592156862745098,
        ["g"] = 0.592156862745098,
        ["r"] = 0.592156862745098,
        a = 1
      },
      colortimestamp = true,
      space = true,
      localtime = true,
      twocolumn = false,
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = PL["Timestamps"],
    desc = PL["Chat window timestamp options."],
    type = "group",
    plugins = module.pluginopts,
    args = {
      show = {
        name = PL["Show Timestamp"],
        desc = PL["Toggle showing timestamp for each window."],
        type = "multiselect",
        order = 120,
        values = Prat.HookedFrameList,
        get = "GetSubValue",
        set = "SetSubValue"
      },
      helpheader = {
        name = PL["Timestamp Text Format"],
        type = "header",
        order = 129,
      },
      formatpre = {
        name = PL["Pre-Timestamp"],
        desc = PL["Pre-Timestamp"],
        type = "input",
        order = 130,
        usage = "<string>",
      },
      formatcode = {
        name = PL["Format All Timestamps"],
        desc = PL["Set the timestamp format"],
        type = "select",
        order = 131,
        values = FORMATS,
      },
      formatpost = {
        name = PL["Post-Timestamp"],
        desc = PL["Post-Timestamp"],
        type = "input",
        order = 132,
        usage = "<string>",
      },
      colortimestamp = {
        name = PL["colortimestamp_name"],
        desc = PL["colortimestamp_desc"],
        type = "toggle",
        get = function(info) return info.handler:GetValue(info) end,
        order = 171,
      },
      localtime = {
        name = PL["localtime_name"],
        desc = PL["localtime_desc"],
        type = "toggle",
        order = 171,
      },
      space = {
        name = PL["space_name"],
        desc = PL["space_desc"],
        type = "toggle",
        order = 171,
      },
      otherheader = {
        name = PL["Other Formatting Options"],
        type = "header",
        order = 170,
      },
      timestampcolor = {
        name = PL["Set Timestamp Color"],
        desc = PL["Sets the color of the timestamp."],
        type = "color",
        order = 181,
        get = "GetColorValue",
        set = "SetColorValue",
        disabled = "IsTimestampPlain",
      },
    },
  })

  Prat:SetModuleInit(module, function(self)
    -- Disable blizz timestamps if possible
    if issecurevariable("ChatFrame_MessageEventHandler") then
      local proxy = { CHAT_TIMESTAMP_FORMAT = false } -- nil would defer to __index
      local CF_MEH_env = setmetatable(proxy, { __index = _G, __newindex = _G })
      setfenv(ChatFrame_MessageEventHandler, CF_MEH_env)
    else
      -- An addon has modified ChatFrame_MessageEventHandler and likely
      -- replaced / hooked it, so we can't setfenv the original function.
      -- TODO Print a warning
      self:Output("Could not install hook")
    end

    for name, v in pairs(Prat.HookedFrames) do
      self:SecureHook(v, "AddMessage")
    end
  end)

  function module:OnModuleEnable()
    for name, v in pairs(Prat.HookedFrames) do
      if not self:IsHooked(v, "AddMessage") then
        self:SecureHook(v, "AddMessage")
      end
    end
    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
  end

  function module:OnModuleDisable()
    for name, v in pairs(Prat.HookedFrames) do
      if self:IsHooked(v, "AddMessage") then
        self:Unhook(v, "AddMessage")
      end
    end
  end

  function module:GetDescription()
    return PL["Chat window timestamp options."]
  end

  function module:Prat_FramesUpdated(info, name, chatFrame, ...)
    if not self:IsHooked(chatFrame, "AddMessage") then
      self:SecureHook(chatFrame, "AddMessage")
    end
  end

  function module:Prat_FramesRemoved(info, name, chatFrame)
    if self:IsHooked(chatFrame, "AddMessage") then
      self:Unhook(chatFrame, "AddMessage")
    end
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --
  function module:AddMessage(frame, text, ...)
    if self.db.profile.on and self.db.profile.show and self.db.profile.show[frame:GetName()] and not Prat.loading then
      local entry = frame.historyBuffer:GetEntryAtIndex(1)
      if entry and text == entry.message then
        entry.message = self:InsertTimeStamp(entry.message, frame)
      end
    end
  end

  function module:IsTimestampPlain()
    return not self.db.profile.colortimestamp
  end

  local function Timestamp(text)
    if not module:IsTimestampPlain() then
      return Prat.CLR:Colorize(module.db.profile.timestampcolor, text)
    else
      return text
    end
  end

  function module:PlainTimestampNotAllowed()
    return false
  end

  function module:InsertTimeStamp(text, cf)
    if type(text) == "string" then
      local db = self.db.profile
      local space = db.space
      local fmt = db.formatpre .. db.formatcode .. db.formatpost

      if cf and cf:GetJustifyH() == "RIGHT" then
        text = text .. (space and " " or "") .. Timestamp(self:GetTime(fmt))
      else
        text = Timestamp(self:GetTime(fmt)) .. (space and " " or "") .. text
      end
    end

    return text
  end

  function module:GetTime(format)
    if self.db.profile.localtime then
      return date(format)
    else
      return date(format, GetServerTime())
    end
  end

  return
end) -- Prat:AddModuleToLoad
