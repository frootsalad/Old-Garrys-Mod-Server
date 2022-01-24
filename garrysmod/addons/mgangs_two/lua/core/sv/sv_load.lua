--[[
MGANGS - SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SERVER FILES ]]
include("mg_config.lua")
include("mg_includes.lua")
include("mg_languages.lua")
include("core/sh_util.lua")
include("core/sh_meta.lua")
include("core/sh_permissions.lua")
include("core/sh_globals.lua")
include("core/sh_settings.lua")
include("mg_modules.lua")
include("sv_meta.lua")
include("sv_networking.lua")
include("data/sv_data_load.lua")

--[[ CLIENT FILES ]]
AddCSLuaFile("mg_config.lua")
AddCSLuaFile("mg_includes.lua")
AddCSLuaFile("mg_languages.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("core/sh_meta.lua")
AddCSLuaFile("core/sh_globals.lua")
AddCSLuaFile("core/sh_permissions.lua")
AddCSLuaFile("core/sh_settings.lua")
AddCSLuaFile("mg_modules.lua")
AddCSLuaFile("core/cl/cl_meta.lua")
AddCSLuaFile("core/cl/cl_networking.lua")

--Derma
AddCSLuaFile("core/cl/derma/cl_derma_load.lua")
AddCSLuaFile("core/cl/derma/cl_derma_paint.lua")
AddCSLuaFile("core/cl/derma/cl_derma_reg.lua")
AddCSLuaFile("core/cl/derma/cl_menu_admin.lua")
AddCSLuaFile("core/cl/derma/cl_menu_invites.lua")
AddCSLuaFile("core/cl/derma/cl_menu_gang.lua")
AddCSLuaFile("core/cl/derma/cl_menu_gangcreation.lua")

--[[---------
	LOAD
-----------]]
hook.Add("Initialize", "MG2.Initialize.DEFAULT",
function()
	MGangs.Module:Load()	-- Load Modules
end)

--[[Modules loaded]]
hook.Add("MG2.Modules.Loaded", "MG2.Modules.Loaded.DEFAULT",
function()
	MGangs.Data:Load()		-- Load Data
end)

--[[Player initial spawn]]
hook.Add("PlayerInitialSpawn", "MG2.Player.Initialize",
function(ply)
	hook.Run("MG2.Player.InitialSpawn.Start", ply)

	MGangs:ConsoleMessage("Initializing " .. ply:Nick() .. "...", Color(0,255,0))

	-- Send gangs
	ply:SendAllGangs(MGangs.Gang:GetAll() or {})

	-- Check & Send players data
	local succ, message = ply:CheckGangData()

	MGangs:ConsoleMessage(message, Color(0,255,0))
	MGangs:ConsoleMessage(ply:Nick() .. (succ && " was successfully initialized!" || " was not successfully initialized!"), Color(0,255,0))

	hook.Run("MG2.Player.InitialSpawn.Post", ply, succ, (message && message || "No message"))
end)

--[[Send gang data]]
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.DEFAULT",
function(ply)
	local gangID = ply:GetGangID()
	local gangMembers = MGangs.Gang:GetMembers(gangID)
	local gangGroups = MGangs.Gang:GetGroups(gangID)

	ply:SendGangGroups((gangGroups or {}))
	ply:SendGangMembers((gangMembers or {}))
end)
