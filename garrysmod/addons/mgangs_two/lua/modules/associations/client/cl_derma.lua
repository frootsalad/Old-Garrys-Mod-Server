--[[
MGANGS - ASSOCIATIONS CLIENTSIDE DERMA
Developed by Zephruz
]]

local MENUS = {}

function MENUS:Associations(parent)
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
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("associations"), rc_tl = true, rc_tr = true})

	self:LoadAssociations(pnl)
	self:LoadGangSearch(pnl)

	return pnl
end

--[[GANG ASSOCIATIONS PANEL]]
function MENUS:LoadAssociations(pnl)
	--[[Associations Panel]]
	local assPnl = vgui.Create("DPanel", pnl)
	assPnl:Dock(FILL)
	assPnl:DockMargin(5,5,5,5)
	assPnl:SetTall(170)
	assPnl.Paint = function(s,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
	end

	--[[Header]]
	local assHdr = vgui.Create("DPanel", assPnl)
	assHdr:Dock(TOP)
	assHdr:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['header'](assHdr, {text = MGangs.Language:GetTranslation("active_associations"), rc_tl = true, rc_tr = true})

	local assListPnl = vgui.Create("DScrollPanel", assPnl)
	assListPnl:Dock(FILL)
	MGangs.Derma.Paint.Elements['scrollpanel'](assListPnl, {})

	--[[Load Associations]]
	local assTbl = MGangs.Gang:GetAssociations()

	if (#assTbl > 0) then
		for k,v in pairs(MGangs.Gang:GetAssociations()) do
			v.gid1 = (tonumber(v.gid1 or 0))
			v.gid2 = (tonumber(v.gid2 or 0))

			local lpGID = LocalPlayer():GetGangID()
			local statInfo = MG2_ASSOCIATIONS:GetStatus(v.type)
			local gangInfo = MGangs.Gang:GetByID(v.gid1 != lpGID && v.gid1 || v.gid2)

			if (statInfo && gangInfo) then
				local gangPnl = vgui.Create("DButton", assListPnl)
				gangPnl:Dock(TOP)
				gangPnl:DockMargin(5,5,5,0)
				gangPnl:SetTall(40)
				MGangs.Derma.Paint.Elements['button'](gangPnl, {text = "", rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true,
				paint = function(s,w,h)
					local assUpd = MGangs.Gang:GetAssociations()[k]
					local gangInfo = MGangs.Gang:GetByID(gangInfo.id)
					local statInfo = MG2_ASSOCIATIONS:GetStatus(assUpd && assUpd.type or -1)
					local x, y = 45, 3

					if !(assUpd) then s:Remove() return false end

					-- Name
					draw.SimpleText( (gangInfo.name || "NIL"), "MG_GangInfo_SM", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

					-- Gang ID
					draw.SimpleText( "ID: " .. (gangInfo.id || "NIL"), "MG_GangInfo_XSM", x, h-y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

					-- Association info
					if (tonumber(gangInfo.id) != LocalPlayer():GetGangID()) then
						if (statInfo.icon) then -- Status Icon
							local iW, iH = 16, 16

							surface.SetDrawColor(255, 255, 255, 255)
							surface.SetMaterial(statInfo.icon)
							surface.DrawTexturedRect(w-(iW+5), h/2-(iH/2), iW, iH)
						end

						draw.SimpleText( (statInfo.name || "NIL"), "MG_GangInfo_SM", w-25, h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

						draw.SimpleText( (assUpd.atWar && "AT WAR" || ""), "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end})

				gangPnl.DoClick = function(s)
					local assPerms = MGangs.Gang:GetPermissions("Associations")
					local assOptions = DermaMenu()

					for i=1,#assPerms do
						local aPerms = assPerms[i]
						local apInfo = MGangs.Gang:GetPermissionInfo("Associations", aPerms)
						apInfo = (apInfo or {})

						if !(apInfo.menuOpts) then
							local opt = assOptions:AddOption(aPerms)

							opt.DoClick = function()
								if !(apInfo.use) then return false end

								apInfo.use(gangInfo)
							end
						else
							for k,v in pairs(apInfo.menuOpts) do
								local opts = v(gangInfo, statInfo)

								if (opts) then
									local optSub = assOptions:AddSubMenu(k)

									for i,d in pairs(opts) do
										local opt = optSub:AddOption(d.name or "NIL")

										opt.DoClick = function()
											if !(apInfo.use) then return false end

											apInfo.use(gangInfo, d.id)
										end
									end
								end
							end
						end
					end

					assOptions:Open()
				end

				local gangImg = vgui.Create("HTTPImage", gangPnl)
				gangImg:SetPos(2, 2)
				gangImg:SetSize(36, 36)
				gangImg:SetURL(gangInfo.icon_url or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")
			end
		end
	else
		local noAssPnl = vgui.Create("DPanel", assListPnl)
		noAssPnl:Dock(TOP)
		noAssPnl:DockMargin(5,5,5,0)
		noAssPnl:SetTall(30)
		noAssPnl.Paint = function(s,w,h)
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, true, true)

			draw.SimpleText( "No Associatons", "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
end

--[[GANG SEARCH PANEL]]
function MENUS:LoadGangSearch(pnl)
	--[[Gangs Panel]]
	local gangsPnl = vgui.Create("DPanel", pnl)
	gangsPnl:Dock(RIGHT)
	gangsPnl:DockMargin(5,5,5,5)
	gangsPnl.Paint = function(s,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
	end

	--[[Header]]
	local gangsHdr = vgui.Create("DPanel", gangsPnl)
	gangsHdr:Dock(TOP)
	gangsHdr:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['header'](gangsHdr, {text = MGangs.Language:GetTranslation("search_fora_gang"), rc_tl = true, rc_tr = true})

	local gangListPnl = vgui.Create("MG2_PagedScrollPanel", gangsPnl)
	gangListPnl:Dock(FILL)
	gangListPnl:SetMaxPageResults(6)
	gangListPnl.Paint = function(s,w,h) end

	function pnl:PerformLayout(w, h)
		gangsPnl:SetSize(w*.485, h)
	end

	--[[Load Gangs]]
	gangListPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_gangs"), placeholder = MGangs.Language:GetTranslation("search_gangs_criteria")})
	gangListPnl.PageItemSetup = function(s, page, gangInfo)
		if (gangInfo) then
			local hasAss, assData = MGangs.Gang:HasAssociation(gangInfo.id)
			local statInfo = MG2_ASSOCIATIONS:GetStatus(assData && assData.type || MG2_ASSOCIATIONS.DefaultStatus)

			local leader = {
				name = (gangInfo.leader_name or "NIL"),
				stid = (gangInfo.leader_steamid or "NIL"),
			}

			gangInfo.name = (gangInfo.name or "NIL")
			gangInfo.id = (gangInfo.id or "0")

			local gangPnl = vgui.Create("DButton")
			gangPnl:Dock(TOP)
			gangPnl:DockMargin(5,5,5,0)
			gangPnl:SetTall(40)
			MGangs.Derma.Paint.Elements['button'](gangPnl, {text = "", rc_tl = true, rc_bl = true, rc_tr = true, rc_br = true,
			paint = function(s,w,h)
				local statInfo = MG2_ASSOCIATIONS:GetStatus(assData && assData.type || MG2_ASSOCIATIONS.DefaultStatus)
				local x, y = 45, 3

				-- Name
				draw.SimpleText( (gangInfo.name or "NIL"), "MG_GangInfo_SM", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

				-- Gang ID
				draw.SimpleText( "ID: " .. (gangInfo.id or "NIL"), "MG_GangInfo_XSM", x, h-y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

				-- Association
				if (tonumber(gangInfo.id) != LocalPlayer():GetGangID()) then
					if (statInfo.icon) then
						local iW, iH = 16, 16

						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(statInfo.icon)
						surface.DrawTexturedRect(w-(iW+5), h/2-(iH/2), iW, iH)
					end
				else
					statInfo.name = MGangs.Language:GetTranslation("your_gang")
					w = w + 20	-- Simple fix
				end

				draw.SimpleText( (statInfo.name or "NIL"), "MG_GangInfo_SM", w-25, h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end})

			gangPnl.DoClick = function(s)
				local assPerms = MGangs.Gang:GetPermissions("Associations")
				local assOptions = DermaMenu()

				for i=1,#assPerms do
					local aPerms = assPerms[i]
					local apInfo = MGangs.Gang:GetPermissionInfo("Associations", aPerms)
					apInfo = (apInfo or {})

					if (apInfo.menuOpts) then
						for k,v in pairs(apInfo.menuOpts) do
							local opts = v(gangInfo, statInfo)

							if (opts) then
								local optSub = assOptions:AddSubMenu(k)

								for i,d in pairs(opts) do
									local opt = optSub:AddOption(d.name or "NIL")

									opt.DoClick = function()
										if !(apInfo.use) then return false end

										apInfo.use(gangInfo, d.id)
									end
								end
							end
						end
					end
				end

				assOptions:Open()
			end

			local gangImg = vgui.Create("HTTPImage", gangPnl)
			gangImg:SetPos(2, 2)
			gangImg:SetSize(36, 36)
			gangImg:SetURL(gangInfo.icon_url or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")

			return gangPnl
		end
	end

	gangListPnl.OnSearch = function(self, val)
		-- Request the data from the server
		netPoint:FromEndPoint("MG2.SearchGangs", "MG2.SearchGangs", {
			requestData = {
				["searchFor"] = val,
			},
			receiveResults = function(res)
				res = (res["searchFor"] or {})

				if (#res > 0) then
					self.TotalSearchResults = (#res || 0)
					self.SearchTable = MGangs.Util:SplitUpTable(res,self.MaxPageResults)
					self:LoadSearchResults(1)
				end
			end,
		})
	end
end

-- Register menu button
MGangs.Derma:RegisterMenuButton({
	Associations = function(slf)
		slf.mnav_Associations = vgui.Create("DButton", slf.menunavbuttons)
		slf.mnav_Associations:Dock(TOP)
		slf.mnav_Associations:DockMargin(0, 0, 0, 5)
		slf.mnav_Associations:SetTall(35)
		slf.mnav_Associations.DoClick = function(s)
			slf:SetCurrentMenu(s, function(parent)
				return MENUS:Associations(parent)
			end)
		end
		MGangs.Derma.Paint.Elements['navbutton'](slf.mnav_Associations, {text = MGangs.Language:GetTranslation("associations")})
	end
})

--[[Particles]]
hook.Add("Think", "MG2.Think.MODULE.ASSOCIATIONS",
function()
	local maxVisDist = 500
	local pTable = {
		[2] = "mg2_indicator_allies01",
		[3] = "mg2_indicator_enemy01",
	}

	local pos = LocalPlayer():GetPos()
	local plys = ents.FindInSphere(pos, maxVisDist)

	for i=1,#plys do
		local ply = plys[i]

		if (IsValid(ply) && ply:IsPlayer() && ply:Alive() && ply != LocalPlayer() && ply:GetObserverMode() != OBS_MODE_ROAMING) then
			local pGID = ply:GetGangID()
			local hasAss, assData = MGangs.Gang:HasAssociation(pGID)
			local pName = (ply._assParticle or false)

			if (pGID != 0) then
				if (hasAss && assData) then
					local particle = pTable[tonumber(assData.type)]

					if (particle) then
						if (particle != pName) then
							ply:StopAndDestroyParticles()
							ParticleEffectAttach(particle, PATTACH_ABSORIGIN_FOLLOW, ply, 0)

							ply._assParticle = particle
						end
					else
						ply:StopAndDestroyParticles()

						ply._assParticle = false
					end
				end
			end
		end
	end

	-- Remove particles that are far away
	for k,v in pairs(player.GetAll()) do
		if (v._assParticle && v:GetPos():Distance(LocalPlayer():GetPos()) > maxVisDist) then
			v:StopAndDestroyParticles()

			v._assParticle = false
		end
	end
end)
