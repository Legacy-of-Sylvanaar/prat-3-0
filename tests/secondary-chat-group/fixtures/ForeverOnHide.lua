-- Excerpt: Gethe/wow-ui-source, Forever commit 734f065329cff4992835b01a84f210a297db91b6
function FloatingChatFrameMixin:OnHide()
	--If the top-level parent is hidden (Alt-Z), OnHide is called, but self:IsShown() is still true (self:IsVisible() would be false)
	if ( not self:IsShown() ) then
		if ( not self.minimized ) then
			SetChatWindowShown(self:GetID(), false);
		end
	end

	self:ClearGamepadFocus();
end
