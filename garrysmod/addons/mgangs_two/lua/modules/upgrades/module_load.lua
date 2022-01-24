--[[
MGANGS - UPGRADES LOAD
Developed by Zephruz
]]

if (!MGangs.Config.Balance or !MGangs.Config.Balance.enabled) then return false end

MGangs.Module.mods.upgrades = {}
MG2_UPGRADES = MGangs.Module.mods.upgrades

if (SERVER) then
	include("server/sv_upgs_load.lua")
	AddCSLuaFile("client/cl_upgs_load.lua")
end

if (CLIENT) then
	include("client/cl_upgs_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

-- Register Permissions
MGangs.Gang:RegisterPermissions("Upgrades", "Purchase")
