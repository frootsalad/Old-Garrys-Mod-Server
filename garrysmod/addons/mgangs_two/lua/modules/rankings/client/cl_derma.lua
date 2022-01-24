--[[
MGANGS - RANKINGS CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

function MENUS:Rankings(parent)
	--[[Panel]]
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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("rankings"), rc_tl = true, rc_tr = true})

	-- Refresh ranks
	local rfrshRanks = vgui.Create("DButton", hdr)
	rfrshRanks:Dock(RIGHT)
	rfrshRanks:SetWide(125)
	MGangs.Derma.Paint.Elements['button'](rfrshRanks, {text = MGangs.Language:GetTranslation("refresh_ranks"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
	rfrshRanks.DoClick = function(slf)
		MGangs.Gang:RequestRanks()
	end

	--[[Ranks Panel]]
	local rnkSPnl = vgui.Create("DScrollPanel", pnl)
	rnkSPnl:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](rnkSPnl)

	for k,v in pairs(MGangs.Gang:GetAllRanks()) do
		local rType = MG2_RANKINGS:GetRankType(k)
		local data = v

		if (rType) then
			if (rType.pnl) then
				rType.pnl(rnkSPnl, rType, data)
			else
				local font = "MG_GangInfo_SM"
				local rTName = (rType.name || "NO NAME")
				local gIconURL = (data.icon_url || false)
				local gName = (data.name || "NO NAME")
				local dData = (data.data || "NIL")

				surface.SetFont(font)

				local gNameX = (gIconURL && 42 || 4)
				local gNameW, gNameH = (surface.GetTextSize(gName))
				local rTNameW, rTNameH = (surface.GetTextSize(gName))
				local dDataW, rTNameH = (surface.GetTextSize(gName))

				gNameW = (gIconURL && gNameW + 50 || 10)
				dDataW = (dDataW + 10)

				local rPnl = vgui.Create("DPanel", rnkSPnl)
				rPnl:Dock(TOP)
				rPnl:DockMargin(5,5,5,0)
				rPnl:SetTall(40)
				rPnl.Paint = function(s,w,h)
					local gRef = ((data.upd_time || 0) + MG2_RANKINGS.cacheExpireTime - CurTime())

					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

					-- Gang Name
					-- draw.RoundedBoxEx(4, 0, 0, gNameW, h, Color(45,45,45,255), true, false, true, false)
					draw.SimpleText(gName, font, gNameX, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					-- Rank Name/Type
					draw.SimpleText(rTName, font, w/2, h*.3, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText((gRef > 0 && MGangs.Language:GetTranslation("ranks_refreshes_in", string.FormattedTime(gRef, "%02i:%02i") || MGangs.Language:GetTranslation("refreshable"))), "MG_GangInfo_XSM", w/2, h*.7, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

					-- Rank Data
					draw.RoundedBoxEx(4, 0, w - dDataW, dDataW, h, Color(45,45,45,255), false, true, false, true)
					draw.SimpleText(dData, font, w - 5, h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end

				if (gIconURL) then
					local gIcon = vgui.Create("HTTPImage", rPnl)
					gIcon:SetSize(32, 32)
					gIcon:SetPos(4, 4)
					gIcon:SetURL(gIconURL)
				end
			end
		end
	end

	return pnl
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Rankings = function(slf)
		slf.mnav_Rankings = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Rankings:Dock(TOP)
		slf.mnav_Rankings:DockMargin(0, 0, 0, 5)
		slf.mnav_Rankings:SetTall(35)
		slf.mnav_Rankings.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Rankings(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Rankings, {text = MGangs.Language:GetTranslation("rankings")})
	end,
})
