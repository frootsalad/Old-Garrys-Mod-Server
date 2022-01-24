--[[
MGANGS - CLIENTSIDE NETWORKING
Developed by Zephruz
]]

-- Clears localized gang data
net.Receive("MG2.Gang.ClearData",
function(len)
	MGangs.Gang:InitData(false)
end)

-- Receives gangs
net.Receive("MG2.Send.Gangs",
function(len)
	local curSplit = net.ReadInt(32)
	local gangsTbl = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.gangs = gangsTbl
	else
		table.Merge(MGangs.Gang.Data.gangs, gangsTbl)
	end
end)

--[[Gang Data Receivers]]
-- Receives gang data
net.Receive("MG2.Send.GangData",
function(len)
	local gangData = net.ReadTable()

	for k,v in pairs(gangData) do
		print("Received gang data: (type) " .. k .. " - (value) " .. tostring(v))
		MGangs.Gang.Data[k] = v
	end
end)

-- Receives gang invites
net.Receive("MG2.Send.GangInvites",
function(len)
	local curSplit = net.ReadInt(32)
	local gangInvites = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.invites = gangInvites
	else
		table.Merge(MGangs.Gang.Data.invites, gangInvites)
	end
end)

-- Receives gang groups
net.Receive("MG2.Send.GangGroups",
function(len)
	local curSplit = net.ReadInt(32)
	local gangGroups = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.groups = gangGroups
	else
		table.Merge(MGangs.Gang.Data.groups,gangGroups)
	end
end)

-- Receives gang members
net.Receive("MG2.Send.GangMembers",
function(len)
	local curSplit = net.ReadInt(32)
	local gangMembers = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.members = gangMembers
	else
		table.Merge(MGangs.Gang.Data.members,gangMembers)
	end
end)

-- Receives new gang member
net.Receive("MG2.Send.NewGangMember",
function(len)
	local member = net.ReadTable()
	local gangmems = MGangs.Gang.Data.members

	for i=1,#gangmems do
		if (gangmems[i].steamid == member.steamid) then	-- Just update them, don't insert a new member
			gangmems[i] = member

			return true
		end
	end

	table.insert(gangmems, member)
end)

-- Receives removed gang member
net.Receive("MG2.Send.RemovedGangMember",
function(len)
	local mstid = net.ReadString()
	local gangmems = MGangs.Gang.Data.members

	for i=1,#gangmems do
		if (gangmems[i] && gangmems[i].steamid == mstid) then
			table.remove(gangmems, i)
		end
	end
end)

-- Receives a server-sent notification
net.Receive("MG2.Send.Notification",
function(len)
	local message = net.ReadString()

	MGangs:Notification(message)
end)
