--[[
MGANGS - CONFIG SHARED
Developed by Zephruz
]]

--[[
	CONFIG BELOW
]]

-- NOTICE:
-- As you may know, mGangs has modules, those modules also have configuration files.
-- If you'd like to modify them, they are located in their respective module folder (lua/modules/)

-- [[General Config]]
MGangs.Config.Language = "en"									-- Current language
MGangs.Config.GangEntityText = "Create Gang"	-- Text above the gang machine
MGangs.Config.DollarSymbol = "$"							-- Universal dollar symbol for any money values

-- [[Gang Config]]
MGangs.Config.GangCost = {
	enabled = true,		-- Enable/disable the cost of gangs (if set to false, it'll be free to make one)
	cost = 10000,			-- How much the gang costs to make
	type = "darkrp",	-- Type of monetary system, currently only supports DarkRP
}

-- [[Balance Config]]
MGangs.Config.Balance = {
	enabled = true,				-- If you disable this, you will disable any module/addon that uses the gang balance.
	use = "darkrp_cash" 	-- darkrp_cash at the moment, you can add more if you want [YOU NEED LUA EXPERIENCE] (lua/core/sh_globals.lua)
}

-- [[Admin Config]]
MGangs.Config.AdminGroups = {
--["groupname"]		= enabled (true/false),
	["founder"] 	= true,
	["superadmin"] 	= true,
	["admin"] 		= true,
	["moderator"] 	= true,
}

-- [[Misc. Config]]
MGangs.Config.BannedNames = {	-- Banned names (gang names, territory names, etc.)
	-- Misc. Names
	"server",
	"test",

	-- Profanity
	"slut",
	"asshole",
	"bitch",

	-- Patterns (don't delete these)
	"[%p]",
}

MGangs.Config.AllowedImageExts = {
	-- Allowed extensions of images that can be uploaded by a user as their gang icon
	".jpg",
	".png",
	".gif",
	".ico",
}

MGangs.Config.LevelSettings = {
	maxlevel = 200,						-- The highest level achievable by a gang (unless set by an admin)
	xpformula = function(lvl)
		return lvl * (lvl*10)		-- The amount of xp a gang needs to level up. Example: Gang Level 10  * 100 = 1000 xp to level up to gang level 11.
	end,
}
