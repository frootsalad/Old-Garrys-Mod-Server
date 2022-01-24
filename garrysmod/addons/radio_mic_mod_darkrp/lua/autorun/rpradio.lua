
-- Radio + Microphone Mod (DarkRP)
-- By Fish

-- Precache model

util.PrecacheModel( "models/mic.mdl" )


-- Setup tables

rpRadio = {}

rpRadio.broads = {}
rpRadio.listeners = {}


-- Radio stations

rpRadio.stations = { { "Offline", "offline" }, { "In-Game Channel", "game" }, { "YouTube", "youtube" } }

function rpRadio.addStation( name, url )

	//if ( not rpRadio.Config.VoiceRadioOnly ) then
	
		table.insert( rpRadio.stations, { name, url } )
	//end
end

function rpRadio.onSameChannel( l, s )

	for _, e in next, rpRadio.broads do
	
		if ( !rpRadio.listeners[ _ ] ) then continue end
		
		if ( table.HasValue( rpRadio.listeners[ _ ], l ) && table.HasValue( rpRadio.broads[ _ ], s ) ) then
		
			return true
		end
	end
	
	return false
end


-- Languages

local languages = {}
local curr_lang = GetConVarString( "gmod_language" )

function rpRadio.addLanguage( name, lang )

	languages[ name ] = lang
end

function rpRadio.getPhrase( name )

	if ( languages[ curr_lang ] ) then
		return ( languages[ curr_lang ][ name ] )
	elseif ( languages[ "en" ] ) then
		return ( languages[ "en" ][ name ] )
	end
	
	return ( "error" )
end

function rpRadio.getPhraseKey( value )

	if ( languages[ curr_lang ] ) then
		return ( table.KeyFromValue( languages[ curr_lang ], value ) )
	elseif ( languages[ "en" ] ) then
		return ( table.KeyFromValue( languages[ "en" ], value ) )
	end
	
	return ( "error" )
end


-- File management

include( 'sh_rpradio_config.lua' )
include( 'sh_rpradio.lua' )

local f = file.Find( 'rpradio_lang/*', 'LUA' )

for k, v in ipairs( f ) do
	if ( SERVER ) then
		AddCSLuaFile( 'rpradio_lang/' .. v )
	end
	include( 'rpradio_lang/' .. v )
end

if ( SERVER ) then
	
	AddCSLuaFile()
	AddCSLuaFile( 'sh_rpradio_config.lua' )
	AddCSLuaFile( 'sh_rpradio.lua' )
	
	AddCSLuaFile( 'cl_rpradio.lua' )
	AddCSLuaFile( 'cl_rpradio_menu.lua' )
	
	resource.AddFile( "models/mic.mdl" )
	resource.AddFile( "materials/models/mic/mic.vmt" )
	
	resource.AddFile( "materials/vgui/entities/rp_radio.vmt" )
	resource.AddFile( "materials/vgui/entities/rp_radio_microphone.vmt" )
	
	include( 'sv_rpradio.lua' )
end

if ( CLIENT ) then
	
	include( 'cl_rpradio.lua' )
	include( 'cl_rpradio_menu.lua' )
end

rpRadio.stations[ 1 ] = { rpRadio.getPhrase( "offline" ), "offline" }
rpRadio.stations[ 2 ] = { rpRadio.getPhrase( "in_game_chan" ), "game" }
