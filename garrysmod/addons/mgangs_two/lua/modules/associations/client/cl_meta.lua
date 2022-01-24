--[[
MGANGS - ASSOCIATIONS CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register("HasAssociation", MGangs.Gang,
function(self, gid)
  gid = (gid && tonumber(gid))

  local has, data = false, nil
  local gidData = MGangs.Gang:GetAssociations()

  if (gidData) then
    for k,v in pairs(gidData) do
      if (tonumber(v.gid1) == gid or tonumber(v.gid2) == gid) then
        has = true
        data = v

        break
      end
    end
  end

  return has, data
end)

MGangs.Meta:Register({"GetAssociations", "GetGangAssociations"}, MGangs.Gang,
function(self)
  local assTbl = (MGangs.Gang.Data && MGangs.Gang.Data.associations || {})

  for i=1,#assTbl do
    local ass = assTbl[i]

    if (ass) then
      ass.atWar = (tobool(ass.atWar))
    end
  end

	return (assTbl)
end)

MGangs.Meta:Register("SetWarStatus", MGangs.Gang,
function(self, gangid, stat)
	net.Start("MG.Gang.SetWarStatus")
		net.WriteInt(gangid, 32)
    net.WriteBool(stat or false)
	net.SendToServer()
end)

MGangs.Meta:Register("SetAssociation", MGangs.Gang,
function(self, gangid, sid)
	net.Start("MG.Gang.SetAssociation")
		net.WriteInt(gangid, 32)
		net.WriteInt(sid, 32)
	net.SendToServer()
end)
