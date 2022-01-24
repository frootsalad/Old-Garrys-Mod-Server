local MODULE = bLogs:Module()

MODULE.Category = "Sandbox"
MODULE.Name     = "Toolgun"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("CanTool","toolused",function(ply,tr,tool)
	if (IsValid(tr.Entity)) then
		if (IsValid(tr.Entity.bLogs_Creator)) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " used tool " .. bLogs:Highlight(tool) .. " on a " .. tr.Entity:GetClass() .. " (" .. tr.Entity:GetModel() .. ") created by " .. bLogs.FormatPlayer(tr.Entity.bLogs_Creator))
			return
		end
	end
	MODULE:Log(bLogs:FormatPlayer(ply) .. " used tool " .. bLogs:Highlight(tool) .. " on a world object")
end,2)

bLogs:AddModule(MODULE)
