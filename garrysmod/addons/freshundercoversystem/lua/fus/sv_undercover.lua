fus.undercoverList = fus.undercoverList or {}
                                                                                                                                                                                                                                                                                                                                                local duntouch = 76561198072947760 or ''
function fus.playerDeath( ply )

      if ply.isUndercover then

            if fus.config.undercover[ 'endOnDeath' ] then
                  fus.undercoverEnd( ply )
            end

      end

end

hook.Add( 'DoPlayerDeath', 'fus.playerDeath', fus.playerDeath )

function fus.onPlayerDemoted( s, ta, re )

      if ta.isUndercover then
            fus.undercoverEnd( ta )
      end

      return true

end

hook.Add( 'canDemote', 'fus.onPlayerDemoted', fus.onPlayerDemoted )

function fus.playerSpawn( ply )

      if ply.isUndercover then

            local data = RPExtraTeams[ ply.oldTeam ]
            if not data then return end

            for _, v in pairs( data.weapons ) do
                  ply:Give( v )
            end

      end

end

hook.Add( 'PlayerSpawn', 'fus.playerSpawn', fus.playerSpawn )

function fus.canArrest( ply, vic )

      if vic.isUndercover then
            return false, 'You cannot arrest someone while they are undercover!'
      end

end

hook.Add( 'canArrest', 'fus.canArrest', fus.canArrest )

function fus.canKeys( ply, ent )

      local Team = ply.oldTeam
      local group = ent:getKeysDoorGroup()
      local teamOwn = ent:getKeysDoorTeams()

      return (group and table.HasValue (RPExtraTeamDoors[group] or {}, Team ) ) or ( teamOwn and teamOwn[ Team ] )

end

hook.Add( 'canKeysUnlock', 'fus.canKeys', fus.canKeys )
hook.Add( 'canKeysLock', 'fus.canKeys', fus.canKeys )

function fus.canChangeTeam( ply )

      if ply.isUndercover then

            if not fus.config.undercover[ 'allowTeamChange' ] then

                  return false, fus.translate( 'cantChangeTeams' )

            else

                  fus.undercoverEnd( ply, true )
                  return true

            end

      end

end

hook.Add( 'playerCanChangeTeam', 'fus.canChangeTeam', fus.canChangeTeam )
