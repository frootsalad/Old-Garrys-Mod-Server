--[[
MGANGS - CLIENTSIDE MENU - GANG
Developed by Zephruz
]]

local MENU = {}
MENU.chatCmds = {
	"gang",
	"gangmenu",
}

net.Receive("MG2.Gang.ActivateMenu",
function(len)
	local open = (net.ReadBool() or false)

	if !(open) then
		if (MENU.menuframe && IsValid(MENU.menuframe)) then
			MENU.menuframe:Remove()
		end
	else
		MENU:Init()
	end
end)

function MENU:Init()
	local gangData = MGangs.Gang:GetData()
	local isAdmin = (MGangs.Config.AdminGroups[LocalPlayer():GetUserGroup()] or false)

	if (!gangData.id) then MGangs:Notification("You aren't in a gang!") return false end

	if (IsValid(self.menuframe)) then self.menuframe:Remove() end

	-- [[Derma]]
	local mfW, mfH = 850, 426

	self.menuframe = vgui.Create("DFrame")
	self.menuframe:SetSize((ScrW()/2 > mfW && ScrW()/2 || mfW),(ScrH()/2 > mfH && ScrH()/2 || mfH))
	self.menuframe:Center()
	self.menuframe:MakePopup()
	self.menuframe:ShowCloseButton(false)
	MGangs.Derma.Paint.Elements['frame'](self.menuframe, "")
	self.menuframe.active = {button = nil, pg = nil}

	self.menuclose = vgui.Create("DButton", self.menuframe)
	self.menuclose:SetSize(20,24)
	self.menuclose:SetPos(self.menuframe:GetWide() - 20,0)
	self.menuclose.DoClick = function(self)
		self:GetParent():Remove()
	end
	MGangs.Derma.Paint.Elements['closebutton'](self.menuclose, "X")

	--[[Top-NavBar Buttons]]

	-- Settings
	self.tnav_Settings = vgui.Create("DButton", self.menuframe)
	self.tnav_Settings:SetPos(self.menuframe:GetWide() - 105,0)
	self.tnav_Settings:SetSize(80,24)
	self.tnav_Settings.DoClick = function(slf)
		if (self.menuframe.active.button) then self.menuframe.active.button:SetDisabled(false) end
		if (self.menuframe.active.pg) then self.menuframe.active.pg:Remove() end

		self.menuframe.active.button = slf
		self.menuframe.active.pg = slf:Page(self.menuframe)
		slf:SetDisabled(true)
	end
	self.tnav_Settings.Page = function(slf, parent)
		local pnl = self:SettingsPanel(parent)

		return pnl
	end
	MGangs.Derma.Paint.Elements['button'](self.tnav_Settings, {text = MGangs.Language:GetTranslation("settings")})

	-- Admin
	if (isAdmin) then
		self.tnav_Admin = vgui.Create("DButton", self.menuframe)
		self.tnav_Admin:SetPos(self.menuframe:GetWide() - 190,0)
		self.tnav_Admin:SetSize(80,24)
		self.tnav_Admin.DoClick = function(slf)
			LocalPlayer():ConCommand("gang_admin")

			self.menuframe:Remove()
		end
		MGangs.Derma.Paint.Elements['button'](self.tnav_Admin, {text = MGangs.Language:GetTranslation("admin")})
	end

	--[[Navigation]]
	-- Nav Container
	self.menunav = vgui.Create("DPanel", self.menuframe)
	self.menunav:Dock(LEFT)
	self.menunav:DockMargin(-5,-5,-5,-5)
	self.menunav:SetWide(250)
	MGangs.Derma.Paint.Elements['navbar'](self.menunav)

	-- Nav Info Card
	self.menunavinfo = vgui.Create("DPanel", self.menunav)
	self.menunavinfo:Dock(TOP)
	self.menunavinfo:DockMargin(0,0,0,0)
	self.menunavinfo:SetTall(105)
	MGangs.Derma.Paint.Elements['navbarInfo'](self.menunavinfo,
	{infofunc = function(self,w,h)
		draw.SimpleText( gangData.name, "MG_GangInfo_Name", 80, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) -- Gang Name
		draw.SimpleText( #MGangs.Gang:GetOnlineMembers(gangData.id) .. " " .. MGangs.Language:GetTranslation("members_online"), "MG_GangInfo_SubText", 80, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) -- Gang Members
	end})

	-- Gang Image
	self.gangimg = vgui.Create("HTTPImage", self.menunavinfo)
	self.gangimg:SetSize(64, 64)
	self.gangimg:SetPos(10, 10)
	self.gangimg:SetURL(gangData.icon_url or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")

	-- Gang Level
	self.menunavinfo_Level = vgui.Create("DProgress", self.menunavinfo)
	self.menunavinfo_Level:Dock(BOTTOM)
	self.menunavinfo_Level:DockMargin(10,0,10,5)
	self.menunavinfo_Level:SetTall(20)
	self.menunavinfo_Level:SetFraction( gangData.exp/MGangs.Config.LevelSettings.xpformula(gangData.level) )
	MGangs.Derma.Paint.Elements['progressbar'](self.menunavinfo_Level,
	function(self,w,h)
		draw.SimpleText( MGangs.Language:GetTranslation("lvl") .. " " .. gangData.level,
		"MG_ProgBar_Text", 10, h/2, MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].progressbar.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		draw.SimpleText( gangData.exp .. "/" .. MGangs.Config.LevelSettings.xpformula(gangData.level) .. " " .. MGangs.Language:GetTranslation("exp"),
		"MG_ProgBar_Text", w - 10, h/2, MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].progressbar.text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end)

	-- Nav Button Panel
	self.menunavbuttons = vgui.Create("DScrollPanel", self.menunav)
	self.menunavbuttons:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](self.menunavbuttons)

	--[[Nav Menus]]
	self:CreateMenuButtons()
end

function MENU:SetCurrentMenu(navBtn, menu)
  if (self.menuframe.active.button) then self.menuframe.active.button:SetDisabled(false) end
  if (self.menuframe.active.pg) then self.menuframe.active.pg:Remove() end

	local curNavBtn = navBtn

	if (curNavBtn) then
    local curPage = (curNavBtn.Page && curNavBtn:Page(self.menuframe) or menu && menu(self.menuframe) or false)

		self.menuframe.active.button = curNavBtn
		self.menuframe.active.pg = curPage

		self.menuframe.active.button:SetDisabled(true)
	end
end

--[[
	LOAD MODULE MENUS
	- Called to retreive any menus that are externally added.
]]
function MENU:LoadModuleMenus()
	for _,mb in pairs(MGangs.Derma.MenuButtons) do
		if (isfunction(mb)) then
			mb(self)
		end
	end
end

function MENU:CreateMenuButtons()
	if (MGangs.Config.Balance && MGangs.Config.Balance.enabled) then
		self:GangBalancePanel()		-- Gang Balance Panel
	end

	self:GangMembersMenu() 		-- Gang Members
	self:LoadModuleMenus()		-- Load Module Menus/Buttons

	if (self.mnav_Members) then
		self.mnav_Members:DoClick()
	end
end

--[[
	GANG BALANCE PANEL
]]
function MENU:GangBalancePanel()
	local gangData = MGangs.Gang:GetData()

	local balPnl = vgui.Create("DPanel", self.menunavbuttons)
	balPnl:Dock(TOP)
	balPnl:DockMargin(0,5,0,0)
	balPnl:SetTall(30)
	balPnl.Paint = function(s,w,h)
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), false, false, false, false)

			draw.SimpleText( MGangs.Config.DollarSymbol .. MGangs.Util:FormatNumber(gangData.balance or 0), "MG_GangInfo_SubText", 5, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) -- Gang Balance
	end

	local canDep = MGangs.Player:HasPermission("Balance", "Deposit")
	local canWit = MGangs.Player:HasPermission("Balance", "Withdraw")

	-- Deposit
	if (canDep) then
		local depBtn = vgui.Create("DButton", balPnl)
		depBtn:Dock(RIGHT)
		depBtn:DockMargin(0,5,5,5)
		MGangs.Derma.Paint.Elements['button'](depBtn, {text = MGangs.Language:GetTranslation("deposit"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})
		depBtn.DoClick = function()
			local valPass = true

			local depPrompt = vgui.Create("MG2_PromptBox")
			depPrompt:SetQuestionText("")
			depPrompt:SetButtonTexts(MGangs.Language:GetTranslation("deposit"), MGangs.Language:GetTranslation("cancel"))
			depPrompt:SetTall(100)
			depPrompt:Setup()

			local depEntry = vgui.Create("MG2_InfoTextEntry", depPrompt)
			depEntry:Dock(TOP)
			depEntry:DockMargin(0,0,0,0)
			depEntry:SetInfoText(MGangs.Language:GetTranslation("deposit_amt"))
			depEntry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_deposit_amt"))
			depEntry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
			depEntry:SetNumeric(true)
			depEntry.dtextentry.Think = function(s)
				valPass = (s.ValuesPass)
			end

			depPrompt:SetOptions(
			function()
					if !(valPass) then
						MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

						return false
					end

					MGangs.Gang:DepositMoney(depEntry:GetValue())

					return true
			end)
		end
	end

	-- Withdraw
	if (canWit) then
		local witBtn = vgui.Create("DButton", balPnl)
		witBtn:Dock(RIGHT)
		witBtn:DockMargin(0,5,5,5)
		MGangs.Derma.Paint.Elements['button'](witBtn, {text = MGangs.Language:GetTranslation("withdraw"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})
		witBtn.DoClick = function()
			local valPass = true

			local witPrompt = vgui.Create("MG2_PromptBox")
			witPrompt:SetQuestionText("")
			witPrompt:SetButtonTexts(MGangs.Language:GetTranslation("withdraw"), MGangs.Language:GetTranslation("cancel"))
			witPrompt:SetTall(100)
			witPrompt:Setup()

			local witEntry = vgui.Create("MG2_InfoTextEntry", witPrompt)
			witEntry:Dock(TOP)
			witEntry:DockMargin(0,0,0,0)
			witEntry:SetInfoText(MGangs.Language:GetTranslation("withdraw_amt"))
			witEntry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_withdraw_amt"))
			witEntry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
			witEntry:SetNumeric(true)
			witEntry.dtextentry.Think = function(s)
				valPass = s.ValuesPass
			end

			witPrompt:SetOptions(
			function()
					if !(valPass) then
						MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

						return false
					end

					MGangs.Gang:WithdrawMoney(witEntry:GetValue())

					return true
			end)
		end
	end
end

--[[
	GANG MEMBERS MENU
]]
function MENU:GangMembersMenu()
	local memberPerms = MGangs.Gang:GetPermissions("Member")

	self.mnav_Members = vgui.Create("DButton", self.menunavbuttons)
	self.mnav_Members:Dock(TOP)
	self.mnav_Members:DockMargin(0,5,0,5)
	self.mnav_Members:SetTall(35)
	self.mnav_Members.DoClick = function(slf)
		self:SetCurrentMenu(slf, function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:DockMargin(10,0,0,0)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
			end

			--[[Get Members]]
			local gangMembers = MGangs.Gang:GetMembers()
			for i=1,#gangMembers do
				local groupInfo = (MGangs.Gang:GroupInfo(gangMembers[i].group) || false)

				gangMembers[i].group_name = (groupInfo && groupInfo.name or "NIL")
			end

			--[[Members Search Panel]]
			local memList_Pnl = vgui.Create("MG2_PagedScrollPanel", pnl)
			memList_Pnl:Dock(FILL)
			memList_Pnl:SetMaxPageResults(6)
			memList_Pnl.Paint = function(s,w,h) end

			--[[Header]]
			local hdr = vgui.Create("DPanel", memList_Pnl)
			hdr:Dock(TOP)
			hdr:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("members"), rc_tl = true, rc_tr = true})

			--[[Load Members]]
			memList_Pnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_members"), placeholder = MGangs.Language:GetTranslation("search_members_criteria")})
			memList_Pnl.PageItemSetup = function(s, page, memInfo)
				memInfo = {
					status = (memInfo.status or 0),
					name = (memInfo.name or "NIL"),
					steamid = (memInfo.steamid or "NIL"),
					group_name = (memInfo.group_name or "NIL"),
				}

				local statusIcon = (memInfo.status == 1 && Material("icon16/bullet_green.png") || Material("icon16/bullet_red.png"))

				local member = vgui.Create("DPanel")
				member:Dock(TOP)
				member:DockMargin(5,5,5,0)
				member:SetTall(50)
				member.Paint = function(s,w,h)
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

					-- Status
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(statusIcon)
					surface.DrawTexturedRect(2, h/2 - 7, 16, 16)

					-- Name
					draw.SimpleText( memInfo.name, "MG_GangInfo_SM", 20, h*0.35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

					-- SteamID
					draw.SimpleText( memInfo.steamid, "MG_GangInfo_XSM", 20, h*0.7, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

					-- Group
					draw.SimpleText( memInfo.group_name, "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				if (#memberPerms > 0 && memInfo.steamid != LocalPlayer():SteamID()) then
					local memberOptions = vgui.Create("DButton", member)
					memberOptions:Dock(RIGHT)
					memberOptions:SetWide(100)
					MGangs.Derma.Paint.Elements['button'](memberOptions, {text = MGangs.Language:GetTranslation("options"), rc_tr = true, rc_br = true})
					memberOptions.DoClick = function(s)
						local memOptions = DermaMenu()

						for i=1,#memberPerms do
							local mPerms = memberPerms[i]
							local mpInfo = MGangs.Gang:GetPermissionInfo("Member", mPerms)
							mpInfo = (mpInfo or {})

							if !(mpInfo.menuOpts) then
								local opt = memOptions:AddOption( mPerms )

								opt.DoClick = function()
									if !(mpInfo.use) then return false end

									mpInfo.use(member, memInfo.steamid)
								end
							else
								for k,v in pairs(mpInfo.menuOpts) do
									local optSub = memOptions:AddSubMenu( k )
									local opts = v()

									for i,d in pairs(opts) do
										local opt = optSub:AddOption( d.name or "NIL" )

										opt.DoClick = function()
											if !(mpInfo.use) then return false end

											mpInfo.use(member, memInfo.steamid, d)
										end
									end
								end
							end
						end

						memOptions:Open()
					end
				end

				return member
			end
			memList_Pnl:SetPageTable(gangMembers)
			memList_Pnl:SetCurrentPage(1)

			return pnl
		end)
	end
	MGangs.Derma.Paint.Elements['navbutton'](self.mnav_Members, {text = MGangs.Language:GetTranslation("members")})
end

--[[
	SETTINGS MENU
]]
function MENU:SettingsPanel(parent)
	local pnl = vgui.Create("DPanel", parent)
	pnl:Dock(FILL)
	pnl:DockMargin(10,0,0,0)
	pnl.Paint = function(self,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
	end

	--[[Header]]
	local hdr = vgui.Create("DPanel", pnl)
	hdr:Dock(TOP)
	hdr:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("settings"), rc_tl = true, rc_tr = true})

	--[[Settings Panel]]
	local stngsPnl = vgui.Create("DScrollPanel", pnl)
	stngsPnl:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](stngsPnl)

	for k,v in pairs(MGangs.Gang.Settings) do
		local gangStng
		local gangHdr = vgui.Create("DPanel")
		gangHdr:Dock(TOP)
		gangHdr:DockMargin(5,5,5,5)
		MGangs.Derma.Paint.Elements['header'](gangHdr, {text = k, rc_tl = true, rc_tr = true, rc_bl = true, rc_br = true})

		stngsPnl:AddItem(gangHdr)

		for i,j in pairs(v) do
			gangStng = j.menu(MENU.menuframe,
			function()
				return MENU:SettingsPanel(parent)
			end)

			if (gangStng) then
				if !(istable(gangStng)) then
					gangStng:DockMargin(5,0,5,5)

					stngsPnl:AddItem(gangStng)
				else
					for r,p in pairs(gangStng) do
						p:DockMargin(5,0,5,5)

						stngsPnl:AddItem(p)
					end
				end
			end

			if (j.check && !j.check()) then
				if !(istable(gangStng)) then
					if (gangStng && gangStng:IsValid()) then gangStng:Remove() end
				else
					for r,p in pairs(gangStng) do
						p:Remove()

						gangStng[r] = nil
					end

					if (table.Count(gangStng) <= 0) then
						gangHdr:Remove()
					end
				end
			end
		end
	end

	return pnl
end

MGangs.Derma:RegisterMenu("gang_menu", MENU)
