--[[
MGANGS - RANKINGS SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/rankings/ranking_config.lua") -- Config (SV)
AddCSLuaFile("modules/rankings/ranking_config.lua") -- Config (CL)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/rankings/client/cl_meta.lua")
AddCSLuaFile("modules/rankings/client/cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.RANKINGS",
function(ply)
	local ranks = MG2_RANKINGS:LoadAllRanks()

	ply:SendGangRankings(ranks)
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString('MG2.Send.GangRankings')
util.AddNetworkString('MG2.Request.GangRankings')

net.Receive("MG2.Request.GangRankings",
function(len, ply)
	local ranks = MG2_RANKINGS:LoadAllRanks()

	ply:SendGangRankings(ranks)
end)
