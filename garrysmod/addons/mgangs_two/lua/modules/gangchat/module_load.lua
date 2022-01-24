--[[
MGANGS - GANGCHAT LOAD
Developed by Zephruz
]]

MGangs.Module.mods.gangchat = (MGangs.Module.mods.gangchat or {})

MG2_GANGCHAT = MGangs.Module.mods.gangchat

if (SERVER) then
	include("server/sv_gchat_load.lua")
	AddCSLuaFile("client/cl_gchat_load.lua")
end

if (CLIENT) then
	include("client/cl_gchat_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

-- [[ MODULE-RELATED REGISTRATION/META ]]

