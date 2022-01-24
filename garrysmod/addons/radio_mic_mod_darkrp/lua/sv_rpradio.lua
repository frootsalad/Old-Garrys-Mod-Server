
-- Radio + Microphone Mod (DarkRP)
-- By Fish


-- Microphone DL

resource.AddFile( "materials/models/Mic/mic.vmt" )
resource.AddFile( "models/mic.mdl" )


-- Networking

util.AddNetworkString( "radBroads" )
util.AddNetworkString( "radListeners" )

util.AddNetworkString( "radChangeChannel" )
util.AddNetworkString( "radChangeChannelDirect" )

util.AddNetworkString( "radChangeRadVolume" )
util.AddNetworkString( "radSetRadVolume" )

util.AddNetworkString( "radChangeYouTube" )

util.AddNetworkString( "radSetLoop" )

util.AddNetworkString( "radStopYouTube" )

util.AddNetworkString( "radPlayDequeueVideo" )
util.AddNetworkString( "radDequeueVideo" )
util.AddNetworkString( "radEnqueueVideo" )

util.AddNetworkString( "radioQueue" )

util.AddNetworkString( "radBlackListVideo" )
util.AddNetworkString( "radRetrieveBlackList" )
util.AddNetworkString( "radRemoveFromBlackList" )
util.AddNetworkString( "radBlackListTab" )

util.AddNetworkString( "radSetMicHost" )


local function preChecks( ply, ent )

	if ( !IsValid( ent ) || !IsValid( ply ) ) then return false end
	if ( !ent.GetChannel ) then return end
	if ( rpRadio.Config.VoiceRadioOnly && ( ent:GetChannel() > 2 && ent:GetClass() != "rp_radio_microphone" ) ) then return false end
	if ( ply:GetPos():Distance( ent:GetPos() ) > 150 ) then return false end
	if ( ply != ent:Getowning_ent() ) then return false end
	
	return true
end

local function YouTubePreCheck( ply )

	if ( !rpRadio.Config.AllowYouTube ) then return false end
	
	if ( table.Count( rpRadio.Config.YouTubeJobs ) > 0 ) then
		if ( !table.HasValue( rpRadio.Config.YouTubeJobs, ply:Team() ) ) then return false end
	end
	
	if ( table.Count( rpRadio.Config.YouTubeULXRanks ) > 0 ) then
		if ( !ply:IsAdmin() && !table.HasValue( rpRadio.Config.YouTubeULXRanks, ply:GetUserGroup() ) ) then return false end
	end
	
	return true
end

net.Receive( "radSetLoop", function( len, ply )

	local ent = net.ReadEntity()
	
	--
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) || ent:GetChannel() != 3 ) then return end
	
	--
	
	ent:SetLoop( not ent:GetLoop() )
end )


net.Receive( "radChangeYouTube", function( len, ply )

	local ent = net.ReadEntity()
	local id = net.ReadString()
	
	--
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) || ent:GetChannel() != 3 ) then return end
	
	--
	
	timer.Simple( 0.2, function()
	
		ent:PlayVideo( id )
	end )
end )

net.Receive( "radStopYouTube", function( len, ply )

	local ent = net.ReadEntity()
	
	--
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) ) then return end
	
	--
	
	ent:StopVideo()
end )

net.Receive( "radBlackListVideo", function( len, ply )

	if ( !ply:IsAdmin() || !rpRadio.Config.AllowYouTube ) then return end
	
	--
	
	if ( !sql.TableExists( "dRM_blacklist" ) ) then
		local query = "CREATE TABLE dRM_blacklist (title varchar(255), ID varchar(255))"
		sql.Query( query )
	end
	
	--
	
	local title = sql.SQLStr( net.ReadString(), true )
	local ID = sql.SQLStr( net.ReadString(), true )
	
	if ( !sql.Query( "SELECT title, ID FROM dRM_blacklist where ID = '" .. ID .. "'" ) ) then
		sql.Query( "INSERT INTO dRM_blacklist ('title','ID') VALUES ('" .. title .. "', '" .. ID .. "');" )
		ply:SendLua( [[chat.AddText( color_white, '[YouTube] ]] .. rpRadio.getPhrase( "success_remove" ) .. [[' )]] )
	end
end )

net.Receive( "radRemoveFromBlackList", function( len, ply )

	if ( !ply:IsAdmin() || !rpRadio.Config.AllowYouTube ) then return end
	
	--
	
	local ID = sql.SQLStr( net.ReadString(), true )
	
	if ( sql.Query( "SELECT title, ID FROM dRM_blacklist WHERE ID = '" .. ID .. "'" ) ) then
	
		sql.Query( "DELETE FROM dRM_blacklist WHERE ID='" .. ID .. "'" )
		ply:SendLua( [[chat.AddText( color_white, '[YouTube] ]] .. rpRadio.getPhrase( "success_remove" ) .. [[' )]] )
		
		if ( type( sql.Query( "SELECT * FROM dRM_blacklist" ) ) == "table" ) then
			net.Start( "radBlackListTab" )
				net.WriteTable( sql.Query( "SELECT * FROM dRM_blacklist" ) )
			net.Send( ply )
		end
	end
end )

net.Receive( "radRetrieveBlackList", function( len, ply )

	if ( !ply:IsAdmin() || !rpRadio.Config.AllowYouTube ) then return end
	
	--
	
	if ( type( sql.Query( "SELECT * FROM dRM_blacklist" ) ) == "table" ) then
		net.Start( "radBlackListTab" )
			net.WriteTable( sql.Query( "SELECT * FROM dRM_blacklist" ) )
		net.Send( ply )
	end
end )

net.Receive( "radEnqueueVideo", function( len, ply )

	local ent = net.ReadEntity()
	//local title = net.ReadString()
	local id = net.ReadString()
	
	--
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) || ent:GetChannel() != 3 ) then return end
	
	--
	
	ent:EnqueueVideo( id )
end )

net.Receive( "radPlayDequeueVideo", function( len, ply )

	local ent = net.ReadEntity()
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) || ent:GetChannel() != 3 ) then return end
	
	--
	
	ent:PlayDequeueVideo( 1 )
end )

net.Receive( "radDequeueVideo", function( len, ply )

	local ent = net.ReadEntity()
	local num = tonumber( net.ReadString() )
	
	--
	
	if ( !YouTubePreCheck( ply ) || !preChecks( ply, ent ) || ent:GetChannel() != 3 ) then return end
	
	--
	
	ent:DequeueVideo( num )
end )

net.Receive( "radChangeChannel", function( len, ply )

	local ent = net.ReadEntity()
	local dir = net.ReadString() == "u" && true || false
	
	--
	
	if ( !preChecks( ply, ent ) ) then return end
	
	--
	
	ent:ChangeChannel( dir )
end )

net.Receive( "radChangeChannelDirect", function( len, ply )

	local ent = net.ReadEntity()
	local channel = tonumber( net.ReadString() )
	
	channel = math.Clamp( channel, 1, table.Count( rpRadio.stations ) )
	
	--
	
	if ( !preChecks( ply, ent ) ) then return end
	if ( channel == 2 && ent.GetMicHost && !IsValid( ent:GetMicHost() ) ) then return end
	
	--
	
	ent:ChangeChannelDir( channel )
end )

net.Receive( "radChangeRadVolume", function( len, ply )

	local ent = net.ReadEntity()
	local diff = tonumber( net.ReadString() )
	
	--
	
	if ( !preChecks( ply, ent ) ) then return end
	
	--
	
	ent:ChangeVolume( diff )
end )

net.Receive( "radSetRadVolume", function( len, ply )

	local ent = net.ReadEntity()
	local vol = tonumber( net.ReadString() )
	
	--
	
	if ( !preChecks( ply, ent ) ) then return end
	
	--
	
	vol = math.Clamp( vol, 0, rpRadio.Config.VolumeCap )
	vol = math.Clamp( vol, 0, 100 )
	
	ent:SetVolume( vol )
	
	timer.Simple( 0.5, function()
		if ( IsValid( ent ) ) then
			ent:ChangeVolume( 0 )
		end
	end )
end )

function rpRadio.radSetMicHost( ent, mic )

	if ( not rpRadio.listeners[ mic:EntIndex() ] ) then
		rpRadio.listeners[ mic:EntIndex() ] = {}
	end
	
	ent:ChangeLocalHost()
	ent:SetMicHost( mic )
end

net.Receive( "radSetMicHost", function( len, ply )

	local ent = net.ReadEntity()
	local mic = net.ReadEntity()
	
	--
	
	if ( !preChecks( ply, ent ) || !IsValid( mic ) ) then return end
	
	--
	
	rpRadio.radSetMicHost( ent, mic )
	ent:ChangeChannelDir( 2 )
end )


-- Update broadcasters

local function upBroads()

	if ( #rpRadio.ENT_MIC == 0 ) then return end
	
	--
	
	for k, mic in ipairs( rpRadio.ENT_MIC ) do
	
		for _, ply in ipairs( player.GetAll() ) do
		
			if ( not rpRadio.broads[ mic:EntIndex() ] ) then
				rpRadio.broads[ mic:EntIndex() ] = {}
			end
				
			if ( ( ( not rpRadio.Config.MicrophoneDefaultMode && mic:GetOn() ) || ( mic.GetChannel && mic:GetChannel() > 1 ) ) && ply:GetPos():Distance( mic:GetPos() ) <= rpRadio.Config.VoiceRadius && mic:canSeePlayer( ply ) ) then
				
				if ( !table.HasValue( rpRadio.broads[ mic:EntIndex() ], ply ) ) then
				
					table.insert( rpRadio.broads[ mic:EntIndex() ], ply )
					
					net.Start( "radBroads" )
						net.WriteTable( rpRadio.broads )
					net.Broadcast()
				end
			else
			
				if ( table.HasValue( rpRadio.broads[ mic:EntIndex() ], ply ) ) then
					
					table.remove( rpRadio.broads[ mic:EntIndex() ], table.KeyFromValue( rpRadio.broads[ mic:EntIndex() ], ply ) )
				
					net.Start( "radBroads" )
						net.WriteTable( rpRadio.broads )
					net.Broadcast()
				end
			end
		end
	end
end
timer.Create( "DarkRP_Radio_T_getBroad", 2, 0, upBroads )


-- Update listeners

local function upListeners()
	
	if ( #rpRadio.ENT_RAD == 0 ) then return end
	
	--
	
	for _, ply in ipairs( player.GetAll() ) do
	
		local found = false
		
		for k, radio in ipairs( rpRadio.ENT_RAD ) do
		
			if ( radio.GetChannel && radio:GetChannel() == 2 && ply:GetPos():Distance( radio:GetPos() ) < rpRadio.Config.HearRadius && radio:canSeePlayer( ply ) ) then
			
				if ( not rpRadio.listeners[ radio:GetMicHost():EntIndex() ] ) then
					rpRadio.listeners[ radio:GetMicHost():EntIndex() ] = {}
				end
				
				if ( !table.HasValue( rpRadio.listeners[ radio:GetMicHost():EntIndex() ], ply ) ) then
				
					table.insert( rpRadio.listeners[ radio:GetMicHost():EntIndex() ], ply )
					
					net.Start( "radListeners" )
						net.WriteTable( rpRadio.listeners )
					net.Broadcast()
				end
				
				found = true
				break
			end
		end
		 
		if ( not found ) then
		
			for k, v in next, rpRadio.listeners do
			
				if ( table.HasValue( v, ply ) ) then
					
					table.remove( rpRadio.listeners[ k ], table.KeyFromValue( rpRadio.listeners[ k ], ply ) )
					
					net.Start( "radListeners" )
						net.WriteTable( rpRadio.listeners )
					net.Broadcast()
				end
			end
		end
	end
end
timer.Create( "DarkRP_Radio_T_getListen", 2, 0, upListeners )


-- PCHPV hook

local cache = {}

timer.Create( "radioClearCache", 2, 0, function()

	cache = {}
end )

local function plyCanHearPlayer( l, s )

	if ( !s:GetNWBool( "ulx_gagged" ) && rpRadio.onSameChannel( l, s ) ) then
		return true
	end
end

local function getCache( l, s )
	
	local key = tostring( l ) .. tostring( s )
	local result = cache[ key ]
	
	if ( result == nil ) then
	
		cache[ key ] = plyCanHearPlayer( l, s )
		return ( cache[ key ] )
	else
	
		return ( result )
	end
end

hook.Add( "PlayerCanHearPlayersVoice", "DarkRP_Radio_PCHPV", function( l, s )

	return ( getCache( l, s ) )
end )


-- OPCT hook

local function playerChangedTeam( ply, oldTeam, newTeam )

	if ( !rpRadio.Config.RemoveMicOnJobChange ) then return end
	
	--
	
	for _, mic in ipairs( rpRadio.ENT_MIC ) do
	
		local owner = mic:Getowning_ent()
		
		if ( IsValid( owner ) && owner == ply ) then
		
			SafeRemoveEntity( mic )
		end
	end
end
hook.Add( "OnPlayerChangedTeam", "DarkRP_Radio_OPCT", playerChangedTeam )



-- Pocket SWEP fix

local function canPocket( ply, ent )

	if ( IsValid( ent ) && ( ent:GetClass() == "rp_radio" || ent:GetClass() == "rp_radio_microphone" ) ) then
	
		return false, "You are not allowed to pocket this entity!"
	end
end
hook.Add( "canPocket", "DarkRP_Radio_PocketFix", canPocket )


-- Remove radios and microphones

local function removeRadiosMics( ply )
	
	local radT = ents.FindByClass( "rp_radio" )
	local micT = ents.FindByClass( "rp_radio_microphone" )
	
	for i = 1, #radT do
	
		local rad = radT[ i ]
		if ( rad:Getowning_ent() == ply ) then
			SafeRemoveEntity( rad )
		end
	end
	
	for i = 1, #micT do
	
		local mic = micT[ i ]
		if ( mic:Getowning_ent() == ply ) then
			SafeRemoveEntity( mic )
		end
	end
end
hook.Add( "PlayerDisconnected", "DarkRP_Radio_PlayerDisconnected", removeRadiosMics )
