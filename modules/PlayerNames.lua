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
	local module = Prat:NewModule("PlayerNames", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
	local PL = module.PL

	--@debug@
	PL:AddLocale("enUS", {
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
		["Mark Guildies"] = true,
		["Toggle showing an indicator for your guild members."] = true,
		["Show Faction"] = true,
		["Toggle showing a faction indicator for your guild members."] = true,
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


  L = {}
  --@localization(locale="enUS", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("enUS",L)



  L = {}
  --@localization(locale="frFR", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("frFR",L)



  L = {}
  --@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("deDE",L)



  L = {}
  --@localization(locale="koKR", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("koKR",L)



  L = {}
  --@localization(locale="esMX", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("esMX",L)



  L = {}
  --@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("ruRU",L)



  L = {}
  --@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("zhCN",L)



  L = {}
  --@localization(locale="esES", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("esES",L)



  L = {}
  --@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="none", same-key-is-true=true, namespace="PlayerNames")@

	  PL:AddLocale("zhTW",L)


	end
	--@end-non-debug@]===]

	module.Classes = {}
	module.Levels = {}
	module.Subgroups = {}
	module.GuildMembers = {}
	module.GuildFactions = {}

	local NOP = function()
		return
	end

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
			showguild = false,
			showfaction = false,
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
			usewho = false,
			color = {
				r = 0.65,
				g = 0.65,
				b = 0.65,
				a = 1.0
			},
		}
	})

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
				disabled = function(info)
					return not info.handler.db.profile.bracketscommoncolor
				end,
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
				disabled = function(info)
					if not info.handler.db.profile.usecommoncolor then
						return true
					else
						return false
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
				hidden = Prat.IsRetail,
			},
			showguild = {
				name = PL["Mark Guildies"],
				desc = PL["Toggle showing an indicator for your guild members."],
				type = "toggle",
				order = 143,
			},
			showfaction = {
				name = PL["Show Faction"],
				desc = PL["Toggle showing a faction indicator for your guild members."],
				type = "toggle",
				order = 144,
			},
			tabcomplete = {
				name = PL["Enable TabComplete"],
				desc = PL["Toggle tab completion of player names."],
				type = "toggle",
				order = 150,
				get = function(info)
					return info.handler.db.profile.tabcomplete
				end,
				set = function(info, v)
					info.handler.db.profile.tabcomplete = v;
					info.handler:TabComplete(v)
				end
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
				disabled = function(info)
					return not info.handler.db.profile.keep
				end,
			},
			usewho = {
				name = PL["Actively Query Player Info"],
				desc = PL["Query the server for all player names we do not know. Note: This happpens pretty slowly, and this data is not saved."],
				type = "toggle",
				order = 202,
				hidden = function()
					if LibStub:GetLibrary("LibWho-2.0", true) then
						return false
					end

					if C_AddOns.GetAddOnInfo("LibWho-2.0") then
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
				C_AddOns.LoadAddOn("LibWho-2.0")
			end
			self.wholib = b and LibStub:GetLibrary("LibWho-2.0", true)
			self:UpdateAll()
		elseif field == "coloreverywhere" then
			self:OnPlayerDataChanged(b and UnitName("player") or nil)
		end
	end

	function module:OnModuleEnable()
		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
		Prat.RegisterChatEvent(self, "Prat_Ready")

		Prat.RegisterMessageItem("PREPLAYERDELIM", "PLAYER", "before")
		Prat.RegisterMessageItem("POSTPLAYERDELIM", "Ss", "after")
		Prat.RegisterMessageItem("PLAYERTARGETICON", "Ss", "after")
		Prat.RegisterMessageItem("PLAYERLEVEL", "PREPLAYERDELIM", "before")
		Prat.RegisterMessageItem("PLAYERGROUP", "POSTPLAYERDELIM", "after")
		Prat.RegisterMessageItem("PLAYERCLIENTICON", "PLAYERLEVEL", "before")
		Prat.RegisterMessageItem("PLAYERFACTION", "PREPLAYERDELIM", "before")
		Prat.RegisterMessageItem("PLAYERFACTIONDELIM", "PLAYERFACTION", "before")
		Prat.RegisterMessageItem("PLAYERGUILD", "PLAYERFACTIONDELIM", "before")
		Prat.RegisterMessageItem("PLAYERGUILDDELIM", "PLAYERGUILD", "before")

		Prat.EnableProcessingForEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
		Prat.EnableProcessingForEvent("CHAT_MSG_ACHIEVEMENT")

		self:RegisterEvent("FRIENDLIST_UPDATE", "UpdateFriends")
		self:RegisterEvent("GUILD_ROSTER_UPDATE")
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateGroup")
		self:RegisterEvent("PLAYER_LEVEL_UP")
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateTarget")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UpdateMouseOver")
		self:RegisterEvent("WHO_LIST_UPDATE", "UpdateWho")
		self:RegisterEvent("CHAT_MSG_SYSTEM", "UpdateWho")
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "EmptyDataCache")

		if self.db.profile.usewho then
			if not LibStub:GetLibrary("LibWho-2.0", true) then
				C_AddOns.LoadAddOn("LibWho-2.0")
			end
			self.wholib = LibStub:GetLibrary("LibWho-2.0", true)
		end

		self:UpdatePlayer()
		self.NEEDS_INIT = true

		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end

		self:TabComplete(self.db.profile.tabcomplete)

		self:CacheAppIcons()
	end

	function module:OnModuleDisable()
		self:TabComplete(false)
		self:UnregisterAllEvents()
		Prat.UnregisterAllChatEvents(self)
	end

	function module:Prat_Ready()
		self:UpdateAll()
	end

	local cache = {
		module.Levels,
		module.Classes,
		module.Subgroups,
		module.GuildMembers,
		module.GuildFactions
	}

	function module:EmptyDataCache()
		for _, v in pairs(cache) do
			wipe(v)
		end

		self:UpdatePlayer()
		self.NEEDS_INIT = true
		self:OnPlayerDataChanged()
	end

	--[[------------------------------------------------
	  Fill Functions
	------------------------------------------------]] --
	local function GetToonInfoByBnetID(bnetAccountID)
		if not bnetAccountID then
			return
		end

		local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
		if not accountInfo then
			return
		end

		return accountInfo.gameAccountInfo.characterName,
			accountInfo.gameAccountInfo.characterLevel,
			accountInfo.gameAccountInfo.className
	end

	local function GetBnetClientByID(bnetAccountID)
		if not bnetAccountID then
			return
		end

		local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
		if not accountInfo then
			return
		end

		return accountInfo.gameAccountInfo.clientProgram
	end

	function module:CacheAppIcons()
		self.appIcons = {}

		-- List derived from old atlas containing client icons
		for _, client in ipairs({
			"App", -- B.net
			"WoW",
			"Hero", -- Heroes of the Storm
			"LAZR", -- Modern Warfare 2
			"OSI", -- Diablo Something
			"Pro", -- Overwatch
			"Overwatch-zhCN", -- Overwatch zhCN
			"RTRO",
			"ODIN", -- Modern Warfare
			"S1", -- Starcraft 1
			"WTCG", -- Hearthstone
			"ZEUS", -- Black Ops
			"FEN", -- Diablo 4
			"D3", -- Diablo 3
			"ANBS", -- Diablo Something
			"VIPR",
			"W3", -- Warcraft 3
			"WLBY",
			"GRY",
		}) do
			C_Texture.GetTitleIconTexture(client, 0, function(success, texture)
				if success then
					self.appIcons[client] = texture
				end
			end)
		end
	end

	--[[------------------------------------------------
	  Core Functions
	------------------------------------------------]] --
	function module:GetDescription()
		return PL["Player name formating options."]
	end

	function module:UpdateAll()
		self.NEEDS_INIT = nil
		self:UpdatePlayer()
		self:UpdateFriends()
		self:UpdateWho()
		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end
		if GetNumBattlefieldScores() > 0 then
			self:UpdateBG()
		else
			self:UpdateGroup()
		end
	end

	function module:UpdateGF()
		self:UpdateFriends()
		self:UpdateWho()
		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end
		if GetNumBattlefieldScores() > 0 then
			self:UpdateBG()
		else
			self:UpdateGroup()
		end
	end

	function module:UpdatePlayer()
		local PlayerClass = select(2, UnitClass("player"))
		local Name, Server = UnitName("player")
		self:addName(Name, Server, PlayerClass, UnitLevel("player"), nil, "PLAYER")
	end

	function module:PLAYER_LEVEL_UP(_, level)
		local PlayerClass = select(2, UnitClass("player"))
		local Name, Server = UnitName("player")
		self:addName(Name, Server, PlayerClass, level, nil, "PLAYER")
	end

	function module:UpdateFriends()
		for i = 1, C_FriendList.GetNumFriends() do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			self:addName(info.name, nil, info.className, info.level, nil, "FRIEND")
		end
	end

	function module:GUILD_ROSTER_UPDATE()
		wipe(self.GuildMembers)
		wipe(self.GuildFactions)
		for i = 1, GetNumGuildMembers() do
			local Name, _, _, Level, _, _, _, _, _, _, Class = GetGuildRosterInfo(i)
			if Name then
				local plr, svr = Name:match("([^%-]+)%-?(.*)")
				self.GuildMembers[plr:lower()] = true
				if svr and svr:len() > 0 then
					self.GuildMembers[(plr .. "-" .. svr):lower()] = true
				end
				self:addName(plr, nil, Class, Level, nil, "GUILD")
				self:addName(plr, svr, Class, Level, nil, "GUILD")
			end
		end

		-- Fetch faction data via Club API
		-- GetClubMembers and GetMemberInfo are SecretInChatMessagingLockdown,
		-- and ClubMemberInfo fields (name, race) may also be secret
		local clubId = C_Club and C_Club.GetGuildClubId and C_Club.GetGuildClubId()
		if clubId and not (issecretvalue and issecretvalue(clubId)) then
			local members = C_Club.GetClubMembers(clubId)
			if members and not (issecretvalue and issecretvalue(members)) then
				for _, memberId in ipairs(members) do
					local info = C_Club.GetMemberInfo(clubId, memberId)
					if info and not (issecretvalue and issecretvalue(info))
						and info.name and not issecretvalue(info.name)
						and info.race and not issecretvalue(info.race) then
						local factionInfo = C_CreatureInfo.GetFactionInfo(info.race)
						if factionInfo then
							local name = Ambiguate(info.name, "all"):lower()
							self.GuildFactions[name] = factionInfo.groupTag
						end
					end
				end
			end
		end
	end

	function module:UpdateRaid()
		for k, _ in pairs(self.Subgroups) do
			self.Subgroups[k] = nil
		end

		for i = 1, GetNumGroupMembers() do
			local _, _, SubGroup, Level, _, Class = GetRaidRosterInfo(i)
			local Name, Server = UnitName("raid" .. i)
			self:addName(Name, Server, Class, Level, SubGroup, "RAID")
		end
	end

	function module:UpdateParty()
		for i = 1, GetNumSubgroupMembers() do
			local Unit = "party" .. i
			local _, Class = UnitClass(Unit)
			local Name, Server = UnitName(Unit)
			self:addName(Name, Server, Class, UnitLevel(Unit), nil, "PARTY")
		end
	end

	function module:UpdateGroup()
		if IsInRaid() then
			self:UpdateRaid()
		elseif IsInGroup() then
			self:UpdateParty()
		end
	end

	function module:UpdateTarget()
		if not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then
			return
		end
		local Class = select(2, UnitClass("target"))
		local Name, Server = UnitName("target")
		self:addName(Name, Server, Class, UnitLevel("target"), nil, "TARGET")
	end

	function module:UpdateMouseOver()
		if not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then
			return
		end
		local Class = select(2, UnitClass("mouseover"))
		local Name, Server = UnitName("mouseover")
		self:addName(Name, Server, Class, UnitLevel("mouseover"), nil, "MOUSE")
	end

	function module:UpdateWho()
		if self.wholib then
			return
		end

		for i = 1, C_FriendList.GetNumWhoResults() do
			local info = C_FriendList.GetWhoInfo(i)
			self:addName(info.fullName, nil, info.classStr, info.level, nil, "WHO")
		end
	end

	function module:UpdateBG()
		for i = 1, GetNumBattlefieldScores() do
			local name, _, _, _, _, _, _, _, class = GetBattlefieldScore(i);

			if name and (not issecretvalue or not issecretvalue(name)) then
				local plr, svr = name:match("([^%-]+)%-?(.*)")
				self:addName(plr, nil, class, nil, nil, "BATTLEFIELD")
				self:addName(plr, svr, class, nil, nil, "BATTLEFIELD")
			end
		end
		self:UpdateGroup()
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
	function CLR:Bracket(text)
		return self:Colorize(module:GetBracketCLR(), text)
	end

	function CLR:Random(text, seed)
		return self:Colorize(module:GetRandomCLR(seed), text)
	end

	local colorFunc = GetQuestDifficultyColor or GetDifficultyColor
	function CLR:Level(text, level, name, class, mode)
		mode = mode or module.db.profile.levelcolor
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
		local mode = module.db.profile.colormode

		if name then
			if class and mode == "CLASS" then
				local classColor = Prat.GetClassColor(class, true)
				if classColor then
					return classColor:WrapTextInColorCode(text)
				end
				return text
			elseif mode == "RANDOM" then
				return self:Colorize(module:GetRandomCLR(name), text)
			else
				return self:Colorize(module:GetCommonCLR(), text)
			end
		end
	end

	local servernames
	function module:addName(Name, Server, Class, Level, SubGroup, Source)
		if not Name then
			return
		end

		if issecretvalue and (issecretvalue(Name) or issecretvalue(Server)) then
			return
		end

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
			servernames = servernames or Prat:GetModule("ServerNames")

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
			else
				-- Update it if it exists
				if self.db.realm.levels[Name:lower()] then
					self.db.realm.levels[Name:lower()] = Level
				end
			end

			changed = true
		end
		if Class and Class ~= UNKNOWN then
			self.Classes[Name:lower()] = Class
			if ((not nosave) and self.db.profile.keep) then
				self.db.realm.classes[Name:lower()] = Class
			end

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

	function module:getClass(player)
		return self.Classes[player:lower()] or self.db.realm.classes[player:lower()] or self.db.realm.classes[player]
	end

	function module:getLevel(player)
		return self.Levels[player:lower()] or self.db.realm.levels[player:lower()] or self.db.realm.levels[player]
	end

	function module:getSubgroup(player)
		return self.Subgroups[player:lower()]
	end

	function module:GetData(player)
		local class = self:getClass(player)
		local level = self:getLevel(player)

		if level == 0 then
			level = nil
		end
		if class == UNKNOWN then
			class = nil
		end

		if self.wholib and not (class and level) then
			local user = self.wholib:UserInfo(player, { timeout = 20 })

			if user then
				level = user.Level or level
				class = user.NoLocaleClass or user.Class or class
			end
		end
		return class, level, self:getSubgroup(player)
	end

	function module:FormatPlayer(message, Name, frame, class)
		if not Name or Name:len() == 0 then
			return
		end

		local storedclass, level, subgroup = self:GetData(Name, frame)
		if class == nil then
			class = storedclass
		end

		-- Add level information if needed
		if level and self.db.profile.level then
			message.PLAYERLEVEL = CLR:Level(tostring(level), level, Name, class)
			message.PREPLAYERDELIM = ":"
		end

		-- Add guild and faction indicators if needed
		-- Message item order: LEVEL : GUILDDELIM : GUILD : FACTIONDELIM : FACTION : PREDELIM : PLAYER
		local nameLower = Name:lower()
		local hasLevel = level and self.db.profile.level
		local isGuildie = self.db.profile.showguild and self.GuildMembers[nameLower]
		local faction = self.db.profile.showfaction and self.GuildFactions[nameLower]

		if isGuildie then
			message.PLAYERGUILD = CLR:Colorize("40ff40", "G")
			message.PREPLAYERDELIM = ":"
			if hasLevel then
				message.PLAYERGUILDDELIM = ":"
			end
		end

		if faction then
			local color = GetFactionColor(faction)
			local letter = faction:sub(1, 1) -- "A" or "H"
			message.PLAYERFACTION = color and color:WrapTextInColorCode(letter) or letter
			message.PREPLAYERDELIM = ":"
			if isGuildie then
				message.PLAYERFACTIONDELIM = ":"
			elseif hasLevel then
				message.PLAYERGUILDDELIM = ":"
			end
		end

		-- Add raid subgroup information if needed
		if subgroup and self.db.profile.subgroup and (GetNumGroupMembers() > 0) then
			message.POSTPLAYERDELIM = ":"
			message.PLAYERGROUP = subgroup
		end

		-- Add raid target icon
		if not Prat.IsRetail and self.db.profile.showtargeticon then
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
				local toonName, toonLevel, toonClass = GetToonInfoByBnetID(message.PRESENCE_ID)
				if toonName and self.db.profile.realidname then
					message.PLAYER = toonName
					if level and self.db.profile.level then
						message.PLAYERLEVEL = CLR:Level(tostring(toonLevel), tonumber(toonLevel), nil, nil, "DIFFICULTY")
						message.PREPLAYERDELIM = ":"
					end
				end

				local classColor = Prat.GetClassColor(toonClass, true)
				if classColor then
					message.PLAYER = classColor:WrapTextInColorCode(message.PLAYER)
				end
			elseif self.db.profile.realidcolor == "RANDOM" then
				message.PLAYER = CLR:Random(message.PLAYER, message.PLAYER:lower())
			end

			if self.db.profile.bnetclienticon then
				local client = GetBnetClientByID(message.PRESENCE_ID)
				if client and self.appIcons[client] then
					message.PLAYERCLIENTICON = CreateTextureMarkup(self.appIcons[client], 12, 12, 12, 12, 0, 1, 0, 1) .. " "
				elseif client then
					C_Texture.GetTitleIconTexture(client, 0, function(success, texture)
						if success then
							self.appIcons[client] = texture
						end
					end)
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
			elseif prof_brackets ~= "None" then
				message.pP = CLR:Bracket("[") .. message.pP
				message.Pp = message.Pp .. CLR:Bracket("]")
			end
		end
	end

	--
	-- Prat Event Implementation
	--
	local EVENTS_FOR_RECHECK = {
		["CHAT_MSG_GUILD"] = module.UpdateGF,
		["CHAT_MSG_INSTANCE_CHAT"] = module.UpdateBG,
		["CHAT_MSG_INSTANCE_CHAT_LEADER"] = module.UpdateBG,
		["CHAT_MSG_SYSTEM"] = module.UpdateGF,
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

	function module:Prat_FrameMessage(_, message, frame, event)
		if self.NEEDS_INIT then
			self:UpdateAll()
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

		local _
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

	function module:GetBracketCLR()
		if not self.db.profile.bracketscommoncolor then
			return CLR.COLOR_NONE
		end

		return CLR:GetHexColor(self.db.profile.bracketscolor)
	end

	function module:GetCommonCLR()
		if not self.db.profile.usecommoncolor then
			return CLR.COLOR_NONE
		end

		return CLR:GetHexColor(self.db.profile.color)
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

	local AceTab = LibStub("AceTab-3.0", true)
	function module:TabComplete(enabled)
		if not enabled then
			if AceTab:IsTabCompletionRegistered(PL["tabcomplete_name"]) then
				AceTab:UnregisterTabCompletion(PL["tabcomplete_name"])
			end
			return
		end

		servernames = servernames or Prat:GetModule("ServerNames")

		if not AceTab:IsTabCompletionRegistered(PL["tabcomplete_name"]) then
			AceTab:RegisterTabCompletion(
				PL["tabcomplete_name"],
				nil,
				function(t)
					for name in pairs(self.Classes) do
						table.insert(t, name)
					end
				end,
				function(_, cands)
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
				end
			)
		end
	end

	return
end)
