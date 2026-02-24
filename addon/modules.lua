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

local function NOP() end

do
	local function AddLocale(self, locale, L)
		if locale == "enUS" or GetLocale() == locale then
			for k, v in pairs(L) do
				if type(v) == "table" then
					-- Do nothing
				elseif v == true then
					self[k] = k
				else
					self[k] = v
				end
			end
		end
	end

	function private:GetLocalizer()
		return setmetatable({
			AddLocale = AddLocale,
		}, {
			__index = function(_, k)
				error("Locale key " .. tostring(k) .. " is not provided.")
			end
		})
	end
end

do
	local module_defaults = {}
	function private:SetModuleDefaults(module, defaults)
		module_defaults[type(module) == "table" and module.name or module] = defaults
	end

	function private:GetModuleDefaults(module)
		return module_defaults[type(module) == "table" and module.name or module]
	end

	local module_init = {}

	function private:SetModuleInit(module, init)
		module_init[type(module) == "table" and module.name or module or "null"] = init
	end

	local function GetModuleInit(module)
		return module_init[type(module) == "table" and module.name or module or "null"]
	end

	local sectionlist = {
		--display
		["Prat_ChannelColorMemory"] = "display",
		["Prat_ChannelSticky"] = "display",
		["Prat_ChatFrames"] = "display",
		["Prat_Fading"] = "display",
		["Prat_History"] = "display",
		["Prat_Frames"] = "display",
		["Prat_Editbox"] = "display",
		["Prat_Paragraph"] = "display",
		["Prat_Scroll"] = "display",
		["Prat_Clear"] = "display",
		["Prat_Font"] = "display",
		["Prat_ChatTabs"] = "display",
		["Prat_Buttons"] = "display",
		["Prat_OriginalButtons"] = "display",

		--formatting
		["Prat_ChannelNames"] = "formatting",
		["Prat_PlayerNames"] = "formatting",
		["Prat_ServerNames"] = "formatting",
		["Prat_Substitutions"] = "formatting",
		["Prat_Timestamps"] = "formatting",
		["Prat_UrlCopy"] = "formatting",

		--extras
		["Prat_AddonMsgs"] = "extras",
		["Prat_EventNames"] = "extras",
		["Prat_PopupMessage"] = "extras",
		["Prat_Sounds"] = "extras",
	}
	setmetatable(sectionlist, {
		__index = function()
			return "extras"
		end
	})

	local function onInit(self)
		if private.db.profile.modules[self.moduleName] == 1 then
			return
		end

		local defaults, opts, init
		defaults, module_defaults[self.name] = module_defaults[self.name] or {}
		self.db = private.db:RegisterNamespace(self.name, defaults)

		init = GetModuleInit(self)
		if init then
			init(self)
			private:SetModuleInit(self, nil)
		end
		opts = private:GetModuleOptions(self.name)
		if opts then
			opts.handler = self
			opts.disabled = "IsDisabled"
			private.Options.args[sectionlist[self.name]].args[self.name], opts = opts
			private:SetModuleOptions(self, self.name, nil)
		end

		local v = private.db.profile.modules[self.moduleName]
		if v == 4 or v == 5 then
			self.db.profile.on = (v == 5) and true or false
			private.db.profile.modules[self.moduleName] = v - 2
		else
			private.db.profile.modules[self.moduleName] = self.db.profile.on and 3 or 2
		end
		self:SetEnabledState(self.db.profile.on)
	end

	local function onEnable(self)
		if private.db.profile.modules[self.moduleName] == 1 then
			return
		end

		local pats = private:GetModulePatterns(self)
		if pats then
			for _, v in pairs(pats) do
				if v then
					private:RegisterPattern(v, self.name)
				end
			end
		end

		self:OnModuleEnable()
	end

	local function onDisable(self)
		if private.db.profile.modules[self.moduleName] == 1 then
			return
		end

		private:UnregisterAllPatterns(self.name)
		self:OnModuleDisable()
		private.UnregisterAllChatEvents(self)
	end

	local function setValue(self, info, b)
		self.db.profile[info[#info]] = b
		self:OnValueChanged(info, b)
	end

	local function getValue(self, info)
		return self.db.profile[info[#info]]
	end

	local function getSubValue(self, info, val)
		return self.db.profile[info[#info]][val]
	end

	local function setSubValue(self, info, val, b)
		self.db.profile[info[#info]][val] = b
		self:OnSubValueChanged(info, val, b)
	end

	local defclr = {
		r = 1,
		b = 1,
		g = 1,
		a = 1
	}
	local function getColorValue(self, info)
		local c = self.db.profile[info[#info]] or defclr
		return c.r, c.g, c.b, c.a
	end

	local function setColorValue(self, info, r, g, b, a)
		local c = self.db.profile[info[#info]] or defclr
		c.r, c.g, c.b, c.a = r, g, b, a
		self:OnColorValueChanged(info, r, g, b, a)
	end

	local function outputText(self, ...)
		local frame, message, r, g, b = ...

		if type(frame) ~= "table" or type(frame.AddMessage) ~= "function" then
			frame, message, r, g, b = _G.DEFAULT_CHAT_FRAME, ...
		end

		if not message then
			return
		end

		local header = "|cffffff78" .. tostring(Prat) .. "|r (|cff80ff80" .. self.moduleName .. "|r) : %s"

		frame:AddMessage(header:format(message), r, g, b)
	end

	local function isDisabled(self)
		return not self:IsEnabled()
	end

	local function getDescription(self)
		return self.PL.module_desc
	end

	local prototype = {
		OnEnable = onEnable,
		OnDisable = onDisable,
		OnInitialize = onInit,
		OnModuleEnable = NOP,
		OnModuleDisable = NOP,
		OnModuleInit = NOP,
		OnValueChanged = NOP,
		OnSubValueChanged = NOP,
		OnColorValueChanged = NOP,
		GetValue = getValue,
		SetValue = setValue,
		GetSubValue = getSubValue,
		SetSubValue = setSubValue,
		GetColorValue = getColorValue,
		SetColorValue = setColorValue,
		IsDisabled = isDisabled,
		GetDescription = getDescription,
		Output = outputText,

		-- Standard fields
		section = "extras",
	}

	function private:NewModule(name, ...)
		local module = private.Addon:NewModule(name, prototype, ...)
		module.PL = private:GetLocalizer()

		private:CreateModuleControlOption(name)
		if private.db.profile.modules[module.moduleName] == 1 then
			module:Disable()
		end

		return module
	end

	function private:GetModule(name, ...)
		local module = private.Addon:GetModule(name, ...)
		if not module or private.db.profile.modules[module.moduleName] == 1 then
			return
		end
		return module
	end
end

do
	local module_options = {}

	function private:SetModuleOptions( module, options)
		module_options[type(module) == "table" and module.name or module or "null"] = options
	end

	function private:GetModuleOptions(module)
		return module_options[type(module) == "table" and module.name or module or "null"]
	end
end

do
	local module_patterns = {}

	function private:SetModulePatterns(module, patterns)
		module_patterns[type(module) == "table" and module.name or module or "null"] = patterns
	end

	function private:GetModulePatterns(module)
		return module_patterns[type(module) == "table" and module.name or module or "null"]
	end
end

do
	local modules_toload = {}
	local extensions_toload = {}

	function private:AddModuleToLoad(module_closure)
		modules_toload[#modules_toload + 1] = module_closure
	end

	function private:AddModuleExtension(extension_closure)
		extensions_toload[#modules_toload + 1] = extension_closure
	end

	local function loadNow(_, mod)
		local success, ret = pcall(mod)
		if not success then
			_G.geterrorhandler()(ret)
		end
	end

	function private:LoadModules()
		private.LoadModules = nil
		private.AddModuleToLoad = loadNow
		private.AddModuleExtension = loadNow

		for _, module in ipairs(modules_toload) do
			local success, ret = pcall(module)
			if not success then
				_G.geterrorhandler()(ret)
			end
		end
		modules_toload = nil

		for _, extension in ipairs(extensions_toload) do
			local success, ret = pcall(extension)
			if not success then
				_G.geterrorhandler()(ret)
			end
		end
		extensions_toload = nil
	end
end

