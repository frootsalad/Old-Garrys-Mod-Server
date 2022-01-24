--[[
MGANGS - NOTIFICATIONS LOAD
Developed by Zephruz
]]

MGangs.Module.mods.notifications = {}
MG2_NOTIFICATIONS = MGangs.Module.mods.notifications

if (SERVER) then
	include("notif_config.lua")
	
	AddCSLuaFile("notif_config.lua")
	AddCSLuaFile("client/cl_notifs_load.lua")
end

if (CLIENT) then
	include("notif_config.lua")
	include("client/cl_notifs_load.lua")
end