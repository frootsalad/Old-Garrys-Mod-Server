// 
/*
	SmartSauce Loader 
	3/2/2018
	Smart Like My Shoe 
*/

include("smartsauce/sh_config.lua");

if (SERVER) then 
	AddCSLuaFile();
	AddCSLuaFile("smartsauce/plugins/cl_derma.lua")
	AddCSLuaFile("smartsauce/plugins/sh_properties.lua");
	AddCSLuaFile("smartsauce/plugins/sh_notify.lua");
	AddCSLuaFile("smartsauce/sh_config.lua");
	AddCSLuaFile("smartsauce/cl_menu.lua");
	AddCSLuaFile("smartsauce/cl_main.lua");

	include("smartsauce/sv_main.lua");
else // CLIENT

	include("smartsauce/cl_menu.lua");
	include("smartsauce/cl_main.lua");
end
