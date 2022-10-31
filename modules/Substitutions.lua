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
  local PRAT_MODULE = Prat:RequestModuleName("Substitutions")

  if PRAT_MODULE == nil then
    return
  end

  local module = Prat:NewModule(PRAT_MODULE)

  -- define localized strings
  local PL = module.PL

  --@debug@
  PL:AddLocale(PRAT_MODULE, "enUS", {
    ["Substitutions"] = true,
    ["A module to provide basic chat substitutions."] = true,
    ['User defined substitutions'] = true,
    ['Options for setting and removing user defined substitutions. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)'] = true,
    ['Set substitution'] = true,
    ['Set the value of a user defined substitution (NB: this may be the same as an existing default substitution; to reset it to the default, just remove the user created definition).'] = true,
    ['subname = text after expansion -- NOTE: sub name without the prefix "%"'] = true,
    ['List substitutions'] = true,
    ['Lists all current subtitutions in the default chat frame'] = true,
    ['Delete substitution'] = true,
    ['Deletes a user defined substitution'] = true,
    ['subname -- NOTE: sub name without the prefix \'%\''] = true,
    ['Are you sure?'] = true,
    ['Delete all'] = true,
    ['Deletes all user defined substitutions'] = true,
    ['Are you sure - this will delete all user defined substitutions and reset defaults?'] = true,
    ['List of available substitutions'] = true,
    ['List of available substitutions defined by this module. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)'] = true,
    ["NO MATCHFUNC FOUND"] = true,
    ["current-prompt"] = "Current value: '%s'\nClick to paste into the chat.",
    ['no substitution name given'] = true,
    ['no value given for subtitution "%s"'] = true,
    ['|cffff0000warning:|r subtitution "%s" already defined as "%s", overwriting'] = true,
    ['defined %s: expands to => %s'] = true,
    ['no substitution name suPLied for deletion'] = true,
    ['no user defined subs found'] = true,
    ['user defined substition "%s" not found'] = true,
    ["user substitutions index (usersubs_idx) doesn't exist! oh dear."] = true,
    ["can't find substitution index for a substitution named '%s'"] = true,
    ['removing user defined substitution "%s"; previously expanded to => "%s"'] = true,
    ['substitution: %s defined as => %s'] = true,
    ['%d total user defined substitutions'] = true,
    ['module:buildUserSubsIndex(): warning: module patterns not defined!'] = true,
    ["<notarget>"] = true,
    ["male"] = true,
    ["female"] = true,
    ["unknown sex"] = true,
    ["<noguild>"] = true,
    ["his"] = true,
    ["hers"] = true,
    ["its"] = true,
    ["him"] = true,
    ["her"] = true,
    ["it"] = true,
    ['usersub_'] = true,
    ["TargetHealthDeficit"] = true,
    ["TargetPercentHP"] = true,
    ["TargetPronoun"] = true,
    ["PlayerHP"] = true,
    ["PlayerName"] = true,
    ["PlayerMaxHP"] = true,
    ["PlayerHealthDeficit"] = true,
    ["PlayerPercentHP"] = true,
    ["PlayerCurrentMana"] = true,
    ["PlayerMaxMana"] = true,
    ["PlayerPercentMana"] = true,
    ["PlayerManaDeficit"] = true,
    ["TargetName"] = true,
    ["TargetTargetName"] = true,
    ["MouseoverTargetName"] = true,
    ["TargetClass"] = true,
    ["TargetHealth"] = true,
    ["TargetRace"] = true,
    ["TargetGender"] = true,
    ["TargetLevel"] = true,
    ["TargetPossesive"] = true,
    ["TargetManaDeficit"] = true,
    ["TargetGuild"] = true,
    ["TargetIcon"] = true,
    ["MapZone"] = true,
    ["MapLoc"] = true,
    ["MapPos"] = true,
    ["MapYPos"] = true,
    ["MapXPos"] = true,
    ["RandNum"] = true,
    ["PlayerAverageItemLevel"] = true,
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "enUS", L)

--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "itIT", L)

--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "ptBR", L)

--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "frFR", L)

--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "deDE", L)

--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "koKR", L)

--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "esMX", L)

--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "ruRU", L)

--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "zhCN", L)

--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "esES", L)

--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="Substitutions")@
PL:AddLocale(PRAT_MODULE, "zhTW", L)
end
--@end-non-debug@]===]


  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
    }
  })


  local patternPlugins = { patterns = {} }

  Prat:SetModuleOptions(module.name, {
    name = PL["Substitutions"],
    desc = PL["A module to provide basic chat substitutions."],
    type = 'group',
    plugins = patternPlugins,
    args = {}
  })

  local function subDesc(info) return info.handler:GetSubstDescription(info) end


  --[[------------------------------------------------
  Core Functions
  ------------------------------------------------]] --
  function module:OnModuleEnable()
    self:BuildModuleOptions(patternPlugins.patterns)
  end

  function module:BuildModuleOptions(args)
    local modulePatterns = Prat.GetModulePatterns(self)

    self.buildingMenu = true

    for _, v in pairs(modulePatterns) do
      if v then
        local name = v.optname
        local pat = v.pattern:gsub("%%%%", "%%")

        args[name] = args[name] or {}
        local d = args[name]

        d.name = name .. " " .. pat
        d.desc = subDesc
        d.type = "execute"
        d.func = "DoPat"
      end
    end

    self.buildingMenu = false
  end

  function module:GetDescription()
    return PL["A module to provide basic chat substitutions."]
  end

  function module:GetSubstDescription(info)
    local val = self:InfoToPattern(info)

    self.buildingMenu = true

    val = val and val.matchfunc and val.matchfunc() or PL["NO MATCHFUNC FOUND"]
    val = PL["current-prompt"]:format("|cff80ff80" .. tostring(val) .. "|r"):gsub("%%%%", "%%")

    self.buildingMenu = false

    return val
  end

  function module:InfoToPattern(info)
    local modulePatterns = Prat.GetModulePatterns(self)
    local name = info[#info] or ""

    if modulePatterns then
      for _, v in pairs(modulePatterns) do
        if v and v.optname == name then
          return v
        end
      end
    end
  end

  function module:DoPat(info)
    local pat = self:InfoToPattern(info)
    pat = pat and pat.pattern or ""
    local e = ChatEdit_GetActiveWindow()
    if not e or not e:IsVisible() then
      return
    end

    e:SetText((e:GetText() or "") .. pat:gsub("[%(%)]", ""):gsub("%%%%", "%%"))
  end

  do
    local function prat_match(text)
      local text = text or ""

      if module.buildingMenu then
        return text
      end

      return Prat:RegisterMatch(text, "OUTBOUND")
    end

    local function Zone(...)
      return prat_match(GetRealZoneText())
    end

    local function Loc(...)
      return prat_match(GetMinimapZoneText())
    end

    local function GetPlayerMapPosition(unit)
      return C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(unit), unit):GetXY()
    end

    local function Pos()
      local x, y = GetPlayerMapPosition("player")
      local str = "(" .. math.floor((x * 100) + 0.5) .. "," .. math.floor((y * 100) + 0.5) .. ")"
      return prat_match(str)
    end

    local function Ypos()
      local x, y = GetPlayerMapPosition("player")
      local y = tostring(math.floor((y * 100) + 0.5))
      return prat_match(y)
    end

    local function Xpos()
      local x, y = GetPlayerMapPosition("player")
      local x = tostring(math.floor((x * 100) + 0.5))
      return prat_match(x)
    end

    local function PlayerHP(...)
      return prat_match(UnitHealth("player"))
    end

    local function PlayerMaxHP(...)
      return prat_match(UnitHealthMax("player"))
    end

    local function PlayerPercentHP()
      return prat_match(floor(100 * (UnitHealth("player") / UnitHealthMax("player"))))
    end

    local function PlayerHealthDeficit()
      return prat_match(UnitHealthMax("player") - UnitHealth("player"))
    end

    local function PlayerCurrentMana()
      return prat_match(UnitPower("player"))
    end

    local function PlayerMaxMana()
      return prat_match(UnitPowerMax("player"))
    end

    local function PlayerPercentMana()
      return prat_match(string.format("%.0f%%%%",
        floor(100 * (UnitPower("player") / UnitPowerMax("player")))))
    end

    local function PlayerManaDeficit()
      return prat_match(UnitPowerMax("player") - UnitPower("player"))
    end



    local function TargetPercentHP()
      local str = PL["<notarget>"]
      if UnitExists("target") then
        str = string.format("%.0f%%%%", floor(100 * (UnitHealth("target") / UnitHealthMax("target"))))
      end

      return prat_match(str)
    end

    local function TargetHealth()
      local str = PL["<notarget>"]
      if UnitExists("target") then
        str = UnitHealth("target")
      end

      return prat_match(str)
    end

    local function TargetHealthDeficit()
      local str = PL["<notarget>"]
      if UnitExists("target") then
        str = UnitHealthMax("target") - UnitHealth("target")
      end

      return prat_match(str)
    end

    local function TargetManaDeficit()
      local str = PL["<notarget>"]
      if UnitExists("target") then
        str = UnitPowerMax("target") - UnitPower("target")
      end

      return prat_match(str)
    end


    local function TargetClass()
      local class = PL["<notarget>"]
      if UnitExists("target") then
        class = UnitClass("target")
      end

      return prat_match(class)
    end

    local raidiconpfx = ICON_TAG_RAID_TARGET_STAR1:sub(1, -2) or "rt"

    local function TargetIcon()
      local icon = ""
      if UnitExists("target") then
        local iconnum = GetRaidTargetIndex("target")

        if type(iconnum) ~= "nil" then
          icon = ("{%s%d}"):format(raidiconpfx, tostring(iconnum))
        end
      end

      return prat_match(icon)
    end


    local function TargetRace()
      local race = PL["<notarget>"]
      if UnitExists("target") then
        if UnitIsPlayer("target") then
          race = UnitRace("target")
        else
          race = UnitCreatureFamily("target")
          if not race then
            race = UnitCreatureType("target")
          end
        end
      end
      return prat_match(race)
    end

    local function TargetGender()
      local sex = PL["<notarget>"]
      if UnitExists("target") then
        local s = UnitSex("target")
        if (s == 2) then
          sex = PL["male"]
        elseif (s == 3) then
          sex = PL["female"]
        else
          sex = PL["unknown sex"]
        end
      end

      return prat_match(sex)
    end

    local function TargetLevel()
      local level = PL["<notarget>"]
      if UnitExists("target") then
        level = UnitLevel("target")
      end
      return prat_match(level)
    end

    local function TargetGuild()
      local guild = PL["<notarget>"]
      if UnitExists("target") then
        guild = PL["<noguild>"]
        if IsInGuild("target") then
          guild = GetGuildInfo("target") or ""
        end
      end
      return prat_match(guild)
    end

    -- %tps (possesive)
    local function TargetPossesive()
      local p = PL["<notarget>"]
      if UnitExists("target") then
        local s = UnitSex("target")
        if (s == 2) then
          p = PL["his"]
        elseif (s == 3) then
          p = PL["hers"]
        else
          p = PL["its"]
        end
      end

      return prat_match(p)
    end

    -- %tpn (pronoun)
    local function TargetPronoun()
      local p = PL["<notarget>"]
      if UnitExists("target") then
        local s = UnitSex("target")
        if (s == 2) then
          p = PL["him"]
        elseif (s == 3) then
          p = PL["her"]
        else
          p = PL["it"]
        end
      end
      return prat_match(p)
    end

    -- %tn (target)
    local function TargetName()
      local t = PL['<notarget>']

      if UnitExists("target") then
        t = UnitName("target")
      end

      return prat_match(t)
    end

    -- %tt (target)
    local function TargetTargetName()
      local t = PL['<notarget>']

      if UnitExists("targettarget") then
        t = UnitName("targettarget")
      end

      return prat_match(t)
    end

    -- %mn (mouseover)
    local function MouseoverName()
      local t = PL['<notarget>']

      if UnitExists("mouseover") then
        t = UnitName("mouseover")
      end

      return prat_match(t)
    end

    -- %pn (player)
    local function PlayerName()
      local p = GetUnitName("player") or ""
      return prat_match(p)
    end


    local function PlayerAverageItemLevel()
      local avgItemLevel = GetAverageItemLevel();
      avgItemLevel = floor(avgItemLevel);

      return prat_match(avgItemLevel)
    end

    local function Rand()
      return prat_match(math.random(1, 100))
    end

    --[[
     * %tn = current target
     * %pn = player name
     * %hc = your current health
     * %hm = your max health
     * %hp = your percentage health
     * %hd = your current health deficit
     * %mc = your current mana
     * %mm = your max mana
     * %mp = your percentage mana
     * %md = your current mana deficit
     * %thp = target's percentage health
     * %th = target's current health
     * %td = target's health deficit
     * %tc = class of target
     * %tr = race of target
     * %ts = sex of target
     * %tl = level of target
     * %ti = raid icon of target
     * %tps = possesive for target (his/hers/its)
     * %tpn = pronoun for target (him/her/it)
     * %fhp = focus's percentage health
     * %fc = class of focus
     * %fr = race of focus
     * %fs = sex of focus
     * %fl = level of focus
     * %fps = possesive for focus (his/hers/its)
     * %fpn = pronoun for focus (him/her/it)
     * %tt = target of target
     * %zon = your current zone (Dun Morogh, Hellfire Peninsula, etc.)
     * %loc = your current subzone (as shown on the minimap)
     * %pos = your current coordinates (x,y)
     * %ypos = your current y coordinate
     * %xpos = your current x coordinate
     * %rnd = a random number between 1 and 100
     * %ail = your average item level
     --]]

    Prat:SetModulePatterns(module, {
      { pattern = "(%%thd)", matchfunc = TargetHealthDeficit, optname = PL["TargetHealthDeficit"], type = "OUTBOUND" },
      {
        pattern = "(%%thp)",
        matchfunc = TargetPercentHP,
        priority = 51,
        optname = PL["TargetPercentHP"],
        type = "OUTBOUND"
      },
      { pattern = "(%%tpn)", matchfunc = TargetPronoun, optname = PL["TargetPronoun"], type = "OUTBOUND" },

      { pattern = "(%%hc)", matchfunc = PlayerHP, optname = PL["PlayerHP"], type = "OUTBOUND" },
      { pattern = "(%%pn)", matchfunc = PlayerName, optname = PL["PlayerName"], type = "OUTBOUND" },
      { pattern = "(%%hm)", matchfunc = PlayerMaxHP, optname = PL["PlayerMaxHP"], type = "OUTBOUND" },
      { pattern = "(%%hd)", matchfunc = PlayerHealthDeficit, optname = PL["PlayerHealthDeficit"], type = "OUTBOUND" },
      { pattern = "(%%hp)", matchfunc = PlayerPercentHP, optname = PL["PlayerPercentHP"], type = "OUTBOUND" },
      { pattern = "(%%mc)", matchfunc = PlayerCurrentMana, optname = PL["PlayerCurrentMana"], type = "OUTBOUND" },
      { pattern = "(%%mm)", matchfunc = PlayerMaxMana, optname = PL["PlayerMaxMana"], type = "OUTBOUND" },
      { pattern = "(%%mp)", matchfunc = PlayerPercentMana, optname = PL["PlayerPercentMana"], type = "OUTBOUND" },
      { pattern = "(%%pmd)", matchfunc = PlayerManaDeficit, optname = PL["PlayerManaDeficit"], type = "OUTBOUND" },

      GetAverageItemLevel and {
        pattern = "(%%ail)",
        matchfunc = PlayerAverageItemLevel,
        optname = PL["PlayerAverageItemLevel"],
        type = "OUTBOUND"
      },

      { pattern = "(%%tn)", matchfunc = TargetName, optname = PL["TargetName"], type = "OUTBOUND" },
      { pattern = "(%%tt)", matchfunc = TargetTargetName, optname = PL["TargetTargetName"], type = "OUTBOUND" },
      { pattern = "(%%tc)", matchfunc = TargetClass, optname = PL["TargetClass"], type = "OUTBOUND" },
      { pattern = "(%%th)", matchfunc = TargetHealth, optname = PL["TargetHealth"], type = "OUTBOUND" },
      { pattern = "(%%tr)", matchfunc = TargetRace, optname = PL["TargetRace"], type = "OUTBOUND" },
      { pattern = "(%%ts)", matchfunc = TargetGender, optname = PL["TargetGender"], type = "OUTBOUND" },
      { pattern = "(%%ti)", matchfunc = TargetIcon, optname = PL["TargetIcon"], type = "OUTBOUND" },
      { pattern = "(%%tl)", matchfunc = TargetLevel, optname = PL["TargetLevel"], type = "OUTBOUND" },
      { pattern = "(%%tps)", matchfunc = TargetPossesive, optname = PL["TargetPossesive"], type = "OUTBOUND" },
      { pattern = "(%%tmd)", matchfunc = TargetManaDeficit, optname = PL["TargetManaDeficit"], type = "OUTBOUND" },
      { pattern = "(%%tg)", matchfunc = TargetGuild, optname = PL["TargetGuild"], type = "OUTBOUND" },

      { pattern = "(%%mn)", matchfunc = MouseoverName, optname = PL["MouseoverTargetName"], type = "OUTBOUND" },

      { pattern = "(%%zon)", matchfunc = Zone, optname = PL["MapZone"], type = "OUTBOUND" },
      { pattern = "(%%loc)", matchfunc = Loc, optname = PL["MapLoc"], type = "OUTBOUND" },
      { pattern = "(%%pos)", matchfunc = Pos, optname = PL["MapPos"], type = "OUTBOUND" },
      { pattern = "(%%ypos)", matchfunc = Ypos, optname = PL["MapYPos"], type = "OUTBOUND" },
      { pattern = "(%%xpos)", matchfunc = Xpos, optname = PL["MapXPos"], type = "OUTBOUND" },
      { pattern = "(%%rnd)", matchfunc = Rand, optname = PL["RandNum"], type = "OUTBOUND" },
    }

    --[[ TODO:
             %%fhp - focus health
             %%fr
             %%fc
             %%fs
             %%fl
             %%fvr
             %%fvn
             ]])
  end


  return
end) -- Prat:AddModuleToLoad