include('shared.lua')

SWEP.PrintName      = "Territory Marker"
SWEP.Slot			= 3
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

function SWEP:DrawHUD()
  local txtStr, txtFont = table.concat(self.instrTbl, " | "), "MG_GangInfo_SM"

  surface.SetFont(txtFont)
  local tsW, tsH = surface.GetTextSize(txtStr)

	local lW, lH = (tsW + 10), (tsH + 10)
	local lX, lY = ScrW()/2 - lW/2, ScrH() - (lH + 10)

  draw.RoundedBoxEx(4,lX-2,lY-2,lW+4,lH+4,Color(255,0,0,255*math.sin(CurTime())),true,true,true,true)
	draw.RoundedBoxEx(4,lX,lY,lW,lH,Color(45,45,45,255),true,true,true,true)

	draw.SimpleText(txtStr, txtFont, ScrW()/2, ScrH() - (lH/2 + 10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

hook.Add("PostDrawOpaqueRenderables", "MG2.TTMarker.PostDrawOpaqueRenderables",
function(dDepth, dSkyBox)
	local tr = LocalPlayer():GetEyeTrace()
  local wep = LocalPlayer():GetActiveWeapon()
	local bPoints = (wep && wep.BoxPoints)

	if (bPoints) then
  	local bPos1, bPos2 = (bPoints[1] or tr.HitPos), (bPoints[2] or Vector(2,2,2))

  	render.DrawWireframeBox(bPos1, Angle(0,0,0), Vector(0,0,0), bPos2, Color(5,255,5,255))
  	render.DrawWireframeSphere(tr.HitPos, 2, 15, 15, Color(5,255,5))
  	render.Model({
  		model = "models/zerochain/mgangs2/mgang_flagpost.mdl",
  		pos = (wep.Flag.pos or tr.HitPos),
  		ang = Angle(0,0,0),
  	})
  end
end)
