--[[
MGANGS - ASSOCIATIONS SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/associations/assoc_config.lua") -- Config (SH)
AddCSLuaFile("modules/associations/assoc_config.lua") -- Config (SH)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/associations/client/cl_meta.lua")
AddCSLuaFile("modules/associations/client/cl_derma.lua")

-- Verify SQLite tables exist
hook.Add("MG2.SQL.VerifyTables", "MG2.SQL.VerifyTables.MODULE.ASSOCIATIONS",
function()
	-- [[Gang Upgrades]]
	MGangs.Data:RegisterSQLTable("mg2_gangassociations", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "type", ctype = "VARCHAR(32) NOT NULL"},
        {name = "gid1", ctype = "INTEGER NOT NULL"},
        {name = "gid2", ctype = "INTEGER NOT NULL"},
				{name = "atWar", ctype = "BOOLEAN NOT NULL"},
				{name = "data", ctype = "BLOB NOT NULL"},
			},
		})
end)

-- Send any data (to player) this module requires
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.ASSOCIATIONS",
function(ply)
	local gangID = ply:GetGangID()
  local ass = MGangs.Gang:GetAssociations(gangID)

  ply:SendGangAssociations(ass)
end)

-- Start of gang creation
hook.Add("MG2.Gang.Creation.Start", "MG2.Gang.Creation.Start.MODULE.ASSOCIATIONS", function(data) end)

-- After gang creation
hook.Add("MG2.Gang.Creation.End", "MG2.Gang.Creation.End.MODULE.ASSOCIATIONS", function(data) end)

-- After gang deleted
hook.Add("MG2.Gang.Deleted", "MG2.Gang.Deleted.MODULE.ASSOCIATIONS",
function(id)
	MGangs.Data:DeleteWhere("mg2_gangassociations", "gid1", id)	-- Delete associations [for gid1 col]
  MGangs.Data:DeleteWhere("mg2_gangassociations", "gid2", id)	-- Delete associations [for gid2 col]
end)

--[[------------
	HOOKS
--------------]]
hook.Add("PlayerShouldTakeDamage", "MG2.ASSOCIATIONS.PlayerShouldTakeDamage",
function(ply, att)
	if (ply:IsPlayer() && att:IsPlayer()) then
    local plyGid, attGid = ply:GetGangID(), att:GetGangID()

		if (plyGid == attGid && plyGid == 0) then return true end	-- They're both not in a gang
    if (plyGid == attGid) then return MG2_ASSOCIATIONS.config.friendlyFire end

		--[[local hasAss, assData = MGangs.Gang:HasAssociation(plyGid, attGid)

    if (hasAss) then
      local sInfo = MG2_ASSOCIATIONS:GetStatus(assData && assData.id)
      local sPerms = (sInfo && sInfo.perms)

      if (sPerms) then
        return (sPerms.killOther)
      end
    end]]
	end
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString("MG.Send.GangAssociations")

util.AddNetworkString("MG.Gang.SetAssociation")
util.AddNetworkString("MG.Gang.SetWarStatus")

net.Receive("MG.Gang.SetAssociation",
function(len, ply)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Associatons", "Set Status")

	if !(hasPerm) then return false end

	local targGid = net.ReadInt(32)	-- Target gang id
	local sid = net.ReadInt(32)			-- Status ID
	local targExists = MGangs.Gang:Exists(targGid)

	if !(targExists) then return false end

	local cont = hook.Run("MG2.Gang.Associations.SetAssociation", gangid, targGid, itemData)

	if (cont == false) then return false end

	local succ, msg = MGangs.Gang:SetAssociation(gangid, targGid, sid)

	if (msg) then
		ply:MG_SendNotification(msg)
	end
end)

net.Receive("MG.Gang.SetWarStatus",
function(len, ply)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Associatons", "Set Status")

	if !(hasPerm) then return false end

	local targGid = net.ReadInt(32)	-- Target gang id
	local warStat = net.ReadBool()
	local targExists = MGangs.Gang:Exists(targGid)

	if !(targExists) then return false end

	local cont = hook.Run("MG2.Gang.Associations." .. (warStat && "StartWar" || "EndWar"), gangid, targGid)

	if (cont == false) then return false end

	local succ, msg = MGangs.Gang:SetWarStatus(gangid, targGid, warStat)

	if (msg) then
		ply:MG_SendNotification(msg)
	end
end)
