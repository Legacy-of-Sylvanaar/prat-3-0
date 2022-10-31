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
  local PRAT_MODULE = Prat:RequestModuleName("HoverTips")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  -- define localized strings
  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
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
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="HoverTips")@
PL:AddLocale(PRAT_MODULE, "zhTW",  L)
end
--@end-non-debug@]===]

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
    }
  })

  -- basic code from Chatter

  local strmatch = string.match
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
    local t = strmatch(link, "^(.-):")
    if linkTypes[t] then
      if t == "battlepet" then
        showingTooltip = BattlePetTooltip
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        BattlePetToolTip_ShowLink(text)
      else
        showingTooltip = GameTooltip
        ShowUIPanel(GameTooltip)
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
      end
    end
  end

  function module:OnHyperlinkLeave(f, link)
    if showingTooltip then
      showingTooltip:Hide()
      showingTooltip = false
    end
  end
end)