local MODULE = bLogs:Module()

MODULE.Category = "General"
MODULE.Name     = "Chat"
MODULE.Colour   = Color(0,106,193)

MODULE:UnHook("PostPlayerSay","darkrp_chat")
MODULE:UnHook("PlayerSay","chat")

timer.Create("blogs_waitforgm_chat",1,0,function()
	if (GM or GAMEMODE) then
		if (DarkRP) then
			MODULE:Hook("PostPlayerSay","darkrp_chat",function(ply,text)
				if (string.Trim(text) == "") then return end
				if (bLogs.InGameConfig) then
					if (not bLogs.InGameConfig.ModulesDisabled["General_Commands"]) then
						if ((text:sub(1,1) == "!" or text:sub(1,1) == "/")) then return end
					end
				end
				MODULE:Log(bLogs:FormatPlayer(ply) .. ": " .. bLogs:Escape(text))
			end)
			MODULE:Hook("bLogsOOC","darkrp_ooc_log",function(ply,text)
				MODULE:Log(bLogs:FormatPlayer(ply) .. ": [OOC] " .. bLogs:Escape(text))
			end)
		else
			MODULE:Hook("PlayerSay","chat",function(ply,text)
				if (bLogs.InGameConfig) then
					if (not bLogs.InGameConfig.ModulesDisabled["General_Commands"]) then
						if (text:sub(1,1) == "!" or text:sub(1,1) == "/" or string.Trim(text) == "") then return end
					end
				end
				MODULE:Log(bLogs:FormatPlayer(ply) .. ": " .. bLogs:Escape(text))
			end)
		end
		timer.Stop("blogs_waitforgm_chat")
	end
end)

bLogs:AddModule(MODULE)
