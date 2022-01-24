if (not TRADING) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Pointshop Trading"
MODULE.Name     = "Logs"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("TradingLogs","tradinglogs",function(log)
	MODULE:Log(log)
end)

bLogs:AddModule(MODULE)
