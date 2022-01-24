include('shared.lua')

surface.CreateFont("MG_TERFLAG_XLG", {
  font = "Abel",
  size = 85,
})

surface.CreateFont("MG_TERFLAG_LG", {
  font = "Abel",
  size = 70,
})

surface.CreateFont("MG_TERFLAG_MD", {
  font = "Abel",
  size = 55,
})

surface.CreateFont("MG_TERFLAG_SM", {
  font = "Abel",
  size = 40,
})

surface.CreateFont("MG_TERFLAG_XSM", {
  font = "Abel",
  size = 30,
})

local material = Material( "sprites/splodesprite" )
function ENT:Draw()
    self:DrawModel()

    local claimPly = self:GetClaimingPly()

    local sTID = tonumber(self:GetTerritoryID())
    local sGID = tonumber(self:GetGangID())
    local pGID = tonumber(LocalPlayer():GetGangID())

    local gangData = MGangs.Gang:GetByID(sGID)
    local terrs = MG2_TERRITORIES._tCache
    terrs = (terrs && terrs[sTID] || nil)

    if !(terrs) then return false end

    if (self:GetPos():Distance(LocalPlayer():GetPos()) <= 700) then
      local ang = LocalPlayer():EyeAngles()
    	local pos = self:GetPos() + Vector(0,0,self:OBBMaxs().z + 75)

    	ang:RotateAroundAxis(ang:Forward(), 90)
    	ang:RotateAroundAxis(ang:Right(), 90)

    	cam.Start3D2D(pos, Angle(ang.x, ang.y, ang.z), 0.5)
        draw.DrawText("'" .. terrs.name .. "' " .. MGangs.Language:GetTranslation("territory"), "MG_TERFLAG_LG", 0, -20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(terrs.desc, "MG_TERFLAG_XSM", 0, 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText((
          gangData && MGangs.Language:GetTranslation("t_controlled_by", (gangData.name or "NIL")) ||
          claimPly && IsValid(claimPly) && MGangs.Language:GetTranslation("t_being_claimed_by", (claimPly:Nick() or "NIL")) .. " (" .. math.floor(self:GetClaimStart() - CurTime()) .. "s)!" ||
           MGangs.Language:GetTranslation("t_currently_uncontrolled")), "MG_TERFLAG_XSM", 0, 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      cam.End3D2D()
    end
end

function ENT:Think()
    self:SetNextClientThink(CurTime())

    return true
end

function ENT:ClientAnim(anim,speed)
    local sequence = self:LookupSequence(anim)
    self:SetCycle( 0 )
    self:ResetSequence(sequence)
    self:SetPlaybackRate(speed)
    self:SetCycle( 0 )
end

net.Receive("mgangs2_flagpost_AnimEvent", function(len, ply)
  local animInfo = net.ReadTable()

  if (animInfo) then
    if (IsValid(animInfo.parent) && animInfo.parent != nil && animInfo.anim) then
      if (animInfo.ClientAnim) then
        animInfo.parent:ClientAnim(animInfo.anim, animInfo.speed)
      end
    end
  end
end)
