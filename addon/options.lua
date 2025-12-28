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



--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local _G = _G
local LibStub = LibStub
local tonumber = tonumber
local tostring = tostring
local pairs = pairs
local type = type
local Prat = select(2, ...)
local setmetatable = setmetatable
local tinsert = tinsert

--[[ END STANDARD HEADER ]] --

local PL = Prat.Localizations


--@debug@
PL:AddLocale(nil, "enUS", {
  prat = "Prat",
  ["display_name"] = "Display Settings",
  ["display_desc"] = "Chat Frame Control and Look",
  ["formatting_name"] = "Chat Formatting",
  ["formatting_desc"] = "Change the way the lines look and feel",
  ["extras_name"] = "Extra Stuff",
  ["extras_desc"] = "Msc. Modules",
  ["modulecontrol_name"] = "Module Control",
  ["modulecontrol_desc"] = "Control the loading and enabling of Prat's modules.",
  ["reload_required"] = "This option change may not take full effect until you %s your UI.",
  load_no = "Don't Load",
  load_disabled = "Disabled",
  load_enabled = "Enabled",
  load_desc = "Control the load behavior for this module.",
  unloaded_desc = "Module is not loaded, load it to see description",
  load_disabledonrestart = "Disabled (reload)",
  load_enabledonrestart = "Enabled (reload)",
})
--@end-debug@

-- These Localizations are auto-generated. To help with localization
-- please go to http://www.wowace.com/projects/prat-3-0/localization/


--[===[@non-debug@
do
  local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "enUS",L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "frFR",L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "deDE",L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "koKR",L)



--@localization(locale="esMX", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "esMX",L)



--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "ruRU",L)



--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "zhCN",L)



--@localization(locale="esES", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "esES",L)



--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "zhTW",L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "itIT",L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@

PL:AddLocale(nil, "ptBR",L)


end
--@end-non-debug@]===]


local AceConfig = LibStub("AceConfig-3.0")
--local AceConfigDialog = LibStub("AceConfigDialog-3.0")
--local AceConfigCmd = LibStub("AceConfigCmd-3.0")

local moduleControlArgs = {}

Prat.Options = {
  type = "group",
  childGroups = "tab",
  get = "GetValue",
  set = "SetValue",
  args = {
    display = {
      type = "group",
      name = PL["display_name"],
      desc = PL["display_desc"],
      hidden = function(info) end,
      get = "GetValue",
      set = "SetValue",
      args = {},
      order = 1,
    },
    formatting = {
      type = "group",
      name = PL["formatting_name"],
      desc = PL["formatting_desc"],
      hidden = function(info) end,
      get = "GetValue",
      set = "SetValue",
      args = {},
      order = 2,
    },
    extras = {
      type = "group",
      name = PL["extras_name"],
      desc = PL["extras_desc"],
      hidden = function(info) end,
      get = "GetValue",
      set = "SetValue",
      args = {},
      order = 3,
    },
    modulecontrol = {
      type = "group",
      name = PL["modulecontrol_name"],
      desc = PL["modulecontrol_desc"],
      get = "GetValue",
      set = "SetValue",
      args = moduleControlArgs,
      order = 4,
    }
  }
}

--[[ WitchHunt: [Ammo] ]] --
tinsert(Prat.EnableTasks, function(self)

  local acreg = LibStub("AceConfigRegistry-3.0")
  acreg:RegisterOptionsTable(PL.prat, Prat.Options)
  acreg:RegisterOptionsTable(PL.prat .. ": " .. Prat.Options.args.display.name, Prat.Options.args.display)
  acreg:RegisterOptionsTable(PL.prat .. ": " .. Prat.Options.args.formatting.name, Prat.Options.args.formatting)
  acreg:RegisterOptionsTable(PL.prat .. ": " .. Prat.Options.args.extras.name, Prat.Options.args.extras)
  acreg:RegisterOptionsTable(PL.prat .. ": " .. Prat.Options.args.modulecontrol.name, Prat.Options.args.modulecontrol)
  acreg:RegisterOptionsTable("Prat: " .. Prat.Options.args.profiles.name, Prat.Options.args.profiles)

  local acdia = LibStub("AceConfigDialog-3.0")
  acdia:AddToBlizOptions(PL.prat, PL.prat)
  acdia:AddToBlizOptions(PL.prat .. ": " .. Prat.Options.args.display.name, Prat.Options.args.display.name, PL.prat)
  acdia:AddToBlizOptions(PL.prat .. ": " .. Prat.Options.args.formatting.name, Prat.Options.args.formatting.name, PL.prat)
  acdia:AddToBlizOptions(PL.prat .. ": " .. Prat.Options.args.extras.name, Prat.Options.args.extras.name, PL.prat)
  acdia:AddToBlizOptions(PL.prat .. ": " .. Prat.Options.args.modulecontrol.name, Prat.Options.args.modulecontrol.name, PL.prat)
  acdia:AddToBlizOptions(PL.prat .. ": " .. Prat.Options.args.profiles.name, Prat.Options.args.profiles.name, PL.prat)

  self:RegisterChatCommand(PL.prat, function() Prat.ToggleOptionsWindow() end)
end)


do
  local function getModuleFromShortName(shortname)
    for k, v in Prat.Addon:IterateModules() do
      if v.moduleName == shortname then
        return v
      end
    end
  end

  local lastReloadMessage = 0
  local function PrintReloadMessage()
    local tm = _G.GetTime()
    if tm - lastReloadMessage > 60 then
      Prat:Print(PL.reload_required:format("reload"))
      lastReloadMessage = tm
    end
  end

  local function setValue(info, b)
    local old = Prat.db.profile.modules[info[#info]]
    Prat.db.profile.modules[info[#info]] = b

    if old == 1 or b == 1 then
      PrintReloadMessage()
    end

    local m = getModuleFromShortName(info[#info])
    if not m then
      --            Prat.db.profile.modules[info[#info]] = b
      return
    end

    if b == 2 or b == 1 then
      m.db.profile.on = false
      m:Disable()
    elseif b == 3 then
      m.db.profile.on = true
      m:Enable()
    end
  end

  local function getValue(info)
    local v, m
    v = Prat.db.profile.modules[info[#info]]

    --		if v ~= 1 then
    --			m = getModuleFromShortName(info[#info])
    --			if m then
    --                -- Allow us to set enabled/disabled while the moduel is "dont load"
    --                if v > 3 then
    --                    v = v - 2
    --- -                    m.db.profile.on = v
    -- else
    -- v = m.db.profile.on and 3 or 2
    -- end
    -- end
    -- end

    return v
  end


  do
    local function blue(text)
      return Prat.CLR:Colorize("a0a0ff", text)
    end

    local function getModuleDesc(info)
      local m = getModuleFromShortName(info[#info])
      local controlMsg = "\n\n" .. blue(PL.load_desc)
      if not m then
        return PL.unloaded_desc .. controlMsg
      end

      return m:GetDescription() .. controlMsg
    end

    local moduleControlOption = {
      name = function(info) return info[#info] end,
      desc = getModuleDesc,
      type = "select",
      --      style = "radio",
      values = function(info) local v = Prat.db.profile.modules[info[#info]] if v == 1 or v > 3 then
        return {
          [1] = "|cffA0A0A0" .. PL.load_no .. "|r",
          [4] = "|cffffff80" .. PL.load_disabledonrestart .. "|r",
          [5] = "|cff80ffff" .. PL.load_enabledonrestart .. "|r"
        }
      else
        return {
          "|cffA0A0A0" .. PL.load_no .. "|r", "|cffff8080" .. PL.load_disabled .. "|r", "|cff80ff80" .. PL.load_enabled .. "|r"
        }
      end
      end,
      get = getValue,
      set = setValue
    }

    function Prat.CreateModuleControlOption(name)
      moduleControlArgs[name] = moduleControlOption
    end
  end
end

Prat.FrameList = {}
Prat.HookedFrameList = {}


local function updateFrameNames()
  for k, v in pairs(Prat.HookedFrames) do
    if (v.isDocked == 1) or v:IsShown() then
      Prat.HookedFrameList[k] = (v.name)
    else
      Prat.HookedFrameList[k] = nil
    end
  end
  for k, v in pairs(Prat.Frames) do
    if (v.isDocked == 1) or v:IsShown() then
      Prat.FrameList[k] = (v.name)
    else
      Prat.FrameList[k] = nil
    end
  end

  Prat.UpdateOptions()
end

function Prat.UpdateOptions()
  LibStub("AceConfigRegistry-3.0"):NotifyChange(PL.prat)
end

tinsert(Prat.EnableTasks, function(self)
  self:SecureHook("FCF_SetWindowName", updateFrameNames)

  _G.FCF_SetWindowName(_G.ChatFrame1, (_G.GetChatWindowInfo(1)), 1)
end)

function Prat.ToggleOptionsWindow()
  local acd = LibStub("AceConfigDialog-3.0")
  if acd.OpenFrames[PL.prat] then
    acd:Close(PL.prat)
  else
    acd:Open(PL.prat)
  end
end

_G["Prat_ToggleOptionsWindow"] = Prat.ToggleOptionsWindow
