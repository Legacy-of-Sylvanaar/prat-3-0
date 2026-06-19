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
	local module = Prat:NewModule("ServerNames")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			space = true,
			colon = true,
			autoabbreviate = true,
			hide = false,
			chanSave = {},
			serveropts = {
				["*"] = {
					replace = false,
					customcolor = false,
					shortname = "",
					color = {
						r = 0.65,
						g = 0.65,
						b = 0.65,
						a = 1,
					},
				},
			},
			randomclr = true,
		}
	})

	local serverPlugins = { servers = {} }

	Prat:SetModuleOptions(module.name, {
		name = PL["ServerNames"],
		desc = PL["Server name abbreviation options."],
		type = "group",
		plugins = serverPlugins,
		args = {
			hide = {
				type = "toggle",
				name = PL["hide_name"],
				desc = PL["hide_desc"],
			},
			autoabbreviate = {
				type = "toggle",
				name = PL["autoabbreviate_name"],
				desc = PL["autoabbreviate_desc"],
				order = 250,
				disabled = function(info)
					return info.handler.db.profile.hide
				end,
			},
			randomclr = {
				type = "toggle",
				name = PL["randomclr_name"],
				desc = PL["randomclr_desc"],
				order = 250,
				disabled = function(info)
					return info.handler.db.profile.hide
				end,
			}
		}
	})

	-- build the options menu using prat templates
	--module.toggleOptions = { optsep_sep = 240, randomclr = 250}
	--module.toggleOptions = { optsep_sep = 229, space = 230, colon = 240 }

	--local server_tags = {
	--    ["Normal"] = "(E)",
	--    ["PvP"] = "(P)",
	--    ["RP"] = "(R)",
	--    ["RP-PvP"] = "(PR)",
	--}
	--
	--local server_desctags = {
	--    ["Normal"] = "PvE",
	--    ["PvP"] = "PvP",
	--    ["RP"] = "RP",
	--    ["RP-PvP"] = "RPPvP",
	--}

	local CLR = Prat.CLR
	local function Server(server, text)
		return CLR:Colorize(module:GetServerCLR(server), text or server)
	end

	local KeyToFullNameMap = {}
	local FullNameToKeyMap = {}

	-- Get the key for the server specified, safe to pass this nil and "", if no key then it returns nil
	function module:GetServerKey(server)
		local key = FullNameToKeyMap[server]

		if key == nil then
			self:AddServer(server)

			key = FullNameToKeyMap[server]
		end

		return key
	end

	function module:AddServer(server)
		if server and strlen(server) > 0 then
			local key = server:gsub(" ", ""):lower()
			FullNameToKeyMap[server] = key
			KeyToFullNameMap[key] = KeyToFullNameMap[key] or server
		end
	end

	function module:GetServerSettings(serverKey)
		local opts = self.db.profile.serveropts[serverKey]
		if not opts then
			self.db.profile.serveropts[serverKey] = {}
			opts = self.db.profile.serveropts[serverKey]
		end

		return opts
	end

	--[[------------------------------------------------
		Module Event Functions
	------------------------------------------------]] --
	function module:OnModuleEnable()
		Prat.RegisterChatEvent(self, "Prat_PreAddMessage")
	end

	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:GetDescription()
		return PL["Server name abbreviation options."]
	end

	-- replace text using prat event implementation
	function module:Prat_PreAddMessage(_, m)
		local serverKey = self:GetServerKey(m.SERVER)
		local opts = serverKey and self:GetServerSettings(serverKey)

		if opts and opts.replace then
			m.SERVER = opts.shortname
		end

		if self.db.profile.hide then
			m.SERVER = ""
		end

		if m.SERVER and strlen(m.SERVER) > 0 then
			m.SERVER = self:FormatServer(m.SERVER, serverKey)
		end

		if not (m.SERVER and strlen(m.SERVER) > 0) then
			local s = Prat.SplitMessage
			s.SERVER, s.sS, s.Ss = "", "", ""
		end
	end

	function module:FormatServer(server, serverKey)
		if server == nil then
			server = KeyToFullNameMap[serverKey]
		elseif serverKey == nil then
			serverKey = self:GetServerKey(server)
		end

		if server == nil or serverKey == nil then
			return
		end

		if self.db.profile.autoabbreviate then
			server = server:match("^([%a\192-\255]?[\128-\191]*[%a\192-\255]?[\128-\191]*[%a\192-\255]?[\128-\191]*)")
		end

		return Server(serverKey, server)
	end

	local serverHashes = setmetatable({}, {
		__mode = "kv",
		__index = function(t, k)
			t[k] = CLR:GetHashColor(k)
			return
			t[k]
		end
	})
	local serverColors = setmetatable({}, {
		__mode = "kv",
		__index = function(t, k)
			t[k] = CLR:GetHexColor(k)
			return
			t[k]
		end
	})

	function module:GetServerCLR(server)
		local serverKey = self:GetServerKey(server)

		if serverKey then
			local opts = self:GetServerSettings(serverKey)

			if opts and opts.customcolor then
				return serverColors[opts.color]
			elseif self.db.profile.randomclr then
				return serverHashes[serverKey]
			end
		end

		return CLR.COLOR_NONE
	end
	return
end) -- Prat:AddModuleToLoad
