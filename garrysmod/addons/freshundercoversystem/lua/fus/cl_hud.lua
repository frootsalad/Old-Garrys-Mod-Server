local btn

function fus.hud()

      local ply = LocalPlayer()

      if ply:GetNWBool( 'isUndercover' ) then

            local timeLeft          = ply:GetNWInt( 'undercoverEnd' ) - CurTime()
            local mainBarW          = 300
            local barW              = mainBarW * timeLeft / fus.config.undercover[ 'undercoverTime' ]
            local barH              = 20

            fus.drawBox( ScrW() / 2 - ( mainBarW / 2 ), 0, mainBarW, barH )
            fus.drawBox( ScrW() / 2 - ( mainBarW / 2 ), 0, barW, barH, fus.clientVal( 'undercoverBarColor' ) )

            fus.txt( 'Undercover as: ' .. LocalPlayer():getDarkRPVar( 'job' ), 15, ScrW() / 2, 10, nil, 1, 1 )

      end

end

hook.Add( 'HUDPaint', 'fus.hud', fus.hud )
