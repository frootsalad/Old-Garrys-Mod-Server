--Support for Raychamp's gang addon
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(0, 0, 5, 5)

	self.GangManage = vgui.Create("DPanel", self)
	self.GangManage:Dock(TOP)
	self.GangManage:DockPadding(0, 45, 5, 5)
	self.GangManage.Paint = function(this, w, h)
		draw.RoundedBox(4, 5, 5, self:GetParent():GetWide() -7, h-5, Color(31, 31, 31, 255))
		draw.SimpleText("Gang management", "aMenuTitle", 10, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.RoundedBox(2, 10, 37, w-15, 2, aMenu.Color)
	end

	self.AllGangs = vgui.Create("DPanel", self.GangManage)
	self.AllGangs:Dock(RIGHT)
	self.AllGangs.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
	end

	self.GangList = vgui.Create("aListView", self.AllGangs)
	self.GangList:Dock(TOP)
	self.GangList:DockMargin(5, 5, 5, 5)
	self.GangList:AddColumn("Gang"):SetFixedWidth(200)
	self.GangList:AddColumn("Net worth")
	self.GangList:AddColumn("Members")

	self.GangListRefresh = vgui.Create("aMenuButton", self.AllGangs)
	self.GangListRefresh:Dock(FILL)
	self.GangListRefresh:DockMargin(5, 0, 5, 5)
	self.GangListRefresh.Text = "Refresh"
	self.GangListRefresh.DoClick = function()
		net.Start("gang fetch request")
		net.SendToServer()
	end
	self.GangListRefresh.DoClick()

	self.PlayerGang = vgui.Create("DPanel", self.GangManage)
	self.PlayerGang:DockMargin(10, 0, 5, 0)
	self.PlayerGang.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
	end

	self.PlayerGangMembers = vgui.Create("aListView", self.PlayerGang)
	self.PlayerGangMembers:Dock(LEFT)
	self.PlayerGangMembers:DockMargin(5, 5, 5, 5)
	self.PlayerGangMembers:AddColumn("Member Name")

	local GangIndex = LocalPlayer():getGang()
	local GangInfo = gangs:get(GangIndex)

	self.GangManagement = {
		{
			Name = "Kick",
			Func = function()
				local menu = DermaMenu()
				for k,v in pairs(GangInfo.members) do
					menu:AddOption(v.name, function()
						self:QuickVerify(function()
							net.Start("gang action")
								net.WriteString("kick")
								net.WriteString(v.id)
							net.SendToServer()
						end)
					end)
				end
				menu:Open()
			end
		},
		{
			Name = "Invite",
			Func = function()
				local menu = DermaMenu()
				for k,v in pairs(player.GetAll()) do
					menu:AddOption(v:Nick(), function()
						self:QuickVerify(function()
							net.Start("gang action")
								net.WriteString("invite")
								net.WriteEntity(v)
							net.SendToServer()
						end)
					end)
				end
				menu:Open()
			end
		},
		{
			Name = "Leave",
			Func = function()
				self:QuickVerify(function()
					net.Start("gang action")
						net.WriteString("leave")
					net.SendToServer()
				end)
				self:InvalidateLayout(true)
			end
		},
		{
			Name = "Colors",
			Func = function()
				local menu = DermaMenu()

				for k,v in pairs(gangs.colorselection) do
					menu:AddOption(k, function()
						self:QuickVerify(function()
							local tab = { r = v.r, g = v.g, b = v.b }

							net.Start("gang action")
								net.WriteString("color")
								net.WriteTable(tab)
							net.SendToServer()
						end)
					end)
				end

				menu:Open()
			end
		},
	}

	for k, v in ipairs(self.GangManagement) do
		self.GangManagement.k = vgui.Create("aMenuButton", self.PlayerGang)
		self.GangManagement.k:Dock(BOTTOM)
		self.GangManagement.k:DockMargin(5, 0, 5, 5)
		self.GangManagement.k.Text = v.Name
		self.GangManagement.k.DoClick = v.Func
	end

	self.ManagementLabel = vgui.Create("DLabel", self.PlayerGang)
	self.ManagementLabel:Dock(TOP)
	self.ManagementLabel:DockMargin(0, 2, 0, 0)
	self.ManagementLabel:SetFont("aMenu22")
	self.ManagementLabel:SetWrap(true)
	self.ManagementLabel:SetMultiline(true)
	self.ManagementLabel:SetAutoStretchVertical(true)

	self.GangCreation = vgui.Create("DPanel", self)
	self.GangCreation:Dock(TOP)
	self.GangCreation:DockPadding(0, 45, 5, 5)
	self.GangCreation.Paint = function(this, w, h)
		draw.RoundedBox(4, 5, 5, self:GetParent():GetWide() -7, h-5, Color(31, 31, 31, 255))
		draw.SimpleText("Gang Creation", "aMenuTitle", 10, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.RoundedBox(2, 10, 37, w-15, 2, aMenu.Color)

		local x, y = self.GangNameEntry:GetPos()

		--Round off the text box edges without having to touch its paint functions
		draw.RoundedBox(4, x - 2, y - 2, self.GangNameEntry:GetWide() + 4, self.GangNameEntry:GetTall() + 4, Color(51, 51, 51, 255))
	end

	self.GangCreateInfo = vgui.Create("DLabel", self.GangCreation)
	self.GangCreateInfo:Dock(TOP)
	self.GangCreateInfo:DockMargin(10, 5, 5, 5)
	self.GangCreateInfo:SetFont("aMenuSubTitle")
	self.GangCreateInfo:SetWrap(true)
	self.GangCreateInfo:SetMultiline(true)
	self.GangCreateInfo:SetAutoStretchVertical(true)
	self.GangCreateInfo:SetText(
			[[
			Create your own gang here. It lasts forever and you can invite your friends to it.
			It has an indicator which displays above your gangmates' heads. 
			You have a exclusive gang chat with "/gang <msg>".
			$]] .. gangs.creationfee .. [[ One time creation fee.
			]]
		)

	self.GangNameEntry = vgui.Create("DTextEntry", self.GangCreation)
	self.GangNameEntry:SetText("Enter a gang name here")
	self.GangNameEntry:SetFont("aMenuSubTitle")
	self.GangNameEntry.OnGetFocus = function(this) this:SetText("") end
	self.GangNameEntry:SetPaintBackgroundEnabled(true)
	self.GangNameEntry:SetCursorColor(Color(200, 200, 200, 255))
	self.GangNameEntry:SetTextColor(Color(200, 200, 200, 255))
	self.GangNameEntry:SetHighlightColor(aMenu.Color)
	self.GangNameEntry.PerformLayout = function()
		self.GangNameEntry:SetBGColor(Color(51, 51, 51, 255))
	end

	self.GangAccept = vgui.Create("aMenuButton", self.GangCreation)
	self.GangAccept:SetSize(140, 45)
	self.GangAccept.Text = "Accept"
	self.GangAccept.DoClick = function()
		local str = self.GangNameEntry:GetValue()
		if str == "" then return end
		net.Start("gang buy")
			net.WriteString(string.Trim(str))
		net.SendToServer()

		self:InvalidateLayout(true)
	end

	self:InvalidateLayout(true)
end

function PANEL:PerformLayout()
	self.GangManage:SetTall(self:GetTall() / 2 - 2)
	self.GangCreation:SetTall(self:GetTall() / 2 - 2)

	self.GangNameEntry:SetSize(self.GangCreation:GetWide() / 4, 45)
	self.GangNameEntry:SetPos(self.GangCreation:GetWide() / 2 - self.GangNameEntry:GetWide() / 2, self.GangCreation:GetTall() - 110)

	self.GangAccept:SetPos(self.GangCreation:GetWide() / 2 - self.GangAccept:GetWide() / 2, self.GangCreation:GetTall() - 53)

	self.AllGangs:SetWide(self.GangManage:GetWide() / 2)
	self.GangList:SetTall(self.AllGangs:GetTall() - 50)

	self.PlayerGang:Dock(FILL)
	self.PlayerGangMembers:SetWide(self.PlayerGang:GetWide() / 2)

	local GangIndex = LocalPlayer():getGang()
	local GangInfo = gangs:get(GangIndex)

	if GangInfo then
		self.GangCreation:Hide()
		self.GangManage:Show()
		self.GangManage:Dock(FILL)
		self.ManagementLabel:SetText("You have " .. table.Count(GangInfo.members) .. " member(s) total | Net worth: $" .. gangs:getWorth(GangIndex))
	else
		self.GangManage:Hide()
		self.GangCreation:Show()
		self.GangCreation:Dock(FILL)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62, 255))
end

function PANEL:QuickVerify(func)
	Derma_Query("Are you sure you wish to confirm?", "Gangs", "Accept", function() func() end, "Cancel")
end

function PANEL:RefreshTables(data)
	if !data then return end

	self.GangList:Clear()
	self.PlayerGangMembers:Clear()

	local GangIndex = LocalPlayer():getGang()
	local GangInfo = gangs:get(GangIndex)

	for k, v in pairs(data) do
		self.GangList:AddLine(v.name, DarkRP.formatMoney(v.networth), v.members)
	end

	if !GangInfo then return end
	for i, e in pairs(GangInfo.members) do
		self.PlayerGangMembers:AddLine(e.name)
	end
end

vgui.Register("aMenuGangs", PANEL, "DPanel")

net.Receive("gang fetch", function()
	local data = net.ReadTable()
	if !IsValid(aMenu.Base) then return end
	aMenu.Base.Gangs:RefreshTables(data)
end)

timer.Create("aMenuGangUpdate", 1, 0, function()
	if !gangs then return end
	net.Start("gang fetch request")
	net.SendToServer()
end)