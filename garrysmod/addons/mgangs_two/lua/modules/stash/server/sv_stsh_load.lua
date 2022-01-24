--[[
MGANGS - STASH SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/stash/stsh_config.lua") -- Config (SV)
AddCSLuaFile("modules/stash/stsh_config.lua") -- Config (CL)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/stash/client/cl_meta.lua")
AddCSLuaFile("modules/stash/client/cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.SQL.VerifyTables", "MG2.SQL.VerifyTables.MODULE.STASH",
function()
	-- [[Gang Stash Items]]
	-- ent:GetNetworkVars() - use this to fetch an entities NW vars for storage
	MGangs.Data:RegisterSQLTable("mg2_gangstashitems", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "amt", ctype = "INTEGER NOT NULL"},
				{name = "class", ctype = "VARCHAR(32) NOT NULL"},
				{name = "model", ctype = "VARCHAR(128) NOT NULL"},
				{name = "data", ctype = "BLOB NOT NULL"},
			},
		})
end)

hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.STASH",
function(ply)
	local gangID = ply:GetGangID()
	local gangItems = MGangs.Gang:GetStashItems(gangID)

	ply:SendGangStashItems((gangItems or {}))
end)

hook.Add("MG2.Gang.Deleted", "MG2.Gang.Deleted.MODULE.STASH",
function(id)
	-- Give/spawn stash items for owner & delete from database

	MGangs.Data:DeleteWhere("mg2_gangstashitems", "gangid", id)
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString('MG.Send.GangStashItems')
util.AddNetworkString('MG_DepositStashItem')
util.AddNetworkString('MG_WithdrawStashItem')

net.Receive("MG_DepositStashItem",
function(len, ply)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Stash", "Deposit Items")

	if !(hasPerm) then return false end

	local invType = net.ReadString()
	local itemData = net.ReadTable()

	local cont, msg = hook.Run("MG2.Gang.Stash.Deposit", gangid, itemData)

	if (cont != nil && !cont) then ply:MG_SendNotification(msg or "You can't deposit that!") return false end

	local invData = MG2_STASH:GetDepositTypes()
	invData = (invData[invType])

	if !(invData) then return false end

	local invCont = true
	local invMeta = invData.meta

	if !(invMeta) then return false end

	if (invMeta.deposit) then
		invCont = (invMeta.deposit(ply, itemData) or invCont)
	end

	if !(invCont) then return false end

	MGangs.Gang:DepositItem(ply, itemData)
end)

net.Receive("MG_WithdrawStashItem",
function(len, ply)
	local gangid = ply:GetGangID()
	local hasPerm = ply:HasGangPermission("Stash", "Withdraw Items")

	if !(hasPerm) then return false end

	local invType = net.ReadString()
	local itemData = net.ReadTable()
	local itemWDAmt = net.ReadInt(32)

	local cont, msg = hook.Run("MG2.Gang.Stash.Withdraw", gangid, itemData)

	if (cont != nil && !cont) then ply:MG_SendNotification(msg or "You can't withdraw that!") return false end

	local invData = MG2_STASH:GetDepositTypes()
	invData = (invData[invType])

	if (!invData or invData.check && !invData.check()) then return false end

	local invCont = true
	local invMeta = invData.meta

	if !(invMeta) then return false end

	invCont = MGangs.Gang:WithdrawItem(ply, itemData, itemWDAmt)

	if !(invCont) then return false end

	if (invMeta.withdraw) then
		invCont = invMeta.withdraw(ply, itemData, itemWDAmt)
	end
end)
