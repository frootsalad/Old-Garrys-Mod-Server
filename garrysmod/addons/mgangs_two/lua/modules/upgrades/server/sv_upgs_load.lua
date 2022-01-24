--[[
MGANGS - UPGRADES SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/upgrades/upgs_config.lua") -- Config (SV)
AddCSLuaFile("modules/upgrades/upgs_config.lua") -- Config (CL)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/upgrades/client/cl_meta.lua")
AddCSLuaFile("modules/upgrades/client/cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]

-- Verify SQLite tables exist
hook.Add("MG2.SQL.VerifyTables", "MG2.SQL.VerifyTables.MODULE.UPGRADES",
function()
	-- [[Gang Upgrades]]
	MGangs.Data:RegisterSQLTable("mg2_gangupgrades", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "val", ctype = "INTEGER NOT NULL"},
				{name = "upgname", ctype = "VARCHAR(32) NOT NULL"},
			},
		})
end)

-- Send any data (to player) this module requires
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.UPGRADES",
function(ply)
	local gangID = ply:GetGangID()
	local gangUpgrades = MGangs.Gang:GetUpgrades(gangID)

	ply:SendGangUpgrades((gangUpgrades or {}))
end)

-- Start of gang creation
hook.Add("MG2.Gang.Creation.Start", "MG2.Gang.Creation.Start.MODULE.UPGRADES",
function(data)
	local gangid = data.id
	local ganginfo = data.info

	-- Create Upgrades
	MGangs.Gang:ValidateUpgrades(gangid)
end)

-- After gang creation
hook.Add("MG2.Gang.Creation.End", "MG2.Gang.Creation.End.MODULE.UPGRADES", function(data) end)

-- After gang deleted
hook.Add("MG2.Gang.Deleted", "MG2.Gang.Deleted.MODULE.UPGRADES",
function(id)
	MGangs.Data:DeleteWhere("mg2_gangupgrades", "gangid", id)	-- Delete upgrades
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString('MG_PurchaseGangUpgrade')
util.AddNetworkString('MG_SendGangUpgrades')

-- Purchase gang Upgrade
net.Receive("MG_PurchaseGangUpgrade",
function(len, ply)
	local upgType = net.ReadString()

	MGangs.Player:BuyUpgrade(ply, upgType)
end)

--[[-----------
	RETURN HOOKS
	- Any hooks that return a value to a hook goes here.
	- Usually checks for maximum/minimum amounts.
-------------]]
local function checkGangUpgrade(upgNm,gangid,amt,retFunc)
	if (!gangid or !amt) then return false, MGangs.Language:GetTranslation("upg_invalid_amtgangid", (amt or "NIL"), (gangid or "NIL")) end

	amt = tonumber(amt)

	local upgData = MG2_UPGRADES.Config.Upgrades[upgNm]
	local gangData = MGangs.Gang:Exists(gangid)

	if (upgData && gangData) then
		local gangUpgs = MGangs.Gang:GetUpgrades(gangid)

		if (gangUpgs) then
			for i=1,#gangUpgs do
				local upg = gangUpgs[i]

				if (upg.val && upg.upgname == upgNm) then
					local upgVal = tonumber(upg.val or 0)

					if (upgVal >= amt) then
						return true
					end
				end
			end
		end
	end

	return false
end


--[[
	Gang Balance Hook
	- Matches set amount to maximum balance
]]
hook.Add("MG2.Gang.Balance.Deposit", "MG2.Gang.Balance.Deposit.MODULE.UPGRADES",
function(ply,amt)
	local canUpg = checkGangUpgrade("balancecash",ply:GetGangID(),amt)

	return canUpg, (!canUpg && MGangs.Language:GetTranslation("upg_bal_cantdeposit"))
end)

--[[
	Stash Deposit Hook
	- Matches set amount to maximum balance
]]
hook.Add("MG2.Gang.Stash.Deposit", "MG2.Gang.Stash.Deposit.MODULE.UPGRADES",
function(gangid,itemData)
	if (!gangid or !itemData) then return false, MGangs.Language:GetTranslation("upg_stash_invalid_itemgangid", (itemData or "NIL"), (gangid or "NIL")) end

	local upgData = MG2_UPGRADES.Config.Upgrades["stashslots"]
	local stashItems = MGangs.Gang:GetItems(gangid)

	if (upgData) then
		if (stashItems) then
			local amt = 0

			for k,v in pairs(stashItems) do
				amt = (amt + (v.amt or 1))
			end

			local checkUpg = checkGangUpgrade("stashslots",gangid,amt)

			return checkUpg, (!checkUpg && MGangs.Language:GetTranslation("upg_stash_cantdeposit"))
		else
			return true
		end
	end

	return false
end)

--[[
	Player Join Gang Hook(s)
	- Matches set amount to maximum balance
]]
hook.Add("MG2.Player.InviteToGang", "MG2.Player.InviteToGang.MODULE.UPGRADES",
function(ply, invitor, gangid)
	local members = (table.Count(MGangs.Gang:GetMembers(gangid)) or 1)
	local canJoin = checkGangUpgrade("memberslots",gangid,members)

	return checkGangUpgrade("memberslots",gangid,members)
end)

hook.Add("MG2.Player.AddToGang", "MG2.Player.AddToGang.MODULE.UPGRADES",
function(ply, gangid)
	local members = (table.Count(MGangs.Gang:GetMembers(gangid) or {ply}) or 1)
	local canJoin = checkGangUpgrade("memberslots",gangid,members)

	return canJoin, (!canJoin && MGangs.Language:GetTranslation("upg_gang_memberfull"))
end)
