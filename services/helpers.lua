local _, private = ...

local issecretvalue = issecretvalue or function ()
	return false
end

function private.GetCommunityAndStreamFromChannel(communityChannel)
	local clubId, streamId = communityChannel:match("(%d+)%:(%d+)")
	return tonumber(clubId), tonumber(streamId)
end

function private.GetCommunityAndStreamName(clubId, streamId)
	local streamInfo = C_Club.GetStreamInfo(clubId, streamId)

	if streamInfo and (streamInfo.streamType == Enum.ClubStreamType.Guild or streamInfo.streamType == Enum.ClubStreamType.Officer) then
		return streamInfo.name
	end

	local streamName = streamInfo and streamInfo.name or ""

	local clubInfo = C_Club.GetClubInfo(clubId)
	if streamInfo and streamInfo.streamType == Enum.ClubStreamType.General then
		if not clubInfo then
			return ""
		end
		local _name = clubInfo.shortName or clubInfo.name
		if not issecretvalue(_name) then
			_name = ChatFrameUtil.TruncateToMaxLength(_name, ChatFrameConstants.TruncatedCommunityNameWithoutChannelLength)
		end
		return _name
	else
		if not clubInfo then
			return ""
		end
		local _name = clubInfo.shortName or clubInfo.name
		if not issecretvalue(_name) then
			_name = ChatFrameUtil.TruncateToMaxLength(_name, ChatFrameConstants.TruncatedCommunityNameLength)
		end
		return _name.." - "..streamName
	end
end

function private.ResolveChannelName(communityChannel)
	local clubId, streamId = private.GetCommunityAndStreamFromChannel(communityChannel)
	if not clubId or not streamId then
		return communityChannel
	end

	return private.GetCommunityAndStreamName(clubId, streamId)
end

function private.ResolvePrefixedChannelName(communityChannelArg)
	local prefix, communityChannel = communityChannelArg:match("(%d+. )(.*)")
	return prefix .. private.ResolveChannelName(communityChannel)
end

function private.GetDecoratedSenderName(event, ...)
	local _, senderName, _, _, _, _, _, channelIndex, _, _, _, senderGUID = ...
	local chatType = string.sub(event, 10)

	if string.find(chatType, "^WHISPER") then
		chatType = "WHISPER"
	end

	if string.find(chatType, "^CHANNEL") then
		chatType = "CHANNEL" .. channelIndex
	end

	local chatTypeInfo = ChatTypeInfo[chatType]
	local decoratedPlayerName = senderName

	local _, englishClass, firstName
	if senderGUID then
		_, englishClass, _, _, _, firstName = GetPlayerInfoByGUID(senderGUID)
	end

	-- Ambiguate guild chat names
	if Ambiguate and not issecretvalue(senderName) then
		if chatType == "GUILD" then
			decoratedPlayerName = Ambiguate(decoratedPlayerName, "guild")
		else
			decoratedPlayerName = Ambiguate(decoratedPlayerName, "none")
		end
	elseif firstName then
		decoratedPlayerName = firstName
	end

	-- Add timerunning icon when necessary based on player guid
	if senderGUID and not issecretvalue(senderGUID) and C_ChatInfo.IsTimerunningPlayer(senderGUID) then
		decoratedPlayerName = TimerunningUtil.AddSmallIcon(decoratedPlayerName)
	end

	if senderGUID and chatTypeInfo and GetPlayerInfoByGUID ~= nil then
		if englishClass then
			local classColor = private.GetClassGetColorNew(englishClass)

			if classColor then
				decoratedPlayerName = classColor:WrapTextInColorCode(decoratedPlayerName)
			end
		end
	end

	if ChatFrameUtil.ProcessSenderNameFilters then
		decoratedPlayerName = ChatFrameUtil.ProcessSenderNameFilters(event, decoratedPlayerName, ...)
	end
	if decoratedPlayerName then
		if not issecretvalue(decoratedPlayerName) and decoratedPlayerName == "" then
			return decoratedPlayerName
		end
		return "[" .. decoratedPlayerName .. "]"
	end
end

local function SanitizeCommunityData(clubId, streamId, epoch, position)
	if type(clubId) == "number" then
		clubId = ("%.f"):format(clubId)
	end
	if type(streamId) == "number" then
		streamId = ("%.f"):format(streamId)
	end
	epoch = ("%.f"):format(epoch)
	position = ("%.f"):format(position)

	return clubId, streamId, epoch, position
end

function private.GetBNPlayerCommunityLink(playerName, linkDisplayText, bnetIDAccount, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position)
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s:%s|h%s|h", playerName, bnetIDAccount, clubId, streamId, epoch, position, linkDisplayText)
end

function private.GetPlayerCommunityLink(playerName, linkDisplayText, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position)
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s|h%s|h", playerName, clubId, streamId, epoch, position, linkDisplayText)
end

function private.GetPlayerLink(characterName, linkDisplayText, lineID, chatType, chatTarget)
	return string.format("|Hplayer:%s:%s:%s:%s|h%s|h", characterName, lineID or 0, chatType or 0, chatTarget or "", linkDisplayText)
end

function private.GetBNPlayerLink(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
	return string.format("|HBNplayer:%s:%s:%s:%s:%s|h%s|h", name, bnetIDAccount, lineID, chatType, chatTarget, linkDisplayText)
end
