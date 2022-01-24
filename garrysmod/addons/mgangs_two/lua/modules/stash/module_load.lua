--[[
MGANGS - STASH LOAD
Developed by Zephruz
]]

MGangs.Module.mods.stash = {}

MG2_STASH = MGangs.Module.mods.stash
MG2_STASH.DepositTypes = (MG2_STASH.DepositTypes or {})

if (SERVER) then
	include("server/sv_stsh_load.lua")
	AddCSLuaFile("client/cl_stsh_load.lua")
end

if (CLIENT) then
	include("client/cl_stsh_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

-- Register Permissions
MGangs.Gang:RegisterPermissions("Stash", "Deposit Items")
MGangs.Gang:RegisterPermissions("Stash", "Withdraw Items")

-- [[ MODULE-RELATED REGISTRATION ]]
function MG2_STASH:RegisterDepositType(name, data)
	MG2_STASH.DepositTypes[name] = data

	return MG2_STASH.DepositTypes[name]
end

function MG2_STASH:GetDepositTypes()
	return self.DepositTypes
end

-- DARKRP POCKET
-- I need to disect the data and turn it into a global format for the stash
-- So when withdrawing something it assigns it the correct class name and data table
-- We can't have shipments merging together because they have the same classname.

-- Deposit: Format the data to fit to the structure of the table
-- Withdraw: Spawn ent by column class, assign any data table [data] to the ent when its spawned

MG2_STASH:RegisterDepositType("drp_pocket", {
	name = "Pocket",
	check = function()
		return DarkRP	-- Check if DarkRP exists
	end,
	menu = {
		icon = "icon16/basket.png",
		items = function()
			return (LocalPlayer():getPocketItems() or {})	-- Return table of items
		end,
	},
	meta = {
		withdraw = function(ply, itemData, amt)	-- When an item is withdrawn from the gang stash
			for i=1,amt do
				local tempEnt = ents.Create(itemData.class)
				tempEnt:Spawn()
				tempEnt:Activate()

				ply:addPocketItem(tempEnt)
			end

			return true
		end,
		deposit = function(ply, itemData)	-- When an item is deposited into the gang stash
			local items = ply.darkRPPocket
			local waTbl = {
				["spawned_weapon"] = function(data)
					return (data.DT && data.DT.WeaponClass || false)
				end,
			}

			local iData = items[itemData._key]

			if (iData) then
				if (waTbl[iData.Class]) then
					itemData.class = waTbl[iData.Class](iData)

					if !(itemData.class) then return false end
				end

				ply:removePocketItem(itemData._key)

				return true
			end

			return false
		end,
	},
})

-- IDINVENTORY
MG2_STASH:RegisterDepositType("idinventory", {
	name = "Inventory",
	check = function()
		return IDInv
	end,
	menu = {
		icon = "icon16/briefcase.png",
		items = function()
			return (IDInv && IDInv.Handlers && IDInv.Handlers.Inventory or {})
		end,
	},
	meta = {
		withdraw = function(ply, itemData, amt)
			ply:GiveItem(itemData.class, itemData.model, amt)

			return true
		end,
		deposit = function(ply, itemData)
			local inv = ply:FetchInventory()

			for i=1,#inv do
				local item = inv[i]

				if (itemData.slotpos == item.slotpos) then
					if (item.amt <= 1) then
						table.remove(inv, i)
					else
						item.amt = item.amt - 1
					end

					break
				end
			end

			ply:UpdateInventory(inv)

			return true
		end,
	},
})

hook.Run("MG2.STASH.LoadDepositTypes", MG2_STASH)
