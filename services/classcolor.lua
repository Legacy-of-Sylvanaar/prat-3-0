local _, private = ...

private.GetClassGetColorNew = function(class)
	if C_ClassColor then
		return C_ClassColor.GetClassColor(class);
	else
		if CUSTOM_CLASS_COLORS then
			local color = CUSTOM_CLASS_COLORS[class]
			return CreateColor(color.r, color.g, color.b)
		else
			return RAID_CLASS_COLORS[class]
		end
	end
end

private.GetClassGetColor = function(class)
  if private.GetGenderNeutralClass then
    class = private.GetGenderNeutralClass(class)
  end

  if class then
    class = class:upper()

    if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] then
      return CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
    end

    if Prat.IsClassic and class == "SHAMAN" then
      return 0.00, 0.44, 0.87
    end

    if RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] then
      return RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
    end
  end
  return 0.63, 0.63, 0.63
end
