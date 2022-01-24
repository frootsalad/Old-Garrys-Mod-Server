MsgC("\n\n")
for i,v in pairs(string.ToTable(string.rep("#",59))) do
	MsgC(Color(i * 4.32203389831,255,0),v)
end
MsgC("\n\n")
for i,v in pairs({"  _     _                     "," | |   | |                    "," | |__ | |     ___   __ _ ___ "," | '_ \\| |    / _ \\ / _` / __|"," | |_) | |___| (_) | (_| \\__ \\"," |_.__/|______\\___/ \\__, |___/","                     __/ |    ","                    |___/     ","                    "}) do
	MsgC(string.rep(" ",11))
	for i,_v in pairs(string.ToTable(v)) do
		MsgC(Color(i * 8.5,255,0),_v)
	end
	MsgC("\n")
end
MsgC("\n" .. string.rep(" ",13))
local spaces = ""
for i=1,math.floor(15 - (#bLogs.Version / 2)),1 do
	spaces = spaces .. " "
end
for i,v in pairs(string.ToTable(spaces .. bLogs.Version)) do
	MsgC(Color(i * 8.5,255,0),v)
end
MsgC("\n\n" .. string.rep(" ",13))
local spaces = ""
for i=1,math.floor(15 - (#("Licensed to " .. bLogs.Licensee) / 2)),1 do
	spaces = spaces .. " "
end
for i,v in pairs(string.ToTable(spaces .. "Licensed to " .. bLogs.Licensee)) do
	MsgC(Color(i * 8.5,255,0),v)
end
MsgC("\n\n\n")
for i,v in pairs(string.ToTable(string.rep("#",59))) do
	MsgC(Color(i * 4.32203389831,255,0),v)
end
MsgC("\n\n")

bLogs.EnglishLanguage = {

	-- First column in the logs, shows the date/time of the log
	when = "When",

	permission_failure = "You don't currently have permission to do this.",

	-- When the user is an admin, this will be in the window title.
	admin_mode = "Admin Mode",

	-- The button to view all logs stored.
	all_logs = "All Logs",

	-- The button to view all players stored in bLogs.
	all_players = "All Players",

	-- The tab at the top to view players stored in bLogs.
	players = "Players",

	-- The message shown to the player when they first open bLogs.
	getting_data = "Getting data, please wait...",

	-- The message shown when there's no logs to show.
	no_data = "No data!",

	advanced_search = "Advanced Search",
	quick_search = "Quick Search",
	search = "Search",

	-- The button to open the SteamID Finder (steamid.venner.io)
	steamid_finder = "SteamID Finder",

	-- The message in the players panel instructing the user to select something
	-- to view players.
	select_something = "Select something",

	-- The button at the pagination that allows you to jump to a specific page.
	jump = "Jump",

	-- The title of the window that pops up when you click "Jump"
	jump_to_page = "Jump to page...",

	-- The text in that window instructing the user.
	-- %d is the number of pages that exist
	type_page = "Type a page number (there are %d pages)",

	cancel = "Cancel",

	error_over_pagenum = "That page of logs doesn't exist",
	error_not_num = "That wasn't a number",

	error = "Error",

	-- Left click to copy [player] name
	involved_tooltip = "Right click for options",

	-- View logs that that this player is involved in
	view_player_logs = "View Player Logs",

	-- Copy [something] [to clipboard]
	copy = "Copy %s",

	profile = "Steam Profile",

	left_click_to_copy = "Left click to copy",

	modules = "Modules",

	custom = "Custom",

	enter_a_steamid = "Enter a SteamID...",

	error_not_steamid = "That wasn't a SteamID.",

	-- Used in the advanced search box
	-- "Does the log contain this text?"
	contains = "And contains...",

	-- "Colour Mode" is whether or not the logs are shown with coloured text.
	colour_mode = "Colour Mode",

	jump_to_date = "Jump to Date",

	jump_to_date_tooltip = "Right click to jump to a date/time",

	type_date = "Enter a date. It must be in this format: DD/MM/YYYY (%s/%s/%s)",

	error_not_date = "That wasn't a valid date. It must be in this format: DD/MM/YYYY (%s/%s/%s)",

	type_time = "Enter a timestamp. It must be in this format: HH:MM (%s:%s) (24 hour)\nLeave blank to ignore time.",

	error_not_time = "That wasn't a valid timestamp. It must be in this format: HH:MM (%s:%s) (24 hour)",

	archive = "Archive",

	searching = "Searching",

	search_archive = "Search Archive",

	search_archive_warning = "Searching the archive can lag the server on local databases. Only use if needed.",

	logging = "Logging",

	save = "Save",

	enabled = "Enabled",

	disabled = "Disabled",

	disable = "Disable",

	enable = "Enable",

	give = "Give",

	take = "Take",

	new_steamid = "New SteamID",

	new_usergroup = "New Usergroup",

	usergroup_name = "Usergroup Name",

	-- "Delete this entry from permissions"
	delete_entry = "Delete Entry",

	usergroup_exists = "That usergroup already exists in the permissions! Is there a CAMI usergroup for that? Use that if so.",

	steamid_exists = "That SteamID already exists in the permissions.",

	loading = "Loading...",

	support = "Support",

	-- "Player Format" is a setting that contains everything that will be included
	-- in a log that references a player. For example, it will show the player's job,
	-- health, armour, etc. depending on the settings.
	player_format = "Player Format",

	permissions = "Permissions",

	general_settings = "General Settings",

	operations = "Operations",

	player_lookup = "Player Lookup",

	help = "Help",

	help_tooltip = "Click here to open the wiki",

	open_blogs_web = "Open bLogs Web",
	open_blogs_web_tooltip = "bLogs Web is available for you to use, and will provide a better user experience. You can leave it open in your Steam browser and access it any time. Just click here.",

}

if (CLIENT) then
	if (not file.Exists("blogs_language.txt","DATA")) then
		file.Write("blogs_language.txt","English")
	end
	bLogs.SelectedLanguage = file.Read("blogs_language.txt","DATA")
	bLogs.SelectedLanguage = bLogs.SelectedLanguage:sub(1,1):upper() .. bLogs.SelectedLanguage:sub(2)
	if (bLogs.SelectedLanguage ~= "English") then
		if (not file.Exists("blogs/lang/" .. bLogs.SelectedLanguage .. ".lua","LUA")) then
			bLogs.SelectedLanguage = "English"
		else
			include("blogs/lang/" .. bLogs.SelectedLanguage .. ".lua")
		end
	else
		bLogs.Language = nil
	end
end

if (file.Exists("blogs_version.dat","DATA")) then

	local version_changes = {

	}

	if (version_changes[file.Read("blogs_version.dat","DATA")]) then
		version_changes[file.Read("blogs_version.dat","DATA")]()
		file.Write("blogs_version.dat",bLogs.Version)
	end

end

require("billyerror")

function bLogs:print(msg,type)
	if (type == "error" or type == "bad") then
		MsgC(Color(255,0,0),"[bLogs] ",Color(255,255,255),msg .. "\n")
	elseif (type == "success" or type == "good") then
		MsgC(Color(0,255,0),"[bLogs] ",Color(255,255,255),msg .. "\n")
	else
		MsgC(Color(0,255,255),"[bLogs] ",Color(255,255,255),msg .. "\n")
	end
end

function bLogs:hook(h,i,f)
	hook.Remove(h,"blogs_" .. i)
	hook.Add(h,"blogs_" .. i,f)
end
function bLogs:unhook(h,i)
	hook.Remove(h,"blogs_" .. i)
end

function bLogs:nets(m)
	net.Start("blogs_" .. m)
end
function bLogs:netr(m,f)
	if (SERVER) then
		net.Receive("blogs_" .. m,function(l,p)
			f(p)
		end)
	else
		net.Receive("blogs_" .. m,f)
	end
end

function bLogs:timer(i,d,r,f)
	timer.Create("blogs_" .. i,d,r,f)
end
function bLogs:untimer(i)
	timer.Remove("blogs_" .. i)
end

include("blogs_config.lua")
if (not bLogs.Config) then
	BillyError("bLogs","There's a syntax error with your bLogs config. Please check your SERVER console for more information. We remind you that your config errors are not the developers' problem and you must fix them yourself.")
	include("blogs/default_config.lua")
end

if (bLogs.Config.DefaultLanguage ~= "English") then
	if (file.Exists("blogs/lang/" .. bLogs.Config.DefaultLanguage .. ".lua","LUA")) then
		include("lang/" .. bLogs.Config.DefaultLanguage .. ".lua")
	else
		if (CLIENT) then BillyError("bLogs","That language does not exist. Please fix config.DefaultLanguage in your bLogs config.") end
		bLogs.Config.DefaultLanguage = "English"
	end
end

CreateConVar("blogs_permissions_debug",0,FCVAR_SERVER_CAN_EXECUTE)
local function permissions_debug(str)
	if (GetConVar("blogs_permissions_debug")) then
		if (GetConVar("blogs_permissions_debug"):GetBool() == true) then
			bLogs:print(str)
		end
	end
end
function bLogs:IsMaxPermitted(ply)
	if (not ply and CLIENT) then ply = LocalPlayer() end
	for _,v in pairs(bLogs.Config.MaxPermitted) do
		if (v == ply:SteamID() or v == ply:SteamID64() or v == ply:Team() or v == ply:GetUserGroup()) then
			permissions_debug("SteamID, SteamID64, job/team or usergroup is MaxPermitted.")
			return true
		elseif (type(v) == "function") then
			if (v(ply,to_what)) then
				permissions_debug("MaxPermitted function called and returned true.")
				return true
			end
		end
	end
	return false
end
function bLogs:HasAccess(ply,to_what)
	if (to_what == nil) then to_what = "Menu" end
	permissions_debug("Checking " .. ply:Nick() .. " for access to " .. to_what)
	if (bLogs:IsMaxPermitted(ply)) then
		permissions_debug("They are MaxPermitted.")
		return true
	end
	local r = false
	if (bLogs.InGameConfig.Permissions.Jobs[team.GetName(ply:Team())]) then
		if (bLogs.InGameConfig.Permissions.Usergroups[ply:GetUserGroup()].Menu == true) then
			if (bLogs.InGameConfig.Permissions.Jobs[team.GetName(ply:Team())][to_what] == true) then
				permissions_debug("Their job has permission.")
				r = true
			end
		end
	end
	if (bLogs.InGameConfig.Permissions.Usergroups[ply:GetUserGroup()]) then
		if (bLogs.InGameConfig.Permissions.Usergroups[ply:GetUserGroup()].Menu == true) then
			if (bLogs.InGameConfig.Permissions.Usergroups[ply:GetUserGroup()][to_what] == true) then
				permissions_debug("Their usergroup has permission.")
				r = true
			end
		end
	end
	if (bLogs.InGameConfig.Permissions.SteamIDs[ply:SteamID()]) then
		if (bLogs.InGameConfig.Permissions.Usergroups[ply:GetUserGroup()].Menu == true) then
			if (bLogs.InGameConfig.Permissions.SteamIDs[ply:SteamID()][to_what] == true) then
				permissions_debug("Their SteamID has permission.")
				r = true
			end
		end
	end
	if (r == false) then
		permissions_debug("They do not have permission.")
	end
	return r
end

function bLogs:t(p)
	if (bLogs.Language) then
		if (bLogs.Language[p]) then
			return bLogs.Language[p]
		end
	end
	return bLogs.EnglishLanguage[p] or p
end

function bLogs:FormatVehicle(ent)
	local s = ""
	s = s .. bLogs:FormatEntity(ent)
	if (IsValid(ent.bLogs_Creator)) then
		s = s .. " created by " .. bLogs:FormatPlayer(ent.bLogs_Creator)
		if (IsValid(ent:GetDriver())) then
			s = s .. " and driven by " .. bLogs:FormatPlayer(ent.bLogs_Creator)
		end
	else
		if (IsValid(ent:GetDriver())) then
			s = s .. " driven by " .. bLogs:FormatPlayer(ent.bLogs_Creator)
		end
	end
	return s
end

function bLogs:MarkupColour(c)
	return c.r .. "," .. c.g .. "," .. c.b .. "," .. c.a
end
function bLogs:EscapeMarkup(s)
	return (s:gsub("([<>])",{
		["<"] = "&lt;",
		[">"] = "&gt;",
	}))
end
function bLogs:Unformat(s)
	local x = {}
	local r = {
		["{#P%|(%d+)%|(.-)%|#}"] = "<color=" .. bLogs_PlayerColor .. ">%2</color>", -- Player
		["{#V%|(.-)%|#}"] = "<color=" .. bLogs_VehicleColor .. ">%1</color>", -- Vehicle
		["{#E%|(.-)%|#}"] = "<color=" .. bLogs_EntityColor .. ">%1</color>", -- Entity
		["{#%$%|(.-)%|#}"] = "<color=" .. bLogs_MoneyColor .. ">%1</color>", -- Money
		["{#H%|(.-)%|#}"] = "<color=" .. bLogs_HighlightColor .. ">%1</color>", -- Miscellaneous
	}
	for i,v in pairs(r) do
		if (i:find("P")) then
			for steamid,nick in s:gmatch(i) do
				x[steamid] = nick
			end
		end
		s = (s:gsub(i,v))
	end
	return x,s
end
function bLogs:PlainTextLog(s)
	i,s = bLogs:Unformat(s)
	return (s:gsub("<colou?r=.->(.-)<%/colou?r>","%1"))
end

local Breach_Teams
local TTT_Teams
function bLogs:FormatPlayer(ply)
	if (ConVarExists("br_roundrestart") and not Breach_Teams) then
		Breach_Teams = {
			[0] = "None",
			[TEAM_SCP] = "SCP",
			[TEAM_GUARD] = "MTF Guard",
			[TEAM_CLASSD] = "Class Ds",
			[TEAM_SPEC] = "Spectator",
			[TEAM_SCI] = "Scientist",
			[TEAM_CHAOS] = "Chaos Insurgency",
		}
	end
	if ((GM or GAMEMODE).Folder == "gamemodes/terrortown" and not TTT_Teams) then
		TTT_Teams = {
			[ROLE_TRAITOR] = "Traitor",
			[ROLE_INNOCENT] = "Innocent",
			[ROLE_DETECTIVE] = "Detective",
		}
	end
	local s = ""
	if (type(ply) == "string") then
		if (ply:find("^STEAM_%d:%d:%d+$")) then
			ply = util.SteamIDTo64(ply)
			s = s .. "{#P|" .. ply .. "|#}"
		end
		if (not ply:find("^7656119%d+$")) then
			ply = "UNKNOWN/BOT"
			s = s .. "{#H|" .. ply .. "|#}"
		end
	else
		if (not IsValid(ply)) then return "(disconnected player/CONSOLE)" end
		if (not ply:IsPlayer()) then return bLogs:FormatEntity(ply) end
		if (ply:IsBot()) then
			s = s .. "{#H|BOT|#}"
			return s
		end
		if (not ply:IsPlayer()) then
			s = s .. "{#H|INVALID|#}"
			return s
		end
		s = s .. "{#P|" .. ply:SteamID64() .. "|" .. bLogs:EscapeMarkup(ply:Nick()) .. "|#}"
		if (bLogs.InGameConfig) then
			if (table.HasValue(bLogs.InGameConfig.Info,true)) then
				if (bLogs.InGameConfig.Info.Usergroup) then
					s = s .. " [" .. bLogs:Highlight(ply:GetUserGroup()) .. "]"
				end
				if (bLogs.InGameConfig.Info.Team) then
					if (ply:Team() ~= TEAM_CONNECTING) then
						if ((GM or GAMEMODE).Folder == "gamemodes/terrortown") then
							s = s .. " [" .. bLogs:Highlight((TTT_Teams[ply:GetRole()] or team.GetName(ply:Team()))) .. "]"
						elseif (ConVarExists("br_roundrestart")) then
							s = s .. " [" .. bLogs:Highlight((Breach_Teams[ply:GTeam()] or team.GetName(ply:Team()))) .. "]"
						else
							s = s .. " [" .. bLogs:Highlight(team.GetName(ply:Team())) .. "]"
						end
					end
				end
				if (bLogs.InGameConfig.Info.Weapon) then
					if (IsValid(ply:GetActiveWeapon())) then
						s = s .. " [" .. bLogs:FormatEntity(ply:GetActiveWeapon()) .. "]"
					end
				end
				if (bLogs.InGameConfig.Info.Health) then
					s = s .. " [" .. bLogs:Highlight(math.Round(ply:Health()) .. "h") .. "]"
				end
				if (bLogs.InGameConfig.Info.Armour) then
					s = s .. " [" .. bLogs:Highlight("+" .. math.Round(ply:Armor()) .. "h") .. "]"
				end
			end
		end
	end
	return s
end
function bLogs:Escape(str)
	return (string.gsub(tostring(str),"\\","\\\\"):gsub("%{#.?%|(.-)%|#%}","{##|%1|##}"):gsub("([<>])",{
		["<"] = "&lt;",
		[">"] = "&gt;",
	}))
end
function bLogs:ReverseEscape(str)
	return (str:gsub("%{##%|(%d+)%|##%}","{#|%1|#}"))
end

function bLogs:GetPrintName(ent)
	local success,n = xpcall(function()  return ent:GetPrintName() end,function() end)

	local blacklist = {
		"<MISSING SWEP PRINT NAME>",
		"<MISSING SENT PRINT NAME>",
		"Scripted Weapon",
		"Scripted Entity",
	} -- when your PrintName is only on the client realm 😂👌

	if (success) then
		if (n ~= nil) then
			if (type(n) == "table") then
				if (n.Name) then
					return n.Name
				end
			elseif (type(n) == "string") then
				if (n:len() ~= 0) then
					if (not table.HasValue(blacklist,n)) then
						return n
					end
				end
			end
		end
	end

	local tbl = ent:GetTable()
	if (tbl) then
		if (tbl.PrintName) then
			if (not table.HasValue(blacklist,tbl.PrintName)) then
				return tbl.PrintName
			end
		end
	end

	if (bLogs.Config.EntityNames[ent:GetClass()]) then
		return bLogs.Config.EntityNames[ent:GetClass()]
	end

	return ent:GetClass()
end

function bLogs:FormatEntity(ent)
	if (not IsValid(ent)) then return "{#E|(invalid entity)|#}" end
	if (ent:IsWeapon()) then
		return "{#E|" .. bLogs:GetPrintName(ent) .. "|#}"
	end
	if (ent:IsVehicle()) then
		return "{#V|" .. bLogs:GetPrintName(ent) .. "|#}"
	else
		return "{#E|" .. bLogs:GetPrintName(ent) .. "|#}"
	end
end

function bLogs:FormatNumber(n)
	while true do
		n,k = string.gsub(n,"^(-?%d+)(%d%d%d)","%1,%2")
		if (k == 0) then
			break
		end
	end
	return n
end

function bLogs:FormatMoney(money)
	if (not tonumber(money)) then
		return "?"
	elseif (not money) then
		return "?"
	end
	money = bLogs:FormatNumber(tonumber(money))
	if ((GM or GAMEMODE).Config.currencyLeft == true) then
		return "{#$|" .. (GM or GAMEMODE).Config.currency .. money .. "|#}"
	else
		return "{#$|" .. money .. (GM or GAMEMODE).Config.currency .. "|#}"
	end
end

function bLogs:Highlight(s)
	return "{#H|" .. s .. "|#}"
end

function bLogs:FormatLongDate(time)
	return os.date("%a %d/%m/%Y %I:%M:%S %p",time)
end

function bLogs:FormatTime(time)
	local s = ""
	return os.date("%I:%M:%S %p %d/%m/%y",time)
	--[[
	if (os.date("%d/%m/%Y",time) == os.date("%d/%m/%Y")) then
		local when = math.floor(((os.time() - time) / 60 ) / 60)
		if (when == 0 or when == -1) then
			when = math.floor((os.time() - time) / 60)
			if (when == 0 or when == -1) then
				when = (os.time() - time)
				if (when ~= 1) then
					s = "s"
				end
				if (when == 0 or when == -1) then
					return "Just now"
				else
					return when .. " second" .. s .. " ago"
				end
			else
				if (when ~= 1) then
					s = "s"
				end
				return when .. " minute" .. s .. " ago"
			end
		else
			if (when ~= 1) then
				s = "s"
			end
			return when .. " hour" .. s .. " ago"
		end
	elseif (os.date("%m/%Y",time) == os.date("%m/%Y")) then
		if ((os.date("%d") - os.date("%d",time)) <= 7) then
			when = os.date("%d") - os.date("%d",time)
			if (when ~= 1) then
				s = "s"
			end
			return when .. " day" .. s .. " ago"
		else
			return os.date("%d/%m/%Y",time)
		end
	else
		return os.date("%d/%m/%Y",time)
	end]]
end

local function e(s)
	return bLogs.Database:escape(s)
end
local function q(query,cb)
	if (type(query) == "table") then
		local r = {}
		local i = 0
		local function s(query,i,r,cb)
			i = i + 1
			local qu = bLogs.Database:query(query[i])
			local data = {}
			qu.onData = function(_,d)
				data[#data + 1] = d
			end
			qu.onSuccess = function()
				table.insert(r,data)
				if (i == #query) then
					if (cb) then
						cb(r)
					end
				else
					s(query,i,r,cb)
				end
			end
			qu:start()
		end
		s(query,i,r,cb)
	else
		local qu = bLogs.Database:query(query)
		local data = {}
		qu.onData = function(_,d)
			data[#data + 1] = d
		end
		qu.onSuccess = function()
			if (cb) then
				cb(data)
			end
		end
		qu:start()
	end
end

function bLogs:OfflineName(steamid64,cb,fb)
	local ply = player.GetBySteamID64(steamid64)
	if (IsValid(ply)) then
		if (bLogs.Database) then
			q("INSERT INTO `blogs_players` (`steamid64`,`name`) VALUES('" .. e(steamid64) .. "','" .. e(ply:Nick()) .. "') ON DUPLICATE KEY UPDATE `name`='" .. e(ply:Nick()) .. "'")
		end
		cb(ply:Nick())
		return
	end
	local function drp()
		DarkRP.offlinePlayerData(util.SteamIDFrom64(steamid64),function(data)
			if (not data) then
				if (fb) then
					cb(fb)
				else
					cb("Unknown")
				end
				return
			end
			data = data[1]
			if (bLogs.Database) then
				q("INSERT INTO `blogs_players` (`steamid64`,`name`) VALUES('" .. e(steamid64) .. "','" .. e(data.rpname) .. "') ON DUPLICATE KEY UPDATE `name`='" .. e(data.rpname) .. "'")
			end
			cb(data.rpname)
		end,function()
			if (fb) then
				cb(fb)
			else
				cb("Unknown")
			end
		end)
	end
	if (not bLogs.Database) then
		if (DarkRP) then
			if (DarkRP.offlinePlayerData) then
				drp()
			elseif (fb) then
				cb(fb)
			else
				cb("Unknown")
			end
		elseif (fb) then
			cb(fb)
		else
			cb("Unknown")
		end
	else
		q("SELECT `name` FROM `blogs_players` WHERE `steamid64`='" .. e(steamid64) .. "'",function(r)
			if (#r > 0) then
				cb(r[1].name)
			elseif (DarkRP) then
				drp()
			elseif (fb) then
				cb(fb)
			else
				cb("Unknown")
			end
		end)
	end
end

if (SERVER) then
	include("preload.lua")

	if (#player.GetHumans() > 0) then
		if (file.Exists("blogs/sv.lua","LUA")) then
			include("blogs/sv.lua")
		else
			include("blogs/ext.lua")
		end
	else
		bLogs:print("Waiting for a player to join the server...","good")
		bLogs:print("If nothing happens after this, another addon is interfering.")
		bLogs:hook("PlayerInitialSpawn","load_hook",function()
			timer.Simple(0,function()
				if (file.Exists("blogs/sv.lua","LUA")) then
					include("blogs/sv.lua")
				else
					include("blogs/ext.lua")
				end
			end)
			bLogs:unhook("PlayerInitialSpawn","load_hook")
		end)
	end
else
	include("blogs/cl.lua")
end
