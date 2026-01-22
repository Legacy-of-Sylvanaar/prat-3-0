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
local _G = _G

local table = table
local unpack = unpack
local pairs, ipairs = pairs, ipairs
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat
local wipe = wipe
local type = type
local setmetatable = setmetatable
local rawset, rawget = rawset, rawget
local tostring, tonumber = tostring, tonumber
local random = math.random

-- Isolate the environment
setfenv(1, select(2, ...))

--[[ END STANDARD HEADER ]] --



local debug = function(...)
  -- _G.ChatFrame1:print(...)
end

function CaseInsensitveWordPattern(word)
  local upper = word:upper()
  local lower = word:lower()

  local pattern = ""
  for i=1,word:len() do
    pattern = pattern .. "[" .. upper:sub(i, i) .. lower:sub(i, i) .. "]"
  end
  return pattern
end

local function uuid()
  local template ='xyxxxxyx'
  return template:gsub('[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return ('%x'):format(v)
  end)
end

-- Register a pattern with the pattern matching engine
-- You can supply a priority 1 - 100. Default is 50
-- 1 = highest, 100 = lowest.
-- pattern = { pattern, matchfunc, priority, type}
--
-- Priorities arent used currently, they are to help with
-- collisions later on if there are alot of patterns
--
local PatternRegistry = { patterns = {}, sortedList = {}, sorted = true}

--@debug@
_G.Prat.PatternRegistry = PatternRegistry
--@end-debug@

do
  function RegisterPattern(pattern, who)
    local idx
    repeat
      idx = uuid()
    until PatternRegistry.patterns[idx] == nil

    PatternRegistry.patterns[idx] = pattern
    PatternRegistry.sortedList[#PatternRegistry.sortedList+1] = pattern
    PatternRegistry.sorted = false

    pattern.owner = who
    pattern.idx = idx

    debug("RegisterPattern", who, pattern)

    return idx
  end

  function UnregisterAllPatterns(who)
    debug("UnregisterAllPatterns", who)

    for i, pattern in ipairs(PatternRegistry.sortedList) do
      if pattern.owner == who then
        tremove(PatternRegistry.sortedList, i)
        PatternRegistry.patterns[pattern.idx] = nil
      end
    end
  end
end

function GetPattern(idx)
  return PatternRegistry.patterns[idx]
end

function UnregisterPattern(idx)
  for i, pattern in ipairs(PatternRegistry.sortedList) do
    if pattern.idx == idx then
      tremove(PatternRegistry.sortedList, i)
      PatternRegistry.patterns[pattern.idx] = nil
      return
    end
  end
end

do
  local tokennum = 1

  local MatchTable = setmetatable({}, {
    __index = function(self, key)
      if type(rawget(self, key)) ~= "table" then
        rawset(self, key, {})
      end
      return rawget(self, key)
    end
  })


  function RegisterMatch(self, text, ptype)
    tokennum = tokennum + 1

    local token = "@##" .. tokennum .. "##@"

    debug("RegisterMatch", text, token)

    local mt = MatchTable[ptype or "FRAME"]
    mt[token] = text

    --   return text
    return token
  end

  function MatchPatterns(m, ptype)
    local startTime = _G.debugprofilestop()

    local text = m.MESSAGE
    if type(m) == "string" then
      text = m
      m = nil
    end
	  if _G.issecretvalue and _G.issecretvalue(text) then
		  return text
	  end

    ptype = ptype or "FRAME"

    tokennum = 0

    if not PatternRegistry.sorted then
      table.sort(PatternRegistry.sortedList, function(a, b)
        local ap = a.priority or 50
        local bp = b.priority or 50

        return ap < bp
      end)

      PatternRegistry.sorted = true
    end

    debug("MatchPatterns -->", text, tokennum)
    -- Match and remove strings
    for _, v in ipairs(PatternRegistry.sortedList) do
      if text and ptype == (v.type or "FRAME") then

        if type(v.pattern) == "string" and (v.pattern):len() > 0 then
          debug("MatchPatterns :", v.pattern)

          if v.deformat then
            text = v.matchfunc(text)
          else
            if v.matchfunc ~= nil then
              text = text:gsub(v.pattern, function(...) local parms = {...} parms[#parms+1] = m return v.matchfunc(unpack(parms)) end)
            else
              debug("ERROR", v.pattern)
            end
          end
        end
      end
    end

    local runTime = _G.debugprofilestop() - startTime
    debug("MatchPatterns <--", text, tokennum, runTime)

    if m then
      m.PATTERN_TIMES = { match = runTime  }
    end

    return text
  end

  function ReplaceMatches(m, ptype)
    local startTime = _G.debugprofilestop()
    local text = m.MESSAGE
    if type(m) == "string" then
      text = m
      m = nil
    end
	  if _G.issecretvalue and _G.issecretvalue(text) then
		  return text
	  end

    -- Substitute them (or something else) back in
    local mt = MatchTable[ptype or "FRAME"]

    debug("ReplaceMatches -->", text)

    local k
    for t = tokennum, 1, -1 do
      k = "@##" .. tostring(t) .. "##@"

      if (mt[k]) then
        local cleaned = mt[k]:gsub("(%W)", "%%%1")
        text = text:gsub(k, cleaned)
      else
        debug("ERROR", k)
      end
      mt[k] = nil
    end

    --	    for k,v in pairs(mt) do
    --	        text = text:gsub(k, v)
    --	        mt[k] = nil
    --	    end

    local runTime = _G.debugprofilestop() - startTime
    debug("ReplaceMatches <--", text, runTime)

    if m then
      m.PATTERN_TIMES.replace = runTime
    end

    return text
  end
end







