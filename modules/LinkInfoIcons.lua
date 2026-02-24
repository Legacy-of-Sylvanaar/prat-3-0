---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2023  Prat Development Team
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
  local module = Prat:NewModule("LinkInfoIcons")
  local PL = module.PL

  --@debug@
  PL:AddLocale("enUS", {
    ["module_name"] = "LinkInfoIcons",
    ["module_desc"] = "Adds icons and item info to hyperlinks",
    ["full_description"] = "Adds icons and item info to links in the chat.",
    ["Item Links"] = "Item Links",
    ["Spell Links"] = "Spell Links",
    ["Achievement Links"] = "Achievement Links",
    ["Player Links"] = "Player Links",
    ["Icon"] = "Icon",
    ["Item Level"] = "Item Level",
    ["Item Type"] = "Item Type",
    ["Class Icon"] = "Class Icon",
    ["Class Label"] = "Class Label",
    ["Race Label"] = "Race Label",
  })
  --@end-debug@

  -- These Localizations are auto-generated. To help with localization
  -- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --[===[@non-debug@
do
    local L


--@localization(locale="enUS", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("enUS", L)



--@localization(locale="itIT", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("itIT", L)



--@localization(locale="ptBR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("ptBR", L)



--@localization(locale="frFR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("frFR", L)



--@localization(locale="deDE", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("deDE", L)



--@localization(locale="koKR", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("koKR",  L)


--@localization(locale="esMX", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("esMX",  L)


--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("ruRU",  L)


--@localization(locale="zhCN", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("zhCN",  L)


--@localization(locale="esES", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("esES",  L)


--@localization(locale="zhTW", format="lua_table", handle-subnamespaces="none", same-key-is-true=true, namespace="LinkInfoIcons")@
PL:AddLocale("zhTW",  L)
end
--@end-non-debug@]===]

	if not module:IsEnabled() then
		return
	end
  Prat:SetModuleDefaults(module.name, {
    profile = {
      on = false,
      item = {
        icon = true,
        itemLevel = true,
        itemType = true,
      },
      spell = {
        icon = true,
      },
      achievement = {
        icon = true,
      },
      player = {
        raceLabel = false,
        classIcon = true,
        classLabel = false,
      },
    }
  })

  Prat:SetModuleOptions(module.name, {
    name = PL.module_name,
    desc = PL.module_desc,
    type = "group",
    --childGroups = "tab",
    get = function(info)
      return module.db.profile[info[#info-1]][info[#info]]
    end,
    set = function(info, value)
      module.db.profile[info[#info-1]][info[#info]] = value
    end,
    args = {
      description = {
        name = PL["full_description"],
        type = "description",
        order = 10,
      },
      item = {
        name = PL["Item Links"],
        type = "group",
        order = 20,
        inline = true,
        args = {
          icon = {
            name = PL["Icon"],
            type = "toggle",
            order = 90
          },
          itemLevel = {
            name = PL["Item Level"],
            type = "toggle",
            order = 100
          },
          itemType = {
            name = PL["Item Type"],
            type = "toggle",
            order = 110
          },
        },
      },
      spell = {
        name = PL["Spell Links"],
        type = "group",
        inline = true,
        order = 30,
        args = {
          icon = {
            name = PL["Icon"],
            type = "toggle",
            order = 90
          },
        },
      },
      achievement = {
        name = PL["Achievement Links"],
        type = "group",
        inline = true,
        order = 40,
        args = {
          icon = {
            name = PL["Icon"],
            type = "toggle",
            order = 90
          },
        },
      },
      player = {
        name = PL["Player Links"],
        type = "group",
        inline = true,
        order = 50,
        args = {
          raceLabel = {
            name = PL["Race Label"],
            type = "toggle",
            order = 90
          },
          classIcon = {
            name = PL["Class Icon"],
            type = "toggle",
            order = 90
          },
          classLabel = {
            name = PL["Class Label"],
            type = "toggle",
            order = 90
          },
        },
      },
    },
  })

  Prat:SetModuleInit(module, function()
    Prat.RegisterMessageItem("PLAYERINFO", "PLAYER", "before")
  end)


  function module:OnModuleEnable()
  end

  function module:OnModuleEnable()
    Prat.RegisterChatEvent(self, "Prat_FrameMessage")
  end

  function module:OnModuleDisable()
    Prat.UnregisterAllChatEvents(self)
  end

  local function GetClassTexture(classFilename)
    return CreateAtlasMarkup(GetClassAtlas(classFilename), 12, 12, 0, -2)
  end

  -- replace text using prat event implementation
  function module:Prat_FrameMessage(_, message)
    if message.GUID == nil or (_G.issecretvalue and _G.issecretvalue(message.GUID)) then
      return
    end

    local playerLocation = PlayerLocation:CreateFromGUID(message.GUID)

    if not playerLocation:IsValid() then
      return
    end

    local className, classFilename = C_PlayerInfo.GetClass(playerLocation)
    local race = C_PlayerInfo.GetRace(playerLocation)
    local raceInfo = race and C_CreatureInfo.GetRaceInfo(race)

    if self.db.profile.player.classLabel and className ~= nil then
      message.PLAYERINFO = className .. " " .. message.PLAYERINFO
    end

    if self.db.profile.player.classIcon and classFilename ~= nil then
      message.PLAYERINFO = GetClassTexture(classFilename) .. message.PLAYERINFO
    end

    if self.db.profile.player.raceLabel and raceInfo ~= nil then
      message.PLAYERINFO = raceInfo.raceName .. " " .. message.PLAYERINFO
    end
  end


  function module:Prat_Ready()
    self:updateAll()
  end

  function module:GetDescription()
    return PL["module_desc"]
  end

  local function GetTexture(file)
    return CreateTextureMarkup(file, 64, 64, 12, 12, 0, 1, 0, 1, 0, -2)
  end

  local function GetPattern(type)
    return "|c.-|H" .. type .. ":.-|h.-|h|r"
  end

  local function IsGear(classID)
    return classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Weapon or classID == Enum.ItemClass.Profession
  end

  local function SubInItemInfo(link)
    local res = link

    local _, _, subType, equipLocation, icon, classID = C_Item.GetItemInfoInstant(link)

    local details = {}

    if module.db.profile.item.itemType then
      table.insert(details, subType)
    end

    if module.db.profile.item.itemType and IsGear(classID) and classID ~= Enum.ItemClass.Weapon and equipLocation and equipLocation ~= "" then
      table.insert(details, _G[equipLocation])
    end

    local level = C_Item.GetDetailedItemLevelInfo(link)
    if module.db.profile.item.itemLevel and IsGear(classID) and level then
      table.insert(details, level)
    end

    if #details > 0 then
      res = link:gsub("|h%[(.-)%]|h", "|h%[%1 %(" .. table.concat(details, " ") .. "%)%]|h")
    end

    if module.db.profile.item.icon and icon then
      res = GetTexture(icon) .. res
    end

    return res
  end

  local function SubInSpellInfo(link)
    local spellID = tonumber(link:match("Hspell:(%d+)"))
    local icon
    if C_Spell and C_Spell.GetSpellInfo then
      local info = C_Spell.GetSpellInfo(spellID)
      icon = info and info.iconID
    else
      icon = select(3, GetSpellInfo(spellID))
    end

    local res = link
    if module.db.profile.spell.icon and icon then
      res = GetTexture(icon) .. res
    end

    return res
  end

  local function SubInAchievementInfo(link)
    local achievementID = tonumber(link:match("Hachievement:(%d+)"))
    local icon = select(10, GetAchievementInfo(achievementID))

    local res = link
    if module.db.profile.achievement.icon and icon then
      res = GetTexture(icon) .. res
    end

    return res
  end

  Prat:RegisterPattern({
    pattern = GetPattern("item"),
    matchfunc = function(link)
      if module.db.profile.on then
        return Prat:RegisterMatch(SubInItemInfo(link))
      end
    end,
    type = "FRAME",
    priority = 43
  }, module.name)

  Prat:RegisterPattern({
    pattern = GetPattern("spell"),
    matchfunc = function(link)
      if module.db.profile.on then
        return Prat:RegisterMatch(SubInSpellInfo(link))
      end
    end,
    type = "FRAME",
    priority = 43
  }, module.name)

  Prat:RegisterPattern({
    pattern = GetPattern("achievement"),
    matchfunc = function(link)
      if module.db.profile.on then
        return SubInAchievementInfo(link)
      end
    end,
    type = "FRAME",
    priority = 41
  }, module.name)

  return
end) -- Prat:AddModuleToLoad
