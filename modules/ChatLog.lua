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

  local PRAT_MODULE = Prat:RequestModuleName("ChatLog")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["ChatLog"] = true,
    ["A module to automaticaly enable chat and combat logging."] = true,
    ["Toggle Chat Log"] = true,
    ["Toggle chat log on and off."] = true,
    ["Toggle Combat Log"] = true,
    ["Toggle combat log on and off."] = true,
    ["Combat Log: Enabled"] = true,
    ["Combat log recorded to <WoW Installation>\\Logs\\WoWCombatLog.txt only upon logout."] = true,
    ["Combat Log: Disabled"] = true,
    ["Chat Log: Enabled"] = true,
    ["Chat log recorded to <WoW Installation>\\Logs\\WoWChatLog.txt only upon logout."] = true,
    ["Chat Log: Disabled"] = true,
    ["quiet_name"] = "Suppress Feedback Messages",
    ["quiet_desc"] = "Dont display any messages when this mod is enabled, or when it changes the log settings.",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatLog")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]




  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      chat = false,
      combat = false,
      quiet = true,
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = PL["ChatLog"],
    desc = PL["A module to automaticaly enable chat and combat logging."],
    type = "group",
    args = {
      chat = {
        name = PL["Toggle Chat Log"],
        desc = PL["Toggle chat log on and off."],
        type = "toggle",
        set = "SetChatLog",
      },
      combat = {
        name = PL["Toggle Combat Log"],
        desc = PL["Toggle combat log on and off."],
        type = "toggle",
        set = "SetCombatLog",
      },
      quiet = {
        name = PL["quiet_name"],
        desc = PL["quiet_desc"],
        type = "toggle",
      }
    }
  })


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    self:SetChatLog(nil, self.db.profile.chat)
    self:SetCombatLog(nil, self.db.profile.combat)
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function module:GetDescription()
    return PL["A module to automaticaly enable chat and combat logging."]
  end

  -- enable or disable the chat log
  function module:SetChatLog(info, val)
    self.db.profile.chat = val
    if self.db.profile.chat then
      self:Print(PL["Chat Log: Enabled"])
      self:Print(PL["Chat log recorded to <WoW Installation>\\Logs\\WoWChatLog.txt only upon logout."])
      LoggingChat(true)
    else
      LoggingChat(false)
      self:Print(PL["Chat Log: Disabled"])
    end
  end

  -- enable or disable the combat log
  function module:SetCombatLog(info, val)
    self.db.profile.combat = val
    if self.db.profile.combat then
      self:Print(PL["Combat Log: Enabled"])
      self:Print(PL["Combat log recorded to <WoW Installation>\\Logs\\WoWCombatLog.txt only upon logout."])
      LoggingCombat(true)
    end
  end

  function module:Print(str)
    if self.db.profile.quiet then return end

    Prat:Print(str)
  end



  return
end) -- Prat:AddModuleToLoad