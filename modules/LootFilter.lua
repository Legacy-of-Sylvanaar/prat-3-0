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

local issecretvalue = issecretvalue or function() return false end

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("LootFilter", "AceEvent-3.0")
	local PL = module.PL

	Prat:SetModuleDefaults(module, {
		profile = {
			on = false,
			minquality = 2, -- Uncommon
			inparty = true,
			inraid = true,
			filterself = false,
		}
	})

	-- Quality names as the client displays them, colored with the quality color
	local QUALITY_VALUES = {}
	for i = 0, 5 do
		local desc = _G["ITEM_QUALITY" .. i .. "_DESC"]
		if desc then
			local color = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[i]
			QUALITY_VALUES[i] = color and color.hex and (color.hex .. desc .. "|r") or desc
		end
	end

	Prat:SetModuleOptions(module, {
		name = PL["LootFilter"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			minquality = {
				name = PL["minquality_name"],
				desc = PL["minquality_desc"],
				type = "select",
				order = 100,
				values = QUALITY_VALUES,
			},
			inparty = {
				name = PL["inparty_name"],
				desc = PL["inparty_desc"],
				type = "toggle",
				order = 110,
			},
			inraid = {
				name = PL["inraid_name"],
				desc = PL["inraid_desc"],
				type = "toggle",
				order = 120,
			},
			filterself = {
				name = PL["filterself_name"],
				desc = PL["filterself_desc"],
				type = "toggle",
				order = 130,
			},
		}
	})

	--[[------------------------------------------------
		Module Event Functions
	------------------------------------------------]] --
	function module:OnModuleEnable()
		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
	end

	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
	end

	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --

	-- Reverse lookup of quality color hex ("ff1eff00") to quality index, for older link formats
	local QUALITY_BY_HEX = {}
	if ITEM_QUALITY_COLORS then
		for i, color in pairs(ITEM_QUALITY_COLORS) do
			if color.hex then
				local hex = color.hex:match("|c(%x%x%x%x%x%x%x%x)")
				if hex then
					QUALITY_BY_HEX[hex:lower()] = i
				end
			end
		end
	end

	local GetItemQualityByID = C_Item and C_Item.GetItemQualityByID
	local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo

	-- Returns the quality of the first item link in the text, or nil if it can't be determined
	local function GetLinkQuality(text)
		local link = text:match("|c[^|]*|Hitem:.-|h.-|h|r") or text:match("|Hitem:.-|h.-|h")
		if not link then
			return
		end

		-- Modern links embed the quality directly: |cnIQ2:
		local quality = link:match("^|cnIQ(%d+):")
		if quality then
			return tonumber(quality)
		end

		if GetItemQualityByID then
			quality = GetItemQualityByID(link)
			if quality then
				return quality
			end
		end

		if GetItemInfo then
			local _, _, q = GetItemInfo(link)
			if q then
				return q
			end
		end

		local hex = link:match("^|c(%x%x%x%x%x%x%x%x)")
		return hex and QUALITY_BY_HEX[hex:lower()]
	end

	-- Unknown looters count as our own, so we never hide our loot by accident
	local function IsOwnLoot(message)
		local guid = message.GUID
		if issecretvalue(guid) then
			return true
		end
		if guid ~= nil and guid ~= "" then
			return guid == UnitGUID("player")
		end

		local looter = message.ORG and message.ORG.ARGS and message.ORG.ARGS[2]
		if type(looter) ~= "string" or issecretvalue(looter) or looter == "" then
			return true
		end
		return Ambiguate(looter, "none") == UnitName("player")
	end

	function module:ShouldFilterGroup()
		if IsInRaid() then
			return self.db.profile.inraid
		elseif IsInGroup() then
			return self.db.profile.inparty
		end
		return false
	end

	function module:Prat_FrameMessage(_, message, _, event)
		if event ~= "CHAT_MSG_LOOT" or message.DONOTPROCESS then
			return
		end

		if not self:ShouldFilterGroup() then
			return
		end

		local text = message.ORG and message.ORG.MESSAGE
		if type(text) ~= "string" or issecretvalue(text) then
			return
		end

		if not self.db.profile.filterself and IsOwnLoot(message) then
			return
		end

		local quality = GetLinkQuality(text)
		if quality and quality < self.db.profile.minquality then
			message.DONOTPROCESS = true
		end
	end

	return
end) -- Prat:AddModuleToLoad
