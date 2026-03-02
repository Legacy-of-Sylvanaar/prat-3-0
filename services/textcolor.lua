local _, private = ...

local tostring = tostring
local type = type
local table = table
local math = math
local string = string

local CLR = {}
private.CLR = CLR

CLR.DEFAULT = "ffffff" -- default to white
CLR.LINK = {
	"|cff", CLR.DEFAULT, "", "|r"
}
CLR.COLOR_NONE = nil

local function GetDefaultColor()
	return 1, 1, 1, 1
end

local function GetColor(c)
	if type(c.r) == "number" and type(c.g) == "number" and type(c.b) == "number" and type(c.a) == "number" then
		return c.r, c.g, c.b, c.a
	end
	if type(c.r) == "number" and type(c.g) == "number" and type(c.b) == "number" then
		return c.r, c.g, c.b, 1.0
	end
	return GetDefaultColor()
end

local function GetVarColor(a1, a2, a3, a4)
	if type(a1) == "table" then
		return GetColor(a1)
	end
	if type(a1) == "number" and type(a2) == "number" and type(a3) == "number" and type(a4) == "number" then
		return a1, a2, a3, a4
	end
	if type(a1) == "number" and type(a2) == "number" and type(a3) == "number" and type(a4) == "nil" then
		return a1, a2, a3, 1.0
	end
	return GetDefaultColor()
end

local function Mult255(r, g, b, a)
	return r * 255, g * 255, b * 255, a
end

function CLR:GetHexColor(a1, a2, a3, a4)
	return string.format("%02x%02x%02x", Mult255(GetVarColor(a1, a2, a3, a4)))
end

function CLR:GetHashColor(text)
	local hash = 17

	for i = 1, text:len() do
		hash = hash * 37 * text:byte(i)
	end

	local r = math.floor(math.fmod(hash / 97, 255))
	local g = math.floor(math.fmod(hash / 17, 255))
	local b = math.floor(math.fmod(hash / 227, 255))

	if ((r * 299 + g * 587 + b * 114) / 1000) < 105 then
		r = math.abs(r - 255)
		g = math.abs(g - 255)
		b = math.abs(b - 255)
	end

	return ("%02x%02x%02x"):format(r, g, b)
end

function CLR:Random(text)
	return CLR:Colorize(self:GetHashColor(text), text)
end

function CLR:Colorize(hexColor, text)
	if text == nil or text == "" then
		return ""
	end

	local color = hexColor
	if type(hexColor) == "table" then
		color = self:GetHexColor(hexColor)
	end

	if color == CLR.COLOR_NONE then
		return text
	end

	local link = CLR.LINK

	link[2] = tostring(color or 'ffffff')
	link[3] = text

	return table.concat(link, "")
end

local function Desaturate(c)
	return ((c or 1.0) * 192 * 0.8 + 63) / 255
end

function CLR:Desaturate(a1, a2, a3, a4)
	local r, g, b, a = GetVarColor(a1, a2, a3, a4)

	r = Desaturate(r)
	g = Desaturate(g)
	b = Desaturate(b)

	return r, g, b, a
end
