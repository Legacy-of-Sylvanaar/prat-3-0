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

local _, private = ...

local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local PL = private:GetLocalizer()

--@debug@
PL:AddLocale("enUS", {
	prat = "Prat",
	["display_name"] = "Display Settings",
	["display_desc"] = "Chat Frame Control and Look",
	["formatting_name"] = "Chat Formatting",
	["formatting_desc"] = "Change the way the lines look and feel",
	["extras_name"] = "Extra Stuff",
	["extras_desc"] = "Msc. Modules",
	["modulecontrol_name"] = "Module Control",
	["modulecontrol_desc"] = "Control the loading and enabling of Prat's modules.",
	["reload_required"] = "This option change may not take full effect until you %s your UI.",
	load_no = "Don't Load",
	load_disabled = "Disabled",
	load_enabled = "Enabled",
	load_desc = "Control the load behavior for this module.",
	unloaded_desc = "Module is not loaded, load it to see description",
	load_disabledonrestart = "Disabled (reload)",
	load_enabledonrestart = "Enabled (reload)",
})
--@end-debug@

-- These Localizations are auto-generated. To help with localization
-- please go to http://www.wowace.com/projects/prat-3-0/localization/


--[===[@non-debug@
do
	local L

	--@localization(locale="enUS", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("enUS",L)

	--@localization(locale="frFR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("frFR",L)

	--@localization(locale="deDE", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("deDE",L)

	--@localization(locale="koKR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("koKR",L)

	--@localization(locale="esMX", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("esMX",L)

	--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("ruRU",L)

	--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("zhCN",L)

	--@localization(locale="esES", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("esES",L)

	--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("zhTW",L)

	--@localization(locale="itIT", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("itIT",L)

	--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="concat", same-key-is-true=true)@
	PL:AddLocale("ptBR",L)
end
--@end-non-debug@]===]

local moduleControlArgs = {}

private.Options = {
	type = "group",
	childGroups = "tab",
	get = "GetValue",
	set = "SetValue",
	args = {
		display = {
			type = "group",
			name = PL["display_name"],
			desc = PL["display_desc"],
			hidden = function() end,
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 1,
		},
		formatting = {
			type = "group",
			name = PL["formatting_name"],
			desc = PL["formatting_desc"],
			hidden = function() end,
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 2,
		},
		extras = {
			type = "group",
			name = PL["extras_name"],
			desc = PL["extras_desc"],
			hidden = function() end,
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 3,
		},
		modulecontrol = {
			type = "group",
			name = PL["modulecontrol_name"],
			desc = PL["modulecontrol_desc"],
			get = "GetValue",
			set = "SetValue",
			args = moduleControlArgs,
			order = 4,
		}
	}
}

private.EnableTasks[#private.EnableTasks + 1] = function(self)
	acr:RegisterOptionsTable(PL.prat, private.Options)
	acr:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.display.name, private.Options.args.display)
	acr:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.formatting.name, private.Options.args.formatting)
	acr:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.extras.name, private.Options.args.extras)
	acr:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.modulecontrol.name, private.Options.args.modulecontrol)
	acr:RegisterOptionsTable("Prat: " .. private.Options.args.profiles.name, private.Options.args.profiles)

	acd:AddToBlizOptions(PL.prat, PL.prat)
	acd:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.display.name, private.Options.args.display.name, PL.prat)
	acd:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.formatting.name, private.Options.args.formatting.name, PL.prat)
	acd:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.extras.name, private.Options.args.extras.name, PL.prat)
	acd:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.modulecontrol.name, private.Options.args.modulecontrol.name, PL.prat)
	acd:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.profiles.name, private.Options.args.profiles.name, PL.prat)

	self:RegisterChatCommand(PL.prat, function()
		private:ToggleOptionsWindow()
	end)
end

do
	local function getModuleFromShortName(shortname)
		for _, v in private.Addon:IterateModules() do
			if v.moduleName == shortname then
				return v
			end
		end
	end

	local lastReloadMessage = 0
	local function PrintReloadMessage()
		local tm = GetTime()
		if tm - lastReloadMessage > 60 then
			private:Print(PL.reload_required:format("reload"))
			lastReloadMessage = tm
		end
	end

	local function setValue(info, b)
		local old = private.db.profile.modules[info[#info]]
		private.db.profile.modules[info[#info]] = b

		if old == 1 or b == 1 then
			PrintReloadMessage()
		end

		local m = getModuleFromShortName(info[#info])
		if not m then
			return
		end

		if b == 2 or b == 1 then
			m.db.profile.on = false
			m:Disable()
		elseif b == 3 then
			m.db.profile.on = true
			m:Enable()
		end
	end

	local function getValue(info)
		return private.db.profile.modules[info[#info]]
	end

	do
		local function getModuleDesc(info)
			local m = getModuleFromShortName(info[#info])
			local controlMsg = "\n\n" .. private.CLR:Colorize("a0a0ff", PL.load_desc)
			if not m or not m:IsEnabled() then
				return PL.unloaded_desc .. controlMsg
			end

			return m:GetDescription() .. controlMsg
		end

		local moduleControlOption = {
			name = function(info)
				return info[#info]
			end,
			desc = getModuleDesc,
			type = "select",
			values = function(info)
				local v = private.db.profile.modules[info[#info]]
				if v == 1 or v > 3 then
					return {
						[1] = "|cffA0A0A0" .. PL.load_no .. "|r",
						[4] = "|cffffff80" .. PL.load_disabledonrestart .. "|r",
						[5] = "|cff80ffff" .. PL.load_enabledonrestart .. "|r"
					}
				else
					return {
						"|cffA0A0A0" .. PL.load_no .. "|r",
						"|cffff8080" .. PL.load_disabled .. "|r",
						"|cff80ff80" .. PL.load_enabled .. "|r"
					}
				end
			end,
			get = getValue,
			set = setValue
		}

		function private:CreateModuleControlOption(name)
			moduleControlArgs[name] = moduleControlOption
		end
	end
end

private.FrameList = {}
private.HookedFrameList = {}

local function updateFrameNames()
	for k, v in pairs(private.HookedFrames) do
		if v.isDocked == 1 or v:IsShown() then
			private.HookedFrameList[k] = v.name
		else
			private.HookedFrameList[k] = nil
		end
	end
	for k, v in pairs(private.Frames) do
		if v.isDocked == 1 or v:IsShown() then
			private.FrameList[k] = v.name
		else
			private.FrameList[k] = nil
		end
	end

	private:UpdateOptions()
end

function private:UpdateOptions()
	acr:NotifyChange("Prat")
end

private.EnableTasks[#private.EnableTasks + 1] = function(self)
	self:SecureHook("FCF_SetWindowName", updateFrameNames)

	FCF_SetWindowName(ChatFrame1, (GetChatWindowInfo(1)), 1)
end

function private:ToggleOptionsWindow()
	if acd.OpenFrames["Prat"] then
		acd:Close("Prat")
	else
		acd:Open("Prat")
	end
end

Prat_ToggleOptionsWindow = private.ToggleOptionsWindow
