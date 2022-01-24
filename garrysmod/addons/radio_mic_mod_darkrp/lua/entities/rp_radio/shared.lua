
ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Radio"
ENT.Author			= "Fish"
ENT.Category 	= "Radio + Microphone Mod"
ENT.Spawnable	= true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Loop" )
	
	self:NetworkVar( "Int", 0, "Channel" )
	self:NetworkVar( "Int", 1, "Volume" )
	self:NetworkVar( "Int", 2, "Seek" )
	//self:NetworkVar( "Entity", 0, "RadOwner" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" )
	self:NetworkVar( "Entity", 1, "MicHost" )
	
	self:NetworkVar( "String", 0, "VideoId" )
	self:NetworkVar( "String", 1, "VideoTitle" )
	self:NetworkVar( "String", 2, "VideoStart" )
end

function ENT:canSeePlayer( ply )

	local tr = {}
	tr.start = self:LocalToWorld( self:OBBCenter() )
	tr.endpos = ply:GetShootPos()
	tr.mask = MASK_PLAYERSOLID
	tr.filter = table.Add( player.GetAll(), { ply, self } )
	
	return not util.TraceLine( tr ).HitWorld
end