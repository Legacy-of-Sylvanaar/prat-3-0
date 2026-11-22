Test.createFrames()
Prat = {
	Options = { args = { display = {args = {}}, formatting = {args = {}}, extras = {args = {}} } },
	CreateModuleControlOption = function() end,
	UpdateOptions = function() end,
	UnregisterAllPatterns = function() end,
	UnregisterAllChatEvents = function() end,
}
Prat.Addon = LibStub("AceAddon-3.0"):NewAddon("Prat")
Prat.db = LibStub("AceDB-3.0"):New("IntegrationPratDB", {profile = {modules = {["*"] = 3}}}, "Default")
PRAT_L = {}
