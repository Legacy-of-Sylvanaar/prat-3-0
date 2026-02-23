--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2023  Prat Development Team
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

if not Prat.IsRetail then
  return
end

Prat:AddModuleToLoad(function()
  local module = Prat:NewModule("NewcomersChat")
  local PL = module.PL

  --@debug@
  PL:AddLocale("enUS", {
    ["NewcomersChat"] = "Newcomers Chat",
    ["module_desc"] = "Configure icons and text indicating guides and newcomers from and in the Newcomers channel",
    ["As Newcomer"] = "As Newcomer",
    ["As Guide"] = "As Guide",
    ["Newcomer Icon"] = "Newcomer Icon",
    ["Guide Icon"] = "Guide Icon",
    ["Guide Label"] = "Guide Label",
    ["In newcomers chat"] = "In newcomers chat",
    ["In normal chat"] = "In normal chat",
    ["Guide"] = "Guide",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --[===[@non-debug@
  do
      local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("enUS",L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("frFR",L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("deDE",L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("koKR",L)



--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("esMX",L)



--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("ruRU",L)



--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("zhCN",L)



--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("esES",L)



--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="NewcomersChat")@

    PL:AddLocale("zhTW",L)


  end
  --@end-non-debug@]===]

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      asNewcomer = {
        newcomerIcon = {
          inNewcomersChat = false,
          inNormalChat = false
        },
        guideIcon = {
          inNewcomersChat = true,
          inNormalChat = false
        },
        guideLabel = {
          inNewcomersChat = true,
          inNormalChat = false
        },
      },
      asGuide = {
        newcomerIcon = {
          inNewcomersChat = true,
          inNormalChat = true
        },
        guideIcon = {
          inNewcomersChat = true,
          inNormalChat = false
        },
        guideLabel = {
          inNewcomersChat = true,
          inNormalChat = false
        },
      },
    },
  })

  local function GetBundle(name, description, order)
    return {
      name = name or "",
      desc = description or "",
      type = "group",
      inline = true,
      order = order,
      args = {
        inNewcomersChat = {
          name = PL["In newcomers chat"],
          type = "toggle",
          order = 10,
        },
        inNormalChat = {
          name = PL["In normal chat"],
          type = "toggle",
          order = 20,
        },
      }
    }
  end
  local function GetTab(name, description)
    return {
      name = name or "",
      desc = description or "",
      type = "group",
      args = {
        newcomerIcon = GetBundle(PL["Newcomer Icon"], nil, 10),
        guideIcon = GetBundle(PL["Guide Icon"], nil, 20),
        guideLabel = GetBundle(PL["Guide Label"], nil, 30),
      },
    }
  end

  module.pluginopts = {}
  Prat:SetModuleOptions(module, {
    name = PL["NewcomersChat"],
    desc = PL["module_desc"],
    type = "group",
    plugins = module.pluginopts,
    childGroups = "tab",
    get = function(info)
      return module.db.profile[info[#info-2]][info[#info-1]][info[#info]]
    end,
    set = function(info, value)
      module.db.profile[info[#info-2]][info[#info-1]][info[#info]] = value
    end,
    args = {
      asNewcomer = GetTab(PL["As Newcomer"]),
      asGuide = GetTab(PL["As Guide"]),
    }
  })

  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
  end

  function module:OnModuleDisable()
    Prat.UnregisterAllChatEvents(self)
  end

  local GUIDE_ICON = "|A:newplayerchat-chaticon-guide:0:0:0:0|a"
  local GUIDE_TEXT = "|cff81b558" .. PL["Guide"] .. "|r"
  local NEWCOMER_ICON = "|A:newplayerchat-chaticon-newcomer:0:0:0:0|a"

  function module:ApplySettings(settings, senderStatus, message)
    message.FLAG = ""

    local ruleSet = C_ChatInfo.GetChannelRulesetForChannelID(message.ARGS[7])
    if ruleSet == Enum.ChatChannelRuleset.Mentor then
      if senderStatus == "GUIDE" then
        if settings.guideIcon.inNewcomersChat then
          message.FLAG = GUIDE_ICON
        end
        if settings.guideLabel.inNewcomersChat then
          message.FLAG = message.FLAG .. GUIDE_TEXT
        end
        if settings.guideIcon.inNewcomersChat or settings.guideLabel.inNewcomersChat then
          message.FLAG = message.FLAG .. " "
        end
      elseif senderStatus == "NEWCOMER" then
        if settings.newcomerIcon.inNewcomersChat then
          message.FLAG = NEWCOMER_ICON
        end
      end

    else
      if senderStatus == "GUIDE" then
        if settings.guideIcon.inNormalChat then
          message.FLAG = GUIDE_ICON
        end
        if settings.guideLabel.inNormalChat then
          message.FLAG = message.FLAG .. GUIDE_TEXT
        end
        if settings.guideIcon.inNormalChat or settings.guideLabel.inNormalChat then
          message.FLAG = message.FLAG .. " "
        end
      elseif senderStatus == "NEWCOMER" then
        if settings.newcomerIcon.inNormalChat then
          message.FLAG = NEWCOMER_ICON
        end
      end
    end
  end

  function module:Prat_FrameMessage(info, message, frame, event)
    local arg6 = message.ARGS[6] or ""

    if arg6 ~= "GUIDE" and arg6 ~= "NEWCOMER" then
      return
    end

    if IsActivePlayerGuide() then
      self:ApplySettings(self.db.profile.asGuide, arg6, message)
    elseif C_PlayerMentorship.IsActivePlayerConsideredNewcomer() then
      self:ApplySettings(self.db.profile.asNewcomer, arg6, message)
    end
  end

  return
end) -- Prat:AddModuleToLoad
