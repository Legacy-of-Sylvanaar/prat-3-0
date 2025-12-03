tinsert(Prat.EnableTasks, function(self)
	-- Register formatting with WIM.
	if (_G.WIM and _G.WIM.RegisterMessageFormatting) then
		_G.WIM.RegisterMessageFormatting("Prat", function(smf, event, ...)
			return Prat.Format(smf, event, _G.WIM.nextColor, ...)
		end)
	end
end)
