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

  local PRAT_MODULE = Prat:RequestModuleName("OriginalButtons")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

  -- define localized strings
  local PL = module.PL



  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["ChannelNames"] = true,
    ["Original Buttons"] = true,
    ["Chat window button options."] = true,
    ["chatmenu_name"] = "Show Chat Menu",
    ["chatmenu_desc"] = "Toggles chat menu on and off.",
    ["Show Arrows"] = true,
    ["Toggle showing chat arrows for each chat window."] = true,
    ["Show Chat%d Arrows"] = true,
    ["Toggles navigation arrows on and off."] = true,
    ["reminder_name"] = "Show ScrollDown Reminder",
    ["reminder_desc"] = "Show reminder button when not at the bottom of a chat window.",
    ["Set Position"] = true,
    ["Sets position of chat menu and arrows for all chat windows."] = true,
    ["Default"] = true,
    ["Right, Inside Frame"] = true,
    ["Right, Outside Frame"] = true,
    ["alpha_name"] = "Set Alpha",
    ["alpha_desc"] = "Sets alpha of chat menu and arrows for all chat windows.",
    ["reflow_name"] = "Text Flows Around",
    ["reflow_desc"] = "Chatframe text should flow around the buttons not under them.",
    buttonframe_desc = "Toggles the button frame menu on and off.",
    buttonframe_name = "Show Button Frame",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)


--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "frFR",L)




--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "deDE", L)


--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "koKR",L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "esMX",L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "ruRU",L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "zhCN",L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "esES",L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="OriginalButtons")@
PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@]===]


  --module.moduleName = PL["Buttons"]
  --module.moduleDesc = PL["Chat window button options."]
  --module.consoleName = "buttons"
  --module.guiName = PL["Buttons"]
  --module.Categories = { cat.BUTTON, cat.FRAME }

  -- define the default db values
  --module.defaultDB = {
  --    on = true,
  --    chatmenu = false,
  --    chatbutton = {false, false, false, false, false, false, false},
  --    position = "DEFAULT",
  --    reminder = false,
  --    alpha = 1.0,
  --}

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      chatmenu = false,
      chatarrows = { ["*"] = true },
      position = "RIGHTINSIDE",
      reminder = true,
      reflow = false,
      alpha = 1.0,
      buttonframe = false,
      friendsbutton = false,
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = PL["Original Buttons"],
    desc = PL["Chat window button options."],
    type = "group",
    args = {
      chatarrows = {
        name = PL["Show Arrows"],
        desc = PL["Toggle showing chat arrows for each chat window."],
        order = 120,
        get = "GetSubValue",
        set = "SetSubValue",
        type = "multiselect",
        values = Prat.FrameList,
      },
      chatmenu = {
        type = "toggle",
        order = 110,
        name = PL["chatmenu_name"],
        desc = PL["chatmenu_desc"],
        get = function(info) return module.db.profile.chatmenu end,
        set = function(info, v) module.db.profile.chatmenu = v module:ChatMenu(v) end,
      },
      buttonframe = {
        type = "toggle",
        order = 110,
        name = PL["buttonframe_name"],
        desc = PL["buttonframe_desc"],
        get = function(info) return module.db.profile.buttonframe end,
        set = function(info, v) module.db.profile.buttonframe = v module:ConfigureAllFrames() end,
      },
      reminder = {
        type = "toggle",
        name = PL["reminder_name"],
        desc = PL["reminder_desc"],
        get = function(info) return module.db.profile.reminder end,
        set = function(info, v) module.db.profile.reminder = v end,
      },
      reflow = {
        type = "toggle",
        name = PL["reflow_name"],
        desc = PL["reflow_desc"],
        get = function(info) return module.db.profile.reflow end,
        set = function(info, v) module.db.profile.reflow = v if v then Prat.Addon:GetModule("SMFHax", true):Enable() end end,
        hidden = function(info) return Prat.Addon:GetModule("SMFHax", true) == nil end,
      },
      alpha = {
        name = PL["alpha_name"],
        desc = PL["alpha_desc"],
        type = "range",
        set = function(info, v) module.db.profile.alpha = v; module:ConfigureAllFrames() end,
        min = 0.1,
        max = 1,
        step = 0.1,
        order = 150,
        get = function(info) return module.db.profile.alpha end,
      },
      position = {
        name = PL["Set Position"],
        desc = PL["Sets position of chat menu and arrows for all chat windows."],
        type = "select",
        order = 140,
        get = function(info) return module.db.profile.position end,
        set = function(info, v) module.db.profile.position = v; module:ConfigureAllFrames() end,
        values = { ["DEFAULT"] = PL["Default"], ["RIGHTINSIDE"] = PL["Right, Inside Frame"], ["RIGHTOUTSIDE"] = PL["Right, Outside Frame"] }
      }
    }
  })

  local function hide(self)
    self:Hide()
  end

  function module:OnSubValueChanged(info, val, b)
    self:chatbutton(_G[val]:GetID(), b)
  end


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  -- things to do when the module is enabled
  function module:OnModuleEnable()
    local buttons3 = Prat.Addon:GetModule("Buttons", true)
    if buttons3 and buttons3:IsEnabled() then
      self.disabledB3 = true
      buttons3.db.profile.on = false
      buttons3:Disable()
      LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
    end
    -- stub variables for frame handling
    self.frames = {}
    self.reminders = {}
    for i = 1, 10 do
      table.insert(self.reminders, self:MakeReminder(i))
      self:chatbutton(i, self.db.profile.chatarrows["ChatFrame" .. i])
      self:ButtonFrame(i, self.db.profile.buttonframe)
    end
    self:ChatMenu(self.db.profile.chatmenu)
    if QuickJoinToastButton then QuickJoinToastButton:Hide() end

    -- set OnUpdateInterval, if they are profiling, update less
    --    if GetCVar("scriptProfile") == "1" then
    --        self.OnUpdateInterval = 0.5
    --    else
    --        self.OnUpdateInterval = 0.05
    --    end

    --    local smfhax = Prat.Addon:GetModule("SMFHax", true)
    --    if self.db.profile.reflow and smfhax then
    --        smfhax:Enable()
    --    end

    self.OnUpdateInterval = 0.05
    self.lastupdate = 0
    -- hook functions
    self:SecureHook("ChatFrame_OnUpdate", "ChatFrame_OnUpdateHook")
    self:SecureHook("FCF_SetTemporaryWindowType")
  end

  -- things to do when the module is disabled
  function module:OnModuleDisable()
    -- show chatmenu
    self:ChatMenu(true)
    -- show all the chatbuttons
    for i = 1, NUM_CHAT_WINDOWS do
      self:chatbutton(i, true)
    end
    -- unhook functions
    self:UnhookAll()
  end

  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --

  function module:GetDescription()
    return PL["Original Buttons"]
  end

  function module:FCF_SetTemporaryWindowType(chatFrame, ...)
    local i = chatFrame:GetID()

    self:chatbutton(i, self.db.profile.chatarrows[chatFrame:GetName()])
    self:ButtonFrame(i, self.db.profile.buttonframe)
  end

  function module:ConfigureAllFrames()
    for name, frame in pairs(Prat.Frames) do
      local i = frame:GetID()
      self:chatbutton(i, self.db.profile.chatarrows[name])
      self:ButtonFrame(i, self.db.profile.buttonframe)
    end
    self:ChatMenu(self.db.profile.chatmenu)

    if QuickJoinToastButton then QuickJoinToastButton:Hide() end
  end

  function module:ChatFrame_OnUpdateHook(this, elapsed)
    if not this:IsVisible() and not this:IsShown() then return end
    self.lastupdate = self.lastupdate + elapsed

    while (self.lastupdate > self.OnUpdateInterval) do
      self:ChatFrame_OnUpdate(this, elapsed)
      self.lastupdate = self.lastupdate - self.OnUpdateInterval;
    end
  end


  do
    local anims = nil
    function module:ChatFrame_OnUpdate(this, elapsed)
      if (not this:IsShown()) then
        return;
      end

      local id = this:GetID()
      local prof = self.db.profile
      local show = prof.chatarrows[this:GetName()]

      self:chatbutton(id, show)
      --self:ChatFrame_OnUpdateTextFlow(this, elapsed)

      -- This is all code for the 'reminder' from here on
      if show then
        return
      end
      if not prof.reminder then
        return
      end
      local remind = _G[this:GetName() .. "ScrollDownReminder"];
      local flash = _G[this:GetName() .. "ScrollDownReminderFlash"];
      if (not flash) then
        return
      end
      if not anims then anims = {} end
      if not anims[flash] then
        anims[flash] = flash:CreateAnimationGroup()

        local fade1 = anims[flash]:CreateAnimation("Alpha")
        fade1:SetDuration(0.1)
        fade1:SetToAlpha(1)
        fade1:SetEndDelay(0.5)
        fade1:SetOrder(1)

        local fade2 = anims[flash]:CreateAnimation("Alpha")
        fade2:SetDuration(0.1)
        fade2:SetToAlpha(-1)
        fade2:SetEndDelay(0.5)
        fade2:SetOrder(2)
      end
      if (this:AtBottom()) then
        if (remind:IsShown()) then
          remind:Hide();
          anims[flash]:Stop()
        end
        return;
      else
        if (remind:IsShown()) then
          return
        end
        remind:Show()
        flash:Show()
        flash:SetAlpha(0)
        anims[flash]:SetLooping("REPEAT")
        anims[flash]:Play()
      end
    end
  end

  function module:ButtonFrame(id, visible)
    if not Prat.BN_CHAT then return end

    local f = _G["ChatFrame" .. id .. "ButtonFrame"]
    local cf = _G["ChatFrame" .. id]

    if visible then
      f:SetScript("OnShow", nil)
      f:Show()
      f:SetWidth(29)
      --        cf:AddMessage("Show Button Frame")
    else
      f:SetScript("OnShow", hide)
      f:Hide()

      f:SetWidth(0.1)
      --        cf:AddMessage("Hide Button Frame")
    end
  end

  -- manipulate chatframe menu button
  function module:ChatMenu(visible)
    local ChatFrameMenuButton = ChatFrameMenuButton
    -- define variables used
    local f = self.frames[1]
    if not f then
      self.frames[1] = {}
      f = self.frames[1]
    end
    f.cfScrl = f.cfScrl or {}
    f.cfScrl.up = _G["ChatFrame1ButtonFrameUpButton"]
    -- chatmenu position:
    -- position chatmenu under the UpButton for chatframe1 if button position is set to "RIGHTINSIDE"
    -- otherwise position chatmenu above the UpButton for chatframe1
    ChatFrameMenuButton:ClearAllPoints()
    if self.db.profile.position == "RIGHTINSIDE" then
      ChatFrameMenuButton:SetPoint("TOP", f.cfScrl.up, "BOTTOM")
    else
      ChatFrameMenuButton:SetPoint("BOTTOM", f.cfScrl.up, "TOP")
    end
    -- chatmenu alpha:
    -- set alpha of the chatmenu based on the alpha setting
    ChatFrameMenuButton:SetAlpha(self.db.profile.alpha)
    -- chatmenu visibility
    -- show buttons based on show settings
    if visible then
      ChatFrameMenuButton:SetScript("OnShow", nil)
      ChatFrameMenuButton:Show()
    else
      ChatFrameMenuButton:Hide()
      ChatFrameMenuButton:SetScript("OnShow", hide)
    end
  end



  -- manipulate chatframe scrolling and reminder buttons
  function module:chatbutton(id, visible)
    -- define variables used
    local f = self.frames[id]
    --local id = this:GetID()
    if not f then
      self.frames[id] = {}
      f = self.frames[id]
    end

    f.cfScrl = f.cfScrl or {}
    f.cf = f.cf or _G["ChatFrame" .. id]
    if Prat.BN_CHAT then
      f.cfScrl.up = f.cfScrl.up or _G["ChatFrame" .. id .. "ButtonFrameUpButton"]
      f.cfScrl.down = f.cfScrl.down or _G["ChatFrame" .. id .. "ButtonFrameDownButton"]
      f.cfScrl.bottom = f.cfScrl.bottom or _G["ChatFrame" .. id .. "ButtonFrameBottomButton"]
      f.cfScrl.min = f.cfScrl.min or _G["ChatFrame" .. id .. "ButtonFrameMinimizeButton"]

      if f.cfScrl.up then
        f.cfScrl.up:SetParent(f.cf)
        f.cfScrl.down:SetParent(f.cf)
        f.cfScrl.bottom:SetParent(f.cf)
        f.cfScrl.min:SetParent(_G[f.cf:GetName() .. "Tab"])

        f.cfScrl.min:SetScript("OnShow",
          function(self)
            if f.cf.isDocked then
              self:Hide()
            end
          end)

        f.cfScrl.min:SetScript("OnClick",
          function(self)
            FCF_MinimizeFrame(f.cf, strupper(f.cf.buttonSide))
          end)

        f.cfScrl.up:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP); f.cf:ScrollUp() end)
        f.cfScrl.down:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN); f.cf:ScrollDown() end)
        f.cfScrl.bottom:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHAT_BOTTOM); f.cf:ScrollToBottom() end)
      end
    else
      f.cfScrl.up = f.cfScrl.up or _G["ChatFrame" .. id .. "UpButton"]
      f.cfScrl.down = f.cfScrl.down or _G["ChatFrame" .. id .. "DownButton"]
      f.cfScrl.bottom = f.cfScrl.bottom or _G["ChatFrame" .. id .. "BottomButton"]
    end

    f.cfScrlheight = (f.cfScrlheight and f.cfScrlheight > 0) and f.cfScrlheight or ((f.cfScrl.up and f.cfScrl.down and f.cfScrl.bottom) and
      (f.cfScrl.up:GetHeight() + f.cfScrl.down:GetHeight() + f.cfScrl.bottom:GetHeight()) or 0)
    f.cfreminder = f.cfreminder or self:MakeReminder(id)
    f.cfreminderflash = f.cfreminderflash or _G["ChatFrame" .. id .. "ScrollDownReminderFlash"]

    -- chatbuttons position:
    -- position of the chatbuttons based on position setting
    if f.cfScrl.bottom and f.cfScrl.up then
      f.cfScrl.bottom:ClearAllPoints()
      f.cfScrl.up:ClearAllPoints()
      if self.db.profile.position == "RIGHTINSIDE" then
        f.cfScrl.bottom:SetPoint("BOTTOMRIGHT", f.cf, "BOTTOMRIGHT", 0, -4)
        f.cfScrl.up:SetPoint("TOPRIGHT", f.cf, "TOPRIGHT", 0, -4)
      elseif self.db.profile.position == "RIGHTOUTSIDE" then
        f.cfScrl.bottom:SetPoint("BOTTOMLEFT", f.cf, "BOTTOMRIGHT", 0, -4)
        f.cfScrl.up:SetPoint("BOTTOM", f.cfScrl.down, "TOP", 0, -2)
      else
        f.cfScrl.bottom:SetPoint("BOTTOMLEFT", f.cf, "BOTTOMLEFT", -32, -4)
        f.cfScrl.up:SetPoint("BOTTOM", f.cfScrl.down, "TOP", 0, -2)
      end
    end

    -- chatbuttons alpha:
    -- set alpha of the chatbuttons based on the alpha setting
    for _, v in pairs(f.cfScrl) do
      v:SetAlpha(self.db.profile.alpha)
    end
    -- chatbuttons visibility:
    -- show buttons based on visible value passed to function
    if f.cf then
      if visible and (f.cf:GetHeight() > f.cfScrlheight) then
        for k, v in pairs(f.cfScrl) do
          f.cfScrl[k]:Show()
        end
      else
        for k, v in pairs(f.cfScrl) do
          f.cfScrl[k]:Hide()
        end
        -- reminder visibility:
        -- show the reminder button (if enabled) when not at the bottom of the chatframe
        if (not f.cf:AtBottom()) and self.db.profile.reminder and (f.cf:GetHeight() > f.cfreminder:GetHeight()) then
          local b = f.cfreminder
          b:ClearAllPoints()
          if f.cf:GetJustifyH() == "RIGHT" then
            b:SetPoint("LEFT", f.cf, "LEFT", 0, 0)
            b:SetPoint("RIGHT", f.cf, "LEFT", 32, 0)
            b:SetPoint("TOP", f.cf, "BOTTOM", 0, 28)
            b:SetPoint("BOTTOM", f.cf, "BOTTOM", 0, 0)
          elseif f.cf:GetJustifyH() == "LEFT" then
            b:SetPoint("RIGHT", f.cf, "RIGHT", 0, 0)
            b:SetPoint("LEFT", f.cf, "RIGHT", -32, 0)
            b:SetPoint("TOP", f.cf, "BOTTOM", 0, 28)
            b:SetPoint("BOTTOM", f.cf, "BOTTOM", 0, 0)
          end

          f.cfreminder:Show()
          f.cfreminderflash:Show()
        else
          f.cfreminder:Hide()
          f.cfreminderflash:Hide()
        end
      end
    end
  end

  -- create a "reminder" button
  function module:MakeReminder(id)
    -- define variables used
    local cf = _G["ChatFrame" .. id]
    local b = _G["ChatFrame" .. id .. "ScrollDownReminder"]
    if b then return b end
    b = CreateFrame("Button", "ChatFrame" .. id .. "ScrollDownReminder", cf)
    -- define the parameters for the button
    b:SetFrameStrata("BACKGROUND")
    b:SetWidth(24)
    b:SetHeight(24)
    b:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Up")
    b:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Down")
    b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    b:SetPoint("RIGHT", cf, "RIGHT", 0, 0)
    b:SetPoint("LEFT", cf, "RIGHT", -32, 0)
    b:SetPoint("TOP", cf, "BOTTOM", 0, 28)
    b:SetPoint("BOTTOM", cf, "BOTTOM", 0, 0)
    b:SetScript("OnClick", function() PlaySound(SOUNDKIT.IG_CHAT_BOTTOM); cf:ScrollToBottom() end)
    -- hide the button by default
    b:Hide()
    -- add a flash texture for the reminder button
    self:AddFlashTexture(b)

    return b
  end

  -- create a "flash" texture
  function module:AddFlashTexture(frame)
    -- define variables used
    local t = frame:CreateTexture(frame:GetName() .. "Flash", "OVERLAY")
    -- define the parameters for the texture
    t:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
    t:SetPoint("CENTER", frame, "CENTER", 0, 1)
    t:SetBlendMode("ADD")
    t:SetAlpha(0.5)
    -- hide the texture by default
    t:Hide()
  end

  return
end) -- Prat:AddModuleToLoad
