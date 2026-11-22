-- Supplies WoW APIs to the actual installed Ace libraries and Prat module loader.
LibStub = nil
unpack = table.unpack
loadstring = load
SlashCmdList = {}
strlenutf8 = string.len
strmatch, strfind, strsub, strlower, strtrim = string.match, string.find, string.sub, string.lower, function(text) return text:match("^%s*(.-)%s*$") end
function geterrorhandler() return function(message) _G.integrationError = message; print("INTEGRATION ERROR: " .. message) end end
function UnitFactionGroup() return "Alliance" end
function UnitClass() return "Mage", "MAGE" end
function UnitRace() return "Human", "Human" end
function UnitNameUnmodified() return "TestCharacter" end
function GetRealmName() return "TestRealm" end
function GetLocale() return "enUS" end
function GetCurrentRegionName() return "US" end
function GetCurrentRegion() return 1 end
function issecurevariable() return true end
function hooksecurefunc(object, method, callback)
	if type(object) == "string" then callback, method, object = method, object, _G end
	local original = assert(object[method], method)
	object[method] = function(...)
		local results = {original(...)}
		callback(...)
		return unpack(results)
	end
end
local frameMethods = getmetatable(UIParent).__index
function frameMethods:RegisterEvent() end
function frameMethods:UnregisterEvent() end
function frameMethods:UnregisterAllEvents() end
function frameMethods:IsEventRegistered() return true end
function wipe(tbl) for key in pairs(tbl) do tbl[key] = nil end; return tbl end
table.wipe = wipe
