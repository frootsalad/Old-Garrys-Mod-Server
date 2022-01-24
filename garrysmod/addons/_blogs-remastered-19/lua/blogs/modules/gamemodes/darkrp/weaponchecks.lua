local MODULE = bLogs:Module()

MODULE.Category = "DarkRP"
MODULE.Name     = "Weapon Checker"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("playerWeaponsChecked","weaponschecked",function(checker,target)
	MODULE:Log(bLogs:FormatPlayer(checker) .. " checked the weapons of " .. bLogs:FormatPlayer(target))
end)

MODULE:Hook("playerWeaponsConfiscated","weaponsconfiscated",function(checker,target)
	MODULE:Log(bLogs:FormatPlayer(checker) .. " confiscated the weapons of " .. bLogs:FormatPlayer(target))
end)

MODULE:Hook("playerWeaponsReturned","weaponsreturned",function(checker,target)
	MODULE:Log(bLogs:FormatPlayer(checker) .. " returned the weapons of " .. bLogs:FormatPlayer(target))
end)

bLogs:AddModule(MODULE)
