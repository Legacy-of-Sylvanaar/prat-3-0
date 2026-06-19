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
	local module = Prat:NewModule("ChannelNames", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
	local PL = module.PL

	-- order to show channels
	local orderMap = {
		"say",
		"whisper",
		"whisperincome",
		"yell",
		"party",
		"partyleader",
		"guild",
		"officer",
		"raid",
		"raidleader",
		"raidwarning",
		"instance",
		"instanceleader",
		"bnwhisper",
		"bnwhisperincome",
		"bnconversation",
	}

	if not CHAT_MSG_BN_WHISPER_INFORM then
		CHAT_MSG_BN_WHISPER_INFORM = "Outgoing Real ID Whisper";
	end

	if not CHAT_MSG_INSTANCE_CHAT then
		CHAT_MSG_INSTANCE_CHAT = INSTANCE_CHAT_MESSAGE;
	end

	if not CHAT_MSG_INSTANCE_CHAT_LEADER then
		CHAT_MSG_INSTANCE_CHAT_LEADER = INSTANCE_CHAT_LEADER;
	end

	-- Look Up Our Settings Key event..message.CHANNUM
	local eventMap = {
		CHAT_MSG_CHANNEL1 = "channel1",
		CHAT_MSG_CHANNEL2 = "channel2",
		CHAT_MSG_CHANNEL3 = "channel3",
		CHAT_MSG_CHANNEL4 = "channel4",
		CHAT_MSG_CHANNEL5 = "channel5",
		CHAT_MSG_CHANNEL6 = "channel6",
		CHAT_MSG_CHANNEL7 = "channel7",
		CHAT_MSG_CHANNEL8 = "channel8",
		CHAT_MSG_CHANNEL9 = "channel9",
		CHAT_MSG_SAY = "say",
		CHAT_MSG_GUILD = "guild",
		CHAT_MSG_WHISPER = "whisperincome",
		CHAT_MSG_WHISPER_INFORM = "whisper",
		CHAT_MSG_BN_WHISPER = "bnwhisperincome",
		CHAT_MSG_BN_WHISPER_INFORM = "bnwhisper",
		CHAT_MSG_YELL = "yell",
		CHAT_MSG_PARTY = "party",
		CHAT_MSG_PARTY_LEADER = "partyleader",
		CHAT_MSG_OFFICER = "officer",
		CHAT_MSG_RAID = "raid",
		CHAT_MSG_RAID_LEADER = "raidleader",
		CHAT_MSG_RAID_WARNING = "raidwarning",
		CHAT_MSG_INSTANCE_CHAT = "instance",
		CHAT_MSG_INSTANCE_CHAT_LEADER = "instanceleader",
		CHAT_MSG_BN_CONVERSATION = "bnconversation"
	}

	local CLR = Prat.CLR

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			space = true,
			colon = true,
			chanlink = true,
			replace = {
				say = true,
				whisper = true,
				whisperincome = true,
				bnwhisper = true,
				bnwhisperincome = true,
				yell = true,
				party = true,
				partyleader = true,
				guild = true,
				officer = true,
				raid = true,
				raidleader = true,
				raidwarning = true,
				instance = true,
				instanceleader = true,
				channel1 = true,
				channel2 = true,
				channel3 = true,
				channel4 = true,
				channel5 = true,
				channel6 = true,
				channel7 = true,
				channel8 = true,
				channel9 = true,
				channel10 = true,
			},
			chanSave = {},
			shortnames = GetLocale() == "zhCN" and {
				say = "[说]",
				whisper = "[密]",
				whisperincome = "[收]",
				yell = "[喊]",
				party = "[队]",
				guild = "[会]",
				officer = "[管]",
				raid = "[团]",
				raidleader = "[酱]",
				raidwarning = "[警]",
				instance = "[战]",
				instanceleader = "[蟀]",
				channel1 = "[1]",
				channel2 = "[2]",
				channel3 = "[3]",
				channel4 = "[4]",
				channel5 = "[5]",
				channel6 = "[6]",
				channel7 = "[7]",
				channel8 = "[8]",
				channel9 = "[9]",
				channel10 = "[10]",
			} or GetLocale() == "zhTW" and {
				say = "[說]",
				whisper = "[密]",
				whisperincome = "[聽]",
				yell = "[喊]",
				party = "[隊]",
				guild = "[會]",
				officer = "[官]",
				raid = "[團]",
				raidleader = "[團長]",
				raidwarning = "[警]",
				instance = "[戰]",
				instanceleader = "[戰領]",
				channel1 = "[1]",
				channel2 = "[2]",
				channel3 = "[3]",
				channel4 = "[4]",
				channel5 = "[5]",
				channel6 = "[6]",
				channel7 = "[7]",
				channel8 = "[8]",
				channel9 = "[9]",
				channel10 = "[10]",
			} or GetLocale() == "koKR" and {
				say = "[대화]",
				whisper = "[귓말]",
				whisperincome = "[받은귓말]",
				yell = "[외침]",
				party = "[파티]",
				guild = "[길드]",
				officer = "[오피서]",
				raid = "[공대]",
				raidleader = "[공대장]",
				raidwarning = "[공대경보]",
				instance = "[전장]",
				instanceleader = "[전투대장]",
				channel1 = "[1]",
				channel2 = "[2]",
				channel3 = "[3]",
				channel4 = "[4]",
				channel5 = "[5]",
				channel6 = "[6]",
				channel7 = "[7]",
				channel8 = "[8]",
				channel9 = "[9]",
				channel10 = "[10]",
			} or {
				say = "[S]",
				whisper = "[W To]",
				whisperincome = "[W From]",
				bnwhisper = "[W To]",
				bnwhisperincome = "[W From]",
				yell = "[Y]",
				party = "[P]",
				partyleader = "[PL]",
				guild = "[G]",
				officer = "[O]",
				raid = "[R]",
				raidleader = "[RL]",
				raidwarning = "[RW]",
				instance = "[I]",
				instanceleader = "[IL]",
				channel1 = "[1]",
				channel2 = "[2]",
				channel3 = "[3]",
				channel4 = "[4]",
				channel5 = "[5]",
				channel6 = "[6]",
				channel7 = "[7]",
				channel8 = "[8]",
				channel9 = "[9]",
				channel10 = "[10]",
			},
			nickname = {}
		}
	})

	local eventPlugins = { types = {}, channels = {} }
	local nickPlugins = { nicks = {} }

	--- module.toggleOptions = { optsep227_sep = 227, optsep_sep = 229, space = 230, colon = 240, sep241_sep = 241, chanlink = 242 }
	Prat:SetModuleOptions(module.name, {
		name = PL["ChannelNames"],
		desc = PL["Channel name abbreviation options."],
		type = "group",
		childGroups = "tab",
		args = {
			etypes = {
				name = PL["ChannelNames"],
				desc = PL["Channel name abbreviation options."],
				type = "group",
				order = 1,
				plugins = eventPlugins,
				args = {}
			},
			ntypes = {
				name = PL["channelnick_name"],
				desc = PL["channelnick_desc"],
				order = 2,
				type = "group",
				plugins = nickPlugins,
				args = {}
			},
			ctypes = {
				name = PL["otheropts_name"],
				desc = PL["otheropts_desc"],
				order = 3,
				type = "group",
				args = {
					space = {
						name = PL["space_name"],
						desc = PL["space_desc"],
						type = "toggle",
					},
					colon = {
						name = PL["colon_name"],
						desc = PL["colon_desc"],
						type = "toggle",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		Module Event Functions
	------------------------------------------------]] --
	function module:OnModuleEnable()
		self:BuildChannelOptions()
		self:RegisterEvent("UPDATE_CHAT_COLOR", "RefreshOptions")
		self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")

		Prat.RegisterChatEvent(self, "Prat_FrameMessage")

		Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE")
		Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE_USER")
		Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_LEAVE")
		Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_JOIN")
	end

	function module:OnModuleDisable()
		self:UnregisterAllEvents()
		Prat.UnregisterAllChatEvents(self)
	end

	function module:GetDescription()
		return PL["Channel name abbreviation options."]
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:CHAT_MSG_CHANNEL_NOTICE()
		self:BuildChannelOptions()
		self:RefreshOptions()
	end

	function module:RefreshOptions()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
	end

	function module:AddNickname(info, name)
		self.db.profile.nickname[info[#info - 1]] = name
	end

	function module:RemoveNickname(info)
		if self.db.profile.nickname[info[#info - 1]] then
			self.db.profile.nickname[info[#info - 1]] = nil
		end
	end

	function module:GetNickname(info)
		return self.db.profile.nickname[info[#info - 1]]
	end

	function module:NotGetNickname(info)
		return (self:GetNickname(info) == nil) and true or false
	end

	-- replace text using prat event implementation
	function module:Prat_FrameMessage(_, message, _, event)
		if event == "CHAT_MSG_CHANNEL_JOIN" or event == "CHAT_MSG_CHANNEL_LEAVE" then
			message.MESSAGE = message.ORG.TYPEPOSTFIX:trim()
			message.ORG.TYPEPOSTFIX = " "
		end

		if event == "CHAT_MSG_CHANNEL_NOTICE" or event == "CHAT_MSG_CHANNEL_NOTICE_USER" or event == "CHAT_MSG_CHANNEL_JOIN" or event == "CHAT_MSG_CHANNEL_LEAVE" then
			event = "CHAT_MSG_CHANNEL"
		end

		local cfg

		if event == "CHAT_MSG_BN_CONVERSATION" then
			cfg = eventMap[event]
		else
			cfg = eventMap[event .. (message.CHANNELNUM or "")]
		end

		if (not issecretvalue or not issecretvalue(message.CHANNEL)) and self.db.profile.nickname[message.CHANNEL] then
			message.CHANNEL = self.db.profile.nickname[message.CHANNEL]
			if message.CHANNEL:sub(1, 1) == "#" then
				message.CHANNEL = message.CHANNEL:sub(2)
			else
				message.CHANNELNUM, message.CC = "", ""
			end
		elseif self.db.profile.replace[cfg] then
			message.cC, message.CHANNELNUM, message.CC, message.CHANNEL, message.Cc = "", "", "", "", ""
			local space = self.db.profile.space and self.db.profile.shortnames[cfg] and self.db.profile.shortnames[cfg] ~= "" and " " or ""
			local colon = ''
			if self.db.profile.colon then
				if message.PLAYER then
					colon = ":"
				elseif message.PLAYERLINK:len() > 0 and message.MESSAGE:len() > 0 then
					colon = ":"
				end
			end
			message.TYPEPREFIX = self.db.profile.shortnames[cfg] or ""

			if message.TYPEPREFIX:len() == 0 then
				message.nN, message.NN, message.Nn, message.CHANLINK = "", "", "", ""
			end

			message.TYPEPREFIX = message.TYPEPREFIX .. space

			if message.PLAYER or message.PLAYERLINK:len() > 0 then
				message.TYPEPOSTFIX = colon .. "\32"
			else
				message.TYPEPOSTFIX = ""
			end
		end
	end

	--[[------------------------------------------------
		Menu Builder Functions
	------------------------------------------------]] --
	function module:BuildChannelOptions()
		for _, v in ipairs(orderMap) do
			self:CreateTypeOption(eventPlugins["types"], v)
		end
		for i = 1, 9 do
			self:CreateChannelOption(eventPlugins["channels"], "channel" .. i, i)
		end

		local t = Prat.GetChannelTable()
		for _, v in pairs(t) do
			if type(v) == "string" then
				self:CreateChanNickOption(nickPlugins["nicks"], v)
			end
		end
	end

	function module:CreateChanNickOption(args, keyname)
		local text = keyname
		local name = keyname
		args[name] = args[name] or {
			name = text,
			desc = string.format(PL["%s settings."], text),
			type = "group",
			order = 228,
			args = {
				addnick = {
					name = PL["Add Channel Abbreviation"],
					desc = PL["addnick_desc"],
					type = "input",
					order = 140,
					usage = "<string>",
					get = "GetNickname",
					set = "AddNickname",
				},
				removenick = {
					name = PL["Remove Channel Abbreviation"],
					desc = PL["Removes an an abbreviated channel name."],
					type = "execute",
					order = 150,
					func = "RemoveNickname",
					disabled = "NotGetNickname";
				},
			}
		}
	end

	function module:GetChanOptValue(info)
		return self.db.profile[info[#info]][info[#info - 1]]
	end

	function module:SetChanOptValue(info, val)
		self.db.profile[info[#info]][info[#info - 1]] = val
	end

	do
		local function revLookup(keyname)
			for k, v in pairs(eventMap) do
				if keyname == v then
					return k
				end
			end
		end

		local function GetChatCLR(name)
			if name == nil then
				return CLR.COLOR_NONE
			end

			local type = strsub(name, 10);
			local info = ChatTypeInfo[type];
			if not info then
				return CLR.COLOR_NONE
			end
			return CLR:GetHexColor(info)
		end

		local function ChatType(text, type)
			return CLR:Colorize(GetChatCLR(type), text)
		end

		local optionGroup = {
			type = "group",
			name = function(info)
				return ChatType(_G[revLookup(info[#info])], revLookup(info[#info]))
			end,
			desc = function(info)
				return (PL["%s settings."]):format(_G[revLookup(info[#info])])
			end,
			get = "GetChanOptValue",
			set = "SetChanOptValue",
			args = {
				shortnames = {
					name = function(info)
						return ChatType(_G[revLookup(info[#info - 1])], revLookup(info[#info - 1]))
					end,
					desc = function(info)
						return (PL["Use a custom replacement for the chat %s text."]):format(ChatType(_G[revLookup(info[#info - 1])], revLookup(info[#info - 1])))
					end,
					order = 1,
					type = "input",
					usage = PL["<string>"],
				},
				replace = {
					name = PL["Replace"],
					desc = PL["Toggle replacing this channel."],
					type = "toggle",
					order = 3,
				},
			}
		}

		local optionGroupChan = {
			type = "group",
			name = function(info)
				return ChatType((PL["Channel %d"]):format(info[#info]:sub(-1)), revLookup(info[#info]))
			end,
			desc = function(info)
				return (PL["%s settings."]):format(ChatType((PL["Channel %d"]):format(info[#info]:sub(-1)), revLookup(info[#info])))
			end,
			get = "GetChanOptValue",
			set = "SetChanOptValue",
			order = function(info)
				return 200 + tonumber(info[#info]:sub(-1))
			end,
			args = {
				shortnames = {
					name = function(info)
						return ChatType((PL["Channel %d"]):format(info[#info - 1]:sub(-1)), revLookup(info[#info - 1]))
					end,
					desc = function(info)
						return (PL["Use a custom replacement for the chat %s text."]):format(ChatType((PL["Channel %d"]):format(info[#info - 1]:sub(-1)), revLookup(info[#info - 1])))
					end,
					order = 1,
					type = "input",
					usage = PL["<string>"],
				},
				replace = {
					name = PL["Replace"],
					desc = PL["Toggle replacing this channel."],
					type = "toggle",
					order = 3,
				},
			}
		}

		function module:CreateTypeOption(args, keyname)
			if not args[keyname] then
				args[keyname] = optionGroup
			end
		end

		function module:CreateChannelOption(args, keyname)
			if not args[keyname] then
				args[keyname] = optionGroupChan
			end
		end
	end

	return
end)
