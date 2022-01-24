
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

util.AddNetworkString( "getMicDuration" )


-- Credits to robotboy655, garrynewman, Chessnut, and AbigailBuccaneer 
-- for the public constraint module code: https://github.com/garrynewman/garrysmod

-- This fixes KeepUpright the efficient way

if ( SERVER ) then

	-- If you're a server admin and you want your physics to spazz out less you can
	-- use the convar. The higher you set it the more accurate physics will be.
	-- This is set to 4 by default, since we are a physics mod.

	CreateConVar( "gmod_physiterations", "4", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

end

-- I think 128 constraints is around the max that causes the crash
-- So at this number we'll refuse to add more to the system
local MAX_CONSTRAINTS_PER_SYSTEM = 100
local ConstraintSystems = {}

--[[----------------------------------------------------------------------
	Go through each constraint system and check it for redundancy
------------------------------------------------------------------------]]
local function GarbageCollectConstraintSystems()

	for k, System in pairs( ConstraintSystems ) do

		-- System was already deleted (most likely by CleanUpMap)
		if ( !IsValid( System ) ) then

			ConstraintSystems[ k ] = nil

		else

			local Count = 0
			for id, Entity in pairs( System.UsedEntities ) do
				if ( Entity:IsValid() ) then Count = Count + 1 end
			end

			if ( Count == 0 ) then

				System:Remove()
				ConstraintSystems[ k ] = nil

			end

		end

	end


end


--[[----------------------------------------------------------------------
	CreateConstraintSystem
------------------------------------------------------------------------]]
local function CreateConstraintSystem()

	-- This is probably the best place to be calling this
	GarbageCollectConstraintSystems()

	local iterations = GetConVarNumber( "gmod_physiterations" )

	local System = ents.Create("phys_constraintsystem")
	System:SetKeyValue( "additionaliterations", iterations )
	System:Spawn()
	System:Activate()

	table.insert( ConstraintSystems, System )
	System.UsedEntities = {}

	return System

end


--[[----------------------------------------------------------------------
	FindOrCreateConstraintSystem

	Takes 2 entities. If the entities don't have a constraint system
	associated with them it creates one and associates it with them.

	It then returns the constraint system
------------------------------------------------------------------------]]
local function FindOrCreateConstraintSystem( Ent1, Ent2 )

	local System = nil

	Ent2 = Ent2 or Ent1

	-- Does Ent1 have a constraint system?
	if ( !Ent1:IsWorld() && Ent1:GetTable().ConstraintSystem && Ent1:GetTable().ConstraintSystem:IsValid() ) then
		System = Ent1:GetTable().ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( System && System:IsValid() && System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- Does Ent2 have a constraint system?
	if ( !System && !Ent2:IsWorld() && Ent2:GetTable().ConstraintSystem && Ent2:GetTable().ConstraintSystem:IsValid() ) then
		System = Ent2:GetTable().ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( System && System:IsValid() && System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- No constraint system yet (Or they're both full) - make a new one
	if ( !System || !System:IsValid() ) then

		--Msg("New Constrant System\n")
		System = CreateConstraintSystem()

	end

	Ent1.ConstraintSystem = System
	Ent2.ConstraintSystem = System

	System.UsedEntities = System.UsedEntities or {}
	table.insert( System.UsedEntities, Ent1 )
	table.insert( System.UsedEntities, Ent2 )

	local ConstraintNum = System:GetVar( "constraints", 0 )
	System:SetVar( "constraints", ConstraintNum + 1 )

	--Msg("System has "..tostring( System:GetVar( "constraints", 0 ) ).." constraints\n")

	return System

end


--[[----------------------------------------------------------------------
	onStartConstraint( Ent1, Ent2 )
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onStartConstraint( Ent1, Ent2 )

	-- Get constraint system
	local system = FindOrCreateConstraintSystem( Ent1, Ent2 )

	-- Any constraints called after this call will use this system
	SetPhysConstraintSystem( system )

end

--[[----------------------------------------------------------------------
	onFinishConstraint( Ent1, Ent2 )
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onFinishConstraint( Ent1, Ent2 )

	-- Turn off constraint system override
	SetPhysConstraintSystem( NULL )

end

local function SetPhysicsCollisions( Ent, b )

	if ( !IsValid( Ent ) || !IsValid( Ent:GetPhysicsObject() ) ) then return end

	Ent:GetPhysicsObject():EnableCollisions( b )

end

--[[----------------------------------------------------------------------
	RemoveConstraints( Ent, Type )
	Removes all constraints of type from entity
------------------------------------------------------------------------]]
local function RemoveConstraints( Ent, Type )

	if ( !Ent:GetTable().Constraints ) then return end

	local c = Ent:GetTable().Constraints
	local i = 0

	for k, v in pairs( c ) do

		if ( !v:IsValid() ) then

			c[ k ] = nil

		elseif ( v:GetTable().Type == Type ) then

			-- Make sure physics collisions are on!
			-- If we don't the unconstrained objects will fall through the world forever.
			SetPhysicsCollisions( v:GetTable().Ent1, true )
			SetPhysicsCollisions( v:GetTable().Ent2, true )

			c[ k ] = nil
			v:Remove()

			i = i + 1
		end

	end

	if ( table.Count( c ) == 0 ) then
		-- Update the network var and clear the constraints table.
		Ent:IsConstrained()
	end

	local bool = i != 0
	return bool, i

end

--[[----------------------------------------------------------------------
	AddConstraintTable( Ent, Constraint, Ent2, Ent3, Ent4 )
	Stores info about the constraints on the entity's table
------------------------------------------------------------------------]]
local function AddConstraintTable( Ent, Constraint, Ent2, Ent3, Ent4 )

	if ( !IsValid( Constraint ) ) then return end

	if ( Ent:IsValid() ) then

		Ent:GetTable().Constraints = Ent:GetTable().Constraints or {}
		table.insert( Ent:GetTable().Constraints, Constraint )
		Ent:DeleteOnRemove( Constraint )

	end

	if ( Ent2 && Ent2 != Ent ) then
		AddConstraintTable( Ent2, Constraint, Ent3, Ent4 )
	end

end

--[[----------------------------------------------------------------------
	Keepupright( ... )
	Creates a KeepUpright constraint
------------------------------------------------------------------------]]
local function Keepupright( Ent, Ang, Bone, angularlimit )

	if ( !angularlimit or angularlimit < 0 ) then return end

	local Phys = Ent:GetPhysicsObjectNum(Bone)

	-- Remove any KU's already on entity
	RemoveConstraints( Ent, "Keepupright" )

	onStartConstraint( Ent )

		local Constraint = ents.Create( "phys_keepupright" )
		Constraint:SetAngles( Ang )
		Constraint:SetKeyValue( "angularlimit", angularlimit )
		Constraint:SetPhysConstraintObjects( Phys, Phys )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent )
	AddConstraintTable( Ent, Constraint )

	local ctable = {
		Type = "Keepupright",
		Ent1 = Ent,
		Ang = Ang,
		Bone = Bone,
		angularlimit = angularlimit
	}
	Constraint:SetTable( ctable )

	--
	-- This is a hack to keep the KeepUpright context menu in sync..
	--
	Ent:SetNWBool( "IsUpright", true )

	return Constraint

end

function ENT:SpawnFunction( ply, tr )

	if ( !IsValid( ply ) ) then return end
	
	--
	
	local mic = ents.Create( "rp_radio_microphone" )
	mic:SetPos( tr.HitPos )
	mic:Setowning_ent( ply )
	mic:Spawn()
	mic:Activate()
	
	return mic
end

function ENT:Initialize()

	self:SetModel( "models/mic.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	if ( rpRadio.Config.NoCollideMic ) then
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	end
	
	self:SetOn( false )
	self:SetChannel( 1 )
	self:SetVolume( 15 )
	
	self.health = 100
	
	-- Keep up right
	local phys = self:GetPhysicsObject()
	
	if ( phys ) then
	
		Keepupright( self, phys:GetAngles(), 0, 40 ) -- Don't make it too strong
		phys:Wake()
	end
	
	self.upright = true
end

function ENT:emptyBroads()

	rpRadio.broads[ self:EntIndex() ] = nil
	rpRadio.listeners[ self:EntIndex() ] = nil
	
	net.Start( "radBroads" )
		net.WriteTable( rpRadio.broads )
	net.Send( player.GetAll() )
	
	net.Start( "radListeners" )
		net.WriteTable( rpRadio.listeners )
	net.Send( player.GetAll() )
end

function ENT:switchState( on )

	self:SetOn( on )
end

function ENT:Use( ply )

	if ( not rpRadio.Config.MicrophoneDefaultMode && self:OwnerCheck( ply ) ) then
		self:switchState( !self:GetOn() )
	else
	
		if ( rpRadio.Config.OnlyRadioOwner ) then
		
			if ( IsValid( self:Getowning_ent() ) && !self:OwnerCheck( ply ) ) then
			
				umsg.Start( "notOwnerRadio", ply )
				umsg.End()
				
				return
			end
		end
		
		umsg.Start( "rpRadioMenu", ply )
			umsg.Entity( self )
		umsg.End()
	end
end

function ENT:OnRemove()

	self:emptyBroads()
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




/*
	Override
*/

function ENT:StopVideo()

	self:PlayVideo( "" )
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	umsg.Start( "stopYouTubeRad", rf )
		umsg.Entity( self )
	umsg.End()
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
				
				
				--
				
				for k, v in ipairs( rpRadio.ENT_RAD ) do
		
					if ( v.GetChannel && v:GetChannel() == 2 && IsValid( v:GetMicHost() ) && self == v:GetMicHost() ) then
							
						if ( title == "" && id == "" ) then
						
							local rf = RecipientFilter()
							rf:AddAllPlayers()
							
							umsg.Start( "stopYouTubeRad", rf )
								umsg.Entity( v )
							umsg.End()
						end
						
						v:PlayVideo( id, title )
					end
				end
				
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


-- Physgun permission

function ENT:PhysgunPickup( ply )
	return ( rpRadio.Config.OwnerCanPhysgunMic && IsValid( ply ) && ( ply == self:Getowning_ent() || ply:IsAdmin() ) )
end
