include 'shared.lua'

AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'

function ENT:Initialize()

	self:SetModel( fus.config.npc[ 'model' ] )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal(  )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )

end

function ENT:AcceptInput( key, cal )

	if key == 'Use' and cal:IsPlayer() then

		if not fus.canOpenMenu( cal ) then return end

		net.Start( 'fus.openMenu' )
		net.Send( cal )

	end

end
