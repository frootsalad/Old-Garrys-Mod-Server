--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
http://wiki.darkrp.com/index.php/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory{
    name = "Staff",
    categorises = "jobs",
    startExpanded = false,
    color = Color(247, 9, 237, 255),
    canSee = function(ply) return true end,
    sortOrder = 999
}

DarkRP.createCategory{
    name = "Security",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 110
}

DarkRP.createCategory{
    name = "Other",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 109
}

DarkRP.createCategory{
    name = "Hitmen",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 108
}

DarkRP.createCategory{
    name = "Drug Dealers",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 107
}

DarkRP.createCategory{
    name = "Government",
    categorises = "jobs",
    startExpanded = true,
    color = Color(20, 55, 255, 255),
    canSee = function(ply) return true end,
    sortOrder = 106
}

DarkRP.createCategory{
    name = "Criminals",
    categorises = "jobs",
    startExpanded = true,
    color = Color(224, 24, 24, 255),
    canSee = function(ply) return true end,
    sortOrder = 105
}

DarkRP.createCategory{
    name = "Custom Jobs",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 112
}
