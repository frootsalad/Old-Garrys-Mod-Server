------------------ Dashboard showing info
local PANEL = {}
local wide, height = aScoreboard.Width - 220, aScoreboard.Height - 55

function PANEL:Init()

	self.Col = aScoreboard.Color

	self:Dock(FILL)
	self.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
	end

	self.Admins = {}
	self.toDraw = {}
	self.totalJobs = {}

	self.MapInformation = vgui.Create("DPanel", self)
	self.MapInformation:Dock(BOTTOM)
	self.MapInformation:DockMargin(5, 0, wide/2, 5)
	self.MapInformation:SetTall(height*0.55)
	self.MapInformation.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))
		draw.SimpleText("Map Information", "aScoreboardTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)


		draw.SimpleText(game.GetMap(), "aScoreboardSubTitle", 190, 46, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.RoundedBox(2, 190, 70, 175, 2, self.Col)

		draw.SimpleText("Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "aScoreboardSubTitle", 190, 75, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Gamemode: " .. GAMEMODE.Name, "aScoreboardSubTitle", 190, 95, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Author: " .. GAMEMODE.Author, "aScoreboardSubTitle", 190, 115, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.MapPreviewContainer = vgui.Create("DPanel", self.MapInformation)
	self.MapPreviewContainer:SetPos(10, 50)
	self.MapPreviewContainer:SetSize(170, 130)
	self.MapPreviewContainer:DockPadding(5, 5, 5, 5)
	self.MapPreviewContainer.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
	end

	self.MapPreview = vgui.Create("HTML", self.MapPreviewContainer)
	self.MapPreview:Dock(FILL)
	self.MapPreview:SetSize(160, 120)
	self.MapPreview:OpenURL("http://image.www.gametracker.com/images/maps/160x120/garrysmod/" .. game.GetMap() .. ".jpg")

	self.GeneralCommands = vgui.Create("DPanel", self)
	self.GeneralCommands:SetSize(wide/2 - 10, height/2 + 40)
	self.GeneralCommands:SetPos(wide/2 + 5, height/2 - 45)
	self.GeneralCommands:DockPadding(10, 45, 10, 5)
	self.GeneralCommands.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))
		draw.SimpleText("General Commands", "aScoreboardTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)
	end

	local cmds = {
		{title = "Stop Sounds", cmd = "stopsound", text = "Stopping all sounds"},
		{title = "Cleanup everything", cmd = "gmod_cleanup", text = "Cleaning up everything"},
		{title = "Clear all decals", cmd = "r_cleardecals", text = "Clearing all decals"},
		{title = "Disconnect", cmd = "disconnect"},
	}

	for k, v in pairs(cmds) do
		local but = vgui.Create("aScoreboardButton", self.GeneralCommands)
		but:Dock(TOP)
		but:SetTall(32)
		but:DockMargin(0, 0, 0, 5)
		but.Text = v.title
		but.DoClick = function()
			if v.text then
				chat.AddText(Color(217, 83, 79), "[aScoreboard] ", Color(210, 210, 210), v.text)
			end
			LocalPlayer():ConCommand(v.cmd)
		end
	end

	self.StaffList = vgui.Create("DPanel", self)
	self.StaffList:SetSize(wide/2 - 5, height/2 - 50)
	self.StaffList:Dock(LEFT)
	self.StaffList:DockMargin(5, 5, 5, 5)
	self.StaffList.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))

		draw.SimpleText("Staff Online", "aScoreboardTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)
	end
	self.StaffList:DockPadding(0, 0, 0, 5)	

	self.StaffList.List = vgui.Create("DScrollPanel", self.StaffList)
	self.StaffList.List:Dock(FILL)
	self.StaffList.List:DockMargin(10, 45, 10, 10)
	aScoreboard.PaintScroll(self.StaffList.List)

	if aScoreboard.PieChart then
		self.JobsGraph = vgui.Create("DPanel", self)
		self.JobsGraph:SetSize(wide/2 - 10, height/2 - 50)
		self.JobsGraph:Dock(RIGHT)
		self.JobsGraph:DockMargin(5, 5, 5, 5)
		self.JobsGraph.Paint = function(this, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))
			draw.SimpleText("Team Distribution", "aScoreboardTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
			draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)
		end

		self.JobsGraph.Graph = vgui.Create("DPanel", self.JobsGraph)
		self.JobsGraph.Graph:Dock(LEFT)
		self.JobsGraph.Graph:DockMargin(10, 45, 5, 10)
		self.JobsGraph.Graph:SetWide((self.JobsGraph:GetTall()*0.3)*2 + 70)
		self.JobsGraph.Graph.Paint = function(this, w, h)

			local radius = math.min(h*0.4, w*0.4)
			local thickness = radius/2
			local roughness = 0
			local clockwise = true

			draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62))				
			draw.NoTexture() --fuck you, you elusive bastard

			draw.Arc(w/2, h/2, radius+15, thickness+radius+15, 0, 360, roughness, Color(41, 41, 41), clockwise)

			--draw.Arc(w/2, h/2, radius, thickness+radius, 0, 360, roughness, Color(240, 240, 240, 100), clockwise)

			for k, v in pairs(self.toDraw) do
				draw.Arc(w/2, h/2, radius, thickness*2, v.startang, v.endang, roughness, v.col, clockwise)
			end
			--draw.Arc(w/2, h/2, radius-10, thickness*2-10, 0, 360, roughness, Color(100, 100, 100, 20), clockwise)
		end

		self.JobsGraph.Info = vgui.Create("DScrollPanel", self.JobsGraph)
		self.JobsGraph.Info:Dock(FILL)
		self.JobsGraph.Info:DockMargin(5, 45, 10, 10)
		self.JobsGraph.Info.Paint = function(this, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62))
		end
		aScoreboard.PaintScroll(self.JobsGraph.Info)	
	else
		self.StaffList:SetSize(wide - 10, height/2 - 50)	
	end

	self:UpdateStaff()

	timer.Create("aScoreboardStaffUpdate", 5, 0, function()
		if self:IsValid() then
			self:UpdateStaff()
		end
	end)

end

function PANEL:UpdateStaff()

	for k, v in pairs(self.Admins) do
		v:Remove()
	end
	table.Empty(self.Admins)

	for k, v in pairs(player.GetAll()) do --Start over
		if v:IsValid() and (v:IsAdmin() or v:IsSuperAdmin()) then
			v.Base = vgui.Create("DPanel", self.StaffList.List)
			v.Base:Dock(TOP)
			v.Base:DockMargin(0, 0, 5, 5)
			v.Base:SetTall(54)

			surface.SetFont("aScoreboardJob")
			local pw, ph = surface.GetTextSize(v:Nick())
			local str = v:GetUserGroup()
			if aScoreboard.NiceRanks[v:GetUserGroup()] then
				str = aScoreboard.NiceRanks[v:GetUserGroup()].name
			end

			v.Base.Paint = function(this, w, h)
				if (not IsValid(v)) or (not v:IsValid()) then return end
				draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 65, 255))
				draw.SimpleText(v:Nick(), "aScoreboardJob", 60, 1, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 

				draw.RoundedBox(2, 60, 28, pw + 10, 2, self.Col)

				draw.SimpleText(str, "aScoreboard20", 60, 30, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
			end

			v.Base.Avatar = vgui.Create("AvatarCircleMask", v.Base)
			v.Base.Avatar:SetPlayer(v, 64)
			v.Base.Avatar:SetPos(4, 4)
			v.Base.Avatar:SetSize(46, 46)
			v.Base.Avatar:SetMaskSize(46 / 2)

			v.Base.Button = vgui.Create("DButton", v.Base)
			v.Base.Button:Dock(FILL)
			v.Base.Button:SetText("")
			v.Base.Button.Paint = function() end
			v.Base.Button.DoClick = function()
				local menu = DermaMenu(v.Base.Button)
				if aScoreboard.EnableAssistance then
					menu.HelpButton = menu:AddOption("Request Assistance", function() LocalPlayer():ConCommand(aScoreboard.AssistanceCommand) end)
				end
				menu:AddOption("Steam Profile", function() v:ShowProfile()  end)
				menu:Open()

				menu.Paint = function() end
				menu.PaintOver = function(this, w, h)
					draw.RoundedBox(2, 0, 0, w, h, Color(41, 41, 41, 255))
					for k, v in pairs(this:GetCanvas():GetChildren()) do
						local x, y = v:GetPos()
						if v.Hovered then
							draw.RoundedBox(2, x+2, y+2, w-4, 18, aScoreboard.Color)
						end
						draw.SimpleText(v:GetText(), "aScoreboard19", x+21, y+1, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						if v:GetText() == "Steam Profile" then
							surface.SetMaterial(aScoreboard.Icons.ProfileButton)
						else
							surface.SetMaterial(aScoreboard.Icons.MessageButton)
						end
						
						surface.SetDrawColor(210, 210, 210)
						surface.DrawTexturedRect(3, y+3, 16, 16)
					end
				end
			end
			table.insert(self.Admins, v.Base)
		end
	end

	if aScoreboard.PieChart then
		table.Empty(self.toDraw)
		table.Empty(self.totalJobs)

		local curstart 	= 0

		for k, v in pairs(player.GetAll()) do
			if team.NumPlayers(v:Team()) != 0 and not self.totalJobs[v:Team()] then
				self.totalJobs[v:Team()] = team.NumPlayers(v:Team())
			end
		end
		
		local count = 255
		for k, v in pairs(self.totalJobs) do
			local numsections = 360 / #player.GetAll()
			local en = (curstart + (v * numsections))
			local col = team.GetColor(k)
			table.insert(self.toDraw, {name = team.GetName(k), col = Color(col.r, col.g, col.b, 200), startang = curstart, endang = en})
			curstart = en
		end

		for k, v in pairs(self.JobsGraph.Info:GetChildren()[1]:GetChildren()) do
			v:Remove()
		end

		for k, v in pairs(self.totalJobs) do
			local base = vgui.Create("DPanel", self.JobsGraph.Info)
			base:Dock(TOP)
			base:DockMargin(5, 3, 5, 3)
			base.Paint = function(this, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
				draw.RoundedBox(4, 5, 5, 14, 14, team.GetColor(k))				
			end

			base.lbl = vgui.Create("DLabel", base)
			base.lbl.PerformLayout = function()
				base.lbl:SetAutoStretchVertical(true)
				base.lbl:SetText(team.GetName(k) .. " \nPlayers: " .. v)
				base.lbl:SizeToContentsY()
				base:SizeToChildren(false, true)
				base:SetTall(base:GetTall() + 3)
			end
			base.lbl:Dock(FILL)
			base.lbl:DockMargin(23, 2, 2, 2)	
			base.lbl:SetFont("aScoreboard19")
			base.lbl.Paint = function(this, w, h)
				--draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
			end
		end
	end
end

vgui.Register("aScoreboardDashboard", PANEL, "DPanel")