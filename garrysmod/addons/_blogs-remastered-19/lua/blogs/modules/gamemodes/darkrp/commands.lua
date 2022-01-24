local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Commands"
MODULE.Colour   = Color(255,0,0)

local advert_disabled = nil
local law_disabled    = nil
local chat_disabled   = nil

MODULE:Hook("onChatCommand","chatcommand",function(ply,cmd,args)
	if (type(args) == "table") then
		args = table.concat(args," ")
	end

	if (bLogs.InGameConfig and advert_disabled == nil) then
		advert_disabled = false
		for _,v in pairs(bLogs.InGameConfig.ModulesDisabled) do
			if (v == "DarkRP_Adverts") then
				advert_disabled = true
				break
			end
		end
	end
	if (bLogs.InGameConfig and law_disabled == nil) then
		law_disabled = false
		for _,v in pairs(bLogs.InGameConfig.ModulesDisabled) do
			if (v == "DarkRP_Laws") then
				law_disabled = true
				break
			end
		end
	end
	if (bLogs.InGameConfig and chat_disabled == nil) then
		chat_disabled = false
		for _,v in pairs(bLogs.InGameConfig.ModulesDisabled) do
			if (v == "General_Chat") then
				chat_disabled = true
				break
			end
		end
	end
	if (advert_disabled == false) then
		if (cmd:lower() == "advert") then
			return
		end
	end
	if (not law_disabled) then
		if (cmd:lower() == "addlaw") then
			hook.Run("bLogs_addLaw",ply,args)
		end
		if (cmd:lower() == "removelaw") then
			hook.Run("bLogs_removeLaw",ply,args)
		end
	end
	if (not chat_disabled) then
		if (cmd:lower() == "/" or cmd:lower() == "ooc") then
			hook.Run("bLogsOOC",ply,args)
			return
		end
	end

	if (bLogs.Config.BlacklistedCommands.darkrp) then
		if (table.HasValue(bLogs.Config.BlacklistedCommands.darkrp,"/" .. cmd)) then return end
	end

	MODULE:Log(bLogs:FormatPlayer(ply) .. ": /" .. bLogs:Escape(cmd or "") .. " " .. bLogs:Escape(args or ""))
end)

bLogs:AddModule(MODULE)
