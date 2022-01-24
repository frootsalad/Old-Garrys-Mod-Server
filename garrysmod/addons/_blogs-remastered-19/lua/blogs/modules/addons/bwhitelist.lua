if (not BWhitelist) then return end

local MODULE = bLogs:Module()

MODULE.Category = "BWhitelist"
MODULE.Name     = "Whitelists"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("bwhitelist_add_to_whitelist","remove_from_whitelist",function(is_usergroup,team,value,ply)
	local who
	if (not ply) then
		who = "{#H|(CONSOLE)|#}"
	else
		who = bLogs:FormatPlayer(ply)
	end
	if (is_usergroup) then
		MODULE:Log(who .. " added " .. bLogs:Highlight(bLogs:Highlight(value)) .. " to the whitelist for " .. bLogs:Highlight(team))
	else
		MODULE:Log(who .. " added " .. bLogs:FormatPlayer(util.SteamIDTo64(value)) .. " to the whitelist for " .. bLogs:Highlight(team))
	end
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "BWhitelist"
MODULE.Name     = "Unwhitelists"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("bwhitelist_remove_from_whitelist","remove_from_whitelist",function(is_usergroup,team,value,ply)
	local who
	if (not ply) then
		who = "{#H|(CONSOLE)|#}"
	else
		who = bLogs:FormatPlayer(ply)
	end
	if (is_usergroup) then
		MODULE:Log(who .. " removed " .. bLogs:Highlight(bLogs:Highlight(value)) .. " from the whitelist for " .. bLogs:Highlight(team))
	else
		MODULE:Log(who .. " removed " .. bLogs:FormatPlayer(util.SteamIDTo64(value)) .. " from the whitelist for " .. bLogs:Highlight(team))
	end
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "BWhitelist"
MODULE.Name     = "Whitelists cleared"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("bwhitelist_clear_whitelist","remove_from_whitelist",function(team,ply)
	local who
	if (not ply) then
		who = "{#H|(CONSOLE)|#}"
	else
		who = bLogs:FormatPlayer(ply)
	end
	MODULE:Log(who .. " cleared the whitelist for " .. bLogs:Highlight(team))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "BWhitelist"
MODULE.Name     = "Whitelists disabled"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("bwhitelist_disable_whitelist","remove_from_whitelist",function(team,ply)
	local who
	if (not ply) then
		who = "{#H|(CONSOLE)|#}"
	else
		who = bLogs:FormatPlayer(ply)
	end
	MODULE:Log(who .. " disabled the whitelist for " .. bLogs:Highlight(team))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "BWhitelist"
MODULE.Name     = "Whitelists enabled"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("bwhitelist_enable_whitelist","remove_from_whitelist",function(team,ply)
	local who
	if (not ply) then
		who = "{#H|(CONSOLE)|#}"
	else
		who = bLogs:FormatPlayer(ply)
	end
	MODULE:Log(who .. " enabled the whitelist for " .. bLogs:Highlight(team))
end)

bLogs:AddModule(MODULE)
