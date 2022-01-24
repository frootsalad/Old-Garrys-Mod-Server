--[[
MGANGS - UPGRADES CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

function MENUS:Upgrades(parent)
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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("upgrades"), rc_tl = true, rc_tr = true})

	--[[Upgrades]]
	local upgs_Pnl = vgui.Create("DScrollPanel", pnl)
	upgs_Pnl:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](upgs_Pnl)

	local canUpg = MGangs.Player:HasPermission("Upgrades", "Purchase")

	for k,v in pairs(MGangs.Gang:GetUpgrades()) do
		local upgInfo = (MG2_UPGRADES.Config.Upgrades[k])

		if (upgInfo) then
			local upg = vgui.Create("DPanel", upgs_Pnl)
			upg:Dock(TOP)
			upg:DockMargin(5,5,5,0)
			upg:SetTall(40)
			upg.Paint = function(self,w,h)
				v = MGangs.Gang:GetUpgrades()[k]

				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

				draw.SimpleText( MGangs.Language:GetTranslation("upgrade_current", (upgInfo.prefix or "") .. (isnumber(v) && MGangs.Util:FormatNumber(v) || v) .. (upgInfo.suffix or "")), "MG_GangInfo_XSM", 5, h*0.3, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				draw.SimpleText( MGangs.Language:GetTranslation("upgrade_next", (upgInfo.prefix or "") .. (isnumber(upgInfo.upg_increments) && isnumber(v) && MGangs.Util:FormatNumber(upgInfo.upg_increments + v) || upgInfo.upg_increments) .. (upgInfo.suffix or "")), "MG_GangInfo_XSM", 5, h*0.72, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				draw.SimpleText( upgInfo.fixedname, "MG_GangInfo_SM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			if (canUpg) then
				local upgBtn = vgui.Create("DButton", upg)
				upgBtn:Dock(RIGHT)
				upgBtn:SetWide(100)
				MGangs.Derma.Paint.Elements['button'](upgBtn, {text = MGangs.Language:GetTranslation("upgrade"), hover_text = (MGangs.Config.DollarSymbol .. (MGangs.Util:FormatNumber(upgInfo.upg_cost) or "0")), font = "MG_GangInfo_XSM", rc_tl = false, rc_bl = false, rc_tr = true, rc_br = true})
				upgBtn.DoClick = function(s)
					MGangs.Gang:PurchaseUpgrade(k)
				end
			end
		end
	end

	return pnl
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Upgrades = function(slf)
		slf.mnav_Upgrades = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Upgrades:Dock(TOP)
		slf.mnav_Upgrades:DockMargin(0, 0, 0, 5)
		slf.mnav_Upgrades:SetTall(35)
		slf.mnav_Upgrades.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Upgrades(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Upgrades, {text = MGangs.Language:GetTranslation("upgrades")})
	end
})
