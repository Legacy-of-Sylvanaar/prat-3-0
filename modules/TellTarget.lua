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

local ChatFrame_SendTell = ChatFrame_SendTell or ChatFrameUtil.SendTell
local ChatEdit_UpdateHeader = ChatEdit_UpdateHeader or ChatFrameEditBoxMixin.UpdateHeader

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("TellTarget", "AceHook-3.0")
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["TellTarget"],
		desc = PL["Adds telltarget slash command (/tt)."],
		type = "group",
		args = {
			info = {
				name = PL["Adds telltarget slash command (/tt)."],
				type = "description",
			}
		}
	})

	function module:OnModuleEnable()
		self.useProcessChatType = ChatFrame1EditBox and type(ChatFrame1EditBox.ProcessChatType) == "function"
		if self.useProcessChatType then
			local whisper = ChatTypeInfo.WHISPER
			ChatTypeInfo["PRAT_TELLTARGET"] = {
				r = whisper.r,
				g = whisper.g,
				b = whisper.b,
				sticky = 0,
				ignoreChatTypeProcessing = nil
			}
			_G["CHAT_PRAT_TELLTARGET_SEND"] = PL["TellTarget"] .. ": "
			_G["SLASH_PRAT_TELLTARGET1"] = "/tt"
			if PL["/tt"] ~= "/tt" then
				_G["SLASH_PRAT_TELLTARGET2"] = PL["/tt"]
			end
		end

		for _, frameName in ipairs(CHAT_FRAMES) do
			self:HookEditBox(_G[frameName .. "EditBox"])
		end
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	function module:OnModuleDisable()
		self:UnhookAll()
		Prat.UnregisterAllChatEvents(self)
	end

	function module:GetDescription()
		return PL["Adds telltarget slash command (/tt)."]
	end

	function module:HookEditBox(editBox)
		if not editBox then
			return
		end
		if self.useProcessChatType then
			if editBox.ProcessChatType and not self:IsHooked(editBox, "ProcessChatType") then
				self:SecureHook(editBox, "ProcessChatType", "ProcessChatType")
			end
		elseif not self:IsHooked(editBox, "OnTextChanged") then
			self:SecureHookScript(editBox, "OnTextChanged")
		end
	end

	function module:Prat_FramesUpdated(_, _, chatFrame)
		self:HookEditBox(chatFrame.editBox)
	end

	function module:ProcessChatType(editBox, msg, index)
		if index == "PRAT_TELLTARGET" then
			self:SendTellToTarget(editBox.chatFrame, msg, editBox)
		end
	end

	function module:OnTextChanged(editBox)
		local command, msg = editBox:GetText():match("^(/%S+)%s(.*)$")
		if command == "/tt" or command == PL["/tt"] then
			self:SendTellToTarget(editBox.chatFrame, msg, editBox)
		end
	end

	local function GetTargetName(unit)
		return Prat.IsForever and GetUnitName(unit) or UnitName(unit)
	end

	local function GetTargetServer(unit)
		if Prat.IsForever then
			return
		end
		local _, realm = UnitName(unit)
		return realm
	end

	function module:SendTellToTarget(frame, text, editBox)
		if frame == nil then
			frame = DEFAULT_CHAT_FRAME
		end

		local unitname, realm, fullname
		if UnitIsPlayer("target") then
			unitname, realm = GetTargetName("target"), GetTargetServer("target")
			if unitname then
				if realm and UnitRealmRelationship("target") ~= LE_REALM_RELATION_SAME then
					fullname = unitname .. "-" .. realm
				else
					fullname = unitname
				end
			end
		end

		local target = fullname or PL["NoTarget"]

		if editBox then
			editBox:SetAttribute("chatType", "WHISPER")
			editBox:SetAttribute("tellTarget", target)
			editBox:SetText(text)
			ChatEdit_UpdateHeader(editBox)
		else
			ChatFrame_SendTell(target, frame)
		end
	end
end)
