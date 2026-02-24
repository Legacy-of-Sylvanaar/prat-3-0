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
  local mod = Prat:NewModule("Frames", "AceHook-3.0")

  local PL = mod.PL

  --@debug@
  PL:AddLocale("enUS", {
    ["Frames"] = true,
    ["Chat window frame parameter options"] = true,
    ["removeclamp_name"] = "Zero Clamp Size",
    ["removeclamp_desc"] = "Allow the chatframe to be moved flush with the edge of the screen",
    ["minchatwidth_name"] = "Set Minimum Width",
    ["minchatwidth_desc"] = "Sets the minimum width for all chat windows.",
    ["maxchatwidth_name"] = "Set Maximum Width",
    ["maxchatwidth_desc"] = "Sets the maximum width for all chat windows.",
    ["minchatheight_name"] = "Set Minimum Height",
    ["minchatheight_desc"] = "Sets the minimum height for all chat windows.",
    ["maxchatheight_name"] = "Set Maximum Height",
    ["maxchatheight_desc"] = "Sets the maximum height for all chat windows.",
    ["mainchatonload_name"] = "Force Main Chat Frame On Load",
    ["mainchatonload_desc"] = "Automatically select the first chat frame and make it active on load.",
    ["framealphastatic_name"] = "Static Chatframe Alpha",
    ["framealphastatic_desc"] = "Set the transparency of the chatframe to always match the configured transparency",
    ["defaultframealpha_name"] = "Default alpha on mouseover",
    ["defaultframealpha_desc"] = "Sets minimum alpha for the chat on mouseover when the static chatframe alpha setting is disabled AND the default alpha is greater than the custom alpha set to the chat window.",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/

  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("enUS", L)

--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("itIT", L)

--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("ptBR", L)

--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("frFR", L)

--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("deDE", L)

--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("koKR", L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("esMX", L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("ruRU", L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("zhCN", L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("esES",  L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Frames")@
PL:AddLocale("zhTW", L)
end
--@end-non-debug@]===]



  -- We have to set the insets here before blizzard has a chance to move them
  for i = 1, NUM_CHAT_WINDOWS do
    local f = _G["ChatFrame" .. i]
    f:SetClampRectInsets(0, 0, 0, 0)
  end


  Prat:SetModuleDefaults(mod.name, {
    profile = {
      on = true,
      minchatwidth = 160,
      minchatwidthdefault = 160,
      maxchatwidth = 800,
      maxchatwidthdefault = 800,
      minchatheight = 120,
      minchatheightdefault = 120,
      maxchatheight = 600,
      maxchatheightdefault = 600,
      mainchatonload = true,
      removeclamp = true,
      framealphastatic = false,
      defaultframealpha = 0.25,
      framemetrics = {
        ['*'] = {
          width = 430,
          height = 120,
        }
      }
    }
  })

  do
    local frameoption = {
      name = function(info) return PL[info[#info] .. "_name"] end,
      desc = function(info) return PL[info[#info] .. "_desc"] end,
      type = "range",
      min = 25,
      max = 1024,
      step = 1
    }

    Prat:SetModuleOptions(mod.name, {
      name = PL["Frames"],
      desc = PL["Chat window frame parameter options"],
      type = "group",
      args = {
        minchatwidth = frameoption,
        maxchatwidth = frameoption,
        minchatheight = frameoption,
        maxchatheight = frameoption,
        removeclamp = {
          type = "toggle",
          order = 110,
          name = PL["removeclamp_name"],
          desc = PL["removeclamp_desc"],
        },
        framealphastatic = {
          type = "toggle",
          order = 130,
          name = PL.framealphastatic_name,
          desc = PL.framealphastatic_desc,
        },
        defaultframealpha = {
          name = PL["defaultframealpha_name"],
          desc = PL["defaultframealpha_desc"],
          type = "range",
          order = 140,
          min = 0.0,
          max = 1,
          step = 0.01,
        },
      }
    })
  end


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  Prat:SetModuleInit(mod, function(self) mod:GetDefaults() end)

  function mod:OnModuleEnable()
    CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
    self:ConfigureAllChatFrames(true)
    self:SecureHook("FCF_DockFrame")
    self:SecureHook("FCF_UnDockFrame")
    self:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors")

    self:SecureHook("FCF_SetWindowAlpha")
    self:SecureHook("FCF_SetWindowColor")

    if not Prat.IsClassic then
      local prevClamp = ChatFrame1.SetClampRectInsets
      self:SecureHook(ChatFrame1, "SetClampRectInsets", function(frame, ...)
		  -- If in combat, SetClampRectInsets is protected... This should likely never happen, but to be safe.
		  if _G.InCombatLockdown() then
			  return
		  end
        if self.db.profile.on and self.db.profile.removeclamp then
          prevClamp(frame, 0, 0, 0, 0)
        end
      end)
    end
  end


  function mod:OnModuleDisable()
    CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0.2
    self:ConfigureAllChatFrames(false)
  end

  function mod:GetDescription()
    return PL["Chat window frame parameter options"]
  end


  function mod:FloatingChatFrame_UpdateBackgroundAnchors(frame)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end
  function mod:FCF_DockFrame(frame, ...)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end

  function mod:FCF_UnDockFrame(frame, ...)
    if self.db.profile.removeclamp then
      frame:SetClampRectInsets(0, 0, 0, 0)
    end
    Prat.Frames[frame:GetName()] = frame
    local m = Prat:GetModule("Font", true)
    if m then m:ConfigureAllChatFrames() end
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  -- make ChatFrame1 the selected chat frame
  function mod:AceEvent_FullyInitialized()
    if self.db.profile.mainchatonload then
      FCF_SelectDockFrame(ChatFrame1)
    end
  end

  -- set parameters for each chatframe
  function mod:ConfigureAllChatFrames(enabled)
    for _, v in pairs(Prat.Frames) do
      self:SetParameters(v, enabled)
    end
  end


  function mod:RecreateBackgroundTextures(frame)
    if frame.PratTextures then
      return
    end
    frame.PratTextures = {}
    for _, name in ipairs(CHAT_FRAME_TEXTURES) do
      local texture = _G[frame:GetName() .. name]
      local layer, sublevel = texture:GetDrawLayer()

      local newTexture = texture:GetParent():CreateTexture(nil, layer, nil, sublevel)
      for i = 1, texture:GetNumPoints() do
        newTexture:SetPoint(texture:GetPoint(i))
      end

      newTexture:SetTexture(texture:GetTexture())
      newTexture:SetTexCoord(texture:GetTexCoord())

      newTexture:SetSize(texture:GetSize())

      table.insert(frame.PratTextures, newTexture)
      texture:Hide()
    end
  end

  function mod:HidePratTextures(frame)
    if frame.PratTextures then
      for _, name in ipairs(CHAT_FRAME_TEXTURES) do
        local texture = _G[frame:GetName() .. name]
        texture:Show()
      end
      for _, texture in ipairs(frame.PratTextures) do
        texture:Hide()
      end
    end
  end

  function mod:RestorePratTextures(frame)
    if not frame.PratTextures then
      self:RecreateBackgroundTextures(frame)
    end

    for _, name in ipairs(CHAT_FRAME_TEXTURES) do
      local texture = _G[frame:GetName() .. name]
      texture:Hide()
    end
    local _, _, r, g, b, a = FCF_GetChatWindowInfo(frame:GetID())
    for _, texture in ipairs(frame.PratTextures) do
      texture:Show()
      texture:SetVertexColor(r, g, b)
      texture:SetAlpha(a)
    end
  end

  -- get the defaults for chat frame1 max/min width/height for use when disabling the module
  function mod:GetDefaults()
    local cf = _G["ChatFrame1"]
    local prof = self.db.profile

    local minwidthdefault, minheightdefault, maxwidthdefault, maxheightdefault
    if cf.GetResizeBounds then
      minwidthdefault, minheightdefault, maxwidthdefault, maxheightdefault = cf:GetResizeBounds()
    else
      minwidthdefault, minheightdefault = cf:GetMinResize()
      maxwidthdefault, maxheightdefault = cf:GetMaxResize()
    end

    prof.minchatwidthdefault = minwidthdefault
    prof.maxchatwidthdefault = maxwidthdefault
    prof.minchatheightdefault = minheightdefault
    prof.maxchatheightdefault = maxheightdefault

    prof.initialized = true
  end

  function mod:FCF_SetWindowColor(frame, r, g, b)
    if frame.PratTextures then
      for _, texture in ipairs(frame.PratTextures) do
        texture:SetVertexColor(r, g, b)
      end
    end
  end

  function mod:FCF_SetWindowAlpha(frame, a)
    local _, _, r, g, b, a = FCF_GetChatWindowInfo(frame:GetID())
    if frame.PratTextures then
      for _, texture in ipairs(frame.PratTextures) do
        texture:SetAlpha(a)
      end
    end
  end
  -- set the max/min width/height for a chatframe
  function mod:SetParameters(cf, enabled)
    local prof = self.db.profile

    local minWidth, minHeight, maxWidth, maxHeight
    if enabled then
      if prof.framealphastatic then
        self:RestorePratTextures(cf)
      else
        self:HidePratTextures(cf)
      end

      DEFAULT_CHATFRAME_ALPHA = prof.defaultframealpha

      minWidth, minHeight = prof.minchatwidth, prof.minchatheight
      maxWidth, maxHeight = prof.maxchatwidth, prof.maxchatheight

      if prof.removeclamp then
        if not Prat.IsClassic then
          cf:SetClampedToScreen(false)
        end
        cf:SetClampRectInsets(0, 0, 0, 0)
        if not Prat.IsClassic then
          EventRegistry:RegisterCallback("EditMode.Enter", function()
            cf:SetClampedToScreen(true)
            EventRegistry:UnregisterCallback("EditMode.Enter", cf)
          end, cf)
        end
      end

      if cf.ScrollBar then
        cf.ScrollBar:SetAlpha(0)
      end
    else
      self:HidePratTextures(cf)
      DEFAULT_CHATFRAME_ALPHA = 0.25

      minWidth, minHeight = prof.minchatwidthdefault, prof.minchatheightdefault
      maxWidth, maxHeight = prof.maxchatwidthdefault, prof.maxchatheightdefault
    end

    if cf.SetResizeBounds then
      cf:SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight)
    else
      cf:SetMinResize(minWidth, minHeight)
      cf:SetMaxResize(maxWidth, maxHeight)
    end
  end


  function mod:OnValueChanged()
    self:ConfigureAllChatFrames(true)
  end

  -- Frame position saving feature credit to Chatter

  function mod:SetChatWindowSavedPosition(id, point, xOffset, yOffset)
    local data = self.db.profile.framemetrics[id]
    data.point, data.xOffset, data.yOffset = point, xOffset, yOffset
  end

  function mod:GetChatWindowSavedPosition(id)
    local data = self.db.profile.framemetrics[id]
    if not data.point then
      data.point, data.xOffset, data.yOffset = self.hooks.GetChatWindowSavedPosition(id)
    end
    return data.point, data.xOffset, data.yOffset
  end

  function mod:SetChatWindowSavedDimensions(id, width, height)
    local data = self.db.profile.framemetrics[id]
    data.width, data.height = width, height
  end

  function mod:GetChatWindowSavedDimensions(id)
    local data = self.db.profile.framemetrics[id]
    if not data.width then
      data.width, data.height = self.hooks.GetChatWindowSavedDimensions(id)
    end
    return data.width, data.height
  end



  return
end) -- Prat:AddModuleToLoad
