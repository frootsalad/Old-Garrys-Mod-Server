timer.Simple(4, function()
	DarkRP.createCategory{
		name = "Circle Printers",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 119, 255, 255),
		canSee = function(ply) return true end,
		sortOrder = 1
	}

	DarkRP.createEntity("Bronze Printer", {
		ent = "circl_printer_bronze",
		model = "models/props_c17/consolebox01a.mdl",
		price = 2000,
		max = 2,
		category = "Circle Printers",
		cmd = "buybronzepritner"
	})
	
	DarkRP.createEntity("Silver Printer", {
		ent = "circl_printer_silver",
		model = "models/props_c17/consolebox01a.mdl",
		price = 2000,
		max = 2,
		category = "Circle Printers",
		cmd = "buysilverprinter"
	})
	
	DarkRP.createEntity("Platinum Printer", {
		ent = "circl_printer_plat",
		model = "models/props_c17/consolebox01a.mdl",
		price = 2000,
		max = 2,
		category = "Circle Printers",
		cmd = "buyplatinumprinter"
	})
	
	DarkRP.createEntity("Diamond Printer", {
		ent = "circl_printer_diamond",
		model = "models/props_c17/consolebox01a.mdl",
		price = 2000,
		max = 2,
		category = "Circle Printers",
		cmd = "buydiamondserver"
	})
	end)