if (not SprayMesh) then return end

local MODULE = bLogs:Module()

MODULE.Category = "SprayMesh"
MODULE.Name     = "Sprays"
MODULE.Colour   = Color(130,0,255)

MODULE:Hook("PlayerSprayMesh","spraymesh",function(ply)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " used their spray " .. bLogs:Highlight(ply:GetInfo("SprayMesh_URL")))
end)

bLogs:AddModule(MODULE)
