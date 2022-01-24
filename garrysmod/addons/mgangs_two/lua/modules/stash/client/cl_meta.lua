--[[
MGANGS - STASH CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"GetStashItems", "GetGangStashItems"}, MGangs.Gang,
function(self)
	local gangData = self:GetGangData()
	
	local gangStashItems = table.Copy(gangData.stashitems)

	function sortByClass(a,b)
		return a.class > b.class
	end

	table.sort(gangStashItems, sortByClass)
	
	return gangStashItems
end)

MGangs.Meta:Register({"DepositItem", "DepositStashItem"}, MGangs.Gang,
function(self, invType, itemData)	
	net.Start("MG_DepositStashItem")
		net.WriteString(invType)
		net.WriteTable(itemData)
	net.SendToServer()
end)

MGangs.Meta:Register({"WithdrawItem", "WithdrawStashItem"}, MGangs.Gang,
function(self, invType, itemData, itemWDAmt)
	net.Start("MG_WithdrawStashItem")
		net.WriteString(invType)
		net.WriteTable(itemData)
		net.WriteInt(itemWDAmt, 32)
	net.SendToServer()
end)