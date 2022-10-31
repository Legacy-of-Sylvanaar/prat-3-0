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

  local PRAT_MODULE = Prat:RequestModuleName("Font")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0", "AceEvent-3.0")

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Font"] = true,
    ["Chat window font options."] = true,
    ["Set Separately"] = true,
    ["Toggle setting options separately for each chat window."] = true,
    ["Set Font Face"] = true,
    ["Set the text font face for all chat windows."] = true,
    ["rememberfont_name"] = "Remember Font",
    ["rememberfont_desc"] = "Remember your font choice and restore it at startup.",
    ["Set Font Size"] = true,
    ["Set text font size for each chat window."] = true,
    ["Set ChatFrame%d Font Size"] = true,
    ["Set text font size."] = true,
    ["Auto Restore Font Size"] = true,
    ["Workaround a Blizzard bug which changes the font size when you open a system menu."] = true,
    ["outlinemode_name"] = "Set Outline Mode",
    ["outlinemode_desc"] = "Sets mode for the outline around the font.",
    ["None"] = true,
    ["Outline"] = true,
    ["Thick Outline"] = true,
    ["monochrome_name"] = "Toggle Monochrome",
    ["monochrome_desc"] = "Toggles monochrome coloring of the font.",
    ["shadowcolor_name"] = "Set Shadow Color",
    ["shadowcolor_desc"] = "Set the color of the shadow effect.",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Font")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]


  Prat:SetModuleDefaults(module, {
    profile = {
      on = true,
      fontface = "",
      rememberfont = false,
      size = { ["*"] = 12 },
      autorestore = false,
      outlinemode = "",
      monochrome = false,
      shadowcolor = {
        r = 0,
        g = 0,
        b = 0,
        a = 1,
      },
    }
  })

  local frameOption =
  {
    --  name = string.format(PL["Set ChatFrame%d Font Size"], num),
    name = function(info) return Prat.FrameList[info[#info]] or "" end,
    desc = PL["Set text font size."],
    type = "range",
    get = "GetSubValue",
    set = "SetSubValue",
    min = 4,
    max = 100,
    step = 1,
    hidden = function(info) return Prat.FrameList[info[#info]] == nil end,
  }


  Prat:SetModuleOptions(module, {
    name = PL["Font"],
    desc = PL["Chat window font options."],
    type = "group",
    args = {
      fontface = {
        name = PL["Set Font Face"],
        desc = PL["Set the text font face for all chat windows."],
        type = "select",
        dialogControl = 'LSM30_Font',
        values = AceGUIWidgetLSMlists.font,
        order = 110,
      },
      size = {
        name = PL["Set Font Size"],
        desc = PL["Set text font size for each chat window."],
        type = "group",
        inline = true,
        order = 130,
        args = {
          ChatFrame1 = frameOption,
          ChatFrame2 = frameOption,
          ChatFrame3 = frameOption,
          ChatFrame4 = frameOption,
          ChatFrame5 = frameOption,
          ChatFrame6 = frameOption,
          ChatFrame7 = frameOption,
        }
      },
      outlinemode = {
        name = PL["outlinemode_name"],
        desc = PL["outlinemode_desc"],
        type = "select",
        order = 150,
        values = { [""] = PL["None"], ["OUTLINE"] = PL["Outline"], ["THICKOUTLINE"] = PL["Thick Outline"] },
      },
      monochrome = {
        type = "toggle",
        name = PL["monochrome_name"],
        desc = PL["monochrome_desc"],
        order = 160,
      },
      shadowcolor = {
        name = PL["shadowcolor_name"],
        desc = PL["shadowcolor_desc"],
        type = "color",
        order = 170,
        get = "GetColorValue",
        set = "SetColorValue",
      },
      rememberfont = {
        type = "toggle",
        order = 120,
        name = PL["rememberfont_name"],
        desc = PL["rememberfont_desc"],
      },
    }
  })

  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --
  local media, FONT
  function module:OnModuleEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.oldsize = {}

    for k, cf in pairs(Prat.Frames) do
      local _, s, _ = cf:GetFont()
      self.oldsize[k] = s
    end

    if not self.db.profile.rememberfont then
      self.db.profile.fontface = nil
    end

    self:ConfigureAllChatFrames()

    self:SecureHook("FCF_SetChatWindowFontSize")

    media = Prat.Media
    FONT = media.MediaType.FONT
    media.RegisterCallback(self, "LibSharedMedia_Registered", "SharedMedia_Registered")
    media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "SharedMedia_Registered")

    Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
  end

  function module:GetDescription()
    return PL["Chat window font options."]
  end

  function module:SharedMedia_Registered(mediatype, name)
    if mediatype == FONT then
      if name == self.db.profile.fontface then
        self:ConfigureAllChatFrames()
      end
    end
  end

  function module:Prat_FramesUpdated(info, name, chatFrame, ...)
    self:ConfigureAllChatFrames()
  end


  function module:PLAYER_ENTERING_WORLD()
    self:ConfigureAllChatFrames()
    self:UnregisterAllEvents()
  end

  function module:OnModuleDisable()
    self:UnhookAll()
    media.UnregisterAllCallbacks(self)

    for k, cf in pairs(Prat.Frames) do
      self:SetFontSize(cf, self.oldsize[k] or 12)
    end
    self:SetFontMode("")
  end

  function module:GetSubValue(info)
    return self.db.profile[info[#info - 1]][info[#info]]
  end

  function module:SetSubValue(info, b)
    self.db.profile[info[#info - 1]][info[#info]] = b
    self:OnValueChanged(info, b)
  end


  --[[------------------------------------------------
    Core Functions
  ------------------------------------------------]] --

  function module:ConfigureAllChatFrames()
    local db = self.db.profile

    if db.fontface then
      self:SetFont(db.fontface)
    end

    -- aPLy font size settings
    for k, v in pairs(Prat.Frames) do
      self:SetFontSize(v, db.size[k])
    end
    -- aPLy font flag settings
    if not db.monochrome then
      self:SetFontMode(db.outlinemode)
    else
      self:SetFontMode(db.outlinemode .. ", MONOCHROME")
    end
  end

  function module:SetFontSize(cf, size)
    FCF_SetChatWindowFontSize(nil, cf, size)
  end


  function module:SetFont(font)
    local fontfile = Prat.Media:Fetch(Prat.Media.MediaType.FONT, font)
    for k, cf in pairs(Prat.Frames) do
      local f, s, m = cf:GetFont()
      cf:SetFont(fontfile, s, m)
    end
  end

  function module:SetFontMode(mode, monochrome)
    for k, cf in pairs(Prat.Frames) do
      local f, s, m = cf:GetFont()
      cf:SetFont(f, s, mode)

      if monochrome then
        local c = self.db.profile.shadowcolor
        cf:SetShadowColor(c.r, c.g, c.b, c.a)
      end
    end
  end

  function module:GetShadowClr()
    local h = self.db.profile.shadowcolor or {}
    return h.r or 1.0, h.g or 1.0, h.b or 1.0
  end

  function module:SetShadowClr(r, g, b)
    local db = self.db.profile
    db.shadowcolor = db.shadowcolor or {}
    local h = db.shadowcolor
    h.r, h.g, h.b = r, g, b
    self:ConfigureAllChatFrames()
  end

  function module:FCF_SetChatWindowFontSize(fcfself, chatFrame, fontSize)
    if not fcfself then return end

    if (not chatFrame) then
      chatFrame = FCF_GetCurrentChatFrame();
    end
    if (not fontSize) then
      fontSize = fcfself.value;
    end
    if self.db and self.db.profile.on then
      self.db.profile.size[chatFrame:GetName()] = fontSize
    end
  end

  module.OnValueChanged = module.ConfigureAllChatFrames
  module.OnSubValueChanged = module.ConfigureAllChatFrames
  module.OnColorValueChanged = module.ConfigureAllChatFrames

  return
end) -- Prat:AddModuleToLoad