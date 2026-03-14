local _, private = ...

private.EventProcessingType = {
	Full = 1,
	PatternsOnly = 2,
}

local eventMap = {
	CHAT_MSG_CHANNEL = private.EventProcessingType.Full,
	CHAT_MSG_SAY = private.EventProcessingType.Full,
	CHAT_MSG_GUILD = private.EventProcessingType.Full,
	CHAT_MSG_WHISPER = private.EventProcessingType.Full,
	CHAT_MSG_WHISPER_INFORM = private.EventProcessingType.Full,
	CHAT_MSG_YELL = private.EventProcessingType.Full,
	CHAT_MSG_PARTY = private.EventProcessingType.Full,
	CHAT_MSG_PARTY_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_OFFICER = private.EventProcessingType.Full,
	CHAT_MSG_RAID = private.EventProcessingType.Full,
	CHAT_MSG_RAID_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_RAID_WARNING = private.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT = private.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_SYSTEM = private.EventProcessingType.Full,
	CHAT_MSG_DND = private.EventProcessingType.Full,
	CHAT_MSG_AFK = private.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER = private.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER_INFORM = private.EventProcessingType.Full,
	CHAT_MSG_BN_CONVERSATION = private.EventProcessingType.Full,
	CHAT_MSG_COMMUNITIES_CHANNEL = private.EventProcessingType.Full,
	CHAT_MSG_LOOT = private.EventProcessingType.PatternsOnly,
}

function private.EnableProcessingForEvent(event, flag)
	if flag == nil or flag == true then
		eventMap[event] = private.EventProcessingType.Full
	elseif flag ~= false then
		eventMap[event] = flag
	else
		eventMap[event] = nil
	end
end

function private.EventIsProcessed(event)
	return eventMap[event]
end



