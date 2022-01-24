--[[
MGANGS - TERRITORIES SERVERSIDE META
Developed by Zephruz
]]

--[[------------
	Gang Territories Meta
---------------]]

function MG2_TERRITORIES:GetTerritories()
	local data = MGangs.Data.File:Read("mgangs/territories/saved_terrs.txt")
	data = (data && util.JSONToTable(data))

	if (data) then
		self._tCache = data

		return data
	elseif !(data) then
		MGangs:ConsoleMessage("[TERRITORIES] Couldn't find territories file!", Color(255,0,0))

		return false
	end
end

--[[Territory entity creation/deletion]]
function MG2_TERRITORIES:DeleteTerritoryEntity(id)
	local flagEnt = self._tEntities[id]

	if !(flagEnt) then return false end
	if (IsValid(flagEnt)) then flagEnt:Remove() end

	table.remove(self._tEntities, id)
end

--[[Create territory entity]]
function MG2_TERRITORIES:CreateTerritoryEntity(id)
	if !(self._tCache[id]) then return false end
	if (IsValid(self._tEntities[id])) then self._tEntities[id]:Remove() end

	local terrData = self._tCache[id]
	local tFlag = (terrData.flag)

	local flagEnt = ents.Create("mg_flag")
	flagEnt:SetPos(tFlag.pos)
	flagEnt:SetModel(tFlag.mdl)
	flagEnt:Spawn()

	flagEnt:SetColor(terrData.color or Color(255,255,255))
	flagEnt:SetGangID(0)
	flagEnt:SetTerritoryID(id)

	local phys = flagEnt:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:EnableMotion(false)
	end

	self._tEntities[id] = flagEnt
end

--[[Update Entities]]
function MG2_TERRITORIES:UpdateTerritoryEnts()
	for i=1,#self._tEntities do
		self._tEntities[i]:SetTerritoryID(i)
	end
end

function MG2_TERRITORIES:LoadTerritoryEntities()
	local terrs = self._tCache

	if (terrs) then
		for k,v in pairs(terrs) do
			self:CreateTerritoryEntity(k)
		end
	end
end

--[[Territory creation/deletion]]
function MG2_TERRITORIES:DeleteTerritory(id)
	if !(self._tCache[id]) then return false, MGangs.Language:GetTranslation("terr_doesnt_exist") end

	table.remove(self._tCache, id)

	self:DeleteTerritoryEntity(id)
	self:SaveTerritories(true)

	return true
end

function MG2_TERRITORIES:CreateTerritory(data)
	local id = table.insert(self._tCache, data)

	self:CreateTerritoryEntity(id)
	self:SaveTerritories(true)

	return true
end

function MG2_TERRITORIES:UpdateTerritory(id, data)
	if !(self._tCache[id]) then self:CreateTerritory(data) return false, MGangs.Language:GetTranslation("terr_created") end

	for k,v in pairs(data) do
		if (self._tCache[id][k] && v != self._tCache[id][k]) then
			self._tCache[id][k] = v
		end
	end

	self:SaveTerritories(true)

	return true
end

function MG2_TERRITORIES:SaveTerritories(updPlayers)
	file.Write("mgangs/territories/saved_terrs.txt", util.TableToJSON(self._tCache or {}))

	if (updPlayers) then
		for k,v in pairs(player.GetAll()) do v:SendGangTerritories(self._tCache) end

		self:UpdateTerritoryEnts()	-- Might as well
	end
end

function MG2_TERRITORIES:LoadTerritories(reload)
	local terrs

	if (reload) then
		terrs = self:GetTerritories()
	else
		terrs = self._tCache
	end

	if (terrs) then
		for k,v in pairs(terrs) do
			self:LoadTerritoryEntities()
		end
	end
end

--[[------------
	Player Meta
---------------]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangTerritories(tTbl)
	local tEnts = {}

	for i=1,#MG2_TERRITORIES._tEntities do
		local ent = MG2_TERRITORIES._tEntities[i]

		table.insert(tEnts, ent:EntIndex())
	end

	net.Start("MG.Send.GangTerritories")
		net.WriteTable(tTbl or MG2_TERRITORIES._tEntities)
		net.WriteTable(tEnts)
	net.Send(self)
end
