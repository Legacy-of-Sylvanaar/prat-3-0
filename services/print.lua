local name, addonTable = ...

--[[ END STANDARD HEADER ]] --

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

local function buildText(...)
  local text = "|cffffff78" .. tostring(addonTable) .. ":|r "

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
if not Prat.Print then
  function Prat.Print(self, ...)
    local text = (self == addonTable) and buildText(...) or buildText(self, ...)

    if text == nil or #text == 0 then
      return
    end

    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
end

if not Prat.PrintLiteral then
  function Prat.PrintLiteral(self, ...)
    UIParentLoadAddOn("Blizzard_DebugTools");
    DevTools_Dump((...));
    DevTools_Dump(select(2, ...));
  end
end

if not Prat.AddPrintMethod then
  function Prat.AddPrintMethod(_, frame)
    function frame:print(...)
      Prat.Print(self, ...)
    end

    function frame:dbg()
    end
  end
end

if not Prat.AddPrintMethods then
  function Prat.AddPrintMethods()
    for i = 1, NUM_CHAT_WINDOWS do
      Prat.AddPrintMethod(addonTable, _G["ChatFrame" .. i])
    end
  end

  Prat.EnableTasks[#Prat.EnableTasks + 1] = Prat.AddPrintMethods
end

