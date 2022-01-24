--[[
MGANGS - TERRITORIES SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/territories/terr_config.lua") -- Config (SH)
AddCSLuaFile("modules/territories/terr_config.lua") -- Config (SH)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/territories/client/cl_meta.lua")
AddCSLuaFile("modules/territories/client/cl_derma.lua")

-- Data
MGangs.Data.File:Create("mgangs/territories", {
	["saved_terrs.txt"] = "[]",
})

--[[------------
	HOOKS
--------------]]
hook.Add("InitPostEntity", "MG2.InitPostEntity.MODULE.TERRITORIES",
function()
	MG2_TERRITORIES:LoadTerritoryEntities()  -- Load the territories entities
end)

hook.Add("MG2.Data.Initialized", "MG2.Data.Initialized.MODULE.TERRITORIES",
function()
  MG2_TERRITORIES:GetTerritories()        -- Load the territories
end)

hook.Add("MG2.Player.InitialSpawn.Post", "MG2.Player.InitialSpawn.Post.MODULE.TERRITORIES",
function(ply)
  ply:SendGangTerritories(MG2_TERRITORIES._tCache)
end)

hook.Add("PlayerSpawnedProp", "MG2.PlayerSpawnedProp.MODULE.TERRITORIES",
function(ply, model, sent)
	if !(MG2_TERRITORIES.config.canBuild) then
		local terrs = MG2_TERRITORIES._tCache
		local terrEnts = MG2_TERRITORIES._tEntities

		if (terrs) then
			for i=1,#terrs do
				local ter = table.Copy(terrs[i])
				local tEnt = terrEnts[i]

				if (tEnt.GetGangID && ply.GetGangID) then
					local sGID, pGID = tonumber(tEnt:GetGangID()), tonumber(ply:GetGangID())

					if (ter && tEnt && sGID != pGID) then
						local col = ter.color
						local bPos1, bPos2 = ter.boxPos[1], ter.boxPos[2]
						bPos1 = Vector(bPos1[1], bPos1[2], bPos1[3])
						bPos2 = Vector(bPos2[1], bPos2[2], bPos2[3])
						bPos2 = LocalToWorld(bPos2, Angle(0,0,0), bPos1, Angle(0,0,0) )

						OrderVectors(bPos1, bPos2)

						local inBounds = sent:GetPos():WithinAABox(bPos1, bPos2)

						if (inBounds) then
							ply:MG_SendNotification(MGangs.Language:GetTranslation("terr_cantbuild"))

							sent:Remove()
						end
					end
				end
			end
		end
	end
end)

--[[Cleanup Detour]]
local tempFlags = {}

hook.Add("PreCleanupMap", "MG2.PreCleanupMap.MODULE.TERRITORES",
function()
	local flags = MG2_TERRITORIES._tEntities

	if (flags && #flags > 0) then
		for i=1,#flags do
			local tFlag = {}
			local flag = flags[i]

			if (IsValid(flag)) then
				local fTID = flag:GetTerritoryID()
				local fGID = flag:GetGangID()

				if (fGID > 0) then
					tFlag.gangid = fGID
				end

				if (fTID > 0) then
					tFlag.territoryid = fTID

					tempFlags[i] = tFlag
				end
			end
		end
	end
end)

hook.Add("PostCleanupMap", "MG2.PostCleanupMap.MODULE.TERRITORIES",
function()
	for i=1,#tempFlags do
		local flag = tempFlags[i]
		local id = flag.territoryid
		local terrData = MG2_TERRITORIES._tCache[id]
		local tFlag = (terrData.flag)

		local flagEnt = ents.Create("mg_flag")
		flagEnt:SetPos(tFlag.pos)
		flagEnt:SetModel(tFlag.mdl)
		flagEnt:Spawn()

		flagEnt:SetColor(terrData.color or Color(255,255,255))
		flagEnt:SetGangID(flag.gangid or 0)
		flagEnt:SetTerritoryID(id)
		flagEnt:ClearClaim() -- Clear it so it resets its anims

		local phys = flagEnt:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:EnableMotion(false)
		end

		MG2_TERRITORIES._tEntities[i] = flagEnt
	end
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString("MG.Send.GangTerritories")
util.AddNetworkString("MG.Admin.UpdateTerritory")
util.AddNetworkString("MG.Admin.CreateTerritory")
util.AddNetworkString("MG.Admin.DeleteTerritory")

net.Receive("MG.Admin.DeleteTerritory",
function(len, ply)
  if !(ply:IsAdmin()) then return false end

  local terrID = net.ReadInt(32)

  if !(terrID) then return false end

  local succ, msg = MG2_TERRITORIES:DeleteTerritory(terrID)

  msg = (msg || succ && MGangs.Language:GetTranslation("terr_deleted") || MGangs.Language:GetTranslation("terr_notdeleted"))

  ply:MG_SendNotification(msg)
end)

net.Receive("MG.Admin.CreateTerritory",
function(len, ply)
  if !(ply:IsAdmin()) then return false end

  local name, desc = net.ReadString(), net.ReadString()
  local color = net.ReadTable()
  local flag = net.ReadTable()
  local boxPos = net.ReadTable()

  if (#name < 3 or #desc < 5) then return false end
  if (!color or !flag or !boxPos) then return false end

  local succ, msg = MG2_TERRITORIES:CreateTerritory({
    name = name,
    desc = desc,
    color = color,
    flag = flag,
    boxPos = boxPos,
  })

  msg = (msg || succ && MGangs.Language:GetTranslation("terr_created") || MGangs.Language:GetTranslation("terr_notcreated"))

  ply:MG_SendNotification(msg)
end)

net.Receive("MG.Admin.UpdateTerritory",
function(len, ply)
  if !(ply:IsAdmin()) then return false end

  local terrID = net.ReadInt(32)
  local name, desc = net.ReadString(), net.ReadString()
  local color = net.ReadTable()
  local flag = net.ReadTable()
  local boxPos = net.ReadTable()

  if !(terrID) then return false end
  if (#name < 3 or #desc < 5) then return false end
  if (!color or !flag or !boxPos) then return false end

  local succ, msg = MG2_TERRITORIES:UpdateTerritory(terrID, {
    name = name,
    desc = desc,
    color = color,
    flag = flag,
    boxPos = boxPos,
  })

  msg = (msg || succ && MGangs.Language:GetTranslation("terr_updated") || MGangs.Language:GetTranslation("terr_notupdated"))

  ply:MG_SendNotification(msg)
end)
