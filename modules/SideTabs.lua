-------------------------------------------------------------------------------
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

  local PRAT_MODULE = Prat:RequestModuleName("SideTabs")
  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")
  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Side Tabs"] = true,
    ["Move chat tabs to the side of the chat frame and stack them vertically."] = true,
    ["Side"] = true,
    ["Which side of the chat frame to anchor tabs to."] = true,
    ["Left"] = true,
    ["Right"] = true,
    ["X Offset"] = true,
    ["Horizontal offset from the frame edge."] = true,
    ["Y Offset"] = true,
    ["Vertical offset from the top of the frame."] = true,
    ["Spacing"] = true,
    ["Space between vertically stacked tabs."] = true,
    ["Tab Width"] = true,
    ["Set a fixed tab width for a cleaner vertical stack."] = true,
    ["Apply to Undocked Windows"] = true,
    ["Also move tabs for non-docked chat windows."] = true,
    ["Simple Skin"] = true,
    ["Hide default tab art and draw a simple background for cleaner side tabs."] = true,
  })
  --@end-debug@

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      side = "LEFT", -- LEFT | RIGHT
      xoffset = -2,
      yoffset = -2,
      spacing = 2,
      tabwidth = 110,
      tabheight = 22,
      tabscale = 1.0,
      normalizeuiscale = false,
      fontface = "",
      fontsize = 0,
      fontcolor = {
        r = 1,
        g = 1,
        b = 1,
        a = 1,
      },
      undocked = true,
      simpleskin = false,
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = "Side Tabs",
    desc = "Move chat tabs to the side of the chat frame and stack them vertically.",
    type = "group",
    args = {
      side = {
        name = "Side",
        desc = "Which side of the chat frame to anchor tabs to.",
        type = "select",
        order = 100,
        values = { LEFT = "Left", RIGHT = "Right" },
      },
      xoffset = {
        name = "X Offset",
        desc = "Horizontal offset from the frame edge.",
        type = "range",
        order = 110,
        min = -40,
        max = 40,
        step = 1,
      },
      yoffset = {
        name = "Y Offset",
        desc = "Vertical offset from the top of the frame.",
        type = "range",
        order = 120,
        min = -40,
        max = 40,
        step = 1,
      },
      spacing = {
        name = "Spacing",
        desc = "Space between vertically stacked tabs.",
        type = "range",
        order = 130,
        min = 0,
        max = 20,
        step = 1,
      },
      tabwidth = {
        name = "Tab Width",
        desc = "Set a fixed tab width for a cleaner vertical stack.",
        type = "range",
        order = 140,
        min = 10,
        max = 200,
        step = 1,
      },
      tabheight = {
        name = "Tab Height",
        desc = "Set tab button height for the vertical stack.",
        type = "range",
        order = 145,
        min = 14,
        max = 40,
        step = 1,
      },
      tabscale = {
        name = "Tab Scale",
        desc = "Scale tab button size without changing your chosen width/height values.",
        type = "range",
        order = 146,
        min = 0.7,
        max = 1.5,
        step = 0.05,
      },
      normalizeuiscale = {
        name = "Normalize for UI Scale",
        desc = "Compensate tab size and offsets for WoW native UI scale.",
        type = "toggle",
        order = 147,
      },
      fontface = {
        name = "Font",
        desc = "Select the tab text font.",
        type = "select",
        dialogControl = "LSM30_Font",
        values = (AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font) or {},
        order = 170,
      },
      fontsize = {
        name = "Font Size",
        desc = "Set tab text font size. Set to 0 to keep the default size.",
        type = "range",
        order = 171,
        min = 0,
        max = 32,
        step = 1,
      },
      fontcolor = {
        name = "Font Color",
        desc = "Set tab text color.",
        type = "color",
        hasAlpha = true,
        order = 172,
        get = "GetColorValue",
        set = "SetColorValue",
      },
      undocked = {
        name = "Apply to Undocked Windows",
        desc = "Also move tabs for non-docked chat windows.",
        type = "toggle",
        order = 150,
      },
      simpleskin = {
        name = "Simple Skin",
        desc = "Hide default tab art and draw a simple background for cleaner side tabs.",
        type = "toggle",
        order = 160,
      },
    }
  })

  local function GetTab(frame)
    if not frame then return nil end
    return _G[frame:GetName() .. "Tab"]
  end

  function module:ApplySkin(tab, simpleOverride)
    if not tab then return end

    local simple = simpleOverride
    if simple == nil then
      simple = self.db.profile.simpleskin
    end

    if tab.Left then tab.Left:SetShown(not simple) end
    if tab.Middle then tab.Middle:SetShown(not simple) end
    if tab.Right then tab.Right:SetShown(not simple) end
    if tab.ActiveLeft then tab.ActiveLeft:SetShown(not simple) end
    if tab.ActiveMiddle then tab.ActiveMiddle:SetShown(not simple) end
    if tab.ActiveRight then tab.ActiveRight:SetShown(not simple) end

    if simple then
      if not tab.PratSideTabsBG then
        local bg = tab:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(tab)
        bg:SetColorTexture(0, 0, 0, 0.35)
        tab.PratSideTabsBG = bg
      end
      tab.PratSideTabsBG:Show()
    elseif tab.PratSideTabsBG then
      tab.PratSideTabsBG:Hide()
    end
  end

  function module:ApplyTextStyle(tab)
    if not tab then return end

    local fs = tab.Text or tab:GetFontString()
    if not fs then return end

    if not tab.PratSideTabsTextDefaults then
      local f, s, m = fs:GetFont()
      local r, g, b, a = fs:GetTextColor()
      tab.PratSideTabsTextDefaults = {
        font = f,
        size = s,
        mode = m,
        r = r,
        g = g,
        b = b,
        a = a,
      }
    end

    local defaults = tab.PratSideTabsTextDefaults
    local p = self.db.profile

    local fontfile = defaults.font
    if p.fontface and p.fontface ~= "" then
      fontfile = Prat.Media:Fetch(Prat.Media.MediaType.FONT, p.fontface) or defaults.font
    end

    local fontsize = defaults.size
    if p.fontsize and p.fontsize > 0 then
      fontsize = p.fontsize
    end

    fs:SetFont(fontfile, fontsize, defaults.mode)

    local c = p.fontcolor or defaults
    fs:SetTextColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
  end

  function module:RestoreTextStyle(tab)
    if not tab or not tab.PratSideTabsTextDefaults then return end

    local fs = tab.Text or tab:GetFontString()
    if not fs then return end

    local d = tab.PratSideTabsTextDefaults
    fs:SetFont(d.font, d.size, d.mode)
    fs:SetTextColor(d.r, d.g, d.b, d.a)
  end

  function module:AnchorTab(tab, anchor, prevTab)
    if not tab or not anchor then return prevTab end

    local p = self.db.profile
    local side = p.side

    if tab.PratSideTabsDefaultHeight == nil then
      tab.PratSideTabsDefaultHeight = tab:GetHeight()
    end
    if tab.PratSideTabsDefaultScale == nil then
      tab.PratSideTabsDefaultScale = tab:GetScale()
    end

    -- Dock scroll-frame tabs are clipped when anchored outside their parent;
    -- use a top-level parent so side tabs remain visible.
    local fullscreenParent = (FCF_GetCurrentFullScreenFrame and FCF_GetCurrentFullScreenFrame()) or UIParent
    if tab:GetParent() ~= fullscreenParent then
      tab:SetParent(fullscreenParent)
    end

    local normalize = 1
    if p.normalizeuiscale then
      local parentScale = fullscreenParent:GetEffectiveScale() or UIParent:GetEffectiveScale() or 1
      normalize = 1 / math.max(parentScale, 0.01)
    end

    local xoffset = p.xoffset * normalize
    local yoffset = p.yoffset * normalize
    local spacing = p.spacing * normalize
    local tabwidth = p.tabwidth * normalize
    local tabheight = p.tabheight * normalize

    tab:ClearAllPoints()

    if side == "LEFT" then
      if prevTab then
        tab:SetPoint("TOPRIGHT", prevTab, "BOTTOMRIGHT", 0, -spacing)
      else
        tab:SetPoint("TOPRIGHT", anchor, "TOPLEFT", xoffset, yoffset)
      end
    else
      if prevTab then
        tab:SetPoint("TOPLEFT", prevTab, "BOTTOMLEFT", 0, -spacing)
      else
        tab:SetPoint("TOPLEFT", anchor, "TOPRIGHT", xoffset, yoffset)
      end
    end

    PanelTemplates_TabResize(tab, tab.sizePadding or 0, tabwidth)
    tab:SetHeight(tabheight)
    tab:SetScale(p.tabscale)
    self:ApplySkin(tab)
    self:ApplyTextStyle(tab)
    FCF_CheckShowChatFrame(tab)

    return tab
  end

  function module:LayoutDockedTabs()
    if not GENERAL_CHAT_DOCK or not GENERAL_CHAT_DOCK.primary then
      return
    end

    local anchor = GENERAL_CHAT_DOCK.primary.Background or GENERAL_CHAT_DOCK.primary
    local prevTab = nil

    for _, frame in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK) or {}) do
      local tab = GetTab(frame)
      if tab then
        prevTab = self:AnchorTab(tab, anchor, prevTab)
      end
    end
  end

  function module:LayoutUndockedTabs()
    if not self.db.profile.undocked then
      return
    end

    for _, frame in pairs(Prat.Frames) do
      if frame and not frame.isDocked then
        local tab = GetTab(frame)
        if tab and tab:IsShown() then
          local anchor = frame.Background or frame
          self:AnchorTab(tab, anchor, nil)
        end
      end
    end
  end

  function module:ApplyAll()
    if not self:IsEnabled() or not self.db.profile.on then
      return
    end

    self:LayoutDockedTabs()
    self:LayoutUndockedTabs()
  end

  function module:QueueApply()
    if self._pendingApply then
      return
    end

    self._pendingApply = true
    C_Timer.After(0, function()
      self._pendingApply = nil
      if self:IsEnabled() and self.db and self.db.profile and self.db.profile.on then
        self:ApplyAll()
      end
    end)
  end

  function module:RestoreDefaults()
    FCF_DockUpdate()

    for _, frame in pairs(Prat.Frames) do
      if frame and not frame.isDocked then
        FCF_SetTabPosition(frame, 0)
      end
      local tab = GetTab(frame)
      if tab then
        if tab.PratSideTabsDefaultHeight ~= nil then
          tab:SetHeight(tab.PratSideTabsDefaultHeight)
        end
        if tab.PratSideTabsDefaultScale ~= nil then
          tab:SetScale(tab.PratSideTabsDefaultScale)
        end
        self:ApplySkin(tab, false)
        self:RestoreTextStyle(tab)
      end
    end
  end

  function module:OnModuleEnable()
    -- Blizzard frequently reanchors tabs; re-apply after each update path.
    self:SecureHook("FCF_DockUpdate", "QueueApply")
    self:SecureHook("FCFDock_UpdateTabs", "QueueApply")
    self:SecureHook("FloatingChatFrame_Update", "QueueApply")
    self:SecureHook("FCF_SetTabPosition", "QueueApply")

    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)

    -- Apply immediately and once again on the next frame to catch startup reanchors.
    self:ApplyAll()
    self:QueueApply()
  end

  function module:OnModuleDisable()
    Prat.UnregisterAllChatEvents(self)
    self:UnhookAll()
    self:RestoreDefaults()
  end

  function module:Prat_FramesUpdated()
    self:QueueApply()
  end

  function module:OnValueChanged()
    if self.db.profile.on then
      self:QueueApply()
    else
      self:RestoreDefaults()
    end
  end

  module.OnColorValueChanged = module.OnValueChanged

  return
end)
