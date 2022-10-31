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

  local PRAT_MODULE = Prat:RequestModuleName("Bubbles")

  if PRAT_MODULE == nil then
    return
  end
  local module = Prat:NewModule(PRAT_MODULE)
  local PL = module.PL
  module._classic_era = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    module_name = "Bubbles",
    module_desc = "Chat bubble related customizations",
    shorten_name = "Shorten Bubbles",
    shorten_desc = "Shorten the chat bubbles down to a single line each. Mouse over the bubble to expand the text.",
    color_name = "Color Bubbles",
    color_desc = "Color the chat bubble border the same as the chat type.",
    format_name = "Format Text",
    format_desc = "Apply Prat's formatting to the chat bubble text.",
    icons_name = "Show Raid Icons",
    icons_desc = "Show raid icons in the chat bubbles.",
    font_name = "Use Chat Font",
    font_desc = "Use the same font you are using on the chatframe",
    fontsize_name = "Font Size",
    fontsize_desc = "Set the chat bubble font size",
    transparent_name = "Transparent Bubbles",
    transparent_desc = "Hide background and border textures from chat bubbles. (/reload required to undo this option)",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/

  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "enUS",L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "frFR",L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "deDE",L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "koKR",L)



--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "esMX",L)



--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "ruRU",L)



--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "zhCN",L)



--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "esES",L)



--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Bubbles")@

  PL:AddLocale(PRAT_MODULE, "zhTW",L)


end
--@end-non-debug@]===]



  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      shorten = false,
      color = true,
      format = true,
      icons = true,
      font = true,
      transparent = false,
      fontsize = 14,
    }
  })

  local toggleOption = {
    name = function(info) return PL[info[#info] .. "_name"] end,
    desc = function(info) return PL[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = PL["module_name"],
    desc = PL["module_desc"],
    type = "group",
    args = {
      shorten = toggleOption,
      color = toggleOption,
      format = toggleOption,
      icons = toggleOption,
      font = toggleOption,
      transparent = toggleOption,
      fontsize = {
        name = function(info) return PL[info[#info] .. "_name"] end,
        desc = function(info) return PL[info[#info] .. "_desc"] end,
        type = "range",
        min = 8,
        max = 32,
        step = 1,
        order = 101
      }
    }
  })

  --[[------------------------------------------------
    Module Event Functions
  ------------------------------------------------]] --

  local BUBBLE_SCAN_THROTTLE = 0.1

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    self.update = self.update or CreateFrame('Frame');
    self.throttle = BUBBLE_SCAN_THROTTLE

    self.update:SetScript("OnUpdate",
      function(frame, elapsed)
        self.throttle = self.throttle - elapsed
        if frame:IsShown() and self.throttle < 0 then
          self.throttle = BUBBLE_SCAN_THROTTLE
          self:FormatBubbles()
        end
      end)

    self:RestoreDefaults()
    self:APLyOptions()
  end

  function module:APLyOptions()
    self.shorten = self.db.profile.shorten
    self.color = self.db.profile.color
    self.format = self.db.profile.format
    self.icons = self.db.profile.icons
    self.font = self.db.profile.font
    self.fontsize = self.db.profile.fontsize
    self.transparent = self.db.profile.transparent

    if self.shorten or self.color or self.format or self.icons or self.font or self.transparent then
      self.update:Show()
    else
      self.update:Hide()
    end
  end

  function module:OnValueChanged(info, b)
    self:RestoreDefaults()

    self:APLyOptions()
  end

  function module:OnModuleDisable()
    self:RestoreDefaults()
  end

  function module:FormatBubbles()
    self:IterateChatBubbles("FormatCallback")
  end

  function module:RestoreDefaults()
    self.update:Hide()

    self:IterateChatBubbles("RestoreDefaultsCallback")
  end

  local MAX_CHATBUBBLE_WIDTH = 300

  
  local textureUVs = {
    "TopLeftCorner", "TopRightCorner",
    "BottomLeftCorner", "BottomRightCorner",
    "TopEdge", "BottomEdge",
    "LeftEdge", "RightEdge"
  }
  -- Called for each chatbubble, passed the bubble's frame and its fontstring
  function module:FormatCallback(frame, fontstring)
    if not frame:IsShown() then
      fontstring.lastText = nil
      return
    end

    if self.color then
      -- Color the bubble border the same as the chat
      local r,g,b,a = fontstring:GetTextColor()
      for _,edge in pairs(textureUVs) do
        frame[edge]:SetVertexColor(r,g,b,a)
      end
      frame.Tail:SetVertexColor(r,g,b,a)
    end

    if self.shorten then
      local wrap = fontstring:CanWordWrap() or false
      -- If the mouse is over, then expand the bubble
      if frame:IsMouseOver() then
        fontstring:SetWordWrap(true)
      elseif wrap == true then
        fontstring:SetWordWrap(false)
      end
    end

    if self.font then
      local a, b, c = fontstring:GetFont()

      fontstring:SetFont(ChatFrame1:GetFont(), self.fontsize, c)
    end

    if self.transparent then
      for _,edge in pairs(textureUVs) do
        frame[edge]:SetTexture(nil)
      end
      frame.Center:SetTexture(nil)
      frame.Tail:SetTexture(nil)
    end

    local text = fontstring:GetText() or ""

    if self.icons then
      if (not fontstring.lastText) or (text ~= fontstring.lastText) then
        local term;
        for tag in string.gmatch(text, "%b{}") do
          term = strlower(string.gsub(tag, "[{}]", ""));
          if (ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]]) then
            text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
          end
        end
      end
    end

    if self.format then
      if (not fontstring.lastText) or (text ~= fontstring.lastText) then
        text = Prat.MatchPatterns(text)
        text = Prat.ReplaceMatches(text)
      end
    end

    fontstring:SetText(text)
    fontstring.lastText = text
    fontstring:SetWidth(fontstring:GetWrappedWidth())
  end

  -- Called for each chatbubble, passed the bubble's frame and its fontstring
  function module:RestoreDefaultsCallback(frame, fontstring)
    for _,edge in pairs(textureUVs) do
      frame[edge]:SetVertexColor(1, 1, 1, 1)
    end
    frame.Tail:SetVertexColor(1, 1, 1, 1)
    fontstring:SetWordWrap(true)
    fontstring:SetWidth(fontstring:GetWidth())
  end

  function module:IterateChatBubbles(funcToCall)
    -- includeForbidden is false by default but in case default changes at some point
    for _, chatBubbleObj in pairs(C_ChatBubbles.GetAllChatBubbles(false)) do
      local chatBubble
      if self._classic_era then -- yeye, hardcoded's bad, but whole client is hardco-dead
        chatBubble = chatBubbleObj
        chatBubble.Center, chatBubble.TopLeftCorner, chatBubble.TopRightCorner, chatBubble.BottomLeftCorner, chatBubble.BottomRightCorner,
        chatBubble.TopEdge, chatBubble.BottomEdge, chatBubble.LeftEdge, chatBubble.RightEdge,
        chatBubble.Tail, chatBubble.String = chatBubble:GetRegions()
      else
        chatBubble = chatBubbleObj:GetChildren()
      end
      if chatBubble and chatBubble.String and chatBubble.String:GetObjectType() == "FontString" then
        if type(funcToCall) == "function" then
          funcToCall(chatBubble, chatBubble.String)
        else
          self[funcToCall](self, chatBubble, chatBubble.String)
        end
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad
