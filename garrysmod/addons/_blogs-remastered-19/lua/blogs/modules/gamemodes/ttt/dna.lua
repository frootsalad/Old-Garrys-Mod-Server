local MODULE = bLogs:Module()

MODULE.Category = "TTT"
MODULE.Name     = "DNA"
MODULE.Colour   = Color(255,130,0)

MODULE:Hook("TTTFoundDNA","tttdna",function(ply,dna_owner,ent)
	if (ent:IsWeapon()) then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " found the DNA of " .. bLogs:FormatPlayer(dna_owner) .. " on their " .. bLogs:FormatEntity(ent))
	else
		MODULE:Log(bLogs:FormatPlayer(ply) .. " found the DNA of " .. bLogs:FormatPlayer(dna_owner) .. " on their corpse")
	end
end)

bLogs:AddModule(MODULE)
