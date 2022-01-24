--[[
MGANGS - CLIENTSIDE META
Developed by Zephruz
]]

--[[-------------
	Misc. Meta
----------------]]
MGangs.Meta:Register("Notification", MGangs,
function(self, msg)
	chat.AddText(Color(255,255,255), msg)

	hook.Run("MG2.Notification", msg)
end)

--[[-------------
	Gang Data
----------------]]
MGangs.Meta:Register("InitData", MGangs.Gang,
function(self, noreset)
	self.Data = (noreset && self.Data || {})
	self.Data.groups = (noreset && self.Data.groups || {})
	self.Data.members = (noreset && self.Data.members || {})
	self.Data.invites = (noreset && self.Data.invites || {})
	self.Data.gangs = (noreset && self.Data.gangs || {})

	-- Admin
	MGangs.Gang:RequestAll() -- Request all gangs

	hook.Run("MG2.Gang.InitData", self.Data)
end)

--[[-------------
	Gang Meta
----------------]]
MGangs.Meta:Register({"GetByID", "FindGang"}, MGangs.Gang,
function(self, gangid)
	local gFound
	local gangInfo = self.Data.gangs

	for k,v in pairs(gangInfo) do
		if (tonumber(v.id) == tonumber(gangid)) then
			gFound = v

			break
		end
	end

	return gFound
end)

MGangs.Meta:Register({"RequestAll", "RequestAllGangs"}, MGangs.Gang,
function(self)
	net.Start("MG2.Admin.RequestGangs")
	net.SendToServer()
end)

MGangs.Meta:Register({"GetAll", "GetAllGangs"}, MGangs.Gang,
function(self)
	return self.Data.gangs
end)

MGangs.Meta:Register("RespondToInvite", MGangs.Gang,
function(self, invid, bool)
	net.Start("MG2.Player.Invite.Respond")
		net.WriteInt(invid, 32)
		net.WriteBool(bool)
	net.SendToServer()
end)

MGangs.Meta:Register({"Create", "CreateGang"}, MGangs.Gang,
function(self, gangName, gangIcon, gangGroups)
	net.Start("MG2.Gang.Create")
		net.WriteString(gangName)
		net.WriteString(gangIcon)
		net.WriteTable(gangGroups)
	net.SendToServer()
end)

MGangs.Meta:Register({"Leave", "LeaveGang"}, MGangs.Gang,
function(self)
	net.Start("MG2.Gang.Leave")
	net.SendToServer()
end)

MGangs.Meta:Register({"UpdateData", "UpdateGangData"}, MGangs.Gang,
function(self, data)
	net.Start("MG2.Gang.UpdateData")
		net.WriteTable(data)
	net.SendToServer()
end)

MGangs.Meta:Register({"GetData", "GetGangData"}, MGangs.Gang,
function(self)
	return (MGangs.Gang.Data)
end)

MGangs.Meta:Register({"GetGroups", "GetGangGroups"}, MGangs.Gang,
function(self)
	local gangData = MGangs.Gang:GetData()

	if !(gangData.id) then return false end

	local gangGroups = gangData.groups

	return (gangGroups or {})
end)

MGangs.Meta:Register({"GroupInfo", "GangGroupInfo"}, MGangs.Gang,
function(self, id)
	local gangData = MGangs.Gang:GetData()

	if !(id) then return {} end
	if !(gangData.id) then return {} end

	local gangGroups = gangData.groups

	for i=1,#gangGroups do
		if (tonumber(gangGroups[i].id) == tonumber(id)) then
			return gangGroups[i]
		end
	end

	return {}
end)

MGangs.Meta:Register("GetPermissions", MGangs.Gang,
function(self, ptype)
	local gangData = MGangs.Gang:GetData()
	local groupPerms = MGangs.Gang:GroupInfo(gangData.yourgroup)
	groupPerms = (groupPerms.perms && groupPerms.perms[ptype] or {})

	if (gangData.leader && gangData.leader.steamid == LocalPlayer():SteamID()) then
		return (MGangs.Gang.GroupPermissions[ptype] or MGangs.Gang.GroupPermissions)
	end

	return (groupPerms)
end)

MGangs.Meta:Register({"GetMembers", "GetGangMembers"}, MGangs.Gang,
function(self)
	local gangData = MGangs.Gang:GetData()
	local gangMembers = table.Copy(gangData.members)
	local onlineGangMembers = MGangs.Gang:GetOnlineMembers(gangData.id)

	for i=1,#gangMembers do
		if (gangMembers[i]) then
			gangMembers[i].status = 0

			for j=1,#onlineGangMembers do
				if (gangMembers[i].steamid == onlineGangMembers[j]:SteamID() or onlineGangMembers[j]:SteamID() == "NULL") then
					gangMembers[i].status = 1
				end
			end
		else
			table.remove(gangMembers,i)
		end
	end

	function sortByStatus(a,b)
		return a.status > b.status
	end

	table.sort(gangMembers, sortByStatus)

	return gangMembers
end)

-- Groups
MGangs.Meta:Register({"UpdateGroups", "UpdateGangGroups"}, MGangs.Gang,
function(self, groups)
	for i=1,#groups do
		local group = groups[i]

		if (group) then
			net.Start("MG2.Gang.UpdateGroups")
				net.WriteTable(group)
			net.SendToServer()
		end
	end
end)

MGangs.Meta:Register({"CreateGroup", "CreateGangGroup"}, MGangs.Gang,
function(self)
	net.Start("MG2.Gang.CreateGroup")
	net.SendToServer()
end)

MGangs.Meta:Register({"DeleteGroup", "DeleteGangGroup"}, MGangs.Gang,
function(self, id)
	net.Start("MG2.Gang.DeleteGroup")
		net.WriteInt(id, 32)
	net.SendToServer()
end)

MGangs.Meta:Register({"Deposit", "DepositMoney"}, MGangs.Gang,
function(self, amt)
	amt = tonumber(amt)
	if (!amt or type(amt) != "number") then return false end

	net.Start("MG2.Gang.Balance.Deposit")
		net.WriteInt(amt, 32)
	net.SendToServer()
end)

MGangs.Meta:Register({"Withdraw", "WithdrawMoney"}, MGangs.Gang,
function(self, amt)
	amt = tonumber(amt)
	if (!amt or type(amt) != "number") then return false end

	net.Start("MG2.Gang.Balance.Withdraw")
		net.WriteInt(amt, 32)
	net.SendToServer()
end)

--[[-------------
	Player Meta
----------------]]
local plyMeta = FindMetaTable("Player")

-- Respond to invite
MGangs.Meta:Register("RespondToInvite", MGangs.Player,
function(self, invid, bool)
	net.Start("MG2.Player.Invite.Respond")
		net.WriteInt(invid, 32)
		net.WriteBool(bool)
	net.SendToServer()
end)

-- Invite
MGangs.Meta:Register({"Invite", "InviteToGang"}, MGangs.Player,
function(self, ply)
	net.Start("MG2.Player.Invite")
		net.WriteEntity(ply)
	net.SendToServer()
end)

-- Kick
MGangs.Meta:Register({"Kick", "KickFromGang"}, MGangs.Player,
function(self, stid)
	net.Start("MG2.Player.Kick")
		net.WriteString(stid)
	net.SendToServer()
end)

-- Set Group Info
MGangs.Meta:Register({"SetGroup", "SetGangGroup"}, MGangs.Player,
function(self, stid, groupid)
	net.Start("MG2.Player.SetGroup")
		net.WriteString(stid)
		net.WriteInt(groupid,32)
	net.SendToServer()
end)

-- Get Invites
MGangs.Meta:Register({"GetInvites", "GetGangInvites"}, MGangs.Player,
function(self)
	return (MGangs.Gang.Data.invites or {})
end)

-- Has Permission
MGangs.Meta:Register("HasPermission", MGangs.Player,
function(self, ptype, perm, groupid)
	local gangData = MGangs.Gang:GetData()
	local groupPerms = MGangs.Gang:GroupInfo(groupid || gangData.yourgroup)
	local gTypeInfo = MGangs.Gang:GetGroupTypeInfo(groupPerms && groupPerms.grouptype || 0)
	groupPerms = (groupPerms && groupPerms.perms || {})

	if (gTypeInfo && gTypeInfo.leader) then return true end
	if !(groupPerms[ptype]) then return false end

	if (gangData.leader_steamid == LocalPlayer():SteamID()) then
		if !(MGangs.Gang.GroupPermissions[ptype]) then return false end

		return (table.HasValue(MGangs.Gang.GroupPermissions[ptype], perm))
	end

	return (table.HasValue(groupPerms[ptype], perm))
end)
