--[[
MGANGS - UPGRADES SERVERSIDE META
Developed by Zephruz
]]

--[[------------
	Upgrade Meta
---------------]]

-- ValidateUpgrades
-- 	- Validates any existant/non-existant/invalid upgrades and handles them
MGangs.Meta:Register("ValidateUpgrades", MGangs.Gang,
function(self, gangid)
	local upgs = MGangs.Gang:GetUpgrades(gangid)
	local upgTbl = {}

	if (upgs or upgs == nil) then
		local upgCfgTbl = table.Copy(MG2_UPGRADES.Config.Upgrades)

		for k,v in pairs(upgCfgTbl) do
			if (upgs == nil) then
				MGangs.Gang:SetUpgrade(gangid, k, (v.default or 0))

				table.insert(upgTbl,v)
			else
				local exists = false

				for i=1,#upgs do
					local upg = upgs[i]

					if (upg && upg.upgname == k) then
						exists = true
					end
				end

				if !(exists) then
					MGangs.Gang:SetUpgrade(gangid, k, (v.default or 0))

					upgTbl[k] = v
				end
			end
		end
	end

	-- Send user data
	if (upgTbl && #upgTbl > 0) then
		upgs = MGangs.Gang:GetUpgrades(gangid)

		MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendGangUpgrades(upgs or {})
		end)
	end

	return upgs
end)

MGangs.Meta:Register({"GetUpgrades", "GetGangUpgrades"}, MGangs.Gang,
function(self, gangid)
	local gangUpgrades = MGangs.Data:SelectAllWhere("mg2_gangupgrades", "gangid", gangid)

	if (gangUpgrades) then
		return gangUpgrades
	end

	return nil
end)

MGangs.Meta:Register({"SetUpgrade", "SetGangUpgrade"}, MGangs.Gang,
function(self, gangid, name, val)
	local exists
	local getGang = MGangs.Gang:Exists(gangid)

	if (getGang && name) then
		local getUpgrades = MGangs.Gang:GetUpgrades(gangid)

		if (getUpgrades) then
			for k,v in pairs(getUpgrades) do
				if (v.upgname == name) then
					MGangs.Data:UpdateWhere("mg2_gangupgrades", "id", v.id,{
						val = (val or 0)
					})

					MGangs.Gang:GetOnlineMembers(gangid,
					function(ply)
						ply:SendGangUpgrades({
							{
								upgname = name,
								val = val,
							},
						})
					end)

					return true, MGangs.Language:GetTranslation("upgrade_exists")
				end
			end
		end

		local createUpgrade = MGangs.Data:InsertInto("mg2_gangupgrades", {
			gangid = (gangid),
			upgname = (name),
			val = (val or 0),
		})

		if (createUpgrade or createUpgrade == nil) then
			MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendGangUpgrades({
					{
						upgname = name,
						val = val,
					},
				})
			end)
		end

		return true, createUpgrade
	end

	return false, MGangs.Language:GetTranslation("no_gang")
end)

--[[------------
	Player Meta
---------------]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangUpgrades(upgs)
	if !(upgs) then MGangs.Gang:ValidateUpgrades(self:GetGangID()) return false end

	for i=1,#upgs do
		local upgs = upgs[i]

		if (upgs.upgname && upgs.val) then
			net.Start("MG_SendGangUpgrades")
				net.WriteString(upgs.upgname)
				net.WriteInt(upgs.val, 32)
			net.Send(self)
		end
	end
end

MGangs.Meta:Register({"BuyUpgrade", "BuyGangUpgrade"}, MGangs.Player,
function(self, ply, upgType)
	if !(MGangs.Config.Balance.enabled) then return false, MGangs.Language:GetTranslation("balance_disabled") end

	local gangid = ply:GetGangID()
	local hasGang = ply:HasGang()

	if !(hasGang) then return false, MGangs.Language:GetTranslation("no_gang") end

	local gangData = MGangs.Gang:Exists(gangid)

	if !(gangData) then return false end

	local hasPerm = ply:HasGangPermission("Upgrades", "Purchase")

	if (hasPerm) then
		local bal = (tonumber(gangData.balance) or nil)
		local upgs = MGangs.Gang:ValidateUpgrades(gangid)
		local upgData = MG2_UPGRADES.Config.Upgrades[upgType]

		if !(upgData) then return false, MGangs.Language:GetTranslation("upgrade_invalidtype") end

		local upgCost = (tonumber(upgData.upg_cost) or nil)

		-- Check balance & charge
		if (bal && upgCost) then
			if (bal >= upgCost) then
				MGangs.Gang:SetMoney(gangid, bal - upgCost)
			else
				return false, MGangs.Language:GetTranslation("not_enough_balance")
			end
		else
			return false, MGangs.Language:GetTranslation("invalid_balance_warn")
		end

		-- Set Upgrade
		if (upgs) then
			for i=1,#upgs do
				local upg = upgs[i]

				if (upg && upg.upgname == upgType) then
					local val = (upg.val + upgData.upg_increments)

					MGangs.Gang:SetUpgrade(gangid, upgType, val)

					ply:MG_SendNotification(MGangs.Language:GetTranslation("upgraded_to", (upgData.fixedname or "NIL") .. (upgData.suffix or " NIL"), (val or 0)))

					break
				end
			end
		end

		return true, MGangs.Language:GetTranslation("upgrade_purchased")
	end
end)
