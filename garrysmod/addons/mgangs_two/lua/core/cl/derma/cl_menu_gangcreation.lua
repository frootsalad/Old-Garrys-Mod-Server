--[[
MGANGS - CLIENTSIDE MENU - GANG CREATION
Developed by Zephruz
]]

local MENU = {}
MENU.chatCmds = {
  "gangcreate",
  "mgcreate",
}

local setupPages = {
	-- [[Gang info page]]
	{
		page = function(self)
			self.menuframe:SetSize((ScrW()/2 > 675 && ScrW()/2 || 675),(ScrH()/2 > 425 && ScrH()/2 || 425))

			local passData = self.menuframe.active.data

			local container = vgui.Create("DPanel", self.menuframe)
			container:Dock(FILL)
			container:InvalidateParent(true)
			container.Paint = function(self,w,h) end

      --[[Gang Info]]
			local gInfoPnl = vgui.Create("DPanel", container)
			gInfoPnl:Dock(TOP)
			gInfoPnl:InvalidateParent(true)
      gInfoPnl:SetTall(100)
			gInfoPnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200), true, true, true, true)
			end

			local gInfoHdr = vgui.Create("DPanel", gInfoPnl)
			gInfoHdr:Dock(TOP)
			gInfoHdr:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](gInfoHdr, {text = MGangs.Language:GetTranslation("gang_information"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			--[[Gang Name]]
			local gangName = vgui.Create("MG2_InfoTextEntry", gInfoPnl)
			gangName:Dock(TOP)
			gangName:DockMargin(5,5,5,0)
			gangName:SetValue(passData.gangName or "")
			gangName:SetInfoText(MGangs.Language:GetTranslation("gang_name"))
			gangName:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_name"))
			gangName:SetCharFilter(MGangs.Config.BannedNames, MGangs.Language:GetTranslation("name_not_allowed"))
			gangName:SetMinMaxChars(3,15)
			gangName.dtextentry.Think = function(s)
				passData.gangName = (s.ValuesPass && s:GetValue() || false)
			end

			--[[Gang Icon URL]]
			local gangIconURL = vgui.Create("MG2_InfoTextEntry", gInfoPnl)
			gangIconURL:Dock(TOP)
			gangIconURL:DockMargin(5,5,5,0)
			gangIconURL:SetValue(passData.gangIconURL or "")
			gangIconURL:SetInfoText(MGangs.Language:GetTranslation("gang_icon_url"))
			gangIconURL:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_icon_url"))
			gangIconURL:SetCharMatch(MGangs.Config.AllowedImageExts, MGangs.Language:GetTranslation("invalid_icon_url"))
			gangIconURL:SetMinMaxChars(4,300)
			gangIconURL.dtextentry.Think = function(s)
				passData.gangIconURL = (s.ValuesPass && s:GetValue() || false)
			end
      MGangs.Derma.Paint.Elements['infobox'](gangIconURL.infotextbox, {rc_tl = true, rc_bl = true, toolTipText = MGangs.Language:GetTranslation("gang_icon_tootlip")})

			--[[Gang Groups]]
      local gGrpPnl = vgui.Create("DPanel", container)
			gGrpPnl:Dock(FILL)
      gGrpPnl:DockMargin(0,5,0,0)
			gGrpPnl:InvalidateParent(true)
			gGrpPnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200), true, true, true, true)
			end

			local hdr_GGroups = vgui.Create("DPanel", gGrpPnl)
			hdr_GGroups:Dock(TOP)
			hdr_GGroups:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](hdr_GGroups, {text = MGangs.Language:GetTranslation("edit_default_groups"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			local gGroupNotice = vgui.Create("DPanel", gGrpPnl)
			gGroupNotice:Dock(TOP)
			gGroupNotice:DockMargin(5,5,5,0)
			gGroupNotice.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

				draw.SimpleText( MGangs.Language:GetTranslation("edit_groups_after_creation"), "MG_GangInfo_XSM", 5, h/2, Color(245,245,245,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end

			local groupNoticeDiv = vgui.Create("MG2_Divider", gGrpPnl)

			local gangGroups = vgui.Create("DScrollPanel", gGrpPnl)
			gangGroups:Dock(FILL)
			gangGroups:DockMargin(5,0,5,5)
			MGangs.Derma.Paint.Elements['scrollpanel'](gangGroups)

			passData.gangGroups = (passData.gangGroups or {})

			for k=1,#MGangs.Gang.DefaultGroups do
				local v = MGangs.Gang.DefaultGroups[k]

				passData.gangGroups[k] = (passData.gangGroups[k] or {})
				passData.gangGroups[k].groupName = (passData.gangGroups[k].groupName || v.name || "")
				passData.gangGroups[k].groupIcon = (passData.gangGroups[k].groupIcon || v.icon || MGangs.Language:GetTranslation("select_group_icon"))
				passData.gangGroups[k].groupPriority = (passData.gangGroups[k].groupPriority || v.priority || 0)

				local group = vgui.Create("DPanel", gangGroups)
				group:Dock(TOP)
				group:DockPadding(5,5,5,5)
				group.Paint = function(self,w,h)
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,135), true, true, true, true)
				end

				--[[Group Name]]
				local groupName = vgui.Create("MG2_InfoTextEntry", group)
				groupName:Dock(TOP)
				groupName:DockMargin(0,0,0,5)
				groupName:SetValue(passData.gangGroups[k].groupName)
				groupName:SetInfoText(MGangs.Language:GetTranslation("group_name"))
				groupName:SetPlaceholderText(MGangs.Language:GetTranslation("enter_group_name"))
				groupName:SetCharFilter({}, MGangs.Language:GetTranslation("name_not_allowed"))
				groupName:SetMinMaxChars(3,15)
				groupName.dtextentry.Think = function(s)
					passData.gangGroups[k].groupName = (s.ValuesPass && s:GetValue() || false)
				end

				--[[Group Icon]]
				local groupIcon = vgui.Create("MG2_InfoComboBox", group)
				groupIcon:Dock(TOP)
				groupIcon:DockMargin(0,0,0,5)
				groupIcon:SetInfoText(MGangs.Language:GetTranslation("group_icon"))
				groupIcon:SetValue(passData.gangGroups[k].groupIcon)
				groupIcon:SetCBoxMaterial(passData.gangGroups[k].groupIcon)
				groupIcon.OnSelect = function(s, index, data)
					passData.gangGroups[k].groupIcon = data

					groupIcon:SetCBoxMaterial(data)
				end

				for _,awardicons in pairs(file.Find("materials/icon16/award_*.png","GAME")) do
					groupIcon:AddChoice("icon16/" .. awardicons)
				end
				for _,usericons in pairs(file.Find("materials/icon16/user_*.png", "GAME")) do
					groupIcon:AddChoice("icon16/" .. usericons)
				end

				--[[Group Priority]]
				local groupPriority = vgui.Create("MG2_InfoTextEntry", group)
				groupPriority:Dock(TOP)
				groupPriority:DockMargin(0,0,0,5)
				groupPriority:SetValue(passData.gangGroups[k].groupPriority)
				groupPriority:SetInfoText(MGangs.Language:GetTranslation("group_priority"))
				groupPriority:SetPlaceholderText(MGangs.Language:GetTranslation("enter_group_priority"))
				groupPriority:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
				groupPriority:SetNumeric(true)
				groupPriority.OnValueChange = function(panel, value)
					passData.gangGroups[k].groupPriority = value
				end

				group:InvalidateLayout(true)
				group:SizeToChildren(false, true)

				if (k != #MGangs.Gang.DefaultGroups) then
					local divider = vgui.Create("MG2_Divider", gangGroups)
				end
			end

			return container
		end,
		nextCheck = function(self)
			local passData = self.menuframe.active.data

			if (!passData.gangName or !passData.gangIconURL) then
				MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

				return false
			end
			for i=1,#passData.gangGroups do
				if !(passData.gangGroups[i].groupName) then
					MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

					return false
				end
			end

			return true
		end,
	},

	-- [[Review & Finish Page]]
	{
		page = function(self)
			self.menuframe:SetTall(205)

			local passData = self.menuframe.active.data

			local container = vgui.Create("DPanel", self.menuframe)
			container:Dock(FILL)
			container:InvalidateParent(true)
			container.Paint = function(self,w,h) end

			local hdr = vgui.Create("DPanel", container)
			hdr:Dock(TOP)
			MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("review_and_finish"), rc_tl = true, rc_tr = true})

			local pnl = vgui.Create("DPanel", container)
			pnl:Dock(FILL)
			pnl:InvalidateParent(true)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), false, false, true, true)
			end

			-- Gang Image
			local gangimg_Pnl = vgui.Create("DPanel", pnl)
			gangimg_Pnl:Dock(LEFT)
			gangimg_Pnl:DockMargin(5,5,5,5)
			gangimg_Pnl:SetWide(96)
			gangimg_Pnl.Paint = function(self,w,h) end

			local gangimg = vgui.Create("HTTPImage", gangimg_Pnl)
			gangimg:Dock(TOP)
			gangimg:SetSize(96,96)
			gangimg:SetURL((passData.gangIconURL or "http://people.sc.fsu.edu/~jburkardt/data/png/baboon.png"))

			-- Gang Data
			local gangdata = vgui.Create("DPanel", pnl)
			gangdata:Dock(FILL)
			gangdata:DockMargin(5,5,5,5)
      gangdata:InvalidateParent(true)
		  gangdata.Paint = function(self,w,h) end

			-- Gang Info
      local gInfoPnl = vgui.Create("DPanel", gangdata)
      gInfoPnl:Dock(LEFT)
      gInfoPnl:DockPadding(0,0,5,0)
      gInfoPnl:InvalidateParent(true)
      gInfoPnl:SetWide(gangdata:GetWide()/2)
      gInfoPnl.Paint = function(s,w,h) end

			local hdr_GInfo = vgui.Create("DPanel", gInfoPnl)
			hdr_GInfo:Dock(TOP)
			hdr_GInfo:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](hdr_GInfo, {text = MGangs.Language:GetTranslation("gang_information"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			local ginfotbl = {
				MGangs.Language:GetTranslation("gang_name") .. ": " .. (passData.gangName or "NIL"),
				MGangs.Language:GetTranslation("leader") .. ": " .. LocalPlayer():Nick() .. " (" .. LocalPlayer():SteamID() .. ")",
			}

			for i=1,#ginfotbl do
				local pnl = vgui.Create("DPanel", gInfoPnl)
				pnl:Dock(TOP)
				pnl:DockMargin(0,5,0,0)
				pnl.Paint = function(s,w,h)
          draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200), true, true, true, true)

					draw.SimpleText( ginfotbl[i], "MG_GangInfo_SM", 5, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end

			-- Gang Groups
      local gGrpPnl = vgui.Create("DPanel", gangdata)
      gGrpPnl:Dock(RIGHT)
      gGrpPnl:DockPadding(5,0,0,0)
      gGrpPnl:SetWide(gangdata:GetWide()/2)
      gGrpPnl.Paint = function(s,w,h) end

			local hdr_GGroups = vgui.Create("DPanel", gGrpPnl)
			hdr_GGroups:Dock(TOP)
			hdr_GGroups:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](hdr_GGroups, {text = MGangs.Language:GetTranslation("gang_groups"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			for i=1,#passData.gangGroups do
				local gIcon = (Material(passData.gangGroups[i].groupIcon) || false)

				local pnl = vgui.Create("DPanel", gGrpPnl)
				pnl:Dock(TOP)
				pnl:DockMargin(0,5,0,0)
				pnl.Paint = function(s,w,h)
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200), true, true, true, true)

					if (gIcon) then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(gIcon)
						surface.DrawTexturedRect(5, 4, 16, 16)
					end

					draw.SimpleText( passData.gangGroups[i].groupName, "MG_GangInfo_SM", 25, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( MGangs.Language:GetTranslation("priority") .. ": " .. passData.gangGroups[i].groupPriority, "MG_GangInfo_SM", w-5, h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
			end

			-- Finish/Create Gang
      local gCostCfg = MGangs.Config.GangCost

			local finishGangCreation = vgui.Create("DButton", container)
			finishGangCreation:Dock(BOTTOM)
			finishGangCreation:DockMargin(0,5,0,0)
			finishGangCreation:SetTall(35)
			MGangs.Derma.Paint.Elements['button'](finishGangCreation, {
        text = MGangs.Language:GetTranslation("finish_gang_creation") .. (gCostCfg.enabled && " (" .. MGangs.Config.DollarSymbol .. MGangs.Util:FormatNumber(gCostCfg.cost) .. ")" || ""),
        rc_tl = true,
        rc_bl = true,
        rc_tr = true,
        rc_br = true,
      })
			finishGangCreation.DoClick = function(s)
				MGangs.Gang:Create(passData.gangName, passData.gangIconURL, passData.gangGroups)

				self.menuframe:Remove()
			end

			return container
		end,
	},
}

function MENU:Init()
	local gangData = MGangs.Gang:GetData()

	if (gangData.id) then return false end
  if (IsValid(self.menuframe)) then self.menuframe:Remove() end

	--[[Derma]]
	self.menuframe = vgui.Create("DFrame")
	self.menuframe:SetSize((ScrW()/2 > 675 && ScrW()/2 || 675),(ScrH()/2 > 425 && ScrH()/2 || 425))
	self.menuframe:Center()
	self.menuframe:MakePopup()
	self.menuframe:ShowCloseButton(false)
	MGangs.Derma.Paint.Elements['frame'](self.menuframe, MGangs.Language:GetTranslation("create_your_gang"))
	self.menuframe.active = {id = 1, data = {}}

	self.menuclose = vgui.Create("DButton", self.menuframe)
	self.menuclose:SetSize(20,24)
	self.menuclose:SetPos(self.menuframe:GetWide() - 20,0)
	self.menuclose.DoClick = function(self)
		self:GetParent():Remove()
	end
	MGangs.Derma.Paint.Elements['closebutton'](self.menuclose, "X")

	--[[Previous & Next Page]]
	self.prevpage = vgui.Create("DButton", self.menuframe)
	self.prevpage:Dock(LEFT)
	self.prevpage:DockMargin(0,0,5,0)
	self.prevpage:SetWide(35)
	MGangs.Derma.Paint.Elements['button'](self.prevpage, {text = "<", rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})
	self.prevpage:SetVisible(false)
	self.prevpage:SetToolTip(MGangs.Language:GetTranslation("previous_step"))
	self.prevpage.DoClick = function()
		local prevPageId = self.menuframe.active.id - 1
		local prevPage = setupPages[prevPageId]
		if (prevPage) then
			if (prevPageId <= 1) then
				self.prevpage:SetVisible(false)
			end

			self.nextpage:SetVisible(true)
			if (self.menuframe.active.pg) then
				self.menuframe.active.pg:Remove()
			end

			self.menuframe.active.id = prevPageId
			self.menuframe.active.pg = prevPage.page(self)
		end
	end

	self.nextpage = vgui.Create("DButton", self.menuframe)
	self.nextpage:Dock(RIGHT)
	self.nextpage:DockMargin(5,0,0,0)
	self.nextpage:SetWide(35)
	self.nextpage:SetToolTip(MGangs.Language:GetTranslation("next_step"))
	MGangs.Derma.Paint.Elements['button'](self.nextpage, {text = ">", rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})
	if (#setupPages <= 1) then
		self.prevpage:SetVisible(false)
	end
	self.nextpage.DoClick = function()
		local shouldCont = true

		local curPageId = self.menuframe.active.id
		local curPage = setupPages[curPageId]

		if (curPage.nextCheck) then
			shouldCont = curPage.nextCheck(self)
		end

		if (shouldCont) then
			local nextPageId = self.menuframe.active.id + 1
			local nextPage = setupPages[nextPageId]
			if (nextPage) then
				if (#setupPages == nextPageId) then
					self.nextpage:SetVisible(false)
				end

				self.prevpage:SetVisible(true)
				if (self.menuframe.active.pg) then
					self.menuframe.active.pg:Remove()
				end

				self.menuframe.active.id = nextPageId
				self.menuframe.active.pg = nextPage.page(self)
			end
		end
	end

	--[[Pages]]
	self.menuframe.active.pg = setupPages[self.menuframe.active.id].page(MENU)
end

MGangs.Derma:RegisterMenu("gangcreate_menu", MENU)
