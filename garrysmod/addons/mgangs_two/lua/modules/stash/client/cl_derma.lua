--[[
MGANGS - STASH CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

local function createItemPanel(page, itemInfo, iType)
	local canDeposit = MGangs.Player:HasPermission("Stash", "Deposit Items")
	local canWithdraw = MGangs.Player:HasPermission("Stash", "Withdraw Items")
	local itemData = (scripted_ents.GetStored(itemInfo.class) or weapons.GetStored(itemInfo.class))

	local itemTypes = {
		["deposit"] = {
			button = function(parent, invType, itemInfo)
				if !(canDeposit) then return false end

				local depositItem = vgui.Create("DButton", parent)
				depositItem:Dock(RIGHT)
				depositItem:SetWide(100)
				depositItem.DoClick = function(slf)
					MGangs.Gang:DepositItem(invType, itemInfo)

					itemInfo.amt = itemInfo.amt - 1

					if (itemInfo.amt <= 0) then
						slf:GetParent():Remove()
					end
				end
				MGangs.Derma.Paint.Elements['button'](depositItem, {text = MGangs.Language:GetTranslation("deposit"), rc_tr = true, rc_br = true})
			end,
		},
		["withdraw"] = {
			button = function(parent, invType, itemInfo)
				if !(canWithdraw) then return false end

				local withdrawItem = vgui.Create("DButton", parent)
				withdrawItem:Dock(RIGHT)
				withdrawItem:SetWide(100)
				withdrawItem.DoClick = function(slf)
					local depositTypes = MG2_STASH:GetDepositTypes()

					local si = DermaMenu()

					for k,v in pairs(depositTypes) do
						local menuInfo = v.menu

						if (v.check && v.check()) then
							local opt = si:AddOption(MGangs.Language:GetTranslation("to") .. " " .. v.name)
							if (menuInfo.icon) then
								opt:SetIcon(menuInfo.icon)
							end

							local subAmt = opt:AddSubMenu()

							for i=1,math.min(10, (itemInfo.amt or itemInfo.amount or 1)) do
								local amt = subAmt:AddOption(i)

								amt.DoClick = function()
									MGangs.Gang:WithdrawItem(k, itemInfo, (i or 1))

									itemInfo.amt = itemInfo.amt - i

									if (itemInfo.amt <= 0) then
										slf:GetParent():Remove()
									end
								end
							end
						end
					end

					si:Open()
				end
				MGangs.Derma.Paint.Elements['button'](withdrawItem, {text = MGangs.Language:GetTranslation("withdraw"), rc_tr = true, rc_br = true})
			end,
		},
	}

	if !(itemData) then return false end

	itemInfo.name = (itemData.PrintName or "Unknown Name")
	itemInfo.amt = tonumber(itemInfo.amt or itemInfo.amount or 1)

	local itemPnl = vgui.Create("DPanel")
	itemPnl:Dock(TOP)
	itemPnl:DockMargin(5,5,5,0)
	itemPnl:SetTall(50)
	itemPnl.Paint = function(s,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

		draw.SimpleText( itemInfo.name .. (itemInfo.amt && itemInfo.amt > 1 && " (" .. itemInfo.amt .. ")" || ""), "MG_Button_Text", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) -- Title
	end

	-- Model
	local itemModel = vgui.Create("DModelPanel", itemPnl)
	itemModel:Dock(LEFT)
	itemModel:SetWide(100)
	itemModel:SetModel(itemInfo.model or "")
	function itemModel:LayoutEntity(ent) return end
	itemModel.Paint = function(self, w, h)
		if !(IsValid(self.Entity)) then return end

		draw.RoundedBoxEx(4, 0, 0, w, h, Color(50,50,50,255), true, false, true, false)

		local x, y = self:LocalToScreen( 0, 0 )

		self:LayoutEntity( self.Entity )

		local ang = self.aLookAngle
		if !(ang) then
			ang = ( self.vLookatPos - self.vCamPos ):Angle()
		end

		cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( self.Entity:GetPos() )
			render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
			render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
			render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )

			for i = 0, 6 do
				local col = self.DirectionalLight[ i ]
				if (col) then
					render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
				end
			end

			self:DrawModel()

			render.SuppressEngineLighting( false )
		cam.End3D()

		self.LastPaint = RealTime()
	end

	for _, mpos in pairs(MG2_STASH.ModelTypes) do
		for _, type in pairs(mpos.types) do
			if (itemInfo.class && itemInfo.class:find(type)) then
				itemModel:SetCamPos( mpos.values.pos )
				itemModel:SetLookAt( mpos.values.lookat )
				itemModel:SetFOV( mpos.values.fov )
			end
		end
	end

	local bData = itemTypes[iType]

	if (bData.button) then
		bData.button(itemPnl, (itemInfo.invtype or "NIL"), itemInfo)
	end

	return itemPnl
end

-- Deposit Menu
function MENUS:Deposit(parent, items, invType)
	local invTypeData = MG2_STASH.DepositTypes[invType]

	if !(invTypeData) then return false end

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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("deposit_item") .. " " .. ("(" .. invTypeData.name .. ")" or ""), rc_tl = true, rc_tr = true})

	local toStashButton = vgui.Create("DButton", hdr)
	toStashButton:Dock(RIGHT)
	toStashButton:SetWide(100)
	MGangs.Derma.Paint.Elements['button'](toStashButton, {text = MGangs.Language:GetTranslation("back_to_stash"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
	toStashButton.DoClick = function(slf)
		parent.active.pg = MENUS:Stash(parent)

		pnl:Remove()
	end

	--[[Deposit Items]]
	local itemList_Pnl = vgui.Create("MG2_PagedScrollPanel", pnl)
	itemList_Pnl:Dock(FILL)
	itemList_Pnl:SetMaxPageResults(6)
	itemList_Pnl.Paint = function(s,w,h) end

	--[[Load Items]]
	itemList_Pnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_items"), placeholder = MGangs.Language:GetTranslation("search_items_criteria")})
	itemList_Pnl.PageItemSetup = function(s, page, itemInfo)
		itemInfo.invtype = invType

		local itemPnl = createItemPanel(page, itemInfo, "deposit")

		return itemPnl
	end
	itemList_Pnl:SetPageTable(items or {})
	itemList_Pnl:SetCurrentPage(1)

	return pnl
end

-- Menu
function MENUS:Stash(parent)
	local gangStashItems = MGangs.Gang:GetStashItems()
	local canDeposit = MGangs.Player:HasPermission("Stash", "Deposit Items")
	local canWithdraw = MGangs.Player:HasPermission("Stash", "Withdraw Items")

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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("stash"), rc_tl = true, rc_tr = true})

	--[[Deposit Item]]
	if (canDeposit) then
		local depositItem = vgui.Create("DButton", hdr)
		depositItem:Dock(RIGHT)
		depositItem:SetWide(100)
		MGangs.Derma.Paint.Elements['button'](depositItem, {text = MGangs.Language:GetTranslation("deposit_item"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})

		depositItem.DoClick = function(slf)
			local depositTypes = MG2_STASH:GetDepositTypes()

			local si = DermaMenu()

			for k,v in pairs(depositTypes) do
				local menuInfo = v.menu

				if (v.check && v.check()) then
					local opt = si:AddOption(MGangs.Language:GetTranslation("from") .. " " .. v.name)
					if (menuInfo.icon) then
						opt:SetIcon(menuInfo.icon)
					end
					opt.DoClick = function()
						parent.active.pg = MENUS:Deposit(parent, menuInfo.items(), k)

						pnl:Remove()
					end
				end
			end

			si:Open()
		end
	end

	--[[Items]]
	local itemList_Pnl = vgui.Create("MG2_PagedScrollPanel", pnl)
	itemList_Pnl:Dock(FILL)
	itemList_Pnl:SetMaxPageResults(6)
	itemList_Pnl.Paint = function(s,w,h) end

	--[[Load Items]]
	itemList_Pnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_items"), placeholder = MGangs.Language:GetTranslation("search_items_criteria")})
	itemList_Pnl.PageItemSetup = function(s, page, itemInfo)
		local itemPnl = createItemPanel(page, itemInfo, "withdraw")

		return itemPnl
	end
	itemList_Pnl:SetPageTable(gangStashItems)
	itemList_Pnl:SetCurrentPage(1)

	return pnl
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Stash = function(slf)
		slf.mnav_Stash = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Stash:Dock(TOP)
		slf.mnav_Stash:DockMargin(0, 0, 0, 5)
		slf.mnav_Stash:SetTall(35)
		slf.mnav_Stash.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Stash(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Stash, {text = MGangs.Language:GetTranslation("stash")})
	end,
})
