tinsert(Prat.EnableTasks, function()
	if not LibStub:GetLibrary("LibDataBroker-1.1", true) then
		return
	end
	LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Prat", {
		type = "launcher",
		text = "Prat |cff8080ff3.0|r",
		icon = "Interface\\Addons\\Prat-3.0\\textures\\prat-logo-dark-small",
		OnClick = function()
			Prat:ToggleOptionsWindow()
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(Prat.Version)
		end,
	})
end)
