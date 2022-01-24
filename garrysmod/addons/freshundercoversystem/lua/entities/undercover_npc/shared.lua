ENT.Base 						= 'base_ai'
ENT.Type 						= 'ai'
ENT.AutomaticFrameAdvance			= true
ENT.PrintName 					= 'Fresh Undercover NPC'
ENT.Category 					= 'Tupac\'s Items'
ENT.Author 						= 'Tupac Shakur'
ENT.Spawnable 					= true
ENT.AdminSpawnable 				= false

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
