local _, private = ...

local unpack = unpack
local ipairs = ipairs
local tsort, tremove = table.sort, table.remove
local type = type
local setmetatable = setmetatable
local rawset, rawget = rawset, rawget
local tostring = tostring
local random = math.random

function private:CaseInsensitveWordPattern(word)
	local upper = word:upper()
	local lower = word:lower()

	local pattern = ""
	for i = 1, word:len() do
		pattern = pattern .. "[" .. upper:sub(i, i) .. lower:sub(i, i) .. "]"
	end
	return pattern
end

local function uuid()
	local template = 'xyxxxxyx'
	return template:gsub('[xy]', function(c)
		local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
		return ('%x'):format(v)
	end)
end

local PatternRegistry = { patterns = {}, sortedList = {}, sorted = true }

do
	function private:RegisterPattern(pattern, who)
		local idx
		repeat
			idx = uuid()
		until PatternRegistry.patterns[idx] == nil

		PatternRegistry.patterns[idx] = pattern
		PatternRegistry.sortedList[#PatternRegistry.sortedList + 1] = pattern
		PatternRegistry.sorted = false

		pattern.owner = who
		pattern.idx = idx

		return idx
	end

	function private:UnregisterAllPatterns(who)
		for i, pattern in ipairs(PatternRegistry.sortedList) do
			if pattern.owner == who then
				tremove(PatternRegistry.sortedList, i)
				PatternRegistry.patterns[pattern.idx] = nil
			end
		end
	end
end

function private:GetPattern(idx)
	return PatternRegistry.patterns[idx]
end

function private:UnregisterPattern(idx)
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

	function private:RegisterMatch(text, ptype)
		tokennum = tokennum + 1

		local token = "@##" .. tokennum .. "##@"

		local mt = MatchTable[ptype or "FRAME"]
		mt[token] = text
		return token
	end

	function private:MatchPatterns(m, ptype)
		local text = m.MESSAGE
		if type(m) == "string" then
			text = m
			m = nil
		end
		if issecretvalue and issecretvalue(text) then
			return text
		end

		ptype = ptype or "FRAME"

		tokennum = 0

		if not PatternRegistry.sorted then
			tsort(PatternRegistry.sortedList, function(a, b)
				local ap = a.priority or 50
				local bp = b.priority or 50

				return ap < bp
			end)

			PatternRegistry.sorted = true
		end

		-- Match and remove strings
		for _, v in ipairs(PatternRegistry.sortedList) do
			if text and ptype == (v.type or "FRAME") then
				if type(v.pattern) == "string" and (v.pattern):len() > 0 then
					if v.deformat then
						text = v.matchfunc(text)
					else
						if v.matchfunc ~= nil then
							text = text:gsub(v.pattern, function(...)
								local parms = { ... }
								parms[#parms + 1] = m
								return v.matchfunc(unpack(parms))
							end)
						end
					end
				end
			end
		end
		return text
	end

	function private:ReplaceMatches(m, ptype)
		local text = m.MESSAGE
		if type(m) == "string" then
			text = m
		end
		if issecretvalue and issecretvalue(text) then
			return text
		end

		-- Substitute them (or something else) back in
		local mt = MatchTable[ptype or "FRAME"]

		local k
		for t = tokennum, 1, -1 do
			k = "@##" .. tostring(t) .. "##@"

			if mt[k] then
				local cleaned = mt[k]:gsub("(%W)", "%%%1")
				text = text:gsub(k, cleaned)
			end
			mt[k] = nil
		end
		return text
	end
end
