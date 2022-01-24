--[[
MGANGS - STASH SERVERSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"GetItems", "GetStashItems", "GetGangStashItems"}, MGangs.Gang,
function(self, gangid)
	local gangItems = MGangs.Data:SelectAllWhere("mg2_gangstashitems", "gangid", gangid)

	if (gangItems && istable(gangItems)) then
		for i=1,table.Count(gangItems) do
			gangItems[i].data = util.JSONToTable(gangItems[i].data)
		end

		return gangItems
	end

	return false
end)

MGangs.Meta:Register({"DepositItem", "DepositStashItem"}, MGangs.Gang,
function(self, ply, itemData)
	local gangid = ply:GetGangID()

	if !(ply:HasGang()) then return false end

	local depositItem
	local items = MGangs.Gang:GetItems(gangid)

	if (items) then
		for i=1,#items do
			local iChk = items[i]

			-- TODO: check the data table before we check for same class types

			if (iChk.class == itemData.class) then
				itemData.exists = true
				itemData.aid = iChk.id
				itemData.amt = iChk.amt + 1

				break
			end
		end
	end

	if (itemData.exists) then
		depositItem = MGangs.Data:UpdateWhere("mg2_gangstashitems", "id", itemData.aid, {
			amt = itemData.amt,
		})
	else
		depositItem = MGangs.Data:InsertInto("mg2_gangstashitems", {
			gangid = gangid,
			class = itemData.class,
			model = itemData.model,
			amt = 1,
			data = "[]",
		})
	end

	if (depositItem or depositItem == nil) then
		local items = MGangs.Gang:GetItems(gangid)
		local members = MGangs.Gang:GetOnlineMembers(gangid)

		for i=1,#members do
			local plys = members[i]

			plys:SendGangStashItems(items)
		end
	end
end)

MGangs.Meta:Register({"WithdrawItem", "WithdrawStashItem"}, MGangs.Gang,
function(self, ply, itemData, amt)
	local gangid = ply:GetGangID()

	if (!ply:HasGang() or !itemData) then return false end

	local withdrawItem
	local withdrawAmt = (amt or 1)
	local items = MGangs.Gang:GetItems(gangid)

	itemData.exists = false

	if (items) then
		for i=1,#items do
			local iChk = items[i]

			if (iChk.id == itemData.id) then
				itemData = iChk
				itemData.exists = true

				break
			end
		end
	end

	if (itemData.exists) then
		local itemAmt = (tonumber(itemData.amt or 1))
		local totalAmt = itemAmt - withdrawAmt

		if (withdrawAmt <= 0) then return false end

		if (totalAmt <= 0) then
			withdrawItem = MGangs.Data:DeleteWhere("mg2_gangstashitems", "id", itemData.id)
		elseif (itemAmt > 1) then
			withdrawItem = MGangs.Data:UpdateWhere("mg2_gangstashitems", "id", itemData.id, {
				["amt"] = totalAmt,
			})
		end
	end

	local items = (MGangs.Gang:GetItems(gangid) or {})

	MGangs.Gang:GetOnlineMembers(gangid,
	function(ply)
		ply:SendGangStashItems(items)
	end)

	return (itemData.exists)
end)

--[[PLAYER META]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangStashItems(items)
	self:SendSplitData("MG.Send.GangStashItems", items, 5)
end
