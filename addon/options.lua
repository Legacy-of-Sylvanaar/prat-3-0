local _, private = ...

local pairs = pairs

local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local PL = private:GetLocalizer()
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
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 1,
		},
		formatting = {
			type = "group",
			name = PL["formatting_name"],
			desc = PL["formatting_desc"],
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 2,
		},
		extras = {
			type = "group",
			name = PL["extras_name"],
			desc = PL["extras_desc"],
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

	local function setValue(info, b)
		private.db.profile.modules[info[#info]] = b

		local m = getModuleFromShortName(info[#info])
		if not m then
			return
		end

		if b == 2 then
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
			if not m then
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
			values = function()
				return {
					[2] = "|cffff8080" .. PL.load_disabled .. "|r",
					[3] = "|cff80ff80" .. PL.load_enabled .. "|r"
				}
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
