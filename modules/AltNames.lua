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

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("AltNames", "AceHook-3.0", "AceEvent-3.0")
	local PL = module.PL

	local altregistry

	module.Alts = {}

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			quiet = false,
			pncol = 'no',
			altidx = {},
			mainpos = 'RIGHT',
			colour = { r = 0, g = 0, b = 0 },
			maincolour = '97ff4c', -- fairly light bright green
			altcolour = 'ff6df2', -- fairly bright light purpley pinkish
			noclobber = false,
			tooltip_showmain = false,
			tooltip_showalts = false,
			usealtlib = true,
			autoguildalts = false,
		},
		realm = {
			alts = {},
		}
	})

	Prat:SetModuleInit(module, function(self)
		altregistry = LibStub("LibAlts-1.0")

		if self.db.profile.alts then
			local alts = self.db.profile.alts
			self.db.profile.alts = nil
			for k, v in pairs(alts) do
				self.db.realm.alts[k] = self.db.realm.alts[k] or v
			end
		end

		-- Load shared Alts data
		for alt, main in pairs(self.db.realm.alts) do

			altregistry:SetAlt(main, alt, "Prat")
		end



		-- define a popup to get the main name
		StaticPopupDialogs['MENUITEM_LINKALT'] = {
			-- text		= "Who would you like to set as the main character of %s?",
			text = 'Mainname',
			button1 = ACCEPT,
			button2 = CANCEL,
			hasEditBox = 1,
			maxLetters = 24,
			exclusive = 0,
			preferredIndex = 3,
			OnAccept = function(this, altname)
				module:addAlt(this.editBox:GetText(), altname)
			end,
			OnShow = function(this)
				this.editBox:SetFocus();
			end,
			OnHide = function(this)
				if (this.editBox:IsShown()) then
					this.editBox:SetFocus();
				end
				_G[this:GetName() .. "EditBox"]:SetText("");
			end,
			EditBoxOnEnterPressed = function(this, altname)
				local parent = this:GetParent()
				module:addAlt(parent.editBox:GetText(), altname)
				parent:Hide()
			end,
			EditBoxOnEscapePressed = function(this)
				this:GetParent():Hide()
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1
		}
	end)

	Prat:SetModuleOptions(module, {
		name = PL["AltNames"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			find = {
				name = PL["Find characters"],
				desc = PL["Search the list of linked characters for matching main or alt names."],
				type = "input",
				usage = PL["<search term> (eg, /altnames find fin)"],
				order = 110,
				set = function(info, q)
					info.handler:findChars(q)
				end,
				get = false,
			},
			listalts = {
				name = PL['List alts'],
				desc = PL['List alts for a given character'],
				type = 'input',
				usage = PL['<main> (eg /altnames listalts Fin)'],
				order = 115,
				set = function(info, m)
					info.handler:listAlts(m)
				end,
				get = false,
			},
			link = {
				name = PL["Link alt"],
				desc = PL["Link someone's alt character with the name of their main."],
				type = "input",
				order = 120,
				usage = PL["link <alt name> <main name> (eg, /altnames link Fin Finjathealtoffin)"],
				set = function(info, argstr)
					local mainname, altname = argstr:match('(%S+)%s+(%S+)')
					info.handler:addAlt(mainname, altname)
				end,
				get = false,
			},
			del = {
				name = PL["Delete alt"],
				desc = PL["Delete a character's link to another character as their main."],
				type = "input",
				usage = PL["<alt name> (eg, /altnames del Personyouthoughtwassomeonesaltbutreallyisnt)"],
				order = 130,
				set = function(info, altname)
					info.handler:delAlt(altname)
				end,
				get = false,
				confirm = true,
			},
			quiet = {
				name = PL["Be quiet"],
				desc = PL["Whether to report to the chat frame or not."],
				type = "toggle",
				order = 191,
			},
			listall = {
				name = PL["List all"],
				desc = PL["List all links between alts and their main names."],
				type = "execute",
				func = "listAll",
			},
			clearall = {
				name = PL["Clear all"],
				desc = PL["Clear all links between alts and main names."],
				type = "execute",
				func = "clearAllAlts",
				confirm = true,
			},
			fixalts = {
				name = PL["Fix alts"],
				desc = PL["Fix corrupted entries in your list of alt names."],
				type = "execute",
				func = "fixAlts",
			},
			colour = {
				name = PL["Colour"],
				get = function(info)
					return info.handler:getColour()
				end,
				set = function(info, nr, ng, nb, na)
					info.handler.db.profile.colour = { r = nr, g = ng, b = nb, a = na }
				end,
				desc = PL["The colour of an alt's main name that will be displayed"],
				type = "color",
				order = 60,
				disabled = function(info)
					return info.handler.db.profile.pncol ~= 'no'
				end
			},
			pncol = {
				name = PL["Class colour"],
				desc = PL["Use class colour (from the PlayerNames module)"],
				type = "select",
				get = function(info)
					return info.handler.db.profile.pncol
				end,
				set = function(info, v)
					info.handler.db.profile.pncol = v
				end,
				order = 55,
				values = {
					['main'] = PL["use class colour of main"],
					['alt'] = PL["use class colour of alt"],
					['no'] = PL["don't use"],
				},
			},
			mainpos = {
				name = PL["Main name position"],
				desc = PL["Where to display a character's main name when on their alt."],
				type = "select",
				order = 50,
				get = function(info)
					return info.handler.db.profile.mainpos
				end,
				set = function(info, v)
					info.handler:setMainPos(v)
				end,
				values = {
					["LEFT"] = PL["Left"],
					["RIGHT"] = PL["Right"],
					["START"] = PL["Start"],
				},
			},
			tooltip_showmain = {
				name = PL['Show main in tooltip'],
				desc = PL["Display a player's main name in the tooltip"],
				type = 'toggle',
				order = 150,
				get = function(info)
					return info.handler.db.profile.tooltip_showmain
				end,
				set = function(info)
					info.handler.db.profile.tooltip_showmain = not info.handler.db.profile.tooltip_showmain
					info.handler.altertooltip = info.handler.db.profile.tooltip_showalts or info.handler.db.profile.tooltip_showmain

					info.handler:HookTooltip()
				end,
			},
			tooltip_showalts = {
				name = PL['Show alts in tooltip'],
				desc = PL["Display a player's alts in the tooltip"],
				type = 'toggle',
				order = 150,
				get = function(info)
					return info.handler.db.profile.tooltip_showalts
				end,
				set = function(info)
					info.handler.db.profile.tooltip_showalts = not info.handler.db.profile.tooltip_showalts
					info.handler.altertooltip = info.handler.db.profile.tooltip_showalts or info.handler.db.profile.tooltip_showmain

					info.handler:HookTooltip()
				end,
			},
			noclobber = {
				name = PL["Don't overwrite existing links"],
				desc = PL["Don't overwrite existing alt <-> main links when importing or adding new alts."],
				type = "toggle",
				order = 192,
			},
			importheader = {
				name = PL["Import options"],
				desc = PL["Various ways to import a main's alts from other addons"],
				type = 'header',
				order = 500,
			},
			importfromlok = {
				name = PL["LOKWhoIsWho import"],
				desc = PL["Imports data from LOKWhoIsWho, if present (drop your SavedVariables\\LOKWhoIsWho.lua in the Prat directory to be able to use this)."],
				type = "execute",
				func = "importFromLOK",
				confirm = true,
				order = 560,
			},
			guildimport = {
				name = PL["Import from guild roster"],
				desc = PL['Imports alt names from the guild roster by checking for members with the rank "alt" or "alts", or guild / officer notes like "<name>\'s alt"'],
				type = "execute",
				func = "importGuildAlts",
				confirm = true,
				order = 520,
			},
			ggimport = {
				name = PL['Import from Guild Greet database'],
				desc = PL['Imports alt names from a Guild Greet database, if present'],
				type = 'execute',
				func = "importGGAlts",
				confirm = true,
				order = 550,
			},
			usealtlib = {
				name = PL["Use LibAlts Data"],
				desc = PL["Use the data available via the shared alt information library."],
				type = "toggle",
				order = 540,
			},
			autoguildalts = {
				name = PL["autoguildalts_name"],
				desc = PL["autoguildalts_desc"],
				type = "toggle",
				order = 540,
			},
		}
	})

	function module:OnModuleEnable()
		for altname, mainname in pairs(self.db.realm.alts) do
			self.Alts[altname] = mainname
		end

		local pncol = self.db.profile.pncol
		if pncol == 'no' then
			self.db.profile.pncol = false
		end

		self.db.profile.pncol = self.db.profile.pncol or false
		self.Altlists = {}
		self.ALTNAMES = ""

		self:setMainPos(self.db.profile.mainpos)

		Prat.RegisterChatEvent(self, "Prat_PreAddMessage")

		self.altertooltip = self.db.profile.tooltip_showmain or self.db.profile.tooltip_showalts

		self:HookTooltip()

		if not self.menusAdded then
			self.menusAdded = true
		end

		if self.db.profile.autoguildalts then
			self:AutoImportGuildAlts(true)
		end

		altregistry.RegisterCallback(self, "LibAlts_SetAlt", function(_, mainname, altname)
			self:addAlt(mainname, altname, true)
		end)
		altregistry.RegisterCallback(self, "LibAlts_RemoveAlt", function(_, _, altname)
			self:delAlt(altname, true)
		end)
	end

	function module:AutoImportGuildAlts(b)
		if b then
			self:RegisterEvent("GUILD_ROSTER_UPDATE", function()
				module:importGuildAlts(nil, true)
			end)
			C_GuildInfo.GuildRoster()
		else
			self:UnregisterEvent("GUILD_ROSTER_UPDATE")
		end
	end

	function module:OnValueChanged(info, b)
		local field = info[#info]
		if field == "autoguildalts" then
			self:AutoImportGuildAlts(b)
		end
	end

	local function NOP()
		return
	end

	function module:HookTooltip()
		if self.altertooltip then
			if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
				TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip, data)
					if tooltip == GameTooltip and self.altertooltip then
						local unitid = UnitTokenFromGUID(data.guid)
						if (not issecretvalue or not issecretvalue(unitid)) and UnitIsPlayer(unitid) then
							self:ModifyUnitTooltip(unitid)
						end
					end
				end)
			else
				self:SecureHookScript(GameTooltip, 'OnTooltipSetUnit', function()
					if self.altertooltip and not self.showingtooltip then
						-- check who / what the tooltip's being displayed for
						local _, unitid = GameTooltip:GetUnit()
						self:ModifyUnitTooltip(unitid)
					end
				end)
				self:SecureHookScript(GameTooltip, 'OnTooltipCleared', function()
					-- got to reset the flag so we know when to readd the lines
					self.showingtooltip = false
				end)
			end

			module.HookTooltip = NOP
		end
	end


	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
		altregistry.UnregisterAllCallbacks(self)
	end

	function module:print(msg, printanyway)
		if msg == nil then
			printanyway = true
			msg = PL['ERROR: some function sent a blank message!']
		end

		local verbose = (not self.db.profile.quiet)

		if (not self.silent) and (verbose or printanyway) then
			self:Output(msg)
		end
	end

	local clrname = function(name, colour)
		return '|cff' .. (colour or 'ffffff') .. (name or "") .. '|r'
	end

	local clrmain = function(mainname, maincolour)
		mainname = mainname or ""
		maincolour = maincolour or module.db.profile.maincolour or '8080ff'
		return clrname(mainname, maincolour)
	end

	local clralt = function(altname, altcolour)
		altname = altname or ""
		altcolour = altcolour or module.db.profile.altcolour or 'ff8080'
		return clrname(altname, altcolour)
	end

	function module:formatCharName(name)
		if name == nil then
			return ""
		end

		name = name:gsub('[%%%[%]":|%s]', '')
		name = name:gsub("'", '')
		name = name:lower()
		name = name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)
		return name
	end

	function module:addAlt(mainname, altname, eventGenerated)
		if not altname or not mainname then
			return false
		end

		mainname = self:formatCharName(mainname)
		altname = self:formatCharName(altname)

		if self.Alts[altname] then
			local oldmain = self.Alts[altname]

			if oldmain == mainname then
				self:print(string.format(PL['warning: alt %s already linked to %s'], clralt(altname), clrmain(mainname)))
				return false
			end

			if self.db.profile.noclobber then
				self:print(string.format(PL['alt name exists: %s -> %s; not overwriting as set in preferences'], clralt(altname), clrmain(oldmain)))
				return false
			end

			self:print(string.format(PL['warning: alt %s already linked to %s'], clralt(altname), clrmain(oldmain)))
		end

		self.Alts[altname] = mainname
		self.db.realm.alts[altname] = mainname

		if self.Altlists[mainname] then
			self.Altlists[mainname] = nil
		end

		if not eventGenerated then
			altregistry:SetAlt(mainname, altname, "Prat")
		end

		self:print(string.format(PL["linked alt %s => %s"], clralt(altname), clrmain(mainname)))
	end

	function module:delAlt(altname, eventGenerated)
		local suPLiedaltname = altname

		altname = self:formatCharName(altname)

		if self.Alts[altname] then
			local mainname = self.Alts[altname]
			self.Alts[altname] = nil
			self.db.realm.alts[altname] = nil

			self:print(string.format(PL["character removed: %s"], clralt(suPLiedaltname)))

			if self.Altlists[mainname] then
				self.Altlists[mainname] = nil
			end

			if not eventGenerated then
				altregistry:DeleteAlt(mainname, altname, "Prat")
			end

			return true
		end

		self:print(string.format(PL['no characters called "%s" found; nothing deleted'], clralt(suPLiedaltname)))
	end

	function module:listAll()
		if not self.db.realm.alts and self.Alts then
			self:print(PL["You have not yet linked any alts with their mains."], true)
			return false
		end

		local altcount = 0

		for altname, mainname in pairs(self.Alts) do
			altcount = altcount + 1
			self:print(string.format("alt: %s => main: %s", clralt(altname), clrmain(mainname)))
		end

		self:print(string.format(PL['%s total alts linked to mains'], altcount))
	end

	function module:findChars(q)
		if not self.Alts then
			self:print(PL["You have not yet linked any alts with their mains."], true)
			return false
		else
			local matches = {}
			local numfound = 0

			for altname, mainname in pairs(self.Alts) do
				local a = string.lower(altname)
				local m = string.lower(mainname)
				local pat = string.lower(q)

				if (a == pat) or (m == pat) or (a:find(pat)) or (m:find(pat)) then
					matches[altname] = mainname
					numfound = numfound + 1
				end
			end

			if numfound == 0 then
				self:print(string.format(PL['no alts or mains found matching "%s"'], '|cffffb200' .. q .. '|r'), true)
			else
				for altname, mainname in pairs(matches) do
					self:print(string.format(PL["Found alt: %s => main: %s"], clralt(altname), clrmain(mainname)))
				end

				self:print(string.format(PL["searched for: %s - total matches: %s"], q, numfound))
			end

			return numfound
		end
	end

	function module:fixAlts()
		local fixedalts = {}

		for altname, mainname in pairs(self.db.realm.alts) do
			altname = self:formatCharName(altname)
			mainname = self:formatCharName(mainname)

			fixedalts[altname] = mainname
		end

		self.Alts = fixedalts
		self.db.realm.alts = fixedalts
	end

	function module:clearAllAlts()
		self.Alts = {}
		self.db.realm.alts = {}
		self.Altlists = {}
	end

	local CLR = Prat.CLR

	function module:setMainPos(pos)
		local msgitems = {
			RIGHT = 'Pp',
			LEFT = 'Ff',
			START = nil,
		}

		pos = pos or 'RIGHT'

		Prat.RegisterMessageItem('ALTNAMES', msgitems[pos])

		if pos == 'RIGHT' then
			self.padfmt = ' ' .. CLR:Colorize("ffffff", "(") .. "%s" .. CLR:Colorize("ffffff", ")")
		else
			self.padfmt = CLR:Colorize("ffffff", "(") .. "%s" .. CLR:Colorize("ffffff", ")") .. ' '
		end

		self.db.profile.mainpos = pos
	end

	local function isAlt(name)
		local alt = module.Alts[name]
		if alt then
			return alt
		end

		if altregistry and altregistry:IsAlt(name) then
			return altregistry:GetMain(name)
		end
	end

	local playernames
	function module:Prat_PreAddMessage(_, message)
		local hexcolour = CLR.NONE

		local mainname = message.PLAYERLINKRAW or ""

		local altname = isAlt(mainname) or isAlt(Ambiguate(mainname, "all"))

		if self.db.profile.on and altname then
			local padfmt = self.padfmt or ' (%s)'

			if self.db.profile.colour then
				if self.db.profile.pncol ~= 'no' then
					local charname
					local coltype = self.db.profile.pncol

					if coltype == "alt" then
						charname = mainname
					elseif coltype == "main" then
						charname = altname
					else
						charname = nil
						self.db.profile.pncol = 'no'
					end

					playernames = playernames or Prat:GetModule("PlayerNames")
					if charname and playernames then
						local class = playernames:GetData(charname)
						if class then
							local classColor = Prat.GetClassColor(class, true)
							if classColor then
								self.ALTNAMES = string.format(padfmt, classColor:WrapTextInColorCode(altname:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)))
								message.ALTNAMES = self.ALTNAMES
								return
							end
						end
					end
				else
					hexcolour = CLR:GetHexColor(self.db.profile.colour)
				end

				hexcolour = hexcolour or CLR:GetHexColor(self.db.profile.colour)
			end

			self.ALTNAMES = string.format(padfmt, CLR:Colorize(hexcolour, altname:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)))

			message.ALTNAMES = self.ALTNAMES
		end
	end

	function module:getColour()
		local col = self.db.profile.colour
		if not col or col.r == nil or col.g == nil or col.b == nil then
			return 0, 0, 0
		end
		return col.r, col.g, col.b, nil
	end

	function module:importFromLOK()
		if not LOKWhoIsWho_Config then
			self:print(PL['LOKWhoIsWho lua file not found, sorry.'])
			return false
		end

		local server = GetRealmName()
		local lokalts = LOKWhoIsWho_Config[server]['players']

		if lokalts == nil then
			self:print(PL["LOKWhoIsWho data not found"])
			return false
		end

		local numimported = 0

		for altname, mainname in pairs(lokalts) do
			self:addAlt(mainname, altname)
			numimported = numimported + 1
		end

		self:print(string.format(PL["%s alts imported from LOKWhoIsWho"], numimported))
	end

	function module:importGGAlts()
		if not GLDG_Data then
			self:print(PL['No Guild Greet database found'])
			return
		end

		local servername = GetRealmName()
		for k, v in pairs(GLDG_Data) do
			if string.match(k, servername .. ' - %S+') then
				for name, player in pairs(v) do
					if player['alt'] and player['alt'] ~= "" then
						self:addAlt(player['alt'], name)
					end
				end
			end
		end
	end

	function module:importGuildAlts(altrank, silently)
		if altrank == "" then
			altrank = nil
		end

		local totalmembers
		self.silent = silently

		totalmembers = GetNumGuildMembers(true)

		if totalmembers == 0 then
			self:print(PL['You are not in a guild'])
			return
		end

		local guildMembers = {}

		for x = 1, totalmembers do
			local name = GetGuildRosterInfo(x)
			if name then
				local shortname, _ = strsplit("-", name, 2)
				guildMembers[string.lower(shortname)] = shortname
			end
		end

		local numfound = 0

		for x = 1, totalmembers do
			local mainname
			local name, rank, _, _, _, _, publicnote, officernote = GetGuildRosterInfo(x)

			officernote = officernote or ""
			publicnote = publicnote or ""
			rank = rank or ""
			officernote = (officernote):match(PL["(.-)'s? [Aa]lt"]) or officernote or ""
			publicnote = (publicnote):match(PL["(.-)'s? [Aa]lt"]) or publicnote or ""

			local cleanpubnote = publicnote:match(Prat.AnyNamePattern)
			local cleanoffnote = officernote:match(Prat.AnyNamePattern)

			if (rank:match(PL[".*[Aa]lts?$"]) or rank:match(PL[".*[Tt]wink.*$"]) or (altrank and rank == altrank)) and (cleanpubnote and
				guildMembers[cleanpubnote:lower()]) then
				mainname = cleanpubnote
			elseif cleanpubnote and guildMembers[cleanpubnote:lower()] then
				mainname = cleanpubnote
			elseif cleanoffnote and guildMembers[cleanoffnote:lower()] then
				mainname = cleanoffnote
			elseif officernote:find(PL["([^%s%p%d%c%z]+)'s alt"]) or publicnote:find(PL["([^%s%p%d%c%z]+)'s alt"]) then
				local TempName = officernote:match(PL["([^%s%p%d%c%z]+)'s alt"]) or publicnote:match(PL["([^%s%p%d%c%z]+)'s alt"])
				if TempName and guildMembers[string.lower(TempName)] then
					mainname = TempName
				end
			elseif officernote:find(PL["alt of ([^%s%p%d%c%z]+)"]) or publicnote:find(PL["alt of ([^%s%p%d%c%z]+)"]) then
				local TempName = officernote:match(PL["alt of ([^%s%p%d%c%z]+)"]) or publicnote:match(PL["alt of ([^%s%p%d%c%z]+)"])
				if TempName and guildMembers[string.lower(TempName)] then
					mainname = TempName
				end
			end

			if mainname and mainname ~= "" then
				if mainname:lower() ~= name:lower() then
					numfound = numfound + 1
					self:addAlt(mainname, name)
				end
			end
		end

		self:print(string.format(PL["guild member alts found and imported: %s"], numfound))
		self.silent = nil
	end

	function module:getAlts(mainname)
		if self.db.profile.usealtlib then
			local alts = { altregistry:GetAlts(mainname) }
			if #alts > 0 then
				return alts
			end

			return false
		end

		if not (mainname and self.Alts) then
			return false
		end

		mainname = self:formatCharName(mainname)
		if mainname == "" then
			return false
		end

		if self.Altlists[mainname] then
			return self.Altlists[mainname]
		end

		local alts = {}
		local allalts = self.Alts

		for alt, tmpmainname in pairs(allalts) do
			if mainname == tmpmainname then
				table.insert(alts, alt)
			end
		end

		if #alts == 0 then
			return false
		end

		self.Altlists[mainname] = alts

		return alts
	end

	function module:getMain(altname)
		if self.db.profile.usealtlib then
			local main = altregistry:GetMain(altname)
			if main then
				return self:formatCharName(main)
			end

			return false
		end

		if not altname and self.Alts then
			return false
		end

		altname = self:formatCharName(altname)
		if altname == "" then
			return false
		end

		if not self.Alts[altname] then
			return false
		end

		return self.Alts[altname]
	end

	function module:nicejoin(t, glue, gluebeforelast)
		if type(t) ~= 'table' then
			return false
		end

		local list = {}
		local index = 1

		for _, v in pairs(t) do
			local vtype = type(v)
			local item = self:formatCharName(v)

			if vtype ~= 'string' then
				item = vtype
			end

			list[index] = item or vtype
			index = index + 1
		end

		if #list == 0 then
			return ""
		end

		if #list == 1 then
			return list[1]
		end

		glue = glue or ', '
		gluebeforelast = gluebeforelast or ', and '

		local last = table.remove(list) or ""
		local str = table.concat(list, glue)
		return str .. gluebeforelast .. last
	end

	function module:listAlts(mainname)
		if not mainname then
			return false
		end

		mainname = self:formatCharName(mainname)
		if mainname == "" then
			return false
		end

		local alts = self:getAlts(mainname)
		if not alts or #alts == 0 then
			self:print(PL['no alts found for character '] .. mainname)
			return
		end

		self:print(string.format(PL['%d alts found for %s: %s'], #alts, clrmain(mainname), clralt(self:nicejoin(alts))))
		return #alts
	end

	function module:ModifyUnitTooltip(unitid)
		if UnitIsPlayer(unitid) then
			local charname = UnitName(unitid)
			local tooltipaltered

			local mainname
			if self.db.profile.tooltip_showmain then
				mainname = self:getMain(charname)
				if mainname then
					GameTooltip:AddDoubleLine(PL['Main:'] .. ' ', clrmain(mainname), 1, 0.9, 0, 0.5, 0.5, 1)
					tooltipaltered = true
				end
			end

			if self.db.profile.tooltip_showalts then
				local alts = self:getAlts(charname)
				if not alts and mainname then
					alts = self:getAlts(mainname)
				end

				if alts then
					GameTooltip:AddLine("|cffffc080" .. PL['Alts:'] .. "|r " .. clralt(self:nicejoin(alts)), 1, 0.5, 0.5, 1)
					tooltipaltered = true
				end
			end

			if tooltipaltered then
				GameTooltip:Show()
			end

			self.showingtooltip = true
		end
	end
end)
