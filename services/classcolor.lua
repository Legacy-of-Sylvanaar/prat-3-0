local _, private = ...

local defaultColor = CreateColor(0.63, 0.63, 0.63)

function private.GetClassColor(class, isLocal)
	if not class then
		return defaultColor
	end

	if isLocal then
		local found
		for k, v in next, LOCALIZED_CLASS_NAMES_FEMALE do
			if v == class then
				class = k
				found = true
				break
			end
		end
		if not found then
			for k, v in next, LOCALIZED_CLASS_NAMES_MALE do
				if v == class then
					class = k
					break
				end
			end
		end
	end

	if C_ClassColor then
		return C_ClassColor.GetClassColor(class) or defaultColor
	end

	if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] then
		local color = CUSTOM_CLASS_COLORS[class]
		return CreateColor(color.r, color.g, color.b)
	end

	return RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] or defaultColor
end
