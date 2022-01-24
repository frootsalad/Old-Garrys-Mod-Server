local partTbl = {
	{
		path = "particles/mg2_indicator_enemy_vfx.pcf",
		particle = "mg2_indicator_enemy01",
	},
	{
		path = "particles/mg2_indicator_allies_vfx.pcf",
		particle = "mg2_indicator_allies01",
	},
}

for k,v in pairs(partTbl) do
	game.AddParticles(v.path)
	PrecacheParticleSystem(v.particle)
end