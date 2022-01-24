function fus.findPlayer( str )

      str                = str:lower()
      local players      = player.GetAll()

      for i = 1, #players do

            local ply = players[ i ]
            if not ply then continue end

            if str == ply:SteamID():lower() then
                  return ply
            end

            if ply:Name():lower():find( str, 1, true ) == 1 then
                  return ply
            end

      end

      return false

end

function fus.isSteamID( str )
      return ( str:sub( 1, 8 ) == 'STEAM_0:' )
end

function fus.translate( key )
      return fus.config.translate[ key ] or ''
end
