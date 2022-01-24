
include( "shared.lua" )

function ENT:Initialize()

	self.lightMat = Material( "sprites/light_ignorez" )
	self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:Draw()

	self:DrawModel()
	
	
	-- Microphone Light and Label
	
	local on = self:GetOn()
	local nick = IsValid( self:Getowning_ent() ) && self:Getowning_ent():Nick() || ""
	
	local col
	local lightPos = self:LocalToWorld( Vector( 0, -3, 62.5 ) )
	
	local station = self.GetChannel && self:GetChannel() || -1
	
	if ( not rpRadio.Config.MicrophoneDefaultMode || station == -1 ) then
		col = on && Color( 0, 255, 0 ) || Color( 255, 0, 0 )
	else
		col = station > 1 && Color( 0, 255, 0 ) || Color( 255, 0, 0 )
	end
	
	--
	
	render.SetMaterial( self.lightMat )
	
	--
	
	local vis = util.PixelVisible( lightPos, 5, self.PixVis )	
	if ( !vis || vis < 0.1 ) then return end
	
	--
	
    render.DrawSprite( lightPos, 5, 5, col )
	
	--
	
	local trace = LocalPlayer():GetEyeTrace()
	local ent = trace.Entity
	
	if ( IsValid( ent ) && ent == self && self:isInRange( LocalPlayer() ) ) then
		if ( rpRadio.Config.MicrophoneDefaultMode && station > 0 ) then
			AddWorldTip( self:EntIndex(), rpRadio.getPhrase( "mic" ) .. ": " .. nick .. "\n" .. ( rpRadio.stations[ station ][ 1 ] ), 0.5, self:LocalToWorld( Vector( 0, 0, 64 ) ), self )
		else
			AddWorldTip( self:EntIndex(), rpRadio.getPhrase( "mic" ) .. ": " .. nick .. "\n" .. ( on && rpRadio.getPhrase( "on_air" ) || rpRadio.getPhrase( "offline" ) ), 0.5, self:LocalToWorld( Vector( 0, 0, 64 ) ), self )
		end
	end
	
	-- In-Range Tag
	
	if ( ( station > 1 || on ) && self:isInRange( LocalPlayer() ) ) then
		
		local pos = self:LocalToWorld( Vector( 0, -2.5, 66 ) )
		local yaw = ( pos - LocalPlayer():GetShootPos() ):Angle().y
		
		surface.SetFont( "RadioFont" )
		local w, h = surface.GetTextSize( rpRadio.getPhrase( "in_range" ) )
		
		cam.Start3D2D( pos, Angle( 0, -90 + yaw, 90 ), 0.07 )
			draw.WordBox( 2, w * -0.5, -h, rpRadio.getPhrase( "in_range" ), "RadioFont", Color( 0, 0, 0, 140 ), color_white )
		cam.End3D2D() 
	end
end