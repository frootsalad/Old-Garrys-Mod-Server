--[[
MGANGS - CLIENTSIDE DERMA LOAD
Developed by Zephruz
]]

MGangs.Derma = (MGangs.Derma or {})
MGangs.Derma.GangInfo = (MGangs.Derma.GangInfo or {})
MGangs.Derma.Menus = (MGangs.Derma.Menus or {})
MGangs.Derma.MenuButtons = (MGangs.Derma.MenuButtons or {})
MGangs.Derma.AdminButtons = (MGangs.Derma.AdminButtons or {})

function MGangs.Derma:RegisterMenu(name, tbl)
	local indx = (istable(name) && name[1] or name)

	MGangs.Derma.Menus[indx] = tbl
	MGangs.Derma.Menus[indx].chatCmd = indx

	if (name) then
		if (istable(name)) then
			for i=1,#name do
				local cmd = name[i]

				if (cmd) then
					concommand.Add(cmd, function()
						self.Menus[name[1]]:Init()	-- Use the first key
					end)
				end
			end
		else
			concommand.Add(name, function()
				self.Menus[name]:Init()
			end)
		end
	end
end

hook.Add("OnPlayerChat", "MG2.Gang.ChatCommands",
function(ply, text, teamChat, isDead)
	if (ply == LocalPlayer()) then
		for mid,mdat in pairs(MGangs.Derma.Menus) do
			local cmd = mid

			if (mdat.chatCmds) then
				if (istable(mdat.chatCmds)) then
					for i=1,#mdat.chatCmds do
						local mCmd = mdat.chatCmds[i]

						if (text == "!" .. mCmd) then
							cmd = mCmd

							break
						end
					end
				else
					cmd = (mdat.chatCmds or cmd)
				end
			end

			if (text == "!" .. cmd) then
				RunConsoleCommand(mid)

				return
			end
		end
	end
end)

function MGangs.Derma:RegisterMenuButton(data) -- Registers a menu button for access
	table.Merge(self.MenuButtons, data)
end

function MGangs.Derma:RegisterAdminButton(data) -- Registers an admin button for access
	table.Merge(self.AdminButtons, data)
end

function MGangs.Derma:RegisterGangInfo(catName, infoTbl)
	local hdrTbl = {val = catName, header = true}

	-- Overwrite old info
	for i=1,#self.GangInfo do
		if (self.GangInfo[i].val == catName) then
			for j=1,#infoTbl do
				self.GangInfo[i + j] = infoTbl[j]
			end

			return false
		end
	end

	-- Create new info
	table.insert(self.GangInfo, hdrTbl)

	for i=1,#infoTbl do
		table.insert(self.GangInfo, infoTbl[i])
	end
end


-- Default Gang Info
MGangs.Derma:RegisterGangInfo("General Info", {
	{name = "Name", val = function(gd) return (gd.name or "NIL") end, header = false},
	{name = "Leader", val = function(gd) return (gd.leader.name or "NIL") .. " (" .. (gd.leader.steamid or "NIL") .. ")" end, header = false},
	{name = "Members", val = function(gd) return (table.Count(gd.members) or 0) end, header = false},
})

MGangs.Derma:RegisterGangInfo("Your Info", {
	{name = "Your Group", val = function(gd) return (MGangs.Gang:GroupInfo(gd.yourgroup).name or "NIL") end, header = false},
})

-- Derma Includes
include('cl_derma_paint.lua')
include('cl_derma_reg.lua')
include('cl_menu_admin.lua')
include('cl_menu_invites.lua')
include('cl_menu_gang.lua')
include('cl_menu_gangcreation.lua')

--[[
	VIEW HUD
]]
hook.Add("HUDPaint", "MG2.HUDPaint.PlayerInfo",
function()
	local tr = LocalPlayer():GetEyeTrace()
	local ply = tr.Entity

	if (!IsValid(ply) or !ply:IsPlayer()) then return end
	if (ply:GetGangID() <= 0) then return end
	if (ply:GetPos():Distance(LocalPlayer():GetPos()) > 350) then return end

	local gangData = MGangs.Gang:GetByID(ply:GetGangID())

	if !(gangData) then return end

	local w, h = 250, 75
	local x, y = ScrW()/2 - w/2, ScrH() - (h+20)

	draw.RoundedBoxEx(6, x, y, w, h, Color(45,45,45,255), true, true, true, true)

	draw.SimpleText(ply:Nick() .. "'s Gang Information", "MG_GangInfo_SM", x + w/2, y + 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText((gangData.name or "No Name") .. " (ID: " .. (gangData.id or "NIL") .. ")", "MG_GangInfo_XSM", x + w/2, y + 23, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Leader: " .. (gangData.leader_name or "No Leader"), "MG_GangInfo_XSM", x + w/2, y + 38, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Level: " .. (gangData.level or "No Level"), "MG_GangInfo_XSM", x + w/2, y + 53, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end)
