------------------ Website link page
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:SetVisible(false)

	self.DarkRPCommands = vgui.Create("DPanel", self)
	--self.DarkRPCommands:DockMargin(5, 5, 5, 5)
	--self.DarkRPCommands.Paint = function(this, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255)) end
	self.DarkRPCommands.Paint = function(this, w, h) end

	self.DarkRPCommands.ServerActions = {}
	self.DarkRPCommands.ServerSettings = {}
	self.DarkRPCommands.PlayerActions = {}	

	for k, v in pairs(FAdmin.ScoreBoard.Server.ActionButtons) do
		if v.TYPE == "ServerSettings" then
			v.aColor = Color(92, 184, 92, 255)
			table.insert(self.DarkRPCommands.ServerSettings, v)
		elseif v.TYPE == "PlayerActions" then
			v.aColor = Color(228, 100, 75, 255)
			table.insert(self.DarkRPCommands.PlayerActions, v)
		else
			v.aColor = Color(217, 83, 79, 255)
			table.insert(self.DarkRPCommands.ServerActions, v)			
		end
	end

	local col1, col2, col3 = Color(217, 83, 79, 255), Color(92, 184, 92, 255), Color(228, 100, 75, 255)
	if aScoreboard.UniformColor then
        col1, col2, col3 = aScoreboard.Color, aScoreboard.Color, aScoreboard.Color
    end

	self:AddClassCommands("Server Actions", 	col1, 	self.DarkRPCommands.ServerActions)
	self:AddClassCommands("Server Settings", 	col2, 	self.DarkRPCommands.ServerSettings)
	self:AddClassCommands("Player Actions", 	col3, 	self.DarkRPCommands.PlayerActions)

	self:InvalidateLayout(true)
end

function PANEL:PerformLayout()
	self.DarkRPCommands:Dock(FILL)
end

function PANEL:AddClassCommands(name, colour, content)
	local base = vgui.Create("DPanel", self.DarkRPCommands)
	base:Dock(LEFT)
	base:DockMargin(5, 5, 0, 5)
	base:DockPadding(5, 40, 5, 5)
	base.PerformLayout = function()
		base:SetWide(self.DarkRPCommands:GetWide()/3 - 6)	
	end
	base.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31))
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
        b.Text = DarkRP.deLocalise(name)
        b:SetBorderColor(v.color)
        b:SetDisabled(true)

        if aScoreboard.UniformColor then
        	v.aColor = aScoreboard.Color
        end

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
           	v.Action(b)
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

function PANEL:GetPlayer()
	return LocalPlayer()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
end

vgui.Register("aScoreboardDarkRPCommands", PANEL, "DPanel")