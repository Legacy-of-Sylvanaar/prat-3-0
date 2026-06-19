Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("Search")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			searchactivealpha = 1.0,
			searchinactivealpha = 0.1
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL.module_name,
		desc = PL.module_desc,
		type = "group",
		args = {
			info = {
				name = PL.module_info,
				type = "description",
				order = 10,
			},
			searchinactivealpha = {
				name = PL["unused_alpha"],
				type = "range",
				order = 20,
				min = 0,
				max = 1.0,
				step = 0.1,
			},
			searchactivealpha = {
				name = PL["used_alpha"],
				type = "range",
				order = 30,
				min = 0,
				max = 1.0,
				step = 0.1,
			},
		}
	})

	function module:StashSearch(frame)
		frame:SetAlpha(self.db.profile.searchinactivealpha)
		frame:SetWidth(30)
	end

	function module:UnstashSearch(frame)
		frame:SetAlpha(self.db.profile.searchactivealpha)
		frame:SetWidth(130)
	end

	function module:CreateSearchBox(chatFrame)
		local name = chatFrame:GetName()
		local f = CreateFrame("EditBox", name .. "ChatSearchEditBox", chatFrame, "SearchBoxTemplate")

		f:SetWidth(130)
		f:SetHeight(16)
		f:SetFrameStrata("HIGH")
		f:SetPoint("TOPRIGHT", chatFrame, "TOPRIGHT")
		f:SetScript("OnEnter", function()
			local hoverAlpha = self.db.profile.searchinactivealpha + (self.db.profile.searchactivealpha - self.db.profile.searchinactivealpha) / 2
			if f:HasFocus() then
				self:UnstashSearch(f)
			else
				f:SetAlpha(hoverAlpha)
			end
		end)
		f:SetScript("OnLeave", function()
			if f:HasFocus() then
				self:UnstashSearch(f)
			else
				self:StashSearch(f)
			end
		end)
		f:SetScript("OnEditFocusLost", function()
			self:StashSearch(f)
		end)
		f:SetScript("OnEditFocusGained", function()
			self:UnstashSearch(f)
		end)
		f:SetScript("OnEscapePressed", function()
			f:ClearFocus()
		end)
		f:SetScript("OnEnterPressed", function(frame)
			local query = f:GetText()
			if query and query:len() > 0 then
				module:Find(query, true, frame:GetParent())
			end
		end)
		f.anim = f:CreateAnimationGroup()
		f.anim.fade1 = f.anim:CreateAnimation("Alpha")
		f.anim.fade1:SetFromAlpha(self.db.profile.searchactivealpha)
		f.anim.fade1:SetDuration(3)
		f.anim.fade1:SetToAlpha(self.db.profile.searchinactivealpha)
		f.anim.fade1:SetSmoothing("IN")
		f.anim:SetScript("OnFinished", function()
			if f:HasFocus() then
				self:UnstashSearch(f)
			else
				self:StashSearch(f)
			end
		end)

		f.anim:Play()

		return f
	end

	Prat:SetModuleInit(module, function(self)
		self.searchBoxes = {}
	end)

	function module:Prat_FramesUpdated(_, name, chatFrame)
		if not self.searchBoxes[name] then
			self.searchBoxes[name] = self:CreateSearchBox(chatFrame)
		end
	end

	function module:OnModuleEnable()
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)

		for name, frame in pairs(Prat.HookedFrames) do
			if not self.searchBoxes[name] then
				self.searchBoxes[name] = self:CreateSearchBox(frame)
			end
		end

		for _, f in pairs(self.searchBoxes) do
			f:Show()
		end
	end

	function module:OnModuleDisable()
		for _, f in pairs(self.searchBoxes) do
			f:Hide()
		end
	end

	SLASH_FIND1 = "/find"
	SlashCmdList["FIND"] = function(msg)
		module:Find(msg, true)
	end

	local foundlines = {}
	local scrapelines = {}

	local CLR = Prat.CLR
	local function SearchTerm(term)
		return CLR:Colorize("ffff40", term)
	end

	function module:Find(word, all, frame)
		if not self.db.profile.on then
			return
		end

		if frame == nil then
			frame = SELECTED_CHAT_FRAME
		end

		if not word then
			return
		end

		if #word <= 1 then
			frame:ScrollToBottom()
			self:Output(frame, PL.err_tooshort)
			return
		end

		if frame:GetNumMessages() == 0 then
			frame:ScrollToBottom()
			self:Output(frame, PL.err_notfound)
			return
		end

		self.lastsearch = word

		self:ScrapeFrame(frame, nil, true)

		for _, v in ipairs(scrapelines) do
			if v.message and v.message:find(Prat:CaseInsensitveWordPattern(word)) then
				if all then
					table.insert(foundlines, v)
				else
					return
				end
			end
		end

		self.lastsearch = nil

		frame:ScrollToBottom()

		if all and #foundlines > 0 then
			self:Output(frame, "-------------------------------------------------------------")
			self:Output(frame, PL.find_results .. ": " .. SearchTerm(word))

			Prat.loading = true -- prevent double timestamp
			for _, v in ipairs(foundlines) do
				frame:AddMessage(v.message:gsub("|K.-|k", PL.bnet_removed), v.r, v.g, v.b)
			end
			Prat.loading = nil
			self:Output(frame, "-------------------------------------------------------------")
		else
			self:Output(frame, PL.err_notfound)
		end

		wipe(foundlines)
		wipe(scrapelines)
	end

	function module:ScrapeFrame(frame)
		wipe(scrapelines)

		for i = frame:GetNumMessages(), 1, -1 do
			local msg = frame.historyBuffer:GetEntryAtIndex(i)

			if msg and msg.message then
				table.insert(scrapelines, msg)
			end
		end
	end

	return
end) -- Prat:AddModuleToLoad
