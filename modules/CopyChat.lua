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

local issecretvalue = issecretvalue or function() return false end

local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow or _G.ChatFrameUtil.GetActiveWindow
local ChatEdit_ChooseBoxForSend = _G.ChatEdit_ChooseBoxForSend or _G.ChatFrameUtil.ChooseBoxForSend

local ChatFrame_OpenChat = _G.ChatFrame_OpenChat or _G.ChatFrameUtil.OpenChat
local StripHyperlinks = _G.StripHyperlinks or _G.C_StringUtil.StripHyperlinks

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("CopyChat", "AceHook-3.0", "AceTimer-3.0")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			showbutton = { ["*"] = true },
			buttonpos = "TOPLEFT",
			copyformat = "plain",
			copytimestamps = true,
			activealpha = 0.9,
			inactivealpha = 0.2,
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["CopyChat"],
		desc = PL["Copy text from the active chat window."],
		type = "group",
		args = {
			showbutton = {
				name = PL["showbutton_name"],
				desc = PL["showbutton_desc"],
				type = "multiselect",
				values = Prat.FrameList,
				get = "GetSubValue",
				set = "SetSubValue"
			},
			buttonpos = {
				name = PL.buttonpos_name,
				desc = PL.buttonpos_desc,
				type = "select",
				order = 195,
				get = "GetValue",
				set = "SetValue",
				values = {
					["TOPLEFT"] = PL.TOPLEFT,
					["TOPRIGHT"] = PL.TOPRIGHT,
					["BOTTOMLEFT"] = PL.BOTTOMLEFT,
					["BOTTOMRIGHT"] = PL.BOTTOMRIGHT
				},
			},
			copy = {
				name = PL["Copy Text"],
				desc = PL["Copy all of the text in the selected chat frame into an edit box"],
				type = "execute",
				order = 190,
				func = function()
					module:DoCopyChat(SELECTED_CHAT_FRAME)
				end
			},
			copyformat = {
				name = PL["Copy Text Format"],
				desc = PL["Should the copied text be plain, or formatted so you can see the colors."],
				type = "select",
				order = 195,
				get = "GetValue",
				set = "SetValue",
				values = { ["plain"] = PL["Plain"], ["bbcode"] = PL["BBCode"], ["html"] = PL["HTML"], ["wowace"] = PL["Wowace.com Forums"] },
			},
			copytimestamps = {
				name = PL.copytimestamps_name,
				desc = PL.copytimestamps_desc,
				type = "toggle",
				order = 200,
			},
			activealpha = {
				name = PL["activealpha"],
				type = "range",
				order = 210,
				min = 0,
				max = 1.0,
				step = 0.1,
			},
			inactivealpha = {
				name = PL["inactivealpha"],
				type = "range",
				order = 220,
				min = 0,
				max = 1.0,
				step = 0.1,
			},
		}
	})

	local PratCCFrame, PratCCText, PratCCFrameScrollText
	Prat:SetModuleInit(module.name, function(self)
		self:CreateCopyFrame()

		PratCCFrameScrollText:SetScript("OnTextChanged", function(this)
			self:OnTextChanged(this)
		end)
		PratCCFrameScrollText:SetScript("OnEscapePressed", function()
			PratCCFrame:Hide()
			self.str = nil
		end)

		Prat.RegisterChatCommand("copychat", function()
			local frame = SELECTED_CHAT_FRAME
			if frame then
				self:DoCopyChat(frame)
			end
		end)

		Prat.RegisterLinkType({ linkid = "pratcopy", linkfunc = self.CopyLink, handler = module }, self.name)

		module.timestamps = Prat:GetModule("Timestamps")

		if self.timestamps then
			self:RawHook(self.timestamps, "GetTime")
		end
	end)

	function module:OnModuleEnable()
		self.buttons = {}
		for k, v in pairs(Prat.Frames) do
			self.buttons[k] = self:MakeReminder(v:GetID())
			self:showbutton(k, self.db.profile.showbutton[k])
		end

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	function module:GetDescription()
		return PL["Copy text from the active chat window."]
	end

	function module:Prat_FramesUpdated(_, _, chatFrame)
		local id = chatFrame:GetID()
		self.buttons[id] = self:MakeReminder(id)
		self:showbutton(id, self.db.profile.showbutton[1])
	end

	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
		self:hidebuttons()
		PratCCFrame:Hide()
	end

	local function CleanText(text)
		text = text:gsub("|K.-|k", "???")
		return StripHyperlinks(text, false, true)
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	function module:CopyLink(_, frame)
		if frame and self.db.profile.on and self.db.profile.copytimestamps then
			for _, visibleLine in ipairs(frame.visibleLines) do
				local isMouseOver = visibleLine:IsMouseOver()
				if not issecretvalue(isMouseOver) and isMouseOver then
					local info = visibleLine.messageInfo
					if info and info.message then
						local text = issecretvalue(info.message) and "<SECRET>" or CleanText(info.message)
						local editBox = ChatEdit_ChooseBoxForSend(frame);

						if editBox ~= ChatEdit_GetActiveWindow() then
							ChatFrame_OpenChat(text, frame);
						else
							editBox:SetText(text);
						end
					end
					return false
				end
			end
		end

		return false
	end

	function module:GetTime(...)
		local stamp = self.hooks[self.timestamps].GetTime(...)
		if module.db.profile.on and module.db.profile.copytimestamps then
			return "|Hpratcopy|h" .. stamp .. "|h"
		end

		return stamp
	end

	module.str = nil

	function module:GetFormattedLine(line, r, g, b)
		local fmt = self.db.profile.copyformat
		local CLR = Prat.CLR

		line = line:gsub("|c00000000|r", "")

		if fmt == "plain" then
			return line
		end

		if fmt == "bbcode" or fmt == "wowace" then
			local fline = line:gsub("|c[fF][fF](%w%w%w%w%w%w)", "[color=#%1]"):gsub("|r", "[/color]")
			return "[color=#" .. CLR:GetHexColor(r, g, b) .. "]" .. fline .. "[/color]"
		end

		if fmt == "html" then
			local fline = line:gsub("|c[fF][fF](%w%w%w%w%w%w)", "<font color='#%1'>"):gsub("|r", "</font>")
			return "<p><font color='#" .. CLR:GetHexColor(r, g, b) .. "' face='monospace'>" .. fline .. "</font></p>"
		end
	end

	function module:DoCopyChat(frame)
		local lines = {}
		for i = 1, frame:GetNumMessages() do
			local msg = frame:GetMessageInfo(i)

			if msg then
				if issecretvalue(msg) then
					lines[#lines + 1] = "<SECRET>"
				else
					lines[#lines + 1] = CleanText(msg)
				end
			end
		end

		local str = table.concat(lines, "\n")
		if self.db.profile.copyformat == "wowace" then
			str = "[bgcolor=black]" .. str .. "[/bgcolor]"
		end
		self.str = str
		PratCCFrameScrollText:SetText(str or "")
		PratCCText:SetText(PL["ChatFrame"] .. frame:GetName():gsub("ChatFrame", "") .. PL[" Text"])
		PratCCFrame:Show()
	end

	function module:CopyChat() -- Used by bindings
		module:DoCopyChat(SELECTED_CHAT_FRAME)
	end

	function module:OnTextChanged(this)
		if self.str and this:GetText() ~= self.str then
			this:SetText(self.str)
		end
		this:GetParent():UpdateScrollChildRect()
		local _, m = PratCCFrameScrollScrollBar:GetMinMaxValues()
		if m > 0 and this.max ~= m then
			this.max = m
			PratCCFrameScrollScrollBar:SetValue(m)
		end
	end

	function module:hidebuttons()
		for _, v in pairs(self.buttons) do
			v:Hide()
		end
	end

	function module:showbutton(id, show)
		local b = self.buttons[id]
		if show then
			b:Show()
		else
			b:Hide()
		end
	end

	do
		local function reminderOnClick(self)
			PlaySound(SOUNDKIT.IG_CHAT_BOTTOM);
			module:DoCopyChat(self:GetParent())
		end

		local function reminderOnEnter(self)
			self:SetAlpha(module.db.profile.activealpha)
		end

		local function reminderOnLeave(self)
			self:SetAlpha(module.db.profile.inactivealpha)
		end

		function module:MakeReminder(id)
			local cf = _G["ChatFrame" .. id]
			local name = "ChatFrame" .. id .. "PratCCReminder"
			local b = _G[name]
			if not b then
				b = CreateFrame("Button", name, cf)
				b:SetFrameStrata("MEDIUM")
				b:SetWidth(24)
				b:SetHeight(24)
				b:SetNormalTexture("Interface\\Addons\\Prat-3.0\\textures\\prat-chatcopy2")
				b:SetPushedTexture("Interface\\Addons\\Prat-3.0\\textures\\prat-chatcopy")
				b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
				b:SetPoint(self.db.profile.buttonpos, cf, self.db.profile.buttonpos, 0, 0)
				b:SetScript("OnClick", reminderOnClick)
				b:SetScript("OnEnter", reminderOnEnter)
				b:SetScript("OnLeave", reminderOnLeave)
				b:SetAlpha(module.db.profile.inactivealpha)
				b:RegisterForClicks("AnyUp")
				b:Hide()
			end

			return b
		end
	end

	function module:OnValueChanged()
		for k, v in pairs(Prat.Frames) do
			local cf = _G["ChatFrame" .. v:GetID()]
			local btn = self.buttons[k]
			btn:ClearAllPoints()
			btn:SetPoint(self.db.profile.buttonpos, cf, self.db.profile.buttonpos, 0, 0)
			btn:SetAlpha(module.db.profile.inactivealpha)
		end
	end

	function module:CreateCopyFrame()
		PratCCFrame = CreateFrame("Frame", "PratCCFrame", UIParent, "DialogBoxFrame,BackdropTemplate")
		PratCCFrame:SetSize(500, 400)
		PratCCFrame:SetMovable(true)
		PratCCFrame:EnableMouse(true)
		PratCCFrame:SetClampedToScreen(true)
		PratCCFrame:RegisterForDrag("LeftButton")
		PratCCFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 },
		})
		PratCCFrame:SetScript("OnDragStart", function(frame)
			frame:StartMoving()
		end)
		PratCCFrame:SetScript("OnDragStop", function(frame)
			frame:StopMovingOrSizing()
		end)

		PratCCText = PratCCFrame:CreateFontString("PratCCText", "ARTWORK", "GameFontHighlight")
		PratCCText:SetPoint("TOPLEFT", PratCCFrame, "TOPLEFT", 5, -5)

		local PratCCFrameScroll = CreateFrame("ScrollFrame", "PratCCFrameScroll", PratCCFrame, "UIPanelScrollFrameTemplate")
		PratCCFrameScroll:SetToplevel(true)
		PratCCFrameScroll:SetSize(455, 330)
		PratCCFrameScroll:SetPoint("TOP", PratCCFrame, "TOP", -10, -30)
		PratCCFrameScroll:SetPoint("BOTTOM", _G["PratCCFrameButton"], "TOP", 0, 5)

		PratCCFrameScrollText = CreateFrame("EditBox", "PratCCFrameScrollText", PratCCFrameScroll)
		PratCCFrameScrollText:SetSize(450, 344)
		PratCCFrameScrollText:SetMultiLine(true)
		PratCCFrameScrollText:SetAutoFocus(true)
		PratCCFrameScrollText:EnableMouse(true)
		PratCCFrameScrollText:SetMaxLetters(999999)
		PratCCFrameScrollText:SetFontObject("ChatFontNormal")

		PratCCFrameScroll:SetScrollChild(PratCCFrameScrollText)
	end
end)
