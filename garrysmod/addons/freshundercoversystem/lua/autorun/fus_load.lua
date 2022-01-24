fus                           = fus or {}
fus.config                    = {}
fus.jobData                   = {}
fus.allowedPlayers            = {}
fus.commands                  = {}
fus.load                      = {}
fus.load[ 'sv' ]              = SERVER and include or function() end
fus.load[ 'sh' ]              = SERVER and function( path ) include( path ) AddCSLuaFile( path ) end or include
fus.load[ 'cl' ]              = CLIENT and include or AddCSLuaFile

function fus.notifyServer( str )
      MsgC( Color( 25, 255, 25 ), 'Fresh Undercover System: ', color_white, str .. '\n' )
end

fus.notifyServer( 'Initializing Fresh Undercover System by Tupac - Bizzy!' )
fus.notifyServer( 'Starting loading proccess!' )

local data, _                    = file.Find( 'fus/*.lua', 'LUA' )

for _, str in ipairs( data ) do

      if fus.load[ str:sub( 1, 2 ) ] then

            fus.load[ str:sub( 1, 2 ) ]( 'fus/' .. str )
            fus.notifyServer( 'Loaded file: ' .. str )

      else

            fus.notifyServer( 'Invalid file format: ' .. str )

      end

end

fus.notifyServer( 'Fully loaded!' )
