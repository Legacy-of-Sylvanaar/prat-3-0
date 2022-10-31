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

local Prat = Prat

Prat:AddModuleToLoad(function()

  local PRAT_MODULE = Prat:RequestModuleName("AltNames")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0", "AceEvent-3.0")

  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Start"] = true,
    ["AltNames"] = true,
    ["module_desc"] = "Allows people's alt characters to be linked to their mains, which can then be displayed next to their names when found in chat messages (default=off).",
    ["quiet"] = "Be quiet",
    ["quiet_name"] = true,
    ["quiet_desc"] = "Whether to report to the chat frame or not.",
    ["mainpos_name"] = "Main name position",
    ["mainpos_desc"] = "Where to display a character's main name when on their alt.",
    ["Main name position"] = true,
    ["<alt name> (eg, /altnames del Personyouthoughtwassomeonesaltbutreallyisnt)"] = true,
    ["Where to display a character's main name when on their alt."] = true,
    ["Left"] = true,
    ["Right"] = true,
    ["Disabled"] = true,
    ["Find characters"] = true,
    ["Search the list of linked characters for matching main or alt names."] = true,
    ["<search term> (eg, /altnames find fin)"] = true,
    ["Link alt"] = true,
    ["Link someone's alt character with the name of their main."] = true,
    ["link <alt name> <main name> (eg, /altnames link Fin Finjathealtoffin)"] = true,
    ["Delete alt"] = true,
    ["Delete a character's link to another character as their main."] = true,
    ["Be quiet"] = true,
    ["Whether to report to the chat frame or not."] = true,
    ["You have not yet linked any alts with their mains."] = true,
    ["no matches found"] = true,
    ["List all"] = true,
    ["List all links between alts and their main names."] = true,
    ["Imports data from LOKWhoIsWho, if present (drop your SavedVariables\\LOKWhoIsWho.lua in the Prat directory to be able to use this)."] = true,
    ["LOKWhoIsWho import"] = true,
    ["Clear all"] = true,
    ["Clear all links between alts and main names."] = true,
    ["Colour"] = true,
    ["The colour of an alt's main name that will be displayed"] = true,
    ["Import from guild roster"] = true,
    ['Imports alt names from the guild roster by checking for members with the rank "alt" or "alts", or guild / officer notes like "<name>\'s alt"'] = true,
    ['Import from Guild Greet database'] = true,
    ['Imports alt names from a Guild Greet database, if present'] = true,
    ['Use class colour (from the PlayerNames module)'] = true,
    ["use class colour of main"] = true,
    ["use class colour of alt"] = true,
    ["don't use"] = true,
    ["Display main names in the same colour as that of the main's class (taking the data from the PlayerNames module if it is enabled)"] = true,
    ["Display main names in the same colour as that of the alt's class (taking the data from the PlayerNames module if it is enabled)"] = true,
    ["Don't use data from the PlayerNames module at all"] = true,
    ["Import options"] = true,
    ["Various ways to import a main's alts from other addons"] = true,
    ["Don't overwrite existing links"] = true,
    ["Don't overwrite existing alt <-> main links when importing or adding new alts."] = true,
    [".*[Aa]lts?$"] = true,
    [".*[Tt]wink.*$"] = true,
    ["(.-)'s? [Aa]lt"] = "%f[%a\192-\255]([%a\192-\255]+)%f[^%a\128-\255]'s [Aa]lt",
    ["([^%s%p%d%c%z]+)'s alt"] = "%f[%a\192-\255]([%a\192-\255]+)%f[^%a\128-\255]'s [Aa]lt",
    ['ERROR: some function sent a blank message!'] = true,
    ["Alts:"] = true,
    ['Main:'] = true,
    ["No main name suPLied to link %s to"] = true,
    ['alt name exists: %s -> %s; not overwriting as set in preferences'] = true,
    ['warning: alt %s already linked to %s'] = true,
    ["linked alt %s => %s"] = true,
    ["character removed: %s"] = true,
    ['no characters called "%s" found; nothing deleted'] = true,
    ['%s total alts linked to mains'] = true,
    ['no alts or mains found matching "%s"'] = true,
    ["searched for: %s - total matches: %s"] = true,
    ['LOKWhoIsWho lua file not found, sorry.'] = true,
    ["LOKWhoIsWho data not found"] = true,
    ["%s alts imported from LOKWhoIsWho"] = true,
    ['No Guild Greet database found'] = true,
    ['You are not in a guild'] = true,
    ["guild member alts found and imported: %s"] = true,
    ["Fix alts"] = true,
    ["Fix corrupted entries in your list of alt names."] = true,
    ["Class colour"] = true,
    ["Use class colour (from the PlayerNames module)"] = true,
    ['Show main in tooltip'] = true,
    ["Display a player's main name in the tooltip"] = true,
    ['Show alts in tooltip'] = true,
    ["Display a player's alts in the tooltip"] = true,
    ["Found alt: %s => main: %s"] = true,
    ["alt"] = true,
    ["main"] = true,
    ["Alt"] = true,
    ["Main"] = true,
    ['no alts found for character '] = true,
    ['List alts'] = true,
    ['List alts for a given character'] = true,
    ['<main> (eg /altnames listalts Fin)'] = true,
    ['%d alts found for %s: %s'] = true,
    ['No arg string given to :addAlt()'] = true,
    ["Use LibAlts Data"] = true,
    ["Use the data available via the shared alt information library."] = true,
    ["autoguildalts_name"] = "Auto Import Guild Alts",
    ["autoguildalts_desc"] = "Automatically run the import from guild roster command silently",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization

  --[===[@non-debug@
do
      local L

  
--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "enUS",L)

  
--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "frFR",L)

  
--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "deDE",L)

  
--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "koKR",L)

  
--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "esMX",L)

  
--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "ruRU",L)

  
--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "zhCN",L)

  
--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "esES",L)

  
--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="AltNames")@
    PL:AddLocale(PRAT_MODULE, "zhTW",L)
  end
  --@end-non-debug@]===]



  local altregistry

  module.Alts = {}

  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      quiet = false,
      pncol = 'no',
      altidx = {},
      mainpos = 'RIGHT',
      colour = {r = 0, g = 0, b = 0},
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


  Prat:SetModuleInit(module,
    function(self)
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
          local mainname = this.editBox:GetText()

          altname = altname or 'xxx'

          module:addAlt(string.format('%s %s', altname, mainname))
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
          local editBox = parent.editBox
          local mainname = editBox:GetText()

          altname = altname or 'xxx'

          module:addAlt(string.format('%s %s', altname, mainname))

          parent:Hide()
        end,
        EditBoxOnEscapePressed = function(this)

          this:GetParent():Hide();
        end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1
      }
      return
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
        set = function(info, q) info.handler:findChars(q) end,
        get = false,
      },
      listalts = {
        name = PL['List alts'],
        desc = PL['List alts for a given character'],
        type = 'input',
        usage = PL['<main> (eg /altnames listalts Fin)'],
        order = 115,
        set = function(info, m) info.handler:listAlts(m) end,
        get = false,
      },
      link = {
        name = PL["Link alt"],
        desc = PL["Link someone's alt character with the name of their main."],
        type = "input",
        order = 120,
        usage = PL["link <alt name> <main name> (eg, /altnames link Fin Finjathealtoffin)"],
        -- pass	= true,
        -- set	= function(argname, argstr) self:addAlt(argstr) end,
        set = function(info, argstr) info.handler:addAlt(argstr) end,
        get = false,
        --				alias	= { 'new', 'add' },
      },
      del = {
        name = PL["Delete alt"],
        desc = PL["Delete a character's link to another character as their main."],
        type = "input",
        usage = PL["<alt name> (eg, /altnames del Personyouthoughtwassomeonesaltbutreallyisnt)"],
        order = 130,
        set = function(info, altname) info.handler:delAlt(altname) end,
        get = false,
        confirm = true,
        --				alias	= { 'remove', 'unlink' },
      },
      quiet = {
        name = PL["Be quiet"],
        desc = PL["Whether to report to the chat frame or not."],
        type = "toggle",
        order = 191, -- 19x = options
      },
      listall = {
        name = PL["List all"],
        desc = PL["List all links between alts and their main names."],
        type = "execute",
        func = "listAll",
        --				alias	= { 'list', 'all' },
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
        get = function(info) return info.handler:getColour() end,
        set = function(info, nr, ng, nb, na) info.handler.db.profile.colour = { r = nr, g = ng, b = nb, a = na } end,
        desc = PL["The colour of an alt's main name that will be displayed"],
        type = "color",
        order = 60,
        disabled = function(info) return info.handler.db.profile.pncol ~= 'no' end
      },
      pncol = {
        name = PL["Class colour"],
        desc = PL["Use class colour (from the PlayerNames module)"],
        type = "select",
        get = function(info) return info.handler.db.profile.pncol end,
        set = function(info, v) info.handler.db.profile.pncol = v end,
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
        get = function(info) return info.handler.db.profile.mainpos end,
        set = function(info, v) info.handler:setMainPos(v) end,
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
        get = function(info) return info.handler.db.profile.tooltip_showmain end,
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
        get = function(info) return info.handler.db.profile.tooltip_showalts end,
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
        order = 192, -- 19x = options
      },

      --			blankheader = {
      --				order	= 499,
      --				type	= 'header',
      --				},

      --[[ IMPORT OPTIONS ]] --
      importheader = {
        name = PL["Import options"],
        desc = PL["Various ways to import a main's alts from other addons"],
        type = 'header',
        order = 500,
      },

      -- imports: LOKWhoIsWho - SavedVariables
      importfromlok = {
        name = PL["LOKWhoIsWho import"],
        desc = PL["Imports data from LOKWhoIsWho, if present (drop your SavedVariables\\LOKWhoIsWho.lua in the Prat directory to be able to use this)."],
        type = "execute",
        func = "importFromLOK",
        confirm = true,
        order = 560,
      },

      -- imports: guild roster - officer notes, public notes, ranks
      guildimport = {
        name = PL["Import from guild roster"],
        desc = PL['Imports alt names from the guild roster by checking for members with the rank "alt" or "alts", or guild / officer notes like "<name>\'s alt"'],
        type = "execute",
        func = "importGuildAlts",
        confirm = true,
        order = 520,
      },

      -- imports: guild greet - SavedVariables
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

  --	if Prat:IsModuleActive("PlayerNames") then
  --		self.moduleOptions['args']['pncol'] = {
  --			name	= PL["Class colour"],
  --			desc	= PL["Use class colour (from the PlayerNames module)"],
  --			type	= "text",
  --			get     =  function() return self.db.profile.pncol end,
  --			set	= function(v) self.db.profile.pncol = v end,
  --			order	= 150,
  --			validate = {
  --				['main']	= PL["use class colour of main"],
  --				['alt']		= PL["use class colour of alt"],
  --				['no']		= PL["don't use"],
  --				},
  --			validateDesc = {
  --				['main']	= PL["Display main names in the same colour as that of the main's class (taking the data from
  -- -- the PlayerNames module if it is enabled)"],
  --				['alt']		= PL["Display main names in the same colour as that of the alt's class (taking the data from
  -- -- the PlayerNames module if it is enabled)"],
  --				['no']		= PL["Don't use data from the PlayerNames module at all"],
  --				},
  --			}
  --	end
  --)


  --[[------------------------------------------------
      Module Event Functions
  ------------------------------------------------]] --

  function module:OnModuleEnable()
    -- much code ripped off from the PlayerMenu code - thanks, and sorry!

    -- things to do when the module is enabled
    for altname, mainname in pairs(self.db.realm.alts) do
      self.Alts[altname] = mainname
    end

    -- PlayerNames colour
    local pncol = self.db.profile.pncol

    if pncol == 'no' then
      pncol = false
      self.db.profile.pncol = false
    end

    self.db.profile.pncol = self.db.profile.pncol or false

    -- for caching a main's list of alts
    self.Altlists = {}

    -- just register one area which can be used for anything
    -- (and only actually has one use at the moment)
    self.ALTNAMES = ""

    -- set position that main names are displayed in chat messages
    self:setMainPos(self.db.profile.mainpos)

    -- register events
    Prat.RegisterChatEvent(self, "Prat_PreAddMessage")

    -- hook functions
    self.altertooltip = self.db.profile.tooltip_showmain or self.db.profile.tooltip_showalts

    self:HookTooltip()

    -- hack 'n' slash
    local slashcmds = {
      '/altnames',
      '/alts',
      '/alt',
    }

    --Prat:RegisterChatCommand(slashcmds, self.moduleOptions, string.upper("AltNames"))

    --self:SecureHook("UnitPopup_OnClick")
    --self:SecureHook("UnitPopup_ShowMenu")

    --Prat:RegisterDropdownButton("LINK_ALT")

    -- add the bits to the context menus
    --    UnitPopupButtons['LINK_ALT'] = { text = "Set Main", func = function() module:UnitPopup_LinkAltOnClick() end, arg1 = "", arg2 = "" }

    if not self.menusAdded then
      --      tinsert(UnitPopupMenus['PARTY'], #UnitPopupMenus['PARTY'] - 1, 'LINK_ALT')
      --      tinsert(UnitPopupMenus['FRIEND'], #UnitPopupMenus['FRIEND'] - 1, 'LINK_ALT')
      --      tinsert(UnitPopupMenus['SELF'], #UnitPopupMenus['SELF'] - 1, 'LINK_ALT')
      --      tinsert(UnitPopupMenus['PLAYER'], #UnitPopupMenus['PLAYER'] - 1, 'LINK_ALT')
      -- tinsert(UnitPopupMenus['TARGET'], getn(UnitPopupMenus['TARGET'])-1, 'LINK_ALT')

      self.menusAdded = true
    end

    if self.db.profile.autoguildalts then
      self:AutoImportGuildAlts(true)
    end

    altregistry.RegisterCallback(self, "LibAlts_SetAlt", function(event, main, alt, source) self:addAlt(alt .. " " .. main, true) end)
    altregistry.RegisterCallback(self, "LibAlts_RemoveAlt", function(event, main, alt, sources) self:delAlt(alt, true) end)
  end

  function module:AutoImportGuildAlts(b)
    if b then
      self:RegisterEvent("GUILD_ROSTER_UPDATE", function() module:importGuildAlts(nil, true) end)
      -- Different functions for retail versus classic
	  if Prat.IsRetail then
        C_GuildInfo.GuildRoster()
      else
        GuildRoster()
      end
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

  local function NOP() return end

  function module:HookTooltip()
    if self.altertooltip then
      self:SecureHookScript(GameTooltip, 'OnTooltipSetUnit')
      self:SecureHookScript(GameTooltip, 'OnTooltipCleared')

      module.HookTooltip = NOP
    end
  end

  --function module:UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData, ...)
  --	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
  --		button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEPL.."Button"..i];
  --
  --		-- Patch our handler function back in
  --		if  button.value == "LINK_ALT" then
  --		    button.func = UnitPopupButtons["LINK_ALT"].func
  --		end
  --	end
  --end

  --  function module:UnitPopup_LinkAltOnClick()
  --    local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
  --
  --    --if (button == 'LINK_ALT') then
  --    local altname = dropdownFrame.name
  --    local dialog = StaticPopup_Show('MENUITEM_LINKALT', altname)
  --
  --    if dialog then
  --      local altname = dropdownFrame.name
  --      dialog.data = altname
  --    end
  --    --end
  --  end



  -- things to do when the module is disabled
  function module:OnModuleDisable()
    -- unregister events
    Prat.UnregisterAllChatEvents(self)

    altregistry.UnregisterAllCallbacks(self)
  end


  --[[------------------------------------------------
      Core Functions
  ------------------------------------------------]] --


  function module:print(msg, printanyway)
    -- make sure we've got a message
    if msg == nil then
      printanyway = true
      msg = PL['ERROR: some function sent a blank message!']
    end

    local verbose = (not self.db.profile.quiet)

    if (not self.silent) and (verbose or printanyway) then
      self:Output(msg)
    end
  end

  --[[ colo*u*ring and formatting ]] --

  local clrname = function(name, colour)
    return '|cff' .. (colour or 'ffffff') .. (name or "") .. '|r'
  end

  local clrmain = function(mainname, maincolour)
    mainname = mainname or ""
    maincolour = maincolour or module.db.profile.maincolour or '8080ff'

    -- 1, 0.9, 0, 0.5, 0.5, 1

    return clrname(mainname, maincolour)
  end

  local clralt = function(altname, altcolour)
    altname = altname or ""
    altcolour = altcolour or module.db.profile.altcolour or 'ff8080'

    -- 1, 0.7, 0, 1, 0.5, 0.5

    return clrname(altname, altcolour)
  end

  local clralts = function(alts, altcolour)
    if not alts or (type(alts) ~= 'table') or (#alts == 0) then return false end

    for mainname, altname in pairs(alts) do
      alts[mainname] = clralt(module:formatCharName(altname))
    end

    return alts
  end

  function module:formatCharName(name)
    -- format character names as having uppercase first letter followed by all lowercase

    if name == nil then
      return ""
    end

    name = name:gsub('[%%%[%]":|%s]', '')
    name = name:gsub("'", '')

    name = name:lower()
    name = name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)

    return name
  end

  --[[ alt <-> main link management ]] --


  function module:addAlt(argstr, eventGenerated)
    local mainname

    local altname = ""
    local args = {}

    -- check we've been passed somethin
    if (argstr == nil) or (argstr == "") then
      self:print(PL['No arg string given to :addAlt()'])
      return false
    end

    -- extract the alt's name and the main name to link to
    for k, v in argstr:gmatch('(%S+)%s+(%S+)') do
      altname, mainname = k, v
    end

    -- check we've got a main name to link to
    if altname and not mainname then
      altname = argstr
      self:print(string.format(PL["No main name suPLied to link %s to"], clralt(altname)), true)
      return false
    end

    -- clean up character names
    mainname = self:formatCharName(mainname)
    altname = self:formatCharName(altname)

    -- check if alt has already been linked to a main
    local oldmain = ""
    local noclobber = self.db.profile.noclobber

    if self.Alts[altname] then
      oldmain = self.Alts[altname]

      if oldmain == mainname then
        self:print(string.format(PL['warning: alt %s already linked to %s'], clralt(altname), clrmain(mainname)))
        return false
      end

      if noclobber then
        self:print(string.format(PL['alt name exists: %s -> %s; not overwriting as set in preferences'],
          clralt(altname), clrmain(oldmain)))
        return false
      end

      self:print(string.format(PL['warning: alt %s already linked to %s'], clralt(altname), clrmain(oldmain)))
    end

    -- add alt to list of alts -> mains
    self.Alts[altname] = mainname
    self.db.realm.alts[altname] = mainname

    -- make sure this character's list of alts is rebuilt next time it's needed
    if self.Altlists[mainname] then self.Altlists[mainname] = nil end

    -- publish this info globablly
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

      -- make sure this character's list of alts is rebuilt next time it's needed
      if self.Altlists[mainname] then self.Altlists[mainname] = nil end

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
    local numfound

    local matchhighlight

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

        -- self:print(string.format("matching against: altname:'%s', mainname:'%s', pat:'%s'", a, m, pat))

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
    -- which item to go after, depending on our position
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
    if alt then return alt end

    if altregistry and altregistry:IsAlt(name) then
      return altregistry:GetMain(name)
    end

    return
  end

  local playernames
  function module:Prat_PreAddMessage(e, message, frame, event)
    local hexcolour = CLR.NONE

    local mainname = message.PLAYERLINK

    local altname = isAlt(mainname) or isAlt(Ambiguate(mainname, "all"))

    if self.db.profile.on and altname then
      local pres = message.PRESENCE_ID or 0


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

          playernames = playernames or Prat.Addon:GetModule("PlayerNames")
          if charname then
            local class, level, subgroup = playernames:GetData(charname)
            if class then
              hexcolour = playernames:GetClassColor(class)
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

  function module:getColour(r, g, b, a)
    local col = self.db.profile.colour
    -- We check every component as old profiles from before 10.0 with a default
    -- colour had them all nil. In 10.0 SetVertexColor requires non-nil colour
    -- components, so we return a black.
    if not col or col.r == nil or col.g == nil or col.b == nil then return 0, 0, 0 end
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
      self:addAlt(string.format("%s %s", altname, mainname))
      numimported = numimported + 1
    end

    self:print(string.format(PL["%s alts imported from LOKWhoIsWho"], numimported))
  end

  function module:importGGAlts()
    --[[
     imports guilds from a Guild Greet database, if present
   ]]
    if not GLDG_Data then
      self:print(PL['No Guild Greet database found'])
      return
    end

    local servername = GetRealmName()
    local mainname, altname

    for k, v in pairs(GLDG_Data) do
      if string.match(k, servername .. ' - %S+') then
        local name, player

        for name, player in pairs(v) do
          -- not sure whether this would be useful:
          -- if player['alt'] and player['alt'] ~= "" and not player['own'] then
          if player['alt'] and player['alt'] ~= "" then
            mainname = player['alt']
            altname = name

            self:addAlt(string.format('%s %s', altname, mainname))
          end
        end
      end
    end
  end

  function module:importGuildAlts(altrank, silently)
    if altrank == "" then altrank = nil end

    local totalmembers
    self.silent = silently

    totalmembers = GetNumGuildMembers(true)

    if totalmembers == 0 then
      self:print(PL['You are not in a guild'])
      return
    end


    -- build a list of guild members to check guild notes against later
    local guildMembers = {}

    for x = 1, totalmembers do
      local name, rank, rankIndex, level, class, zone, publicnote, officernote, online, status = GetGuildRosterInfo(x)
      if name then
        --since GetGuildRosterInfo returns Playername-Realm we need to trim Realmname
        --later we can compare Playername with officernote/publicnote
        --nobody is typing Playername with realm into the notes
        local shortname, realm = strsplit("-", name, 2)
        guildMembers[string.lower(shortname)] = shortname
      end
    end


    -- loop through members and check stuff for later
    local mainname
    local altname
    local numfound = 0

    for x = 1, totalmembers do
      altname = nil
      mainname = nil

      local name, rank, rankIndex, level, class, zone, publicnote, officernote, online, status = GetGuildRosterInfo(x)

      -- yeah I know the vars should be pre-lc'ed and it's not as efficient as it could be below
      -- ... feel free to clean it up

      -- untested (is there a more convenient trim function available?):
      --[[
     officernote = gsub("^%s*", "", officernote)
     publicnote = gsub("^%s*", "", publicnote)
     ]]

      officernote = officernote or ""
      publicnote = publicnote or ""
      rank = rank or ""
      officernote = (officernote):match(PL["(.-)'s? [Aa]lt"]) or officernote or ""
      publicnote = (publicnote):match(PL["(.-)'s? [Aa]lt"]) or publicnote or ""

      local cleanpubnote = publicnote:match(Prat.AnyNamePattern)
      local cleanoffnote = officernote:match(Prat.AnyNamePattern)

      -- check for guild members with rank "alt" or "alts" or "officer alt" or "twink"
      if (rank:match(PL[".*[Aa]lts?$"]) or rank:match(PL[".*[Tt]wink.*$"]) or (altrank and rank == altrank)) and (cleanpubnote and
        guildMembers[cleanpubnote:lower()]) then
        -- self:print(string.format('found mainname name for member %s', name))
        mainname = cleanpubnote
        -- check whether guild note is an exact match of a member's name
      elseif cleanpubnote and guildMembers[cleanpubnote:lower()] then
        mainname = cleanpubnote
      elseif cleanoffnote and guildMembers[cleanoffnote:lower()] then
        mainname = cleanoffnote
      elseif officernote:find(PL["([^%s%p%d%c%z]+)'s alt"]) or publicnote:find(PL["([^%s%p%d%c%z]+)'s alt"]) then
        local TempName = officernote:match(PL["([^%s%p%d%c%z]+)'s alt"]) or publicnote:match(PL["([^%s%p%d%c%z]+)'s alt"])
        if TempName and guildMembers[string.lower(TempName)] then
          mainname = TempName
        end
      end

      -- set alt name if we've found their main name
      if mainname and mainname ~= "" then

        if mainname:lower() ~= name:lower() then
          numfound = numfound + 1
          altname = name
          self:addAlt(string.format('%s %s', altname, mainname))
        end
      end
    end

    self:print(string.format(PL["guild member alts found and imported: %s"], numfound))
    self.silent = nil
  end


  -- function for showing a list of alt names in the tooltip
  function module:getAlts(mainname)
    if self.db.profile.usealtlib then
      local alts = { altregistry:GetAlts(mainname) }
      if #alts > 0 then
        return alts
      end

      return false
    end

    -- self.Alts = self.db.profile.altnames

    -- check valid mainname is being passed and that we actually have a list of alts
    if not (mainname and self.Alts) then return false end

    -- format the character name
    mainname = self:formatCharName(mainname)

    -- check mainname wasn't just made of invalid characters
    if mainname == "" then return false end

    -- check we've not already built the list of alts for this character
    if self.Altlists[mainname] then return self.Altlists[mainname] end

    local alts = {}
    local allalts = self.Alts

    -- loop through list of alts and build alts table for given mainname
    for alt, tmpmainname in pairs(allalts) do
      if mainname == tmpmainname then
        table.insert(alts, alt)
      end
    end

    -- check there we've actually found some alts
    if #alts == 0 then return false end

    -- cache this list of alts
    self.Altlists[mainname] = alts

    return alts
  end


  -- function for showing main names in the tooltip
  function module:getMain(altname)
    if self.db.profile.usealtlib then
      local main = altregistry:GetMain(altname)
      if main then
        return self:formatCharName(main)
      end

      return false
    end

    -- self.Alts = self.db.profile.altnames

    -- check for valid alt name being passed and that we actually have a list of alts
    if not altname and self.Alts then return false end

    -- format the character name
    altname = self:formatCharName(altname)

    -- check the alt name wasn't just made of invalid character
    if altname == "" then return false end

    -- check a main exists for the given alt name
    if not self.Alts[altname] then return false end

    return self.Alts[altname]
  end



  function module:nicejoin(t, glue, gluebeforelast)
    -- check we've got a table
    if type(t) ~= 'table' then return false end

    local list = {}
    local index = 1

    -- create a copy of the table with a numerical and no nested tables
    for i, v in pairs(t) do
      local vtype = type(v)
      local item = self:formatCharName(v)

      if vtype ~= 'string' then
        item = vtype
      end

      list[index] = item or vtype
      index = index + 1
    end

    -- make sure we have some items to join
    if #list == 0 then
      return ""
    end

    -- trying to join one item = that item
    if #list == 1 then
      return list[1]
    end

    -- defaults with which we will want wo woin no that's not going to work
    -- defaults
    glue = glue or ', '
    gluebeforelast = gluebeforelast or ', and '

    -- pop the last value off
    local last = table.remove(list) or "" -- shouldn't need the ' or ""'?

    -- standard way of joining a list of items together
    local str = table.concat(list, glue)

    -- return the previous list, but add the last value nicely
    return str .. gluebeforelast .. last
  end


  -- displays all alts for a given character as a list rather than seperate matches
  function module:listAlts(mainname)
    if not mainname then return false end

    mainname = self:formatCharName(mainname)

    if mainname == "" then return false end

    local alts

    alts = self:getAlts(mainname)

    if not alts or (#alts == 0) then
      self:print(PL['no alts found for character '] .. mainname)
      return
    else
      self:print(string.format(PL['%d alts found for %s: %s'], #alts, clrmain(mainname), clralt(self:nicejoin(alts))))
      return #alts
    end
  end


  -- hooked function to show mains and alts if set in preferences
  function module:OnTooltipSetUnit()
    --[[
   check:

    . the user wants information about alts or mains on the tooltip
    . there's a tooltip to alter
    .  we haven't already added anything to the tooltip

   ]]
    if self.altertooltip and GameTooltip and not self.showingtooltip then
      -- create lines table for extra information that might be added
      local lines = {}

      -- check who / what the tooltip's being displayed for
      local charname, unitid = GameTooltip:GetUnit()

      -- check to see if it's a character
      if UnitIsPlayer(unitid) then
        local mainname, alts, tooltipaltered

        -- check if the user wants the mainame name shown on alts' tooltips
        if self.db.profile.tooltip_showmain then
          local mainame = self:getMain(charname)

          if mainname then
            -- add the character's main name to the tooltip
            GameTooltip:AddDoubleLine(PL['Main:'] .. ' ', clrmain(mainname), 1, 0.9, 0, 0.5, 0.5, 1)
            tooltipaltered = true
          end
        end

        local width = GameTooltip:GetWidth()
        -- check if the user wants a list of alts shown on mains' tooltips
        if self.db.profile.tooltip_showalts then
          local alts = self:getAlts(charname) or self:getAlts(mainame)

          if alts then
            -- build the string listing alts
            --					local altstr = self:nicejoin(alts)

            -- add the list of alts to the tooltip
            GameTooltip:AddLine("|cffffc080" .. PL['Alts:'] .. "|r " .. clralt(self:nicejoin(alts)), 1, 0.5, 0.5, 1)
            tooltipaltered = true
          end
        end

        if tooltipaltered then
          GameTooltip:SetWidth(width)
          GameTooltip:Show()
        end

        -- make sure we don't add another tooltip
        self.showingtooltip = true
      end
    end
  end

  -- got to reset the flag so we know when to readd the lines
  function module:OnTooltipCleared()
    self.showingtooltip = false
  end


  return
end) -- Prat:AddModuleToLoad
