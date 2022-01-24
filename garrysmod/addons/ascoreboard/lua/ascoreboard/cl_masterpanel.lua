------------------- Base panel
local PANEL = {}

function PANEL:Init()
	self:SetSize(aScoreboard.Width, aScoreboard.Height)
	self:Center()
	self:DockPadding(0, 0, 0, 0)
	self:MakePopup()
	self:SetKeyboardInputEnabled(false) 
	self:ShowCloseButton(false)
	self.Col = aScoreboard.Color
	self.Tabs = {}
	self.Criteria = "Score"

	self.Banner = vgui.Create("DPanel", self)
	self.Banner:SetSize(self:GetParent():GetWide(), 55)
	self.Banner:Dock(TOP)
	self.Banner.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.Col)
		draw.SimpleText(aScoreboard.Title, "aScoreboardTitle", 5, 0, Color(237, 237, 237), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.SimpleText(aScoreboard.SubTitle, "aScoreboardSubTitle", 5, 27, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
	end

	self.MenuBar = vgui.Create("DPanel", self)
	self.MenuBar:Dock(LEFT)
	self.MenuBar:SetWide(220)
	self.MenuBar.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
	end

	self.MenuBar.Info = vgui.Create("DPanel", self.MenuBar)
	self.MenuBar.Info:Dock(TOP)
	self.MenuBar.Info:DockMargin(5, 5, 5, 0)
	self.MenuBar.Info:SetTall(77)
	self.MenuBar.Info.Gamemode = gmod.GetGamemode()["Name"]
	self.MenuBar.Info.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, 72, Color(62, 62, 62))

		draw.SimpleText(LocalPlayer():Nick(), "aScoreboardSubTitle", 80, 1, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 

		draw.RoundedBox(2, 80, 28, 120, 2, self.Col)

		draw.SimpleText(self.MenuBar.Info.Gamemode, "aScoreboard20", 80, 30, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.SimpleText(os.date("%X", os.time()), "aScoreboard20", 80, 48, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
	end

	self.MenuBar.Info.Avatar = vgui.Create("AvatarCircleMask", self.MenuBar.Info)
	self.MenuBar.Info.Avatar:SetPlayer(LocalPlayer(), 64)
	self.MenuBar.Info.Avatar:SetPos(4, 4)
	self.MenuBar.Info.Avatar:SetSize(64, 64)
	self.MenuBar.Info.Avatar:SetMaskSize(64 / 2)

	self.MenuBar.List = vgui.Create("DPanel", self.MenuBar)
	self.MenuBar.List:Dock(FILL)
	self.MenuBar.List:DockMargin(5, 0, 5, 5)
	self.MenuBar.List.Paint = function(this, w, h) end

	self.CanvasPanel = vgui.Create("DPanel", self)
	self.CanvasPanel:Dock(FILL)
	self.CanvasPanel.Paint = function() end

	self.PlayerInspect = vgui.Create("aScoreboardPlayerInspect", self.CanvasPanel)
	self.PlayerInspect:SetVisible(false)

	self.Dashboard = vgui.Create("aScoreboardDashboard", self.CanvasPanel)

	if aScoreboard.Murder then
		self.Players = vgui.Create("aScoreboardMurderList", self.CanvasPanel)
	else
		self.Players = vgui.Create("aScoreboardPlayerList", self.CanvasPanel)
	end

	if aScoreboard.DarkRP then
		self.DarkRPCommands = vgui.Create("aScoreboardDarkRPCommands", self.CanvasPanel)
	end

	if aScoreboard.UseRulesTab then
		self.Rules = vgui.Create("aScoreboardRules", self.CanvasPanel)
	end
	
	if aScoreboard.WebsiteLink != "" then 
		self.Website = vgui.Create("aScoreboardWebBase", self)
		self.Website:SetLink(aScoreboard.WebsiteLink)
	end

	if aScoreboard.DonationLink != "" then
		self.Donate = vgui.Create("aScoreboardWebBase", self)
		self.Donate:SetLink(aScoreboard.DonationLink)	
	end
	
	if aScoreboard.WorkshopLink != "" then
		self.Workshop = vgui.Create("aScoreboardWebBase", self)
		self.Workshop:SetLink(aScoreboard.WorkshopLink)	
	end

	--TODO: Upload new icon for the Steam Group to the Workshop collection
	if aScoreboard.SteamGroupLink != "" then
		self.SteamGroup = vgui.Create("aScoreboardWebBase", self)
		self.SteamGroup:SetLink(aScoreboard.SteamGroupLink)	
	end

	self:AddCat("Dashboard", aScoreboard.Icons.Dashboard, self.Dashboard)
	self:AddCat("Players", aScoreboard.Icons.PlayersButton, self.Players)

	if aScoreboard.DarkRP then
		self:AddCat("Dark RP", aScoreboard.Icons.DarkRPButton, self.DarkRPCommands)
	end

	if aScoreboard.UseRulesTab then
		self:AddCat("Rules", aScoreboard.Icons.RulesButton, self.Rules)
	end

	if aScoreboard.WebsiteLink != "" then 
		self:AddCat("Website", aScoreboard.Icons.WebButton, self.Website)
	end
	
	if aScoreboard.DonationLink != "" then
		self:AddCat("Donate", aScoreboard.Icons.DonateButton, self.Donate)
	end
	
	if aScoreboard.WorkshopLink != "" then
		self:AddCat("Workshop", aScoreboard.Icons.WorkshopButton, self.Workshop)
	end

	if aScoreboard.SteamGroupLink != "" then
		self:AddCat("Steam Group", aScoreboard.Icons.WebButton, self.SteamGroup)
	end

	self:SetActivePanel(self.Players)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
end

function PANEL:SetActivePanel(panel)
	for k, v in pairs(self.CanvasPanel:GetChildren()) do
		v:SetVisible(false)
	end
	panel:SetVisible(true)
	self.Tab = table.KeyFromValue(self.Tabs, panel)
end

function PANEL:AddCat(name, icon, panel)
	table.insert(self.Tabs, panel)

	local cat = vgui.Create("DButton", self.MenuBar.List)
	cat:SetSize(self:GetParent():GetWide(), 36)
	cat:DockMargin(0, 0, 0, 5)
	cat:Dock(TOP)

	cat.DoClick = function()

		if panel.IsSitePage then
			panel:OpenPage()
			return
		end

		self:SetActivePanel(panel)
	end
	cat:SetText("")

	cat.Paint = function(this, w, h)
		if self.Tab == table.KeyFromValue(self.Tabs, panel) then
			cat.Col = self.Col
		else
			cat.Col = Color(210, 210, 210)
		end

		if name == "Dashboard" then
			draw.RoundedBox(4, 0, 0, w, h, self.Col) 
			draw.SimpleText(string.upper(name), "aScoreboard18", 54, 18, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
			draw.SimpleText(">", "aScoreboard18", w-20, 18, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetMaterial(icon)
			surface.SetDrawColor(210, 210, 210)
			surface.DrawTexturedRect(20, 10, 16, 16)
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62)) 
			draw.SimpleText(string.upper(name), "aScoreboard18", 54, 18, cat.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
			draw.SimpleText(">", "aScoreboard18", w-20, 18, cat.Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			surface.SetMaterial(icon)
			surface.SetDrawColor(cat.Col.r, cat.Col.g, cat.Col.b)
			surface.DrawTexturedRect(20, 10, 16, 16)		 
		end
	end
end

vgui.Register("aScoreboardBase", PANEL, "DFrame")