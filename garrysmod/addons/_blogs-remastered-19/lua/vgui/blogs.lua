local PANEL = {}

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

derma.DefineControl("bLogs_Column",nil,PANEL,"DListView_Column")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:SetSelected(b)

	self.m_bSelected = b

	for id,column in pairs(self.Columns) do
		if (b) then
			column:SetTextColor(Color(255,255,255))
		else
			column:SetTextColor(Color(0,0,0))
		end
		column:ApplySchemeSettings()
	end

end

function PANEL:Init()
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

function PANEL:SetColumnText( i, strText )

	strText = (strText:gsub("<color=%d+,%d+,%d+,?%d*>(.-)</color>","%1"))

	if ( type( strText ) == "Panel" ) then

		if ( IsValid( self.Columns[ i ] ) ) then self.Columns[ i ]:Remove() end

		strText:SetParent( self )
		self.Columns[ i ] = strText
		self.Columns[ i ].Value = strText
		return

	end

	if ( !IsValid( self.Columns[ i ] ) ) then

		self.Columns[ i ] = vgui.Create( "DListViewLabel", self )
		self.Columns[ i ]:SetMouseInputEnabled( false )

	end

	self.Columns[ i ]:SetText( tostring( strText ) )
	self.Columns[ i ].Value = strText
	return self.Columns[ i ]

end
PANEL.SetValue = PANEL.SetColumnText

derma.DefineControl("bLogs_LegacyLine",nil,PANEL,"DListView_Line")

--////////////////////////////////////////////////////////////////////////--

PANEL = {}

function PANEL:SetSelected(b)

	self.m_bSelected = b

	for id,column in pairs(self.Columns) do
		if (b) then
			column:SetTextColor(Color(255,255,255))
		else
			column:SetTextColor(Color(0,0,0))
		end
		column:ApplySchemeSettings()
	end

end

function PANEL:Init()
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

function PANEL:SetColumnText( i, strText )

	if ( type( strText ) == "Panel" ) then

		if ( IsValid( self.Columns[ i ] ) ) then self.Columns[ i ]:Remove() end

		strText:SetParent( self )
		self.Columns[ i ] = strText
		self.Columns[ i ].Value = strText
		return

	end

	if ( !IsValid( self.Columns[ i ] ) ) then

		self.Columns[ i ] = vgui.Create( "BListViewLabel", self )
		self.Columns[ i ]:SetMouseInputEnabled( false )

	end

	self.Columns[ i ]:SetText( tostring( strText ) )
	self.Columns[ i ].Value = strText
	return self.Columns[ i ]

end
PANEL.SetValue = PANEL.SetColumnText

derma.DefineControl("bLogs_Line",nil,PANEL,"DListView_Line")

--////////////////////////////////////////////////////////////////////////--

local PANEL = {}

function PANEL:Paint(w,h)
	if (not self.TextObj) then
		self.Font = self.Font or "BVGUI_roboto16"
		self.Text = self.Text or "Label"
		self.MainColour = self.MainColour or "0,0,0,255"
		self:UpdateTextObj()
	end
	self.TextObj:Draw(5,h / 2,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	self.TextObjSize = self.TextObj:Size()
end

function PANEL:UpdateTextObj()
	self.TextObj = markup.Parse("<colour=" .. self.MainColour .. "><font=" .. self.Font .. ">" .. self.Text .. "</font></colour>")
end

function PANEL:SetTextColor(color)
	self.Font = self.Font or "BVGUI_roboto16"
	self.Text = self.Text or "Label"
	self.MainColour = color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a

	self:UpdateTextObj()
end

function PANEL:SetText(txt)
	self.Font = self.Font or "BVGUI_roboto16"
	self.Text = txt
	self.MainColour = self.MainColour or "0,0,0,255"

	self:UpdateTextObj()
end

function PANEL:SetFont(fnt)
	self.Font = fnt
	self.Text = self.Text or "Label"
	self.MainColour = self.MainColour or "0,0,0,255"

	self:UpdateTextObj()
end

derma.DefineControl("BListViewLabel","",PANEL,"DPanel")

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

local AddLine = "bLogs_Line"
if (bLogs.LocalSettings) then
	if (bLogs.LocalSettings.colour_mode == false) then
		AddLine = "bLogs_LegacyLine"
	end
end
hook.Remove("bLogs_UpdateLocalSettings","bLogsVGUI_UpdateLocalSettings")
hook.Add("bLogs_UpdateLocalSettings","bLogsVGUI_UpdateLocalSettings",function()
	if (bLogs.LocalSettings.colour_mode == false) then
		AddLine = "bLogs_LegacyLine"
	else
		AddLine = "bLogs_Line"
	end
end)

function PANEL:AddColumn(a,b)local c=nil;if self.m_bSortable then c=vgui.Create("bLogs_Column",self)else c=vgui.Create("DListView_ColumnPlain",self)end;c:SetName(a)c:SetZPos(10)if b then table.insert(self.Columns,b,c)for d=1,#self.Columns do self.Columns[d]:SetColumnID(d)end else local e=table.insert(self.Columns,c)c:SetColumnID(e)end;self:InvalidateLayout()return c end
function PANEL:AddLine(...)self:SetDirty(true)self:InvalidateLayout()local a=vgui.Create(AddLine,self.pnlCanvas)local b=table.insert(self.Lines,a)a:SetListView(self)a:SetID(b)for c,d in pairs(self.Columns)do a:SetColumnText(c,"")end;for c,d in pairs({...})do a:SetColumnText(c,d)end;local e=table.insert(self.Sorted,a)if e%2==1 then a:SetAltLine(true)end;for f,g in pairs(a.Columns)do g:SetFont("BVGUI_roboto16")end;return a end

derma.DefineControl("bLogs_ListView",nil,PANEL,"DListView")
