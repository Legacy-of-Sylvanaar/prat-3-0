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

	--@debug@
	PL:AddLocale("enUS", {
		["module_name"] = "Alias",
		["module_desc"] = "Adds the command /alias, which can be used to alias slash commands in a similar way to the Unix alias command.",
		["add"] = true,
		["add an alias"] = true,
		['<command>[ <value>] - alias <command> to be executed as <value>, or return the value of the currently defined alias for <command> if <command> has not been assigned a value. eg: "/alias /examplehello /say hello there" - typing "/examplehello" will now cause your character to say "hello there"; "/alias examplehello" - \\s "/examplehello is aliased to /say hello there" (cmd aliases: /addalias)'] = true,
		["unalias"] = true,
		["remove an alias"] = true,
		['<alias> - remove the alias <alias> (cmd aliases: /delalias, /remalias)'] = true,
		["listaliases"] = true,
		["list all aliases"] = true,
		['findaliases'] = true,
		['find aliases matching a given search term'] = true,
		['<keyword> - finds all aliases matching <keyword> (cmd aliases: /findalias)'] = true,
		['verbose'] = true,
		['Display extra information in the chat frame when commands are dealiased'] = true,
		['inline'] = true,
		['Expand aliases as you are typing'] = true,
		["Options for altering the behaviour of Alias"] = true,
		['Options'] = true,
		['noclobber'] = true,
		["Don't overwrite existing aliases when using /addalias"] = true,
		[' - list all aliases; suPLy <keyword> to search for matching aliases (cmd aliases: /listallaliases)'] = true,
		["%s() called with nil argument!"] = true,
		["%s() called with blank string!"] = true,
		['refusing to alias "/%s" to anything in the interests of Not Buggering Everything Up'] = true,
		['noclobber set - skipping new alias: /%s already expands to /%s'] = true,
		['overwriting existing alias "/%s" (was aliased to "/%s")'] = true,
		["/%s aliased to: /%s"] = true,
		['alias "/%s" does not exist'] = true,
		['deleting alias "/%s" (previously aliased as "/%s")'] = true,
		['tried to show value for alias "%s" but undefined in module.Aliases!'] = true,
		['/%s aliased to "/%s"'] = true,
		["No aliases have been defined"] = true,
		['There is no alias current defined for "%s"'] = true,
		['infinite loop detected for alias /%s - ignoring'] = true,
		['dealiasing command /%s to /%s'] = true,
		['matching aliases found: %d'] = true,
		['total aliases: %d'] = true,
		["warnUser() called with nil argument!"] = true,
		["warnUser() called with zero length string!"] = true,
	})
	--@end-debug@

	-- These Localizations are auto-generated. To help with localization
	-- please go to http://www.wowace.com/projects/prat-3-0/localization/
	--[===[@non-debug@
	do
		local L

		--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("enUS", L)

		--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("itIT", L)

		--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("ptBR", L)

		--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("frFR", L)

		--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("deDE", L)

		--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("koKR", L)

		--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("esMX", L)

		--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("ruRU", L)

		--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("zhCN", L)

		--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("esES", L)

		--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Alias")@
		PL:AddLocale("zhTW", L)
	end
	--@end-non-debug@]===]

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			aliases = {},
			verbose = false,
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
			verbose = {
				name = PL['verbose'],
				desc = PL['Display extra information in the chat frame when commands are dealiased'],
				type = 'toggle',
				order = 530,
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

		if _G.ChatFrameEditBoxBaseMixin and _G.ChatFrameEditBoxBaseMixin.HandleChatType then
			_G.ChatFrame1EditBox.HandleChatType = function(editBox, msg, command, send)
				return self:ChatEdit_HandleChatType(editBox, msg, command, send)
			end
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
		if _G.ChatFrameEditBoxBaseMixin and _G.ChatFrameEditBoxBaseMixin.HandleChatType then
			_G.ChatFrame1EditBox.HandleChatType = _G.ChatFrameEditBoxBaseMixin.HandleChatType
		end
		self.Aliases = nil
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
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

	local fake = {}
	function module:ChatEdit_HandleChatType(editBox, msg, command, send)
		command = command or ""
		msg = msg or ""
		self.processing = true
		local alias = self.Aliases[string.lower(strsub(command, 2))]

		if alias and alias ~= "" then
			if (send == 1) and self.db.profile.verbose then
				self:warnUser(string.format(PL['dealiasing command /%s to /%s'], clralias(strsub(command, 2)), clrexpansion(alias)))
				editBox:AddHistoryLine(editBox:GetText())
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
				fake.MESSAGE = msg

				Prat.Addon:ProcessUserEnteredChat(fake)

				msg = fake.MESSAGE
				text = text .. ' ' .. msg
			end

			if (send == 1) then
				editBox:SetText(text)
				ChatEdit_ParseText(editBox, send)
				return true
			elseif (self.db.profile.inline) then
				editBox:SetText(text .. ' ')
			end
			return true
		end
		if _G.ChatFrameEditBoxBaseMixin and _G.ChatFrameEditBoxBaseMixin.HandleChatType then
			return _G.ChatFrameEditBoxMixin.HandleChatType(editBox, msg, command, send)
		else
			return self.hooks["ChatEdit_HandleChatType"](editBox, msg, command, send)
		end
	end

	return
end)
