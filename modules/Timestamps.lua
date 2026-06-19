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
	local module = Prat:NewModule("Timestamps", "AceHook-3.0")
	local PL = module.PL

	module.pluginopts = {}

	-- Chatter (Antiarc)
	local TIME_FORMATS = {
		["%I:%M:%S %p"] = PL["HH:MM:SS AM (12-hour)"],
		["%I:%M:%S"] = PL["HH:MM:SS (12-hour)"],
		["%X"] = PL["HH:MM:SS (24-hour)"],
		["%I:%M %p"] = PL["HH:MM AM (12-hour)"],
		["%I:%M"] = PL["HH:MM (12-hour)"],
		["%H:%M"] = PL["HH:MM (24-hour)"],
		["%M:%S"] = PL["MM:SS"],
	}
	local DATE_FORMATS = {
		[""] = PL["None"],
		["%d/%m/%y"] = PL["dd/mm/yy"],
		["%m/%d/%y"] = PL["mm/dd/yy"],
		["%d/%m"] = PL["dd/mm"],
		["%m/%d"] = PL["mm/dd"],
	}

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			show = { ["*"] = true },
			formatcode = "%X",
			formatdate = "",
			formatpre = "[",
			formatpost = "]",
			["timestampcolor"] = {
				["b"] = 0.592156862745098,
				["g"] = 0.592156862745098,
				["r"] = 0.592156862745098,
				a = 1
			},
			colortimestamp = true,
			space = true,
			localtime = true,
			twocolumn = false,
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["Timestamps"],
		desc = PL["Chat window timestamp options."],
		type = "group",
		plugins = module.pluginopts,
		args = {
			show = {
				name = PL["Show Timestamp"],
				desc = PL["Toggle showing timestamp for each window."],
				type = "multiselect",
				order = 120,
				values = Prat.HookedFrameList,
				get = "GetSubValue",
				set = "SetSubValue"
			},
			helpheader = {
				name = PL["Timestamp Text Format"],
				type = "header",
				order = 129,
			},
			formatpre = {
				name = PL["Pre-Timestamp"],
				desc = PL["Pre-Timestamp"],
				type = "input",
				order = 130,
				usage = "<string>",
			},
			formatcode = {
				name = PL["Format All Timestamps"],
				desc = PL["Set the timestamp format"],
				type = "select",
				order = 131,
				values = TIME_FORMATS,
			},
			formatpost = {
				name = PL["Post-Timestamp"],
				desc = PL["Post-Timestamp"],
				type = "input",
				order = 145,
				usage = "<string>",
			},
			formatdate = {
				name = PL["Date Format"],
				desc = PL["Set the format for the day/month/year"],
				type = "select",
				order = 150,
				values = DATE_FORMATS,
			},
			colortimestamp = {
				name = PL["colortimestamp_name"],
				desc = PL["colortimestamp_desc"],
				type = "toggle",
				get = function(info)
					return info.handler:GetValue(info)
				end,
				order = 171,
			},
			localtime = {
				name = PL["localtime_name"],
				desc = PL["localtime_desc"],
				type = "toggle",
				order = 171,
			},
			space = {
				name = PL["space_name"],
				desc = PL["space_desc"],
				type = "toggle",
				order = 171,
			},
			otherheader = {
				name = PL["Other Formatting Options"],
				type = "header",
				order = 170,
			},
			timestampcolor = {
				name = PL["Set Timestamp Color"],
				desc = PL["Sets the color of the timestamp."],
				type = "color",
				order = 181,
				get = "GetColorValue",
				set = "SetColorValue",
				disabled = "IsTimestampPlain",
			},
		},
	})

	Prat:SetModuleInit(module, function(self)
		-- Disable blizz timestamps if possible
		local proxy = {}
		if Prat.IsClassic then
			proxy.CHAT_TIMESTAMP_FORMAT = false -- nil would defer to __index
		else
			proxy.GetChatTimestampFormat = function()
			end
		end
		local CF_MEH_env = setmetatable(proxy, { __index = _G, __newindex = _G })
		if _G.ChatFrameMixin and _G.ChatFrameMixin.MessageEventHandler then
			setfenv(_G.ChatFrameMixin.MessageEventHandler, CF_MEH_env)
		elseif _G["ChatFrame_MessageEventHandler"] and issecurevariable("ChatFrame_MessageEventHandler") then
			setfenv(_G.ChatFrame_MessageEventHandler, CF_MEH_env)
		else
			self:Output("Could not install hook")
		end

		for _, v in pairs(Prat.HookedFrames) do
			self:SecureHook(v, "AddMessage")
		end
	end)

	function module:OnModuleEnable()
		for _, v in pairs(Prat.HookedFrames) do
			if not self:IsHooked(v, "AddMessage") then
				self:SecureHook(v, "AddMessage")
			end
		end
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
	end

	function module:OnModuleDisable()
		for _, v in pairs(Prat.HookedFrames) do
			if self:IsHooked(v, "AddMessage") then
				self:Unhook(v, "AddMessage")
			end
		end
	end

	function module:GetDescription()
		return PL["Chat window timestamp options."]
	end

	function module:Prat_FramesUpdated(_, _, chatFrame)
		if not self:IsHooked(chatFrame, "AddMessage") then
			self:SecureHook(chatFrame, "AddMessage")
		end
	end

	function module:Prat_FramesRemoved(_, _, chatFrame)
		if self:IsHooked(chatFrame, "AddMessage") then
			self:Unhook(chatFrame, "AddMessage")
		end
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	local lastParsed
	function module:AddMessage(frame)
		if self.db.profile.on and self.db.profile.show and self.db.profile.show[frame:GetName()] and not Prat.loading then
			local entry = frame.historyBuffer:GetEntryAtIndex(1)
			if lastParsed == entry then
				return
			end
			entry.message = self:InsertTimestamp(entry.message, frame)
			lastParsed = entry
		end
	end

	function module:IsTimestampPlain()
		return not self.db.profile.colortimestamp
	end

	local function Timestamp(text)
		if not module:IsTimestampPlain() then
			return Prat.CLR:Colorize(module.db.profile.timestampcolor, text)
		end
		return text
	end

	function module:PlainTimestampNotAllowed()
		return false
	end

	function module:InsertTimestamp(text, cf)
		if type(text) == "string" then
			local db = self.db.profile
			local space = db.space
			local code = db.formatcode
			if db.formatdate ~= "" then
				code = db.formatdate .. " " .. code
			end
			local fmt = db.formatpre .. code .. db.formatpost

			if cf and cf:GetJustifyH() == "RIGHT" then
				return text .. (space and " " or "") .. Timestamp(self:GetTime(fmt))
			end
			return Timestamp(self:GetTime(fmt)) .. (space and " " or "") .. text
		end

		return text
	end

	function module:GetTime(format)
		if self.db.profile.localtime then
			return date(format)
		end
		return date(format, GetServerTime())
	end

	return
end) -- Prat:AddModuleToLoad
