--[[
MGANGS - SERVERSIDE NETWORKING
Developed by Zephruz
]]

--[[Module]]
-- Sends (to client)
util.AddNetworkString('MG2.Send.GangInvites')
util.AddNetworkString('MG2.Send.GangData')
util.AddNetworkString('MG2.Send.GangGroups')
util.AddNetworkString('MG2.Send.GangMembers')
util.AddNetworkString('MG2.Send.NewGangMember')
util.AddNetworkString('MG2.Send.RemovedGangMember')
util.AddNetworkString('MG2.Send.Gangs')
util.AddNetworkString('MG2.Send.Notification')

-- Admin
util.AddNetworkString('MG2.Admin.UpdateGang')
util.AddNetworkString('MG2.Admin.UpdatePlayer')
util.AddNetworkString('MG2.Admin.RequestGangs')
util.AddNetworkString('MG2.Admin.ActivateMenu')

-- Gang
util.AddNetworkString('MG2.Gang.Create')
util.AddNetworkString('MG2.Gang.Leave')
util.AddNetworkString('MG2.Gang.ActivateMenu')
util.AddNetworkString('MG2.Gang.UpdateData')
util.AddNetworkString('MG2.Gang.ClearData')
util.AddNetworkString('MG2.Gang.UpdateGroups')
util.AddNetworkString('MG2.Gang.CreateGroup')
util.AddNetworkString('MG2.Gang.DeleteGroup')
util.AddNetworkString('MG2.Gang.Balance.Withdraw')
util.AddNetworkString('MG2.Gang.Balance.Deposit')

-- Player
util.AddNetworkString('MG2.Player.Kick')
util.AddNetworkString('MG2.Player.Invite')
util.AddNetworkString('MG2.Player.Invite.Respond')
util.AddNetworkString('MG2.Player.SetGroup')

--[[
	NW Receives
]]

-- Admin
net.Receive("MG2.Admin.RequestGangs",
function(len, ply)
	local isAdmin = MGangs.Config.AdminGroups[ply:GetUserGroup()]

	if !(isAdmin) then return false end

	ply:SendAllGangs(MGangs.Gang:GetAll() or {})
end)

net.Receive("MG2.Admin.UpdateGang",
function(len,ply)
	local isAdmin = MGangs.Config.AdminGroups[ply:GetUserGroup()]
	local adminOpts = MGangs.Gang.AdminMenuOptions.gang

	if (!isAdmin or !adminOpts) then return false end

	local gangid = net.ReadInt(32)
	local data = net.ReadTable()
	local gangExists = MGangs.Gang:Exists(gangid)

	if (!gangid or !gangExists or !data) then return false end

	for k,v in pairs(adminOpts) do
		local succ, message

		if (data[k]) then
			if (v.update) then
				succ, message = v.update(gangid, data)

				break
			elseif (istable(data[k])) then
				for i,d in pairs(adminOpts[k]) do
					if (data[k][i] && d.update) then
						succ, message = d.update(gangid, data[k])

						break
					end
				end
			end
		end

		if (message) then
			ply:MG_SendNotification(message)
		end
	end
end)

net.Receive("MG2.Admin.UpdatePlayer",
function(len,ply)
	local isAdmin = MGangs.Config.AdminGroups[ply:GetUserGroup()]
	local adminOpts = MGangs.Gang.AdminMenuOptions.player

	if !(isAdmin) then return false end

	local tPly = net.ReadEntity()
	local data = net.ReadTable()

	if (IsValid(tPly)) then
		for k,v in pairs(adminOpts) do
			local succ, message

			if (data[k]) then
				if (v.update) then
					succ, message = v.update(tPly, data)

					break
				elseif (istable(data[k])) then
					for i,d in pairs(adminOpts[k]) do
						if (data[k][i] && d.update) then
							succ, message = d.update(tPly, data[k])

							break
						end
					end
				end
			end

			if (message) then
				ply:MG_SendNotification(message)
			end
		end
	else
		ply:MG_SendNotification(MGangs.Language:GetTranslation("player_not_valid"))
	end
end)

-- Balance
net.Receive("MG2.Gang.Balance.Withdraw",
function(len, ply)
	if !(ply:HasGang()) then return false end

	local amt = net.ReadInt(32)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Balance", "Withdraw")
	local balType = (MGangs.Gang.Currencies && MGangs.Gang.Currencies[MGangs.Config.Balance.use] or MGangs.Gang.Currencies["darkrp_cash"])

	if (!hasPerm or !amt or amt < 0) then return false end

	local cont, msg = hook.Run("MG2.Gang.Balance.Withdraw", ply, amt)

	if (cont != nil && !cont) then
		if (msg) then
			ply:MG_SendNotification(msg)
		end

		return false
	end

	local gangData = MGangs.Gang:Exists(gangid)
	local newAmt = gangData.balance - amt

	if (newAmt < 0) then ply:MG_SendNotification(MGangs.Language:GetTranslation("cant_withdraw_amt")) return false end

	local bTypeWithdraw = balType.withdraw(ply, amt)

	if !(bTypeWithdraw) then ply:MG_SendNotification(MGangs.Language:GetTranslation("cant_withdraw_amt")) return false end

	MGangs.Gang:SetMoney(gangid, newAmt)
end)

net.Receive("MG2.Gang.Balance.Deposit",
function(len, ply)
	if !(ply:HasGang()) then return false end

	local amt = net.ReadInt(32)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Balance", "Deposit")
	local balType = (MGangs.Gang.Currencies && MGangs.Gang.Currencies[MGangs.Config.Balance.use] or MGangs.Gang.Currencies["darkrp_cash"])

	if (!hasPerm or !amt or amt < 0) then return false end

	local gangData = MGangs.Gang:Exists(gangid)

	if !(gangData) then return false end

	local newAmt = gangData.balance + amt
	local cont, msg = hook.Run("MG2.Gang.Balance.Deposit", ply, newAmt)

	if (cont != nil && !cont) then
		if (msg) then
			ply:MG_SendNotification(msg)
		end

		return false
	end

	if (newAmt < 0) then ply:MG_SendNotification(MGangs.Language:GetTranslation("cant_deposit_amt")) return false end

	local bTypeDeposit = balType.deposit(ply, amt)

	if !(bTypeDeposit) then ply:MG_SendNotification(MGangs.Language:GetTranslation("cant_deposit_amt")) return false end

	MGangs.Gang:SetMoney(gangid, newAmt)
end)

-- Create Gang
net.Receive("MG2.Gang.Create",
function(len, ply)
	hook.Run("MG2.Gang.PreCreation", ply)

	local data = {name = net.ReadString(), icon_url = net.ReadString(), groups = net.ReadTable()}
	local gangid, msg = MGangs.Gang:Create(ply, data)

	ply:MG_SendNotification(msg)

	hook.Run("MG2.Gang.PostCreation", ply, gangid)
end)

-- Leave Gang
net.Receive("MG2.Gang.Leave",
function(len, ply)
	ply:RemoveFromGang()

	hook.Run("MG2.Gang.Leave", ply)
end)

-- Update Gang
net.Receive("MG2.Gang.UpdateData",
function(len, ply)
	if !(ply:HasGang()) then return false end

	local data = net.ReadTable()
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Gang", "Edit")

	if (!hasPerm or !data) then return false end

	local newData = {	-- Add this so we only allow certain values to pass
		["name"] = (data.name or nil),
		["icon_url"] = (data.icon_url or nil),
	}

	local updGang = MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, newData)

	if (updGang or updGang == nil) then
		ply:ActivateGangMenu(true)

		local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid)

		for i=1,#onlineMembers do
			local ply = onlineMembers[i]

			if (ply && IsValid(ply)) then
				ply:SendGangData(newData)
			end
		end
	end
end)

--[[Gang Player]]
net.Receive("MG2.Player.Invite.Respond",
function(len, ply)
	local invid = net.ReadInt(32)
	local repBool = net.ReadBool()

	ply:RespondToInvite(invid, repBool)
end)

net.Receive("MG2.Player.Invite",
function(len,ply)
	if (ply.mg2_nextGangInvite && ply.mg2_nextGangInvite > os.time()) then
		ply:MG_SendNotification(MGangs.Language:GetTranslation("you_cant_do_yet"))

		return false
	end
	ply.mg2_nextGangInvite = os.time() + 5

	if !(ply:HasGang()) then return false end

	local gangid = ply:GetGangID()
	local invPly = net.ReadEntity()
	local hasPerm = ply:HasGangPermission("User", "Invite")

	if (!hasPerm or !invPly or !IsValid(invPly) or invPly:HasGang()) then return false end

	local succ, msg = invPly:InviteToGang(ply, gangid)

	if (msg) then
		ply:MG_SendNotification(msg)
	end

	hook.Run("MG2.Gang.Invite", ply, invPly)
end)

net.Receive("MG2.Player.Kick",
function(len,ply)
	if !(ply:HasGang()) then return false end

	local stid = net.ReadString()

	local hasPerm = ply:HasGangPermission("Member", "Kick")

	if (!hasPerm or !stid) then return false end

	MGangs.Player:RemoveFromGang(stid)

	hook.Run("MG2.Gang.Kick", stid)
end)

net.Receive("MG2.Player.SetGroup",
function(len,ply)
	if !(ply:HasGang()) then return false end

	local stid = net.ReadString()
	local groupid = net.ReadInt(32)

	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Member", "Set Group")

	if (!hasPerm or !groupid or !stid) then return false end

	MGangs.Player:SetGroup(gangid, stid, groupid)
end)

--[[Groups]]
-- Delete Gang Group
net.Receive("MG2.Gang.DeleteGroup",
function(len, ply)
	if !(ply:HasGang()) then return false end

	local gangid = ply:GetGangID()
	local groupid = net.ReadInt(32)
	local hasPerm = ply:HasGangPermission("Group", "Delete")

	if (!hasPerm or !groupid) then return false end

	MGangs.Gang:DeleteGroup(gangid, groupid)
end)

-- Create New Gang Group
net.Receive("MG2.Gang.CreateGroup",
function(len, ply)
	if !(ply:HasGang()) then return false end

	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Group", "Create")

	if !(hasPerm) then return false end

	MGangs.Gang:CreateGroup(gangid)

	-- ply:ActivateGangMenu(true)
	ply:MG_SendNotification(MGangs.Language:GetTranslation("gang_created_group"))
end)

-- Update Gang Groups
net.Receive("MG2.Gang.UpdateGroups",
function(len, ply)
	local group = net.ReadTable()

	if !(group) then return false end
	if !(ply:HasGang()) then return false end

	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Group", "Edit")

	if !(hasPerm) then return false end

	MGangs.Gang:UpdateGroups(gangid, group)
end)
