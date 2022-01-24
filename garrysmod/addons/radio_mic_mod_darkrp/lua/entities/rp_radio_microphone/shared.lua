
ENT.Type 			= "anim"
ENT.Base 			= "rp_radio"
ENT.PrintName		= "Microphone"
ENT.Author			= "Fish"
ENT.Category 	= "Radio + Microphone Mod"
ENT.Spawnable	= true

ENT.radioBroads 	= {}

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Bool", 1, "Loop" )
	
	self:NetworkVar( "Int", 0, "Channel" )
	self:NetworkVar( "Int", 1, "Volume" )
	self:NetworkVar( "Int", 2, "Seek" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" )
	
	self:NetworkVar( "String", 0, "VideoId" )
	self:NetworkVar( "String", 1, "VideoTitle" )
	self:NetworkVar( "String", 2, "VideoStart" )
end

function ENT:canSeePlayer( ply )

	local tr = {}
	tr.start = self:LocalToWorld( Vector( 0, 0, 64 ) )
	tr.endpos = ply:GetShootPos()
	tr.mask = MASK_PLAYERSOLID
	tr.filter = table.Add( player.GetAll(), { ply, self } )
	
	return not util.TraceLine( tr ).HitWorld
end

function ENT:isInRange( ply )

	return ( ply:GetPos():Distance( self:GetPos() ) <= rpRadio.Config.VoiceRadius && self:canSeePlayer( ply ) )
end