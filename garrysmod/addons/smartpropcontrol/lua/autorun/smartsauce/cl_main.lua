//
/*
	Client Entrypoint
	3/2/2018
	Smart Like My Shoe 
*/

/*
	Plugins 
*/
local propertiesPlugin = include("plugins/sh_properties.lua");
propertiesPlugin:Init();

local notify = include("plugins/sh_notify.lua");

/*
	Main
*/
local main = {};

/*
	Receives decal cleanup message from server 
*/
function main.CleanupDecals()
	RunConsoleCommand("r_cleardecals");
end 
net.Receive("smartsauce_decal", main.CleanupDecals);
