--Player List
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(0, 0, 0, 5)
	self:DockMargin(5, 0, 5, 0)

	self.Header = vgui.Create("DPanel", self)
	self.Header:Dock(TOP)
	self.Header:SetTall(30)
	self.Header:DockMargin(37, 5, 5, 2)
	if aScoreboard.TeamCategories then
		self.Header:DockMargin(42, 5, 5, 2)
	end
	
	self.Header.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
	end
	self.Header.Labels = {}

	for k, v in pairs(aScoreboard.DataValues) do
		if not v.Enabled then continue end
		self.Header.Labels[k] = vgui.Create("DButton", self.Header)
		self.Header.Labels[k].Text = k
		self.Header.Labels[k].DoClick = function() 
			aScoreboard.Base.Criteria = k 
		end
		self.Header.Labels[k].Paint = function(this, w, h) 
			if this:IsHovered() then
				draw.SimpleText(this.Text, "aScoreboardSubTitle", w/2, h/2, aScoreboard.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(this.Text, "aScoreboardSubTitle", w/2, h/2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			end
		end
	end

	self.Scroller = vgui.Create("DScrollPanel", self)
	self.Scroller:Dock(FILL)
	self.Scroller.Teams = {}
	aScoreboard.PaintScroll(self.Scroller)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
end

function PANEL:Think()
	for k, v in pairs(player.GetAll()) do
		if not IsValid(v) then continue end
		if not v.aScoreboardPanel then
			v.aScoreboardPanel = vgui.Create("aScoreboardPlayerLine", self.Scroller)
			v.aScoreboardPanel.Player = v
			v.aScoreboardPanel:Dock(TOP)
			v.aScoreboardPanel:DockMargin(5, 5, 5, 0)
			v.aScoreboardPanel:SetTall(44)
			v.aScoreboardPanel:InvalidateLayout(true)	
		end
	end		

	if aScoreboard.TeamCategories then
		if (string.find(string.lower(GAMEMODE.Name), "rp") or string.find(string.lower(GAMEMODE.Name), "purge")) then
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) and v:IsValid() and v:getDarkRPVar("job") then
					if not self.Scroller.Teams[v:getDarkRPVar("job")] then
						self.Scroller.Teams[v:getDarkRPVar("job")] = vgui.Create("aScoreboardGroup", self.Scroller)
						self.Scroller.Teams[v:getDarkRPVar("job")].Name = v:getDarkRPVar("job")
						self.Scroller.Teams[v:getDarkRPVar("job")].Col = team.GetColor(v:Team())
					end

					if v.aScoreboardPanel:GetParent() != self.Scroller.Teams[v:getDarkRPVar("job")] then
						v.aScoreboardPanel:SetParent(self.Scroller.Teams[v:getDarkRPVar("job")])
					end

					if not ValidPanel(self.Scroller.Teams[v:getDarkRPVar("job")]) then
						self.Scroller.Teams[v:getDarkRPVar("job")]:Remove()	
						self.Scroller.Teams[v:getDarkRPVar("job")] = nil
					else
						self.Scroller.Teams[v:getDarkRPVar("job")]:InvalidateLayout(true)
						self.Scroller.Teams[v:getDarkRPVar("job")]:SizeToChildren(false, true)							
					end
				end
			end	
		else
			for k, v in pairs(team.GetAllTeams()) do
				if #team.GetPlayers(k) != 0 then
					if not self.Scroller.Teams[k] then
						self.Scroller.Teams[k] = vgui.Create("aScoreboardGroup", self.Scroller)
						self.Scroller.Teams[k].Name = v.Name
						self.Scroller.Teams[k].Col = v.Color
					end

					for _, e in pairs(team.GetPlayers(k)) do
						if e.aScoreboardPanel:GetParent() != self.Scroller.Teams[k] then
							e.aScoreboardPanel:SetParent(self.Scroller.Teams[k])
						end
					end

					if not ValidPanel(self.Scroller.Teams[k]) then
						self.Scroller.Teams[k]:Remove()	
						self.Scroller.Teams[k] = nil
					else
						self.Scroller.Teams[k]:InvalidateLayout(true)
						self.Scroller.Teams[k]:SizeToChildren(false, true)							
					end
				end
			end		
		end
	end
end

function PANEL:PerformLayout()
	for k, v in pairs(aScoreboard.DataValues) do
		if not (v.Enabled or self.Header.Labels[k]) then continue end		
		self.Header.Labels[k]:SetText(k)
		self.Header.Labels[k]:SetFont("aScoreboardSubTitle")
		self.Header.Labels[k]:SetColor(Color(0, 0, 0, 0))
		self.Header.Labels[k]:SizeToContents()
		if v.Alignment == 0 then --Left
			self.Header.Labels[k]:SetPos(v.Pos(self.Header:GetWide()), self.Header:GetTall()/2 - self.Header.Labels[k]:GetTall()/2)
		elseif v.Alignment == 1 then --Centre
			self.Header.Labels[k]:SetPos(v.Pos(self.Header:GetWide()) - self.Header.Labels[k]:GetWide()/2, self.Header:GetTall()/2 - self.Header.Labels[k]:GetTall()/2)
		elseif v.Alignment == 2 then --Right
			self.Header.Labels[k]:SetPos(v.Pos(self.Header:GetWide()) - self.Header.Labels[k]:GetWide(), self.Header:GetTall()/2 - self.Header.Labels[k]:GetTall()/2)
		end
	end

	self.Scroller:InvalidateLayout(true)
end

function PANEL:UpdateScoreboard()
    self:InvalidateLayout(true)
end

vgui.Register("aScoreboardPlayerList", PANEL, "DPanel")