---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat modification
-- and a collection of modules which utilize the framework
--
-- Copyright (C) 2006-2020  Prat Development Team
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

Prat = select(2, ...)

--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local _G = _G
local LibStub = LibStub
local tonumber = tonumber
local tostring = tostring
local pairs = pairs
local ipairs = ipairs
local type = type
local strsub = strsub
local Prat = Prat
local setmetatable, getmetatable = setmetatable, getmetatable
local strfind = strfind
local IsSecureCmd = IsSecureCmd
local wipe = table.wipe

--[[ END STANDARD HEADER ]] --

--@debug@
Prat.Version = "Prat |cff8080ff3.0|r (|cff8080ff" .. "DEBUG" .. "|r)"
--@end-debug@

--[===[@non-debug@
Prat.Version = "Prat |cff8080ff3.0|r (|cff8080ff".."@project-version@".."|r)"
--@end-non-debug@]===]

local am = {}
local om = getmetatable(Prat)
if om then
  for k, v in pairs(om) do am[k] = v end
end
am.__tostring = function() return "Prat |cff8080ff3.0|r" end
setmetatable(Prat, am)

Prat.Prat3 = true
Prat.IsClassic = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC)
Prat.IsRetail =  (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE)
Prat.IsMop = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MISTS_CLASSIC)

Prat.Localizations = Prat.GetLocalizer({})

Prat.Frames = {
  ["ChatFrame1"] = _G.ChatFrame1,
  ["ChatFrame2"] = _G.ChatFrame2,
  ["ChatFrame3"] = _G.ChatFrame3,
  ["ChatFrame4"] = _G.ChatFrame4,
  ["ChatFrame5"] = _G.ChatFrame5,
  ["ChatFrame6"] = _G.ChatFrame6,
  ["ChatFrame7"] = _G.ChatFrame7,
  ["ChatFrame8"] = _G.ChatFrame8,
  ["ChatFrame9"] = _G.ChatFrame9,
  ["ChatFrame10"] = _G.ChatFrame10
}
Prat.HookedFrames = {}
Prat.ExternalFrames = {}

local builtinSounds = {
  ["Bell"] = "Interface\\AddOns\\Prat-3.0\\sounds\\Bell.ogg",
  ["Chime"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Chime.ogg",
  ["Heart"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Heart.ogg",
  ["IM"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\IM.ogg",
  ["Info"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Info.ogg",
  ["Kachink"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Kachink.ogg",
  ["popup"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Link.ogg",
  ["Text1"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Text1.ogg",
  ["Text2"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Text2.ogg",
  ["Xylo"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Xylo.ogg",
}


-- Symbolic names for all the events which Prat uses
Prat.Events = {
  MODULE_ENABLED = "Prat_ModuleCreated",
  DISABLED = "Prat_Disabled",
  ENABLING = "Prat_Starting",
  ENABLED = "Prat_Ready",
  STARTUP = "Prat_Initialized",
  DEBUG_UPDATE = "Prat_DebugModeChanged",
  PRE_OUTBOUND = "Prat_PreOutboundChat",
  OUTBOUND = "Prat_OutboundChat",
  PRE_ADDMESSAGE = "Prat_PreAddMessage",
  POST_ADDMESSAGE = "Prat_PostAddMessage",
  POST_ADDMESSAGE_BLOCKED = "Prat_PostAddMessageBlocked",
  FRAME_MESSAGE = "Prat_FrameMessage",
  SECTIONS_UPDATED = "Prat_ChatSectionsUpdated",
  FRAMES_UPDATED = "Prat_FramesUpdated",
  FRAMES_REMOVED = "Prat_FramesRemoved",
}

Prat.EnableTasks = {}

local addon = LibStub("AceAddon-3.0"):NewAddon("Prat", "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0")
Prat.Addon = addon

--local  callbacks

--[[ 1 = no load, 2 = disabled, 3 = enabled (this is temporary, a better format will be forthcoming, 4 is setdisabled, and 5 is setenabled]]
--  What I need to do is return the module's own value if the option isn't 1
-- but one problem is if the module was "no-load", and then is set to "enabled" but it thinks it should be "disabled"
local defaults = {
  profile = {
    modules = {
      ["Clear"] = 1,
      ["AddonMsgs"] = 1,
      ["CustomFilters"] = 1,
      ["EventNames"] = 1,
      ["Substitutions"] = 1,
      ["Experimental"] = 1,
      ["Filtering"] = 1,
      ["KeyBindings"] = 3,
      ["OriginalEditbox"] = 1,
      ["ChatTabs"] = 1,
      ["*"] = 3
    }
  },
  realm = {
    PlayerNameBlackList = {
      ["you"] = true
    }
  }
}
local SOUND
function addon:OnInitialize()
	local IsAddOnLoaded = _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
  if IsAddOnLoaded("Prat") == 1 then
    Prat:Print("Prat 2.0 was detected, and disabled. Please reload your UI.")
  end


  Prat.db = LibStub("AceDB-3.0"):New("Prat3DB", defaults, "Default")

  _G.Prat3CharDB = _G.Prat3CharDB or {}

  Prat.PlayerNameBlackList = Prat.db.realm.PlayerNameBlackList or {}

  Prat.callbacks = LibStub("CallbackHandler-1.0"):New(Prat, "RegisterChatEvent", "UnregisterChatEvent", "UnregisterAllChatEvents")

  Prat.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(Prat.db)
  Prat.Options.args.profiles.order = tonumber(-1)

  Prat.Media = LibStub("LibSharedMedia-3.0")
  SOUND = Prat.Media.MediaType.SOUND

  for k, v in pairs(builtinSounds) do
    Prat.Media:Register(SOUND, k, v)
  end

  Prat.AddonName = self.baseName

  Prat.builtinSounds = nil

  -- Build the list of frames which we should hook addmessage on
  -- IsCombatLog is not correct yet it appears, so we resort to checking
  -- for chatframe2
  for _, v in pairs(Prat.Frames) do
    if (not _G.IsCombatLog(v)) and v ~= _G.ChatFrame2 then
      Prat.HookedFrames[v:GetName()] = v
    end
  end

  Prat.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  Prat.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  Prat.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  Prat.LoadModules()

  self.OnInitalize = nil
end

-- Used for Prat/WIM integration
function Prat.Format(smf, event, color, ...)
  local PRE_ADDMESSAGE = "Prat_PreAddMessage"
  local POST_ADDMESSAGE = "Prat_PostAddMessage"
  local FRAME_MESSAGE = "Prat_FrameMessage"
  local this = smf
  local formattedText = ""
  local m, info = Prat.SplitChatMessage(smf, event, ...)

  if type(m) == "boolean" and m == true then
    return ""
  end

  Prat.CurrentMessage = m

  m.DONOTPROCESS = nil
  local process = Prat.EventProcessingType.Full

  Prat.callbacks:Fire(FRAME_MESSAGE, m, this, event)

  if not m.DONOTPROCESS then
    color = color or info
    local r, g, b, id = color.r or 1, color.g or 1, color.b or 1, 1

    -- Remove all the pattern matches ahead of time
    m.MESSAGE = Prat.MatchPatterns(m)

    Prat.callbacks:Fire(PRE_ADDMESSAGE, m, this, event, Prat.BuildChatText(m), r, g, b, id)

    -- Pattern Matches Put Back IN
    m.MESSAGE = Prat.ReplaceMatches(m)

    if process == Prat.EventProcessingType.Full then
      -- We are about to send the message
      m.OUTPUT = Prat.BuildChatText(m) -- Combine all the chat sections
    elseif process == Prat.EventProcessingType.PatternsOnly then

      m.OUTPUT = (m.PRE or "") .. m.MESSAGE .. (m.POST or "")
    else
      if type(m.OUTPUT) == "string" then
        -- Now we have the chatstring that the client was planning to output
        -- For now just do it. (Tack on POST too)
        m.OUTPUT = (m.PRE or "") .. m.OUTPUT .. (m.POST or "")
      end
    end

    -- Allow for message blocking during the patern match phase
    if not m.DONOTPROCESS then
      formattedText = m.OUTPUT
    end

    -- We have called addmessage by now, or we have skipped it
    -- regardless, we call postaddmessage. This was changed to allow
    -- for more flexibility in the customfilters module, speficially
    -- it allows for replacements to occur in blocked messages

    Prat.callbacks:Fire(POST_ADDMESSAGE, m, this, event, m.OUTPUT, r, g, b, id)
  end

  m.CAPTUREOUTPUT = nil
  m.OUTPUT = nil
  m.INFO = nil

  Prat.CurrentMessage = nil

  return formattedText
end

function addon:OnEnable()
  for _, v in ipairs(Prat.EnableTasks) do
    v(self)
  end
  Prat.EnableTasks = nil

  Prat.RegisterLinkType({
    linkid = "rldui",
    linkfunc = function(...) _G.ReloadUI() return false end
  }, "Prat")

  self:PostEnable()
end


function addon:UpdateProfile()
  self:ScheduleTimer("UpdateProfileDelayed", 0)
end

function addon:UpdateProfileDelayed()
  for _, v in self:IterateModules() do
    if v.db.profile.on then
      if v:IsEnabled() then
        v:Disable()
        v:Enable()
      else
        v:Enable()
      end
    else
      v:Disable()
    end
  end

  Prat.UpdateOptions()
end

do
  local org_GetChannelName = _G.GetChannelName
  local chanTable
  Prat.EnableTasks[#Prat.EnableTasks + 1] = function() chanTable = Prat.GetChannelTable() end
  function Prat.GetChannelName(n)
    local a, b, c = org_GetChannelName(n)

    if b == nil and chanTable then
      n = chanTable[n]

      if n ~= nil then
        a, b, c = org_GetChannelName(n)
      end
    end

    return a, b, c
  end
end

function addon:FCF_SetTemporaryWindowType(chatFrame, chatType, chatTarget)
  local name = chatFrame:GetName()

  Prat.Frames[name] = chatFrame

  Prat.HookedFrames[name] = chatFrame

  Prat.callbacks:Fire(Prat.Events.FRAMES_UPDATED, name, chatFrame, chatType, chatTarget)
end


function addon:FCF_Close(frame)
  local name = frame:GetName()

  Prat.Frames[name] = nil

  Prat.HookedFrames[name] = nil

  Prat.callbacks:Fire(Prat.Events.FRAMES_REMOVED, name, frame)
end

function addon:FCF_CopyChatSettings(chatFrame)
  if not chatFrame.isTemporary then
    local name = chatFrame:GetName()

    Prat.Frames[name] = chatFrame

    if not _G.IsCombatLog(chatFrame) then
      Prat.HookedFrames[name] = chatFrame
    end

    Prat.callbacks:Fire(Prat.Events.FRAMES_UPDATED, name, chatFrame)
  end
end

function addon:PostEnable()
  --@debug@
  Prat:Print(Prat.Version)
  --@end-debug@

  Prat.AddPrintMethods()

  if Prat.PrintSlashCommand then
    self:RegisterChatCommand("print", Prat.PrintSlashCommand)
  end
    -- Inbound Hooking
	if _G["ChatFrame_MessageEventHandler"] then
		self:RawHook("ChatFrame_MessageEventHandler", true)
	elseif _G["ChatFrameMixin"] and _G["ChatFrameMixin"].MessageEventHandler then
		for _, chatFrame in ipairs(_G["CHAT_FRAMES"]) do
			_G[chatFrame].customEventHandler = function(self, event, ...)
				return addon:ChatFrame_MessageEventHandler(self, event, ...)
			end
		end
	end

	-- Outbound hooking
	self:SecureHook("ChatEdit_ParseText")
	if _G.ChatFrame1EditBox and _G.ChatFrame1EditBox.ParseText then
		self:SecureHook(_G.ChatFrame1EditBox, 'ParseText', 'ChatEdit_ParseText')
	end

  -- Display Hooking
  Prat.DummyFrame = _G.CreateFrame("ScrollingMessageFrame")
	if _G.Mixin and _G.ChatFrameMixin then
		_G.Mixin(Prat.DummyFrame, _G.ChatFrameMixin)
	end
  self:RawHook(Prat.DummyFrame, "AddMessage", true)

  -- ItemRef Hooking

  self:RawHook(_G.ItemRefTooltip, "SetHyperlink", true)

  self:SecureHook("FCF_SetTemporaryWindowType")

  self:SecureHook("FCF_Close")

  self:SecureHook("FCF_CopyChatSettings")

  --    -- This event fires after Prat's hooks are installed
  --    -- Prat's core wont operate until after this event
  Prat.callbacks:Fire(Prat.Events.SECTIONS_UPDATED)
  Prat.callbacks:Fire(Prat.Events.ENABLED)

  --@debug@
  if Prat.Modules then
    local total, loaded, enabled = 0, 0, 0
    for _, v in pairs(Prat.Modules) do
      total = total + 1
      if v ~= "EXISTS" then
        loaded = loaded + 1
      end
      if v == "ENABLED" then
        enabled = enabled + 1
      end
    end

    Prat:Print(("Module Count: |cff80ffff%d|r total |cff80ffff%d|r loaded, |cff80ffff%d|r enabled"):format(total, loaded, enabled))
  end

  if Prat.MemoryUse then
    _G.collectgarbage("collect")
    Prat:Print("Memory Use: " .. Prat.MemoryUse())
  end
  --@end-debug@

  if Prat.EnableGlobalCompletions then
    Prat.EnableGlobalCompletions(Prat, "Prat-Global-Autocomplete")
  end
end

function addon:SetHyperlink(frame, ...)
  return Prat.SetHyperlinkHook(self.hooks[frame], frame, ...)
end


function addon:ChatEdit_ParseText(editBox, send)
  local command = editBox:GetText()

  -- this is what blizzard does
  local cmd = command:match("^(#%s*[Ss][Hh][Oo][Ww]:*)%s[^%s]") or
    command:match("^(#%s*[Ss][Hh][Oo][Ww][Tt][Oo][Oo][Ll][Tt][Ii][Pp]:*)%s[^%s]") or
    command:match("^(/[^%s]+)");

  -- Hack from blizzard's code
  if (cmd and strfind(cmd, "^#")) then
    -- This is a hack, but the "USE" code below handles bags and slots
    cmd = SLASH_USE1;
  end

  if cmd and IsSecureCmd(cmd) then
    return
  end

  local m = Prat.SplitMessageOut
  wipe(m)
  CurrentMessage = m

  m.MESSAGE = command:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace

  m.CTYPE = editBox:GetAttribute("chatType")
  m.TARGET = editBox:GetAttribute("tellTarget")
  m.CHANNEL = editBox:GetAttribute("channelTarget")
  m.LANGUAGE = editBox.language
  m.SEND = send

  if send ~= 1 then
    return
  end

  self:ProcessUserEnteredChat(m)

  editBox:SetAttribute("chatType", m.CTYPE)
  editBox:SetAttribute("tellTarget", m.TARGET)
  editBox:SetAttribute("channelTarget", m.CHANNEL)
  editBox.languague = m.LANGUAGE

  if m.DONOTPROCESS then
    editBox:SetText("")
  else
    editBox:SetText(m.MESSAGE)
  end

  Prat.CurrentMessage = nil
end

function addon:ProcessUserEnteredChat(m)
  if (m.MESSAGE:len() <= 0) then
    return
  end

  Prat.callbacks:Fire(Prat.Events.PRE_OUTBOUND, m)

  -- Remove all the pattern matches ahead of time
  m.MESSAGE = Prat.MatchPatterns(m, "OUTBOUND")

  Prat.callbacks:Fire(Prat.Events.OUTBOUND, m)

  -- Pattern Matches Put Back IN
  m.MESSAGE = Prat.ReplaceMatches(m, "OUTBOUND")
end

local fieldBlacklist = {
  historyBuffer = true,
  isLayoutDirty = true,
  isDisplayDirty = true,
  onDisplayRefreshedCallback = true,
  onScrollChangedCallback = true,
  onTextCopiedCallback = true,
  scrollOffset = true,
  visibleLines = true,
  highlightTexturePool = true,
  fontStringPool = true,
}
local savedFrame = {}
function Prat.CreateProxy(frame)
  for k, v in pairs(frame) do
    if type(v) ~= "function" and not fieldBlacklist[k] then
      savedFrame[k] = Prat.DummyFrame[k]
      Prat.DummyFrame[k] = v
    end
  end
  Prat.DummyFrame.IsShown = function() return true end
  return Prat.DummyFrame
end

function Prat.RestoreProxy()
  for k, v in pairs(savedFrame) do
    Prat.DummyFrame[k] = v
  end
  for k, v in pairs(Prat.DummyFrame) do
    if type(v) ~= "function" and not fieldBlacklist[k] then
      if savedFrame[k] == nil then
        Prat.DummyFrame[k] = nil
      end
    end
  end
end

function addon:ChatFrame_MessageEventHandler(this, event, ...)
  local PRE_ADDMESSAGE = "Prat_PreAddMessage"
  local POST_ADDMESSAGE = "Prat_PostAddMessage"
  local FRAME_MESSAGE = "Prat_FrameMessage"
  local POST_ADDMESSAGE_BLOCKED = "Prat_PostAddMessageBlocked"

  local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15 = ...

  loading = nil -- clear any batch message loading that may be happening

  if not Prat.HookedFrames[this:GetName()] then
	  if _G["ChatFrame_MessageEventHandler"] then
		  return self.hooks["ChatFrame_MessageEventHandler"](this, event, ...)
	  else
		  return _G["ChatFrameMixin"].MessageEventHandler(this, event, ...)
	  end
  end

  local message, info
  local process = Prat.EventIsProcessed(event)

  local CMEResult

  if type(arg1) == "string" and (arg1):find("\r") then -- Stupid exploit. Protect our users.
    arg1 = arg1:gsub("\r", " ")
  end

	if strsub(event, 1, 8) == "CHAT_MSG" and _G.ChatFrameUtil and _G.ChatFrameUtil.ProcessMessageEventFilters then
		local shouldDiscardMessage = false
		shouldDiscardMessage , arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14
			= _G.ChatFrameUtil.ProcessMessageEventFilters(this, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
		if shouldDiscardMessage then
			return true
		end
	end

  -- Create a message table. This table contains the chat message in a non-concatenated form
  -- so that it can be modified easily without lots of complex gsub's
  message, info = Prat.SplitChatMessage(this, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)

  -- Handle Default-UI filtering: Since the default UI now provides filtering functions
  -- similar to the way Prat's pattern registry works, we need to be sure not to call the
  -- filtering functions twice by calling back into the hook chain - otherwise you could
  -- have side effects of the handler functions being called more than once for a given event.
  -- I don't see any way around this.
  if type(message) == "boolean" and message == true then
    return true
  end

  if not info then
	  if _G["ChatFrame_MessageEventHandler"] then
		  return self.hooks["ChatFrame_MessageEventHandler"](this, event, ...)
	  else
		  return _G["ChatFrameMixin"].MessageEventHandler(this, event, ...)
	  end
  else
    local m = message --SplitMessage


    -- Prat_FrameMessage is fired for every message going to the
    -- chatframe which is displayable (has a chat infotype)
    -- It may not be displayed, in which case no Pre/Post Addmessage
    -- events will fire
    -- Any addons which hook things will operate following this event
    -- but before Prat_PreAddMessage, OUTPUT will contain the chat line
    -- it may be modified by other addons.
    --
    -- Right now, prat will discard the chat line for chat types that
    -- it is handling
    --
    m.OUTPUT = nil

    m.DONOTPROCESS = nil

    --        DUMP_OUTPUT_EX(this, "Prat_FrameMessage", nil, nil, m.CAPTUREOUTPUT, m.OUTPUT)

    Prat.callbacks:Fire(FRAME_MESSAGE, message, this, message.EVENT)

    -- A return value of true means that the message was processed
    -- normally this would result in the OnEvent returning
    -- for that chatframe
    local proxy = Prat.CreateProxy(this)

    m.CAPTUREOUTPUT = proxy
	  if _G["ChatFrame_MessageEventHandler"] then
		  CMEResult = self.hooks["ChatFrame_MessageEventHandler"](proxy, event, ...) -- This specifically does not use message.EVENT
	  else
		  CMEResult = _G["ChatFrameMixin"].MessageEventHandler(proxy, event, ...)
	  end
    this.tellTimer = proxy.tellTimer

    Prat.RestoreProxy()

    m.CAPTUREOUTPUT = false

    if type(m.OUTPUT) == "string" and not m.DONOTPROCESS then
      Prat.CurrentMessage = m
      local r, g, b, id = m.INFO.r, m.INFO.g, m.INFO.b, m.INFO.id

      if process == Prat.EventProcessingType.Full or process == Prat.EventProcessingType.PatternsOnly then
        -- Remove all the pattern matches ahead of time
        m.MESSAGE = Prat.MatchPatterns(m, "FRAME")
      end

      Prat.callbacks:Fire(PRE_ADDMESSAGE, message, this, message.EVENT, Prat.BuildChatText(message), r, g, b, id)

      if process == Prat.EventProcessingType.Full or process == Prat.EventProcessingType.PatternsOnly then
        -- Pattern Matches Put Back IN
        m.MESSAGE = Prat.ReplaceMatches(m, "FRAME")
      end

      if process == Prat.EventProcessingType.Full then
        -- We are about to send the message
        m.OUTPUT = Prat.BuildChatText(message) -- Combine all the chat sections
      elseif process == Prat.EventProcessingType.PatternsOnly then

        m.OUTPUT = (m.PRE or "") .. m.MESSAGE .. (m.POST or "")
      else

        -- Now we have the chatstring that the client was planning to output
        -- For now just do it. (Tack on POST too)
        m.OUTPUT = (m.PRE or "") .. m.OUTPUT .. (m.POST or "")
      end

      -- Allow for message blocking during the patern match phase
      if m.DONOTPROCESS then
        Prat.callbacks:Fire(POST_ADDMESSAGE_BLOCKED, m, this, message.EVENT, m.OUTPUT, r, g, b, id)
      elseif m.OUTPUT:len() > 0 then

        -- Hack to get the censored message display working with Prat
        local isChatLineCensored = arg11 and C_ChatInfo.IsChatLineCensored(arg11);
        local msg = isChatLineCensored and arg1 or m.OUTPUT

        if isChatLineCensored then
          local eventLabel = event
          local eventArgs = SafePack(...);
          this:AddMessage(msg, r, g, b, id, m.ACCESSID, m.TYPEID, eventLabel, eventArgs, function(text) return text end);
        else
          this:AddMessage(msg, r, g, b, id, m.ACCESSID, m.TYPEID);
        end

        -- We have called addmessage by now, or we have skipped it
        -- regardless, we call postaddmessage. This was changed to allow
        -- for more flexibility in the customfilters module, speficially
        -- it allows for replacements to occur in blocked messages

        Prat.callbacks:Fire(POST_ADDMESSAGE, m, this, message.EVENT, m.OUTPUT, r, g, b, id, m.ACCESSID, m.TYPEID)

        if (not this:IsShown()) then
          if ((this == _G.DEFAULT_CHAT_FRAME and m.INFO.flashTabOnGeneral) or (this ~= _G.DEFAULT_CHAT_FRAME and m.INFO.flashTab)) then
            if ((_G.CHAT_OPTIONS and not _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS) or m.CHATTYPE == "WHISPER" or m.CHATTYPE == "BN_WHISPER") then
              if (not _G.FCFManager_ShouldSuppressMessageFlash(this, m.CHATGROUP, m.CHATTARGET)) then
                _G.FCF_StartAlertFlash(this);
              end
            end
          end
        end


        Prat.LastMessage = m
		  if not _G["ChatFrame_MessageEventHandler"] then
			  CMEResult = true
		  end
      end
    end

    m.CAPTUREOUTPUT = nil

    Prat.CurrentMessage = nil
  end

  return CMEResult
end

function addon:AddMessage(frame, text, r, g, b, id, ...)
  local s = Prat.SplitMessage
  if s.OUTPUT == nil and s.CAPTUREOUTPUT == frame then
    s.ORG.OUTPUT = text
  else
    self.hooks[frame].AddMessage(frame, text, r, g, b, id, ...)
  end
end

local wowsounds = {
  ["TellMessage"] = _G.SOUNDKIT.TELL_MESSAGE,
}

function Prat.PlaySound(_, sound)
  if not sound then return end

  if wowsounds[sound] then
    _G.PlaySound(wowsounds[sound], "Master")
  else
    local play
    if play == nil then
      play = Prat.Media:Fetch(SOUND, sound)
    end
    if play == nil then return end

    _G.PlaySoundFile(play, "Master")
  end
end

function Prat.CanSendChatMessage(chatType)
  if chatType == "SAY" or chatType == "YELL" then
    return _G.IsInInstance("player")
  elseif chatType == "RAID" or chatType == "GUILD" or chatType == "WHISPER" then
    return true
  end

  return false
end


function Prat.RegisterChatCommand(cmd, func)
  addon:RegisterChatCommand(cmd, func)
end


Prat.RegisterChatCommand("pratblacklist",
  function(name)
    if name and #name > 0 then
      Prat:Print("Blacklisting: '" .. tostring(name) .. "'. Reload to activate.")
      db.realm.PlayerNameBlackList[tostring(name):lower()] = true
    end
  end)


Prat.RegisterChatCommand("pratunblacklist",
  function(name)
    if name and #name > 0 then
      Prat:Print("Un-Blacklisting: '" .. tostring(name) .. "'. Reload to activate")
      db.realm.PlayerNameBlackList[tostring(name):lower()] = nil
    end
  end)


Prat.RegisterChatCommand("pratdebugmsg",
  function()
    Prat:PrintLiteral(LastMessage, Prat.LastMessage.ORG)

    local cc = addon:GetModule("CopyChat", true)
    if cc then cc:ScrapeFullChatFrame(printFrame or _G.DEFAULT_CHAT_FRAME, true) end
  end)

Prat.RegisterChatCommand("pratdebug", function()
  local dm = addon:GetModule("DebugModules", true)
  if dm then
    dm:ShowCopyDialog()
  end
end)
