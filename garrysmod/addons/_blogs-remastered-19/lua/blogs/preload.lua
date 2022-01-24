util.AddNetworkString("blogs_InvalidateData")
bLogs:nets("InvalidateData")
net.Broadcast()

if (not bLogs.Log) then
	bLogs.QueuedLogs = {}
	function bLogs:Log(...)
		table.insert(bLogs.QueuedLogs,{...})
	end
end

util.AddNetworkString("blogs_update_country")
bLogs:netr("update_country",function(ply)
	ply:SetNWString("blogs_country",net.ReadString())
end)

bLogs.DefaultInGameConfig = {
	Permissions = {
		Jobs = {},
		SteamIDs = {},
		Usergroups = {},
	},
	ModulesDisabled = {},
	PrintToConsole = {},
	SendToDiscord = {},
	General = {
		AutoDeleteEnabled = true,
		AutoDelete = 30,
		VolatileLogs = false,
		DisableServerLog = false,
		DisableDarkRPLog = false,
	},
	Info = {
		Team        = true,
		Health      = false,
		Armour      = false,
		Usergroup   = false,
		Weapon      = false,
	},
}

file.CreateDir("blogs")
if (not file.Exists("blogs/config.txt","DATA")) then
	file.Write("blogs/config.txt",util.TableToJSON(bLogs.DefaultInGameConfig))
	bLogs.InGameConfig = table.Copy(bLogs.DefaultInGameConfig)
else
	local c = file.Read("blogs/config.txt","DATA")
	c = util.JSONToTable(c)
	if (c) then
		bLogs.InGameConfig = c

		local ch = false

		for i,v in pairs(bLogs.DefaultInGameConfig) do
			if (table.HasValue({"ModulesDisabled","Permissions","PrintToConsole","SendToDiscord"},i)) then
				if (bLogs.InGameConfig[i] == nil) then
					bLogs.InGameConfig[i] = v
					ch = true
				end
				continue
			end
			if (type(v) == "table") then
				if (bLogs.InGameConfig[i] == nil) then
					bLogs.InGameConfig[i] = v
					ch = true
				elseif (type(v) == "table") then
					for i_,v_ in pairs(v) do
						if (bLogs.InGameConfig[i][i_] == nil) then
							bLogs.InGameConfig[i][i_] = v_
							ch = true
						end
					end
				end
			end
		end

		for i,v in pairs(bLogs.InGameConfig) do
			if (table.HasValue({"ModulesDisabled","Permissions","PrintToConsole","SendToDiscord"},i)) then
				if (bLogs.DefaultInGameConfig[i] == nil) then
					bLogs.InGameConfig[i] = nil
					ch = true
				end
				continue
			end
			if (type(v) == "table") then
				if (bLogs.DefaultInGameConfig[i] == nil) then
					bLogs.InGameConfig[i] = nil
					ch = true
				elseif (type(v) == "table") then
					for i_,v_ in pairs(v) do
						if (bLogs.DefaultInGameConfig[i][i_] == nil) then
							bLogs.InGameConfig[i][i_] = nil
							ch = true
						end
					end
				end
			end
		end

		if (ch) then
			file.Write("blogs/config.txt",util.TableToJSON(bLogs.InGameConfig))
		end
	else
		file.Write("blogs/config.txt",util.TableToJSON(bLogs.DefaultInGameConfig))
		BillyError("bLogs","Looks like the bLogs Config was corrupted! It's been reset and the script is running.")
	end
end

bLogs.Modules = {}

function bLogs:Module() return {
	Hooks = {},
	Hook = function(self,e,i,f,p)
		hook.Add(e,"blogs_m_" .. self.Name .. "_" .. i,f,p or -2)
		table.insert(self.Hooks,{e,"blogs_m_" .. self.Name .. "_" .. i,f})
	end,
	UnHook = function(self,e,i)
		hook.Remove(e,"blogs_m_" .. self.Name .. "_" .. i)
		for x,v in pairs(self.Hooks) do
			if (v[1] == e and v[2] == i) then
				table.remove(x)
				break
			end
		end
	end,
	Log = function(self,log)
		bLogs:Log(self.Category .. "_" .. self.Name,log)
	end,
	Enabled = true,
} end

function bLogs:AddModule(MODULE)
	MODULE.File = (debug.getinfo(2,"S").short_src:gsub("addons/.-/lua/",""))
	bLogs.Modules[MODULE.Category .. "_" .. MODULE.Name] = MODULE
end

bLogs.PlayerLookup = {}
bLogs.PlayerLookupSession = {}
for _,ply in pairs(player.GetHumans()) do
	bLogs.PlayerLookup[ply:SteamID()] = {
		Online = true,
		IP_Address = (ply:IPAddress():gsub(":%d+$","")) or "UNKNOWN",
		Nick = ply:Nick(),
	}
	bLogs.PlayerLookupSession[ply:SteamID()] = {
		Online = true,
		IP_Address = (ply:IPAddress():gsub(":%d+$","")) or "UNKNOWN",
		Nick = ply:Nick(),
	}
end
if (file.Exists("blogs/playerlookup.txt","DATA")) then
	local old_lookup = file.Read("blogs/playerlookup.txt","DATA")
	if (old_lookup) then
		old_lookup = util.JSONToTable(old_lookup)
		if (old_lookup) then
			table.Merge(bLogs.PlayerLookup,old_lookup)
		end
	end
end
file.Write("blogs/playerlookup.txt",util.TableToJSON(bLogs.PlayerLookupSession))
bLogs:hook("PlayerInitialSpawn","PlayerLookup_Add",function(ply)
	if (ply:IsBot()) then return end
	bLogs.PlayerLookup[ply:SteamID()] = {
		Online = true,
		IP_Address = (ply:IPAddress():gsub(":%d+$","")) or "UNKNOWN",
		Nick = ply:Nick(),
	}
	bLogs.PlayerLookupSession[ply:SteamID()] = {
		Online = true,
		IP_Address = (ply:IPAddress():gsub(":%d+$","")) or "UNKNOWN",
		Nick = ply:Nick(),
	}
	file.Write("blogs/playerlookup.txt",util.TableToJSON(bLogs.PlayerLookupSession))
end)
bLogs:hook("PlayerDisconnect","PlayerDisconnect_Remove",function(ply)
	if (ply:IsBot()) then return end
	bLogs.PlayerLookup[ply:SteamID()].Online = false
	bLogs.PlayerLookupSession[ply:SteamID()].Online = false
	file.Write("blogs/playerlookup.txt",util.TableToJSON(bLogs.PlayerLookupSession))
end)
bLogs:hook("onPlayerChangedName","PlayerLookup_UpdateNick",function(ply,old,new)
	if (ply:IsBot()) then return end
	if (not DarkRP) then bLogs:unhook("onPlayerChangedName","PlayerLookup_UpdateNick") return end
	bLogs.PlayerLookup[ply:SteamID()].Nick = new
	bLogs.PlayerLookupSession[ply:SteamID()].Nick = new
	file.Write("blogs/playerlookup.txt",util.TableToJSON(bLogs.PlayerLookupSession))
end)
bLogs:hook("PlayerDeath","PlayerLookup_UpdateNick_Death",function(ply)
	if (ply:IsBot()) then return end
	if (bLogs.PlayerLookup[ply:SteamID()].Nick ~= ply:Nick()) then
		bLogs.PlayerLookup[ply:SteamID()].Nick = ply:Nick()
		bLogs.PlayerLookupSession[ply:SteamID()].Nick = ply:Nick()
		file.Write("blogs/playerlookup.txt",util.TableToJSON(bLogs.PlayerLookupSession))
	end
end) -- just in case PlayerInitialSpawn doesn't give us an accurate Nick or it changes mid-game

function bLogs.LoadModules()
	bLogs:print("Loading modules...")
	local f = file.Find("blogs/modules/*.lua","LUA")
	for _,v in pairs(f) do
		include("blogs/modules/" .. v)
	end
end
function bLogs.LoadDelayedModules()
	if ((GM or GAMEMODE).IsSandboxDerived) then
		local f = file.Find("blogs/modules/sandbox/*.lua","LUA")
		for _,v in pairs(f) do
			include("blogs/modules/sandbox/" .. v)
		end
	end
	local gamemodes = file.Read("blogs/modules/gamemodes/gamemodes.json","LUA")
	gamemodes = util.JSONToTable(gamemodes)
	if (gamemodes[(GM or GAMEMODE).Name] or gamemodes[(GM or GAMEMODE).BaseClass.Name]) then
		local folder = gamemodes[(GM or GAMEMODE).Name] or gamemodes[(GM or GAMEMODE).BaseClass.Name]
		local f = file.Find("blogs/modules/gamemodes/" .. folder .. "/*.lua","LUA")
		for _,v in pairs(f) do
			include("blogs/modules/gamemodes/" .. folder .. "/" .. v)
		end
	end
	for i,v in pairs(bLogs.Config.ForcedModules) do
		if (gamemodes[i] and v == true) then
			local folder = gamemodes[i]
			local f = file.Find("blogs/modules/gamemodes/" .. folder .. "/*.lua","LUA")
			for _,v in pairs(f) do
				include("blogs/modules/gamemodes/" .. folder .. "/" .. v)
			end
		end
	end
	bLogs:print("Modules loaded","good")
end

bLogs.LoadModules()

if (GM or GAMEMODE) then
	bLogs.LoadDelayedModules()
else
	bLogs:print("Waiting for gamemode initalization...")
	hook.Add("Initialize","blogs_load_delayed_modules",bLogs.LoadDelayedModules)
end

hook.Run("bLogs_ModulesLoaded")
