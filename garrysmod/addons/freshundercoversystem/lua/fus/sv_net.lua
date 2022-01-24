util.AddNetworkString 'fus.notifyPlayer'
util.AddNetworkString 'fus.openAdminMenu'
util.AddNetworkString 'fus.openMenu'
util.AddNetworkString 'fus.undercoverStart'
util.AddNetworkString 'fus.undercoverNotify'
util.AddNetworkString 'fus.quickEnd'
util.AddNetworkString 'fus.addJob'
util.AddNetworkString 'fus.deleteJob'
util.AddNetworkString 'fus.broadcastJobs'
util.AddNetworkString 'fus.printUndercover'
util.AddNetworkString 'fus.printCommands'

net.Receive( 'fus.undercoverStart', function( _, ply )
      fus.undercoverStart( ply, net.ReadInt( 32 ) )
end )

net.Receive( 'fus.quickEnd', function( _, ply )

      if not ply.isUndercover then return end

      fus.undercoverEnd( ply )

end )

net.Receive( 'fus.addJob', function( _, ply )

      if not fus.config.adminRanks[ ply:GetUserGroup() ] then return end

      local curTeam            = net.ReadInt( 32 )
      if not curTeam then return end

      local groupData          = net.ReadTable()
      local jobData            = net.ReadTable()

      fus.addJob( curTeam, groupData, jobData )
      fus.notifyPlayer( ply, 'Added job specified by you.' )

end )

net.Receive( 'fus.deleteJob', function( _, ply )

      if not fus.config.adminRanks[ ply:GetUserGroup() ] then return end

      local curTeam      = net.ReadInt( 32 )
      if not curTeam then return end

      local id           = 0

      for _, data in pairs( fus.jobData ) do

            if data.team == curTeam then

                  id = _
                  break

            end

      end

      if fus.jobData[ id ] then
            fus.notifyPlayer( ply, 'Removed job specified by you.' )
      end

      fus.deleteJob( id )

end )
