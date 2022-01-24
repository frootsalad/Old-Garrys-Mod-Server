
-- Radio + Microphone Mod (DarkRP)
-- By Fish


/*
	Creates Player Data
*/

hook.Add( "InitPostEntity", "DarkRP_Radio_IPE", function()

	timer.Simple( 0, function()
		
		local ply = LocalPlayer()
		
		if ( ply:GetPData( "rpRadioVolume" ) == nil ) then
			ply:SetPData( "rpRadioVolume", 85 )
		end
		
		if ( ply:GetPData( "rpRadioVolOver" ) == nil ) then
			ply:SetPData( "rpRadioVolOver", 0 )
		end
		
		if ( ply:GetPData( "radMenuColorScheme" ) == nil ) then
			ply:SetPData( "radMenuColorScheme", rpRadio.Config.ListViewColorScheme )
		end
		
		timer.Simple( 0, function()
			hook.Call( 'radMenuSetScheme' )
		end )
		
		if ( rpRadio.Config.VolumeNotification ) then
			chat.AddText( color_white, 'Type ' .. rpRadio.Config.ChatCommandRadioSettingsMenu .. ' to override radio stream volume.' )
		end
	end )
end )


rpRadio.channels = {}


/*
	Receives broadcasters and listeners
*/

net.Receive( "radBroads", function( len )

	rpRadio.broads = table.Copy( net.ReadTable() )
end )

net.Receive( "radListeners", function( len )

	rpRadio.listeners = table.Copy( net.ReadTable() )
end )


/*
	DarkRP hear compatibility
*/

local function hearFunc( ply )

	if not LocalPlayer().DRPIsTalking then return nil end
	
	if ( not LocalPlayer():GetNWBool( "ulx_gagged" ) && rpRadio.onSameChannel( ply, LocalPlayer() ) ) then
		return true
	end
	
	if ( LocalPlayer():GetPos():Distance( ply:GetPos() ) > 550 ) then return false end
	
	return not GAMEMODE.Config.dynamicvoice or ply:isInRoom()
end

timer.Simple( 1, function()

	if ( string.lower( gmod.GetGamemode().Name ) == "darkrp" ) then -- DarkRP 2.5+ only!
	
		DarkRP.addChatReceiver( "speak", DarkRP.getPhrase( "speak" ), hearFunc )
	end
end )


/*
	Gets the current station
*/

local function getCurrentStation( ent )
	
	local nowStation = nil
	
	if ( IsValid( ent ) ) then
	
		if ( rpRadio.channels[ ent:EntIndex() ] ) then
		
			nowStation = rpRadio.channels[ ent:EntIndex() ].station
		end
	end
	
	return nowStation
end


/*
	Changes the volume
*/

local function switchVolume( ent, vol )
	
	local over = tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) || 0
	local volume = ent.GetVolume && ent:GetVolume() || 45
	
	if ( over >= 1 ) then
	
		if ( vol ) then
	
			volume = vol
		else
		
			return
		end
	end
	
	--
	
	local currStation = getCurrentStation( ent )
	local channel = ent.GetChannel && ent:GetChannel() || 1
	
	if ( IsValid( currStation ) ) then
	
		currStation:SetVolume( volume / 100 )
	else
	
		if ( ( channel == 2 || channel == 3 ) && rpRadio.Config.AllowYouTube ) then
		
			if ( IsValid( ent.html ) ) then
			
				for i = 0, 1 do
					ent.html:RunJavascript( "if ( YTPlayer ) { YTPlayer.setVolume( " .. volume .. " ); }" )
				end
			end
		end
	end
end


local oldVol = -1
local oldOver = -1

local function updateRadio( ent )

	-- Grab the current station
	
	local channel = ent.GetChannel && ent:GetChannel() || 1
	local currStation = getCurrentStation( ent )
	
	-- Update position
	
	if ( IsValid( ent ) ) then
	
		if ( IsValid( currStation ) ) then
		
			currStation:SetPos( ent:LocalToWorld( ent:OBBCenter() ) )
		elseif ( !IsValid( ent.html ) ) then
		
			rpRadio.channels[ ent:EntIndex() ].fail = rpRadio.channels[ ent:EntIndex() ].fail + 1
		end
		
		
		-- Update volume
		
		local vol = tonumber( LocalPlayer():GetPData( "rpRadioVolume" ) )
		local over = tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) )
		
		--
		
		if ( vol == nil || over == nil ) then return end
		
		--
		
		if ( over != oldOver ) then
			
			if ( over == 0 ) then
				switchVolume( ent )
			else
				switchVolume( ent, vol )
			end
			
			oldOver = over
			return
		end
		
		if ( over >= 1 && vol != oldVol ) then
		
			switchVolume( ent, vol )
			oldVol = vol
		end
	end
end


/*
	Stops the YouTube audio
*/

usermessage.Hook( "stopYouTubeRad", function( um )

	local ent = um:ReadEntity()
	
	if ( IsValid( ent ) && IsValid( ent.html ) ) then
		
		if ( rpRadio.channels[ ent:EntIndex() ] ) then
			rpRadio.channels[ ent:EntIndex() ].url = "none"
		end
		
		ent.html:RunJavascript( "YTPlayer.stopVideo();" )
	end
end )


/*
	Forces a change in a radio's volume
*/

usermessage.Hook( "radVolumeSwitch", function( um )

	local ent = um:ReadEntity()
	local level = um:ReadLong()
	
	if ( IsValid( ent ) ) then
		
		switchVolume( ent )
	end
end )


/*
	Gets a radio's URL
*/

local function getCurrentURL( ent, channel )

	if ( rpRadio.Config.AllowYouTube && ( channel == 2 || channel == 3 ) && ent:GetVideoId() != "" ) then
		return ( ent:GetVideoId() )
	elseif ( channel == 2 && ent:GetClass() != "rp_radio_microphone" ) then
		local c = ent:GetMicHost().GetChannel && ent:GetMicHost():GetChannel() || 1
		return ( channel != nil && rpRadio.stations[ c ] != nil && rpRadio.stations[ c ][ 2 ] != nil && rpRadio.stations[ c ][ 2 ] || "none" )
	else
		return ( channel != nil && rpRadio.stations[ channel ] != nil && rpRadio.stations[ channel ][ 2 ] != nil && rpRadio.stations[ channel ][ 2 ] || "none" )
	end
end


/*
	Controls the radio stations
*/

local function detectStations()

	for _, ent in ipairs( rpRadio.ENT_BOTH ) do
	
		if ( !rpRadio.channels[ ent:EntIndex() ] ) then
		
			rpRadio.channels[ ent:EntIndex() ] = {}
		end
		
		if ( !rpRadio.channels[ ent:EntIndex() ].station ) then
		
			rpRadio.channels[ ent:EntIndex() ].station = nil
		end
		
		if ( !rpRadio.channels[ ent:EntIndex() ].url ) then
		
			rpRadio.channels[ ent:EntIndex() ].url = "none"
		end
		
		if ( !rpRadio.channels[ ent:EntIndex() ].fail ) then
		
			rpRadio.channels[ ent:EntIndex() ].fail = 0
		end
		
		--
		
		if ( not timer.Exists( "radVolumeUpdate" .. ent:EntIndex() ) ) then
			
			local entindex = ent:EntIndex()
			
			timer.Create( "radVolumeUpdate" .. entindex, 0.2, 0, function()
			
				if ( !IsValid( ent ) ) then
				
					timer.Destroy( "radVolumeUpdate" .. entindex )
				end
			end )
		end
		
		--
		
		local channel = ent.GetChannel && ent:GetChannel() || 1
		local url = getCurrentURL( ent, channel )
		
		-- Stop radio sounds (outside radius)
		
		if ( LocalPlayer():GetPos():Distance( ent:GetPos() ) > rpRadio.Config.HearRadius ) then
		
			local chan = rpRadio.channels[ ent:EntIndex() ].station
			
			if ( IsValid( chan ) ) then
			
				chan:Stop()
				chan = nil
			end
			
			if ( IsValid( ent.html ) ) then
			
				ent.html:RunJavascript( "YTPlayer.stopVideo();" )
			end
			
			if ( rpRadio.channels[ ent:EntIndex() ].url != "none" ) then
				rpRadio.channels[ ent:EntIndex() ].url = "none"
			end
			
			continue
		end
		
		
		local nowStation = getCurrentStation( ent )
		
		
		-- Channel changed!
		
		if ( rpRadio.channels[ ent:EntIndex() ].url != url || rpRadio.channels[ ent:EntIndex() ].fail > 15 ) then
		
			-- Stop
			if ( IsValid( nowStation ) ) then
				nowStation:Stop()
				nowStation = nil
			end
			
			if ( IsValid( ent.html ) ) then
				ent.html:RunJavascript( "YTPlayer.stopVideo();" )
			end
			
			if ( rpRadio.Config.AllowYouTube && ( channel == 2 || channel == 3 ) && ent:GetVideoId() != "" ) then
				
				-- Prevent OSX from playing YouTube (OSX does not work with YT audio)
				if ( system.IsOSX() ) then continue end
				
				local id = ent:GetVideoId()
				
				if ( rpRadio.Config.YouTubeChatNotification ) then
					chat.AddText( color_white, "[YouTube] " .. ( rpRadio.getPhrase( "play_vid" ) or "?" ) .. ": " .. ent:GetVideoTitle() )
				end
				
				-- Set new URL
				rpRadio.channels[ ent:EntIndex() ].url = id
				
				-- Reset fail count
				rpRadio.channels[ ent:EntIndex() ].fail = 0
				
				--
				
				if ( !IsValid( ent.frame ) ) then
				
					ent.frame = vgui.Create( "DFrame" )
					ent.frame:SetSize( 1, 1 )
					ent.frame:SetTitle( "" )
					ent.frame:SetVisible( false )
				end
				
				----
				
				if ( !IsValid( ent.html ) ) then
				
					ent.html = vgui.Create( "DHTML", ent.frame )
					ent.html:SetPos( 0, 0 )
					ent.html:SetSize( 1, 1 )
					ent.html:SetVisible( false )
					ent.html:SetMouseInputEnabled( false )
					
					/* Volume */
					
					local vol = ent.GetVolume && ent:GetVolume() || 0.5
					
					if ( ( ( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) ) or 0 ) >= 1 ) then
						
						vol = tonumber( LocalPlayer():GetPData( "rpRadioVolume" ) ) or 0.5
					end
					
					ent.html:AddFunction( "rad", "ReadyToGo", function()
						
						if ( IsValid( ent.html ) && ent:GetVideoId() == id ) then
							
							local seek = math.max( 0, math.floor( CurTime() ) - tonumber( ent:GetVideoStart() ) )
							ent.html:RunJavascript( [[YTPlayer.cueVideo( ']] .. id .. [[', ]] .. seek .. [[, ]] .. vol .. [[ );]] )
						end
					end )
					
					function ent.html:ConsoleMessage() end
					ent.html:OpenURL( "http://youtube.fesv.net/yt.html" )
				else
					
					local seek = math.max( 0, math.floor( CurTime() ) - tonumber( ent:GetVideoStart() ) )
					ent.html:RunJavascript( [[YTPlayer.cueVideo( ']] .. id .. [[', ]] .. seek .. [[ );]] )
				end
				
				return
			end
			
			-- Set new URL
			rpRadio.channels[ ent:EntIndex() ].url = url
			
			-- Silence
			if ( channel < 2 ) then
				continue
			end
			
			-- Reset fail count
			rpRadio.channels[ ent:EntIndex() ].fail = 0
			
			-- Play the new station
			sound.PlayURL( url, rpRadio.Config.Sound3d && "3d" || "mono", function( station )
			
				local currentURL = getCurrentURL( ent, channel )
				
				if ( IsValid( station ) && IsValid( ent ) ) then
				
					station:SetPos( ent:LocalToWorld( ent:OBBCenter() ) )
					
					if ( rpRadio.channels[ ent:EntIndex() ].url == currentURL ) then
					
						station:Play()
					else
					
						station:Stop()
						station = nil
						
						return
					end
					
					-- Loud volume fix
					station:SetVolume( 0 )
					
					timer.Simple( 0.5, function()
					
						if ( IsValid( ent ) ) then
						
							local over = tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) )
							local oVol = tonumber( LocalPlayer():GetPData( "rpRadioVolume" ) )
							
							if ( over > 0 ) then
								switchVolume( ent, oVol )
							else
								switchVolume( ent )
							end
						end
					end )
					
					-- Add new station
					rpRadio.channels[ ent:EntIndex() ].station = station
				end
			end )
		end
		
		updateRadio( ent )
	end
end
timer.Create( "DarkRP_Radio_DetectStations", 1, 0, detectStations )


/*
	Recovers the radio timer
*/

timer.Create( "DarkRP_Radio_Recovery", 2, 0, function()

	if ( !timer.Exists( "DarkRP_Radio_DetectStations" ) ) then
	
		timer.Create( "DarkRP_Radio_DetectStations", 1, 0, detectStations )
	end
end )