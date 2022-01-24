local MODULE = bLogs:Module()

MODULE.Category = "Props"
MODULE.Name     = "Propkills"
MODULE.Colour   = Color(255,0,75)

MODULE:Hook("PlayerDeath","propkill",function(ply,prop)
	if (not IsValid(prop)) then return end
	if (prop:IsVehicle()) then return end
	if (IsValid(prop.bLogs_Creator)) then
		if (prop.bLogs_Creator == ply) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " killed themself with their prop (" .. bLogs:Highlight(prop:GetModel()) .. ")")
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was killed by a prop created by " .. bLogs:FormatPlayer(prop.bLogs_Creator) .. " (" .. bLogs:Highlight(prop:GetModel()) .. ")")
		end
	elseif (prop:GetClass() == "prop_physics") then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was killed by a world prop (" .. bLogs:Highlight(prop:GetModel()) .. ")")
	end
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Props"
MODULE.Name     = "Propdamage"
MODULE.Colour   = Color(255,0,75)

MODULE:Hook("EntityTakeDamage","propdamage",function(ply,dmginfo)
	if (not ply:IsPlayer()) then return end
	if (dmginfo:GetDamage() == 0) then return end
	local prop = dmginfo:GetAttacker()
	if (not IsValid(prop)) then return end
	if (prop:IsVehicle()) then return end
	if (IsValid(prop.bLogs_Creator)) then
		if (prop.bLogs_Creator == ply) then
			MODULE:Log(bLogs:FormatPlayer(ply) .. " damaged themself for " .. bLogs:Highlight(dmginfo:GetDamage()) .. " damage with their prop (" .. bLogs:Highlight(prop:GetModel()) .. ")")
		else
			MODULE:Log(bLogs:FormatPlayer(ply) .. " was hurt by a prop for " .. bLogs:Highlight(dmginfo:GetDamage()) .. " damage created by " .. bLogs:FormatPlayer(prop.bLogs_Creator) .. " (" .. bLogs:Highlight(prop:GetModel()) .. ")")
		end
	elseif (prop:GetClass() == "prop_physics") then
		MODULE:Log(bLogs:FormatPlayer(ply) .. " was damaged for " .. bLogs:Highlight(dmginfo:GetDamage()) .. " damage by a world prop (" .. bLogs:Highlight(prop:GetModel()) .. ")")
	end
end)

bLogs:AddModule(MODULE)
