------------------- Base panel
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(5, 50, 5, 5)

	self.BackButton = vgui.Create("aScoreboardButton", self)
	self.BackButton:SetSize(100, 35)	
	self.BackButton.Text = "Back"
	self.BackButton.Col = aScoreboard.Color
	self.BackButton.DoClick = function()
		aScoreboard.Base:SetActivePanel(aScoreboard.Base.Players)
	end

	self.Scroller = vgui.Create("DScrollPanel", self)
	self.Scroller:Dock(FILL)
	--self.Scroller:DockPadding(5, 5, 5, 5)
	self.Scroller:DockMargin(5, 5, 5, 5)
	self.Scroller.Paint = function() end
	aScoreboard.PaintScroll(self.Scroller)

	self.GeneralCommands = vgui.Create("DPanel", self.Scroller)
	self.GeneralCommands:DockMargin(0, 0, 0, 5)
	self.GeneralCommands.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
		surface.SetFont("aScoreboardTitle")

		draw.SimpleText("Player information", "aScoreboardTitle", 10, 6, Color(210, 210, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 38, w - 20, 2, aScoreboard.Color) 
	end

	self.TopInfoPanel = vgui.Create("DPanel", self.GeneralCommands)
	self.TopInfoPanel:SetTall(96)
	self.TopInfoPanel:Dock(TOP)
	self.TopInfoPanel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, Color(51, 51, 51, 255))

		surface.SetFont("aScoreboardTitle")
		local w, h = surface.GetTextSize(self:GetPlayer():Nick() or "")

		draw.SimpleText(self:GetPlayer():Nick() or "", "aScoreboardTitle", 96, 0, Color(210, 210, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 95, 32, w + 5, 2, aScoreboard.Color) 

		w, h = 250, 26
		draw.RoundedBox(4, 95, 36, w, h, Color(61, 61, 61, 255))
		draw.RoundedBox(4, 97, 38, math.Clamp(self:GetPlayer():Health(), 2, 100)/100*(w - 4), h - 4, aScoreboard.Color)
		draw.SimpleText(self:GetPlayer():Health(), "aScoreboard18", 97 + w/2 , 36 + h/2, Color(210, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.RoundedBox(4, 95, 64, w, h, Color(61, 61, 61, 255))
		draw.RoundedBox(4, 97, 66, math.Clamp(self:GetPlayer():Armor(), 2, 100)/100*(w - 4), h - 4, Color(66, 139, 202, 255))
		draw.SimpleText(self:GetPlayer():Armor(), "aScoreboard18", 97 + w/2, 64 + h/2, Color(210, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end


	self.CopyButtons = {
		{name = "Name", 			func = function() return self:GetPlayer():Nick() end},
		{name = "Kills", 			func = function() return self:GetPlayer():Frags() end},
		{name = "Deaths", 			func = function() return self:GetPlayer():Deaths() end},
		{name = "Ping", 			func = function() return self:GetPlayer():Ping() end},
		{name = "SteamID", 			func = function() return self:GetPlayer():SteamID() end},
		{name = "SteamID 64", 		func = function() return self:GetPlayer():SteamID64() end},
		{name = "Community Link", 	func = function() return "http://steamcommunity.com/profiles/" .. (self:GetPlayer():SteamID64() or "BOT")  end},
		{name = "Rank", 			func = function() return self:GetPlayer():GetUserGroup() end},
	}

	self.BottomInfoPanel = vgui.Create("DPanel", self.GeneralCommands)
	for k, v in pairs(self.CopyButtons) do
		self.BottomInfoPanel[v.name] = vgui.Create("DButton", self.BottomInfoPanel)
		self.BottomInfoPanel[v.name]:SetSize(120, 30)
		self.BottomInfoPanel[v.name]:SetText("")
		self.BottomInfoPanel[v.name].Paint = function(this, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(61, 61, 61))
			if this:IsHovered() then
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 20))
			end
			draw.SimpleText(v.name, "aScoreboard20", w/2, h/2, Color(250, 250, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		end
		self.BottomInfoPanel[v.name].DoClick = function() 
			SetClipboardText(v.func())
		end
	end
	self.BottomInfoPanel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, Color(51, 51, 51, 255))
	end

	self.Avatar = vgui.Create("AvatarCircleMask", self.TopInfoPanel)
	self.Avatar:SetSize(84, 84)
	self.Avatar:SetMaskSize(84 / 2)

	if aScoreboard.DarkRP then
		self.DarkRPCommands = vgui.Create("DPanel", self.Scroller)
		self.DarkRPCommands.Paint = function(this, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255)) end

		self.DarkRPCommands.Access = {}
		self.DarkRPCommands.Util = {}
		self.DarkRPCommands.Admin = {}	

		local col1, col2, col3 = Color(217, 83, 79, 255), Color(92, 184, 92, 255), Color(228, 100, 75, 255)
		if aScoreboard.UniformColor then
	        col1, col2, col3 = aScoreboard.Color, aScoreboard.Color, aScoreboard.Color
	    end

		for k, v in pairs(FAdmin.ScoreBoard.Player.ActionButtons) do
			if v. color and v.color.g == 200 then
				v.aColor = col1
				table.insert(self.DarkRPCommands.Util, v)
			elseif v.color and v.color.g == 130 then
				v.aColor = col3
				table.insert(self.DarkRPCommands.Admin, v)
			else
				v.aColor = col2
				table.insert(self.DarkRPCommands.Access, v)			
			end
		end

		self:AddClassCommands("Access", 			col2, 	self.DarkRPCommands.Access)
		self:AddClassCommands("Utility", 			col1, 	self.DarkRPCommands.Util)
		self:AddClassCommands("Administration", 	col3, 	self.DarkRPCommands.Admin)
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

function PANEL:Think()
	if not IsValid(self:GetPlayer()) then
		self:SetPlayer(LocalPlayer()) --Fairly certain LocalPlayer will always be valid when used like this, fuck me if not
		aScoreboard.Base:SetActivePanel(aScoreboard.Base.Players)
	end
end

function PANEL:SetPlayer(ply)
	
	self.Player = ply
	self.Avatar:SetPlayer(ply, 128)

	for k, v in pairs(self.CopyButtons) do
		self.BottomInfoPanel[v.name]:SetTooltip(v.func() or "") 
	end

	if aScoreboard.DarkRP then
		FAdmin.ScoreBoard.Player.Player = ply
	end

	self:InvalidateLayout(true)
end

function PANEL:GetPlayer()
	return self.Player or LocalPlayer()
end

function PANEL:PerformLayout()
	self.BackButton:SetPos(10, 10)

	self.Scroller:InvalidateLayout(true)

	self.GeneralCommands:Dock(TOP)

	self.GeneralCommands:SetTall(230)

	self.TopInfoPanel:DockMargin(5, 47, 5, 5)

	self.BottomInfoPanel:Dock(FILL)
	self.BottomInfoPanel:DockMargin(5, 0, 5, 5)

	self.Avatar:SetPlayer(self:GetPlayer(), 128)
	self.Avatar:SetPos(5, 5)

	self.BottomInfoPanel:InvalidateLayout(true)

	local x, y = 0, 5
	for k, v in pairs(self.BottomInfoPanel:GetChildren()) do
		v:SetSize(self.BottomInfoPanel:GetWide()/4 - 8, self.BottomInfoPanel:GetTall()/2 - 7)
		v:SetPos(x + 5, y)
		x = x + self.BottomInfoPanel:GetWide()/4

		if x > (self.BottomInfoPanel:GetWide() - 20) then
			y = y + (self.BottomInfoPanel:GetTall()/2 - 2)
			x = 0
		end
	end

	if aScoreboard.DarkRP then
		self.DarkRPCommands:Dock(TOP)
		self.DarkRPCommands:SetTall(self:GetTall() - self.GeneralCommands:GetTall() - 70)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
	--draw.SimpleText(self.Player:GetName(), "aScoreboardSubTitle", 40, 2, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	--draw.SimpleText(self.Player:GetUserGroup(), "aScoreboard19", 40, 20, Color(210, 210, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

function PANEL:AddCopyInfo(name, value, parent)
	local base = vgui.Create("DPanel", parent)
	base:SetSize(200, 28)
	base:DockMargin(5, 5, 5, 0)
	base.Paint = function(this, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255)) end

	base.Copy = vgui.Create("DButton", base)
	base.Copy:Dock(LEFT)
	base.Copy:SetText("")
	base.Copy:SetWide(28)
	base.Copy.DoClick = function() SetClipboardText(value) end
	base.Copy.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, aScoreboard.Color)
		surface.SetMaterial(aScoreboard.Icons.Copy)	
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawTexturedRect(2, 2, 24, 24)
	end

	base.Lbl = vgui.Create("DLabel", base)
	base.Lbl:Dock(FILL)
	base.Lbl:DockMargin(5, 0, 0, 0)
	base.Lbl:SetFont("aScoreboard22")
	base.Lbl:SetText(name .. " : " .. value)

	base:InvalidateLayout(true)
	base:SizeToContents(true, true)

	return base
end

function PANEL:AddClassCommands(name, colour, content)
	local base = vgui.Create("DPanel", self.DarkRPCommands)
	base:Dock(LEFT)
	base:DockMargin(5, 5, 0, 5)
	base:DockPadding(5, 40, 5, 5)
	base.PerformLayout = function()
		base:SetWide(self.DarkRPCommands:GetWide()/3 - 10)	
	end
	base.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		draw.SimpleText(name, "aScoreboardTitle", 12, 4, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, colour)
	end

	base.Scroll = vgui.Create("DScrollPanel", base)
	base.Scroll:DockMargin(5, 5, 5, 0)
	base.Scroll:Dock(FILL)

	local scr 				= base.Scroll:GetVBar()
	scr.Paint 				= function() draw.RoundedBox(4, 0, 0, scr:GetWide(), scr:GetTall(), Color(62, 62, 62)) end
	scr.btnUp.Paint 		= function() end
	scr.btnDown.Paint 		= function() end
	scr.btnGrip.Paint 		= function() draw.RoundedBox(6, 2, 0, scr.btnGrip:GetWide()-4, scr.btnGrip:GetTall()-2, colour) end

	for k, v in pairs(content) do
        local b = vgui.Create("FAdminActionButton", base.Scroll)

        local name = v.Name
        if type(name) == "function" then name = name(self:GetPlayer()) end
        b:SetText("")
    	b:SetTall(30)
        b.Text = name
        b:SetBorderColor(v.color)
        b:SetDisabled(true)
        b.PerformLayout = function()
        	b:SetText("")
        	b.m_Image:SetSize(0, 0)
        	b.m_Image2:SetSize(0, 0)
        	b:SetWide(b:GetParent():GetWide() - 10)
        	b.Text = name
        end
        --b.DoClick = function() end
        b.OnMouseReleased = function()
            if not IsValid(self:GetPlayer()) then return end
           	v.Action(self:GetPlayer(), b)
           	b:InvalidateLayout()
           	return
    	end
        if v.OnButtonCreated then
            v.OnButtonCreated(self:GetPlayer(), b)
        end
        b.Paint = function(this, w, h)
        	if not (v.Visible == true or (type(v.Visible) == "function" and v.Visible(self:GetPlayer()) == true)) then
				draw.RoundedBox(4, 0, 0, w, h, Color(61, 61, 61))
				draw.SimpleText(this.Text, "aScoreboard22", w/2, h/2, Color(120, 120, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			else
				draw.RoundedBox(4, 0, 0, w, h, v.aColor)
				if this:IsHovered() then
					draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 20))
				end
				draw.SimpleText(this.Text, "aScoreboard22", w/2, h/2, Color(255, 253, 252), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			end
        end
		b:DockMargin(5, 5, 5, 5)

		base.Scroll:SizeToChildren(false, true)
		b:Dock(TOP) 	
	end
end

vgui.Register("aScoreboardPlayerInspect", PANEL, "DPanel")