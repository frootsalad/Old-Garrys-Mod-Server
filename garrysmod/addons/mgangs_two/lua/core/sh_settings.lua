--[[
MGANGS - SHARED SETTINGS
Developed by Zephruz
]]

--[[--------------
	Settings
-----------------]]
MGangs.Gang.Settings = {}

MGangs.Meta:Register("RegisterSettings", MGangs.Gang,
function(self, category, name, data)
	if !(MGangs.Gang.Settings[category]) then MGangs.Gang.Settings[category] = {} end

	MGangs.Gang.Settings[category][name] = {
		data = (data.data or {
			name = (data.name or name),
		}),
		menu = (data.menu or nil),
		check = (data.check or nil),
	}
end)

--[[
	Default Settings
]]

--[[General Settings]]
-- General - Leave Gang
MGangs.Gang:RegisterSettings(MGangs.Language:GetTranslation("general"), MGangs.Language:GetTranslation("leave_gang"), {
	menu = function(parent, curPnl)
		local btn = vgui.Create("DButton")
		btn:Dock(TOP)
		MGangs.Derma.Paint.Elements['button'](btn, {text = MGangs.Language:GetTranslation("leave_gang"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		btn.DoClick = function()
			MGangs.Gang:Leave()
		end

		return btn
	end,
})

--[[Gang Settings]]
-- Gang - Edit Gang
MGangs.Gang:RegisterSettings(MGangs.Language:GetTranslation("gang_administration"), MGangs.Language:GetTranslation("edit_gang"), {
	check = function()
		local perms = MGangs.Player:HasPermission("Gang", "Edit")

		return perms
	end,
	menu = function(parent, curPnl)
		local btn = vgui.Create("DButton")
		btn:Dock(TOP)
		MGangs.Derma.Paint.Elements['button'](btn, {text = MGangs.Language:GetTranslation("edit_gang_information"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		local function openEditGang(parent)
			local gangData = table.Copy(MGangs.Gang:GetData())

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
			MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("edit_gang"), rc_tl = true, rc_tr = true})

			--[[To Settings]]
			local stngsBtn = vgui.Create("DButton", hdr)
			stngsBtn:Dock(RIGHT)
			stngsBtn:SetWide(110)
			MGangs.Derma.Paint.Elements['button'](stngsBtn, {text = MGangs.Language:GetTranslation("back_to_settings"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
			stngsBtn.DoClick = function(slf)
				parent.active.pg = curPnl(parent)

				pnl:Remove()
			end

			--[[Gang Edit Settings]]
			local gangName = vgui.Create("MG2_InfoTextEntry", pnl)
			gangName:Dock(TOP)
			gangName:DockMargin(5,5,5,0)
			gangName:SetValue(gangData.name or "")
			gangName:SetInfoText(MGangs.Language:GetTranslation("gang_name"))
			gangName:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_name"))
			gangName:SetCharFilter(MGangs.Config.BannedNames, MGangs.Language:GetTranslation("name_not_allowed"))
			gangName:SetMinMaxChars(3,15)
			gangName.dtextentry.Think = function(s)
				gangData.name = (s.ValuesPass && s:GetValue() || false)
			end

			--[[Gang Icon URL]]
			local gangIconURL = vgui.Create("MG2_InfoTextEntry", pnl)
			gangIconURL:Dock(TOP)
			gangIconURL:DockMargin(5,5,5,0)
			gangIconURL:SetValue(gangData.icon_url or "")
			gangIconURL:SetInfoText(MGangs.Language:GetTranslation("gang_icon_url"))
			gangIconURL:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_icon_url"))
			gangIconURL:SetCharMatch(MGangs.Config.AllowedImageExts, MGangs.Language:GetTranslation("invalid_icon_url"))
			gangIconURL:SetMinMaxChars(4,300)
			gangIconURL.dtextentry.Think = function(s)
				gangData.icon_url = (s.ValuesPass && s:GetValue() || false)
			end
			MGangs.Derma.Paint.Elements['infobox'](gangIconURL.infotextbox, {rc_tl = true, rc_bl = true, toolTipText = MGangs.Language:GetTranslation("gang_icon_tootlip")})

			--[[Save Gang]]
			local saveBtn = vgui.Create("DButton", pnl)
			saveBtn:Dock(TOP)
			saveBtn:DockMargin(5,5,5,5)
			MGangs.Derma.Paint.Elements['button'](saveBtn, {text = MGangs.Language:GetTranslation("save"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			saveBtn.DoClick = function()
				if (!gangData.name or !gangData.icon_url) then
					MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

					return false
				end

				MGangs.Gang:UpdateData({
					name = gangData.name,
					icon_url = gangData.icon_url,
				})

				MGangs:Notification(MGangs.Language:GetTranslation("updated_gang_info"))
			end

			return pnl
		end

		btn.DoClick = function()
			if (parent.active.pg) then parent.active.pg:Remove() end

			parent.active.pg = openEditGang(parent)
		end

		return btn
	end,
})

-- Gang - Invite Players
MGangs.Gang:RegisterSettings(MGangs.Language:GetTranslation("gang_administration"), MGangs.Language:GetTranslation("invite_players"), {
	check = function()
		local perms = MGangs.Player:HasPermission("User", "Invite")

		return perms
	end,
	menu = function(parent, curPnl)
		local btn = vgui.Create("DButton")
		btn:Dock(TOP)
		MGangs.Derma.Paint.Elements['button'](btn, {text = MGangs.Language:GetTranslation("invite_players"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		local function openInvitePlayers(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:DockMargin(10,0,0,0)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
			end

			--[[Player Search Panel]]
			local plySPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
			plySPnl:Dock(FILL)
			plySPnl:SetMaxPageResults(6)
			plySPnl.Paint = function(s,w,h) end

			--[[Header]]
			local hdr = vgui.Create("DPanel", plySPnl)
			hdr:Dock(TOP)
			hdr:DockMargin(0,0,0,0)
			MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("invite_player"), rc_tl = true, rc_tr = true})

			--[[To Settings]]
			local stngsBtn = vgui.Create("DButton", hdr)
			stngsBtn:Dock(RIGHT)
			stngsBtn:SetWide(110)
			MGangs.Derma.Paint.Elements['button'](stngsBtn, {text = MGangs.Language:GetTranslation("back_to_settings"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
			stngsBtn.DoClick = function(slf)
				parent.active.pg = curPnl(parent)

				pnl:Remove()
			end

			--[[Load Players]]
			local players = player.GetAll()

			plySPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_players"), placeholder = "Type a name, SteamID, etc. and press enter"})
			plySPnl.PageItemSetup = function(s, page, plyInfo)
				if (!plyInfo or !IsValid(plyInfo)) then return false end

				if (plyInfo:GetGangID() == 0) then
					-- Player Panel
					local plyPnl = vgui.Create("DPanel")
					plyPnl:Dock(TOP)
					plyPnl:DockMargin(5,5,5,0)
					plyPnl:SetTall(50)
					plyPnl.Paint = function(s,w,h)
						draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

						-- Name
						draw.SimpleText( plyInfo:Nick() or "NIL", "MG_GangInfo_SM", 50, h*0.35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

						-- SteamID
						draw.SimpleText( plyInfo:SteamID() or "NIL", "MG_GangInfo_XSM", 50, h*0.7, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end

					local plyAva = vgui.Create("CircularAvatar", plyPnl)
					plyAva:Dock(LEFT)
					plyAva:DockMargin(5,5,5,5)
					plyAva:SetSize(40,40)
					plyAva:SetPlayer(plyInfo)

					local invPlyBtn = vgui.Create("DButton", plyPnl)
					invPlyBtn:Dock(RIGHT)
					invPlyBtn:SetWide(110)
					MGangs.Derma.Paint.Elements['button'](invPlyBtn, {text = MGangs.Language:GetTranslation("invite"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = true})
					invPlyBtn.DoClick = function(slf)
						MGangs.Player:Invite(plyInfo)

						plyPnl:Remove()
					end

					return plyPnl
				end
			end
			plySPnl:SetPageTable(players)
			plySPnl:SetCurrentPage(1)

			return pnl
		end

		btn.DoClick = function()
			if (parent.active.pg) then parent.active.pg:Remove() end

			parent.active.pg = openInvitePlayers(parent)
		end

		return btn
	end,
})

-- Gang - Groups
MGangs.Gang:RegisterSettings(MGangs.Language:GetTranslation("gang_administration"), MGangs.Language:GetTranslation("edit_groups"), {
	check = function()
		local perms = MGangs.Player:HasPermission("Group", "Edit")

		return perms
	end,
	menu = function(parent, curPnl)
		local btn = vgui.Create("DButton")
		btn:Dock(TOP)
		MGangs.Derma.Paint.Elements['button'](btn, {text = MGangs.Language:GetTranslation("edit_groups"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

		local function openGangGroups(parent)
			local groups = table.Copy(MGangs.Gang:GetGroups())
			local grpPerm = MGangs.Gang:GetPermissions("Group")

			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:DockMargin(10,0,0,0)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
			end

			--[[Header]]
			local hdr = vgui.Create("DPanel", pnl)
			hdr:Dock(TOP)
			hdr:DockMargin(0,0,0,5)
			MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("edit_groups"), rc_tl = true, rc_tr = true})

			--[[To Settings]]
			local stngsBtn = vgui.Create("DButton", hdr)
			stngsBtn:Dock(RIGHT)
			stngsBtn:SetWide(110)
			MGangs.Derma.Paint.Elements['button'](stngsBtn, {text = MGangs.Language:GetTranslation("back_to_settings"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
			stngsBtn.DoClick = function(slf)
				parent.active.pg = curPnl(parent)

				pnl:Remove()
			end

			--[[Settings Panel]]
			local groupsPnl = vgui.Create("DScrollPanel", pnl)
			groupsPnl:Dock(FILL)
			MGangs.Derma.Paint.Elements['scrollpanel'](groupsPnl)

			--[[New Group]]
			local function loadGroups(groupsPnl)
				if !(IsValid(groupsPnl)) then print("invalid") return end

				groupsPnl:Clear()

				for i=1,#groups do
					local group = groups[i]
					local grpTypeInf = MGangs.Gang:GetGroupTypeInfo(group.grouptype)
					local icon = (group.icon && Material(group.icon) or false)

					local grpPnl = vgui.Create("DPanel", groupsPnl)
					grpPnl:Dock(TOP)
					grpPnl:DockMargin(5,0,5,5)
					grpPnl:SetTall(175)
					grpPnl.Paint = function(s,w,h)
						draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,200), true, true, true, true)
					end

					--[[Group Info Panel]]
					local grpInfPnl = vgui.Create("DPanel", grpPnl)
					grpInfPnl:Dock(LEFT)
					grpInfPnl:DockMargin(5,5,5,5)
					grpInfPnl:DockPadding(0,25,0,0)
					grpInfPnl:SetWide(300)
					grpInfPnl.Paint = function(s,w,h)
						if (icon) then
							surface.SetDrawColor(255, 255, 255, 255)
							surface.SetMaterial(icon)
							surface.DrawTexturedRect(5, 7, 16, 16)
						end

						draw.SimpleText( (group.name or "NIL"), "MG_GangInfo_SM", 23, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					end

					-- Group Name
					local grpNameTB = vgui.Create("MG2_InfoTextEntry", grpInfPnl)
					grpNameTB:Dock(TOP)
					grpNameTB:DockMargin(0,5,0,0)
					grpNameTB:SetValue(group.name or "")
					grpNameTB:SetInfoText(MGangs.Language:GetTranslation("create_group"))
					grpNameTB:SetPlaceholderText(MGangs.Language:GetTranslation("enter_group_name"))
					grpNameTB:SetCharFilter(MGangs.Config.BannedNames, MGangs.Language:GetTranslation("name_not_allowed"))
					grpNameTB:SetMinMaxChars(3,15)
					grpNameTB.dtextentry.Think = function(s)
						group.name = (s.ValuesPass && s:GetValue() || false)
					end

					-- Group Priority
					local grpPriorityTB = vgui.Create("MG2_InfoTextEntry", grpInfPnl)
					grpPriorityTB:Dock(TOP)
					grpPriorityTB:DockMargin(0,5,0,0)
					grpPriorityTB:SetValue(group.priority or 0)
					grpPriorityTB:SetInfoText(MGangs.Language:GetTranslation("group_priority"))
					grpPriorityTB:SetPlaceholderText(MGangs.Language:GetTranslation("enter_group_priority"))
					grpPriorityTB:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
					grpPriorityTB:SetNumeric(true)
					grpPriorityTB.dtextentry.Think = function(s)
						group.priority = (s.ValuesPass && s:GetValue() || false)
					end

					-- Group Icon
					local grpIconCB = vgui.Create("MG2_InfoComboBox", grpInfPnl)
					grpIconCB:Dock(TOP)
					grpIconCB:DockMargin(0,5,0,0)
					grpIconCB:SetInfoText(MGangs.Language:GetTranslation("group_icon"))
					grpIconCB:SetValue(group.icon)
					grpIconCB:SetCBoxMaterial(group.icon)
					grpIconCB.OnSelect = function(s, index, data)
						group.icon = data
						icon = Material(data)

						grpIconCB:SetCBoxMaterial(data)
					end

					for _,awardicons in pairs(file.Find("materials/icon16/award_*.png","GAME")) do
						grpIconCB:AddChoice("icon16/" .. awardicons)
					end
					for _,usericons in pairs(file.Find("materials/icon16/user_*.png", "GAME")) do
						grpIconCB:AddChoice("icon16/" .. usericons)
					end

					-- Delete Group
					if (grpTypeInf && grpTypeInf.candelete) then
						dPerm = (grpPerm && table.HasValue(grpPerm, "Delete") || false)

						if (dPerm) then
							local grpDeleteBtn = vgui.Create("DButton", grpInfPnl)
							grpDeleteBtn:Dock(BOTTOM)
							MGangs.Derma.Paint.Elements['button'](grpDeleteBtn, {text = MGangs.Language:GetTranslation("delete"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

							grpDeleteBtn.DoClick = function(s)
								MGangs.Gang:DeleteGroup(group.id)

								grpPnl:Remove()
							end
						end
					end

					--[[Permissions Panel]]
					local permsPnl = vgui.Create("DScrollPanel", grpPnl)
					permsPnl:Dock(FILL)
					permsPnl:DockMargin(5,5,5,5)
					MGangs.Derma.Paint.Elements['scrollpanel'](permsPnl)

					local prmHdr = vgui.Create("DPanel", permsPnl)
					prmHdr:Dock(TOP)
					prmHdr:DockMargin(0,0,0,5)
					MGangs.Derma.Paint.Elements['header'](prmHdr, {text = MGangs.Language:GetTranslation("permissions"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

					for pCN,pTbl in pairs(MGangs.Gang.GroupPermissions) do
						group.perms[pCN] = (group.perms[pCN] or {})

						local groupPerms = group.perms[pCN]

						local prmCat = vgui.Create("DPanel", permsPnl)
						prmCat:Dock(TOP)
						prmCat:DockMargin(5,0,5,5)
						prmCat:SetTall(20)
						prmCat.Paint = function(s,w,h)
							draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

							draw.SimpleText( (pCN or "NIL"), "MG_GangInfo_XSM", 5, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						end

						for pID,pNM in pairs(pTbl) do
							local permCheck = vgui.Create("MG2_ButtonCheckbox", permsPnl)
							permCheck:Dock(TOP)
							permCheck:DockMargin(5,0,5,5)
							permCheck:SetCustText(pNM)
							permCheck:SetChecked(table.HasValue(groupPerms, pNM))
							permCheck.WasClicked = function(self)
								if (self:GetChecked()) then
									if (!table.HasValue(groupPerms, pNM)) then
										table.insert(groupPerms, pNM)
									end
								else
									local permKey = table.KeyFromValue(groupPerms, pNM)

									if (permKey) then
										table.remove(groupPerms, permKey)
									end
								end

								group.perms[pCN] = groupPerms
							end
						end
					end
				end
			end

			loadGroups(groupsPnl)

			--[[Create Group Button]]
			cPerm = (grpPerm && table.HasValue(grpPerm, "Create") || false)

			if (cPerm) then
				local nGrpBtn = vgui.Create("DButton", hdr)
				nGrpBtn:Dock(RIGHT)
				nGrpBtn:DockMargin(0,0,5,0)
				nGrpBtn:SetWide(110)
				MGangs.Derma.Paint.Elements['button'](nGrpBtn, {text = MGangs.Language:GetTranslation("create_group")})
				nGrpBtn.DoClick = function(slf)
					MGangs.Gang:CreateGroup()

					timer.Simple(1,
					function()
						loadGroups(groupsPnl)
					end)
				end
			end

			--[[Save Groups]]
			local saveBtn = vgui.Create("DButton", pnl)
			saveBtn:Dock(BOTTOM)
			saveBtn:DockMargin(5,5,5,5)
			MGangs.Derma.Paint.Elements['button'](saveBtn, {text = MGangs.Language:GetTranslation("save_groups"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})

			saveBtn.DoClick = function()
				for i=1,#groups do
					local group = groups[i]

					if (!group.name or !group.priority) then
						MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

						return false
					end
				end

				MGangs.Gang:UpdateGroups(groups)

				MGangs:Notification(MGangs.Language:GetTranslation("updated_gang_groups"))
			end

			return pnl
		end

		btn.DoClick = function()
			if (parent.active.pg) then parent.active.pg:Remove() end

			parent.active.pg = openGangGroups(parent)
		end

		return btn
	end,
})
