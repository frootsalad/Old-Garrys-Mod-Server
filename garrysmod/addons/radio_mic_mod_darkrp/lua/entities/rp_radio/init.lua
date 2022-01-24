
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )


util.AddNetworkString( "getRadDuration" )


function ENT:SpawnFunction( ply, tr )

	if ( !IsValid( ply ) ) then return end
	
	--
	
	local rad = ents.Create( "rp_radio" )
	rad:SetPos( tr.HitPos )
	rad:Setowning_ent( ply )
	rad:Spawn()
	rad:Activate()
	
	return rad
end

function ENT:Initialize()

	self:SetModel( "models/props_lab/citizenradio.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	
	if( phys:IsValid() ) then 
		
		phys:Wake()
	end
	
	self:SetLoop( false )
	self:SetChannel( 1 )
	self:SetVolume( math.Clamp( math.Clamp( rpRadio.Config.DefaultVolume, 0, rpRadio.Config.VolumeCap ), 0, 100 ) )
	
	self.health = 100
end

function ENT:Use( ply )

	if ( !IsValid( ply ) ) then return end
	
	--
	
	if ( rpRadio.Config.OnlyRadioOwner ) then
	
		if ( IsValid( self:Getowning_ent() ) && ply != self:Getowning_ent() ) then
		
			umsg.Start( "notOwnerRadio", ply )
			umsg.End()
			
			return
		end
	end
	
	--
	
	umsg.Start( "rpRadioMenu", ply )
		umsg.Entity( self )
	umsg.End()
end

function ENT:OwnerCheck( ply )

	if ( rpRadio.Config.OnlyRadioOwner ) then
	
		local owner = self.Getowning_ent && self:Getowning_ent() || ( self.GetMicOwner && self:GetMicOwner() )
		return ( ply == owner )
	end
	
	return true
end

function ENT:StopVideo()

	self:PlayVideo( "" )
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	umsg.Start( "stopYouTubeRad", rf )
		umsg.Entity( self )
	umsg.End()
	
	--
	
	// Check the queue now
	if ( rpRadio.Config.AllowYouTube ) then
		if ( self:GetChannel() == 3 && self:GetVideoId() == "" && self.queue && self.queue[1] ) then
			self:PlayDequeueVideo()
		end
	end
end

-- Video length

local vidChar = {}
vidChar[ "H" ] = 3600
vidChar[ "M" ] = 60
vidChar[ "S" ] = 1

local function calcVideoLen( dur )
	
	local i = 3
	local length = 0
	
	local strN = ""
	
	while ( i <= string.len( dur ) ) do
		
		local char = string.sub( dur, i, i )
		
		if ( not vidChar[ char ] ) then
			
			strN = strN .. char
		else
			
			length = length + ( tonumber( strN ) * vidChar[ char ] )
			strN = ""
		end
		
		i = i + 1
	end
	
	return length
end

function ENT:EnqueueVideo( id )
	
	local request = {
		url = 'https://www.googleapis.com/youtube/v3/videos?id=' .. id .. '&key=AIzaSyCZD5_t5vtBiMugeyQIGWKEkTkaF2nshJo&part=snippet,contentDetails',
		method = "get",
		success = function( code, body )
		
			local t = util.JSONToTable( body )
			local length = calcVideoLen( t.items[1].contentDetails.duration )
			
			local title = t.items[1].snippet.title
			
			// Check title..
			if ( title ) then
				
				local t = string.lower( title )
				
				for k, v in ipairs( rpRadio.Config.YouTubeBlackListWords ) do
					if ( string.find( t, string.lower( v ) ) != nil ) then
						return false
					end
				end
			end
			
			
			if ( sql.TableExists( "dRM_blacklist" ) ) then
			
				local result = sql.Query( "SELECT title, ID FROM dRM_blacklist WHERE ID = '" .. id .. "'" )
				
				if ( result ) then
					return
				end
			end
			
			--
			
			if ( self.queue == nil ) then
			
				self.queue = {}
			end
			
			// no video repeats
			for k, v in ipairs( self.queue ) do
			
				if ( v.id == id ) then
				
					return
				end
			end
			
			--
			
			// Check the queue now
			if ( rpRadio.Config.AllowYouTube ) then
				if ( self:GetChannel() == 3 && self:GetVideoId() == "" && ( #self.queue == 0 ) ) then
				
					self:PlayVideo( id )
					return
				end
			end
			
			--
			
			table.insert( self.queue, { title = title, id = id } )
			
			--
			
			net.Start( "radioQueue" )
				net.WriteEntity( self )
				net.WriteTable( self.queue )
			net.Broadcast()
			
		end,
			headers = { [ "Referer" ] = "rp-rad-mic.appspot.com", [ "Content-length" ] = "0" }
		}
		HTTP( request )
end

function ENT:DequeueVideo( num )

	table.remove( self.queue, num )
	
	--
	
	net.Start( "radioQueue" )
		net.WriteEntity( self )
		net.WriteTable( self.queue )
	net.Broadcast()
end

function ENT:PlayDequeueVideo()

	if ( !self.queue || #self.queue == 0 ) then self:StopVideo() return end
	
	--
	
	local id = self.queue[ 1 ].id
	local title = self.queue[ 1 ].title
	
	--
	
	if ( sql.TableExists( "dRM_blacklist" ) ) then
	
		local result = sql.Query( "SELECT title, ID FROM dRM_blacklist WHERE ID = '" .. id .. "'" )
		
		if ( result ) then
			return
		end
	end
	
	--
	
	if ( self:GetLoop() ) then
		table.insert( self.queue, { title = self.queue[ 1 ].title, id = self.queue[ 1 ].id } )
	end
	
	self:DequeueVideo( 1 )
	self:PlayVideo( id )
end

function ENT:PlayVideo( id )
	
	if ( rpRadio.Config.YouTubeBlackList && sql.TableExists( "dRM_blacklist" ) ) then
	
		local result = sql.Query( "SELECT title, ID FROM dRM_blacklist WHERE ID = '" .. id .. "'" )
		
		if ( result ) then
		
			return
		end
	end
	
	--
	
	timer.Destroy( tostring( "radStop" .. self:EntIndex() ) )
	
	--
	
	if ( id != "" ) then
		
		local request = {
			url = 'https://www.googleapis.com/youtube/v3/videos?id=' .. id .. '&key=AIzaSyCZD5_t5vtBiMugeyQIGWKEkTkaF2nshJo&part=snippet,contentDetails',
			method = "get",
			success = function( code, body )
			
				local t = util.JSONToTable( body )
				local length = calcVideoLen( t.items[1].contentDetails.duration )
				
				local title = t.items[1].snippet.title
				
				// Check title..
				if ( title ) then
					
					local t = string.lower( title )
					
					for k, v in ipairs( rpRadio.Config.YouTubeBlackListWords ) do
						if ( string.find( t, string.lower( v ) ) != nil ) then
							return false
						end
					end
				end
				
				--
				
				self:SetVideoStart( tostring( math.floor( CurTime() ) ) )
				self:SetSeek( 0 )
				self:SetVideoTitle( title )
				self:SetVideoId( id )
				
				--
				
				timer.Create( "radStop" .. self:EntIndex(), length, 1, function()
					if ( IsValid( self ) ) then
					
						self:StopVideo()
					end
				end )
			end,
			headers = { [ "Referer" ] = "rp-rad-mic.appspot.com", [ "Content-length" ] = "0" }
		}
		HTTP( request )
	else
		
		self:SetVideoStart( tostring( math.floor( CurTime() ) ) )
		self:SetSeek( 0 )
		self:SetVideoTitle( "" )
		self:SetVideoId( "" )
	end
end

function ENT:SyncInGameUT( stat )

	if ( rpRadio.Config.AllowYouTube && stat == 2 ) then
		for k, v in ipairs( rpRadio.ENT_MIC ) do
			if ( self.GetMicHost && IsValid( self:GetMicHost() ) && v == self:GetMicHost() && v.GetChannel && v:GetChannel() == 3 ) then
			
				self:SetVideoStart( v:GetVideoStart() )
				self:SetSeek( 0 )
				self:SetVideoTitle( v:GetVideoTitle() )
				self:SetVideoId( v:GetVideoId() )
				break
			end
		end
	end
end

function ENT:ChangeChannel( dir )

	local newStat = self:GetChannel()
	
	if ( dir ) then
	
		newStat = newStat + 1
		
		if ( self.GetMicHost && newStat == 2 ) then
		
			local mic = rpRadio.ENT_MIC
			if ( #mic == 0 ) then newStat = 3 else local ran = mic[math.random(1,#mic)] rpRadio.radSetMicHost( self, ran ) end
		end
		
		if ( newStat == 3 && not rpRadio.Config.AllowYouTube ) then
			newStat = 4
		end
		
		if ( newStat > ( ( ( not rpRadio.Config.VoiceRadioOnly || self:GetClass() == "rp_radio_microphone" ) && table.Count( rpRadio.stations ) || 2 ) ) ) then
			newStat = 1
		end
	else
	
		newStat = newStat - 1
		
		if ( newStat == 3 && not rpRadio.Config.AllowYouTube ) then
			newStat = 2
		end
		
		if ( newStat < 1 ) then
			newStat = ( ( ( not rpRadio.Config.VoiceRadioOnly || self:GetClass() == "rp_radio_microphone" ) ) && table.Count( rpRadio.stations ) || 2 )
		end
		
		if ( self.GetMicHost && newStat == 2 ) then
		
			local mic = rpRadio.ENT_MIC
			if ( #mic == 0 ) then newStat = 1 else local ran = mic[math.random(1,#mic)] rpRadio.radSetMicHost( self, ran ) end
		end
	end
	
	self:ChangeChannelDir( newStat )
end

function ENT:ChangeChannelDir( stat )
	
	if ( stat == 2 && self.GetMicHost && !IsValid( self:GetMicHost() ) ) then
		
		local mic = rpRadio.ENT_MIC
		
		if ( #mic != 0 ) then
			local rand = mic[math.random(1,#mic)]
			rpRadio.radSetMicHost( self, rand )
		else
			stat = 1
		end
	end
	
	--
	
	if ( not rpRadio.Config.VoiceRadioOnly || self:GetClass() == "rp_radio_microphone" || stat < 3 ) then
	
		if ( rpRadio.Config.AllowYouTube && ( self:GetChannel() == 2 || ( self:GetChannel() == 3 && stat != 3 ) ) ) then
			timer.Destroy( "radStop" .. self:EntIndex() )
			self:StopVideo()
		end
		
		self:SetChannel( stat )
		self:SyncInGameUT( stat )
	end
end

function ENT:ChangeVolume( diff )

	local level = math.Clamp( self:GetVolume() + diff, 0, rpRadio.Config.VolumeCap )
	level = math.Clamp( level, 0, 100 )
	
	self:SetVolume( level )
	
	umsg.Start( "radVolumeSwitch" )
		umsg.Entity( self )
		umsg.Long( level )
	umsg.End()
end

function ENT:ChangeLocalHost()
	
	local found = false
	
	for k, v in ipairs( player.GetAll() ) do
	
		if ( v:GetPos():Distance( self:GetPos() ) < rpRadio.Config.HearRadius ) then
		
			for _, lt in next, rpRadio.listeners do
				if ( table.HasValue( lt, v ) ) then
					table.remove( rpRadio.listeners[ _ ], table.KeyFromValue( rpRadio.listeners[ _ ], v ) )
					found = true
				end
			end
		end
	end
	
	if ( found ) then
		net.Start( "radListeners" )
			net.WriteTable( rpRadio.listeners )
		net.Broadcast()
	end
end

function ENT:OnRemove()

	self:ChangeLocalHost()
end

function ENT:OnTakeDamage( dmgInfo )

	self.health = self.health - dmgInfo:GetDamage()
	
	if ( self.health <= 0 ) then
		
		self:Destroy()
	end
end

function ENT:Destroy()

	local explosion = EffectData()
	explosion:SetOrigin( self:GetPos() )
	explosion:SetScale( 2 )
	
	util.Effect( "Explosion", explosion )
	
	SafeRemoveEntity( self )
end


-- Physgun permission

function ENT:PhysgunPickup( ply )
	return ( rpRadio.Config.OwnerCanPhysgunRad && IsValid( ply ) && ( ply == self:Getowning_ent() || ply:IsAdmin() ) )
end
