include("autorun/config_dfpp.lua")
AddCSLuaFile("autorun/config_dfpp.lua")
util.AddNetworkString("DFPP_SendBlockedModels")

DFPP = DFPP or {}

function DFPP.BlacklistProp(trace, owner)

	if ( !IsValid(trace.Entity) ) then return false end
	if not owner:HasToolAccess() then return end
	local mdl = trace.Entity:GetModel()
	local blocked = false

	for k in pairs(FPP.BlockedModels) do
		if k == mdl then
			blocked = true
		end
	end
	if blocked then trace.Entity:Remove() else RunConsoleCommand("FPP_AddBlockedModel", mdl) end

end

function DFPP.UnblacklistProp(trace, owner)

	if ( !IsValid(trace.Entity) ) then return false end
	if not owner:HasToolAccess() then return end
	RunConsoleCommand("FPP_RemoveBlockedModel", trace.Entity:GetModel())

end

function DFPP.ToggleBlockedProps(ply)

	if not ply:HasToolAccess() then return end
	ply.toggleDelay = ply.toggleDelay or 0
    if ply.toggleDelay > CurTime() - 1 then return end
    ply.toggleDelay = CurTime()

	local blocked = tobool((FPP.Settings["FPP_BLOCKMODELSETTINGS1"]["toggle"]))
	local toggle = "1"
	if blocked then
		toggle = "0"
	else
		toggle = "1"
	end
	RunConsoleCommand("FPP_setting", "FPP_BLOCKMODELSETTINGS1", "toggle", toggle)

end

function DFPP.SendBlockedProps(ply, cmd, args)
	ply.Netdelay = ply.Netdelay or 0
    if ply.Netdelay > CurTime() - 1 then return end --Network black listed models every second
    ply.Netdelay = CurTime()

    local models = {}
    for k in pairs(FPP.BlockedModels) do table.insert(models, k) end --Create table full of models that we're going to network
    local data = util.Compress(table.concat(models, "\0")) --Compress that shiet!

    if not data then return end

    net.Start("DFPP_SendBlockedModels")
        net.WriteData(data, #data)
    net.Send(ply)
end

hook.Add("PlayerPostThink", "BL_UpdateLastTool", function(ply)
		
		if ply.lastTool == nil then
			ply.lastTool = ""
		end 

		if IsValid(ply:GetActiveWeapon()) then 

		if ply:GetActiveWeapon():GetClass()  == "gmod_tool" and ply.lastTool != ply:GetTool() then
			
			ply.lastTool = ply:GetTool()

		end

	    end

end)

hook.Add("PlayerSwitchWeapon", "BL_NotifyUnblocked", function( ply, oldWeapon, newWeapon )
		
		if IsValid(oldWeapon) and oldWeapon:GetClass() == "gmod_tool" and ply.lastTool == ply:GetTool("blacklist") and tobool((FPP.Settings["FPP_BLOCKMODELSETTINGS1"]["toggle"])) == false and DFFP.Config.NotifyBlockedSpawn then
			ply:ChatPrint("Spawning of blocked models has been left enabled, reload with the Blacklist Model tool to adjust.")
		end

	end)
