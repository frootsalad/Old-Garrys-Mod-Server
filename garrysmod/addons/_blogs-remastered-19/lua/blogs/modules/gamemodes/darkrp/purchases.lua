local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Purchases"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerBoughtVehicle","boughtvehicle",function(ply,ent,cost)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a " .. bLogs:FormatEntity(ent) .. " for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtCustomVehicle","boughtcustomvehicle",function(ply,tbl,ent,cost)
	local name = tbl.name
	if (ent:GetTable()) then
		if (ent:GetTable().PrintName) then
			if (ent:GetTable().PrintName:lower() ~= name:lower()) then
				name = name .. " (" .. ent:GetTable().PrintName .. ")"
			end
		end
	end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a {#V|" .. name .. "|#} for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtCustomEntity","boughtentity",function(ply,tbl,ent,cost)
	local name = tbl.name
	if (ent:GetTable()) then
		if (ent:GetTable().PrintName) then
			if (ent:GetTable().PrintName:lower() ~= name:lower()) then
				name = name .. " (" .. ent:GetTable().PrintName .. ")"
			end
		end
	end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a {#E|" .. name .. "|#} for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtAmmo","boughtammo",function(ply,tbl,ent,cost)
	local name = tbl.name
	if (ent:GetTable()) then
		if (ent:GetTable().PrintName) then
			if (ent:GetTable().PrintName:lower() ~= name:lower()) then
				name = name .. " (" .. ent:GetTable().PrintName .. ")"
			end
		end
	end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought {#E|" .. name .. "|#} ammo for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtShipment","boughtshipment",function(ply,tbl,ent,cost)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a shipment of x" .. (tbl.amount or 1) .. " {#E|" .. tbl.name .. "|#} for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtPistol","boughtpistol",function(ply,tbl,ent,cost)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a shipment of x" .. (tbl.amount or 1) .. " {#E|" .. tbl.name .. "|#} for " .. bLogs:FormatMoney(cost))
end)

MODULE:Hook("playerBoughtFood","boughtfood",function(ply,tbl,ent,cost)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " bought a shipment of x" .. (tbl.amount or 1) .. " {#E|" .. tbl.name .. "|#} for " .. bLogs:FormatMoney(cost))
end)

bLogs:AddModule(MODULE)
