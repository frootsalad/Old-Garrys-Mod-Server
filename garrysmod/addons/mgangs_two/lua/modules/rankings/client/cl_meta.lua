--[[
MGANGS - RANKINGS CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"RequestRanks", "FetchRanks"}, MGangs.Gang,
function()
  net.Start("MG2.Request.GangRankings")
  net.SendToServer()
end)

MGangs.Meta:Register({"GetRanks", "GetAllRanks"}, MGangs.Gang,
function()
  return MG2_RANKINGS.rankCache
end)
