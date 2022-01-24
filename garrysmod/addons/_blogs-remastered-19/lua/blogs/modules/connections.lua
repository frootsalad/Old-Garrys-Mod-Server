gameevent.Listen("player_connect")

local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Connections"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("player_connect","connect",function(data)
	local ply_steamid64 = data.networkid
	if (data.networkid:find("STEAM_%d:%d:%d+")) then
		ply_steamid64 = util.SteamIDTo64(data.networkid)
	end
	if (data.bot == 0) then
		local country = "(unknown)"
		local ipaddress = data.address
		if (data.address:find("^192%.168")) then
			ipaddress = game.GetIPAddress()
		end
		ipaddress = (ipaddress:gsub(":%d+$",""))
		local function x()
			local function d(name)
				MODULE:Log("{#P|" .. ply_steamid64 .. "|" .. name .. "|#} connected from " .. bLogs:Highlight(country))
			end
			bLogs:OfflineName(ply_steamid64,d,data.name)
		end
		if (ipaddress ~= "0.0.0.0" and ipaddress) then
			http.Fetch("http://lib.venner.io/service/geoip.php?ip=" .. ipaddress,function(body)
				if (body) then
					if (body:find("#!# ")) then
						body = (body:gsub("#!# ",""))
						country = body
						return x()
					end
				end
				x()
			end,x)
		end
	else
		MODULE:Log("A bot joined.")
	end
end)

MODULE:Hook("PlayerInitialSpawn","full_connect",function(ply)
	if (DarkRP and not ply:IsBot()) then
		timer.Create("bLogs_General_Connections_DarkRPVar",0.1,0,function()
			if (ply:getDarkRPVar("rpname")) then
				MODULE:Log(bLogs:FormatPlayer(ply) .. " finished spawning in")
				timer.Remove("bLogs_General_Connections_DarkRPVar")
			end
		end)
	else
		MODULE:Log(bLogs:FormatPlayer(ply) .. " finished spawning in")
	end
end)

MODULE:Hook("PlayerSpawn","player_spawned",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " respawned")
end)

bLogs:AddModule(MODULE)
