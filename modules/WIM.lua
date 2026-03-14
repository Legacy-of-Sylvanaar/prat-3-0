tinsert(Prat.EnableTasks, function()
	-- Register formatting with WIM.
	if (WIM and WIM.RegisterMessageFormatting) then
		WIM.RegisterMessageFormatting("Prat", function(smf, event, ...)
			return Prat.Format(smf, event, WIM.nextColor, ...)
		end)
	end
end)
