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

  local PRAT_MODULE = Prat:RequestModuleName("Clear")

  if PRAT_MODULE == nil then
    return
  end


  local module = Prat:NewModule(PRAT_MODULE)

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Clear"] = true,
    ["Adds clear text slash commands (/clear)(/cls)(/clearall)(/clsall)."] = true,
    ["Clears the current chat frame."] = true,
    ["Clearall"] = true,
    ["Clears all chat frames."] = true,
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Clear")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = PL["Clear"],
    desc = PL["Adds clear text slash commands (/clear)(/cls)(/clearall)(/clsall)."],
    type = "group",
    args = {}
  })

  --[[------------------------------------------------
    Module Event Functions
  ------------------------------------------------]] --

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    Prat.RegisterChatCommand("clear", function() module:clear(SELECTED_CHAT_FRAME) end)
    Prat.RegisterChatCommand("cls", function() module:clear(SELECTED_CHAT_FRAME) end)
    Prat.RegisterChatCommand("clearall", function() module:clearAll() end)
    Prat.RegisterChatCommand("clsall", function() module:clearAll() end)

    --	local slashcmds, cmdopts
    --
    --	-- clear
    --	cmdopts_clear = {
    --		name	= PL["Clear"],
    --		desc	= PL["Clears the current chat frame."],
    --		type	= "execute",
    --		func	= function() module:clear(SELECTED_CHAT_FRAME) end,
    --		}
    --
    --	-- cleartastic
    --	cmdopts_clearall = {
    --		name	= PL["Clearall"],
    --		desc	= PL["Clears all chat frames."],
    --		type	= "execute",
    --		func	= function() module:clearAll() end,
    --		}

    -- TODO - need to find call equivalent to RCC in Ace2
    --	Prat.Addon:RegisterChatCommand({ '/clear', '/cls' }, cmdopts_clear)
    --	Prat.Addon:RegisterChatCommand({ '/clearall', '/clsall' }, cmdopts_clearall)
  end

  function module:OnModuleDisable()
  end

  --[[ - - ------------------------------------------------
    Core Functions
  --------------------------------------------- - ]] --

  function module:GetDescription()
    return PL["Adds clear text slash commands (/clear)(/cls)(/clearall)(/clsall)."]
  end

  function module:clear(chatframe)
    local vartype = type(chatframe)
    local type = chatframe:GetObjectType() or nil

    if self.db.profile.on and type == 'Frame' and chatframe.Clear then
      chatframe:Clear()
    end
  end

  function module:clearAll()
    for i = 1, NUM_CHAT_WINDOWS do
      self:clear(_G['ChatFrame' .. i])
    end
  end


  return
end) -- Prat:AddModuleToLoad