--[[
MGANGS - STASH CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"GetUpgrades", "GetGangUpgrades"}, MGangs.Gang,
function(self, name)
	return (name && MGangs.Gang.Data.upgrades[name] || MGangs.Gang.Data.upgrades)
end)

MGangs.Meta:Register({"PurchaseUpgrade", "PurchaseGangUpgrade"}, MGangs.Gang,
function(self, upgType)
	net.Start("MG_PurchaseGangUpgrade")
		net.WriteString(upgType)
	net.SendToServer()
end)