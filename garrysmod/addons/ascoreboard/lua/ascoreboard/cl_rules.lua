------------------ Rules page
local PANEL = {}

function PANEL:Init()
	self.Type 		= 0
	self.Rules 		= ""
	self:Dock(FILL)
	self:DockPadding(5, 5, 5, 5)

	if aScoreboard.UseHTMLRules then
		self.Body = vgui.Create("DHTML", self)
		self.Body:Dock(FILL)
		self.Body:OpenURL(aScoreboard.RulesLink)
	else
		self.RichText = vgui.Create("RichText", self)
		self.RichText:Dock(FILL)
		self.RichText:InsertColorChange(210, 210, 210, 255)

		self:GetRules()
	end
end

function PANEL:GetRules()
	if aScoreboard.UseLink then
		http.Fetch(aScoreboard.RulesLink,
			function(body, len, headers, code)
				if self.Rules then
					self.Rules = body
					self.RichText:AppendText(self.Rules)
					self:InvalidateLayout()
				end
			end,
			function(error)
				MsgC(Color(240, 173, 78), "[aScoreboard] ", Color(210, 210, 210), "Failed to get online rules, reverting to config set.\n")
				self.Rules = aScoreboard.Rules
				self.RichText:AppendText(self.Rules)
				self:InvalidateLayout()
			end
		)
	else
		self.Rules = aScoreboard.Rules
		self.RichText:AppendText(self.Rules)
		self:InvalidateLayout()
	end
end

function PANEL:PerformLayout()
		if not aScoreboard.UseHTMLRules then self.RichText:SetFontInternal("aScoreboard22") end
		--self.RichText:SetFGColor(Color(255, 255, 255))
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
end

vgui.Register("aScoreboardRules", PANEL, "DPanel")