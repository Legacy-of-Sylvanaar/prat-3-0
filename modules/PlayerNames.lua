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

  local PRAT_MODULE = Prat:RequestModuleName("PlayerNames")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

  -- define localized strings
  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["PlayerNames"] = true,
    ["Player name formating options."] = true,
    ["Brackets"] = true,
    ["Square"] = true,
    ["Angled"] = true,
    ["None"] = true,
    ["Class"] = true,
    ["Random"] = true,
    ["Reset Settings"] = true,
    ["No additional coloring"] = true,
    ["Restore default settings, and delete stored character data."] = true,
    ["Sets style of brackets to use around player names."] = true,
    ["Unknown Use Common Color"] = true,
    ["Toggle using a common color for unknown player names."] = true,
    ["Unknown Common Color"] = true,
    ["Set common color of unknown player names."] = true,
    ["Enable TabComplete"] = true,
    ["Toggle tab completion of player names."] = true,
    ["Show Level"] = true,
    ["Toggle level showing."] = true,
    ["Level Color Mode"] = true,
    ["Use Player Color"] = true,
    ["Use Channel Color"] = true,
    ["Color by Level Difference"] = true,
    ["How to color other player's level."] = true,
    ["Show Group"] = true,
    ["Toggle raid group showing."] = true,
    ["Show Raid Target Icon"] = true,
    ["Toggle showing the raid target icon which is currently on the player."] = true,
    ["Use toon name for RealID"] = true,

    -- In the high-cpu pullout
    ["coloreverywhere_name"] = "Color Names Everywhere",
    ["coloreverywhere_desc"] = "Color player names if they appear in the text of the chat message",
    ["hoverhilight_name"] = "Hover Hilighting",
    ["hoverhilight_desc"] = "Hilight chat lines from a specific player when hovering over thier playerlink",
    ["realidcolor_name"] = "RealID Coloring",
    ["realidcolor_desc"] = "RealID Name Coloring",
    ["Keep Info"] = true,
    ["Keep Lots Of Info"] = true,
    ["Keep player information between session for all players except cross-server players"] = true,
    ["Keep player information between session, but limit it to friends and guild members."] = true,
    ["Player Color Mode"] = true,
    ["How to color player's name."] = true,
    ["Unknown Common Color From TasteTheNaimbow"] = true,
    ["Let TasteTheNaimbow set the common color for unknown player names."] = true,
    ["Brackets Common Color"] = true,
    ["Sets common color of brackets to use around player names."] = true,
    ["Brackets Use Common Color"] = true,
    ["Toggle using a common color for brackets around player names."] = true,
    ["linkifycommon_name"] = "Linkify Common Messages",
    ["linkifycommon_desc"] = "Linkify Common Messages",
    msg_stored_data_cleared = "Stored Player Data Cleared",
    ["tabcomplete_name"] = "Possible Names",
    ["Tab completion : "] = true,
    ["Too many matches (%d possible)"] = true,
    ["Actively Query Player Info"] = true,
    ["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."] = true,
    bnetclienticon_name = "Show BNet Client Icon",
    bnetclienticon_desc = "Show an icon indicating which game or client the Battle.Net friend is using"
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/
  --[===[@non-debug@
  do
      local L

  
--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "enUS",L)


  
--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "frFR",L)


  
--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "deDE",L)


  
--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "koKR",L)


  
--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "esMX",L)


  
--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "ruRU",L)


  
--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "zhCN",L)


  
--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "esES",L)


  
--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

    PL:AddLocale(PRAT_MODULE, "zhTW",L)


  end
  --@end-non-debug@]===]

  module.Classes = {}
  module.Levels = {}
  module.Subgroups = {}

  local NOP = function(self) return end

  module.OnPlayerDataChanged = NOP


  Prat:SetModuleDefaults(module.name, {
    realm = {
      classes = {},
      levels = {}
    },
    profile = {
      on = true,
      brackets = "Square",
      tabcomplete = true,
      tabcompletelimit = 20,
      level = true,
      levelcolor = "DIFFICULTY",
      subgroup = true,
      showtargeticon = false,
      keep = false,
      keeplots = false,
      colormode = "CLASS",
      realidcolor = "CLASS",
      realidname = false,
      coloreverywhere = true,
      usecommoncolor = true,
      bracketscommoncolor = true,
      linkifycommon = true,
      bnetclienticon = true,
      bracketscolor = {
        r = 0.85,
        g = 0.85,
        b = 0.85,
        a = 1.0
      },
      useTTN = true,
      usewho = false,
      color = {
        r = 0.65,
        g = 0.65,
        b = 0.65,
        a = 1.0
      },
    }
  })


  Prat:SetModuleInit(module,
    function(self)
      -- Right click - who

      --      UnitPopupButtons["WHOIS"] = {
      --        text = "Who Is?",
      --        func = function()
      --          local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
      --          local name = dropdownFrame.name
      --
      --          if name then
      --            SendWho(name)
      --          end
      --        end
      --      }
      --  tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "WHOIS");

      --Prat:RegisterDropdownButton("WHOIS")
    end)

  module.pluginopts = {}

  Prat:SetModuleOptions(module, {
    name = PL["PlayerNames"],
    desc = PL["Player name formating options."],
    type = "group",
    plugins = module.pluginopts,
    args = {
      brackets = {
        name = PL["Brackets"],
        desc = PL["Sets style of brackets to use around player names."],
        type = "select",
        order = 110,
        values = { ["Square"] = PL["Square"], ["Angled"] = PL["Angled"], ["None"] = PL["None"] }
      },
      bracketscommoncolor = {
        name = PL["Brackets Use Common Color"],
        desc = PL["Toggle using a common color for brackets around player names."],
        type = "toggle",
        order = 111,
      },
      bracketscolor = {
        name = PL["Brackets Common Color"],
        desc = PL["Sets common color of brackets to use around player names."],
        type = "color",
        order = 112,
        get = "GetColorValue",
        set = "SetColorValue",
        disabled = function(info) return not info.handler.db.profile.bracketscommoncolor end,
      },
      usecommoncolor = {
        name = PL["Unknown Use Common Color"],
        desc = PL["Toggle using a common color for unknown player names."],
        type = "toggle",
        order = 120,
      },
      color = {
        name = PL["Unknown Common Color"],
        desc = PL["Set common color of unknown player names."],
        type = "color",
        order = 121,
        get = "GetColorValue",
        set = "SetColorValue",
        disabled = function(info) if not info.handler.db.profile.usecommoncolor then return true else return false
        end
        end,
      },
      useTTN = {
        name = PL["Unknown Common Color From TasteTheNaimbow"],
        desc = PL["Let TasteTheNaimbow set the common color for unknown player names."],
        type = "toggle",
        order = 122,
        hidden = function(info) if TasteTheNaimbow_Loaded then return false else return true end end,
        disabled = function(info) if not info.handler.db.profile.usecommoncolor then return true else return false
        end
        end,
      },
      colormode = {
        name = PL["Player Color Mode"],
        desc = PL["How to color player's name."],
        type = "select",
        order = 130,
        values = { ["RANDOM"] = PL["Random"], ["CLASS"] = PL["Class"], ["NONE"] = PL["None"] }
      },
      realidcolor = {
        name = PL["realidcolor_name"],
        desc = PL["realidcolor_desc"],
        type = "select",
        order = 135,
        values = { ["RANDOM"] = PL["Random"], ["CLASS"] = PL["Class"], ["NONE"] = PL["None"] }
      },
      realidname = {
        name = PL["Use toon name for RealID"],
        desc = PL["Use toon name for RealID"],
        type = "toggle",
        order = 136,
      },
      bnetclienticon = {
        name = PL.bnetclienticon_name,
        desc = PL.bnetclienticon_desc,
        type = "toggle",
        order = 137,
      },
      levelcolor = {
        name = PL["Level Color Mode"],
        desc = PL["How to color other player's level."],
        type = "select",
        order = 131,
        values = {
          ["PLAYER"] = PL["Use Player Color"],
          ["CHANNEL"] = PL["Use Channel Color"],
          ["DIFFICULTY"] = PL["Color by Level Difference"],
          ["NONE"] = PL["No additional coloring"]
        }
      },
      level = {
        name = PL["Show Level"],
        desc = PL["Toggle level showing."],
        type = "toggle",
        order = 140,
      },
      subgroup = {
        name = PL["Show Group"],
        desc = PL["Toggle raid group showing."],
        type = "toggle",
        order = 141,
      },
      showtargeticon = {
        name = PL["Show Raid Target Icon"],
        desc = PL["Toggle showing the raid target icon which is currently on the player."],
        type = "toggle",
        order = 142,
      },
      tabcomplete = {
        name = PL["Enable TabComplete"],
        desc = PL["Toggle tab completion of player names."],
        type = "toggle",
        order = 150,
        get = function(info) return info.handler.db.profile.tabcomplete end,
        set = function(info, v) info.handler.db.profile.tabcomplete = v; info.handler:TabComplete(v) end
      },
      keep = {
        name = PL["Keep Info"],
        desc = PL["Keep player information between session, but limit it to friends and guild members."],
        type = "toggle",
        order = 200,
      },
      keeplots = {
        name = PL["Keep Lots Of Info"],
        desc = PL["Keep player information between session for all players except cross-server players"],
        type = "toggle",
        order = 201,
        disabled = function(info) return not info.handler.db.profile.keep end,
      },
      usewho = {
        name = PL["Actively Query Player Info"],
        desc = PL["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."],
        type = "toggle",
        order = 202,
        hidden = function(info)
          if LibStub:GetLibrary("LibWho-2.0", true) then
            return false
          end

          if GetAddOnInfo("LibWho-2.0") then
            return false
          end

          return true
        end
      },
      reset = {
        name = PL["Reset Settings"],
        desc = PL["Restore default settings, and delete stored character data."],
        type = "execute",
        order = 250,
        func = "resetStoredData"
      },
    }
  })

  function module:OnValueChanged(info, b)
    local field = info[#info]
    if field == "altinvite" or field == "linkinvite" then
      self:SetAltInvite()
    elseif field == "usewho" then
      if b and not LibStub:GetLibrary("LibWho-2.0", true) then
        LoadAddOn("LibWho-2.0")
      end
      self.wholib = b and LibStub:GetLibrary("LibWho-2.0", true)
      self:updateAll()
    elseif field == "coloreverywhere" then
      self:OnPlayerDataChanged(b and UnitName("player") or nil)
    end
  end

  local mt_GuildClass = {}


  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
    Prat.RegisterChatEvent(self, "Prat_Ready")

    Prat.RegisterMessageItem("PREPLAYERDELIM", "PLAYER", "before")
    Prat.RegisterMessageItem("POSTPLAYERDELIM", "Ss", "after")

    Prat.RegisterMessageItem("PLAYERTARGETICON", "Ss", "after")

    Prat.EnableProcessingForEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    Prat.EnableProcessingForEvent("CHAT_MSG_ACHIEVEMENT")

    Prat.RegisterMessageItem("PLAYERLEVEL", "PREPLAYERDELIM", "before")
    Prat.RegisterMessageItem("PLAYERGROUP", "POSTPLAYERDELIM", "after")

    Prat.RegisterMessageItem("PLAYERCLIENTICON", "PLAYERLEVEL", "before")

    self:RegisterEvent("FRIENDLIST_UPDATE", "updateFriends")
    self:RegisterEvent("GUILD_ROSTER_UPDATE", "updateGuild")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "updateGroup")
    self:RegisterEvent("PLAYER_LEVEL_UP", "updatePlayerLevel")
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "updateTarget")
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "updateMouseOver")
    self:RegisterEvent("WHO_LIST_UPDATE", "updateWho")
    self:RegisterEvent("CHAT_MSG_SYSTEM", "updateWho") -- for short /who command

    self:RegisterEvent("PLAYER_LEAVING_WORLD", "EmptyDataCache")

    if self.db.profile.usewho then
      if not LibStub:GetLibrary("LibWho-2.0", true) then
        LoadAddOn("LibWho-2.0")
      end
      self.wholib = LibStub:GetLibrary("LibWho-2.0", true)
    end

    self:updatePlayer()
    self.NEEDS_INIT = true

    if IsInGuild() then
      self.GuildRoster()
    end

    self:TabComplete(self.db.profile.tabcomplete)
  end

  function module:OnModuleDisable()
    self:TabComplete(false)
    self:UnregisterAllEvents()
    Prat.UnregisterAllChatEvents(self)
  end


  function module:Prat_Ready()
    self:updateAll()
  end

  local cache = {
    module.Levels,
    module.Classes,
    module.Subgroups
  }


  function module:EmptyDataCache(force)
    for k, v in pairs(cache) do
      wipe(v)
    end

    self:updatePlayer()
    self.NEEDS_INIT = true
    self:OnPlayerDataChanged()
  end

  --[[------------------------------------------------
    Fill Functions
  ------------------------------------------------]] --

  -- Use C_FriendList.GetNumWhoResults instead
  local GetNumWhoResults = C_FriendList.GetNumWhoResults;

  -- Use C_FriendList.GetWhoInfo instead
  local function GetWhoInfo(index)
    local info = C_FriendList.GetWhoInfo(index);
    return info.fullName,
    info.fullGuildName,
    info.level,
    info.raceStr,
    info.classStr,
    info.area,
    info.filename,
    info.gender;
  end

  -- Use C_FriendList.SendWho instead
  local SendWho = C_FriendList.SendWho;

  local function GetNumFriends()
    return C_FriendList.GetNumFriends(),
    C_FriendList.GetNumOnlineFriends();
  end

  -- Use C_FriendList.GetFriendInfo or C_FriendList.GetFriendInfoByIndex instead
  local function GetFriendInfo(friend)
    local info;
    if type(friend) == "number" then
      info = C_FriendList.GetFriendInfoByIndex(friend);
    elseif type(friend) == "string" then
      info = C_FriendList.GetFriendInfo(friend);
    end

    if info then
      local chatFlag = "";
      if info.dnd then
        chatFlag = CHAT_FLAG_DND;
      elseif info.afk then
        chatFlag = CHAT_FLAG_AFK;
      end
      return info.name,
      info.level,
      info.className,
      info.area,
      info.connected,
      chatFlag,
      info.notes,
      info.referAFriend,
      info.guid;
    end
  end

  local GetToonInfoByBnetID
  if Prat.IsClassic then
    GetToonInfoByBnetID = function(bnetAccountID)
      if not bnetAccountID then return end

      local _, _, _, _, _, gameAccountID = BNGetFriendInfoByID(bnetAccountID)
      if gameAccountID then
        local _, toonName, client, realmName, _, faction, race, class, _, zoneName, level, gameText,
        broadcastText, broadcastTime = BNGetGameAccountInfo(gameAccountID)
        -- Pre-8.2.5 API returns empty strings if friend is online on non-WoW client
        -- We return only non-empty strings for consistency with other "no data" situations
        if toonName ~= "" then
          return toonName, level, class
        end
      end
    end
  else
    GetToonInfoByBnetID = function(bnetAccountID)
      if not bnetAccountID then return end

      local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
      if accountInfo then
        return accountInfo.gameAccountInfo.characterName,
        accountInfo.gameAccountInfo.characterLevel,
        accountInfo.gameAccountInfo.className
      end
    end
  end

  local GetBnetClientByID
  if Prat.IsClassic then
    GetBnetClientByID = function(bnetAccountID)
      if not bnetAccountID then return end

      local _, _, _, _, _, gameAccountID = BNGetFriendInfoByID(bnetAccountID)
      if gameAccountID then
        local _, toonName, client, realmName, _, faction, race, class, _, zoneName, level, gameText,
        broadcastText, broadcastTime = BNGetGameAccountInfo(gameAccountID)
        -- Pre-8.2.5 API returns empty strings if friend is online on non-WoW client
        -- We return only non-empty strings for consistency with other "no data" situations
        if client ~= "" then
          return client
        end
      end
    end
  else
    GetBnetClientByID = function(bnetAccountID)
      if not bnetAccountID then return end

      local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
      if accountInfo then
        return accountInfo.gameAccountInfo.clientProgram
      end
    end
  end

  -- This function is a wrapper for the Blizzard GuildRoster function, to account for the differences between Retail and Classic
  function module:GuildRoster(...)
    if Prat.IsRetail then
      return C_GuildInfo.GuildRoster(...)
    else
      return GuildRoster(...)
    end
  end



  --[[------------------------------------------------
    Core Functions
  ------------------------------------------------]] --
  function module:GetDescription()
    return PL["Player name formating options."]
  end

  function module:updateAll()
    self:updatePlayer()

    self:updateGroup()

    self:updateFriends()

    self.NEEDS_INIT = nil

    self:updateGuild(self.db.profile.keeplots)
  end


  function module:updateGF()
    if IsInGuild() then self.GuildRoster() end
    self:updateFriends()
    if GetNumBattlefieldScores() > 0 then
      self:updateBG()
    end
    self:updateWho()
    self:updateGuild()
  end

  function module:updatePlayer()
    local PlayerClass = select(2, UnitClass("player"))
    local Name, Server = UnitName("player")
    self:addName(Name, Server, PlayerClass, UnitLevel("player"), nil, "PLAYER")
  end

  function module:updatePlayerLevel(event, level, hp, mp, talentPoints, str, agi, sta, int, spi)
    local PlayerClass = select(2, UnitClass("player"))
    local Name, Server = UnitName("player")
    self:addName(Name, Server, PlayerClass, level, nil, "PLAYER")
  end


  function module:updateFriends()
    local Name, Class, Level
    for i = 1, GetNumFriends() do
      Name, Level, Class = GetFriendInfo(i) -- name, level, class, area, connected, status
      self:addName(Name, nil, Class, Level, nil, "FRIEND")
    end
  end



  function module:updateGuild()
    if IsInGuild() then
      self.GuildRoster()

      local Name, Class, Level, _
      for i = 1, GetNumGuildMembers(true) do
        Name, _, _, Level, _, _, _, _, _, _, Class = GetGuildRosterInfo(i)

        local plr, svr = Name:match("([^%-]+)%-?(.*)")

        self:addName(plr, nil, Class, Level, nil, "GUILD")
        self:addName(plr, svr, Class, Level, nil, "GUILD")
      end
    end
  end

  function module:updateRaid()
    --  self:Debug("updateRaid -->")
    local Name, Class, SubGroup, Level, Server, rank
    local _, zone, online, isDead, role, isML
    for k, v in pairs(self.Subgroups) do
      self.Subgroups[k] = nil
    end

    for i = 1, GetNumGroupMembers() do
      _, rank, SubGroup, Level, _, Class, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
      Name, Server = UnitName("raid" .. i)
      self:addName(Name, Server, Class, Level, SubGroup, "RAID")
    end
  end

  function module:updateParty()
    local Class, Unit, Name, Server, _
    for i = 1, GetNumSubgroupMembers() do
      Unit = "party" .. i
      _, Class = UnitClass(Unit)
      Name, Server = UnitName(Unit)
      self:addName(Name, Server, Class, UnitLevel(Unit), nil, "PARTY")
    end
  end

  function module:updateGroup()
    if IsInRaid() then
      self:updateRaid()
    elseif IsInGroup() then
      self:updateParty()
    end
  end

  function module:updateTarget()
    local Class, Name, Server
    if not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then
      return
    end
    Class = select(2, UnitClass("target"))
    Name, Server = UnitName("target")
    self:addName(Name, Server, Class, UnitLevel("target"), nil, "TARGET")
  end

  function module:updateMouseOver(event)
    local Class, Name, Server
    if not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then
      return
    end
    Class = select(2, UnitClass("mouseover"))
    Name, Server = UnitName("mouseover")
    self:addName(Name, Server, Class, UnitLevel("mouseover"), nil, "MOUSE")
  end


  function module:updateWho()
    if self.wholib then return end

    local Name, Class, Level, Server, _
    for i = 1, GetNumWhoResults() do
      Name, _, Level, _, _, _, Class = GetWhoInfo(i)
      self:addName(Name, Server, Class, Level, nil, "WHO")
    end
  end

  function module:updateBG()
    for i = 1, GetNumBattlefieldScores() do
      local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone,
      healingDone = GetBattlefieldScore(i);

      if name then
        local plr, svr = name:match("([^%-]+)%-?(.*)")
        self:addName(plr, svr, class, nil, nil, "BATTLEFIELD")
        self:addName(plr, nil, class, nil, nil, "BATTLEFIELD")
      end
    end
    self:updateGroup()
  end


  function module:resetStoredData()
    self.db.realm.classes = {}
    self.db.realm.levels = {}

    self:EmptyDataCache(true)

    self:Output(PL.msg_stored_data_cleared)
  end

  --
  -- Coloring Functions
  --
  local CLR = Prat.CLR
  function CLR:Bracket(text) return self:Colorize(module:GetBracketCLR(), text) end

  function CLR:Common(text) return self:Colorize(module:GetCommonCLR(), text) end

  function CLR:Random(text, seed) return self:Colorize(module:GetRandomCLR(seed), text) end

  function CLR:Class(text, class) return self:Colorize(module:GetClassColor(class), text) end

  local colorFunc = GetQuestDifficultyColor or GetDifficultyColor
  function CLR:Level(text, level, name, class, mode)
    local mode = mode or module.db.profile.levelcolor
    if mode and type(level) == "number" and level > 0 then
      if mode == "DIFFICULTY" then
        local diff = colorFunc(level)
        return self:Colorize(CLR:GetHexColor(CLR:Desaturate(diff)), text)
      elseif mode == "PLAYER" then
        return self:Player(text, name, class)
      end
    end

    return text
  end

  function CLR:Player(text, name, class)
    return self:Colorize(module:GetPlayerCLR(name, class), text)
  end

  local servernames

  function module:addName(Name, Server, Class, Level, SubGroup, Source)
    if Name then
      local nosave
      Source = Source or "UNKNOWN"

      -- Messy negations, but this says dont save data from
      -- sources other than guild or friends unless you enable
      -- the keeplots option
      if Source ~= "GUILD" and Source ~= "FRIEND" and Source ~= "PLAYER" then
        nosave = not self.db.profile.keeplots
      end

      if Server and Server:len() > 0 then
        nosave = true
        servernames = servernames or Prat.Addon:GetModule("ServerNames", true)

        if servernames then
          servernames:GetServerKey(Server)
        end
      end


      Name = Name .. (Server and Server:len() > 0 and ("-" .. Server) or "")

      local changed
      if Level and Level > 0 then
        self.Levels[Name:lower()] = Level
        if ((not nosave) and self.db.profile.keep) then
          self.db.realm.levels[Name:lower()] = Level
        else -- Update it if it exists
          if self.db.realm.levels[Name:lower()] then
            self.db.realm.levels[Name:lower()] = Level
          end
        end

        changed = true
      end
      if Class and Class ~= UNKNOWN then
        self.Classes[Name:lower()] = Class
        if ((not nosave) and self.db.profile.keep) then self.db.realm.classes[Name:lower()] = Class end

        changed = true
      end
      if SubGroup then
        module.Subgroups[Name:lower()] = SubGroup

        changed = true
      end

      if changed then
        self:OnPlayerDataChanged(Name)
      end
    end
  end

  function module:getClass(player)
    return self.Classes[player:lower()] or self.db.realm.classes[player:lower()] or self.db.realm.classes[player]
  end

  function module:getLevel(player)
    return self.Levels[player:lower()] or self.db.realm.levels[player:lower()] or self.db.realm.levels[player]
  end

  function module:getSubgroup(player)
    return self.Subgroups[player:lower()]
  end

  function module:GetData(player, frame)
    local class = self:getClass(player)
    local level = self:getLevel(player)

    if level == 0 then level = nil end
    if class == UNKNOWN then class = nil end

    if self.wholib and not (class and level) then
      local user, cachetime = self.wholib:UserInfo(player, { timeout = 20 })

      if user then
        level = user.Level or level
        class = user.NoLocaleClass or user.Class or class
      end
    end
    return class, level, self:getSubgroup(player)
  end

  function module:GetClassColor(class)
    return CLR:GetHexColor(Prat.GetClassGetColor(class))
  end

  function module:addInfo(Name, Server)
    return
  end



  function module:FormatPlayer(message, Name, frame, class)
    if not Name or Name:len() == 0 then return end



    local storedclass, level, subgroup = self:GetData(Name, frame)
    if class == nil then
      class = storedclass
    end

    -- Add level information if needed
    if level and self.db.profile.level then
      message.PLAYERLEVEL = CLR:Level(tostring(level), level, Name, class)
      message.PREPLAYERDELIM = ":"
    end

    -- Add raid subgroup information if needed
    if subgroup and self.db.profile.subgroup and (GetNumGroupMembers() > 0) then
      message.POSTPLAYERDELIM = ":"
      message.PLAYERGROUP = subgroup
    end

    -- Add raid target icon
    if self.db.profile.showtargeticon then
      local icon = UnitExists(Name) and GetRaidTargetIndex(Name)
      if icon then
        icon = ICON_LIST[icon]

        if icon and icon:len() > 0 then
          -- since you cant have icons in links end the link before the icon
          message.PLAYERTARGETICON = "|h" .. icon .. "0|t"
          message.Ll = ""
        end
      end
    end

    if message.PLAYERLINKDATA and (message.PLAYERLINKDATA:find("BN_") and message.PLAYER ~= UnitName("player")) then
      if self.db.profile.realidcolor == "CLASS" then
        local toonName, level, class = GetToonInfoByBnetID(message.PRESENCE_ID)
        if toonName and self.db.profile.realidname then
          message.PLAYER = toonName
          if level and self.db.profile.level then
            message.PLAYERLEVEL = CLR:Level(tostring(level), tonumber(level), nil, nil, "DIFFICULTY")
            message.PREPLAYERDELIM = ":"
          end
        end
        message.PLAYER = CLR:Class(message.PLAYER, class or "") -- Empty string to get default gray color
      elseif self.db.profile.realidcolor == "RANDOM" then
        message.PLAYER = CLR:Random(message.PLAYER, message.PLAYER:lower())
      end

      if self.db.profile.bnetclienticon then
        local client = GetBnetClientByID(message.PRESENCE_ID)
        if client then
          message.PLAYERCLIENTICON = ("|T%s:%d:%d:%d:%d|t"):format(BNet_GetClientAtlas(client), 14)
        end
      end
    else
      -- Add the player name in the proper color
      message.PLAYER = CLR:Player(message.PLAYER, Name, class)
    end

    -- Add the correct bracket style and color
    if message.pP then
      local prof_brackets = self.db.profile.brackets
      if prof_brackets == "Angled" then
        message.pP = CLR:Bracket("<") .. message.pP
        message.Pp = message.Pp .. CLR:Bracket(">")
      elseif prof_brackets == "None" then
      else
        message.pP = CLR:Bracket("[") .. message.pP
        message.Pp = message.Pp .. CLR:Bracket("]")
      end
    end
  end


  --
  -- Prat Event Implementation
  --
  local EVENTS_FOR_RECHECK = {
    ["CHAT_MSG_GUILD"] = module.updateGF,
    ["CHAT_MSG_INSTANCE_CHAT"] = module.updateBG,
    ["CHAT_MSG_INSTANCE_CHAT_LEADER"] = module.updateBG,
    ["CHAT_MSG_SYSTEM"] = module.updateGF,
  }

  local EVENTS_FOR_CACHE_GUID_DATA = {
    CHAT_MSG_PARTY = true,
    CHAT_MSG_PARTY_LEADER = true,
    CHAT_MSG_RAID = true,
    CHAT_MSG_RAID_WARNING = true,
    CHAT_MSG_RAID_LEADER = true,
    CHAT_MSG_INSTANCE_CHAT = true,
    CHAT_MSG_INSTANCE_CHAT_LEADER = true,
  }


  function module:MakePlayer(message, name)
    if type(name) == "string" then
      local plr, svr = name:match("([^%-]+)%-?(.*)")
      --     self:Debug("MakePlayer", name, plr, svr)

      message.lL = "|Hplayer:"
      message.PLAYERLINK = name
      message.LL = "|h"
      message.PLAYER = plr
      message.Ll = "|h"

      if svr and strlen(svr) > 0 then
        message.sS = "-"
        message.SERVER = svr
      end
    end
  end


  function module:Prat_FrameMessage(info, message, frame, event)
    local _
    if self.NEEDS_INIT then
      self:updateAll()
    end

    -- This name is used to lookup playerdata, not for display
    local Name = message.PLAYERLINK or ""
    message.Pp = ""
    message.pP = ""

    -- If there is no playerlink, then we have nothing to do
    if Name:len() == 0 then
      return
    end

    Name = Ambiguate(Name, "all")

    local class, level, subgroup = self:GetData(Name)

    if (class == nil) and message and message.ORG and message.ORG.GUID and message.ORG.GUID:len() > 0 and message.ORG.GUID ~= "0000000000000000" then
      _, class = GetPlayerInfoByGUID(message.ORG.GUID)

      if class ~= nil and EVENTS_FOR_CACHE_GUID_DATA[event] then
        self:addName(Name, message.SERVER, class, level, subgroup, "GUID")
      end
    end
    local fx = EVENTS_FOR_RECHECK[event]
    if fx ~= nil and (level == nil or level == 0) then
      fx(self)
    end

    self:FormatPlayer(message, Name, frame, class)
  end

  function module:GetPlayerCLR(name, class, mode)
    if not mode then mode = module.db.profile.colormode end

    if name and strlen(name) > 0 then
      if class and mode == "CLASS" then
        return self:GetClassColor(class)
      elseif mode == "RANDOM" then
        return self:GetRandomCLR(name)
      else
        return self:GetCommonCLR()
      end
    end
  end

  function module:GetBracketCLR()
    if not self.db.profile.bracketscommoncolor then
      return CLR.COLOR_NONE
    else
      local color = self.db.profile.bracketscolor
      return CLR:GetHexColor(color)
    end
  end

  function module:GetCommonCLR()
    local color = CLR.COLOR_NONE
    if self.db.profile.usecommoncolor then
      if self.db.profile.useTTN and TasteTheNaimbow_Loaded then
        color = TasteTheNaimbowExternalColor(name)
      else
        color = CLR:GetHexColor(self.db.profile.color)
      end
    end
    return color
  end

  function module:GetRandomCLR(Name)
    local hash = 17
    for i = 1, string.len(Name) do
      hash = hash * 37 * string.byte(Name, i);
    end

    local r = math.floor(math.fmod(hash / 97, 255));
    local g = math.floor(math.fmod(hash / 17, 255));
    local b = math.floor(math.fmod(hash / 227, 255));

    if ((r * 299 + g * 587 + b * 114) / 1000) < 105 then
      r = math.abs(r - 255);
      g = math.abs(g - 255);
      b = math.abs(b - 255);
    end

    return string.format("%02x%02x%02x", r, g, b)
  end


  function module:TabComplete(enabled)
    local AceTab = LibStub("AceTab-3.0")

    if enabled then
      servernames = servernames or Prat.Addon:GetModule("ServerNames", true)

      if not AceTab:IsTabCompletionRegistered(PL["tabcomplete_name"]) then
        local foundCache = {}
        AceTab:RegisterTabCompletion(PL["tabcomplete_name"], nil,
          function(t, text, pos)
            for name in pairs(self.Classes) do
              table.insert(t, name)
            end
          end,
          function(u, cands, ...)
            local candcount = #cands
            if candcount <= self.db.profile.tabcompletelimit then
              local text
              for key, cand in pairs(cands) do
                if servernames then
                  local plr, svr = key:match("([^%-]+)%-?(.*)")

                  cand = CLR:Player(cand, plr, self:getClass(key))

                  if svr then
                    svr = servernames:FormatServer(nil, servernames:GetServerKey(svr))
                    cand = cand .. (svr and ("-" .. svr) or "")
                  end
                else
                  cand = CLR:Player(cand, cand, self:getClass(cand))
                end


                text = text and (text .. ", " .. cand) or cand
              end
              return "   " .. text
            else
              return "   " .. PL["Too many matches (%d possible)"]:format(candcount)
            end
          end,
          nil,
          function(name)
            return name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1):match("^[^%-]+")
          end)
      end
    else
      if AceTab:IsTabCompletionRegistered(PL["tabcomplete_name"]) then
        AceTab:UnregisterTabCompletion(PL["tabcomplete_name"])
      end
    end
  end

  return
end) -- Prat:AddModuleToLoad
