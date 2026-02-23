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

--[[ BEGIN STANDARD HEADER ]] --

-- Imports
local pairs, ipairs = pairs, ipairs
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat

-- Isolate the environment
setfenv(1, select(2, ...))

--[[ END STANDARD HEADER ]] --

function BuildLink(linktype, data, text, color, link_start, link_end)
  return "|cff" .. (color or "ffffff") .. "|H" .. linktype .. ":" .. data .. "|h" .. (link_start or "[") .. text .. (link_end or "]") .. "|h|r"
end


function FormatLink(linkType, linkDisplayText, ...)
  local linkFormatTable = { ("|H%s"):format(linkType), ... };
  local returnLink = tconcat(linkFormatTable, ":");
  if linkDisplayText then
    return returnLink .. ("|h%s|h"):format(linkDisplayText);
  else
    return returnLink .. "|h";
  end
end

do
  local LinkRegistry = {}

  -- linktype = { linkid, linkfunc, handler }
  function RegisterLinkType(linktype, who)
    if linktype and linktype.linkid and linktype.linkfunc then
      linktype.owner = who

      tinsert(LinkRegistry, linktype)

      local idx = #LinkRegistry
      return idx
    end
  end

  function UnregisterAllLinkTypes(who)
    for i, linktype in ipairs(LinkRegistry) do
      if linktype.owner == who then
        UnregisterLinkType(i)
      end
    end
  end

  function UnregisterLinkType(idx)
    tremove(LinkRegistry, idx)
  end

  function SetHyperlinkHook(hooks, tooltip, link, ...)
    for i, reg_link in ipairs(LinkRegistry) do
      if reg_link.linkid == link:sub(1, (reg_link.linkid):len()) then
        local frame
        for _,v in pairs(HookedFrames) do
          if v:IsMouseOver() and v:IsVisible() then
            frame = v
            break
          end
        end
        if (reg_link.linkfunc(reg_link.handler, link, frame, ...) == false) then
          return false
        end
      end
    end
    hooks.SetHyperlink(tooltip, link, ...)
  end
end


