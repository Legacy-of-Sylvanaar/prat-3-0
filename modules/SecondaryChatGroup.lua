-- SPDX-License-Identifier: GPL-3.0-or-later
-- Uses real chat frames, but never marks them as members of GENERAL_CHAT_DOCK.
-- Inactive frames stay shown under hidden holders: Forever's OnHide otherwise
-- calls SetChatWindowShown(false), allowing the client to close/reuse the window.
Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("SecondaryChatGroup", "AceHook-3.0", "AceEvent-3.0", "AceConsole-3.0")
	local MAX_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows
	local TAB_HEIGHT, GAP = 32, 1
	local function InCombat()
		return InCombatLockdown and InCombatLockdown()
	end
	local function NativeTab(frame)
		return _G[frame:GetName() .. "Tab"]
	end
	local function EditBox(frame)
		return frame.editBox or _G[frame:GetName() .. "EditBox"]
	end
	local function WindowInfo(id)
		local name, _, _, _, _, _, shown, locked, docked = GetChatWindowInfo(id)
		return name, shown, locked, docked
	end
	local function Deactivate(frame)
		local box = EditBox(frame)
		if not box then return end
		local deactivate = ChatEdit_DeactivateChat or (ChatFrameUtil and ChatFrameUtil.DeactivateChat)
		if deactivate then deactivate(box) end
	end
	local function LastActive(frame)
		local setActive = ChatEdit_SetLastActiveWindow or (ChatFrameUtil and ChatFrameUtil.SetLastActiveWindow)
		if setActive then setActive(EditBox(frame)) end
	end

	Prat:SetModuleDefaults(module, {
		profile = { on = false },
		-- Chat window IDs and channel filters belong to a character, not a Prat profile.
		char = {
			members = {}, selected = 0, locked = false,
			point = "BOTTOMRIGHT", x = -50, y = 180, width = 430, height = 180,
		},
	})

	function module:GetDescription()
		return "Group existing chat windows into a second, independent set of tabs."
	end
	function module:GetEntry(id)
		for index, entry in ipairs(self.db.char.members) do
			if entry.id == id then return entry, index end
		end
	end
	function module:CanUse(id)
		if type(id) ~= "number" or id < 3 or id > MAX_WINDOWS then return false end
		local frame = _G["ChatFrame" .. id]
		local name, shown, _, docked = WindowInfo(id)
		return frame and not frame.isTemporary and not frame.minimized and not frame:IsProtected() and name and name ~= ""
			and (shown or docked or frame.isDocked or self:GetEntry(id))
	end
	function module:WindowChoices()
		local result = {}
		for id = 3, MAX_WINDOWS do
			if self:CanUse(id) then result[id] = (WindowInfo(id)) .. " (" .. id .. ")" end
		end
		return result
	end
	function module:Notify()
		Prat:UpdateOptions()
	end
	function module:OpenOptions()
		local dialog = LibStub("AceConfigDialog-3.0")
		dialog:Open("Prat")
		if self:IsEnabled() then
			dialog:SelectGroup("Prat", "display", self.name)
		else
			dialog:SelectGroup("Prat", "modulecontrol")
			self:Output("Enable SecondaryChatGroup in Module Control to configure the group.")
		end
	end

	Prat:SetModuleOptions(module, {
		name = "Secondary Chat Group", desc = module:GetDescription(), type = "group",
		args = {
			info = { type = "description", order = 1, name = "Choose existing windows for your second tab group. Create windows using General > Create New Window, then select them below. General and Combat Log stay in the main group. Layout and membership are saved per character.\n\nLeft-click a tab to switch; right-click for its normal chat settings. Shift-click moves a tab left; Ctrl-click moves it right. When unlocked, drag any tab to move the group and the bottom-right grip to resize it." },
			members = {
				type = "multiselect", name = "Windows in the secondary group", order = 10,
				values = function() return module:WindowChoices() end,
				get = function(_, id) return module:GetEntry(id) ~= nil end,
				set = function(_, id, value) if value then module:AddWindow(id) else module:RemoveWindow(id) end end,
				disabled = InCombat,
			},
			locked = {
				type = "toggle", name = "Lock group position and size", order = 20,
				get = function() return module.db.char.locked end,
				set = function(_, value) module.db.char.locked = value; module:Layout() end,
				disabled = InCombat,
			},
			width = {
				type = "range", name = "Width", order = 30, min = 250, max = 1200, step = 1,
				get = function() return module.db.char.width end,
				set = function(_, value) module.db.char.width = value; module:Layout() end,
				disabled = InCombat,
			},
			height = {
				type = "range", name = "Height", order = 40, min = 100, max = 800, step = 1,
				get = function() return module.db.char.height end,
				set = function(_, value) module.db.char.height = value; module:Layout() end,
				disabled = InCombat,
			},
			reset = { type = "execute", name = "Reset position and size", order = 50, disabled = InCombat,
				func = function()
					local db = module.db.char
					db.point, db.x, db.y, db.width, db.height = "BOTTOMRIGHT", -50, 180, 430, 180
					module:Layout()
				end,
			},
			release = { type = "execute", name = "Return all windows", order = 60, disabled = InCombat,
				desc = "Remove all windows from this group and restore their original docking or placement.",
				func = function()
					while #module.db.char.members > 0 do module:RemoveWindow(module.db.char.members[1].id) end
				end,
			},
		},
	})

	function module:CreateGroup()
		if self.group then return end
		local group = CreateFrame("Frame", "PratSecondaryChatGroup", UIParent)
		self.group = group
		group:SetFrameStrata("LOW")
		group:SetMovable(true)
		group:SetResizable(true)
		group:SetClampedToScreen(true)
		group:SetResizeBounds(250, 100, 1200, 800)
		group:EnableMouse(false)
		self.hidden = CreateFrame("Frame", nil, UIParent)
		self.hidden:Hide()
		local resize = CreateFrame("Button", nil, group)
		self.resize = resize
		resize:SetSize(18, 18)
		resize:SetPoint("BOTTOMRIGHT", group, "BOTTOMRIGHT", 8, -8)
		resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		resize:SetAlpha(0)
		resize:SetScript("OnMouseDown", function(_, button)
			if button == "LeftButton" and not InCombat() and not self.db.char.locked then
				group:StartSizing("BOTTOMRIGHT"); self.moving = true
			end
		end)
		resize:SetScript("OnMouseUp", function() self:StopMoving() end)
		group:SetScript("OnSizeChanged", function()
			if self.moving then
				self.db.char.width, self.db.char.height = group:GetSize()
				self:LayoutContents()
			end
		end)
		group:SetScript("OnUpdate", function(_, elapsed) self:UpdateHover(elapsed) end)
		group:Hide()
	end
	function module:StartMoving()
		if InCombat() or self.db.char.locked then return end
		self.group:StartMoving()
		self.moving = true
		GameTooltip:Hide()
	end
	function module:UpdateHover(elapsed)
		local hovered = self.moving or self.group:IsMouseOver() or self.resize:IsMouseOver()
		for _, state in pairs(self.active) do
			hovered = hovered or state.button:IsMouseOver()
		end
		self.mouseAway = hovered and 0 or (self.mouseAway or 0) + elapsed
		local bright = hovered or self.mouseAway < 1
		local step = elapsed / (bright and (CHAT_FRAME_FADE_TIME or 0.15) or (CHAT_FRAME_FADE_OUT_TIME or 2))
		for id, state in pairs(self.active) do
			local target = (bright or state.unread) and 1 or (self.db.char.selected == id and 0.4 or 0.6)
			local alpha = state.button:GetAlpha()
			state.button:SetAlpha(alpha + math.max(-step, math.min(step, target - alpha)))
		end
		local target = bright and 1 or 0
		local alpha = self.resize:GetAlpha()
		self.resize:SetAlpha(alpha + math.max(-step, math.min(step, target - alpha)))
	end
	function module:StopMoving()
		if not self.moving then return end
		self.group:StopMovingOrSizing()
		self.moving = nil
		local db = self.db.char
		db.point, db.x, db.y = "BOTTOMLEFT", self.group:GetLeft(), self.group:GetBottom()
		db.width, db.height = self.group:GetSize()
		self:Layout()
		self:Notify()
	end
	function module:Snapshot(frame)
		local restore = { points = {}, width = frame:GetWidth(), height = frame:GetHeight(), scale = frame:GetScale(), locked = frame.isLocked or false }
		for i = 1, frame:GetNumPoints() do
			local point, relative, relativePoint, x, y = frame:GetPoint(i)
			restore.points[i] = { point, relative and relative:GetName() or "UIParent", relativePoint, x, y }
		end
		if frame.isDocked then
			local dockFrames = FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)
			for index, docked in ipairs(dockFrames) do
				if docked == frame then
					restore.dockIndex = index
					restore.dockBefore = dockFrames[index - 1] and dockFrames[index - 1]:GetID()
					restore.dockAfter = dockFrames[index + 1] and dockFrames[index + 1]:GetID()
				end
			end
		end
		return restore
	end
	function module:AddWindow(id)
		if InCombat() or not self:IsEnabled() or self:GetEntry(id) or not self:CanUse(id) then return end
		local frame = _G["ChatFrame" .. id]
		local entry = { id = id, name = WindowInfo(id), restore = self:Snapshot(frame) }
		table.insert(self.db.char.members, entry)
		self:Attach(entry)
		self:SelectWindow(id)
		self:Notify()
	end
	function module:Attach(entry)
		local id, frame = entry.id, _G["ChatFrame" .. entry.id]
		if self.active[id] then return end
		local tab = NativeTab(frame)
		local state = { frame = frame, entry = entry, parent = frame:GetParent(), tabParent = tab:GetParent() }
		self.active[id] = state
		if frame.isDocked then FCF_UnDockFrame(frame) end
		SetChatWindowShown(id, true)
		local holder = CreateFrame("Frame", nil, self.group)
		holder:SetAllPoints(self.group)
		state.holder = holder
		holder:Hide()
		frame:SetParent(holder)
		frame:Show()
		-- The group owns movement/resizing; suppress the member's native controls.
		state.controls = {}
		for _, control in pairs({ frame.ResizeButton, frame.minimizeButton or (frame.buttonFrame and frame.buttonFrame.minimizeButton) }) do
			state.controls[#state.controls + 1] = { frame = control, parent = control:GetParent() }
			self:SecureHook(control, "SetParent", function()
				if self.active[id] and control:GetParent() ~= self.hidden then control:SetParent(self.hidden) end
			end)
			control:SetParent(self.hidden)
		end
		-- A hidden native tab still supplies its menu/click handler and alert state.
		-- Reparenting, rather than Hide(), also avoids ChatTabs' Always Show hook.
		self:SecureHook(tab, "SetParent", function()
			if self.active[id] and tab:GetParent() ~= self.hidden then tab:SetParent(self.hidden) end
		end)
		tab:SetParent(self.hidden)
		self:SecureHook(frame, "SetParent", function()
			if self.active[id] and frame:GetParent() ~= holder then frame:SetParent(holder) end
		end)
		self:SecureHook(frame, "AddMessage", function()
			if self.active[id] and self.db.char.selected ~= id then
				state.unread = true
				self:UpdateTab(state)
			end
		end)
		-- Inherit only Blizzard's artwork. ChatTabTemplate also installs native
		-- docking/minimize scripts, which must not operate on this independent group.
		self.buttonSerial = (self.buttonSerial or 0) + 1
		local button = CreateFrame("Button", "PratSecondaryChatTab" .. self.buttonSerial, self.group, "ChatTabArtTemplate")
		-- Classic uses different parent keys and does not provide a glow animation.
		button.Left = button.Left or button.leftTexture
		button.Middle = button.Middle or button.middleTexture
		button.Right = button.Right or button.rightTexture
		button.ActiveLeft = button.ActiveLeft or button.leftSelectedTexture
		button.ActiveMiddle = button.ActiveMiddle or button.middleSelectedTexture
		button.ActiveRight = button.ActiveRight or button.rightSelectedTexture
		button.HighlightLeft = button.HighlightLeft or button.leftHighlightTexture
		button.HighlightMiddle = button.HighlightMiddle or button.middleHighlightTexture
		button.HighlightRight = button.HighlightRight or button.rightHighlightTexture
		button.Left:ClearAllPoints()
		button.Left:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -2, 0)
		button.Right:ClearAllPoints()
		button.Right:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
		button.Middle:ClearAllPoints()
		button.Middle:SetPoint("LEFT", button.Left, "RIGHT")
		button.Middle:SetPoint("RIGHT", button.Right, "LEFT")
		if not button.glow.FlashAnim then
			local animation = button.glow:CreateAnimationGroup()
			for order = 1, 2 do
				local alpha = animation:CreateAnimation("Alpha")
				alpha:SetOrder(order)
				alpha:SetDuration(1)
				alpha:SetFromAlpha(order == 1 and 0 or 1)
				alpha:SetToAlpha(order == 1 and 1 or 0)
			end
			animation:SetLooping("REPEAT")
			button.glow.FlashAnim = animation
		end
		state.button = button
		button:SetID(id)
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetHeight(TAB_HEIGHT)
		button.label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		button.label:SetPoint("CENTER", 0, -5)
		button.label:SetJustifyH("CENTER")
		button.label:SetWordWrap(false)
		button:SetFontString(button.label)
		button:RegisterForDrag("LeftButton")
		button:SetScript("OnDragStart", function() self:StartMoving() end)
		button:SetScript("OnDragStop", function() self:StopMoving() end)
		button:SetScript("OnClick", function(_, mouseButton)
			if mouseButton == "LeftButton" and IsShiftKeyDown() then self:MoveWindow(id, -1); return end
			if mouseButton == "LeftButton" and IsControlKeyDown() then self:MoveWindow(id, 1); return end
			if not self:SelectWindow(id) then return end
			if mouseButton == "RightButton" then
				FCF_Tab_OnClick(button, mouseButton)
			else
				-- Preserve other modules' native OnClick hooks (e.g. clear tab highlights).
				local onClick = tab:GetScript("OnClick")
				if onClick then onClick(tab, mouseButton) end
			end
		end)
		button:SetScript("OnEnter", function()
			GameTooltip:SetOwner(button, "ANCHOR_TOP")
			GameTooltip:SetText(entry.name)
			GameTooltip:AddLine("Right-click: chat settings\nShift-click: move left\nCtrl-click: move right", 1, 1, 1)
			if not self.db.char.locked then GameTooltip:AddLine("Drag to move this chat group", 0.2, 1, 0.2) end
			GameTooltip:Show()
			if self.db.char.selected == id then FCF_FadeInChatFrame(frame) end
		end)
		button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	function module:UpdateTab(state)
		local selected = self.db.char.selected == state.entry.id
		local button = state.button
		button.label:SetText(state.entry.name)
		local color = NativeTab(state.frame).selectedColorTable or DEFAULT_TAB_SELECTED_COLOR_TABLE or { r = 1, g = 0.82, b = 0 }
		local text = NORMAL_FONT_COLOR or { r = 1, g = 0.82, b = 0 }
		button.label:SetTextColor(text.r, text.g, text.b)
		for _, key in ipairs({ "ActiveLeft", "ActiveMiddle", "ActiveRight" }) do
			button[key]:SetShown(selected)
			button[key]:SetVertexColor(color.r, color.g, color.b)
		end
		for _, key in ipairs({ "HighlightLeft", "HighlightMiddle", "HighlightRight", "glow" }) do
			button[key]:SetVertexColor(color.r, color.g, color.b)
		end
		if state.unread then
			button:SetAlpha(1)
			button.glow:Show()
			if not button.glow.FlashAnim:IsPlaying() then button.glow.FlashAnim:Play() end
		else
			button.glow.FlashAnim:Stop()
			button.glow:Hide()
		end
	end
	function module:SelectWindow(id)
		local state = self.active[id]
		if not state then return false end
		if InCombat() and state.frame:IsProtected() then return false end
		local previous = self.active[self.db.char.selected]
		if previous and previous ~= state then Deactivate(previous.frame) end
		self.db.char.selected = id
		state.unread = nil
		self:Layout()
		SELECTED_CHAT_FRAME = state.frame
		LastActive(state.frame)
		FCF_StopAlertFlash(state.frame)
		FCF_FadeInChatFrame(state.frame)
		return true
	end
	function module:MoveWindow(id, delta)
		if InCombat() then return end
		local entry, index = self:GetEntry(id)
		if not entry then return end
		local target = index + delta
		if target < 1 or target > #self.db.char.members then return end
		table.remove(self.db.char.members, index)
		table.insert(self.db.char.members, target, entry)
		self:Layout()
	end
	function module:LayoutContents()
		if self.applying then return end
		self.applying = true
		local width, height = self.group:GetSize()
		self.resize:SetShown(not self.db.char.locked)
		local x, row = 0, 0
		for _, entry in ipairs(self.db.char.members) do
			local state = self.active[entry.id]
			if state then
				local frame, button = state.frame, state.button
				local scale = frame:GetScale()
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMLEFT", self.group, "BOTTOMLEFT", 0, 0)
				frame:SetSize(width / scale, height / scale)
				self:UpdateTab(state)
				button.label:SetWidth(0)
				local tabWidth = math.min(width, 160, math.max(64, button.label:GetStringWidth() + 20))
				if x > 0 and x + tabWidth > width then x, row = 0, row + 1 end
				button:ClearAllPoints()
				button:SetPoint("BOTTOMLEFT", self.group, "TOPLEFT", x, 3 + row * (TAB_HEIGHT - 4))
				button:SetWidth(tabWidth)
				button.label:SetWidth(tabWidth - 20)
				x = x + tabWidth + GAP
				state.holder:SetShown(self.db.char.selected == entry.id)
			end
		end
		self.group:SetClampRectInsets(0, -20, (row + 1) * TAB_HEIGHT + 3, -30)
		self.applying = nil
	end
	function module:Layout()
		if not self.group or self.applying or self.moving then return end
		local db = self.db.char
		local root = FCF_GetCurrentFullScreenFrame and FCF_GetCurrentFullScreenFrame() or UIParent
		self.group:SetParent(root)
		if not self.active[db.selected] then
			db.selected = db.members[1] and db.members[1].id or 0
		end
		self.group:ClearAllPoints()
		self.group:SetPoint(db.point, UIParent, db.point, db.x, db.y)
		self.group:SetSize(db.width, db.height)
		self:LayoutContents()
		self.group:SetShown(self:IsEnabled() and next(self.active) ~= nil)
	end
	function module:QueueLayout()
		if self.pending or self.applying or not self:IsEnabled() then return end
		self.pending = true
		C_Timer.After(0, function()
			self.pending = nil
			if self:IsEnabled() then self:Layout() end
		end)
	end
	function module:Release(id, restore, closed)
		local state = self.active[id]
		if not state then return end
		self.active[id] = nil -- let our SetParent hooks retire before restoration
		local frame, tab, saved = state.frame, NativeTab(state.frame), state.entry.restore
		self:Unhook(frame, "SetParent")
		self:Unhook(frame, "AddMessage")
		self:Unhook(tab, "SetParent")
		Deactivate(frame)
		local root = FCF_GetCurrentFullScreenFrame and FCF_GetCurrentFullScreenFrame() or state.parent or UIParent
		frame:SetParent(root)
		tab:SetParent(frame.isDocked and (state.tabParent or UIParent) or UIParent)
		for _, control in ipairs(state.controls) do
			self:Unhook(control.frame, "SetParent")
			control.frame:SetParent(control.parent)
		end
		state.button.glow.FlashAnim:Stop()
		state.button:Hide()
		state.holder:Hide()
		if restore and saved then
			frame:ClearAllPoints()
			for _, point in ipairs(saved.points) do
				frame:SetPoint(point[1], _G[point[2]] or UIParent, point[3], point[4], point[5])
			end
			frame:SetSize(saved.width, saved.height)
			FCF_SetLocked(frame, saved.locked)
			if saved.dockIndex then
				local index = saved.dockIndex
				for position, docked in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)) do
					if docked:GetID() == saved.dockBefore then index = position + 1 end
					if docked:GetID() == saved.dockAfter then index = position; break end
				end
				FCF_DockFrame(frame, index)
			end
		end
		if not closed then
			SetChatWindowShown(id, true)
			if frame.isDocked then FCF_DockUpdate() else frame:Show(); tab:Show(); FCF_SetTabPosition(frame, 0) end
		end
		if SELECTED_CHAT_FRAME == frame then
			SELECTED_CHAT_FRAME = FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) or DEFAULT_CHAT_FRAME
			LastActive(SELECTED_CHAT_FRAME)
		end
	end
	function module:RemoveWindow(id, closed, docked)
		if InCombat() and not closed and not docked then return end
		local _, index = self:GetEntry(id)
		if not index then return end
		table.remove(self.db.char.members, index)
		self:Release(id, not closed and not docked, closed)
		self:Layout()
		self:Notify()
	end
	function module:OnWindowClosed(frame, fallback)
		frame = fallback or frame or (FCF_GetCurrentChatFrame and FCF_GetCurrentChatFrame())
		if frame and self.active[frame:GetID()] then
			-- Closing a window under a hidden holder may not fire its native OnHide.
			SetChatWindowShown(frame:GetID(), false)
			self:RemoveWindow(frame:GetID(), true)
		end
	end
	function module:OnWindowDocked(frame)
		if frame and self.active[frame:GetID()] and frame.isDocked then self:RemoveWindow(frame:GetID(), false, true) end
	end
	function module:OnWindowRenamed(frame)
		local entry = frame and self.active[frame:GetID()] and self:GetEntry(frame:GetID())
		if entry then entry.name = WindowInfo(frame:GetID()); self:QueueLayout() end
	end
	function module:RestoreMembers()
		if InCombat() then self.restorePending = true; return end
		self.restorePending = nil
		-- Drop stale IDs instead of taking over a different window in a recycled slot.
		local seen = {}
		for i = #self.db.char.members, 1, -1 do
			local entry = self.db.char.members[i]
			local name, shown, _, docked = WindowInfo(entry.id)
			if seen[entry.id] or not self:CanUse(entry.id) or name ~= entry.name or not (shown or docked) then
				table.remove(self.db.char.members, i)
			else
				seen[entry.id] = true
			end
		end
		for _, entry in ipairs(self.db.char.members) do self:Attach(entry) end
		self:Layout()
	end
	function module:PLAYER_ENTERING_WORLD()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		-- Let Prat Memory and Blizzard's chat restoration finish first.
		C_Timer.After(0, function() if self:IsEnabled() then self:RestoreMembers() end end)
	end
	function module:PLAYER_REGEN_DISABLED()
		self:StopMoving()
	end
	function module:PLAYER_REGEN_ENABLED()
		if self.restorePending then self:RestoreMembers() end
		self:Layout()
	end
	function module:PLAYER_LOGOUT()
		-- Persist ordinary Blizzard windows as a fallback if the companion is
		-- disabled/deleted on the next launch. Keep our membership for reattachment.
		self:OnModuleDisable()
	end
	function module:OnModuleEnable()
		self.active = {}
		self:CreateGroup()
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_LOGOUT")
		self:SecureHook("FCF_Close", "OnWindowClosed")
		self:SecureHook("FCF_DockFrame", "OnWindowDocked")
		self:SecureHook("FCF_SetWindowName", "OnWindowRenamed")
		self:SecureHook("FCF_RestorePositionAndDimensions", "QueueLayout")
		self:SecureHook("FloatingChatFrame_Update", "QueueLayout")
		for _, name in ipairs({ "FCF_UpdateChatFrameParent", "FCF_SetFullScreenFrame", "FCF_ClearFullScreenFrame" }) do
			if type(_G[name]) == "function" then self:SecureHook(name, "QueueLayout") end
		end
		if IsLoggedIn() then self:PLAYER_ENTERING_WORLD() end
	end
	function module:OnModuleDisable()
		self:StopMoving()
		-- Retain saved membership so re-enabling restores the group.
		local ids = {}
		for id in pairs(self.active or {}) do ids[#ids + 1] = id end
		for _, id in ipairs(ids) do self:Release(id, true) end
		self:UnhookAll()
		self:UnregisterAllEvents()
		if self.group then self.group:Hide() end
	end
	Prat:SetModuleInit(module, function(self)
		self.active = {}
		self:RegisterChatCommand("pratgroup", "OpenOptions")
	end)
end)
