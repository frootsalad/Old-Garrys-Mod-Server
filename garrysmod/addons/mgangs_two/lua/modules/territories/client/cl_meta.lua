--[[
MGANGS - TERRITORIES CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"GetTerritoryEntities"}, MG2_TERRITORIES,
function(self)
  return ents.FindByClass("mg_flag")
end)

MGangs.Meta:Register({"GetTerritoryEntByID"}, MG2_TERRITORIES,
function(self, terID)
  local ent = false
  local tEnts = ents.FindByClass("mg_flag")

  for i=1,#tEnts do
    if (IsValid(tEnts[i]) && tonumber(tEnts[i]:GetTerritoryID()) == tonumber(terID)) then
      ent = tEnts[i]
    end
  end

  return ent
end)

MGangs.Meta:Register({"DeleteTerritory", "RemoveTerritory"}, MG2_TERRITORIES,
function(self, id)
  net.Start("MG.Admin.DeleteTerritory")
    net.WriteInt(id, 32)
  net.SendToServer()
end)

MGangs.Meta:Register({"CreateTerritory", "CreateNewTerritory"}, MG2_TERRITORIES,
function(self, data)
  net.Start("MG.Admin.CreateTerritory")
    net.WriteString(data.name or "INVALID")
    net.WriteString(data.desc or "Default description")
    net.WriteTable(data.color or Color(0,255,0,255))
    net.WriteTable(data.flag or {})
    net.WriteTable(data.boxPos or {})
  net.SendToServer()
end)

MGangs.Meta:Register({"UpdateTerritory", "EditTerritory"}, MG2_TERRITORIES,
function(self, id, data)
  net.Start("MG.Admin.UpdateTerritory")
    net.WriteInt(id, 32)
    net.WriteString(data.name or "INVALID")
    net.WriteString(data.desc or "Default description")
    net.WriteTable(data.color or Color(0,255,0,255))
    net.WriteTable(data.flag or {})
    net.WriteTable(data.boxPos or {})
  net.SendToServer()
end)
