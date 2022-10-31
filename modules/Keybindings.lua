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

  -- Get Utility Libraries
  local PRAT_MODULE = Prat:RequestModuleName("KeyBindings")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    module_desc = "Adds chat related keybindings",
    ["Prat Keybindings"] = true,
    ["Officer Channel"] = true,
    ["Guild Channel"] = true,
    ["Party Channel"] = true,
    ["Raid Channel"] = true,
    ["Raid Warning Channel"] = true,
    ["Instance Channel"] = true,
    ["Say"] = true,
    ["Yell"] = true,
    ["Whisper"] = true,
    ["Channel %d"] = true,
    ["Prat TellTarget"] = true,
    ["TellTarget"] = true,
    ["Prat CopyChat"] = true,
    ["Copy Selected Chat Frame"] = true,
    ["Smart Group Channel"] = true,
    ["Next Chat Tab"] = true
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --[===[@non-debug@
 do
     local L

 
--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "enUS",L)


 
--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "frFR",L)


 
--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "deDE",L)


 
--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "koKR",L)


 
--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "esMX",L)


 
--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "ruRU",L)


 
--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "zhCN",L)


 
--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "esES",L)


 
--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="KeyBindings")@

   PL:AddLocale(PRAT_MODULE, "zhTW",L)


 end
 --@end-non-debug@]===]


  Prat:SetModuleInit(module,
    function(self)
      BINDING_HEADER_Prat = PL["Prat Keybindings"]
      BINDING_NAME_officer = PL["Officer Channel"]
      BINDING_NAME_guild = PL["Guild Channel"]
      BINDING_NAME_party = PL["Party Channel"]
      BINDING_NAME_raid = PL["Raid Channel"]
      BINDING_NAME_raidwarn = PL["Raid Warning Channel"]
      BINDING_NAME_instance = PL["Instance Channel"]
      BINDING_NAME_say = PL["Say"]
      BINDING_NAME_yell = PL["Yell"]
      BINDING_NAME_whisper = PL["Whisper"]
      BINDING_NAME_one = (PL["Channel %d"]):format(1)
      BINDING_NAME_two = (PL["Channel %d"]):format(2)
      BINDING_NAME_three = (PL["Channel %d"]):format(3)
      BINDING_NAME_four = (PL["Channel %d"]):format(4)
      BINDING_NAME_five = (PL["Channel %d"]):format(5)
      BINDING_NAME_six = (PL["Channel %d"]):format(6)
      BINDING_NAME_seven = (PL["Channel %d"]):format(7)
      BINDING_NAME_eight = (PL["Channel %d"]):format(8)
      BINDING_NAME_nine = (PL["Channel %d"]):format(9)
      BINDING_NAME_SmartGroup = PL["Smart Group Channel"]
      --	    BINDING_HEADER_Prat_TellTarget = PL["Prat TellTarget"]
      --	    BINDING_HEADER_Prat_CopyChat = PL["Prat CopyChat"]
      BINDING_NAME_NextTab = PL["Next Chat Tab"]
      BINDING_NAME_CopySelected = PL["Copy Selected Chat Frame"]
    end)

  -- /script keybindings:CycleChatTabs()
  function module:CycleChatTabs()
    local current = FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK)
    local idx
    local dockedFrames = FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)

    for i, v in ipairs(dockedFrames) do
      if v == current then
        idx = i
      end
    end

    if idx == nil then return end

    idx = idx + 1
    if dockedFrames[idx] == nil then
      idx = 1
    end

    FCFDock_SelectWindow(GENERAL_CHAT_DOCK, dockedFrames[idx])
  end

  return
end) -- Prat:AddModuleToLoad