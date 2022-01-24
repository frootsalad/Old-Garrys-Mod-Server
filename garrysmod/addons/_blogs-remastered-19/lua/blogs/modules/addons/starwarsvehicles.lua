local starwarsvehicles = {}
local global_tbl = list.Get("SWVehicles")
local found = false
for i,v in pairs(global_tbl) do
	found = true
	table.insert(starwarsvehicles,v.ClassName)
end
if (not found) then
	return
end

local MODULE = bLogs:Module()

MODULE.Category = "Star Wars Vehicles"
MODULE.Name     = "Vehicle Damage"
MODULE.Colour   = Color(0,150,255)

MODULE:Hook("EntityTakeDamage","swdamage",function(ent,dmginfo)
	if (ent:IsWorld()) then return end
	if (not table.HasValue(starwarsvehicles,ent:GetClass())) then return end
	if (not IsValid(dmginfo:GetAttacker())) then return end
	if (not dmginfo:GetAttacker():IsPlayer()) then return end
	local owner = ent.bLogs_Creator
	local weapon = dmginfo:GetAttacker():GetActiveWeapon()
	if (IsValid(weapon)) then
		local witha = " with a " .. bLogs:FormatEntity(weapon)
	end
	if (IsValid(owner)) then
		MODULE:Log(bLogs:FormatPlayer(dmginfo:GetAttacker()) .. " damaged Star Wars Vehicle vehicle " .. bLogs:Highlight(bLogs:FormatEntity(ent)) .. " owned by " .. bLogs:FormatPlayer(owner) .. " for " .. bLogs:Highlight(math.floor(dmginfo:GetDamage())) .. " damage" .. (witha or ""))
	else
		MODULE:Log(bLogs:FormatPlayer(dmginfo:GetAttacker()) .. " damaged Star Wars Vehicle vehicle " .. bLogs:Highlight(bLogs:FormatEntity(ent)) .. " for " .. bLogs:Highlight(math.floor(dmginfo:GetDamage())) .. " damage" .. (witha or ""))
	end
end)

bLogs:AddModule(MODULE)
