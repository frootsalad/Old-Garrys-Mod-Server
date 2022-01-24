local NoticeColor = {}
NoticeColor[NOTIFY_GENERIC]		= Color(66, 139, 202)
NoticeColor[NOTIFY_ERROR]		= Color(215, 85, 80)
NoticeColor[NOTIFY_UNDO]		= Color(92, 184, 92)
NoticeColor[NOTIFY_HINT]		= Color(91, 192, 222)
NoticeColor[NOTIFY_CLEANUP]		= Color(228, 100, 75)

local PANEL = {}

function PANEL:Init()
	self:DockPadding(6, 5, 6, 2)

	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(LEFT)
	self.Label:SetFont("aHUD22")
	self.Label:SetTextColor(Color(210, 210, 210))

	self.Col = aHUD.Color
end

function PANEL:SetText(txt)
	self.Label:SetText(txt)
	self:SizeToContents()
end

function PANEL:SizeToContents()
	self.Label:SizeToContents()

	local width = self.Label:GetWide()

	--if (IsValid(self.Image)) then
		width = width + 14
	--end
	self:SetWidth(math.max(width, 160))

	self:SetHeight(32)

	self:InvalidateLayout()
end

function PANEL:SetLegacyType(t)
	self.Type = t
	if aHUD.UniformNotificationColour then
		self.Col = aHUD.Color
	else
		self.Col = NoticeColor[self.Type]
	end
	
	self:SizeToContents()
end

function PANEL:SetProgress()
	self.Paint = function(s, w, h)
		self.BaseClass.Paint(self, w, h)

	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
	draw.RoundedBox(0, 0, 0, w, 4, self.Col)

	local time = self.StartTime + self.Length
	local timeleft = math.Round(time - SysTime(), 4)
	draw.RoundedBox(0, 0, 4, w*(timeleft/self.Length), h-4, Color(self.Col.r, self.Col.g, self.Col.b, 70))
end

function PANEL:KillSelf()
	if (self.StartTime + self.Length < SysTime()) then
		self:Remove()
		return true
	end

	return false
end

vgui.Register("NoticePanel", PANEL, "DPanel")