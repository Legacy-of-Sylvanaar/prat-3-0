---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2023  Prat Development Team
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

Prat.EventProcessingType = {
	Full = 1,
	PatternsOnly = 2,
}

local eventMap = {
	CHAT_MSG_CHANNEL = Prat.EventProcessingType.Full,
	CHAT_MSG_SAY = Prat.EventProcessingType.Full,
	CHAT_MSG_GUILD = Prat.EventProcessingType.Full,
	CHAT_MSG_WHISPER = Prat.EventProcessingType.Full,
	CHAT_MSG_WHISPER_INFORM = Prat.EventProcessingType.Full,
	CHAT_MSG_YELL = Prat.EventProcessingType.Full,
	CHAT_MSG_PARTY = Prat.EventProcessingType.Full,
	CHAT_MSG_PARTY_LEADER = Prat.EventProcessingType.Full,
	CHAT_MSG_OFFICER = Prat.EventProcessingType.Full,
	CHAT_MSG_RAID = Prat.EventProcessingType.Full,
	CHAT_MSG_RAID_LEADER = Prat.EventProcessingType.Full,
	CHAT_MSG_RAID_WARNING = Prat.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT = Prat.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT_LEADER = Prat.EventProcessingType.Full,
	CHAT_MSG_SYSTEM = Prat.EventProcessingType.Full,
	CHAT_MSG_DND = Prat.EventProcessingType.Full,
	CHAT_MSG_AFK = Prat.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER = Prat.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER_INFORM = Prat.EventProcessingType.Full,
	CHAT_MSG_BN_CONVERSATION = Prat.EventProcessingType.Full,
	CHAT_MSG_COMMUNITIES_CHANNEL = Prat.EventProcessingType.Full,
	CHAT_MSG_LOOT = Prat.EventProcessingType.PatternsOnly,
}

function Prat.EnableProcessingForEvent(event, flag)
	if flag == nil or flag == true then
		eventMap[event] = Prat.EventProcessingType.Full
	elseif flag ~= false then
		eventMap[event] = flag
	else
		eventMap[event] = nil
	end
end

function Prat.EventIsProcessed(event)
	return eventMap[event]
end



