--[[
MGANGS - TERRITORIES LOAD
Developed by Zephruz
]]

MGangs.Module.mods.territories = {}
MG2_TERRITORIES = MGangs.Module.mods.territories
MG2_TERRITORIES._tCache = (MG2_TERRITORIES._tCache or {})
MG2_TERRITORIES._tEntities = (MG2_TERRITORIES._tEntities or {})

if (SERVER) then
	include("server/sv_terr_load.lua")
	AddCSLuaFile("client/cl_terr_load.lua")
end

if (CLIENT) then
	include("client/cl_terr_load.lua")
end

-- [[End Points/Request Receivers]]
netPoint:CreateEndPoint("MG2.GetTerritories", {
	searchFor = function(ply)
		return MG2_TERRITORIES._tCache
	end,
})
