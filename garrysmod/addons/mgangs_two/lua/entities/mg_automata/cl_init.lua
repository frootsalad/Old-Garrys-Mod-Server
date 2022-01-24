include('shared.lua')

surface.CreateFont("MG_AUTOMATA_TEXT", {
	font = "Abel",
	size = 68,
})

function ENT:Draw()
    self:DrawModel()

    if (self:GetPos():Distance(LocalPlayer():GetPos()) < 350) then
		local entSize = self:OBBMaxs()
		local ang = LocalPlayer():EyeAngles()
		local pos = self:EyePos() + Vector(0,0,(entSize.z + 40))

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, Angle(ang.x, ang.y, ang.z), 0.4)
            draw.DrawText(MGangs.Config.GangEntityText, "MG_AUTOMATA_TEXT", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		cam.End3D2D()
  	end
end
