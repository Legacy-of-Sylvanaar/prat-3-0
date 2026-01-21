local name, addonTable = ...

function addonTable:ExportProfile(profileKey)
	local profile = Prat.db.sv.profiles[profileKey]
	if not profile then return nil end
	local namespaces = {}
	for namespaceKey, namespaceData in pairs(Prat.db.sv.namespaces) do
		if namespaceData.profiles[profileKey] then
			namespaces[namespaceKey] = {}
			namespaces[namespaceKey].profiles = {}
			namespaces[namespaceKey].profiles[profileKey] = namespaceData.profiles[profileKey]
		end
	end
	local data = {
		profile = profile,
		namespaces = namespaces,
	}
	local dataString = C_EncodingUtil.EncodeBase64(C_EncodingUtil.SerializeCBOR(data))
	return dataString
end

function addonTable:ImportProfile(dataString, profileKey)
	local data = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecodeBase64(dataString))
	if not data then return false end
	Prat.db.sv.profiles[profileKey] = data.profile
	Prat.db.sv.profileKeys[UnitName("player") .. " - " .. GetRealmName()] = profileKey
	for namespaceKey, namespaceData in pairs(data.namespaces) do
		if not Prat.db.sv.namespaces[namespaceKey] then
			Prat.db.sv.namespaces[namespaceKey] = { profiles = {} }
		end
		Prat.db.sv.namespaces[namespaceKey].profiles[profileKey] = namespaceData.profiles[profileKey]
	end
end
