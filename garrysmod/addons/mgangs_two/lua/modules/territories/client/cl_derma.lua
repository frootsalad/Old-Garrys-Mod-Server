--[[
MGANGS - TERRITORIES CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

--[[--------------
		Gang Menu
----------------]]
function MENUS:Territories(parent)
	local pnl = vgui.Create("DPanel", parent)
	pnl:Dock(FILL)
	pnl:DockMargin(10,0,0,0)
	pnl.Paint = function(s,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
	end

	--[[Header]]
	local hdr = vgui.Create("DPanel", pnl)
	hdr:Dock(TOP)
	hdr:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("territories"), rc_tl = true, rc_tr = true})

	--[[Territories Panel]]
	local terListPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
	terListPnl:Dock(FILL)
	terListPnl:SetMaxPageResults(6)
	terListPnl.Paint = function(s,w,h) end

	--[[Load Players]]
	terListPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_territories"), placeholder =  MGangs.Language:GetTranslation("search_territories_criteria")})
	terListPnl.PageItemSetup = function(s, page, terr)
		local tEnt = MG2_TERRITORIES:GetTerritoryEntByID(terr && terr._key or 0)

		if (!terr or !IsValid(tEnt)) then return false end

		local gang = MGangs.Gang:GetByID(tEnt:GetGangID())

		local terPnl = vgui.Create("DPanel")
		terPnl:Dock(TOP)
		terPnl:DockMargin(5,5,5,0)
		terPnl:SetTall(40)
		terPnl.Paint = function(s,w,h)
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

			local tName, tDesc = terr.name, terr.desc
			local tGetSize = (#tName > #tDesc && tName || tDesc)
			local tFont = (tGetSize == tName && "MG_GangInfo_SM" || "MG_GangInfo_XSM")

			draw.RoundedBoxEx(4, 0, 0, 10, h, terr.color, true, false, true, false)

			draw.SimpleText(terr.name, "MG_GangInfo_SM", 14, h*0.3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(terr.desc, "MG_GangInfo_XSM", 14, h*0.7, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			draw.SimpleText((gang && MGangs.Language:GetTranslation("t_controlled_by", gang.name) || MGangs.Language:GetTranslation("t_currently_uncontrolled")), "MG_GangInfo_SM", w-(gang && 45 || 5), h*0.33, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText((gang && "ID: " .. gang.id || MGangs.Language:GetTranslation("claim_territory_for_rewards")), "MG_GangInfo_XSM", w-(gang && 45 || 5), h*0.73, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		if (gang) then
			local gangImg = vgui.Create("HTTPImage", terPnl)
			gangImg:Dock(RIGHT)
			gangImg:DockMargin(2,2,2,2)
			gangImg:SetSize(36, 36)
			gangImg:SetURL(gang.icon_url or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")
		end

		return terPnl
	end
	terListPnl:SetPageTable(MG2_TERRITORIES._tCache)
	terListPnl:SetCurrentPage(1)

	return pnl
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Territories = function(slf)
		slf.mnav_Territories = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Territories:Dock(TOP)
		slf.mnav_Territories:DockMargin(0, 0, 0, 5)
		slf.mnav_Territories:SetTall(35)
		slf.mnav_Territories.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Territories(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Territories, {text = MGangs.Language:GetTranslation("territories")})
	end
})

--[[--------------
		Admin Menu
----------------]]
MGangs.Derma:RegisterAdminButton({
	Territories = function(self)
		self.mnav_Territories = vgui.Create("DButton", self.menuadminbtns)
		self.mnav_Territories:Dock(TOP)
		self.mnav_Territories:DockMargin(5, 5, 5, 5)
		self.mnav_Territories:SetTall(35)
		self.mnav_Territories.DoClick = function(s)
			self:SetCurrentMenu(s, function(parent)
				local pnl = vgui.Create("DPanel", parent)
				pnl:Dock(FILL)
				pnl:DockMargin(0,0,0,0)
				pnl.Paint = function(self,w,h)
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
				end

				--[[Header]]
				local hdr = vgui.Create("DPanel", pnl)
				hdr:Dock(TOP)
				hdr:DockMargin(0,0,0,0)
				MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("edit_territories"), rc_tl = true, rc_tr = true})

				local backBtn = vgui.Create("DButton", hdr)
				backBtn:Dock(RIGHT)
				backBtn:SetWide(100)
				MGangs.Derma.Paint.Elements['button'](backBtn, {text = MGangs.Language:GetTranslation("back_to_admin"), rc_tr = true})
				backBtn.DoClick = function(slf)
					self:CreateAdminButtons()

					pnl:Remove()
				end

				--[[Territories Panel]]
				local terListPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
				terListPnl:Dock(FILL)
				terListPnl:SetMaxPageResults(6)
				terListPnl.Paint = function(s,w,h) end

				--[[Load Territories]]
				terListPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_territories"), placeholder = MGangs.Language:GetTranslation("search_territories_criteria")})
				terListPnl.PageItemSetup = function(s, page, terr)
					local terPnl = vgui.Create("DPanel")
					terPnl:Dock(TOP)
					terPnl:DockMargin(5,5,5,0)
					terPnl:SetTall(40)
					terPnl.Paint = function(s,w,h)
						draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

						local tName, tDesc = terr.name, terr.desc
						local tGetSize = (#tName > #tDesc && tName || tDesc)
						local tFont = (tGetSize == tName && "MG_GangInfo_SM" || "MG_GangInfo_XSM")

						draw.RoundedBoxEx(4, 0, 0, 10, h, terr.color, true, false, true, false)

						draw.SimpleText(terr.name, "MG_GangInfo_SM", 14, h*0.3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(terr.desc, "MG_GangInfo_XSM", 14, h*0.7, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

						if (s:IsHovered()) then
							local flag = terr.flag
							local flagPos = (flag && flag.pos)
							local x, y, z = flagPos.x, flagPos.y, flagPos.z

							render.RenderView({
								origin = Vector(x, y, z) + Vector(-200, -200, 200),
								angles = Angle(12, 45, 0),
								x = 15,
								y = 15,
								w = ScrW()/3,
								h = ScrH()/3
							})
						end
					end

					--[[Delete Territory]]
					local delTerBtn = vgui.Create("DButton", terPnl)
					delTerBtn:Dock(RIGHT)
					delTerBtn:SetWide(65)
					MGangs.Derma.Paint.Elements['button'](delTerBtn, {text = MGangs.Language:GetTranslation("delete"), rc_tr = true, rc_br = true})
					delTerBtn.DoClick = function(s)
						local delPrompt = vgui.Create("MG2_PromptBox")
						delPrompt:SetQuestionText(MGangs.Language:GetTranslation("you_want_to_do_this"))
						delPrompt:SetButtonTexts(MGangs.Language:GetTranslation("delete"), MGangs.Language:GetTranslation("cancel"))
						delPrompt:SetTall(100)
						delPrompt:Setup()
						delPrompt:SetOptions(
						function()
								if (IsValid(s) && IsValid(s:GetParent())) then
									s:GetParent():Remove()
									MG2_TERRITORIES:DeleteTerritory(terr._key)

									timer.Simple(1,
									function()
										if !(IsValid(terListPnl)) then return false end

										terListPnl:SetPageTable(MG2_TERRITORIES._tCache or {})
										terListPnl:SetCurrentPage(1)
									end)

									return true
								end

								return false
						end)
					end

					--[[Edit Territory]]
					local editTerBtn = vgui.Create("DButton", terPnl)
					editTerBtn:Dock(RIGHT)
					editTerBtn:DockMargin(0,0,5,0)
					editTerBtn:SetWide(50)
					MGangs.Derma.Paint.Elements['button'](editTerBtn, {text = "Edit"})
					editTerBtn.DoClick = function(s)
						MG2_TERRITORIES:MenuEditTerritory(terr, "Edit Territory",
						function(data)
							MG2_TERRITORIES:UpdateTerritory(terr._key, data)

							timer.Simple(1,
							function()
								if !(IsValid(terListPnl)) then return false end

								terListPnl:SetPageTable(MG2_TERRITORIES._tCache)
								terListPnl:SetCurrentPage(1)
							end)
						end)
					end

					return terPnl
				end
				terListPnl:SetPageTable(MG2_TERRITORIES._tCache)
				terListPnl:SetCurrentPage(1)

				return pnl
			end)
		end
		MGangs.Derma.Paint.Elements['button'](self.mnav_Territories, {text = MGangs.Language:GetTranslation("edit_territories"), rc_tl = true, rc_tr = true, rc_bl = true, rc_br = true})
	end
})

--[[--------------
		Global Menus
----------------]]
local ctFrame = (ctFrame or nil)

function MG2_TERRITORIES:MenuEditTerritory(tData, fTitle, sFunc)
	if !(LocalPlayer():IsAdmin()) then return false end
	if (IsValid(ctFrame)) then ctFrame:Remove() end

	local valPass
	local nameTxt, nameDesc = (tData.name or ""), (tData.desc or "")
	local flagPos, flagMdl = (tData.flag && tData.flag.pos || Vector(0,0,0)), (tData.flag && tData.flag.mdl || "models/zerochain/mgangs2/mgang_flagpost.mdl")

	ctFrame = vgui.Create("DFrame")
	ctFrame:SetSize(500, 180)
	ctFrame:Center()
	ctFrame:MakePopup()
	ctFrame:ShowCloseButton(false)
	MGangs.Derma.Paint.Elements['frame'](ctFrame, (fTitle or MGangs.Language:GetTranslation("edit_territory")))

	local closeBtn = vgui.Create("DButton", ctFrame)
	closeBtn:SetSize(20,24)
	closeBtn:SetPos(ctFrame:GetWide() - 20,0)
	closeBtn.DoClick = function(self)
		self:GetParent():Remove()
	end
	MGangs.Derma.Paint.Elements['closebutton'](closeBtn, "X")

	--[[Territory name]]
	local tNameEnt = vgui.Create("MG2_InfoTextEntry", ctFrame)
	tNameEnt:Dock(TOP)
	tNameEnt:DockMargin(0,0,0,0)
	tNameEnt:SetValue(nameTxt)
	tNameEnt:SetInfoText(MGangs.Language:GetTranslation("name"))
	tNameEnt:SetPlaceholderText(MGangs.Language:GetTranslation("edit_territory_name"))
	tNameEnt:SetCharFilter({"[%p]"}, MGangs.Language:GetTranslation("name_not_allowed"))
	tNameEnt:SetMinMaxChars(3,15)
	tNameEnt.dtextentry.Think = function(s)
		valPass = (s.ValuesPass)
	end

	--[[Territory desc]]
	local tDescEnt = vgui.Create("MG2_InfoTextEntry", ctFrame)
	tDescEnt:Dock(TOP)
	tDescEnt:DockMargin(0,5,0,0)
	tDescEnt:SetValue(nameDesc)
	tDescEnt:SetInfoText(MGangs.Language:GetTranslation("description"))
	tDescEnt:SetPlaceholderText(MGangs.Language:GetTranslation("edit_territory_desc"))
	tDescEnt:SetMinMaxChars(5,60)
	tDescEnt.dtextentry.Think = function(s)
		valPass = (s.ValuesPass)
	end

	--[[Flag model]]
	local tFlagCBox = vgui.Create("MG2_InfoComboBox", ctFrame)
	tFlagCBox:Dock(TOP)
	tFlagCBox:DockMargin(0,5,0,0)
	tFlagCBox:SetValue(flagMdl)
	tFlagCBox:SetInfoText(MGangs.Language:GetTranslation("terr_flagmodel"))

	for _,flagMdls in pairs(self.config.flagModels) do
		tFlagCBox:AddChoice(flagMdls)
	end

	--[[Select Color]]
	local colTbl = {
		{r = (tData.color && tData.color.r or 0)},
		{g = (tData.color && tData.color.g or 255)},
		{b = (tData.color && tData.color.b or 0)},
		{a = (tData.color && tData.color.g or 255)},
	}
	local colGet = Color(colTbl[1].r, colTbl[2].g, colTbl[3].b, colTbl[4].a)

	local tColPnl = vgui.Create("DPanel", ctFrame)
	tColPnl:Dock(TOP)
	tColPnl:DockMargin(5,5,5,0)
	tColPnl.Paint = function(s,w,h) end

	local DColorButton = vgui.Create("DColorButton", tColPnl)
	DColorButton:Dock(RIGHT)
	DColorButton:DockMargin(0,0,5,0)
	DColorButton:SetWide(75)
	DColorButton:SetColor(colGet)

	local DColorCube = vgui.Create("DColorCube", tColPnl)
	DColorCube:Dock(RIGHT)
	DColorCube:DockMargin(0,0,5,0)
	DColorCube:SetWide(75)
	DColorCube:SetBaseRGB(colGet)
	DColorCube.OnUserChanged = function(s, col)
		DColorButton:SetColor(col)
	end

	for i=1,#colTbl do
		local col = colTbl[i]

		for k,v in pairs(col) do
			local colEntry = vgui.Create("MG2_InfoTextEntry", tColPnl)
			colEntry:Dock(LEFT)
			colEntry:DockMargin(0,0,5,0)
			colEntry:SetWide(75)
			colEntry:SetValue(v)
			colEntry:SetInfoText(k:upper())
			colEntry:SetPlaceholderText(v)
			colEntry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
			colEntry:SetNumeric(true)
			colEntry.dtextentry.Think = function(s)
				valPass = (s.ValuesPass)
			end
			colEntry.dtextentry.OnValueChange = function(s)
				colTbl[i][k] = (#s:GetValue() > 0 && s:GetValue() or 0)
				colGet = Color(colTbl[1].r, colTbl[2].g, colTbl[3].b, colTbl[4].a)

				DColorButton:SetColor(colGet)
				DColorCube:SetColor(colGet)
			end
		end
	end

	--[[Create Button]]
	local createBtn = vgui.Create("DButton", ctFrame)
	createBtn:Dock(BOTTOM)
	createBtn:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['button'](createBtn, {text = MGangs.Language:GetTranslation("submit"), rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true})
	createBtn.DoClick = function(self)
		local data = {
			id = (tData.id or nil),
			name = (tNameEnt:GetValue() or "INVALID"),
			desc = (tDescEnt:GetValue() or "INVALID"),
			color = (colGet or Color(0,255,0)),
			boxPos = (tData.boxPos or {Vector(0,0,0), Vector(0,0,0)}),
			flag = {
				pos = (tData.flag.pos or Vector(0,0,0)),
				mdl = (tFlagCBox:GetValue() or "models/zerochain/mgangs2/mgang_flagpost.mdl"),
			},
		}

		if !(sFunc) then
			MG2_TERRITORIES:CreateTerritory(data)
		else
			sFunc(data)
		end

		self:GetParent():Remove()
	end

	return ctFrame
end

hook.Remove("HUDPaint", "MG2.HUDPaint.MODULE.TERRITORIES")
hook.Add("HUDPaint", "MG2.HUDPaint.MODULE.TERRITORIES",
function()
	local terrs = MG2_TERRITORIES._tCache

	if (terrs) then
		for i=1,#terrs do
			local ter = table.Copy(terrs[i])

			if (ter) then
				local col = ter.color
				local bPos1, bPos2 = ter.boxPos[1], ter.boxPos[2]
				bPos1 = Vector(bPos1[1], bPos1[2], bPos1[3])
				bPos2 = Vector(bPos2[1], bPos2[2], bPos2[3])
				bPos2 = LocalToWorld(bPos2, Angle(0,0,0), bPos1, Angle(0,0,0) )

				OrderVectors(bPos1, bPos2)

				local inBounds = LocalPlayer():EyePos():WithinAABox(bPos1, bPos2)

				if (inBounds) then
					local textTbl = {
						{
							check = true,
							topTxt = MGangs.Language:GetTranslation("terr_youarein"),
							text = "'" .. ter.name .. "'",
							font = "MG_GangInfo_SM",
						},
						{
							check = #ter.desc > 0,
							text = ter.desc,
							font = "MG_GangInfo_XSM",
						},
					}

					-- Current Territory
					local curX = 0
					local lY = 10

					for i=1,#textTbl do
						local txtInfo = textTbl[i]

						if !(txtInfo.check) then return end

						local txtStr, txtFont = txtInfo.text, txtInfo.font
						surface.SetFont(txtFont)
						local tsW, tsH = surface.GetTextSize(txtStr)
						tsW = tsW + 10

						local lW, lH = math.max(140, tsW), tsH
						local lX, lY = ScrW()/2 - lW/2, (lY + curX + (i != 1 && (i*5) || 0))

						if (txtInfo.topTxt) then lH = lH + 13 end

						draw.RoundedBoxEx(4,lX-2,lY-2,lW+4,lH+4,Color((col.r or 255),(col.g or 0),(col.b or 0),255*math.sin(CurTime())),true,true,true,true)
						draw.RoundedBoxEx(4,lX,lY,lW,lH,Color(45,45,45,255),true,true,true,true)

						if (txtInfo.topTxt) then
							draw.SimpleText(txtInfo.topTxt, "MG_GangInfo_XSM", ScrW()/2, lY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
						end

						draw.SimpleText(txtStr, txtFont, ScrW()/2, (lH + lY), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

						curX = curX + lH
					end
				end
			end
		end
	end
end)
