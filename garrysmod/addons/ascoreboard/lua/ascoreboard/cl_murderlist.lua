--Player List
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(0, 5, 5, 5)

	self.PlayerPanel = vgui.Create("DPanel", self)
	self.PlayerPanel:Dock(LEFT)
	self.PlayerPanel:DockMargin(5, 0, 5, 0)
	self.PlayerPanel.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		draw.SimpleText("Players", "aScoreboardTitle", 7, 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.JoinSpectatorsButton = vgui.Create("aScoreboardButton", self.PlayerPanel)
	self.JoinSpectatorsButton:SetSize(55, 26)	
	self.JoinSpectatorsButton.Text = translate.scoreboardJoinTeam
	self.JoinSpectatorsButton.Col = aScoreboard.Color
	self.JoinSpectatorsButton.DoClick = function()
		RunConsoleCommand("mu_jointeam", 2)
	end

	self.PlayerList = vgui.Create("DPanel", self.PlayerPanel) 
	self.PlayerList:Dock(FILL)
	self.PlayerList:DockMargin(5, 36, 5, 5)
	self.PlayerList.Paint = function(this, w, h) end
	self.PlayerList.Think = function()
		for k, v in pairs(self.PlayerList:GetChildren()) do
			if not IsValid(v.Player) then
				v:Remove()
				timer.Simple(0, function()
					self.PlayerList:InvalidateLayout(true)
					self.SpectatorList:InvalidateLayout(true)
				end)
			end	
		end
	end

	self.SpectatorPanel = vgui.Create("DPanel", self)
	self.SpectatorPanel:Dock(LEFT)
	self.SpectatorPanel:DockMargin(5, 0, 5, 0)
	self.SpectatorPanel.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		draw.SimpleText("Spectators", "aScoreboardTitle", 7, 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.JoinPlayersButton = vgui.Create("aScoreboardButton", self.SpectatorPanel)
	self.JoinPlayersButton:SetSize(55, 26)	
	self.JoinPlayersButton.Text = translate.scoreboardJoinTeam
	self.JoinPlayersButton.Col = aScoreboard.Color
	self.JoinPlayersButton.DoClick = function()
		RunConsoleCommand("mu_jointeam", 1)
	end

	self.SpectatorList = vgui.Create("DPanel", self.SpectatorPanel) 
	self.SpectatorList:Dock(FILL)
	self.SpectatorList:DockMargin(5, 36, 5, 5)
	self.SpectatorList.Paint = function(this, w, h) end
	self.SpectatorList.Think = function()
		for k, v in pairs(self.SpectatorList:GetChildren()) do
			if not IsValid(v.Player) then
				v:Remove()
				timer.Simple(0, function()
					self.PlayerList:InvalidateLayout(true)
					self.SpectatorList:InvalidateLayout(true)
				end)
			end	
		end
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
end

function PANEL:Think()
	for k, v in pairs(player.GetAll()) do
		if not IsValid(v) then continue end
		if not v.aScoreboardPanel then
			v.aScoreboardPanel = vgui.Create("aScoreboardPlayerLine", self.PlayerList)
			v.aScoreboardPanel.Player = v
			v.aScoreboardPanel:Dock(TOP)
			v.aScoreboardPanel:DockMargin(5, 5, 5, 0)
			v.aScoreboardPanel:SetTall(44)
			v.aScoreboardPanel:InvalidateLayout(true)	
			v.aScoreboardPanel.Paint = function(this, w, h)
				local col = Color(61, 61, 61)
				if aScoreboard.ColourMurderRowsByPlayer then
					col = v:GetPlayerColor() or Vector()
					col = Color(col.r * 255, col.g * 255, col.b * 255)
				end
				draw.RoundedBox(4, 0, 0, w, h, col)
				draw.SimpleText(v:Nick(), "aScoreboard22", 42, h/2, Color(244, 244, 244), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Ping(), "aScoreboard22", w - 20, h/2, Color(244, 244, 244), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			v.aScoreboardPanel.Think = function()
				if (v.aScoreboardPanel:GetParent() == self.PlayerList) and v:Team() == 1 then
					v.aScoreboardPanel:SetParent(self.SpectatorList)
					self.SpectatorList:InvalidateLayout(true)
					self.PlayerList:InvalidateLayout(true)
				end

				if (v.aScoreboardPanel:GetParent() == self.SpectatorList) and v:Team() == 2 then
					v.aScoreboardPanel:SetParent(self.PlayerList)
					self.SpectatorList:InvalidateLayout(true)
					self.PlayerList:InvalidateLayout(true)
				end
			end

			v.aScoreboardPanel.Button.DoClick = function()
				local menu = DermaMenu(v.aScoreboardPanel)

				if v:IsAdmin() then
					menu:AddOption(translate.scoreboardActionAdmin, function() end)
				end

				if v != LocalPlayer() then
					if v:IsMuted() then
						menu:AddOption(translate.scoreboardActionUnmute, function() v:SetMuted(!v:IsMuted()) end)
					else
						menu:AddOption(translate.scoreboardActionMute, function() v:SetMuted(!v:IsMuted()) end)
					end					
				end
				
				if IsValid(LocalPlayer()) and LocalPlayer():IsAdmin() then
					menu:AddSpacer() 
					if v:Team() == 2 then
						menu:AddOption(Translator:QuickVar(translate.adminMoveToSpectate, "spectate", team.GetName(1)), function() RunConsoleCommand("mu_movetospectate", v:EntIndex()) end)
						menu:AddOption(translate.adminMurdererForce, function() RunConsoleCommand("mu_forcenextmurderer", v:EntIndex()) end)
						if v:Alive() then
							menu:AddOption(translate.adminSpectate, function() RunConsoleCommand("mu_spectate", v:EntIndex()) end)
						end
					end
				end

				menu:Open()

				menu.Paint = function() end
				menu.PaintOver = function(this, w, h)
					draw.RoundedBox(2, 0, 0, w, h, Color(41, 41, 41, 255))
					for k, v in pairs(this:GetCanvas():GetChildren()) do
						local x, y = v:GetPos()
						if v.Hovered then
							draw.RoundedBox(2, x+2, y+2, w-4, 18, aScoreboard.Color)
						end
						draw.SimpleText(v:GetText(), "aScoreboard19", x+6, y+1, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end
				end
			end
		end
	end	
end

function PANEL:PerformLayout()
	local w, h = self:GetWide()
	
	self.PlayerPanel:SetWide(w/2 - 10)
	
	self.SpectatorPanel:SetWide(w/2 - 10)	

	self.JoinSpectatorsButton:SetPos(self.PlayerPanel:GetWide() - 62, 7)
	self.JoinPlayersButton:SetPos(self.SpectatorPanel:GetWide() - 62, 7)
end

vgui.Register("aScoreboardMurderList", PANEL, "DPanel")