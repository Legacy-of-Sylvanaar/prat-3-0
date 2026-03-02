local _, private = ...

local pairs, ipairs = pairs, ipairs
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat

function private.BuildLink(linktype, data, text, color, link_start, link_end)
	return "|cff" .. (color or "ffffff") .. "|H" .. linktype .. ":" .. data .. "|h" .. (link_start or "[") .. text .. (link_end or "]") .. "|h|r"
end

function private.FormatLink(linkType, linkDisplayText, ...)
	local linkFormatTable = { ("|H%s"):format(linkType), ... }
	local returnLink = tconcat(linkFormatTable, ":")
	if linkDisplayText then
		return returnLink .. ("|h%s|h"):format(linkDisplayText)
	end
	return returnLink .. "|h"
end

do
	local LinkRegistry = {}

	-- linktype = { linkid, linkfunc, handler }
	function private.RegisterLinkType(linktype, who)
		if linktype and linktype.linkid and linktype.linkfunc then
			linktype.owner = who

			tinsert(LinkRegistry, linktype)

			return #LinkRegistry
		end
	end

	function private.UnregisterAllLinkTypes(who)
		for i, linktype in ipairs(LinkRegistry) do
			if linktype.owner == who then
				private.UnregisterLinkType(i)
			end
		end
	end

	function private.UnregisterLinkType(idx)
		tremove(LinkRegistry, idx)
	end

	function private.SetHyperlinkHook(hooks, tooltip, link, ...)
		for _, reg_link in ipairs(LinkRegistry) do
			if reg_link.linkid == link:sub(1, (reg_link.linkid):len()) then
				local frame
				for _, v in pairs(private.HookedFrames) do
					if v:IsMouseOver() and v:IsVisible() then
						frame = v
						break
					end
				end
				if reg_link.linkfunc(reg_link.handler, link, frame, ...) == false then
					return false
				end
			end
		end
		hooks.SetHyperlink(tooltip, link, ...)
	end
end
