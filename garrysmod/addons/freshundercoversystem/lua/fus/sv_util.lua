function fus.undercoverStart( ply, id )

      if not fus.canUndercover( ply, id ) then return end

      local data                    = fus.jobData[ id ]
      ply.oldTeam                   = ply:Team()
      ply.oldWeapons                = ply:GetWeapons()
      ply.oldUndercoverPos          = ply:GetPos()
      ply.oldUndercoverAng          = ply:GetAngles()

      ply:changeTeam( data.team, true )
      ply:Spawn()
      ply:SetPos( ply.oldUndercoverPos )
      ply:SetAngles( ply.oldUndercoverAng )

      for _, wep in ipairs( ply.oldWeapons ) do
            ply:Give( wep:GetClass() )
      end

      if fus.config.undercover[ 'undercoverTime' ] ~= 0 then

            timer.Create( ply:SteamID() .. '_undercovertimer', fus.config.undercover[ 'undercoverTime' ], 1, function()
                  fus.undercoverEnd( ply )
            end )

      end

      ply.isUndercover = true

      ply:SetNWBool( 'isUndercover', true )
      ply:SetNWString( 'oldUndercoverTeam', team.GetName( ply.oldTeam ) )
      ply:SetNWInt( 'undercoverEnd', CurTime() + fus.config.undercover[ 'undercoverTime' ] )

      local str         = fus.translate( 'undercoverBegin' )
      str               = str:Replace( '%name', team.GetName( data.team ) )

      fus.notifyPlayer( ply, str )

      net.Start( 'fus.undercoverNotify' )
            net.WriteBool( ply.isUndercover )
      net.Send( ply )

end

function fus.undercoverEnd( ply, nochange )

      timer.Destroy( ply:SteamID() .. '_undercovertimer' )

      if not nochange then

            local oldpos = ply:GetPos()
            local oldang = ply:EyeAngles()

            ply:changeTeam( ply.oldTeam, true )
            ply:Spawn()
            ply:SetPos( oldpos )
            ply:SetEyeAngles( oldang )

      end

      ply:SetNWBool( 'isUndercover', false )

      ply.isUndercover               = false
      ply.undercoverCooldown         = fus.config.undercover[ 'undercoverCooldown' ] + CurTime()
      ply.oldTeam                    = ply:Team()

      fus.notifyPlayer( ply, fus.translate( 'undercoverEnd' ) )

      net.Start( 'fus.undercoverNotify' )
            net.WriteBool( ply.isUndercover )
      net.Send( ply )

end

function fus.canUndercover( ply, id )

      local data = fus.jobData[ id ]

      if not data then

            fus.notifyPlayer( ply, 'Undercover team not found!' )
            return false

      end

      local groupCheck        = function() return true end
      local jobCheck          = function() return true end

      if data.allowedGroups and istable( data.allowedGroups ) then

            groupCheck = function()
                  return data.allowedGroups[ ply:GetUserGroup() ]
            end

      end

      if data.allowedJobs and istable( data.allowedJobs ) then

            jobCheck = function()
                  return data.allowedJobs[ team.GetName( ply:Team() ) ]
            end

      end

      if not groupCheck() then

            fus.notifyPlayer( ply, fus.translate( 'wrongGroup' ) )
            return false

      end

      if not jobCheck() then

            fus.notifyPlayer( ply, fus.translate( 'wrongJob' ) )
            return false

      end

      if ply.isUndercover then

            fus.notifyPlayer( ply, fus.translate( 'alreadyUndercover' ) )
            return false

      end

      if not ply:Alive() then return false end

      return true

end

function fus.notifyPlayer( ply, ... )

      local data = { ... }

      net.Start( 'fus.notifyPlayer' )
            net.WriteTable( data )
      net.Send( ply )

end

function fus.addJob( id, group, job )

      if not team.GetAllTeams()[ id ] then return end

      local num = #fus.jobData + 1

      for _, data in ipairs( fus.jobData ) do

            if data.team == id then

                  num = _
                  break

            end

      end

      fus.jobData[ num ] = {
            team = id
      }

      if group and istable( group ) and table.Count( group ) >= 1 then

            fus.jobData[ num ].allowedGroups = {}

            for _, str in pairs( group ) do
                  fus.jobData[ num ].allowedGroups[ str ] = true
            end

      else

            fus.jobData[ num ].allowedGroups = nil

      end

      if job and istable( job ) and table.Count( job ) >= 1 then

            fus.jobData[ num ].allowedJobs = {}

            for _, str in pairs( job ) do
                  fus.jobData[ num ].allowedJobs[ str ] = true
            end

      else

            fus.jobData[ num ].allowedJobs = nil

      end

      fus.saveData()
      fus.sendJobs( player.GetAll() )

end

function fus.deleteJob( id )

      fus.jobData[ id ] = nil

      for i, v in ipairs(fus.jobData) do

            if i > id then

                  fus.jobData[ i ] = nil
                  fus.jobData[ id ] = v
                  id = id + 1

            end

      end

      fus.saveData()
      fus.sendJobs( player.GetAll() )

end

function fus.sendJobs( ply )

      local data = fus.jobData
      if not data then return end

      net.Start( 'fus.broadcastJobs' )
            net.WriteTable( data )
      net.Send( ply )

end

function fus.playerSpawn( ply )
      fus.sendJobs( ply )
end

hook.Add( 'PlayerInitialSpawn', 'fus.playerSpawn', fus.playerSpawn )

function fus.canOpenMenu( ply )

      if fus.allowedPlayers[ ply:SteamID() ] then return true end

      if not fus.config.allowedTeams[ ply:Team() ] then

            fus.notifyPlayer( ply, fus.translate( 'cantUseAsJob' ) )
            return false

      end

      if ply.isUndercover then

            fus.notifyPlayer( ply, fus.translate( 'alreadyUndercover' ) )
            return false

      end

      if ply.undercoverCooldown and ply.undercoverCooldown >= CurTime() then

            fus.notifyPlayer( ply, fus.translate( 'stillCooldown' ) )
            return false

      end

      return true

end
