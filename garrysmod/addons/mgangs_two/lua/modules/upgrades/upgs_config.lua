--[[
MGANGS - UPGRADES CONFIG
Developed by Zephruz
]]

MG2_UPGRADES.Config = {}

MG2_UPGRADES.Config.Upgrades = {
	["memberslots"] = {
			default = 5,				-- How many a gang starts with
			upg_increments = 5,		-- How many slots/max cash/etc. is added each upgrade
			upg_cost = 50000,			-- How much each upgrade costs

			-- Don't need to edit below but you can
			fixedname = "Members",			-- Fixed upgrade name, required but you don't have to change it
			prefix = "",								-- Amount prefix
			suffix = " Slots",					-- Amount suffix
		},
	["stashslots"] = {
			default = 12,
			upg_increments = 3,
			upg_cost = 100000,

			-- Don't need to edit below but you can
			fixedname = "Stash Items",
			prefix = "",
			suffix = " Slots",
		},
	["balancecash"] = {
			default = 200000,
			upg_increments = 10000,
			upg_cost = 75000,

			-- Don't need to edit below but you can
			fixedname = "Balance",
			prefix = MGangs.Config.DollarSymbol,
			suffix = "",
		},
}
