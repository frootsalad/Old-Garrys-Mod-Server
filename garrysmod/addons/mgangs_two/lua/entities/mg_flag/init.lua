AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/zerochain/mgangs2/mgang_flagpost.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()

  if (phys:IsValid()) then
    phys:Wake()
  end

  self:UseClientSideAnimation()

  self:SendClientAnim("idle_closed",1)
end

function ENT:ClaimTerritory(ply)
  if (self.ClaimerPly) then return false, MGangs.Language:GetTranslation("someone_else_is_claiming") end
  if !(ply:HasGang()) then return false, MGangs.Language:GetTranslation("youre_not_ina_gang") end

  local tUncon = (MG2_TERRITORIES && MG2_TERRITORIES.config.claimWait.uncon or 0)
  local tCon = (MG2_TERRITORIES && MG2_TERRITORIES.config.claimWait.con or 10)

  local sTID = tonumber(self:GetTerritoryID())
  local sGID = tonumber(self:GetGangID())
  local pGID = tonumber(ply:GetGangID())

  local terrs = MG2_TERRITORIES._tCache
  terrs = (terrs && terrs[sTID] || nil)

  if !(terrs) then return false end

  if (sGID <= 0) then    -- No gang
    local succ, msg = self:StartClaim(ply, tUncon)

    return succ, msg
  elseif (sGID > 0) then
    if (sGID != pGID) then
      local succ, msg = self:StartClaim(ply, tCon)

      return succ, msg
    else
      return false, MGangs.Language:GetTranslation("cant_claim_own_territory")
    end
  else
    return false, MGangs.Language:GetTranslation("cant_claim_territory")
  end
end

function ENT:Use(activator, caller)
  local succ, msg = self:ClaimTerritory(caller)

  if (msg) then
    caller:MG_SendNotification(msg)
  end
end

--[[Claiming]]
function ENT:ClearClaim()
  self:SetClaimingPly(nil)
  self:SetClaimStart(0)

  if (self:GetGangID() > 0) then
    self:SendClientAnim("open", 1)
    self:SendClientAnim("idle_open", 1)
  end
end

function ENT:StartClaim(ply, time)
  local sTID = tonumber(self:GetTerritoryID())
  local sGID = tonumber(self:GetGangID())

  local terrs = MG2_TERRITORIES._tCache
  terrs = (terrs && terrs[sTID] || nil)

  if (time <= 0) then self:FinishClaim(ply, true) return true, MGangs.Language:GetTranslation("claimed_territory_for", (terrs.name or "NIL"))  end

  self:SendClientAnim("fold", 1)
  self:SendClientAnim("idle_closed", 1)

  self:SetClaimingPly(ply)
  self:SetClaimStart(CurTime() + time)

  if (sGID > 0) then
    MGangs.Gang:GetOnlineMembers(sGID,
    function(ply)
      ply:MG_SendNotification(MGangs.Language:GetTranslation("territory_is_being_claimed", (terrs.name or "NIL")))
    end)
  end

  return true, MGangs.Language:GetTranslation("must_wait_seconds", time)
end

function ENT:FinishClaim(ply, noMsg)
  local sTID = tonumber(self:GetTerritoryID())
  local sGID = tonumber(self:GetGangID())
  local pGID = tonumber(ply:GetGangID())
  local gData = MGangs.Gang:Exists(pGID)

  if !(gData) then return false end

  local terrs = MG2_TERRITORIES._tCache
  terrs = (terrs && terrs[sTID] || nil)

  local trUncon = (MG2_TERRITORIES && MG2_TERRITORIES.config.claimRewards.uncon or {exp=10,money=100})
  local trCon = (MG2_TERRITORIES && MG2_TERRITORIES.config.claimRewards.con or {exp=100,money=1000})

  if (sGID > 0) then
    MGangs.Gang:SetExp(pGID, (gData.exp or 0) + trCon.exp)
    MGangs.Gang:SetMoney(pGID, (gData.balance or 0) + trCon.money)
  else
    MGangs.Gang:SetExp(pGID, (gData.exp or 0) + trUncon.exp)
    MGangs.Gang:SetMoney(pGID, (gData.balance or 0) + trUncon.money)
  end

  self:ClearClaim()

  self:SetGangID(ply:GetGangID())
  self:SetCaptureTime(os.time())

  self:SendClientAnim("open", 1)
  self:SendClientAnim("idle_open", 1)

  if !(noMsg) then
    ply:MG_SendNotification(MGangs.Language:GetTranslation("claimed_territory_for", (terrs.name or "NIL")))
  end
end

function ENT:Think()
  --[[Claiming]]
  local cPly = self:GetClaimingPly()

  if (cPly && IsValid(cPly)) then
    if !(cPly:Alive()) then self:ClearClaim() cPly:MG_SendNotification(MGangs.Language:GetTranslation("t_notclaming_dead")) return false end
    if (cPly:GetPos():Distance(self:GetPos()) > MG2_TERRITORIES.config.claimRadius) then self:ClearClaim() cPly:MG_SendNotification(MGangs.Language:GetTranslation("t_notclaming_toofar")) return false end

    if (self:GetClaimStart() <= CurTime()) then
      self:FinishClaim(cPly)
    end
  end

  --[[Controlling/Occupying rewards]]
  local occRew = MG2_TERRITORIES.config.occupyRewards

  if (occRew && occRew.enabled) then
    local sTID = self:GetTerritoryID()
    local sGID = self:GetGangID()

    local terrs = MG2_TERRITORIES._tCache
    terrs = (terrs && terrs[sTID] || nil)

    if (sGID > 0 && terrs) then
      local occTime = (occRew.time or 60)

      if !(self.nOccRew) then self.nOccRew = CurTime() + occTime return false end

      if (self.nOccRew <= CurTime()) then
        self.nOccRew = CurTime() + occTime

        local formatOccTime = string.FormattedTime(occTime, "%02im %02is")
        local gangData = MGangs.Gang:Exists(sGID)

        if (gangData) then
          MGangs.Gang:SetExp(sGID, (gangData.exp or 0) + occRew.exp)
          MGangs.Gang:SetMoney(sGID, (gangData.balance or 0) + occRew.money)

          MGangs.Gang:GetOnlineMembers(sGID,
          function(ply)
            ply:MG_SendNotification("Your gang has been rewarded for holding the territory '" .. terrs.name .. "' for " .. formatOccTime .. " consecutively!")
          end)
        else
          self:SetGangID(0)
        end
      end
    end
  end
end

--[[
idle_closed (IDLE - CLOSED)
open  (OPEN)
idle_open (IDLE - OPENED)
fold  (CLOSE)
]]
util.AddNetworkString( "mgangs2_flagpost_AnimEvent" )

function ENT:SendClientAnim(anim,speed)
    self:ServerAnim(anim,speed)
    net.Start("mgangs2_flagpost_AnimEvent")
      net.WriteTable({
        anim = anim,
        speed = speed,
        parent = self
      })
    net.Broadcast()
end

function ENT:ServerAnim(anim,speed)
    local sequence = self:LookupSequence(anim)
    self:SetCycle(0)
    self:ResetSequence(sequence)
    self:SetPlaybackRate(speed)
    self:SetCycle(0)
end
