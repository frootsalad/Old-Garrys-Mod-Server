if SERVER then
	resource.AddWorkshop("728328781")

	AddCSLuaFile("ahud/ahud_config.lua")
	AddCSLuaFile("ahud/ahud.lua")
	AddCSLuaFile("ahud/vgui/cl_circleavatar.lua")
	AddCSLuaFile("ahud/vgui/cl_notification.lua")
	AddCSLuaFile("ahud/vgui/cl_voice.lua")
else
	include("ahud/ahud.lua")
end