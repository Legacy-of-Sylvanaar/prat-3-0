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
  local MODULE_NAME = "SideTabs"
  local EMPTY_TABLE = {}
  local module = Prat:NewModule(MODULE_NAME, "AceHook-3.0")
  local PL = module.PL

  --@debug@
  PL:AddLocale(MODULE_NAME, "enUS", {
    ["SideTabs"] = true,
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
    ["Hide default tab art and draw a simple background for a cleaner SideTabs look."] = true,
  })
  --@end-debug@

  Prat:SetModuleDefaults(module, {
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
      labelsenabled = false,
      labelmode = { ["*"] = "default" },
      customlabel = { ["*"] = "" },
      labelpreset = { ["*"] = "STAR" },
      labelshape = { ["*"] = "SQUARE" },
      labelcolor = {
        ["*"] = {
          r = 1,
          g = 1,
          b = 1,
          a = 1,
        },
      },
      undocked = true,
      simpleskin = false,
    }
  })

  local function GroupLabel(text)
    return text
  end

  local function SettingLabel(text)
    return "|cffffffff" .. text .. "|r"
  end

  local function GetInfoFrameName(info)
    for i = #info, 1, -1 do
      local v = info[i]
      if type(v) == "string" and v:match("^ChatFrame%d+$") then
        return v
      end
    end
    return nil
  end

  local function MakeTabLabelOption(order)
    return {
      name = function(info) return Prat.FrameList[info[#info]] or info[#info] end,
      type = "group",
      order = order,
      args = {
        labelmode = {
          name = SettingLabel("Label Mode"),
          desc = "How this tab label should be rendered.",
          type = "select",
          order = 100,
          values = {
            ["default"] = "Default Name",
            ["preset"] = "Symbol / Glyph",
            ["shape"] = "Colored Shape",
            ["custom"] = "Custom Text",
          },
          sorting = { "default", "preset", "shape", "custom" },
          get = "GetTabLabelValue",
          set = "SetTabLabelValue",
        },
        labelpreset = {
          name = SettingLabel("Symbol / Glyph"),
          desc = "Choose a native symbol-like marker for this tab.",
          type = "select",
          order = 110,
          values = {
            ["STAR"] = "Star",
            ["CIRCLE"] = "Circle",
            ["DIAMOND"] = "Diamond",
            ["TRIANGLE"] = "Triangle",
            ["MOON"] = "Moon",
            ["SKULL"] = "Skull",
          },
          hidden = function(info)
            local profile = module.db and module.db.profile
            if not profile then return true end
            local frameName = GetInfoFrameName(info)
            if not frameName then return true end
            return (profile.labelmode and profile.labelmode[frameName]) ~= "preset"
          end,
          get = "GetTabLabelValue",
          set = "SetTabLabelValue",
        },
        labelshape = {
          name = SettingLabel("Shape"),
          desc = "Choose a simple shape for this tab.",
          type = "select",
          order = 120,
          values = {
            ["SQUARE"] = "Square",
            ["CIRCLE"] = "Circle",
          },
          hidden = function(info)
            local profile = module.db and module.db.profile
            if not profile then return true end
            local frameName = GetInfoFrameName(info)
            if not frameName then return true end
            return (profile.labelmode and profile.labelmode[frameName]) ~= "shape"
          end,
          get = "GetTabLabelValue",
          set = "SetTabLabelValue",
        },
        labelcolor = {
          name = SettingLabel("Shape Color"),
          desc = "Set the shape color (with alpha).",
          type = "color",
          hasAlpha = true,
          order = 130,
          hidden = function(info)
            local profile = module.db and module.db.profile
            if not profile then return true end
            local frameName = GetInfoFrameName(info)
            if not frameName then return true end
            return (profile.labelmode and profile.labelmode[frameName]) ~= "shape"
          end,
          get = "GetTabLabelColorValue",
          set = "SetTabLabelColorValue",
        },
        customlabel = {
          name = SettingLabel("Custom Label"),
          desc = "Set custom text, symbol, or emoji for this tab.",
          type = "input",
          width = "full",
          order = 140,
          hidden = function(info)
            local profile = module.db and module.db.profile
            if not profile then return true end
            local frameName = GetInfoFrameName(info)
            if not frameName then return true end
            return (profile.labelmode and profile.labelmode[frameName]) ~= "custom"
          end,
          get = "GetTabLabelValue",
          set = "SetTabLabelValue",
        },
      },
    }
  end

  Prat:SetModuleOptions(module, {
    name = "SideTabs",
    desc = "Move chat tabs to the side of the chat frame and stack them vertically.",
    type = "group",
    args = {
      layout = {
        name = GroupLabel("Layout"),
        type = "group",
        inline = true,
        order = 100,
        args = {
          side = {
            name = SettingLabel("Side"),
            desc = "Which side of the chat frame to anchor tabs to.",
            type = "select",
            order = 100,
            values = { LEFT = "Left", RIGHT = "Right" },
          },
          xoffset = {
            name = SettingLabel("X Offset"),
            desc = "Horizontal offset from the frame edge.",
            type = "range",
            order = 110,
            min = -40,
            max = 40,
            step = 1,
          },
          yoffset = {
            name = SettingLabel("Y Offset"),
            desc = "Vertical offset from the top of the frame.",
            type = "range",
            order = 120,
            min = -40,
            max = 40,
            step = 1,
          },
          spacing = {
            name = SettingLabel("Spacing"),
            desc = "Space between vertically stacked tabs.",
            type = "range",
            order = 130,
            min = 0,
            max = 20,
            step = 1,
          },
        },
      },
      sizing = {
        name = GroupLabel("Sizing"),
        type = "group",
        inline = true,
        order = 110,
        args = {
          tabwidth = {
            name = SettingLabel("Tab Width"),
            desc = "Set a fixed tab width for a cleaner vertical stack.",
            type = "range",
            order = 140,
            min = 10,
            max = 200,
            step = 1,
          },
          tabheight = {
            name = SettingLabel("Tab Height"),
            desc = "Set tab button height for the vertical stack.",
            type = "range",
            order = 145,
            min = 14,
            max = 40,
            step = 1,
          },
          tabscale = {
            name = SettingLabel("Tab Scale"),
            desc = "Scale tab button size without changing your chosen width/height values.",
            type = "range",
            order = 146,
            min = 0.7,
            max = 1.5,
            step = 0.05,
          },
          normalizeuiscale = {
            name = SettingLabel("Normalize for UI Scale"),
            desc = "Compensate tab size and offsets for WoW native UI scale.",
            type = "toggle",
            order = 147,
          },
        },
      },
      text = {
        name = GroupLabel("Text"),
        type = "group",
        inline = true,
        order = 120,
        args = {
          fontface = {
            name = SettingLabel("Font"),
            desc = "Select the tab text font.",
            type = "select",
            dialogControl = "LSM30_Font",
            values = (AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font) or {},
            order = 170,
          },
          fontsize = {
            name = SettingLabel("Font Size"),
            desc = "Set tab text font size.",
            type = "range",
            order = 171,
            min = 4,
            max = 32,
            step = 1,
          },
          fontcolor = {
            name = SettingLabel("Font Color"),
            desc = "Set tab text color.",
            type = "color",
            hasAlpha = true,
            order = 172,
            get = "GetColorValue",
            set = "SetColorValue",
          },
        },
      },
      behavior = {
        name = GroupLabel("Behavior"),
        type = "group",
        inline = true,
        order = 130,
        args = {
          undocked = {
            name = SettingLabel("Apply to Undocked Windows"),
            desc = "Also move tabs for non-docked chat windows.",
            type = "toggle",
            order = 150,
          },
        },
      },
      visual = {
        name = GroupLabel("Visual"),
        type = "group",
        inline = true,
        order = 140,
        args = {
          simpleskin = {
            name = SettingLabel("Simple Skin"),
            desc = "Hide default tab art and draw a simple background for a cleaner SideTabs look.",
            type = "toggle",
            order = 160,
          },
        },
      },
      tablabels = {
        name = GroupLabel("Tab Labels"),
        type = "group",
        childGroups = "tree",
        order = 150,
        args = {
          labelsenabled = {
            name = SettingLabel("Enable Per-tab Labels"),
            desc = "Replace chat tab names with per-tab symbols, shapes, or custom labels.",
            type = "toggle",
            order = 10,
          },
          help = {
            type = "description",
            order = 20,
            name = "Configure each tab below. Choose Label Mode per tab: Default Name keeps Blizzard text, while Symbol / Glyph, Colored Shape, and Custom Text replace it.",
          },
          ChatFrame1 = MakeTabLabelOption(101),
          ChatFrame2 = MakeTabLabelOption(102),
          ChatFrame3 = MakeTabLabelOption(103),
          ChatFrame4 = MakeTabLabelOption(104),
          ChatFrame5 = MakeTabLabelOption(105),
          ChatFrame6 = MakeTabLabelOption(106),
          ChatFrame7 = MakeTabLabelOption(107),
          ChatFrame8 = MakeTabLabelOption(108),
          ChatFrame9 = MakeTabLabelOption(109),
          ChatFrame10 = MakeTabLabelOption(110),
        },
      },
    }
  })

  local function GetTab(frame)
    if not frame then return nil end
    return _G[frame:GetName() .. "Tab"]
  end

  local function IsTabHovered(tab)
    if not tab or not tab:IsShown() then
      return false
    end

    if tab:IsMouseOver() then
      return true
    end

    if tab.Text and tab.Text:IsMouseOver() then
      return true
    end

    if tab.conversationIcon and tab.conversationIcon:IsShown() and tab.conversationIcon:IsMouseOver() then
      return true
    end

    return false
  end

  local function IsAnyDockedTabHovered()
    local dock = GENERAL_CHAT_DOCK
    if not dock then return false end

    if not FCFDock_GetChatFrames then
      return false
    end

    for _, frame in ipairs(FCFDock_GetChatFrames(dock) or EMPTY_TABLE) do
      local tab = _G[frame:GetName() .. "Tab"]
      if IsTabHovered(tab) then
        return true
      end
    end

    return false
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

  local PRESET_LABELS = {
    STAR = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14:0:0|t",
    CIRCLE = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:14:14:0:0|t",
    DIAMOND = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14:0:0|t",
    TRIANGLE = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14:0:0|t",
    MOON = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:14:14:0:0|t",
    SKULL = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:14:14:0:0|t",
  }

  local function EnsureShapeTexture(tab)
    if not tab.PratSideTabsShapeTex then
      local tex = tab:CreateTexture(nil, "OVERLAY")
      tex:SetPoint("CENTER", tab, "CENTER", 0, 0)
      tex:SetTexture("Interface\\Buttons\\WHITE8X8")
      tab.PratSideTabsShapeTex = tex
    end

    return tab.PratSideTabsShapeTex
  end

  local function EnsureShapeCircleMask(tab)
    if not tab.PratSideTabsShapeMask then
      local mask = tab:CreateMaskTexture(nil, "OVERLAY")
      mask:SetPoint("CENTER", tab, "CENTER", 0, 0)
      -- This is a built-in circular alpha mask used by Blizzard UI.
      mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
      tab.PratSideTabsShapeMask = mask
    end

    return tab.PratSideTabsShapeMask
  end

  local function HideShapeTexture(tab)
    if tab and tab.PratSideTabsShapeTex then
      tab.PratSideTabsShapeTex:Hide()
    end
  end

  function module:ApplyShapeLabel(tab, shape, color)
    if not tab then return end

    local tex = EnsureShapeTexture(tab)
    local mask = EnsureShapeCircleMask(tab)
    local fs = tab.Text or tab:GetFontString()
    local fontSize = 12
    if fs then
      local _, s = fs:GetFont()
      fontSize = s or 12
    end
    local shapeSize = math.max(8, math.floor((fontSize or 12) * 0.9 + 0.5))

    tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    tex:SetSize(shapeSize, shapeSize)

    if shape == "CIRCLE" then
      -- Filled/tintable circle using a circular alpha mask (no border ring).
      mask:SetSize(shapeSize, shapeSize)
      tex:RemoveMaskTexture(mask)
      tex:AddMaskTexture(mask)
    else
      tex:RemoveMaskTexture(mask)
    end

    tex:SetVertexColor(color.r or 1, color.g or 1, color.b or 1, color.a or 1)
    tex:Show()
  end

  function module:GetTabLabelValue(info)
    local key = info[#info]
    local frameName = GetInfoFrameName(info)
    if not frameName then return nil end
    local profile = self.db and self.db.profile
    if not profile then return nil end
    local section = profile[key]
    if not section then return nil end
    return section[frameName]
  end

  function module:SetTabLabelValue(info, value)
    local key = info[#info]
    local frameName = GetInfoFrameName(info)
    if not frameName then return end
    local profile = self.db and self.db.profile
    if not profile then return end
    profile[key] = profile[key] or {}
    profile[key][frameName] = value
    self:OnValueChanged()
  end

  function module:GetTabLabelColorValue(info)
    local frameName = GetInfoFrameName(info)
    if not frameName then
      return 1, 1, 1, 1
    end
    local profile = self.db and self.db.profile
    if not profile then
      return 1, 1, 1, 1
    end

    local section = profile.labelcolor or {}
    local c = section[frameName] or { r = 1, g = 1, b = 1, a = 1 }
    return c.r, c.g, c.b, c.a
  end

  function module:SetTabLabelColorValue(info, r, g, b, a)
    local frameName = GetInfoFrameName(info)
    if not frameName then return end
    local profile = self.db and self.db.profile
    if not profile then return end

    profile.labelcolor = profile.labelcolor or {}
    profile.labelcolor[frameName] = profile.labelcolor[frameName] or {}
    local c = profile.labelcolor[frameName]
    c.r, c.g, c.b, c.a = r, g, b, a
    self:OnValueChanged()
  end

  function module:ApplyTabLabel(frame, tab)
    if not frame or not tab then return end

    if not tab.PratSideTabsDefaultText then
      tab.PratSideTabsDefaultText = tab:GetText()
    end

    if not self.db.profile.labelsenabled then
      HideShapeTexture(tab)
      tab:SetText(frame.name or tab.PratSideTabsDefaultText or "")
      return
    end

    local frameName = frame:GetName()
    local mode = self.db.profile.labelmode[frameName] or "default"

    if mode == "default" then
      HideShapeTexture(tab)
      tab:SetText(frame.name or tab.PratSideTabsDefaultText or "")
      return
    end

    if mode == "custom" then
      HideShapeTexture(tab)
      local custom = self.db.profile.customlabel[frameName]
      if custom and custom ~= "" then
        tab:SetText(custom)
      else
        tab:SetText(frame.name or tab.PratSideTabsDefaultText or "")
      end
      return
    end

    if mode == "preset" then
      HideShapeTexture(tab)
      local preset = self.db.profile.labelpreset[frameName] or "STAR"
      tab:SetText(PRESET_LABELS[preset] or PRESET_LABELS.STAR)
      return
    end

    if mode == "shape" then
      local shape = self.db.profile.labelshape[frameName] or "SQUARE"
      local color = self.db.profile.labelcolor[frameName] or { r = 1, g = 1, b = 1, a = 1 }
      tab:SetText(" ")
      self:ApplyShapeLabel(tab, shape, color)
      return
    end

    HideShapeTexture(tab)
    tab:SetText(frame.name or tab.PratSideTabsDefaultText or "")
  end

  function module:RestoreTabLabel(frame, tab)
    if not frame or not tab then return end
    HideShapeTexture(tab)
    tab:SetText(frame.name or tab.PratSideTabsDefaultText or "")
  end

  function module:ApplyTextLayout(tab)
    if not tab then return end

    local fs = tab.Text or tab:GetFontString()
    if not fs then return end

    if not tab.PratSideTabsTextLayoutDefaults then
      tab.PratSideTabsTextLayoutDefaults = {
        points = {},
        justifyH = fs:GetJustifyH(),
        justifyV = fs:GetJustifyV(),
        width = fs:GetWidth(),
      }

      for i = 1, fs:GetNumPoints() do
        local p, rel, rp, x, y = fs:GetPoint(i)
        tab.PratSideTabsTextLayoutDefaults.points[i] = { p, rel, rp, x, y }
      end
    end

    fs:ClearAllPoints()
    fs:SetPoint("CENTER", tab, "CENTER", 0, 0)
    fs:SetJustifyH("CENTER")
    fs:SetJustifyV("MIDDLE")
    fs:SetWidth(math.max(1, tab:GetWidth() - 4))
  end

  function module:RestoreTextLayout(tab)
    if not tab or not tab.PratSideTabsTextLayoutDefaults then return end

    local fs = tab.Text or tab:GetFontString()
    if not fs then return end

    local d = tab.PratSideTabsTextLayoutDefaults
    fs:ClearAllPoints()
    if d.points and #d.points > 0 then
      for _, point in ipairs(d.points) do
        fs:SetPoint(point[1], point[2], point[3], point[4], point[5])
      end
    end

    if d.justifyH then fs:SetJustifyH(d.justifyH) end
    if d.justifyV then fs:SetJustifyV(d.justifyV) end
    if d.width and d.width > 0 then
      fs:SetWidth(d.width)
    end
  end

  function module:AnchorTab(tab, anchor, prevTab, frame)
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

    if PanelTemplates_TabResize then
      PanelTemplates_TabResize(tab, 0, tabwidth)
    end
    tab:SetHeight(tabheight)
    tab:SetScale(p.tabscale)
    self:ApplyTextLayout(tab)
    local fallbackFrame = FCF_GetChatFrameByID and FCF_GetChatFrameByID(tab:GetID()) or nil
    self:ApplyTabLabel(frame or fallbackFrame, tab)
    self:ApplySkin(tab)
    self:ApplyTextStyle(tab)
    if FCF_CheckShowChatFrame then
      FCF_CheckShowChatFrame(tab)
    end

    return tab
  end

  function module:LayoutDockedTabs()
    if not GENERAL_CHAT_DOCK or not GENERAL_CHAT_DOCK.primary or not FCFDock_GetChatFrames then
      return
    end

    local anchor = GENERAL_CHAT_DOCK.primary.Background or GENERAL_CHAT_DOCK.primary
    local prevTab = nil

    for _, frame in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK) or EMPTY_TABLE) do
      local tab = GetTab(frame)
      if tab then
        prevTab = self:AnchorTab(tab, anchor, prevTab, frame)
      end
    end
  end

  function module:LayoutUndockedTabs()
    if not self.db.profile.undocked or not Prat.Frames then
      return
    end

    for _, frame in pairs(Prat.Frames) do
      if frame and not frame.isDocked then
        local tab = GetTab(frame)
        if tab and tab:IsShown() then
          local anchor = frame.Background or frame
          self:AnchorTab(tab, anchor, nil, frame)
        end
      end
    end
  end

  function module:ApplyAll()
    local profile = self.db and self.db.profile
    if not self:IsEnabled() or not profile or not profile.on then
      return
    end

    self:LayoutDockedTabs()
    self:LayoutUndockedTabs()
  end

  function module:FCF_OnUpdate(elapsed)
    if not CHAT_TAB_SHOW_DELAY or not FCF_FadeInChatFrame then
      return
    end

    -- Blizzard's hover fade logic checks the chat frame/top region, not moved side tabs.
    -- Keep fade timers alive while the cursor is over a side tab.
    for _, frameName in ipairs(CHAT_FRAMES or EMPTY_TABLE) do
      local chatFrame = _G[frameName]
      local chatTab = _G[frameName .. "Tab"]
      if chatFrame and chatTab and chatFrame:IsShown() and chatTab:IsShown() and chatTab:IsMouseOver() then
        chatFrame.mouseOutTime = 0
        chatFrame.mouseInTime = (chatFrame.mouseInTime or 0) + (elapsed or 0)
        if not chatFrame.hasBeenFaded and chatFrame.mouseInTime > CHAT_TAB_SHOW_DELAY then
          FCF_FadeInChatFrame(chatFrame)
        end
      end
    end
  end

  function module:FCF_FadeOutChatFrame(chatFrame)
    if not chatFrame then
      if self.hooks and self.hooks.FCF_FadeOutChatFrame then
        return self.hooks.FCF_FadeOutChatFrame(chatFrame)
      end
      return
    end

    if not FCF_FadeInChatFrame then
      if self.hooks and self.hooks.FCF_FadeOutChatFrame then
        return self.hooks.FCF_FadeOutChatFrame(chatFrame)
      end
      return
    end

    if chatFrame.isDocked and IsAnyDockedTabHovered() then
      -- Any hovered docked tab should keep docked chat tabs visible.
      chatFrame.mouseOutTime = 0
      FCF_FadeInChatFrame(chatFrame)
      return
    end

    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    if IsTabHovered(chatTab) then
      -- Preserve default behavior semantics while hovered over a moved side tab.
      chatFrame.mouseOutTime = 0
      FCF_FadeInChatFrame(chatFrame)
      return
    end

    if self.hooks and self.hooks.FCF_FadeOutChatFrame then
      return self.hooks.FCF_FadeOutChatFrame(chatFrame)
    end
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
    if FCF_DockUpdate then
      FCF_DockUpdate()
    end

    if not Prat.Frames then
      return
    end

    for _, frame in pairs(Prat.Frames) do
      if frame and not frame.isDocked and FCF_SetTabPosition then
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
        self:RestoreTabLabel(frame, tab)
        self:RestoreTextLayout(tab)
        self:ApplySkin(tab, false)
        self:RestoreTextStyle(tab)
      end
    end
  end

  function module:OnModuleEnable()
    local function HookIfPresent(kind, globalName, method)
      if not _G[globalName] then
        return
      end

      if kind == "secure" then
        self:SecureHook(globalName, method)
      else
        self:RawHook(globalName, true)
      end
    end

    -- Blizzard frequently reanchors tabs; re-apply after each update path.
    HookIfPresent("secure", "FCF_DockUpdate", "QueueApply")
    HookIfPresent("secure", "FCFDock_UpdateTabs", "QueueApply")
    HookIfPresent("secure", "FloatingChatFrame_Update", "QueueApply")
    HookIfPresent("secure", "FCF_SetTabPosition", "QueueApply")
    HookIfPresent("secure", "FCF_OnUpdate", "FCF_OnUpdate")
    HookIfPresent("raw", "FCF_FadeOutChatFrame", "FCF_FadeOutChatFrame")

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
