if (not MavNPCModel) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Mav NPC"
MODULE.Name     = "Bought Health"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("bLogs_Maverick_BuyHealth","Maverick_BuyHealth",function(activator,MavHealthCost)
	if (not IsValid(activator)) then return end
	MODULE:Log(bLogs:FormatPlayer(activator) .. " bought health from NPC for " .. bLogs:FormatMoney(MavHealthCost))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Mav NPC"
MODULE.Name     = "Bought Armor"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("bLogs_Maverick_BuyArmor","Maverick_BuyArmor",function(activator,MavArmorCost)
	if (not IsValid(activator)) then return end
	MODULE:Log(bLogs:FormatPlayer(hitman) .. " bought armor from an NPC for " .. bLogs:FormatMoney(MavArmorCost))
end)

bLogs:AddModule(MODULE)