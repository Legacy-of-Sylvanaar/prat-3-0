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

  local PRAT_MODULE = Prat:RequestModuleName("Highlight")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  -- define localized strings
  local PL = module.PL


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      player = true,
      guild = true
    }
  })

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["module_name"] = "Highlight",
    ["module_desc"] = "Highlight your own name, and various other text",
    ["player_name"] = "Highlight Self",
    ["player_desc"] = "Highlight you own name in a special color",
    ["guild_name"] = "Highlight Guilds",
    ["guild_desc"] = "Highlight things which looks like guild names"
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Highlight")@
PL:AddLocale(PRAT_MODULE, "zhTW",  L)
end
--@end-non-debug@]===]

  local toggleOption = {
    name = function(info) return PL[info[#info] .. "_name"] end,
    desc = function(info) return PL[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    args = {
      player = toggleOption,
      guild = toggleOption
    }
  })

  local CLR = Prat.CLR
  local function guildBracket(text)
    return CLR:Colorize("ffffff", text)
  end

  local function guildText(text)
    return CLR:Colorize("00ff00", text)
  end


  local function highlightPlayer(text)
    if module.db.profile.player then
      return Prat:RegisterMatch(CLR:Colorize("00ff00", text))
    end
  end

  local function highlightGuild(text)
    if module.db.profile.guild then
      return Prat:RegisterMatch(guildBracket("<") .. guildText(text) .. guildBracket(">"))
    end
  end

  Prat:SetModulePatterns(module, {
    { pattern = Prat.GetNamePattern(UnitName("player")), matchfunc = highlightPlayer, priority = 47 },
    { pattern = "<(..-)>", matchfunc = highlightGuild, priority = 49 },
  })
end)