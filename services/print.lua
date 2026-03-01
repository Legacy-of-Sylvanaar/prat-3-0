local _, private = ...

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

local function buildText(...)
	local text = "|cffffff78" .. tostring(private) .. ":|r "

	for i = 1, select("#", ...) do
		local parm = select(i, ...)
		if type(parm) == "string" then
			text = text .. parm
		else
			text = text .. tostring(parm) .. " "
		end
	end

	if text == nil or #text == 0 then
		return ""
	end

	return text
end

--[[ from AceConsole-3.0 ]] --
if not private.Print then
	function private.Print(self, ...)
		local text = (self == private) and buildText(...) or buildText(self, ...)

		if text == nil or #text == 0 then
			return
		end

		DEFAULT_CHAT_FRAME:AddMessage(text)
	end
end

if not private.PrintLiteral then
	function private.PrintLiteral(_, ...)
		UIParentLoadAddOn("Blizzard_DebugTools");
		DevTools_Dump((...));
		DevTools_Dump(select(2, ...));
	end
end

if not private.AddPrintMethod then
	function private.AddPrintMethod(_, frame)
		function frame:print(...)
			private.Print(self, ...)
		end

		function frame:dbg()
		end
	end
end

if not private.AddPrintMethods then
	function private.AddPrintMethods()
		for i = 1, NUM_CHAT_WINDOWS do
			private.AddPrintMethod(private, _G["ChatFrame" .. i])
		end
	end

	private.EnableTasks[#private.EnableTasks + 1] = private.AddPrintMethods
end

