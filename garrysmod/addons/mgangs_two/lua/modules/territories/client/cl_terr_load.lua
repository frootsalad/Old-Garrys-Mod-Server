--[[
MGANGS - TERRITORIES CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/territories/terr_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

CreateClientConVar("mg2_draw_territories", "0", true, false)

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.TERRITORIES",
function(data, noreset)
	data.territories = (noreset && data.territories || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG.Send.GangTerritories",
function(len)
	-- Territories
	MG2_TERRITORIES._tCache = (net.ReadTable() or {})

	-- Entities
	MG2_TERRITORIES._tEntities = (MG2_TERRITORIES:GetTerritoryEntities() or {})
end)

hook.Add("InitPostEntity", "MG2.InitPostEntity.MODULE.TERRITORIES",
function()
	-- Entities
	MG2_TERRITORIES._tEntities = (MG2_TERRITORIES:GetTerritoryEntities() or {})
end)

--[[
	MISC.
]]

-- Draw the territories
hook.Remove("PostDrawTranslucentRenderables", "MG2.PostDrawTranslucentRenderables.MODULE.TERRITORIES")
hook.Add("PostDrawTranslucentRenderables", "MG2.PostDrawTranslucentRenderables.MODULE.TERRITORIES",
function()
	local tr = LocalPlayer():GetEyeTrace()
	local eAng = LocalPlayer():EyeAngles()
	local tTbl = MG2_TERRITORIES._tCache

	local dTOpt = GetConVar("mg2_draw_territories")

	for i=1,#tTbl do
		local terr = tTbl[i]
		local bPos = terr.boxPos
		local tCol = (terr.color || Color(0,255,0,255))
		tCol = Color(tCol.r, tCol.g, tCol.b, tCol.a)

		if (bPos && dTOpt && tobool(dTOpt:GetInt())) then
			local bPos1, bPos2 = bPos[1], bPos[2]

			-- Draw wireframe
			render.DrawWireframeBox(bPos1, Angle(0,0,0), Vector(0,0,0), bPos2, tCol, false)
		end
	end
end)
