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





Prat:AddModuleExtension(function()
  local module = Prat.Addon:GetModule("PlayerNames", true)

  if not module then return end

  LibStub("AceTimer-3.0"):Embed(module)

  local PL = module.PL

  module.pluginopts["GlobalPatterns"] = {
    coloreverywhere = {
      type = "toggle",
      name = PL["coloreverywhere_name"],
      desc = PL["coloreverywhere_desc"],
      order = 220
    }
  }

  Prat.RegisterPattern({
    pattern = "|c.-|H.-:.-|h.-|h|r",
    matchfunc = function(link) return Prat:RegisterMatch(link) end,
    type = "FRAME",
    priority = 44
  }, module.name)

  Prat.RegisterPattern({
    pattern = "|H.-:.-|h.-|h",
    matchfunc = function(link) return Prat:RegisterMatch(link) end,
    type = "FRAME",
    priority = 45
  }, module.name)

  Prat.RegisterPattern({
    pattern = "|K.-|k",
    matchfunc = function(link) return Prat:RegisterMatch(link) end,
    type = "FRAME",
    priority = 45
  }, module.name)

  local ColorPlayer
  do
    local function Player(name, class)
      return Prat.CLR:Player(name, name, class)
    end

    ColorPlayer = function(name)
      return Prat:RegisterMatch(Player(name, module:GetData(name)))
    end
  end

  local function newPattern(name)
    return { pattern = Prat.GetNamePattern(name), matchfunc = ColorPlayer, priority = 48 }
  end

  do
    local namePatterns = {}

    function module:OnPlayerDataChangedThrottled(Name)
      self.timerPlayerData = nil

      if self.db.profile.coloreverywhere and Name then
        Name = Name:match("(.-)%-.+") or Name
        Name = Name:lower()
        if not namePatterns[Name] and not Prat.PlayerNameBlackList[Name] and Name:len() > 1 then
          namePatterns[Name] = Prat.RegisterPattern(newPattern(Name), self.name)
        end
      else
        for k, v in pairs(namePatterns) do
          Prat.UnregisterPattern(v)
          namePatterns[k] = nil
        end
      end
    end

    function module:OnPlayerDataChanged(Name)
      if not self.db.profile.coloreverywhere then return end

      self:OnPlayerDataChangedThrottled(Name)
    end
  end

  return
end) -- Prat:AddModuleToLoad