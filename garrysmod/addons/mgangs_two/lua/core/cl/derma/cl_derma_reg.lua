--[[
MGANGS - CLIENTSIDE DERMA REGISTRATION
Developed by Zephruz
]]

--[[------------------
	Paged Scroll Panel
---------------------]]
vgui.Register("MG2_PagedScrollPanel", {
	Init = function(self)
		self.MaxPageResults = 5

		-- Page
		self.CurrentPagePanel = false
		self.CurrentPage = 0
		self.PageTable = {}

		-- Search
		self.SearchTable = false
		self.TotalSearchResults = 0
		self.LastSearchBench = 0

		--[[Page Navigation]]
		local pageNav = vgui.Create("DPanel", self)
		pageNav:Dock(BOTTOM)
		pageNav:SetTall(25)
		pageNav.Paint = function(s,w,h)
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200),false,false,false,false)
			draw.SimpleText( MGangs.Language:GetTranslation("page") .. ": " .. (self.CurrentPage || 0) .. "/" .. (self.SearchTable && #self.SearchTable || #self.PageTable || 0), "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		local prevPage = vgui.Create("DButton", pageNav)
		prevPage:Dock(LEFT)
		MGangs.Derma.Paint.Elements['button'](prevPage, {text = "<"})
		prevPage.DoClick = function()
			self:PreviousPage()
		end

		local nextPage = vgui.Create("DButton", pageNav)
		nextPage:Dock(RIGHT)
		MGangs.Derma.Paint.Elements['button'](nextPage, {text = ">"})
		nextPage.DoClick = function()
			self:NextPage()
		end
	end,
	SetMaxPageResults = function(self,val)
		self.MaxPageResults = (tonumber(val) or 5)
	end,
	PreviousPage = function(self)
		local prevPageID = self.CurrentPage - 1

		if (self.SearchTable && #self.SearchTable < 1 || #self.PageTable < 1) then return false end
		if (self.SearchTable && !self.SearchTable[prevPageID] || !self.PageTable[prevPageID]) then return false end

		if (self.SearchTable) then
			self:LoadSearchResults(prevPageID)
		else
			self:SetCurrentPage(prevPageID)
		end
	end,
	NextPage = function(self)
		local nextPageID = self.CurrentPage + 1
		if (self.SearchTable && #self.SearchTable < 1 || #self.PageTable < 1) then return false end
		if (self.SearchTable && !self.SearchTable[nextPageID] || !self.PageTable[nextPageID]) then return false end

		if (self.SearchTable) then
			self:LoadSearchResults(nextPageID)
		else
			self:SetCurrentPage(nextPageID)
		end
	end,
	SetPageTable = function(self, tbl)
		tbl = MGangs.Util:SplitUpTable(tbl,self.MaxPageResults)
		self.PageTable = tbl
	end,
	GetPageTable = function(self)
		return self.PageTable
	end,
	SetCurrentPage = function(self, pg)
		if (!self.PageTable) then return false end
		if (self.CurrentPagePanel) then self.CurrentPagePanel:Remove() end

		local pagePop = (self.PageTable[pg] or self.PageTable[1])
		if (!pagePop) then return false end

		local page = vgui.Create("DScrollPanel", self)
		page:Dock(FILL)
		MGangs.Derma.Paint.Elements['scrollpanel'](page)

		for k,v in pairs(pagePop) do
			if (v) then
				v._key = k

				local item = self:PageItemSetup(page, v)

				if (item) then
					item:SetParent(page)
				end
			end
		end

		self.CurrentPage = pg
		self.CurrentPagePanel = page
	end,

	-- Search
	SetupSearchBar = function(self, vals)
		--[[Search Bar]]
		self.searchBar = vgui.Create("MG2_InfoTextEntry", self)
		self.searchBar:Dock(TOP)
		self.searchBar:SetValue(vals.value or "")
		self.searchBar:SetInfoText(vals.infotext or MGangs.Language:GetTranslation("search_for"))
		self.searchBar:SetPlaceholderText(vals.placeholder or MGangs.Language:GetTranslation("enter_search_criteria"))
		self.searchBar:SetMinMaxChars((vals.minchars or 0),(vals.maxchars or 0))
		self.searchBar.OnEnter = function(s)
			local val = s:GetValue()

			if (#val <= 0) then self.SearchTable = false self:SetCurrentPage(1) return false end

			local benchMarkStart = SysTime()
			local searchTable = MGangs.Util:RebuildSplitTable(self.PageTable)
			local resultTable = {}

			for i=1,#searchTable do
				if (istable(searchTable[i])) then
					for k,v in pairs(searchTable[i]) do
						local searchVal = tostring(val):lower()
						local dataVal = tostring(v):lower()

						if (dataVal:find(searchVal)) then
							table.insert(resultTable, searchTable[i])
							searchTable[i] = nil
						end
					end
				end
			end

			local benchMarkEnd = SysTime()
			self.LastSearchBench = math.Round((math.Round(benchMarkEnd, 3) - math.Round(benchMarkStart, 3)), 3)
			self.TotalSearchResults = #resultTable

			-- Load Results
			local cont = self:OnSearch(val)

			if (!cont && cont != nil) then return false end

			self.SearchTable = MGangs.Util:SplitUpTable(resultTable,self.MaxPageResults)
			self:LoadSearchResults(1)
		end
		MGangs.Derma.Paint.Elements['infobox'](self.searchBar.infotextbox)
		MGangs.Derma.Paint.Elements['textentry'](self.searchBar.dtextentry, {ptext = self.searchBar.PlaceholderText})
	end,
	LoadSearchResults = function(self, pg)
		if (!self.SearchTable) then return false end
		if (self.CurrentPagePanel) then self.CurrentPagePanel:Remove() end

		local searchValue = (self.searchBar && self.searchBar:GetValue())
		local totalSearchResults = (self.TotalSearchResults || 0)
		local searchBench = (self.LastSearchBench || 0)

		local page = vgui.Create("DScrollPanel", self)
		page:Dock(FILL)
		MGangs.Derma.Paint.Elements['scrollpanel'](page)

		local resultsHeader = vgui.Create("DPanel", page)
		resultsHeader:Dock(TOP)
		resultsHeader:SetTall(25)
		resultsHeader.Paint = function(s,w,h)
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(35,35,35,255),false,false,false,false)

			draw.SimpleText(MGangs.Language:GetTranslation("search_results", (totalSearchResults), (searchValue || "NIL")), "MG_GangInfo_XSM", 5, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText(MGangs.Language:GetTranslation("search_results_took", (searchBench)), "MG_GangInfo_XSM", w-5, h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end

		local searchPop = (self.SearchTable[pg] || self.SearchTable[1])

		if (searchPop) then
			for k,v in pairs(searchPop) do
				local item = self:PageItemSetup(page, v)

				if (item) then
					item:SetParent(page)
				end
			end
		else
			local noResults = vgui.Create("DPanel", page)
			noResults:Dock(TOP)
			noResults:SetTall(30)
			noResults.Paint = function(s,w,h)
				draw.SimpleText(MGangs.Language:GetTranslation("no_search_results"), "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end

		self.CurrentPage = (searchPop && pg || 0)
		self.CurrentPagePanel = page
	end,

	-- Overrides/placeholders
	PageItemSetup = function(...) end,
	OnSearch = function(...) end
}, "DPanel")

--[[---------------
	Button Checkbox
------------------]]
vgui.Register("MG2_ButtonCheckbox", {
	Init = function(self)
		self:SetText("")

		self.custText = ""
		self.isAct = true

		-- Icons
		self.checkIcon = Material("icon16/tick.png")
		self.errorIcon = Material("icon16/exclamation.png")
	end,
	SetCustText = function(self, text)
		self.custText = (text or "BUTTON CHECKBOX")
	end,
	SetChecked = function(self, bool)
		self.isAct = bool
	end,
	GetChecked = function(self)
		return self.isAct
	end,
	Paint = function(self,w,h)
		local icon = self.errorIcon

		if (self.isAct) then
			icon = self.checkIcon
		end

		draw.RoundedBoxEx(4, 0, 0, w, h, Color(75,75,75,255), true, true, true, true)

		if (icon) then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(w-20, 3, 16, 16)
		end

		draw.SimpleText( (self.custText or "BUTTON CHECKBOX"), "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end,

	--Overrides
	WasClicked = function(...) end,
	DoClick = function(self)
		self:SetChecked(!self.isAct && true || false)

		self:WasClicked()
	end,
}, "DButton")

--[[---------------
	Prompt Box
------------------]]
vgui.Register("MG2_PromptBox", {
	Init = function(self)
		self:SetSize(300,125)
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(false)

		self.questText = "This is a question, will you answer?"
		self.yBtnTxt = MGangs.Language:GetTranslation("yes")
		self.nBtnTxt = MGangs.Language:GetTranslation("no")

		-- Vgui
		local closeBtn = vgui.Create("DButton", self)
		closeBtn:SetSize(20,24)
		closeBtn:SetPos(self:GetWide() - 20,0)
		closeBtn.DoClick = function(self)
			self:GetParent():Remove()
		end
		MGangs.Derma.Paint.Elements['closebutton'](closeBtn, "X")
	end,
	SetButtonTexts = function(self, yBtnTxt, nBtnTxt)
		self.yBtnTxt = (yBtnTxt or MGangs.Language:GetTranslation("yes"))
		self.nBtnTxt = (nBtnTxt or MGangs.Language:GetTranslation("no"))
	end,
	SetQuestionText = function(self, text)
		self.questText = (text or self.questText)
	end,
	GetQuestionText = function(self)
		return (self.questText or "NIL?")
	end,
	SetOptions = function(self, yFunc, nFunc)
		self.yesBtn.DoClick = function(s)
			local cont = true

			if (yFunc) then
				cont = yFunc(self)
			end

			if (cont != nil && !cont) then return false end

			self:Remove()
		end
		self.noBtn.DoClick = function(s)
			if (nFunc) then
				nFunc(self)
			end

			self:Remove()
		end
	end,
	Setup = function(self)
		local infoCont = vgui.Create("DPanel", self)
		infoCont:Dock(FILL)
		infoCont.Paint = function(s,w,h)
			draw.SimpleText( self.questText, "MG_GangInfo_Name", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		local btnCont = vgui.Create("DPanel", self)
		btnCont:Dock(BOTTOM)
		btnCont:SetTall(30)
		btnCont.Paint = function(s,w,h) end

		self.yesBtn = vgui.Create("DButton", btnCont)
		self.yesBtn:Dock(LEFT)
		MGangs.Derma.Paint.Elements['button'](self.yesBtn, {text = self.yBtnTxt, rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		self.noBtn = vgui.Create("DButton", btnCont)
		self.noBtn:Dock(RIGHT)
		MGangs.Derma.Paint.Elements['button'](self.noBtn, {text = self.nBtnTxt, rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		MGangs.Derma.Paint.Elements['frame'](self, "", {fgBlur = true})
	end,
}, "DFrame")

--[[---------------
	Info Combo Box
------------------]]
vgui.Register("MG2_InfoComboBox", {
	Init = function(self)
		self:SetTall(25)

		self.InfoText = "Info Text"

		self.infotextbox = vgui.Create("DPanel", self)
		self.infotextbox:Dock(LEFT)
		self.infotextbox.InfoText = self.InfoText

		self.combobox = vgui.Create("DComboBox", self)
		self.combobox:Dock(FILL)
		self.combobox.OnSelect = function(...) self.OnSelect(...) end
		self.combobox.GetSelected = function(...) self.GetSelected(...) end
		self.combobox.GetSelectedID = function(...) self.GetSelectedID(...) end
		self.combobox.GetOptionText = function(...) self.GetOptionText(...) end

		self:PaintChildren()
	end,
	PaintChildren = function(self)
		MGangs.Derma.Paint.Elements['infobox'](self.infotextbox, {rc_tl = true, rc_bl = true})
		MGangs.Derma.Paint.Elements['combobox'](self.combobox, {text = self.combobox:GetValue(), rc_br = true, rc_tr = true})
	end,
	AddChoice = function(self, val)
		self.combobox:AddChoice(val)
	end,
	SetValue = function(self, val)
		self.combobox:SetValue(val)
	end,
	GetValue = function(self)
		return self.combobox:GetValue()
	end,
	SetInfoText = function(self, val)
		self.InfoText = val
		self.infotextbox.InfoText = val

		surface.SetFont((self:GetFont() or "DermaDefault"))
		local ITxtW, ITxtH = surface.GetTextSize( self.InfoText )

		self.infotextbox:SetWide(ITxtW + 10)
	end,
	GetInfoText = function(self)
		return self.InfoText
	end,
	SetFont = function(self, val)
		self.dtextentry:SetFont(val)
		self.infotextbox:SetFontInternal(val)
	end,
	SetCBoxMaterial = function(self, val)
		MGangs.Derma.Paint.Elements['combobox'](self.combobox, {icon = val, text = val, rc_br = true, rc_tr = true})
	end,
	Paint = function(self,w,h) end,

	--Overrides
	OnSelect = function(...) end,
	GetSelected = function(...) end,
	GetSelectedID = function(...) end,
	GetOptionText = function(...) end,
}, "DPanel")

--[[---------------
	Tool Tip
------------------]]
vgui.Register("MG2_ToolTip", {
	Init = function(self)
		self.ttText = "TolololTip"
		self.ttFont = "DermaDefault"
		self.ttCol = Color(255,255,255,255)

		surface.SetFont(self.ttFont)
		local txtW, txtH = surface.GetTextSize(self.ttText)
		self:SetSize(txtW + 10, txtH + 15)

		self:Hide()
	end,
	setTTFont = function(self, font)
		self.ttFont = font
	end,
	getTTFont = function(self)
		return self.ttFont
	end,
	setTTCol = function(self, col)
		self.ttCol = col
	end,
	getTTCol = function(self)
		return self.ttCol
	end,
	setTTText = function(self, text)
		self.ttText = text

		surface.SetFont(self:getTTFont())
		local txtW, txtH = surface.GetTextSize(self.ttText)
		self:SetSize(txtW + 15, txtH + 5)
	end,
	getTTText = function(self)
		return self.ttText
	end,
	getTTParent = function(self)
		return self.hoverParent
	end,
	setTTParent = function(self, parent)
		self.hoverParent = parent

		if (IsValid(parent)) then
			parent.OnCursorEntered = function(s)
				self:Show()
			end

			parent.OnCursorExited = function(s)
				self:Hide()
			end

			parent.OnRemove = function(s)
				self:Remove()
			end
		end
	end,
	Think = function(self)
		local ttX, ttY = gui.MousePos()
		local w, h = self:GetSize()

		self:SetPos(ttX - (w/2), ttY - 40)
		self:MakePopup()
	end,
	Paint = function(self, w, h)
		draw.RoundedBoxEx(3, 0, 0, w, h, Color(35,35,35,255), true, true, true, true)

		draw.SimpleText(self:getTTText(), self:getTTFont(), w/2, h/2, self:getTTCol(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end,
}, "DPanel")

--[[------------------
	Info Text Entry
---------------------]]
vgui.Register("MG2_InfoTextEntry", {
	Init = function(self)
		self:SetTall(25)

		self.PlaceholderText = "Placeholder"
		self.InfoText = "Info Text"

		self.infotextbox = vgui.Create("DPanel", self)
		self.infotextbox:Dock(LEFT)
		self.infotextbox.InfoText = self.InfoText

		self.dtextentry = vgui.Create("DTextEntry", self)
		self.dtextentry:Dock(FILL)
		self.dtextentry:SetUpdateOnType(true)
		self.dtextentry.OnValueChange = function(...) self.OnValueChange(...) end
		self.dtextentry.OnLoseFocus = function(...) self.OnLoseFocus(...) end
		self.dtextentry.OnEnter = function(...) self.OnEnter(...) end

		self:PaintChildren()
	end,
	PaintChildren = function(self)
		MGangs.Derma.Paint.Elements['infobox'](self.infotextbox, {rc_tl = true, rc_bl = true})
		MGangs.Derma.Paint.Elements['textentry'](self.dtextentry, {ptext = self.PlaceholderText, rc_br = true, rc_tr = true})
	end,
	SetMinMaxChars = function(self, minc, maxc)
		self.dtextentry.MinCharacters = minc
		self.dtextentry.MaxCharacters = maxc
	end,
	SetCharMatch = function(self, val, err)
		self.dtextentry.CharacterMatch = val
		self.dtextentry.CharacterMatchError = (err or "Error")
	end,
	SetCharFilter = function(self, val, err)
		self.dtextentry.CharacterFilter = val
		self.dtextentry.CharacterFilterError = (err or "Error")
	end,
	SetNumeric = function(self, val)
		self.dtextentry:SetNumeric(val)
	end,
	SetValue = function(self, val)
		self.dtextentry:SetValue(val)
	end,
	GetValue = function(self)
		return self.dtextentry:GetValue()
	end,
	SetInfoText = function(self, val)
		self.InfoText = val
		self.infotextbox.InfoText = val

		surface.SetFont((self:GetFont() or "DermaDefault"))
		local ITxtW, ITxtH = surface.GetTextSize( self.InfoText )

		self.infotextbox:SetWide(ITxtW + 10)
	end,
	GetInfoText = function(self)
		return self.InfoText
	end,
	SetPlaceholderText = function(self, val)
		self.PlaceholderText = val

		self:PaintChildren()
	end,
	GetPlaceholderText = function(self)
		return self.PlaceholderText
	end,
	SetFont = function(self, val)
		self.dtextentry:SetFont(val)
		self.infotextbox:SetFontInternal(val)
	end,
	Paint = function(self,w,h) end,

	-- Overrides
	OnValueChange = function(...) end,
	OnLoseFocus = function(...) end,
	OnEnter = function(...) end,
}, "DPanel")

--[[----------
	Divider
--------------]]
vgui.Register("MG2_Divider", {
	Init = function(self)
		self:Dock(TOP)
		self:DockMargin(5,5,5,5)
		self:SetTall(5)
	end,
	Paint = function(self, w, h)
		draw.RoundedBoxEx(3, 0, 0, w, h, Color(40,40,40,225), true, true, true, true)
	end,
}, "DPanel")


--[[------------------
	Circular Avatar
---------------------]]
vgui.Register("CircularAvatar", {
	Init = function(self)
		self.Avatar = vgui.Create("AvatarImage", self)
		self.Avatar:SetPaintedManually(true)
		self.material = Material( "effects/flashlight001" )
		self:OnSizeChanged(self:GetWide(), self:GetTall())
	end,
	PerformLayout = function(self)
		self:OnSizeChanged(self:GetWide(), self:GetTall())
	end,
	SetSteamID = function(self, ...)
		self.Avatar:SetSteamID(...)
	end,
	SetPlayer = function(self, ...)
		self.Avatar:SetPlayer(...)
	end,
	OnSizeChanged = function(self, w, h)
		self.Avatar:SetSize(self:GetWide(), self:GetTall())
		self.points = math.Max((self:GetWide()/4), 96)
		self.poly = MakeCirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
	end,
	DrawMask = function(self, w, h)
		draw.NoTexture()
		surface.SetMaterial(self.material)
		surface.SetDrawColor(color_white)
		surface.DrawPoly(self.poly)
	end,
	Paint = function(self, w, h)
		render.ClearStencil()
		render.SetStencilEnable(true)

		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_ZERO )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
		render.SetStencilReferenceValue( 1 )

		self:DrawMask(w, h)

		render.SetStencilFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilReferenceValue(1)

		self.Avatar:SetPaintedManually(false)
		self.Avatar:PaintManual()
		self.Avatar:SetPaintedManually(true)

		render.SetStencilEnable(false)
		render.ClearStencil()
	end,
}, "AvatarImage")

--[[------------------
	Circular Image
---------------------]]
vgui.Register("CircularImage", {
	Init = function(self)
		self.Image = vgui.Create("DImage", self)
		self.Image:SetPaintedManually(true)
		self.material = Material( "effects/flashlight001" )
		self:OnSizeChanged(self:GetWide(), self:GetTall())
	end,
	PerformLayout = function(self, w, h)
		self:OnSizeChanged(self:GetWide(), self:GetTall())
	end,
	SetImage = function(self, ...)
		self.Image:SetImage(...)
	end,
	SetMaterial = function(self, ...)
		self.Image:SetMaterial(..., "noclamp smooth")
	end,
	OnSizeChanged = function(self, w, h)
		self.Image:SetSize(self:GetWide(), self:GetTall())
		self.points = math.Max((self:GetWide()/4), 96)
		self.poly = MakeCirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
	end,
	DrawMask = function(self, w, h)
		draw.NoTexture()
		surface.SetMaterial(self.material)
		surface.SetDrawColor(color_white)
		surface.DrawPoly(self.poly)
	end,
	Paint = function(self, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)
		--[[surface.SetDrawColor(45,45,45,225)
		draw.NoTexture()
		draw.Circle(w/2, h/2, w/2, 30)]]

		render.ClearStencil()
		render.SetStencilEnable(true)

		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_ZERO )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
		render.SetStencilReferenceValue( 1 )

		self:DrawMask(w, h)

		render.SetStencilFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilReferenceValue(1)

		self.Image:SetPaintedManually(false)
		self.Image:PaintManual()
		self.Image:SetPaintedManually(true)

		render.SetStencilEnable(false)
		render.ClearStencil()
	end,
}, "DImage")

--[[-----------------------
	HTTP/URL Material Image
--------------------------]]
local function validateHTTPURL(url)
	-- Check if it is a connection (we can't use this)
	if (url:StartWith("https://")) then
		url = url:Replace("https://", "http://")
	end

	return url
end

vgui.Register("HTTPImage", {
    Init = function(self)
        self.DHTMLImg = vgui.Create("DHTML", self)
		self.DHTMLImg:SetSize(self:GetWide(), self:GetTall())
		self.DHTMLImg:SetAlpha(0)
		self.DHTMLImg:SetMouseInputEnabled( false )
    end,
    SetURL = function(self, url)
		url = validateHTTPURL(url)
		
		self.DHTMLImg:SetHTML([[
			<body style="overflow: hidden; margin: 0;">
				<img src="]] .. url .. [[" width=]] .. self:GetWide() .. [[px height=]] .. self:GetTall() .. [[px />
			</body>]])
		self.DHTMLImg.ImageMatLoaded = false

		self.DHTMLImg.LoadImageMat = function()
			if !(self.DHTMLImg) then return false end

			local html_mat = self.DHTMLImg:GetHTMLMaterial()

			if (!html_mat) then return false end

			local scale_x, scale_y = (self:GetWide()/html_mat:Width()),(self:GetTall()/html_mat:Height())

			local matdata = {
				["$basetexture"] = html_mat:GetName(),
				["$basetexturetransform"] = "center 0 0 scale " .. scale_x .. " " .. scale_y .. " rotate 0 translate 0 0",
				["$model"] = 1,
				["$alphatest"] = 1,
				["$nocull"] = 1,
			}

			local uid = string.Replace(html_mat:GetName(),"__vgui_texture_","mg_gangmat_")

			self.mg_webmat = CreateMaterial(uid, "UnlitGeneric", matdata)

			self:SetMaterial(self.mg_webmat)
		end

		self.DHTMLImg.Think = function()
			if (self.DHTMLImg:GetHTMLMaterial() && !self.DHTMLImg.ImageMatLoaded) then
				self.DHTMLImg.ImageMatLoaded = true
					
				self.DHTMLImg.LoadImageMat()
			end
		end
    end
}, "CircularImage")
