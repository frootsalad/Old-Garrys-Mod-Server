--[[

	What is this? -> https://support.gmodsto.re/console.log

]]

--[[

	LICENSE

	https://creativecommons.org/licenses/by-nc-nd/4.0/

	Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)

]]

--////////////////////////////////////////////////////////////////////////--

local domain = "support.gmodsto.re"

concommand.Add("blib_consolelog", function(ply, _, args)
	if (IsValid(ply)) then
		ply:SendLua([[
			MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "You are using the wrong console... https://]] .. domain .. [[/console.log", "\n")
		]])
		return
	end

	local authentication_code = args[1]

	if (not authentication_code) then
		MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "We were unable to upload your console.log as you did not provide an authentication code. https://" .. domain .. "/console.log", "\n")
		return
	end
	if (#player.GetHumans() == 0) then
		MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Please have a player join the server before performing this operation.", "\n")
		return
	end
	if (not file.Exists("console.log", "GAME")) then
		MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "We couldn't find your console.log as it does not exist in your server. https://" .. domain .. "/console.log", "\n")
		return
	end

	--[[
		-- Seems to crash servers
		local console_log_start_1 = string.find(console_log, ".*" .. string.PatternSafe("WS: No +host_workshop_collection or it is invalid!"))
		local console_log_start_2 = string.find(console_log, ".*" .. string.PatternSafe("WS: Waiting for Steam to log us in...."))
		if (console_log_start_1 and not console_log_start_2) then
			console_log = string.sub(console_log, console_log_start_1)
		elseif (console_log_start_2 and not console_log_start_1) then
			console_log = string.sub(console_log, console_log_start_2)
		elseif (console_log_start_1 and console_log_start_2) then
			if (console_log_start_1 > console_log_start_2) then
				console_log = string.sub(console_log, console_log_start_1)
			else
				console_log = string.sub(console_log, console_log_start_2)
			end
		end
	]]

	MsgC(Color(0,255,255), "[bLib] ", Color(255,255,255), "Reading console.log...", "\n")

	local console_log_raw = file.Read("console.log", "GAME")

	MsgC(Color(0,255,255), "[bLib] ", Color(255,255,255), "Plucking console.log...", "\n")

	local console_log_lines = string.Explode("\n", console_log_raw)
	local latest_console_log_rev = {}

	for i = #console_log_lines, 1, -1 do
		local v = console_log_lines[i]
		latest_console_log_rev[#latest_console_log_rev + 1] = v
		if (v == "WS: Waiting for Steam to log us in...." or v == "WS: No +host_workshop_collection or it is invalid!") then
			break
		end
	end

	MsgC(Color(0,255,255), "[bLib] ", Color(255,255,255), "Reconstructing console.log...", "\n")

	local console_log = ""
	for i = #latest_console_log_rev, 1, -1 do
		console_log = console_log .. latest_console_log_rev[i] .. "\n"
	end

	if (#console_log > 5000000) then
		MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Your console.log is too large to upload. (>5 MB) https://" .. domain .. "/console.log", "\n")
		return
	end

	MsgC(Color(0,255,255), "[bLib] ", Color(255,255,255), "Reading server info...", "\n")

	local ip_address = game.GetIPAddress()
	local server_name = GetConVar("hostname"):GetString()
	local gamemode = (GM or GAMEMODE).Name
	if ((GM or GAMEMODE).BaseClass) then
		gamemode = gamemode .. " (derived from " .. (GM or GAMEMODE).BaseClass.Name .. ")"
	end
	local avg_ping = 0
	for _,v in ipairs(player.GetHumans()) do
		avg_ping = avg_ping + v:Ping()
	end
	avg_ping = tostring(math.Round(avg_ping / #player.GetHumans()))

	MsgC(Color(0,255,255), "[bLib] ", Color(255,255,255), "Starting upload...", "\n")

	http.Post(

		"https://" .. domain .. "/console.log/upload",

		{
			authentication_code = authentication_code,
			console_log = console_log,
			
			ip_address = ip_address,
			server_name = server_name,
			gamemode = gamemode,
			avg_ping = avg_ping
		},

		function(body, size, headers, status_code)
			if (status_code ~= 200) then
				MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "HTTP Error " .. status_code, "\n")
				return
			end
			if (size == 0) then
				MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Empty body", "\n")
				return
			end
			local decoded_body = util.JSONToTable(body)
			if (not decoded_body) then
				MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "JSON error", "\n")
				return
			end
			if (decoded_body.success == true) then
				MsgC(Color(0,255,0), "[bLib] ", Color(255,255,255), "Thank you; successfully uploaded your console.log to the support site :)", "\n")
			elseif (decoded_body.failure ~= nil) then
				MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Error: " .. decoded_body.failure, "\n")
			else
				MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Unknown error", "\n")
			end
		end,

		function(err)
			MsgC(Color(255,0,0), "[bLib] ", Color(255,255,255), "Error: " .. decoded_body.failure, "\n")
		end

	)
end)