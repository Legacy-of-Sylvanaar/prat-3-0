-- Deterministic frame simulation. The runner injects Forever's actual OnHide
-- method below this harness so tests exercise its persisted-window side effect.
local unpack = table.unpack or unpack
local queue, frames, server, combat, loggedIn = {}, {}, {}, false, true
local methods = {}
local function visible(frame)
	return frame.shown and (not frame.parent or visible(frame.parent))
end
local function visibilityChange(action)
	local before = {}
	for _, frame in ipairs(frames) do before[frame] = visible(frame) end
	action()
	for _, frame in ipairs(frames) do
		local now = visible(frame)
		if now ~= before[frame] then
			local script = frame.scripts[now and "OnShow" or "OnHide"]
			if script then script(frame) end
		end
	end
end
function methods:GetName() return self.name end
function methods:GetID() return self.id end
function methods:SetID(id) self.id = id end
function methods:SetParent(parent) visibilityChange(function() self.parent = parent end) end
function methods:GetParent() return self.parent end
function methods:Show() visibilityChange(function() self.shown = true end) end
function methods:Hide() visibilityChange(function() self.shown = false end) end
function methods:SetShown(value) if value then self:Show() else self:Hide() end end
function methods:IsShown() return self.shown end
function methods:IsVisible() return visible(self) end
function methods:SetScript(key, callback) self.scripts[key] = callback end
function methods:GetScript(key) return self.scripts[key] end
function methods:SetPoint(...) self.points[#self.points + 1] = {...} end
function methods:ClearAllPoints() self.points = {} end
function methods:GetNumPoints() return #self.points end
function methods:GetPoint(index) return unpack(self.points[index]) end
function methods:SetAllPoints(frame) self.allPoints = frame end
function methods:SetWidth(width) self.width = width end
function methods:SetHeight(height) self.height = height end
function methods:GetWidth() return self.width end
function methods:GetHeight() return self.height end
function methods:SetSize(width, height)
	local changed = width ~= self.width or height ~= self.height
	self.width, self.height = width, height
	if changed and self.scripts.OnSizeChanged then self.scripts.OnSizeChanged(self, width, height) end
end
function methods:GetSize() return self.width, self.height end
function methods:GetScale() return self.scale end
function methods:SetScale(scale) self.scale = scale end
function methods:GetLeft() return self.left or 100 end
function methods:GetBottom() return self.bottom or 100 end
function methods:IsProtected() return self.protected end
function methods:SetColorTexture(...) self.color = {...} end
function methods:SetText(text) self.text = text end
function methods:SetTextColor(...) self.color = {...} end
function methods:SetVertexColor(...) self.color = {...} end
function methods:SetAlpha(alpha) self.alpha = alpha end
function methods:GetAlpha() return self.alpha or 1 end
function methods:IsMouseOver() return self.mouseOver or false end
function methods:SetFontString(label) self.label = label end
function methods:GetStringWidth() return #(self.text or "") * 6 end
function methods:SetWordWrap() end
function methods:CreateAnimationGroup()
	return {
		IsPlaying = function(self) return self.playing end,
		Play = function(self) self.playing = true end,
		Stop = function(self) self.playing = false end,
		SetLooping = function() end,
		CreateAnimation = function()
			return { SetOrder = function() end, SetDuration = function() end, SetFromAlpha = function() end, SetToAlpha = function() end }
		end,
	}
end
function methods:AddMessage(message) self.messages[#self.messages + 1] = message end
function methods:ClearGamepadFocus() end
function methods:StartMoving() self.moving = true end
function methods:StartSizing() self.moving = true end
function methods:StopMovingOrSizing() self.moving = false end
for _, method in ipairs({"SetFrameStrata", "SetMovable", "SetResizable", "SetClampedToScreen", "SetResizeBounds", "EnableMouse", "RegisterForDrag", "RegisterForClicks", "SetNormalTexture", "SetHighlightTexture", "SetJustifyH", "SetClampRectInsets", "SetOwner", "AddLine"}) do
	methods[method] = function() end
end
function CreateFrame(_, name, parent, template)
	local frame = setmetatable({ name = name, parent = parent, shown = true, scripts = {}, points = {}, width = 430, height = 180, scale = 1, messages = {} }, { __index = methods })
	if name then _G[name] = frame end
	frames[#frames + 1] = frame
	frame.template = template
	if template == "ChatTabArtTemplate" then
		local keys = TEST_CLASSIC and {"leftTexture", "middleTexture", "rightTexture", "leftSelectedTexture", "middleSelectedTexture", "rightSelectedTexture", "leftHighlightTexture", "middleHighlightTexture", "rightHighlightTexture", "glow"}
			or {"Left", "Middle", "Right", "ActiveLeft", "ActiveMiddle", "ActiveRight", "HighlightLeft", "HighlightMiddle", "HighlightRight", "glow"}
		for _, key in ipairs(keys) do
			frame[key] = CreateFrame("Texture", nil, frame)
		end
		frame.glow.FlashAnim = not TEST_CLASSIC and {
			IsPlaying = function(self) return self.playing end,
			Play = function(self) self.playing = true end,
			Stop = function(self) self.playing = false end,
		}
	end
	return frame
end
function methods:CreateTexture() return CreateFrame("Texture", nil, self) end
function methods:CreateFontString() return CreateFrame("FontString", nil, self) end
UIParent = CreateFrame("Frame", "UIParent")
GameTooltip = CreateFrame("Frame", "GameTooltip", UIParent)
NUM_CHAT_WINDOWS = 10
FloatingChatFrameMixin = {}
C_Timer = { After = function(_, callback) queue[#queue + 1] = callback end }
local function flush()
	local iterations = 0
	while #queue > 0 do
		iterations = iterations + 1
		assert(iterations < 100, "timer/layout loop")
		local callbacks = queue; queue = {}
		for _, callback in ipairs(callbacks) do callback() end
	end
end
function InCombatLockdown() return combat end
function IsLoggedIn() return loggedIn end
function IsShiftKeyDown() return false end
function IsControlKeyDown() return false end
function GetChatWindowInfo(id)
	local data = assert(server[id], "invalid window id")
	return data.name, 12, 1, 1, 1, 1, data.shown, data.locked, data.docked
end
function SetChatWindowShown(id, value) server[id].shown = value end
function FCF_SetLocked(frame, value) frame.isLocked = value; server[frame.id].locked = value end
local lastActive
ChatFrameUtil = {
	SetLastActiveWindow = function(box) lastActive = box end,
	DeactivateChat = function(box) box.deactivated = true end,
}
GENERAL_CHAT_DOCK = { DOCKED_CHAT_FRAMES = {} }
function FCFDock_GetChatFrames(dock) return dock.DOCKED_CHAT_FRAMES end
function FCFDock_GetSelectedWindow(dock) return dock.selected end
function FCF_DockUpdate()
	for _, frame in ipairs(GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES) do frame:SetShown(frame == GENERAL_CHAT_DOCK.selected) end
end
function FCF_DockFrame(frame, index)
	if frame.isDocked then return end
	index = math.min(index or 1, #GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES + 1)
	table.insert(GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES, index, frame)
	frame.isDocked = true
	server[frame.id].docked = index
	NativeTabForTest(frame):SetParent(UIParent)
	FCF_DockUpdate()
end
function NativeTabForTest(frame) return _G[frame.name .. "Tab"] end
function FCF_UnDockFrame(frame)
	for index, docked in ipairs(GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES) do
		if docked == frame then table.remove(GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES, index); break end
	end
	frame.isDocked, server[frame.id].docked = nil, nil
	if GENERAL_CHAT_DOCK.selected == frame then GENERAL_CHAT_DOCK.selected = ChatFrame1 end
	frame:Show()
	FCF_DockUpdate()
end
function FCF_StopAlertFlash(frame) frame.alertStopped = true end
function FCF_FadeInChatFrame(frame) frame.fadedIn = true end
function FCF_Tab_OnClick(tab, button)
	local frame = _G["ChatFrame" .. tab:GetID()]
	if button == "RightButton" then _G.testMenuID = tab:GetID(); return end
	SELECTED_CHAT_FRAME = frame
	ChatFrameUtil.SetLastActiveWindow(frame.editBox)
end
function FCF_SetWindowName(frame, name) server[frame.id].name = name end
function FCF_SetTabPosition(frame) local tab = NativeTabForTest(frame); tab:ClearAllPoints(); tab:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0) end
function FCF_RestorePositionAndDimensions(frame) frame:ClearAllPoints(); frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0) end
function FCF_UpdateChatFrameParent(frame) frame:SetParent(UIParent) end
local fullScreen = UIParent
function FCF_GetCurrentFullScreenFrame() return fullScreen end
function FCF_SetFullScreenFrame(parent) fullScreen = parent end
function FCF_ClearFullScreenFrame() fullScreen = UIParent end
if TEST_CLASSIC then
	FCF_UpdateChatFrameParent, FCF_GetCurrentFullScreenFrame = nil, nil
	FCF_SetFullScreenFrame, FCF_ClearFullScreenFrame = nil, nil
end
function FCF_Close(frame, fallback)
	frame = fallback or frame
	FCF_UnDockFrame(frame)
	frame:Hide()
	NativeTabForTest(frame):Hide()
	server[frame.id].channels = {}
end
function FloatingChatFrame_Update(id)
	local frame = _G["ChatFrame" .. id]
	FCF_SetWindowName(frame, server[id].name)
	if server[id].shown then frame:Show() elseif not server[id].docked then FCF_Close(frame) end
	FCF_RestorePositionAndDimensions(frame)
end
local function clone(value)
	if type(value) ~= "table" then return value end
	local result = {}; for key, item in pairs(value) do result[key] = clone(item) end; return result
end
local hooks, callbacks, options = {}, {}, {}
Prat = { Addon = {}, db = { profile = { modules = {} } } }
local module
function Prat:NewModule(name)
	module = { name = "Prat_" .. name, enabled = true, events = {} }
	function module:IsEnabled() return self.enabled end
	function module:RegisterEvent(event) self.events[event] = true end
	function module:UnregisterEvent(event) self.events[event] = nil end
	function module:UnregisterAllEvents() self.events = {} end
	function module:RegisterChatCommand(command, method) self.command = command; self.commandMethod = method end
	function module:Output(message) self.lastOutput = message end
	function module:SecureHook(object, method, handler)
		if type(object) == "string" then handler, method, object = method, object, _G end
		local original = assert(object[method], "missing API: " .. method)
		local hook = { object = object, method = method, original = original, active = true }
		hooks[#hooks + 1] = hook
		object[method] = function(...)
			local result = {original(...)}
			if hook.active then
				if type(handler) == "string" then self[handler](self, ...) else handler(...) end
			end
			return unpack(result)
		end
	end
	function module:Unhook(object, method)
		for _, hook in ipairs(hooks) do if hook.object == object and hook.method == method then hook.active = false end end
	end
	function module:UnhookAll() for _, hook in ipairs(hooks) do hook.active = false end end
	return module
end
function Prat:SetModuleDefaults(_, defaults) module.db = clone(defaults) end
function Prat:SetModuleOptions(_, value) options = value end
function Prat:SetModuleInit(_, callback) callbacks.init = callback end
function Prat:AddModuleToLoad(callback) callback() end
function Prat:UpdateOptions() end
function LibStub() return { Open = function() end, SelectGroup = function() end } end
Test = {}
function Test.createFrames()
	for id = 1, 10 do
		server[id] = { name = ({"General", "Combat Log", "Party", "Raid", "Guild", "Loot"})[id] or "", shown = id <= 6, channels = {"CHANNEL_" .. id} }
		local frame = CreateFrame("ScrollingMessageFrame", "ChatFrame" .. id, UIParent)
		frame.id = id
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", id * 100, 80)
		frame:SetSize(400 + id, 200 + id)
		frame.editBox = CreateFrame("EditBox", nil, frame)
		frame.ResizeButton = CreateFrame("Button", nil, frame)
		frame.buttonFrame = CreateFrame("Frame", nil, frame)
		frame.buttonFrame.minimizeButton = CreateFrame("Button", nil, frame.buttonFrame)
		if TEST_CLASSIC then
			frame.minimizeButton = frame.buttonFrame.minimizeButton
			frame.buttonFrame.minimizeButton = nil
		end
		frame:SetScript("OnHide", FloatingChatFrameMixin.OnHide)
		local tab = CreateFrame("Button", "ChatFrame" .. id .. "Tab", UIParent)
		tab.id = id
		tab:SetScript("OnClick", FCF_Tab_OnClick)
	end
	DEFAULT_CHAT_FRAME, SELECTED_CHAT_FRAME = ChatFrame1, ChatFrame1
	GENERAL_CHAT_DOCK.selected = ChatFrame1
	FCF_DockFrame(ChatFrame1, 1); FCF_DockFrame(ChatFrame2, 2); FCF_DockFrame(ChatFrame5, 3)
end
function Test.start()
	Test.createFrames()
	callbacks.init(module)
	module:OnModuleEnable()
	flush()
end
Test.module = function() return module end
Test.options = function() return options end
Test.server = server
Test.flush = flush
Test.combat = function(value) combat = value end
Test.lastActive = function() return lastActive end
Test.clone = clone
Test.logIn = function(value) loggedIn = value end
