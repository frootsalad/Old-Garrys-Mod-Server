gameevent.Listen("player_disconnect")

local MODULE = bLogs:Module()

MODULE.Category = "Player Events"
MODULE.Name     = "Disconnections"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("player_disconnect","connect",function(data)
	local ply_steamid64 = data.networkid
	if (data.networkid:find("STEAM_%d:%d:%d+")) then
		ply_steamid64 = util.SteamIDTo64(data.networkid)
	end
	local ply = player.GetBySteamID64(ply_steamid64)
	if (IsValid(ply)) then
		ply = bLogs:FormatPlayer(ply)
	else
		ply = bLogs:FormatPlayer(ply_steamid64)
	end
	MODULE:Log(ply .. " disconnected (" .. bLogs:Highlight((data.reason:gsub("%.$",""):gsub("\\n",""))) .. ")")
end)

bLogs:AddModule(MODULE)
