local _, private = ...

local chanTable = {}
function private.RebuildChannelTable()
	table.wipe(chanTable)
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

function private.GetChannelTable()
	if #chanTable == 0 then
		private.RebuildChannelTable()
	end
	return chanTable
end

-- Update logic
if ChatFrame_AddCommunitiesChannel then
	hooksecurefunc("ChatFrame_AddCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)
	hooksecurefunc("ChatFrame_RemoveCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)
elseif ChatFrameUtil and ChatFrameUtil.AddCommunitiesChannel then
	hooksecurefunc(ChatFrameUtil, "AddCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)
	hooksecurefunc(ChatFrameUtil, "RemoveCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)
end
hooksecurefunc(C_ChatInfo, "SwapChatChannelsByChannelIndex", function()
	private.RebuildChannelTable()
end)
