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
    ["Show Tab Textures"] = true,
    ["All"] = true,
    ["Individual"] = true,
    ["Always"] = true,
    ["Hidden"] = true,
    ["Default"] = true,
    ["disablewhisperflash_name"] = "Disable Flash for Whispers",
    ["disablewhisperflash_desc"] = "Disable flashing of the chat tabs for whispers.",
    ["preventdrag_name"] = "Prevent Dragging",
    ["preventdrag_desc"] = "Prevent dragging chat tabs with mouse",
    ["Set Flash On Message"] = true,
    ["Change Font Color On Message"] = true,
    ["Flash Color"] = true,
    ["Font Color"] = true,
    ["Visibility"] = true,
    ["Highlighting/Flashing"] = true,
    ["foreveralert_name"] = "Keep highlighting until tab button clicked",
    ["foreveralert_desc"] = "With this turned off the highlight/flash will persist until the timer elapses",
    ["Chat Alert Timeout"] = true,
    ["How long any highlights/flashes should last"] = true,
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
  module.HighlightTabsPlugin = {}



  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      displaymode = {},
      highlighttabs = {
        ["*"] = {
          flash = false,
          flashcolor = {
            r = 124/255,
            g = 239/255,
            b = 232/255,
            a = 0.7,
          },
          changefont = false,
          fontcolor = {
            r = 221/255,
            g = 27/255,
            b = 24/255,
            a = 1,
          }
        },
      },
      disableflash = false,
      notactivealpha = 0,
      activealpha = 0,
      preventdrag = false,
      showtabtextures = true,

      foreveralert = false,
      alerttimeout = 3.2,
    }
  })

  --module.toggleOptions = { sep115_sep = 115, disableflash = 120, preventdrag = 125 }

  Prat:SetModuleOptions(module.name, {
    name = PL["Tabs"],
    desc = PL["Chat window tab options."],
    type = "group",
    childGroups = "tab",
    args = {
      displaygroup = {
        type = "group",
        name = PL["Visibility"],
        order = 10,
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
          showtabtextures = {
            name = PL["Show Tab Textures"],
            type = "toggle",
            order = 150,
          },
        },
      },
      highlightgroup = {
        name = PL["Highlighting/Flashing"],
        type = "group",
        order = 20,
        plugins = module.HighlightTabsPlugin,
        args = {
          disableflash = {
            name = PL["disablewhisperflash_name"],
            desc = PL["disablewhisperflash_desc"],
            type = "toggle",
            order = 4
          },
          foreveralert = {
            name = PL["foreveralert_name"],
            desc = PL["foreveralert_desc"],
            type = "toggle",
            order = 5
          },
          alerttimeout = {
            name = PL["Chat Alert Timeout"],
            desc = PL["How long any highlights/flashes should last"],
            type = "range",
            order = 6,
            min = 0.1,
            max = 15,
          },
        },
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
    self:SecureHook("FCFTab_UpdateAlpha")
    self:SecureHook("FCF_StopAlertFlash")

    self:HookedMode(true)
    self.chatTabTexture = {}
    self.chatAlertTimers = {}
    self.chatAlertCleanupActions = {}

    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
    self:UpdateAllTabs()
    self:UpdateHighlightTabsConfig()
  end

  -- things to do when the module is enabled
  function module:OnModuleDisable()
    self:RemoveHooks()
  end

  function module:Prat_FramesUpdated(info, name, chatFrame, ...)
    self:UpdateHighlightTabsConfig()
  end

  function module:Prat_FramesRemoved(info, name, chatFrame)
    self:UpdateHighlightTabsConfig()
  end
  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function module:UpdateHighlightTabsConfig()
    local getToggle = function(info)
      return self.db.profile.highlighttabs[info[#info-1]][info[#info]]
    end
    local setToggle = function(info, value)
      self.db.profile.highlighttabs[info[#info-1]][info[#info]] = value
    end
    local getColor = function(info)
      local color = self.db.profile.highlighttabs[info[#info-1]][info[#info]]
      return color.r, color.g, color.b, color.a
    end
    local setColor = function(info, r, g, b, a)
      self.db.profile.highlighttabs[info[#info-1]][info[#info]] = {
        r = r,
        g = g,
        b = b,
        a = a,
      }
    end
    local orderedFrames = {}
    for _, frame in pairs(Prat.Frames) do
      if (frame.isDocked == 1) or frame:IsShown() then
        table.insert(orderedFrames, frame)
      end
    end
    table.sort(orderedFrames, function(a, b) return a:GetID() < b:GetID() end)
    for index, frame in pairs(orderedFrames) do
      local raw = frame:GetName()
      local name = frame.name
      self.HighlightTabsPlugin[raw] = {
        [raw] = {
          name = name,
          type = "group",
          inline = true,
          order = index * 10,
          args = {
            flash = {
              name = PL["Set Flash On Message"],
              order = 150,
              type = "toggle",
              get = getToggle,
              set = setToggle,
            },
            flashcolor = {
              name = PL["Flash Color"],
              type = "color",
              order = 170,
              get = getColor,
              set = setColor,
            },
            changefont = {
              name = PL["Change Font Color On Message"],
              order = 160,
              type = "toggle",
              get = getToggle,
              set = setToggle,
            },
            fontcolor = {
              name = PL["Font Color"],
              type = "color",
              order = 170,
              get = getColor,
              set = setColor,
            },
          },
        }
      }
    end
  end

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
    for frameName, chatFrame in pairs(Prat.Frames) do
      local tabButton = _G[frameName .. "Tab"]
      self:HookScript(tabButton, "OnShow", "OnTabShow")
      self:SecureHook(chatFrame, "AddMessage")
      if tabButton:IsShown() then
        self:HookScript(tabButton, "OnHide", "OnTabHide")
        needToHook[tabButton] = nil
      else
        needToHook[tabButton] = true
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

  local ChatTabTexturesRetail = {
    "Left", "Right", "Middle",
    "HighlightLeft", "HighlightRight", "HighlightMiddle",
    "ActiveLeft", "ActiveRight", "ActiveMiddle",
  }
  local ChatTabTexturesSelectedRetail = {
    "ActiveLeft", "ActiveRight", "ActiveMiddle",
  }
  local ChatTabTexturesClassic = {
    "Left", "Right", "Middle",
    "HighlightLeft", "HighlightRight", "HighlightMiddle",
    "SelectedLeft", "SelectedRight", "SelectedMiddle",
  }
  local ChatTabTexturesSelectedClassic = {
    "SelectedLeft", "SelectedRight", "SelectedMiddle",
  }

  function module:ShowHideTabTextures(tab)
    local tabButton = _G[tab:GetName() .. "Tab"]
    local alpha = self.db.profile.showtabtextures and 1 or 0
    if not Prat.IsClassic then
      for _, field in ipairs(ChatTabTexturesRetail) do
        tabButton[field]:SetShown(self.db.profile.showtabtextures)
      end
      for _, field in ipairs(ChatTabTexturesSelectedRetail) do
        tabButton[field]:SetAlpha(alpha)
      end
    else
      for _, field in ipairs(ChatTabTexturesClassic) do
        _G[tabButton:GetName() .. field]:SetShown(self.db.profile.showtabtextures)
      end
      for _, field in ipairs(ChatTabTexturesSelectedClassic) do
        _G[tabButton:GetName() .. field]:SetAlpha(alpha)
      end
    end
  end

  function module:UpdateAllTabs()
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = self.db.profile.activealpha;
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = self.db.profile.notactivealpha;
    for k, v in pairs(Prat.Frames) do
      local tabButton = _G[k .. "Tab"]
      if FCF_IsValidChatFrame(v) then
        tabButton:Show()
        tabButton:Hide()
        FCFTab_UpdateAlpha(v)
      end
      self:ShowHideTabTextures(v)
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

  function module:FCFTab_UpdateAlpha(chatFrame)
    local chatTab = _G[chatFrame:GetName() .. "Tab"]

    if chatTab.alerting then
      return
    elseif self.chatAlertCleanupActions[chatFrame:GetName()] then
      chatTab.noMouseAlpha = 1
      chatTab.mouseAlpha = 1
      chatTab:SetAlpha(1)
      return
    end

    if FCF_IsValidChatFrame(chatFrame) then
      if SELECTED_CHAT_FRAME:GetID() == chatFrame:GetID() then
        chatTab:SetAlpha(self.db.profile.activealpha)
        chatTab.noMouseAlpha = self.db.profile.activealpha
        chatTab.mouseAlpha = self.db.profile.activealpha
      else
        chatTab:SetAlpha(self.db.profile.notactivealpha)
        chatTab.noMouseAlpha = self.db.profile.notactivealpha
        chatTab.mouseAlpha = self.db.profile.notactivealpha
      end
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

  function module:FCF_StopAlertFlash(frame)
    if FCF_IsValidChatFrame(frame) then
      FCFTab_UpdateAlpha(frame)
    end
  end

  function module:AddMessage(chatFrame)
    local oldActions = self.chatAlertCleanupActions[chatFrame:GetName()]
    self.chatAlertCleanupActions[chatFrame:GetName()] = nil
    if oldActions then
      for _, a in ipairs(oldActions) do
        a()
      end
    end
    if self.chatAlertTimers[chatFrame:GetName()] then
      self.chatAlertTimers[chatFrame:GetName()]:Cancel()
    end

    local actions = {}
    if self.db.profile.highlighttabs[chatFrame:GetName()].flash then
      table.insert(actions, self:DoFlash(chatFrame))
    end
    if self.db.profile.highlighttabs[chatFrame:GetName()].changefont then
      table.insert(actions, self:DoFontColorChange(chatFrame))
    end
    if #actions > 0 then
      table.insert(actions, self:KeepTabButtonVisible(chatFrame))
    end

    if #actions> 0 then
      self.chatAlertCleanupActions[chatFrame:GetName()] = actions
      if not self.db.profile.foreveralert then
        self.chatAlertTimers[chatFrame:GetName()] = C_Timer.NewTimer(self.db.profile.alerttimeout, function()
          self.chatAlertTimers[chatFrame:GetName()] = nil
          for _, a in ipairs(actions) do
            a()
          end
          self.chatAlertCleanupActions[chatFrame:GetName()] = nil
        end)
      else
        local tabButton = _G[chatFrame:GetName() .. "Tab"]
        if not self:IsHooked(tabButton, "OnClick") then
          self:HookScript(tabButton, "OnClick", function(tabButton)
            local frameName = "ChatFrame" .. tabButton:GetID()
            if self.chatAlertCleanupActions[frameName] then
              local actions = self.chatAlertCleanupActions[frameName]
              for _, a in ipairs(actions) do
                a()
              end
              self.chatAlertCleanupActions[frameName] = nil
            end
          end)
        end
      end
    end
  end

  function module:KeepTabButtonVisible(chatFrame)
    local tabButton = _G[chatFrame:GetName() .. "Tab"]
    tabButton:SetAlpha(1)
    tabButton.noMouseAlpha = 1
    tabButton.mouseAlpha = 1
    UIFrameFadeRemoveFrame(tabButton)
    return function()
      if chatFrame.hasBeenFaded then
        tabButton.noMouseAlpha = self.db.profile.activealpha
        tabButton.mouseAlpha = self.db.profile.activealpha
      else
        tabButton.noMouseAlpha = self.db.profile.notactivealpha
        tabButton.mouseAlpha = self.db.profile.notactivealpha
        UIFrameFadeOut(tabButton, 0.2, tabButton:GetAlpha(), tabButton.mouseAlpha)
      end
    end
  end

  function module:DoFlash(chatFrame)
    local tabButton = _G[chatFrame:GetName() .. "Tab"]

    if not self.chatTabTexture[chatFrame:GetName()] then
      self.chatTabTexture[chatFrame:GetName()] = tabButton:CreateTexture()
      local texture = self.chatTabTexture[chatFrame:GetName()]
      texture:SetTexture([[Interface\AddOns\Prat-3.0\textures\button-flash]])
      texture:SetPoint("BOTTOM", 0, -8)
      texture:SetHeight(32)
      texture:SetWidth(tabButton:GetWidth())
      texture.animation = texture:CreateAnimationGroup()
      local alpha = texture.animation:CreateAnimation("Alpha")
      alpha:SetFromAlpha(0)
      alpha:SetToAlpha(1)
      alpha:SetTargetParent()
      alpha:SetDuration(0.4)
      alpha:SetOrder(1)
      local alpha2 = texture.animation:CreateAnimation("Alpha")
      alpha2:SetFromAlpha(1)
      alpha2:SetToAlpha(0)
      alpha2:SetTargetParent()
      alpha2:SetDuration(0.4)
      alpha2:SetOrder(2)
      texture.animation:SetLooping("REPEAT")
    end

    local color = self.db.profile.highlighttabs[chatFrame:GetName()].flashcolor
    local highlight = self.chatTabTexture[chatFrame:GetName()]
    highlight:SetVertexColor(color.r, color.g, color.b, color.a)
    highlight:Show()
    highlight.animation:Restart()

    return function()
      if chatFrame.hasBeenFaded then
        tabButton.noMouseAlpha = self.db.profile.activealpha
        tabButton.mouseAlpha = self.db.profile.activealpha
      else
        tabButton.noMouseAlpha = self.db.profile.notactivealpha
        tabButton.mouseAlpha = self.db.profile.notactivealpha
        UIFrameFadeOut(tabButton, 0.2, tabButton:GetAlpha(), tabButton.mouseAlpha)
      end
      highlight:Hide()
    end
  end

  function module:DoFontColorChange(chatFrame)
    local tabButton = _G[chatFrame:GetName() .. "Tab"]
    local oldR, oldG, oldB, oldA  = tabButton:GetFontString():GetTextColor()
    local color = self.db.profile.highlighttabs[chatFrame:GetName()].fontcolor
    tabButton:GetFontString():SetTextColor(color.r, color.g, color.b, color.a)

    return function()
      tabButton:GetFontString():SetTextColor(oldR, oldG, oldB, oldA)
    end
  end


  return
end) -- Prat:AddModuleToLoad
