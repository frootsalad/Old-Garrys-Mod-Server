--[[
MGANGS - ACHIEVEMENTS CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

function MENUS:Achievements(parent)
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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("achievements"), rc_tl = true, rc_tr = true})

	--[[Achievements]]
	local function getAchCategorized()
		local achCats = {}

		for k,v in pairs(MGangs.Gang:GetAchievements()) do
			local achInfo = (MG2_ACHIEVEMENTS.Achievements[k])

			if (achInfo) then
				local achCat = (achInfo.achcat or "Other")
				if !(achCats[achCat]) then achCats[achCat] = {} end

				achCats[achCat][k] = v
			end
		end

		return achCats
	end

	local achCats = getAchCategorized()

	local achs_Pnl = vgui.Create("DScrollPanel", pnl)
	achs_Pnl:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](achs_Pnl)

	for k,achs in pairs(achCats) do
		local catHdr = vgui.Create("DPanel", achs_Pnl)
		catHdr:Dock(TOP)
		catHdr:DockMargin(5,5,5,0)
		MGangs.Derma.Paint.Elements['header'](catHdr, {text = k, rc_tl = true, rc_tr = true, rc_bl = true, rc_br = true})

		for i,d in pairs(achs) do
			local achInfo = (MG2_ACHIEVEMENTS.Achievements[i])
			local inCat = (achInfo && achInfo.achcat == k)

			if (achInfo && inCat) then
				local status = (d == achInfo.reqAmt)
				local statusIcon = Material("icon16/award_star_gold_3.png")
				local rewards = (achInfo.rewards or {exp = 10, balance = 10})

				local ach = vgui.Create("DPanel", achs_Pnl)
				ach:Dock(TOP)
				ach:DockMargin(5,5,5,0)
				ach:SetTall(30)
				ach.Paint = function(self,w,h)
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

					-- Status
					surface.SetDrawColor(0,0,0,125)
					if (status) then
						surface.SetDrawColor(255, 255, 255, 255)
					end
					surface.SetMaterial(statusIcon)
					surface.DrawTexturedRect(5, h/2 - 7, 16, 16)

					-- Name
					draw.SimpleText( i, "MG_ProgBar_Text", 25, h/2, MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].progressbar.text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end

				local achProg = vgui.Create("DProgress", ach)
				achProg:Dock(RIGHT)
				achProg:DockMargin(5,5,5,5)
				achProg:SetWide(200)
				achProg:SetFraction( (d or 1) / (achInfo.reqAmt or 100) )
				MGangs.Derma.Paint.Elements['progressbar'](achProg,
				function(self,w,h)
					--[[draw.SimpleText(
					MGangs.Util:FormatNumber(rewards.exp) .. " EXP | $" ..
					MGangs.Util:FormatNumber(rewards.balance), "MG_ProgBar_Text", 10, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )]]

					draw.SimpleText(
					MGangs.Util:FormatNumber(getAchCategorized()[k][i] or 0) .. "/" ..
					MGangs.Util:FormatNumber(achInfo.reqAmt or 100), "MG_ProgBar_Text", w - 10, h/2, MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].progressbar.text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end)

			end
		end
	end

	return pnl
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Achievements = function(slf)
		slf.mnav_Achievements = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Achievements:Dock(TOP)
		slf.mnav_Achievements:DockMargin(0, 0, 0, 5)
		slf.mnav_Achievements:SetTall(35)
		slf.mnav_Achievements.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Achievements(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Achievements, {text = MGangs.Language:GetTranslation("achievements")})
	end
})
