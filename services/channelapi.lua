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

-- Start hacks for in-combat ResolveChannelName
private.GetCommunityAndStreamFromChannel = function(communityChannel)
	local clubId, streamId = communityChannel:match("(%d+)%:(%d+)")
	return tonumber(clubId), tonumber(streamId)
end

private.GetCommunityAndStreamName = function(clubId, streamId)
	local streamInfo = C_Club.GetStreamInfo(clubId, streamId)

	if streamInfo and (streamInfo.streamType == Enum.ClubStreamType.Guild or streamInfo.streamType == Enum.ClubStreamType.Officer) then
		return streamInfo.name
	end

	local streamName = streamInfo and streamInfo.name or ""

	local clubInfo = C_Club.GetClubInfo(clubId);
	if streamInfo and streamInfo.streamType == Enum.ClubStreamType.General then
		local communityName = clubInfo and (clubInfo.shortName or clubInfo.name) or ""
		return communityName
	else
		local communityName = clubInfo and (clubInfo.shortName or clubInfo.name) or ""
		return communityName .. " - " .. streamName
	end
end

private.ResolveChannelName = function(communityChannel)
	local clubId, streamId = private.GetCommunityAndStreamFromChannel(communityChannel)
	if not clubId or not streamId then
		return communityChannel
	end

	return private.GetCommunityAndStreamName(clubId, streamId)
end

private.ResolvePrefixedChannelName = function(communityChannelArg)
	local prefix, communityChannel = communityChannelArg:match("(%d+. )(.*)");
	return prefix .. private.ResolveChannelName(communityChannel);
end
-- End hacks for in-combat ResolveChannelName

local chanTable = {}
local function RebuildChannelTable()
	local channels = {GetChannelList()}
	if #channels > 0 then
		for i = 1, #channels, 3 do
			local num, name = channels[i], channels[i+1]
			name = private.ResolveChannelName(name)
			if not issecretvalue or not issecretvalue(name) then
				chanTable[num] = name
				chanTable[name] = num
			end
		end
	end
	if not chanTable["LookingForGroup"] then
		local lfgnum = GetChannelName("LookingForGroup")
		if lfgnum and lfgnum > 0 then
			chanTable["LookingForGroup"] = lfgnum
			chanTable[lfgnum] = "LookingForGroup"
		end
	end
	for k, v in pairs(chanTable) do
		if type(k) == "string" then
			chanTable[k:lower()] = v
		end
	end
end

private.GetChannelTable = function()
	if #chanTable == 0 then
		RebuildChannelTable()
	end
	return chanTable
end

-- Update logic
if ChatFrame_AddCommunitiesChannel then
	hooksecurefunc("ChatFrame_AddCommunitiesChannel", function()
		RebuildChannelTable()
	end)
	hooksecurefunc("ChatFrame_RemoveCommunitiesChannel", function()
		RebuildChannelTable()
	end)
elseif ChatFrameUtil and ChatFrameUtil.AddCommunitiesChannel then
	hooksecurefunc(ChatFrameUtil, "AddCommunitiesChannel", function()
		RebuildChannelTable()
	end)
	hooksecurefunc(ChatFrameUtil, "RemoveCommunitiesChannel", function()
		RebuildChannelTable()
	end)
end
hooksecurefunc(C_ChatInfo, "SwapChatChannelsByChannelIndex", function()
	RebuildChannelTable()
end)
