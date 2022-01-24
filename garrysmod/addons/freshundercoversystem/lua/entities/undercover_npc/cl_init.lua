include 'shared.lua'

function ENT:Draw()

      self:DrawModel()

      if self:GetPos():Distance( LocalPlayer():GetPos() ) > fus.config.npc[ 'overheadTextHide' ] then return end

      local hop               = math.abs( math.cos( CurTime() * 1 ) )
      local pos               = self:GetPos() + Vector( 0, 0, 84 + hop * 15 )
      local ang               = Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 )

      cam.Start3D2D( pos, ang, 0.1 )
            draw.SimpleText( '>> ' .. fus.config.npc[ 'overheadText' ] .. ' <<', 'fus_font_130', 0, 0, fus.config.npc[ 'overheadTextColor' ], 1 )
      cam.End3D2D()

end
