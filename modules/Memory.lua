---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
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

Prat:AddModuleToLoad(function()
  local function dbg(...) end

  --@debug@
--  function dbg(...) Prat:PrintLiteral(...) end

  --@end-debug@

  local PRAT_MODULE = Prat:RequestModuleName("Memory")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

  -- define localized strings
  local PL = module.PL


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = true,
      frames = { ["*"] = {} },
      types = {},
      cvars = {},
      autoload = false
    }
  })

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["module_name"] = "Memory",
    ["module_desc"] = "Support saving the Blizzard chat settings to your profile so they can be synced across all your characters",
    module_info = "|cffff8888THIS MODULE IS EXPERIMENTAL|r \n\n This module allows you to load/save all your chat settings and frame layout. These settings can be loaded on any of your characters",
    autoload_name = "Load Settings Automatically",
    autoload_desc = "Automatically load the saved settings when you log in",
    load_name = "Load Settings",
    load_desc = "Load the chat frame/tabs from the last save",
    save_name = "Save Settings",
    save_desc = "Save the current chat frame/tab configuration",
    msg_nosettings = "No stored settings",
    msg_settingsloaded = "Settings Loaded",
    command_header_name = "Commands",
    options_header_name = "Options",
    msg_loadfailed = "Could not fully restore the chat settings"
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Memory")@
PL:AddLocale(PRAT_MODULE, "zhTW",  L)
end
--@end-non-debug@]===]

  local toggleOption = {
    name = function(info) return info.handler.PL[info[#info] .. "_name"] end,
    desc = function(info) return info.handler.PL[info[#info] .. "_desc"] end,
    type = "toggle",
  }

  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    args = {
      info = {
        name = PL.module_info,
        type = "description",
      },
      command_header = {
        name = PL.command_header_name,
        type = "header",
        order = 190,
      },
      save = {
        name = PL.save_name,
        desc = PL.save_desc,
        type = "execute",
        order = 191,
        func = "SaveSettings"
      },
      load = {
        name = PL.load_name,
        desc = PL.load_desc,
        type = "execute",
        order = 190,
        func = "LoadSettings"
      },
      options_header = {
        name = PL.options_header_name,
        type = "header",
        order = 195,
      },
      autoload = {
        name = PL.autoload_name,
        desc = PL.autoload_desc,
        type = "toggle",
        order = 200,
      }
    }
  })

  local cvars = {
    whisperMode = "CVar",
    chatStyle = "CVar",
    wholeChatWindowClickable = "CVarBool",
    whisperMode = "CVar",
    blockChannelInvites = "CVarBool"
  }

  Prat:SetModuleInit(module.name,
    function(self)
      self:RegisterEvent("PLAYER_ENTERING_WORLD")
    end)

  function module:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self.ready = true
    if self.needsLoading then
      self:ScheduleTimer("LoadSettings", 0)
    end
  end

  function module:OnModuleEnable()
    if not self.working and self.db.profile.autoload and next(self.db.profile.frames) then
      if not self.ready then
        self.needsLoading = true
      else
        self:ScheduleTimer("LoadSettings", 0)
      end
    end

    Prat.RegisterChatEvent(self, Prat.Events.PRE_ADDMESSAGE)
  end

  function module:SaveSettings()
    local db = self.db.profile

    wipe(db.frames)

    for i = 1, NUM_CHAT_WINDOWS do
      self:SaveSettingsForFrame(i)
    end

    db.types =  CopyTable(getmetatable(ChatTypeInfo).__index)
    db.channels = { GetChannelList() }

    for k,v in pairs(cvars) do
      db.cvars[k] = _G["Get"..v](k)
    end

    self:Output("Settings Saved")
  end

  function module:SaveSettingsForFrame(frameId)
    local db = self.db.profile.frames[frameId]

    local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(frameId)
    db.name, db.fontSize, db.r, db.g, db.b, db.alpha, db.shown, db.locked, db.docked, db.uninteractable =
    name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable

    local f = Chat_GetChatFrame(frameId)
    db.minimized = f.minimized
    if f.minFrame then
      db.minframe = {}
      for i=1,f.minFrame:GetNumPoints() do
        local point, relativeTo, relativePoint, xoff, yoff = f.minFrame:GetPoint(i)
        db.minframe[#db.minframe+1] = { point, (type(relativeTo) == "table") and relativeTo:GetName() or relativeTo, relativePoint, xoff, yoff }
      end
    end
    db.messages = { GetChatWindowMessages(frameId) }
    db.channels = { GetChatWindowChannels(frameId) }

    local width, height = GetChatWindowSavedDimensions(frameId);
    local point, xOffset, yOffset = GetChatWindowSavedPosition(frameId)

    db.point, db.xOffset, db.yOffset, db.width, db.height =
    point, xOffset, yOffset, width, height
  end

  function module:LoadFrameSettingsForFrame(frameId)
    local db = self.db.profile.frames[frameId]
    local success = true
    local f = Chat_GetChatFrame(frameId)

    if not db.shown and not db.docked then
      FCF_Close(f)
      return success
    end

    if f.minimized then
      FCF_MaximizeFrame(f)
    end

    -- Restore FloatingChatFrame
    SetChatWindowName(frameId, db.name)
    SetChatWindowSize(frameId, db.fontSize)
    SetChatWindowColor(frameId, db.r, db.g, db.b)
    SetChatWindowAlpha(frameId, db.alpha)
    SetChatWindowDocked(frameId, db.docked)
    SetChatWindowLocked(frameId, db.locked)
    SetChatWindowUninteractable(frameId, db.uninteractable)
    SetChatWindowSavedDimensions(frameId, db.width, db.height)
    if db.point then
      SetChatWindowSavedPosition(frameId, db.point, db.xOffset, db.yOffset)
    end
    SetChatWindowShown(frameId, db.shown)
    FloatingChatFrame_Update(frameId, 1)
    FCF_DockUpdate()
    ChatEdit_DeactivateChat(f.editBox)
    FCF_FadeInChatFrame(f)

    if db.minimized then
      FCF_MinimizeFrame(f, "LEFT")
      f.minFrame:ClearAllPoints()
      for i,v in ipairs(db.minframe) do
        local point, relativeTo, relativePoint, xoff, yoff = unpack(v)
        f.minFrame:SetPoint(point, relativeTo and _G[relativeTo], relativePoint, xoff, yoff)
      end

      f.minFrame:SetUserPlaced(true)
    end
    return success
  end

  function module:LoadChatSettingsForFrame(frameId)
    local db = self.db.profile.frames[frameId]
    local success = true
    local f = Chat_GetChatFrame(frameId)

    -- Restore ChatFrame
    ChatFrame_RemoveAllMessageGroups(f)
    for _, v in ipairs(db.messages) do
      ChatFrame_AddMessageGroup(f, v);
    end

    ChatFrame_RemoveAllChannels(f)
    for i = 1, #db.channels, 2 do
      local chan = ChatFrame_AddChannel(f, db.channels[i])
      if not chan then
        dbg("failed to load", db.channels[i], chan)
        success = false
      end
    end

    ChatFrame_ReceiveAllPrivateMessages(f)
    return success
  end
  function module:LeaveChannels(...)
    local db = self.db.profile
    local map = self:GetChannelMap(unpack(db.channels))
    for i = 1, select("#", ...), 3 do
      local snum, sname = select(i, ...);
      local num, name = map[sname], map[snum];
      if snum ~= num or sname ~= name then
        dbg("leave", snum, sname, num, name)
        LeaveChannelByName(snum)
      end
    end
  end

  local channelStepDelay = 0.5
  local function getDelay()
    return channelStepDelay + module.errorcount
  end

  function module:LeavePlaceholderChannels(...)
    dbg("leave placeholders", ...)
    for i = 1, select("#", ...), 3 do
      local num, name = select(i, ...);
      if name:match("^LeaveMe") then
        dbg("leave", num, name)
        LeaveChannelByName(num)
      end
    end

    self:ScheduleTimer(function() module:CheckChannels(GetChannelList()) end,  getDelay())
  end

  function module:GetChannelMap(...)
    local map = {}
    for i = 1, select("#", ...), 3 do
      local num, name = select(i, ...);
      map[name] = num
      map[num] = name
    end

    return map
  end

  function module:CheckChannels(...)
    dbg("check channels", ...)
    local db = self.db.profile
    local map = self:GetChannelMap(unpack(db.channels))

    local correct = true
    if select("#", ...) ~= #db.channels then
      correct = "wrong"
    else
      for i = 1, select("#", ...), 3 do
        local snum, sname = select(i, ...);
        local num, name = db.channels[i], db.channels[i + 1];
        if snum ~= num or sname ~= name then
          dbg("mismatch", snum, num, sname, name, map[sname])
          correct = map[sname] and "order" or "wrong"
        end
      end
    end

    dbg("channels correct", correct)
    if type(correct) == "boolean" or self.errorcount >= 3 then
      self:ScheduleTimer("LoadSettings", 0)
    else
      if correct == "wrong" then
        self:LeaveChannels(GetChannelList())
        self:ScheduleTimer("RestoreChannels", getDelay(), unpack(db.channels))
        self.errorcount = self.errorcount + 1
      elseif correct == "order" then
        dbg(GetChannelList())
        for i = 1, select("#", ...), 3 do
          local snum, sname = select(i, GetChannelList());
          local curnum = map[sname]
          dbg("check", snum, curnum)
          if snum ~= curnum then
            dbg("swap", snum, curnum)
            if Prat.IsClassic then
              SwapChatChannelByLocalID(snum, curnum)
            else
              C_ChatInfo.SwapChatChannelsByChannelIndex(snum, curnum)
            end
          end
        end

        self:ScheduleTimer(function() module:CheckChannels(GetChannelList()) end,  getDelay())
      end
    end
  end

  if Prat.IsClassic then
    function module:RestoreChannels(...)
      local index = 1
      for i = 1, select("#", ...), 3 do
        local num, name = select(i, ...);
        dbg("restore", name, num)
        while index < num do
          if GetChannelName(index) == 0 then
            JoinTemporaryChannel("LeaveMe" .. index)
            dbg("join", "LeaveMe" .. index)
          end
          index = index + 1
        end
        if GetChannelName(index) == 0 then
          dbg("join", name)
          JoinChannelByName(name)
        else
          dbg("occupied", name, select(2, GetChannelName(index)))
        end
        index = index + 1
      end

      self:ScheduleTimer(function() module:LeavePlaceholderChannels(GetChannelList()) end,  getDelay())
    end
  else
    function module:RestoreChannels(...)
      local index = 1
      for i = 1, select("#", ...), 3 do
        local num, name = select(i, ...);
        dbg("restore", name, num)
        while index < num do
          if GetChannelName(index) == 0 then
            JoinTemporaryChannel("LeaveMe" .. index)
            dbg("join", "LeaveMe" .. index)
          else
            dbg("skip", index)
          end
          index = index + 1
        end
        if GetChannelName(index) == 0 then
          local clubId, streamId = ChatFrame_GetCommunityAndStreamFromChannel(name);
          if not clubId or not streamId then
            dbg("join", name)

            JoinChannelByName(name)
          else
            dbg("addclub", clubId, streamId)
            ChatFrame_AddNewCommunitiesChannel(1, clubId, streamId)
          end
        else
          dbg("occupied", name, select(2, GetChannelName(index)))
        end
        index = index + 1
      end
      self:ScheduleTimer(function() module:LeavePlaceholderChannels(GetChannelList()) end,  getDelay())
    end
  end
  function module:LoadSettings()
    local db = self.db.profile
    local success = true
  
    if not next(db.frames) then
      self:Output(PL.msg_nosettings)
      self.needsLoading = nil
      return
    end

    if not self.working then
      self.working = {}
    end

    -- restore CVars
    if not self.working.cvars then
      for k, v in pairs(cvars) do
        local val = db.cvars[k]
        if val ~= nil then
          dbg("set cvar", k, val)
          SetCVar(k, val)
        end
      end
      self.working.cvars = true
    end

    -- restore frame appearance and layout
    if not self.working.frames then
      for k, v in pairs(db.frames) do
        if not self:LoadFrameSettingsForFrame(k) then
          success = false
        end
      end
      FCFDock_SelectWindow(GENERAL_CHAT_DOCK, ChatFrame1)
      self.working.frames = success
    end

    -- restore chat channels
    if not self.working.channels and db.channels and #db.channels > 0 then
      self.errorcount = 0
      self:ScheduleTimer("CheckChannels", getDelay(), GetChannelList())
      self.working.channels = true
      return
    end

    -- restore channels and messages to chatframes
    if not self.working.chatframes then
      for k, v in pairs(db.frames) do
        if not self:LoadChatSettingsForFrame(k) then
          success = false
        end
      end
      self.working.chatframes = success
    end

    -- restore chat colors
    if not self.working.colorsa then
      for k, v in pairs(db.types) do
        ChangeChatColor(k, v.r, v.g, v.b)
      end
      self.working.colorsa = true
    end

    if success then
      self.needsLoading = nil
      self.working = nil
      self.errorcount = nil
      self:Output(PL.msg_settingsloaded)
    else
      self.errorcount = self.errorcount + 1

      if self.errorcount > 10 then
        self.working = nil
        self.errorcount = nil
        self:Output(PL.msg_loadfailed)
        return
      end
      self:ScheduleTimer("LoadSettings", getDelay())
    end
  end

  function module:Prat_PreAddMessage(arg, message, frame, event, t, r, g, b)
    if self.working and ("YOU_CHANGED" == message.NOTICE or "YOU_LEFT" == message.NOTICE) then
      message.DONOTPROCESS = true
    end
  end
end)

