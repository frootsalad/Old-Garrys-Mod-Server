if SERVER then
	AEL_Version = "1.1.1"
	AElections = {}
	AEL_Lang = {}
	AEL_Candidates = {}
	AEL_PreElectionsActive = false
	AEL_ElectionsActive = false

	include("ael_config.lua")
	include("a_elections/server/sv_ael_main.lua")
	include("a_elections/server/sv_ael_required_functions.lua")

	AddCSLuaFile("ael_config.lua")
	AddCSLuaFile("a_elections/client/cl_ael_main.lua")
	AddCSLuaFile("a_elections/client/cl_ael_required_functions.lua")

	if AElections.WorkshopDownload or AElections.ServerDownload then
		include("a_elections/server/sv_ael_downloads.lua")
	end
end

if CLIENT then
	AElections = {}
	AEL_Lang = {}
	AEL_Candidates = {}

	include("ael_config.lua")
	include("a_elections/client/cl_ael_main.lua")
	include("a_elections/client/cl_ael_required_functions.lua")
end
