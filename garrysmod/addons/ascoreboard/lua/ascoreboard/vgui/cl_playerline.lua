--Player Rows
local PANEL = {}

function PANEL:Init()
	self.Col 	= aScoreboard.Color
	self.Player = nil
	self.Type 	= nil

	self.Avatar = vgui.Create("AvatarCircleMask", self)
	self.Avatar:SetSize(32, 32)
	self.Avatar:SetMaskSize(32 / 2)

	if aScoreboard.CompactRows then 
		self.Avatar:SetSize(24, 24)
		self.Avatar:SetMaskSize(24 / 2)
	end

	self.Button = vgui.Create("DButton", self)
	self.Button:SetPos(0, 0)
	self.Button:SetText("")
	self.Button.DoClick = function()
		aScoreboard.Base:SetActivePanel(aScoreboard.Base.PlayerInspect)
		aScoreboard.Base.PlayerInspect:SetPlayer(self.Player)
	end
	self.Button.DoRightClick = function()

		local Menu = vgui.Create("DMenu")
		Menu:MakePopup()
		Menu:SetPos(gui.MousePos())
		Menu:MoveToFront()		

		Menu.Think = function() 
			if not aScoreboard.Base:IsVisible() then 
				Menu:Remove() 
				return 
			end 
		end		

		Menu.Paint = function() end
		Menu.PaintOver = function(this, w, h)
			draw.RoundedBox(2, 0, 0, w, h, Color(51, 51, 51, 255))
			for k, v in pairs(this:GetCanvas():GetChildren()) do
				if v:GetTall() == 1 then v:SetTall(4) end
				local x, y = v:GetPos()
				if v.Hovered and v:GetTall() != 4 and not v.IsHeader then
					draw.RoundedBox(2, x+2, y+2, w-4, 18, aScoreboard.Color)
				end
				if v:GetTall() == 4 then
					draw.RoundedBox(2, x+4, y + 1, w-8, 2, aScoreboard.Color)
				end

				if v.IsHeader then
					draw.SimpleText(v:GetText(), "aScoreboard19", x+6, y+1, aScoreboard.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				else
					draw.SimpleText(v:GetText(), "aScoreboard19", x+6, y+1, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
				
			end
		end

		local header = Menu:AddOption("General commands", function() end)
		header.IsHeader = true

		Menu:AddOption("Copy Name", function() 
			if not (IsValid(self.Player) or self.Player:IsValid()) then return end 
			SetClipboardText(self.Player:Nick()) 
		end)

		Menu:AddOption("Copy SteamID", function() 
			if not (IsValid(self.Player) or self.Player:IsValid()) then return end 
			SetClipboardText(self.Player:SteamID()) 
		end)

		Menu:AddOption("Copy Profile URL", function() 
			if not (IsValid(self.Player) or self.Player:IsValid()) then return end 
			SetClipboardText("http://steamcommunity.com/profiles/".. self.Player:SteamID64() .."/")
		end)

		if self.Player != LocalPlayer() then
			if self.Player:IsMuted() then
				Menu:AddOption("Clientside Unmute", function() self.Player:SetMuted(!self.Player:IsMuted()) end)
			else
				Menu:AddOption("Clientside Mute", function() self.Player:SetMuted(!self.Player:IsMuted()) end)
			end					
		end

		if ulx then
			Menu:AddSpacer()

			local header = Menu:AddOption("ULX commands", function() end)
			header.IsHeader = true

			if ULib.ucl.query(LocalPlayer(), "ulx mute") then
				Menu:AddOption("Mute", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx mute \"".. self.Player:Nick() .. "\"" )
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx gag") then
				Menu:AddOption("Gag", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx gag \"".. self.Player:Nick() .. "\"" )
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx slay") then
				Menu:AddOption("Slay", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx slay \"".. self.Player:Nick() .. "\"" )
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx kick") then
				Menu:AddOption("Kick", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx kick \"".. self.Player:Nick() .. "\"" )
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx ban") then
				Menu:AddOption("Ban - 12 hours", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx kick \"".. self.Player:Nick() .. "\" 12h")
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx ban") then
				Menu:AddOption("Ban - 2 days", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx ban \"".. self.Player:Nick() .. "\" 2d")
				end)
			end

			if ULib.ucl.query(LocalPlayer(), "ulx ban") then
				Menu:AddOption("Ban - 1 week", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx ban \"".. self.Player:Nick() .. "\" 1w ")
				end)
			end

			--This one was a bit too much for just a scoreboard
			--[[
			if ULib.ucl.query(LocalPlayer(), "ulx ban") then
				Menu:AddOption("Ban - permanent", function()
					if not (IsValid(self.Player) or self.Player:IsValid()) then return end  
					LocalPlayer():ConCommand("ulx ban \"".. self.Player:Nick() .. "\" 0")
				end)
			end
			--]]
		end		
	end
	self.Button.Paint = function() end

	self.AvatarButton = vgui.Create("DButton", self)
	self.AvatarButton:SetPos(0, 0)
	self.AvatarButton:SetSize(38, 38)
	self.AvatarButton:SetText("")
	self.AvatarButton.Paint = function() end
end

function PANEL:PerformLayout()

	if aScoreboard.CompactRows then 
		self:SetTall(34)
		self:DockMargin(2, 5, 2, 0)

		self.Avatar:SetPlayer(self.Player, 24)
		self.Avatar:SetPos(10, self:GetTall()/2 - 12)
	else
		self:SetTall(40)
		self:DockMargin(2, 5, 2, 0)

		self.Avatar:SetPlayer(self.Player, 32)
		self.Avatar:SetPos(4, self:GetTall()/2 - 16)
	end
	self.Button:SetSize(self:GetWide(), self:GetTall())

	self.AvatarButton.DoClick = function()
		self.Player:ShowProfile()
	end
end

function PANEL:SetPlayer(ply)
	self.Player = ply

	self:InvalidateLayout(true)

	if not (IsValid(self.Player) or self.Player:IsValid()) then return end

	self:Dock(TOP)
	self:SetVisible(true)	
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))

	for k, v in pairs(aScoreboard.DataValues) do
		if not v.Enabled then continue end
		draw.SimpleText(v.Func(self.Player), "aScoreboard22", v.Pos(w - 44) + 44, h/2, v.Col(self.Player), v.Alignment, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Think()
	if ((not IsValid(self.Player)) or (not self.Player:IsValid()) or (self == NULL)) then
		self:Remove()
		self = nil
		return
	end		

	if aScoreboard.Base.Criteria == "Score" then
		self:SetZPos(self.Player:Frags()*-1)		
	elseif aScoreboard.Base.Criteria == "Player" then
		self:SetZPos(string.byte(string.lower(self.Player:Nick()), 1, 1))
	elseif aScoreboard.Base.Criteria == "Team" then
		self:SetZPos(string.byte(string.lower(team.GetName(self.Player:Team())), 1, 1))
	elseif aScoreboard.Base.Criteria == "Karma" then
		self:SetZPos(math.Round(self.Player:GetBaseKarma())*-1)
	elseif aScoreboard.Base.Criteria == "Deaths" then
		self:SetZPos(self.Player:Deaths()*-1)
	elseif aScoreboard.Base.Criteria == "Rank" then
		self:SetZPos(string.byte(string.lower(self.Player:GetUserGroup()), 1, 1))
	elseif aScoreboard.Base.Criteria == "Ping" then
		self:SetZPos(self.Player:Ping())
	elseif aScoreboard.Base.Criteria == "Hours Played" then
		self:SetZPos(tonumber(string.FormattedTime(self.Player:GetUTimeTotalTime()).h) * -1)
	end	
end

vgui.Register("aScoreboardPlayerLine", PANEL, "DPanel")