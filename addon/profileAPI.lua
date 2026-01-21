local name, addonTable = ...

function addonTable:ExportProfile(profileKey)
	local profile = Prat.db.profiles[profileKey]
	if not profile then return nil end
	local profileString = C_EncodingUtil.EncodeBase64(C_EncodingUtil.SerializeCBOR(profile))
	return profileString
end

function addonTable:ImportProfile(profileString, profileKey)
	local profile = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecodeBase64(profileString))
	if not profile then return false end
	Prat.db.profiles[profileKey] = profile
end
