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
	local module = Prat:NewModule("Fading")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			textfade = { ["*"] = true },
			duration = 120
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			textfade = {
				name = PL["textfade_name"],
				desc = PL["textfade_desc"],
				type = "multiselect",
				values = Prat.HookedFrameList,
				get = "GetSubValue",
				set = "SetSubValue"
			},
			duration = {
				name = PL["duration_name"],
				desc = PL["duration_desc"],
				type = "range",
				order = 190,
				min = 1,
				max = 240,
				step = 1,
			},
		}
	})

	function module:OnModuleEnable()
		self:OnValueChanged()
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	function module:OnModuleDisable()
		for _, v in pairs(Prat.HookedFrames) do
			self:Fade(v, true)
		end
	end

	function module:Prat_FramesUpdated(_, name, chatFrame)
		self:Fade(chatFrame, self.db.profile.textfade[name])
	end

	function module:OnValueChanged()
		for k, v in pairs(Prat.HookedFrames) do
			self:Fade(v, self.db.profile.textfade[k])
		end
	end
	module.OnSubValueChanged = module.OnValueChanged

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:Fade(cf, textfade)
		if textfade then
			cf:SetFading(true)
			cf:SetTimeVisible(module.db.profile.duration)
		else
			cf:SetFading(false)
		end
	end

	return
end)
