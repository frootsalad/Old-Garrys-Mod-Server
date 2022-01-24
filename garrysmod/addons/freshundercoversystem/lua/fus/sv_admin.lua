function fus.registerCommand( data )

      fus.commands[ data.name:lower() ] = data
      fus.notifyServer( 'Registered command: ' .. data.name )

end

local data              = {}
data.name               = 'savefus'
data.description        = '!savefus - Saves all entities and job data!'

data.onRan              = function( ply, args )

      fus.saveData()
      fus.notifyPlayer( ply, 'You saved all data related to ', Color( 25, 255, 25 ), 'Fresh Undercover System!' )

end

fus.registerCommand( data )

data                    = {}
data.name               = 'fusadmin'
data.description        = '!fusadmin - Opens up admin menu where you can configurate the system!'

data.onRan              = function( ply, args )

      fus.notifyPlayer( ply, 'Opening the admin menu...' )

      net.Start( 'fus.openAdminMenu' )
            net.WriteTable( fus.jobData )
      net.Send( ply )

end

fus.registerCommand( data )

data                    = {}
data.name               = 'fuswhitelist'
data.description        = '!fuswhitelist < player name/SteamID > - Whitelists a player to be allowed to use the NPC anytime, white being any job!'

data.onRan              = function( ply, args )

      if not args[ 2 ] then

            fus.notifyPlayer( ply, 'Please enter a name/SteamID' )
            return

      end

      local target      = fus.findPlayer( args[ 2 ] )
      local sid         = args[ 2 ]

      if target then
            sid = target:SteamID()
      end

      if not fus.isSteamID( sid ) then

            fus.notifyPlayer( ply, 'Invalid SteamID!' )
            return

      end

      fus.allowedPlayers[ sid ] = true
      fus.saveData()

      fus.notifyPlayer( ply, 'Whitelisted ', target and team.GetColor( target:Team() ) or Color( 25, 255, 25 ), target and target:Name() or sid, color_white, ', they are now allowed to use the NPC anytime! To undo this, use !fusunwhitelist.' )
      fus.notifyPlayer( ply, 'All data has been saved!')

      if target then
            fus.notifyPlayer( target, 'You have been whitelisted by ', Color( 25, 25, 255 ), ply:Name(), color_white, ' you are now able to use the NPC anytime!' )
      end

end

fus.registerCommand( data )

data                    = {}
data.name               = 'fusunwhitelist'
data.description        = '!fusunwhitelist < player name/SteamID > - Unwhitelist a player, so they are only able to use the NPC when they are the correct job!'

data.onRan              = function( ply, args )

      if not args[ 2 ] then

            fus.notifyPlayer( ply, 'Please enter a player name/SteamID!' )
            return

      end

      local target      = fus.findPlayer( args[ 2 ] )
      local sid         = args[ 2 ]

      if target then
            sid = target:SteamID()
      end

      if not fus.isSteamID( sid ) then

            fus.notifyPlayer( ply, 'Invalid SteamID!' )
            return

      end

      fus.allowedPlayers[ sid ] = false
      fus.saveData()

      fus.notifyPlayer( ply, 'Unwhitelisted ', target and team.GetColor( target:Team() ) or Color( 25, 255, 25 ), target and target:Name() or sid, color_white, ', they are now no longer allowed to use the NPC, unless they are the correct job!' )
      fus.notifyPlayer( ply, 'All data has been saved!')

      if target then
            fus.notifyPlayer( target, 'You have been unwhitelisted by ', Color( 25, 25, 255 ), ply:Name() )
      end

end

fus.registerCommand( data )

data                    = {}
data.name               = 'fuscommands'
data.description        = '!fuscommands - Display a full list of commands used by FUS!'

data.onRan              = function( ply, args )

      local commands    = {}

      for _, data in pairs( fus.commands ) do

            commands[ _ ] = {
                  description = data.description
            }

      end

      net.Start( 'fus.printCommands' )
            net.WriteTable( commands )
      net.Send( ply )

      fus.notifyPlayer( ply, 'A full list of commands have been printed into your console!' )

end

fus.registerCommand( data )

data                    = {}
data.name               = 'undercoverlist'
data.description        = '!undercoverlist - Prints a list of undercover players into console!'

data.onRan              = function( ply )

      net.Start( 'fus.printUndercover' )
      net.Send( ply )

      fus.notifyPlayer( ply, 'A full list of undercover players has been printed into your console!' )

end

fus.registerCommand( data )

function fus.checkCommand( ply, str )

      local args              = string.Explode( ' ', str )
      args[ 1 ]               = args[ 1 ]:Replace( '!', '' )

      if fus.commands[ args[ 1 ]:lower() ] then

            if fus.config.adminRanks[ ply:GetUserGroup() ] then

                  fus.commands[ args[ 1 ] ].onRan( ply, args )

            else

                  fus.notifyPlayer( ply, 'You are not the correct rank to do this!' )

            end

            return ''

      end

end

hook.Add( 'PlayerSay', 'fus.checkCommand', fus.checkCommand )
