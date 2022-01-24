--[[
MGANGS - STASH CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/stash/stsh_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

MG2_STASH.ModelTypes = {
	{
		types = {"weapon_", "spawned_weapon", "m9k_"},
		values = {
			pos = Vector( 50, 50, 40 ),
			lookat = Vector( 15, 15, 15 ),
			fov = 30,
		},
	},
	{
		types = {"item_", "item_ammo", "item_box", "item_health", "spawned_food", "spawned_ammo"},
		values = {
			pos = Vector( 50, 50, 50 ),
			lookat = Vector( 15, 15, 19 ),
			fov = 19,
		},
	},
	{
		types = {"spawned_shipment"},
		values = {
			pos = Vector( 50, 50, 50 ),
			lookat = Vector( 15, 15, 22 ),
			fov = 40,
		},
	},
	{
		types = {"prop_vehicle"},
		values = {
			pos = Vector( 50, 50, 50 ),
			lookat = Vector( 15, 15, 22 ),
			fov = 100,
		},
	},
}

MGangs.Derma:RegisterGangInfo("Stash Info", {
	{name = "Items", val = function(gd)
		local items = MGangs.Gang:GetStashItems()
		local amt = 0
		
		for i=1,#items do
			local item = items[i]
			
			amt = amt + (item.amt or item.amount or 1)
		end
	
		return amt .. " / " .. (MGangs.Gang:GetUpgrades("stashslots")) 
	end, header = false},
})

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.STASH",
function(data, noreset)
	data.stashitems = (noreset && data.stashitems || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG.Send.GangStashItems",
function(len)
	local curSplit = net.ReadInt(32)
	local gangItems = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.stashitems = gangItems
	else
		table.Merge(MGangs.Gang.Data.stashitems,gangItems)
	end
end)