include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

hook.Add("PostDrawOpaqueRenderables", "AEL_Title", function()
	for _, ent in pairs (ents.FindByClass("ael_secretary")) do
		if ent:GetPos():Distance(LocalPlayer():GetPos()) < 800 then
			local plyAng = LocalPlayer():GetAngles()
			local ang = Angle(0, plyAng.y - 180, 0)

			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)

			cam.Start3D2D(ent:GetPos() + ent:GetForward() + ent:GetUp() * 85, ang, 0.1)
				draw.RoundedBox(7, -175, -80, 350, 160, Color(32, 36, 38, 255))
				draw.RoundedBox(7, -175, -80, 350, 155, Color(42, 46, 48, 255))

				draw.SimpleText( "Mayor's", "AEL_Font5", 0, -85, ael_accentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText( "Secretary", "AEL_Font6", 0, -10, ael_accentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end
end)

function ENT:Draw()
	self:DrawModel()
end
