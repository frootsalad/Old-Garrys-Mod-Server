AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
  self:SetModel( "models/zerochain/mgangs2/mgang_automata.mdl" )
  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )
  self:SetUseType( SIMPLE_USE )

  local phys = self:GetPhysicsObject()

  if (phys:IsValid()) then
    phys:Wake()
  end
end

function ENT:Use( activator, caller )
  if !(caller:HasGang()) then
    caller:ConCommand("gangcreate_menu")
  else
    caller:ConCommand("gang_menu")
  end

  return
end
