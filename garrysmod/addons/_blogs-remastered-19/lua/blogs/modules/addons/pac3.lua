if (not pac) then return end

local MODULE = bLogs:Module()

MODULE.Category = "PAC3"
MODULE.Name     = "Outfit Change"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("PACSubmitAcknowledged","pacoutfit",function(ply, allowed, reason, name, data)
	if (allowed) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " switched to PAC Outfit " .. bLogs:Highlight(name))
	end
end)

bLogs:AddModule(MODULE)
