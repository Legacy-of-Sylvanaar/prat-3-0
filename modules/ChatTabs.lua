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

  local PRAT_MODULE = Prat:RequestModuleName("ChatTabs")

  local dbg = function() end
  --@debug@
  dbg = function(...) Prat:PrintLiteral(...) end
  --@end-debug@

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Tabs"] = true,
    ["Chat window tab options."] = true,
    ["Set Display Mode"] = true,
    ["Set tab display mode for each chat window."] = "Set tab display mode for each chat window. Checked (on), Unchecked (off), Greyed Check (default)",
    ["Set ChatFrame%d Display Mode"] = true,
    ["Set tab display to always, hidden or the Blizzard default."] = true,
    ["Active Alpha"] = true,
    ["Sets alpha of chat tab for active chat frame."] = true,
    ["Not Active Alpha"] = true,
    ["Sets alpha of chat tab for not active chat frame."] = true,
    ["All"] = true,
    ["Individual"] = true,
    ["Always"] = true,
    ["Hidden"] = true,
    ["Default"] = true,
    ["disableflash_name"] = "Disable Flashing",
    ["disableflash_desc"] = "Disable flashing of the chat tabs.",
    ["preventdrag_name"] = "Prevent Dragging",
    ["preventdrag_desc"] = "Prevent dragging chat tabs with mouse",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="ChatTabs")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]



  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      displaymode = {},
      disableflash = false,
      notactivealpha = 0,
      activealpha = 0,
      preventdrag = false,
    }
  })

  --module.toggleOptions = { sep115_sep = 115, disableflash = 120, preventdrag = 125 }

  Prat:SetModuleOptions(module.name, {
    name = PL["Tabs"],
    desc = PL["Chat window tab options."],
    type = "group",
    args = {
      displaymode = {
        name = PL["Set Display Mode"],
        desc = PL["Set tab display mode for each chat window."],
        type = "multiselect",
        tristate = true,
        order = 110,
        values = Prat.FrameList,
        get = "GetSubValue",
        set = "SetSubValue",
      },
      disableflash = {
        name = PL["disableflash_name"],
        desc = PL["disableflash_desc"],
        type = "toggle",
        order = 120
      },
      --			preventdrag = {
      --				name = PL["preventdrag_name"],
      --				desc = PL["preventdrag_desc"],
      --				type = "toggle",
      --				order = 120
      --			},
      activealpha = {
        name = PL["Active Alpha"],
        desc = PL["Sets alpha of chat tab for active chat frame."],
        type = "range",
        order = 130,
        min = 0.0,
        max = 1,
        step = 0.1,
      },
      notactivealpha = {
        name = PL["Not Active Alpha"],
        desc = PL["Sets alpha of chat tab for not active chat frame."],
        type = "range",
        order = 140,
        min = 0.0,
        max = 1,
        step = 0.1,
      },
    }
  })

  --local tabmode = { ["true"] = "ALWAYS", ["false"] = "HIDDEN", ["nil"] = "DEFAULT" }

  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    self:SecureHook("FCF_StartAlertFlash")

    self:HookedMode(true)

    self:UpdateAllTabs()
  end

  -- things to do when the module is enabled
  function module:OnModuleDisable()
    self:RemoveHooks()
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function module:GetDescription()
    return PL["Chat window tab options."]
  end

  function module:HookedMode(hooked)
    if hooked then
      self:RawHook("FCF_Close", true)
      self:InstallHooks()
    else
      self:RemoveHooks()
    end
  end


  local needToHook = {}

  function module:InstallHooks()
    for k, v in pairs(Prat.Frames) do
      local cftab = _G[k .. "Tab"]
      self:HookScript(cftab, "OnShow", "OnTabShow")
      if cftab:IsShown() then
        self:HookScript(cftab, "OnHide", "OnTabHide")
        needToHook[cftab] = nil
      else
        needToHook[cftab] = true
      end
      --		self:HookScript(cftab,"OnDragStart", "OnTabDragStart")
    end
  end

  function module:RemoveHooks()
    for k, v in pairs(Prat.Frames) do
      local cftab = _G[k .. "Tab"]
      cftab:SetScript("OnShow", function() return end)
      cftab:SetScript("OnHide", function() return end)
    end
    -- unhook functions
    self:UnhookAll()
  end

  function module:OnValueChanged(info, b)
    --	if info[#info]:find("alpha") then
    --
    --		return
    --	end

    self:UpdateAllTabs()
  end

  function module:OnSubValueChanged(info, b)
    self:UpdateAllTabs()
  end

  function module:UpdateAllTabs()
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = self.db.profile.activealpha;
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = self.db.profile.notactivealpha;

    for k, v in pairs(Prat.Frames) do
      if FCF_IsValidChatFrame(v) then

        local chatTab = _G[k .. "Tab"]
        chatTab:Show()
        chatTab:Hide()
        FloatingChatFrame_Update(v:GetID())

        chatTab.mouseOverAlpha = CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA;
        chatTab.noMouseAlpha = CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA;

        -- Prevent an error in FloatingChatFrame FCF_FadeOutChatFrame() (blizz bug)
        chatTab:SetAlpha(chatTab:GetAlpha() or 0)
        v:SetAlpha(v:GetAlpha() or 0)
        v.oldAlpha = v.oldAlpha or 0

        FCF_FadeOutChatFrame(v)
      end
    end
  end

  function module:OnTabShow(tab, ...)
    if needToHook[tab] then
      self:HookScript(tab, "OnHide", "OnTabHide")
      needToHook[tab] = nil
    end

    if self.db.profile.displaymode["ChatFrame" .. tab:GetID()] == false then
      tab:Hide()
    end
  end

  function module:OnTabHide(tab, ...)
    local p = self.db.profile
    local i = tab:GetID()

    if self.db.profile.displaymode["ChatFrame" .. tab:GetID()] == true then
      tab:Show()
      if SELECTED_CHAT_FRAME:GetID() == i then
        tab:SetAlpha(p.activealpha)
      else
        tab:SetAlpha(p.notactivealpha)
      end
    end
  end

  function module:OnTabDragStart(this, ...)
    local p = self.db.profile

    if p.preventdrag and p.on then return end

    self.hooks[this].OnDragStart(this, ...)
  end



  function module:FCF_StartAlertFlash(this)
    if self.db.profile.disableflash then
      FCF_StopAlertFlash(this)
    end
  end

  function module:FCF_Close(frame, fallback)
    local tab = _G[frame:GetName() .. "Tab"]

    -- print(frame, fallback, tab)
    if tab then
      self:Unhook(tab, "OnHide")
      needToHook[tab] = true
    end

    self.hooks.FCF_Close(frame, fallback)
  end


  return
end) -- Prat:AddModuleToLoad