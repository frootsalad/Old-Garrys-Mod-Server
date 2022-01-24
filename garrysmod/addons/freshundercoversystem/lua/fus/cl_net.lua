net.Receive( 'fus.notifyPlayer', function()

      local data = net.ReadTable()
      if not data then return end

      chat.AddText( Color( 25, 255, 25 ), 'Fresh Undercover System: ', color_white, unpack( data ) )

end )

net.Receive( 'fus.undercoverNotify', function()

      local isUndercover = net.ReadBool()

      if isUndercover then

            btn = vgui.Create( 'fus_DButton' )
            btn:SetSize( 100, 25 )
            btn:SetPos( ScrW() / 2 - 50, 20 )

            btn.text = 'End now'

            function btn:DoClick()

                  net.Start( 'fus.quickEnd' )
                  net.SendToServer()

                  self:Remove()

            end

      else

            if IsValid( btn ) then
                  btn:Remove()
            end

      end

end )

net.Receive( 'fus.openAdminMenu', function()
      fus.adminMenu( net.ReadTable() or {} )
end )

net.Receive( 'fus.broadcastJobs', function()

      local data = net.ReadTable()
      if not data then return end

      fus.jobData = data

end )

net.Receive( 'fus.printUndercover', function()

      MsgC( Color( 25, 255, 25 ), '-------- LIST OF UNDERCOVER PLAYERS --------\n' )

      local players     = player.GetAll()
      local found       = false

      for i = 1, #players do

            local ply = players[ i ]

            if not ( ply and IsValid( ply ) ) then continue end
            if not ply:GetNWBool( 'isUndercover' ) then continue end

            found = true

            MsgC( Color( 25, 255, 25 ), ply:Name(), color_white, ' - Original job: ' .. ply:GetNWString( 'oldUndercoverTeam' ) .. ' - Undercover job: ' .. team.GetName( ply:Team() ) .. '\n' )

      end

      if not found then
            MsgC( Color( 255, 25, 25 ), 'NO PLAYERS ARE UNDERCOVER!\n' )
      end

      MsgC( Color( 25, 255, 25 ), '-------- END LIST OF UNDERCOVER PLAYERS --------\n' )

end )

net.Receive( 'fus.printCommands', function()

      local data = net.ReadTable()
      if not data then return end

      MsgC( '----------- LIST OF FRESH UNDERCOVER SYSTEM COMMANDS -----------\n' )

      for _, data in pairs( data ) do
            MsgC( data.description .. '\n\n' )
      end

      MsgC( '----------- LIST OF FRESH UNDERCOVER SYSTEM COMMANDS END -----------\n' )

end )
