--[[
MGANGS - ASSOCIATIONS SERVERSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register("HasAssociation", MGangs.Gang,
function(self, gid1, gid2)
  gid1 = (gid1 && tonumber(gid1))
  gid2 = (gid2 && tonumber(gid2))

  local has, data = false, nil
  local gidData = MGangs.Gang:GetAssociations(gid1)

  if (gidData) then
    for k,v in pairs(gidData) do
      if (tonumber(v.gid1) == gid2 or tonumber(v.gid2) == gid2) then
        has = true
        data = v

        break
      end
    end
  end

  return has, data
end)

MGangs.Meta:Register({"GetAssociations", "GetGangAssociations"}, MGangs.Gang,
function(self, gangid)
  local gangAss = {}
	local gangAss1, gangAss2 = MGangs.Data:SelectAllWhere("mg2_gangassociations", "gid1", gangid), MGangs.Data:SelectAllWhere("mg2_gangassociations", "gid2", gangid)

	if (gangAss1) then
    for k,v in pairs(gangAss1) do
      gangAss1[k].atWar = (tobool(v && v.atWar))
    end

    table.Merge(gangAss,gangAss1)
  end

  if (gangAss2) then
    for k,v in pairs(gangAss2) do
      gangAss2[k].atWar = (tobool(v && v.atWar))
    end

    table.Merge(gangAss,gangAss2)
  end

	return (gangAss && #gangAss > 0 && gangAss || {})
end)

MGangs.Meta:Register("SetWarStatus", MGangs.Gang,
function(self, gangid, targGid, bool)
  local gangData = self:Exists(gangid)
  local targGangData = self:Exists(targGid)

  if (!gangData or !targGangData) then return false end

  local hasAss, assData = self:HasAssociation(gangid, targGid)

  if !(hasAss) then return false end

  local status = MG2_ASSOCIATIONS:GetStatus(assData && assData.type)
  local statPerms = (status && status.perms)

  if (bool && assData && assData.atWar) then return false, MGangs.Language:GetTranslation("already_at_war_with", (targGangData.name or "NIL")) end
  if (!bool && assData && !assData.atWar) then return false, MGangs.Language:GetTranslation("not_at_war_with", (targGangData.name or "NIL")) end
  if (!statPerms or statPerms && !statPerms.startWar) then return false, MGangs.Language:GetTranslation("cant_start_war_with", (targGangData.name or "NIL")) end

  MGangs.Data:UpdateWhere("mg2_gangassociations", "id", assData.id, {
    ["atWar"] = (bool or false),
  })

  -- Update online members
  MGangs.Gang:GetOnlineMembers(gangid,
  function(ply)
    ply:SendGangAssociations(self:GetAssociations(gangid))
    ply:MG_SendNotification(MGangs.Language:GetTranslation("war_startend_with", (bool && "started" || "ended"), (targGangData.name or "NIL")))
  end)

  MGangs.Gang:GetOnlineMembers(targGid,
  function(ply)
    ply:SendGangAssociations(self:GetAssociations(targGid))
    ply:MG_SendNotification(MGangs.Language:GetTranslation("war_startend_with", (bool && "started" || "ended"), (gangData.name or "NIL")))
  end)

  return true
end)

MGangs.Meta:Register("SetAssociation", MGangs.Gang,
function(self, gangid, targGid, sid)
  local status = MG2_ASSOCIATIONS:GetStatus(sid)
  gangid = tonumber(gangid)
  targGid = tonumber(targGid)

  if (gangid == targGid) then return false, MGangs.Language:GetTranslation("ass_cant_set_owngang") end
  if !(status) then return false end

  local gangData = self:Exists(gangid)
  local targGangData = self:Exists(targGid)

  if (!gangData or !targGangData) then return false end

  local hasAss, assData = self:HasAssociation(gangid, targGid)

  if (hasAss) then
    if (assData.atWar) then return false, MGangs.Language:GetTranslation("at_war_with_gang") end

    if (tonumber(assData.type) != tonumber(sid)) then
      MGangs.Data:UpdateWhere("mg2_gangassociations", "id", assData.id, {
        ["type"] = sid,
        ["atWar"] = false,
      })
    else
      return false, MGangs.Language:GetTranslation("war_startend_with", (status.name or "NIL"), (targGangData.name or "NIL"))
    end
  else
    MGangs.Data:InsertInto("mg2_gangassociations", {
      ["type"] = sid,
      ["gid1"] = gangid,
      ["gid2"] = targGid,
      ["atWar"] = false,
      ["data"] = "[]",
    })
  end

  -- Update online members
  local updMsg = MGangs.Language:GetTranslation("now_ass_with", (status.name or "NIL"), (targGangData.name or "NIL"))

  MGangs.Gang:GetOnlineMembers(gangid,
  function(ply)
    ply:SendGangAssociations(self:GetAssociations(gangid))
    ply:MG_SendNotification(updMsg)
  end)

  MGangs.Gang:GetOnlineMembers(targGid,
  function(ply)
    ply:SendGangAssociations(self:GetAssociations(targGid))
    ply:MG_SendNotification(updMsg)
  end)

  return true, MGangs.Language:GetTranslation("set_gang_ass_to", (targGangData.name or "NIL"), (status.name or "NIL"))
end)

--[[------------
	Player Meta
---------------]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangAssociations(ass)
  self:SendSplitData("MG.Send.GangAssociations", ass, 5)
end
