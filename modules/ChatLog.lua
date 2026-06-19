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
	local module = Prat:NewModule("ChatLog")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			chat = false,
			combat = false,
			quiet = true,
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["ChatLog"],
		desc = PL["A module to automaticaly enable chat and combat logging."],
		type = "group",
		args = {
			chat = {
				name = PL["Toggle Chat Log"],
				desc = PL["Toggle chat log on and off."],
				type = "toggle",
				set = "SetChatLog",
			},
			combat = {
				name = PL["Toggle Combat Log"],
				desc = PL["Toggle combat log on and off."],
				type = "toggle",
				set = "SetCombatLog",
			},
			quiet = {
				name = PL["quiet_name"],
				desc = PL["quiet_desc"],
				type = "toggle",
			}
		}
	})

	function module:OnModuleEnable()
		self:SetChatLog(nil, self.db.profile.chat)
		self:SetCombatLog(nil, self.db.profile.combat)
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:GetDescription()
		return PL["A module to automaticaly enable chat and combat logging."]
	end

	function module:SetChatLog(_, val)
		self.db.profile.chat = val
		if self.db.profile.chat then
			self:Print(PL["Chat Log: Enabled"])
			self:Print(PL["Chat log recorded to <WoW Installation>\\Logs\\WoWChatLog.txt only upon logout."])
			LoggingChat(true)
		else
			LoggingChat(false)
			self:Print(PL["Chat Log: Disabled"])
		end
	end

	function module:SetCombatLog(_, val)
		self.db.profile.combat = val
		if self.db.profile.combat then
			self:Print(PL["Combat Log: Enabled"])
			self:Print(PL["Combat log recorded to <WoW Installation>\\Logs\\WoWCombatLog.txt only upon logout."])
			LoggingCombat(true)
		end
	end

	function module:Print(str)
		if self.db.profile.quiet then
			return
		end

		Prat:Print(str)
	end
end)
