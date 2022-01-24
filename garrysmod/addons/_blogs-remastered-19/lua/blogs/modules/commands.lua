local MODULE = bLogs:Module()

MODULE.Category = "General"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(0,106,193)

MODULE:Hook("PostPlayerSay","commands_verbose",function(ply,text)
	if (string.Trim(text) == "") then return end
	if (text:sub(1,1) == "!" or text:sub(1,1) == "/") then
		if (bLogs.InGameConfig) then
			if (text:sub(1,1) == "/" and DarkRP and not bLogs.InGameConfig.ModulesDisabled["DarkRP_Commands"]) then
				if ((DarkRP.getChatCommands())[((string.Explode(" ",text))[1]:sub(2))]) then -- challenge: write the most disgusting & autistic looking line as possible
					return
				end
			end
		end
		MODULE:Log(bLogs:FormatPlayer(ply) .. ": " .. bLogs:Escape(text))
	end
end)

bLogs:AddModule(MODULE)
