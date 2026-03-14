local LSM = LibStub("LibSharedMedia-3.0")

if not LSM then
	return
end

local folder = [[Prat-3.0\fonts\]]

-- From SharedMedia
LSM:Register("font", "Bazooka", [[Interface\Addons\]] .. folder .. [[Bazooka.ttf]])
LSM:Register("font", "DorisPP", [[Interface\Addons\]] .. folder .. [[DORISPP.ttf]])
LSM:Register("font", "Enigmatic", [[Interface\Addons\]] .. folder .. [[Enigma__2.ttf]])

-- From SharedMediaAdditionalFonts
LSM:Register("font", "Liberation Sans (U)", [[Interface\Addons\]] .. folder .. [[LiberationSans-Regular.ttf]])

-- From UrbanFonts.com
LSM:Register("font", "Fira Mono", [[Interface\Addons\]] .. folder .. [[FiraMono-Regular.ttf]])
LSM:Register("font", "Crystal", [[Interface\Addons\]] .. folder .. [[CRYSRG__.ttf]])
LSM:Register("font", "White Rabbit", [[Interface\Addons\]] .. folder .. [[WHITRABT.ttf]])
LSM:Register("font", "Monofonto", [[Interface\Addons\]] .. folder .. [[MONOFONT.ttf]])
LSM:Register("font", "FSEX300 (U)", [[Interface\Addons\]] .. folder .. [[FSEX300.ttf]])
LSM:Register("font", "DejaVu (U)", [[Interface\Addons\]] .. folder .. [[DejaVuSansMono.ttf]])

-- From http://www.google.com/webfonts
LSM:Register("font", "Anonymous Pro Bold (U)", [[Interface\Addons\]] .. folder .. [[AnonymousPro-Bold.ttf]])
