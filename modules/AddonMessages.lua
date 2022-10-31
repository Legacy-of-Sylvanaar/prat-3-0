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

  local PRAT_MODULE = Prat:RequestModuleName("AddonMsgs")

  if PRAT_MODULE == nil then
    return
  end

  local mod = Prat:NewModule(PRAT_MODULE, "AceEvent-3.0")

  -- define localized strings
  local PL = mod.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["AddonMsgs"] = true,
    ["Addon message options."] = true,
    ["show_name"] = "Show Addon Messages",
    ["show_desc"] = "Toggle showing hidden addon messages in each chat window.",
    ["show_perframename"] = "ChatFrame%d AddonMsgsShow",
    ["show_perframedesc"] = "Toggle showing hidden addon messages on and off.",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "enUS", L)




--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "itIT", L)




--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)




--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "frFR", L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "deDE", L)




--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "koKR", L)




--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "esMX", L)




--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "ruRU", L)




--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "zhCN", L)




--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "esES", L)




--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AddonMsgs")@
PL:AddLocale(PRAT_MODULE, "zhTW", L)


end
--@end-non-debug@]===]




  Prat:SetModuleDefaults(mod.name, {
    profile = {
      on = false,
      show = {},
    }
  })

  Prat:SetModuleOptions(mod.name, {
    name = PL["AddonMsgs"],
    desc = PL["Addon message options."],
    type = "group",
    args = {
      show = {
        name = PL["show_name"],
        desc = PL["show_desc"],
        type = "multiselect",
        values = Prat.HookedFrameList,
        get = "GetSubValue",
        set = "SetSubValue"
      }
    }
  })

  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --
  function mod:OnModuleEnable()
    self:RegisterEvent("CHAT_MSG_ADDON")
  end

  function mod:OnModuleDisable()
    self:UnregisterEvent("CHAT_MSG_ADDON")
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function mod:GetDescription()
    return PL["Addon message options."]
  end

  local CLR = Prat.CLR

  -- add a splash of color to text
  local function c1(text) return CLR:Colorize("ffff40", text) end

  local function c2(text) return CLR:Colorize("a0a0a0", text) end

  local function c3(text) return CLR:Colorize("40ff40", text) end

  local function c4(text) return CLR:Colorize("4040ff", text) end

  -- show hidden addon channel messages
  function mod:CHAT_MSG_ADDON(arg1, arg2, arg3, arg4)
    for k, v in pairs(Prat.HookedFrames) do
      if self.db.profile.show[k] then
        v:AddMessage("[" .. c1(arg1) .. "][" .. c2(arg2) .. "][" .. c3(arg3) .. "][" .. c4(arg4) .. "]")
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad