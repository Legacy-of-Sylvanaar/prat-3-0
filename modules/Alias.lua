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

local ChatEdit_ParseText = _G.ChatEdit_ParseText or _G.ChatFrameEditBoxMixin.ParseText

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("Alias", "AceHook-3.0")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			aliases = {},
			inline = false,
			noclobber = false,

			-- things we won't alias
			wontalias = {
				unalias = 1,
				alias = 1,
				prat = 1,
				script = 1,
				run = 1,
				ace = 1,
				ace2 = 1,
				listaliases = 1,
				quit = 1,
				reload = 1,
				rl = 1,
			},
		}
	})

	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			add = {
				type = "input",
				name = PL["add"],
				desc = PL["add an alias"],
				get = false,
				set = function(info, argstr)
					return info.handler:setAlias(argstr)
				end,
				order = 210,
			},
			del = {
				name = PL["unalias"],
				desc = PL["remove an alias"],
				type = "select",
				values = function(info)
					return info.handler.db.profile.aliases
				end,
				set = function(info, aliastoremove)
					return info.handler:delAlias(aliastoremove)
				end,
				order = 220,
				disabled = function(info)
					return info.handler:NumAliases() == 0
				end
			},
			find = {
				name = PL["findaliases"],
				desc = PL["find aliases matching a given search term"],
				type = 'input',
				set = function(info, q)
					return info.handler:listAliases(q)
				end,
				get = false,
				order = 230,
			},
			list = {
				name = PL["listaliases"],
				desc = PL["list all aliases"],
				type = 'execute',
				func = function(info)
					info.handler:listAliases()
				end,
				order = 240,
			},
			blankheader = {
				name = "",
				order = 499,
				type = 'header',
			},
			--[[ OPTIONS ]] --
			optionsheader = {
				name = PL["Options"],
				desc = PL["Options for altering the behaviour of Alias"],
				type = 'header',
				order = 500,
			},
			inline = {
				name = PL['inline'],
				desc = PL['Expand aliases as you are typing'],
				type = 'toggle',
				order = 510,
			},
			noclobber = {
				name = PL['noclobber'],
				desc = PL["Don't overwrite existing aliases when using /addalias"],
				type = 'toggle',
				order = 520,
			},
		}
	})

	local CLR = Prat.CLR

	local function clralias(text)
		return CLR:Colorize("64ff64", text:lower())
	end

	local function clrexpansion(text)
		return CLR:Colorize("64ffff", text:lower())
	end

	local function clrmodname(text)
		return CLR:Colorize("ff8080", text)
	end

	function module:OnModuleEnable()
		self.Aliases = {}

		table.sort(self.db.profile.aliases)

		for k, v in pairs(self.db.profile.aliases) do
			self.Aliases[k] = v
		end

		self.WontAlias = self.db.profile.wontalias
		for naughtyalias, _ in pairs(self.WontAlias) do
			self.WontAlias[string.lower(naughtyalias)] = 1
		end

		if Prat.IsRetail then
			self.RegisteredAliasCommands = {}
			self:RegisterAllAliasCommands()
		else
			self:RawHook('ChatEdit_HandleChatType', true)
		end

		Prat.RegisterChatCommand("alias", function(argstr)
			return self:setAlias(argstr)
		end)
		Prat.RegisterChatCommand("unalias", function(argstr)
			return self:delAlias(argstr)
		end)
		Prat.RegisterChatCommand("listaliases", function(argstr)
			return self:listAliases(argstr)
		end)
	end

	function module:OnModuleDisable()
		self:UnhookAll()
		self.Aliases = nil
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:GetAliasCommandKey(alias)
		return "PRATALIAS_" .. string.upper(alias)
	end

	function module:RegisterAliasCommand(alias)
		alias = string.lower(alias)

		if self.RegisteredAliasCommands[alias] then
			return
		end

		local key = self:GetAliasCommandKey(alias)

		_G["SLASH_" .. key .. "1"] = "/" .. alias
		SlashCmdList[key] = function(msg)
			module:ExecuteAlias(alias, msg or "")
		end

		self.RegisteredAliasCommands[alias] = true
	end

	function module:RegisterAllAliasCommands()
		if not self.RegisteredAliasCommands then
			self.RegisteredAliasCommands = {}
		end

		for alias in pairs(self.Aliases) do
			self:RegisterAliasCommand(alias)
		end
	end

	function module:splitAliasArgs(str)
		local args = {
			name = "",
			value = "",
		}

		for alias, command in str:gmatch("/?(%w+)%s*[%s=]%s*/?(.-)$") do
			args['name'] = string.lower(alias)
			args['value'] = command or ""
		end
		return args
	end

	function module:checkArgStr(funcname, argstr)
		if argstr == nil then
			self:warnUser(string.format(PL["%s() called with nil argument!"], funcname))
			return false
		end

		if argstr == "" then
			self:warnUser(string.format(PL["%s() called with blank string!"], funcname))
			return false
		end

		return true
	end

	function module:setAlias(argstr)
		if not self:checkArgStr('setAlias', argstr) then
			return false
		end

		local alias = self:splitAliasArgs(argstr)

		-- Check to see if the user is defining an alias or not
		if not alias['value'] or (alias['value'] == "") then
			local name = argstr

			-- Called as: /alias <command> - check for alias called <command> to display
			if self.Aliases[name] then
				-- Alias found; show it :)
				self:showAlias(name)
				return true
			else
				-- No alias found called <command>; tell user
				self:reportUndefinedAlias(name)
			end
		elseif self.WontAlias[string.lower(alias['name'])] then
			-- User is defining an alias called <command>, but it's potentially bad
			self:warnUser(string.format(PL['refusing to alias "/%s" to anything in the interests of Not Buggering Everything Up'], clralias(alias['name'])))
			return false
		elseif self.db.profile.noclobber and self.Aliases[string.lower(alias['name'])] then
			self:warnUser(string.format(PL['noclobber set - skipping new alias: /%s already expands to /%s'], clralias(alias['name']), clrexpansion(alias['value'])))
			return false
		else
			-- It's not listed as bad, so create or update the aliases tables
			-- called as /alias <command> <value> - define alias <command> as <value>
			if self.Aliases[alias['name']] then
				-- Specified alias already exists, warn user and print old setting
				self:warnUser(string.format(PL['overwriting existing alias "/%s" (was aliased to "/%s")'], clralias(alias['name']), clrexpansion(self.Aliases[alias['name']])))
			end

			-- Now (re?)define the alias <command> to <value>
			self.Aliases[alias['name']] = alias['value']
			self.db.profile.aliases[alias['name']] = alias['value']

			table.sort(self.db.profile.aliases)
			table.sort(self.Aliases)

			LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")

			self:warnUser(string.format(PL["/%s aliased to: /%s"], clralias(alias['name']), clrexpansion(alias['value'])))
		end
		if Prat.IsRetail then
			self:RegisterAliasCommand(alias['name'])
		end
	end

	function module:delAlias(aliasname)
		if not self:checkArgStr('delAlias', aliasname) then
			return false
		end

		-- Remove unecessary /s at the beginning of the alias name
		aliasname = aliasname:gsub('^/*', '')

		if not self.Aliases[aliasname] then
			self:warnUser(string.format(PL['alias "/%s" does not exist'], clralias(aliasname)))
			return false
		end

		local oldalias = self.Aliases[aliasname]

		self:warnUser(string.format(PL['deleting alias "/%s" (previously aliased as "/%s")'], clralias(aliasname), clrexpansion(oldalias)))

		self.Aliases[aliasname] = nil
		self.db.profile.aliases[aliasname] = nil

		LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")

		return oldalias
	end

	function module:showAlias(aliasname)
		if not self:checkArgStr('showAlias', aliasname) then
			return false
		end

		-- Check for undefined alias called aliasname
		if not self.Aliases[aliasname] then
			self:warnUser(string.format(PL['tried to show value for alias "%s" but undefined in module.Aliases!'], clralias(aliasname)))
			return false
		end

		-- Everything OK; display value of alias "aliasname"
		self:warnUser(string.format(PL['/%s aliased to "/%s"'], clralias(aliasname), clrexpansion(self.Aliases[aliasname])))

		return true
	end

	function module:listAliases(q)
		if self.Aliases == {} then
			self:warnUser(PL["No aliases have been defined"])
			return false
		end

		table.sort(self.Aliases)

		local count = 0
		for name, _ in pairs(self.Aliases) do
			if not q or (name:match(q)) then
				self:showAlias(name)
				count = count + 1
			end
		end

		self:tellUser(string.format(q and PL['matching aliases found: %d'] or PL['total aliases: %d'], count))
	end

	function module:reportUndefinedAlias(name)
		return self:warnUser(string.format(PL['There is no alias current defined for "%s"'], clralias(name)))
	end

	function module:tellUser(str)
		return module:warnUser(str)
	end

	function module:NumAliases()
		local n = 0
		for _, _ in pairs(self.Aliases) do
			n = n + 1
		end
		return n
	end

	function module:warnUser(str)
		if str == nil then
			str = PL["warnUser() called with nil argument!"]
		elseif str == "" then
			str = PL["warnUser() called with zero length string!"]
		end

		Prat:Print(string.format("%s: %s", clrmodname(self.moduleName), str))
	end

	-- Retail logic
	function module:ExecuteAlias(aliasName, msg)
		-- We cannot perform logic while in lockdown
		if C_ChatInfo.InChatMessagingLockdown() then
			return
		end

		local alias = self.Aliases[string.lower(aliasName)]
		if not alias or alias == "" then
			self:reportUndefinedAlias(aliasName)
			return
		end

		alias = Prat:ReplaceMatches(alias, 'OUTBOUND')
		msg = msg or ""

		-- Extract target command
		local newcmd = strmatch(alias, "^/*([^%s]+)") or ""
		local premsg = strsub(alias, strlen(newcmd) + 2) or ""

		if premsg ~= "" then
			msg = premsg .. (msg ~= "" and (" " .. msg) or "")
		end

		if msg and msg ~= "" then
			local fake = {}
			fake.MESSAGE = msg

			Prat.Addon:ProcessUserEnteredChat(fake)

			msg = fake.MESSAGE
		end

		local cmd = newcmd:upper()

		-- Slash command
		local slashCmd = SlashCmdList[cmd]
		if slashCmd then
			slashCmd(msg)
			return
		end
		-- Chat Type
		local chatCmd = hash_ChatTypeInfoList and hash_ChatTypeInfoList['/'..cmd]
		if chatCmd then
			local editBox = ChatEdit_ChooseBoxForSend()
			if editBox:ProcessChatType(msg, chatCmd, 1) then
				local type = editBox:GetChatType();
				local text = editBox:GetText();
				if strfind(text, "%s*[^%s]+") then
					text = ChatFrameUtil.SubstituteChatMessageBeforeSend(text)
					if type == "WHISPER" then
						local target = editBox:GetTellTarget()
						ChatFrameUtil.SetLastToldTarget(target, type)
						C_ChatInfo.SendChatMessage(text, type, editBox.languageID, target)
					elseif type == "BN_WHISPER" then
						local target = editBox:GetTellTarget();
						local bnetIDAccount = BNet_GetBNetIDAccount(target)
						if bnetIDAccount then
							ChatFrameUtil.SetLastToldTarget(target, type)
							C_BattleNet.SendWhisper(bnetIDAccount, text)
						else
							ChatFrameUtil.DisplaySystemMessageInPrimary(format(BN_UNABLE_TO_RESOLVE_NAME, target))
						end
					elseif type == "CHANNEL" then
						C_ChatInfo.SendChatMessage(text, type, editBox.languageID, editBox:GetChannelTarget())
					else
						C_ChatInfo.SendChatMessage(text, type, editBox.languageID)
					end
				end
				return
			end
		end
		-- Emote
		local emoteCmd = hash_EmoteTokenList and hash_EmoteTokenList['/'..cmd]
		if emoteCmd then
			C_ChatInfo.PerformEmote(emoteCmd, msg)
		end
	end

	-- Classic logic
	function module:ChatEdit_HandleChatType(editBox, msg, command, send)
		command = command or ""
		msg = msg or ""
		local alias = self.Aliases[string.lower(strsub(command, 2))]

		if not alias or alias == "" then
			return self.hooks["ChatEdit_HandleChatType"](editBox, msg, command, send)
		end

		alias = Prat:ReplaceMatches(alias, 'OUTBOUND')

		local newcmd = strmatch(alias, "^/*([^%s]+)") or ""
		local premsg = strsub(alias, strlen(newcmd) + 2) or ""

		if premsg ~= "" then
			msg = premsg .. ' ' .. msg
		end

		command = '/' .. string.upper(newcmd) -- this needs to be upper
		local text = string.lower(command) -- this needs to be lower

		if msg and msg ~= "" then
			local fake = {}
			fake.MESSAGE = msg

			Prat.Addon:ProcessUserEnteredChat(fake)

			msg = fake.MESSAGE
			text = text .. ' ' .. msg
		end

		if (send == 1) then
			editBox:SetText(text)
			ChatEdit_ParseText(editBox, send)
		elseif (self.db.profile.inline) then
			editBox:SetText(text .. ' ')
		end
		return true
	end
end)
