--[[
MGANGS - RANKINGS CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/rankings/ranking_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.RANKINGS",
function(data, noreset)
	data.rankcache = (noreset && data.rankcache || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG2.Send.GangRankings",
function(len)
	local curSplit = net.ReadInt(32)
	local gangRanks = net.ReadTable()

	if (curSplit == 1) then
		MG2_RANKINGS.rankCache = gangRanks
	else
		for k,v in pairs(gangRanks) do
			MG2_RANKINGS.rankCache[k] = gangRanks
		end
	end
end)
