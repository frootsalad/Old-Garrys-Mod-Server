local MODULE = bLogs:Module()

MODULE.Category = "TTT"
MODULE.Name     = "Equipment"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("TTTOrderedEquipment","tttequipment",function(ply,equipment,is_item)
	if (type(equipment) == "string") then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " bought " .. bLogs:Highlight(equipment))
	else
		local name
		for _,v in pairs(EquipmentItems) do
			for _,_v in pairs(v) do
				if (_v.id == equipment) then
					name = _v.name
					break
				end
			end
		end
		if (name) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " bought " .. bLogs:Highlight(name))
		end
	end
end)

bLogs:AddModule(MODULE)
