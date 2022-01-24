local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Cheques"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerDroppedCheque","droppedcheque",function(dropper,written,cost)
	MODULE:Log(bLogs:FormatPlayer(dropper) .. " dropped a cheque of " .. bLogs:FormatMoney(cost) .. " for " .. bLogs:FormatPlayer(written))
end)

MODULE:Hook("playerPickedUpCheque","pickedupcheque",function(dropper,written,cost,success)
	if (not success) then return end
	MODULE:Log(bLogs:FormatPlayer(written) .. " cashed a cheque of " .. bLogs:FormatMoney(cost) .. " from " .. bLogs:FormatPlayer(dropper))
end)

MODULE:Hook("playerToreUpCheque","torecheque",function(dropper,written,cost)
	MODULE:Log(bLogs:FormatPlayer(dropper) .. " tore up a cheque of " .. bLogs:FormatMoney(cost) .. " meant for " .. bLogs:FormatPlayer(written))
end)

bLogs:AddModule(MODULE)
