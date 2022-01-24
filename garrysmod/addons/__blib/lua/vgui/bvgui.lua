--[[

	LICENSE

	https://creativecommons.org/licenses/by-nc-nd/4.0/

	Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)

]]

--////////////////////////////////////////////////////////////////////////--

local version = 1
if (BVGUI) then
	if (BVGUI.Version >= version) then
		return
	end
end
BVGUI = {}
BVGUI.Version = version

surface.CreateFont("BVGUI_roboto16",{
	size = 16,
	font = "Roboto",
})
surface.CreateFont("BVGUI_roboto16_i",{
	size = 16,
	font = "Roboto",
	italic = true,
})

BVGUI_Tooltips = BVGUI_Tooltips or {}

local function OnCursorEntered_Tooltip(self)
	if (self.Tooltip == "" or self.Tooltip == nil) then return end
	self.TooltipGUI = vgui.Create("DLabel")
	table.insert(BVGUI_Tooltips,self.TooltipGUI)
	self.TooltipGUI:SetDrawOnTop(true)
	self.TooltipGUI:SetTextColor(Color(255,255,255))
	self.TooltipGUI:SetFont("BVGUI_roboto16")
	self.TooltipGUI:SetDrawBackground(true)
	self.TooltipGUI:SetContentAlignment(7)
	self.TooltipGUI:SetText(self.Tooltip)
	self.TooltipGUI:SetWide(200)
	self.TooltipGUI:SetTall(ScrH())
	self.TooltipGUI:SetWrap(true)
	self.TooltipGUI.NoPaint = true
	local x,y = gui.MousePos()
	self.TooltipGUI:SetPos(x - (self.TooltipGUI:GetWide() / 2),y + 35)
	function self.TooltipGUI:Paint(w,h)
		self:SizeToContentsX()
		if (w > 200) then
			self:SetWide(200)
		end
		self:SizeToContentsY()
		if (not self.NoPaint) then
			surface.DisableClipping(true)
			surface.SetDrawColor(0,0,0,250)
			surface.DrawRect(-5,-5,w + 10,h + 10)
		end
		self.NoPaint = false
	end
end

local function OnCursorExited_Tooltip(self)
	if (IsValid(self.TooltipGUI)) then
		self.TooltipGUI:Remove()
	end
	for _,v in pairs(BVGUI_Tooltips) do
		v:Remove()
	end
end

local function OnCursorMoved_Tooltip(self)
	if (IsValid(self.TooltipGUI)) then
		local x,y = gui.MousePos()
		self.TooltipGUI:SizeToContentsY()
		self.TooltipGUI:SetPos(x - (self.TooltipGUI:GetWide() / 2),y + 35)
	end
end

local function SetTooltip(self,tt)
	self.Tooltip = tt
	if (IsValid(self.TooltipGUI)) then
		self.TooltipGUI:SetText(self.Tooltip)
	end
	if (tt == "") then
		if (IsValid(self.TooltipGUI)) then
			self.TooltipGUI:Remove()
		end
	end
end

--////////////////////////////////////////////////////////////////////////--

local PANEL = {}

function PANEL:SetTooltip(tt)
	SetTooltip(self,tt)
end
function PANEL:OnCursorEntered()
	OnCursorEntered_Tooltip(self)
end
function PANEL:OnCursorExited()
	OnCursorExited_Tooltip(self)
end
function PANEL:OnCursorMoved()
	OnCursorMoved_Tooltip(self)
end

derma.DefineControl("BImageButton",nil,PANEL,"DImageButton")

--////////////////////////////////////////////////////////////////////////--

local PANEL = {}

function PANEL:Init()
	self:SetTextColor(Color(255,255,255))
	self:SetFont("BVGUI_roboto16")
end

function PANEL:SetTooltip(tt)
	SetTooltip(self,tt)
end
function PANEL:OnCursorEntered()
	OnCursorEntered_Tooltip(self)
end
function PANEL:OnCursorExited()
	OnCursorExited_Tooltip(self)
end
function PANEL:OnCursorMoved()
	OnCursorMoved_Tooltip(self)
end

function PANEL:Paint()
	if (self:GetDisabled() ~= false) then
		surface.SetDrawColor(Color(26,26,26))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	else
		if (self:IsHovered() and input.IsMouseDown(MOUSE_LEFT)) then
			surface.SetDrawColor(Color(96,168,255))
		elseif (self:IsHovered()) then
			surface.SetDrawColor(Color(38,103,183))
		else
			surface.SetDrawColor(Color(52,139,249))
		end
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		surface.SetDrawColor(Color(26,26,26))
		surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
	end
end

derma.DefineControl("BButton",nil,PANEL,"DButton")

--////////////////////////////////////////////////////////////////////////--

local PANEL = {}

function PANEL:SetTooltip(tt)
	SetTooltip(self,tt)
end
function PANEL:OnCursorEntered()
	OnCursorEntered_Tooltip(self)
end
function PANEL:OnCursorExited()
	OnCursorExited_Tooltip(self)
end
function PANEL:OnCursorMoved()
	OnCursorMoved_Tooltip(self)
end

derma.DefineControl("BImageButton",nil,PANEL,"DImageButton")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Paint()
	surface.SetDrawColor(Color(26,26,26))
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

function PANEL:Init()
	self.VBar.btnUp:SetText("-")
	self.VBar.btnUp:SetFont("BVGUI_roboto16")
	self.VBar.btnUp:SetTextColor(Color(255,255,255))
	self.VBar.btnUp.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnDown:SetText("-")
	self.VBar.btnDown:SetFont("BVGUI_roboto16")
	self.VBar.btnDown:SetTextColor(Color(255,255,255))
	self.VBar.btnDown.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnGrip:SetCursor("hand")
	self.VBar.btnGrip.Paint = function(self)
		surface.SetDrawColor(Color(50,50,50))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
end

derma.DefineControl("BScrollPanel",nil,PANEL,"DScrollPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Paint()
	surface.SetDrawColor(Color(26,26,26))
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

function PANEL:Init()
	self.VBar.btnUp:SetText("-")
	self.VBar.btnUp:SetFont("BVGUI_roboto16")
	self.VBar.btnUp:SetTextColor(Color(255,255,255))
	self.VBar.btnUp.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnDown:SetText("-")
	self.VBar.btnDown:SetFont("BVGUI_roboto16")
	self.VBar.btnDown:SetTextColor(Color(255,255,255))
	self.VBar.btnDown.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnGrip:SetCursor("hand")
	self.VBar.btnGrip.Paint = function(self)
		surface.SetDrawColor(Color(50,50,50))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.Container = vgui.Create("DPanel",self)
	self.Container.Paint = function() end

	self.Items = {}
end

function PANEL:NewItem(name,color,f,force_toggle)

	local this = self

	local new = vgui.Create("DPanel",self.Container)
	new:SetCursor("hand")
	new:SetSize(self.Container:GetWide(),30)
	table.insert(self.Items,new)
	new:AlignLeft(0)
	new.Paint = function() end

	new.borderLeft = vgui.Create("DPanel",new)
	new.borderLeft:SetSize(5,new:GetTall())
	new.borderLeft:AlignTop(0)
	new.borderLeft:AlignLeft(0)
	new.borderLeft.Paint = function()
		surface.SetDrawColor(color or Color(26,26,26))
		surface.DrawRect(0,0,new.borderLeft:GetWide(),new.borderLeft:GetTall())
	end

	new.text = vgui.Create("DLabel",new)
	new.text:SetTextColor(Color(255,255,255))
	new.text:SetFont("BVGUI_roboto16")
	new.text:SetText(name)
	new.text:SizeToContents()
	new.text:AlignLeft(10)
	new.text:CenterVertical()

	function new:OnCursorEntered()
		if (new.Toggled) then return end
		new.borderLeft:SetWide(7)
		new.text:AlignLeft(13)
	end

	function new:OnCursorExited()
		if (new.Toggled) then return end
		new.borderLeft:SetWide(5)
		new.text:AlignLeft(10)
	end

	function new:OnMousePressed()
		f(name,color,new)
		if (force_toggle) then
			for _,v in pairs(this.Items) do
				if (v.borderLeft and v.Toggled) then
					v.Toggled = false
					v.borderLeft:Stop()
					v.borderLeft:SizeTo(5,v.borderLeft:GetTall(),0.25)
					v.text:AlignLeft(10)
				end
			end
			new.Toggled = true
			new.borderLeft:Stop()
			new.borderLeft:SizeTo(new:GetWide(),new.borderLeft:GetTall(),0.25)
			new.text:AlignLeft(13)
		end
	end
	function new.borderLeft:OnMousePressed() new:OnMousePressed() end
	function new.text:OnMousePressed() new:OnMousePressed() end

	self:FixLayout()

	return new
end

function PANEL:NewCategory(name,color)

	local new = vgui.Create("DPanel",self.Container)
	new:SetSize(self.Container:GetWide(),30)
	new:AlignTop(#self.Items * 30)
	table.insert(self.Items,new)
	new:AlignLeft(0)
	new.Paint = function()
		surface.SetDrawColor(color or Color(26,26,26))
		surface.DrawRect(0,0,new:GetWide(),new:GetTall())
	end

	new.text = vgui.Create("DLabel",new)
	if (color.r >= 160 and color.g >= 160 and color.b >= 160) then
		new.text:SetTextColor(Color(0,0,0))
	else
		new.text:SetTextColor(Color(255,255,255))
	end
	new.text:SetFont("BVGUI_roboto16")
	new.text:SetText(name)
	new.text:SizeToContents()
	new.text:Center()

	self:FixLayout()
end

function PANEL:FixLayout()
	self.Container:SetSize(self:GetWide(),0)
	local s = 0
	for i,v in pairs(self.Items) do
		local t = self.Container:GetTall()
		self.Container:SetSize(self:GetWide(),t + v:GetTall())
		if (i == 1) then
			v:AlignTop(0)
			s = v:GetTall()
		else
			v:AlignTop(t + v:GetTall() - s)
		end
		v:SetWide(self.Container:GetWide())
		v.text:SetWide(self.Container:GetWide() - 15)
		v.text:AlignLeft(10)
	end
end

function PANEL:Clear()
	for _,v in pairs(self.Items) do
		v:Remove()
	end
	self.Items = {}
end

derma.DefineControl("BCategories",nil,PANEL,"DScrollPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self:GetParent().btnClose:SetVisible(false)
	self:GetParent().btnMaxim:SetVisible(false)
	self:GetParent().btnMinim:SetVisible(false)

	self.Paint = function() end
	self:SetSize(18,18)
	self:SetText("X")
	self:SetFont("BVGUI_roboto16")
	self:SetTextColor(Color(255,255,255))
	self:AlignRight(2)
	self:AlignTop(2)
	self.DoClick = function()
		if (self:GetParent().CloseButtonClicked) then
			self:GetParent().CloseButtonClicked()
		end
		self:GetParent():Close()
	end
end

function PANEL:ShowCloseButton(shouldshow)
	self:SetVisible(shouldshow)
end

derma.DefineControl("BCloseButton",nil,PANEL,"DButton")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self.ShowTitleBar = true
	self.BackgroundColor = Color(242,242,242)

	self:DockPadding(1,24,1,1)

	self.lblTitle:SetTextColor(Color(255,255,255))
	self.lblTitle:SetFont("BVGUI_roboto16")
	self.lblTitle:SetPos(5,5)

	self.Paint = function(self)
		surface.SetDrawColor(self.BackgroundColor)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())

		if (self.ShowTitleBar ~= false) then
			surface.SetDrawColor(Color(26,26,26))
			surface.DrawRect(0,0,self:GetWide(),24)

			surface.SetDrawColor(Color(26,26,26))
			surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
		end
	end
end

function PANEL:ShowCloseButton(shouldshow)
	self.CloseButton:ShowCloseButton(shouldshow)
end

function PANEL:Configured()
	local x,y = self:GetPos()
	self:SetPos(x,ScrH())
	self:MoveTo(x,y,0.5)

	self.CloseButton = vgui.Create("BCloseButton",self)
end

function PANEL:Paint()
	surface.SetDrawColor(Color(26,26,26))
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

function PANEL:Close()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	local x = self:GetPos()
	self:Stop()
	self:MoveTo(x,ScrH(),0.5,0,-1,function()
		self:Remove()
	end)

	if (self.OnClose ~= nil) then
		self.OnClose()
	end
end

function PANEL:ShouldShowTitleBar(shouldshow)
	PANEL.ShowTitleBar = tobool(shouldshow) or true
end
function PANEL:SetBackgroundColor(bgcolor)
	PANEL.ShowTitleBar = tobool(shouldshow) or true
end

derma.DefineControl("BFrame",nil,PANEL,"DFrame")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self:SetTextColor(Color(0,0,0))
	self:SetFont("BVGUI_roboto16")
end

function PANEL:White()
	self:SetTextColor(Color(255,255,255))
end

derma.DefineControl("BLabel",nil,PANEL,"DLabel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self.DrawOutline = false

	self.Header:SetFont("BVGUI_roboto16")
	self.Header:SetTextColor(Color(0,0,0))
	function self.Header:OnMousePressed() end

	if (IsValid(self.DraggerBar)) then
		self.DraggerBar:SetVisible(false)
	end

	self.Header.Paint = function(self)
		local bg = Color(242,242,242)

		if (self:IsHovered()) then
			bg = Color(232,232,232)
		end

		surface.SetDrawColor(bg)
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())

		surface.SetDrawColor(Color(206,206,206))
		surface.DrawRect(0,self:GetTall() - 1,self:GetWide(),1)


	end
end

function PANEL:DrawOutline(shoulddraw)
	self.DrawOutline = shoulddraw
end

derma.DefineControl("BListView_Column",nil,PANEL,"DListView_Column")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	for _,v in pairs(self.Columns) do
		v:SetTextColor(Color(0,0,0))
		v:SetFont("BVGUI_roboto16")

		v.PaintOver = function(self)
			surface.SetDrawColor(Color(219,219,219))
			surface.DrawRect(0,0,1,self:GetTall())
		end
	end
	if (self.ColorMode == false) then
		self.Paint = function(self)
			if (self:IsLineSelected()) then
				surface.SetDrawColor(Color(26,26,26))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				return
			end

			local bg = Color(255,255,255)

			if (self:IsHovered()) then
				bg = Color(245,245,245)
			end

			surface.SetDrawColor(bg)
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())

			surface.SetDrawColor(Color(219,219,219))
			surface.DrawRect(1,self:GetTall() - 1,self:GetWide() - 2,1)
		end
	else
		self.Paint = function(self)
			if (self:IsLineSelected()) then
				surface.SetDrawColor(Color(26,26,26))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				return
			end

			local bg = Color(245,245,245)

			if (self:IsHovered()) then
				bg = Color(235,235,235)
			end

			surface.SetDrawColor(bg)
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())

			surface.SetDrawColor(Color(219,219,219))
			surface.DrawRect(1,self:GetTall() - 1,self:GetWide() - 2,1)
		end
	end
	self.ColorMode = not self.ColorMode
end
function PANEL:OnMousePressed(mcode)
	if (mcode == MOUSE_RIGHT) then
		self:GetListView():OnRowRightClick(self:GetID(),self)
		self:OnRightClick()
		return
	end
	self:GetListView():OnClickLine(self,true)
	self:OnSelect()
end

derma.DefineControl("BListView_Line",nil,PANEL,"DListView_Line")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self.Paint = function(self)
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		surface.SetDrawColor(Color(207,207,207))
		surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
	end
	self:SetHeaderHeight(35)
	self:SetDataHeight(25)
	self.ColorMode = false

	self.VBar.btnUp:SetText("-")
	self.VBar.btnUp:SetFont("BVGUI_roboto16")
	self.VBar.btnUp:SetTextColor(Color(255,255,255))
	self.VBar.btnUp.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnDown:SetText("-")
	self.VBar.btnDown:SetFont("BVGUI_roboto16")
	self.VBar.btnDown:SetTextColor(Color(255,255,255))
	self.VBar.btnDown.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.btnGrip:SetCursor("hand")
	self.VBar.btnGrip.Paint = function(self)
		surface.SetDrawColor(Color(50,50,50))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	self.VBar.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
end

function PANEL:Clear()
	self.ColorMode = false

	for a,b in pairs(self.Lines)do b:Remove()end;self.Lines={}self.Sorted={}self:SetDirty(true)
end

function PANEL:AddColumn(a,b)local c=nil;if self.m_bSortable then c=vgui.Create("BListView_Column",self)else c=vgui.Create("DListView_ColumnPlain",self)end;c:SetName(a)c:SetZPos(10)if b then table.insert(self.Columns,b,c)for d=1,#self.Columns do self.Columns[d]:SetColumnID(d)end else local e=table.insert(self.Columns,c)c:SetColumnID(e)end;self:InvalidateLayout()return c end
function PANEL:AddLine(...)self:SetDirty(true)self:InvalidateLayout()local a=vgui.Create("BListView_Line",self.pnlCanvas)local b=table.insert(self.Lines,a)a:SetListView(self)a:SetID(b)for c,d in pairs(self.Columns)do a:SetColumnText(c,"")end;for c,d in pairs({...})do a:SetColumnText(c,d)end;local e=table.insert(self.Sorted,a)if e%2==1 then a:SetAltLine(true)end;for f,g in pairs(a.Columns)do g:SetFont("BVGUI_roboto16")end;return a end

derma.DefineControl("BListView",nil,PANEL,"DListView")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function Billy_Message(strText,strTitle,strButtonText)

	local Window = vgui.Create("BFrame")
	Window:SetTitle(strTitle or "Message")
	Window:SetDraggable(false)
	Window:SetBackgroundBlur(true)
	Window:SetDrawOnTop(true)

	local InnerPanel = vgui.Create("Panel",Window)

	local Text = vgui.Create("DLabel",InnerPanel)
	Text:SetFont("BVGUI_roboto16")
	Text:SetText(strText or "Message Text")
	Text:SizeToContents()
	Text:SetContentAlignment(5)
	Text:SetTextColor(Color(0,0,0))

	local ButtonPanel = vgui.Create("DPanel",Window)
	ButtonPanel:SetTall(30)
	ButtonPanel:SetDrawBackground(false)

	local Button = vgui.Create("BButton",ButtonPanel)
	Button:SetText(strButtonText or "OK")
	Button:SizeToContents()
	Button:SetTall(20)
	Button:SetWide(Button:GetWide() + 20)
	Button:SetPos(5,5)
	Button.DoClick = function() Window:Close() end

	ButtonPanel:SetWide(Button:GetWide() + 10)

	local w,h = Text:GetSize()

	Window:SetSize(w + 50,h + 25 + 45 + 10)

	InnerPanel:StretchToParent(5,25,5,45)

	Text:StretchToParent(5,5,5,5)

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom(8)

	Window:MakePopup()
	Window:DoModal()

	Window:Center()
	Window:Configured()
	Window:ShowCloseButton(false)

	return Window

end

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Paint()
	surface.SetDrawColor(Color(26,26,26))
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

function PANEL:SetTooltip(tt)
	SetTooltip(self,tt)
end
function PANEL:OnCursorEntered()
	OnCursorEntered_Tooltip(self)
end
function PANEL:OnCursorExited()
	OnCursorExited_Tooltip(self)
end
function PANEL:OnCursorMoved()
	OnCursorMoved_Tooltip(self)
end

derma.DefineControl("BPanel",nil,PANEL,"DPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	local p = self

	self.Value = 1
	self.Max   = 1
	self.Text  = ""
	self.Color = Color(52,139,249)

	self.InnerBar = vgui.Create("DPanel",self)
	function self.InnerBar:Paint(w,h)
		surface.SetDrawColor(p.Color)
		surface.DrawRect(0,0,w,h)
	end

	function self.InnerBar:Think()
		if (p.Max == 0) then
			p.InnerBar:SetSize(p:GetWide(),p:GetTall())
		else
			p.InnerBar:SetSize(p:GetWide() * (p.Value / p.Max),p:GetTall())
		end
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawRect(0,0,w,h)
end

derma.DefineControl("BProgressBar",nil,PANEL,"DPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function Billy_Query( strText, strTitle, ... )

	local Window = vgui.Create("BFrame" )
	Window:SetTitle( strTitle or "Message Title (First Parameter)" )
	Window:SetDraggable( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create("BLabel", InnerPanel )
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k=1, 8, 2 do

		local Text = select( k, ... )
		if Text == nil then break end

		local Func = select( k+1, ... ) or function() end

		local Button = vgui.Create("BButton", ButtonPanel )
		Button:SetText( Text )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button.DoClick = function() Window:Close() Func() end
		Button:SetPos( x, 5 )

		x = x + Button:GetWide() + 5

		ButtonPanel:SetWide( x )
		NumOptions = NumOptions + 1

	end

	local w, h = Text:GetSize()

	w = math.max( w, ButtonPanel:GetWide() )

	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	if ( NumOptions == 0 ) then

		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil

	end

	Window:Configured()
	Window:ShowCloseButton( false )

	return Window

end

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function Billy_StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText )

	local Window = vgui.Create("BFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )

	local Text = vgui.Create("BLabel", InnerPanel )
		Text:SetTextColor(Color(0,0,0))
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )

	local TextEntry = vgui.Create("BTextBox", InnerPanel )
		if (strDefaultText) then
			TextEntry:SetPlaceHolder( strDefaultText )
		else
			TextEntry:SetText( "" )
		end
		TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	local Button = vgui.Create("BButton", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

	local ButtonCancel = vgui.Create("BButton", ButtonPanel )
		ButtonCancel:SetText( strButtonCancelText or "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
		ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )

	local w, h = Text:GetSize()
	w = math.max( w, 400 )

	Window:SetSize( w + 50, h + 25 + 75 + 10 )

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 35 )

	TextEntry:StretchToParent( 5, nil, 5, nil )
	TextEntry:AlignBottom( 5 )

	TextEntry:RequestFocus()
	TextEntry:SelectAllText( true )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	Window:Center()
	Window:Configured()
	Window:ShowCloseButton( false )

	return Window

end

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:SetTabs(tabs)
	tabs:InvalidateParent(true)
	local x,y = tabs:GetPos()
	self:SetPos(x,y + tabs:GetTall())
end

function PANEL:Paint() end

derma.DefineControl("BTabs_Panel",nil,PANEL,"DPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurrentlySelected = 1
end

function PANEL:Paint()
	surface.SetDrawColor(Color(26,26,26))
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
end

function PANEL:AddTab(tabname,tabpanel)
	local newTab = vgui.Create("DButton",self)
	table.insert(self.Tabs,newTab)
	newTab.OpenPanel = tabpanel
	if (IsValid(tabpanel)) then
		tabpanel:SetMouseInputEnabled(false)
		tabpanel.Paint = function() end
		local tll = 0
		if (IsValid(self:GetParent())) then
			tll = ((self:GetParent():GetTall() - 24) - 35)
			tabpanel:SetParent(self:GetParent())
		else
			tll = (ScrH() - 24 - 35)
			tabpanel:SetParent(NULL)
		end
		tabpanel:SetSize(self:GetWide(),tll)
		tabpanel:SetPos(-tabpanel:GetWide(),24 + 35)
	end

	newTab.myID = #self.Tabs
	newTab:SetText("")
	newTab.Paint = function() end
	newTab:SetSize(self:GetWide() / #self.Tabs,self:GetTall())
	newTab:SetPos((#self.Tabs - 1) * (self:GetWide() / #self.Tabs))
	newTab.DoClick = function()
		self:SelectTab(newTab.myID)
	end

	newTab.TextLbl = vgui.Create("DLabel",newTab)
	newTab.TextLbl:SetTextColor(Color(255,255,255))
	newTab.TextLbl:SetText(tabname)
	newTab.TextLbl:SetFont("BVGUI_roboto16")
	newTab.TextLbl:SizeToContents()
	newTab.TextLbl:Center()

	for i,v in pairs(self.Tabs) do
		v:SetSize(self:GetWide() / #self.Tabs,self:GetTall())
		v:SetPos((i - 1) * (self:GetWide() / #self.Tabs),0)
		v.TextLbl:Center()
	end

	if (not IsValid(self.TabBar)) then
		self.TabBar = vgui.Create("DPanel",self)
		self.TabBar.Paint = function(self)
			surface.SetDrawColor(Color(52,139,249))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		self.TabBar:SetSize(self:GetWide() / #self.Tabs,3)
		self.TabBar:SetPos(0,newTab:GetTall() - 3)
	else
		self.TabBar:SetSize(self:GetWide() / #self.Tabs,3)
		self.TabBar:SetPos(0,newTab:GetTall() - 3)
	end

	if (IsValid(tabpanel)) then
		local x,y = tabpanel:GetPos()
		tabpanel:SetPos((#self.Tabs - 1) * tabpanel:GetWide(),y)
	end

	if (IsValid(tabpanel)) then
		if (tabpanel.onbLogsSetup ~= nil) then
			tabpanel.onbLogsSetup()
		end
	end

	return newTab
end

function PANEL:GetSelectedTabID()
	return self.CurrentlySelected or -1
end
function PANEL:GetTabFromID(id)
	return self.Tabs[id] or NULL
end

function PANEL:SelectTab(id)
	local theTab = self.Tabs[id]
	if (self:GetSelectedTabID() ~= id) then
		for i,v in pairs(self.Tabs) do
			if (IsValid(v.OpenPanel)) then
				v.OpenPanel:Stop()
				local _,y = v.OpenPanel:GetPos()
				v.OpenPanel:MoveTo((i - id) * v.OpenPanel:GetWide(),y,0.5)
			end
		end

		self.TabBar:Stop()
		local x,y = self.TabBar:GetPos()
		self.TabBar:MoveTo((id - 1) * (self:GetWide() / #self.Tabs),y,0.5)
	end
	self.CurrentlySelected = id

	return theTab.OpenPanel
end

derma.DefineControl("BTabs",nil,PANEL,"DPanel")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:GetValue()
	if (self.PlaceHoldered == true) then
		return ""
	else
		return self:GetText()
	end
end

function PANEL:SetPlaceHolder(text)
	self.PlaceHoldered = true
	self.PlaceHolder = text
	self:SetText(text)
	self:SetFont("BVGUI_roboto16_i")
	self:ApplySchemeSettings()
	self:SetTextColor(Color(64,64,64))
end

function PANEL:Init()
	self:SetFont("BVGUI_roboto16")
	self:ApplySchemeSettings()
	self:SetTextColor(Color(0,0,0))

	self.OnGetFocus = function()
		if (self.PlaceHoldered == true) then
			self.PlaceHoldered = false
			self:SetFont("BVGUI_roboto16")
			self:ApplySchemeSettings()
			self:SetTextColor(Color(0,0,0))
			self:SetText("")
		end
	end

	self.OnLoseFocus = function()
		if (self:GetValue() == "" and self.PlaceHolder) then
			self.PlaceHoldered = true
			self:SetText(self.PlaceHolder)
			self:SetFont("BVGUI_roboto16_i")
			self:ApplySchemeSettings()
			self:SetTextColor(Color(64,64,64))
		end
	end
end

function PANEL:OnValueChange(v)
	if (v == "" and self.PlaceHolder) then
		self.PlaceHoldered = true
		self:SetText(self.PlaceHolder)
		self:SetFont("BVGUI_roboto16_i")
		self:ApplySchemeSettings()
		self:SetTextColor(Color(64,64,64))
	end
	if (self.Typed) then
		self.Typed(self:GetValue())
	end
end

function PANEL:OnKeyCodeTyped(kc)
	if (self.PlaceHoldered == true and kc ~= 66) then
		self.PlaceHoldered = false
		self:SetFont("BVGUI_roboto16")
		self:ApplySchemeSettings()
		self:SetTextColor(Color(0,0,0))
		self:SetText("")
	end
	if (kc == 64) then
		if (self.OnEnter) then
			self:OnEnter()
		end
	end
end

function PANEL:GetUpdateOnType()
	return true
end

function PANEL:Clear()
	self:SetText("")
	if (self.PlaceHolder) then
		self.PlaceHoldered = true
		self:SetText(self.PlaceHolder)
		self:SetFont("BVGUI_roboto16_i")
		self:ApplySchemeSettings()
		self:SetTextColor(Color(64,64,64))
	end
end

derma.DefineControl("BTextBox",nil,PANEL,"DTextEntry")

