local PANEL = {}

function PANEL:Init()
	self.Name = ""
	self.Col = Color(255, 255, 255, 255)

	self:DockPadding(5, 26, 5, 5)
	self:DockMargin(0, 5, 0, 0)
	self:Dock(TOP)
end


function PANEL:PerformLayout()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(51, 51, 51, 255))
	draw.SimpleText(self.Name, "aScoreboardSubTitle", 7, 2, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

function PANEL:Think()
	if #self:GetChildren() == 0 then
		self:Remove()
	end
end


vgui.Register("aScoreboardGroup", PANEL, "DPanel")