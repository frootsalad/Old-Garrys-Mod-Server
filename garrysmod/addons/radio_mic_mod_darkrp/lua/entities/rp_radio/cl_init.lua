
include( "shared.lua" )


-- Radio font

surface.CreateFont( "RadioFont",
	{
		font      = "coolvetica",
		size      = 48,
		weight    = 100,
		underline = 1
	}
)

function ENT:Draw()

	self:DrawModel()
	
	
	-- Radio Label
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	local chan = self.GetChannel && self:GetChannel() || -1
	local col = chan == 1 && Color( 255, 153, 0 ) || chan == 2 && Color( 0, 184, 245 ) || Color( 0, 255, 0 )
	
	surface.SetFont( "RadioFont" )
	
	local radWidth = surface.GetTextSize( rpRadio.getPhrase( "radio" ) )
	local onOffWidth = surface.GetTextSize( rpRadio.stations[ chan ][ 1 ] )
	
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), -90 )
	
	cam.Start3D2D( pos + ang:Up() * 9.5, ang, 0.1 )
		draw.WordBox( 2, -2 - radWidth * 0.5, -150, rpRadio.getPhrase( "radio" ), "RadioFont", Color( 0, 0, 0, 140 ), rpRadio.Config.RadioLabelColor )
		draw.WordBox( 2, -2 - onOffWidth * 0.5, -98, rpRadio.stations[ chan ][ 1 ], "RadioFont", Color( 0, 0, 0, 140 ), col )
	cam.End3D2D()
end

function ENT:OnRemove()

	if ( !rpRadio.channels[ self:EntIndex() ] ) then return end
	
	--

	local chan = rpRadio.channels[ self:EntIndex() ].station
		
	if ( IsValid( chan ) ) then
	
		chan:Stop()
	end
	
	rpRadio.channels[ self:EntIndex() ].station = nil
	rpRadio.channels[ self:EntIndex() ].url = "none"
	
	--
	
	if ( IsValid( self.html ) ) then
		self.html:RunJavascript( "player.stopVideo();" )
		self.frame:Close()
	end
	
	--
	
	rpRadio.channels[ self:EntIndex() ] = nil
end