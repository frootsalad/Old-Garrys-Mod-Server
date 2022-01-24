local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Economy"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerDroppedMoney","droppedmoney",function(ply,amount,ent)
	ent.bLogs_Attach = ply
	MODULE:Log(bLogs:FormatPlayer(ply) .. " dropped " .. bLogs:FormatMoney(amount))
end)

MODULE:Hook("playerPickedUpMoney","pickedupmoney",function(ply,amount,ent)
	if (IsValid(ent)) then
		if (IsValid(ent.bLogs_Attach)) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up " .. bLogs:FormatMoney(amount) .. " dropped by " .. bLogs:FormatPlayer(ent.bLogs_Attach))
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up " .. bLogs:FormatMoney(amount))
		end
	else
		MODULE:Log(bLogs:FormatPlayer(ply) .. " picked up " .. bLogs:FormatMoney(amount))
	end
end)

bLogs:AddModule(MODULE)
