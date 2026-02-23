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

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

Prat:AddModuleToLoad(function()
  local module = Prat:NewModule("HoverTips", "AceHook-3.0")

  -- define localized strings
  local PL = module.PL

  --@debug@
  PL:AddLocale("enUS", {
    ["module_name"] = "Hover Tips",
    ["module_desc"] = "Shows tooltip when hovering over link in chat",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale("zhTW",  L)
end
--@end-non-debug@]===]

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
    }
  })

  local linkTypes = {
    item = true,
    enchant = true,
    spell = true,
    quest = true,
    achievement = true,
    currency = true,
    battlepet = true,
  }

  function module:OnEnable()
    for i = 1, NUM_CHAT_WINDOWS do
      local frame = _G["ChatFrame" .. i]
      self:HookScript(frame, "OnHyperlinkEnter", OnHyperlinkEnter)
      self:HookScript(frame, "OnHyperlinkLeave", OnHyperlinkLeave)
    end
  end

  function module:OnDisable()
    for i = 1, NUM_CHAT_WINDOWS do
      local frame = _G["ChatFrame" .. i]
      self:Unhook(frame, "OnHyperlinkEnter")
      self:Unhook(frame, "OnHyperlinkLeave")
    end
  end

  local showingTooltip = false
  function module:OnHyperlinkEnter(f, link, text)
    local linkType = link:match("^([^:]+):")
    -- Prevent NPC tooltips leaving health bars behind or remaining behind
    -- battle pet tooltips
    GameTooltip:Hide()
    if linkType == "battlepet" then
      showingTooltip = BattlePetTooltip
      GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
      BattlePetToolTip_ShowLink(text)
    elseif linkTypes[linkType] then
      showingTooltip = GameTooltip
      GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
      GameTooltip:SetHyperlink(link)
      GameTooltip:Show()
    end
  end

  function module:OnHyperlinkLeave(f, link)
    if showingTooltip then
      showingTooltip:Hide()
      showingTooltip = false
    end
  end
end)
