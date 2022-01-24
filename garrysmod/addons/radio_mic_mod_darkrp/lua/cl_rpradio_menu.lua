
-- Radio + Microphone Mod (DarkRP)
-- By Fish


-- Menu fonts

surface.CreateFont( "RadMenuFont0",
	{
		font      = "coolvetica",
		size      = 16,
		weight    = 100,
		underline = 1
	}
)

surface.CreateFont( "RadMenuFont1",
	{
		font      = "coolvetica",
		size      = 20,
		weight    = 100,
		underline = 1
	}
)

surface.CreateFont( "RadMenuFont2",
	{
		font      = "coolvetica",
		size      = 24,
		weight    = 100,
		underline = 1
	}
)

surface.CreateFont( "RadMenuFont3",
	{
		font      = "coolvetica",
		size      = 32,
		weight    = 100,
		underline = 1
	}
)

local scheme = {}

scheme[ rpRadio.getPhrase( "orange" ) ] = {

	lightest = Color( 255, 116, 0 ),
	light = Color( 223, 101, 0 ),
	dark = Color( 134, 61, 0 ),
	darkest = Color( 79, 36, 0 ),
}

scheme[ rpRadio.getPhrase( "red" ) ] = {

	lightest = Color( 234, 89, 70 ),
	light = Color( 203, 52, 32 ),
	dark = Color( 111, 13, 0 ),
	darkest = Color( 54, 6, 0 ),
}

scheme[ rpRadio.getPhrase( "yellow" ) ] = {

	lightest = Color( 211, 174, 0 ),
	light = Color( 155, 128, 0 ),
	dark = Color( 79, 65, 0 ),
	darkest = Color( 42, 34, 0 ),
}

scheme[ rpRadio.getPhrase( "pink" ) ] = {

	lightest = Color( 235, 91, 135 ),
	light = Color( 230, 51, 105 ),
	dark = Color( 176, 0, 53 ),
	darkest = Color( 138, 0, 42 ),
}

scheme[ rpRadio.getPhrase( "purple" ) ] = {

	lightest = Color( 143, 83, 192 ),
	light = Color( 119, 49, 176 ),
	dark = Color( 76, 8, 132 ),
	darkest = Color( 60, 5, 104 ),
}

scheme[ rpRadio.getPhrase( "grey" ) ] = {

	lightest = Color( 119, 119, 119 ),
	light = Color( 85, 85, 85 ),
	dark = Color( 51, 51, 51 ),
	darkest = Color( 17, 17, 17 ),
}

scheme[ rpRadio.getPhrase( "green" ) ] = {

	lightest = Color( 62, 167, 6 ),
	light = Color( 46, 132, 0 ),
	dark = Color( 20, 56, 0 ),
	darkest = Color( 0, 35, 0 ),
}

scheme[ rpRadio.getPhrase( "blue" ) ] = {

	lightest = Color( 84, 122, 151 ),
	light = Color( 50, 92, 124 ),
	dark = Color( 11, 49, 79 ),
	darkest = Color( 3, 30, 51 ),
}

local currScheme = scheme[ rpRadio.Config.ListViewColorScheme ] || scheme[ rpRadio.getPhrase( "blue" ) ]

hook.Add( 'radMenuSetScheme', 'schemeHook01', function()

	currScheme = scheme[ rpRadio.getPhrase( LocalPlayer():GetPData( "radMenuColorScheme" ) ) ] || scheme[ rpRadio.getPhrase( "blue" ) ]
end )

net.Receive( "radioQueue", function( len )

	local ent = net.ReadEntity()
	local tab = net.ReadTable()
	
	ent.queue = tab
end )


/*
	YouTube Menu
*/

local NUM_RESULTS = 10
local KEY = 'AIzaSyCZD5_t5vtBiMugeyQIGWKEkTkaF2nshJo'

local function retrieveYouTube( tab, onsuccess )

	local id = tab.id
	local keyword = tab.keyword
	
	local urlY = ""
	
	if ( keyword != nil ) then
		
		keyword = string.Replace( keyword, " ", "%20" )
		urlY = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=' .. keyword .. '&maxResults=' .. NUM_RESULTS .. '&type=video&key=' .. KEY
	elseif ( id != nil ) then
		
		urlY = 'https://www.googleapis.com/youtube/v3/videos?id=' .. id .. '&key=' .. KEY .. '&part=snippet,contentDetails,statistics,status'
	end
	
	--
	
	if ( urlY == "" ) then return end
	
	--
	
	local request = 
	{
		url = urlY,
		method = "get",
		success = function( code, body )
			onsuccess( body )
		end,
		headers = { ["Referer"] = "rp-rad-mic.appspot.com", ["Content-length"] = "0" }
	}
	HTTP( request )
end

local function YouTubeMenu( ent, playF )
	
	local listV
	local htmlI
	local lab
	local dLab
	
	local function hideVidInfo( shouldHide )
	
		if ( IsValid( htmlI ) ) then htmlI:SetVisible( !shouldHide ) end
		if ( IsValid( lab ) ) then lab:SetVisible( !shouldHide ) end
		if ( IsValid( dLab ) ) then dLab:SetVisible( !shouldHide ) end
	end
	
	local function clearVidInfo()
		
		if ( IsValid( htmlI ) ) then htmlI:SetHTML( [[]] ) end
		
		if ( IsValid( lab ) ) then
			lab:SetText( "" )
			lab:SizeToContents()
		end
		
		if ( IsValid( dLab ) ) then
			dLab:SetText( "" )
			dLab:SizeToContents()
		end
		
		if ( IsValid( listV ) ) then
			listV:Clear()
		end
	end
	
	local function searchYouTube( keyword )
	
		clearVidInfo()
		
		retrieveYouTube( { keyword = keyword }, function( result )
		
			local feed = util.JSONToTable( result )
			if ( feed == nil || feed.items == nil ) then return end
			
			for i = 1, NUM_RESULTS do
			
				if ( !feed.items[i] ) then continue end
				
				local title = feed.items[i].snippet["title"]
				local id = feed.items[i].id["videoId"]
				local des = feed.items[i].snippet["description"]
					
				if ( IsValid( listV ) ) then
					listV:AddLine( title, des, id )
				end
				
				if ( i == 1 ) then
				
					updateLabel( title, id, des )
				end
			end
		end )
	end
	
	
	local function searchMenu()
	
		// Hide other panels
		if ( IsValid( listV ) ) then
			listV:SetVisible( true )
			hideVidInfo( false )
		end
	end
	
	local mediaF = vgui.Create( "DFrame" )
	mediaF:SetSize( 500, 210 )
	mediaF:Center()
	mediaF:SetDraggable( false )
	mediaF:ShowCloseButton( false )
	mediaF:SetTitle( "RP " .. rpRadio.getPhrase( "radio" ) .. ": YouTube" )
	mediaF:MakePopup()
	mediaF.Paint = function( self )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, mediaF:GetWide(), mediaF:GetTall() )
		--
		surface.DrawLine( 0, 22, mediaF:GetWide(), 22 )
		--
		surface.SetDrawColor( Color( 0, 138, 184, 155 ) )
		surface.DrawRect( 0, 0, mediaF:GetWide(), mediaF:GetTall() )
	end

	local exitB = vgui.Create( "DImageButton", mediaF )
	exitB:SetIcon( "icon16/cancel.png" )
	exitB:SetPos( mediaF:GetWide() - 20, 4 )
	exitB:SizeToContents()
	exitB.DoClick = function() mediaF:SetVisible( false ) end
	
	function updateLabel( text, id, des )
	
		if ( lab == nil ) then
			
			lab = vgui.Create( "DLabel", mediaF )
			lab:SetFont( "RadMenuFont1" )
			lab:SetText( text )
			lab:SetPos( 11, mediaF:GetTall() - 94 - 35 )
			lab:SizeToContents()
		else
			
			lab:SetText( text )
			lab:SizeToContents()
		end
		
		--
		
		if ( dLab == nil ) then
		
			dLab = vgui.Create( "DLabel", mediaF )
			dLab:SetPos( 140, mediaF:GetTall() - 100 )
			dLab:SetFont( "RadMenuFont1" )
			dLab:SetText( des )
			dLab:SetWide( 330 )
			dLab:SetAutoStretchVertical( true )
			dLab:SetWrap( true )
		else
		
			dLab:SetText( des )
			dLab:SetWide( 330 )
			dLab:SetAutoStretchVertical( true )
			dLab:SetWrap( true )
		end
		
		--
		
		if ( htmlI == nil ) then
		
			htmlI = vgui.Create( "DHTML", mediaF )
			htmlI:SetPos( 10, mediaF:GetTall() - 100 )
			htmlI:SetSize( 120, 90 )
			htmlI:OpenURL( "https://i.ytimg.com/vi/" .. id .. "/default.jpg" )
		else
			htmlI:SetVisible( true )
			htmlI:OpenURL( "https://i.ytimg.com/vi/" .. id .. "/default.jpg" )
		end
	end

	listV = vgui.Create( "DListView", mediaF )
	listV:SetPos( 4, 50 )
	listV:SetSize( mediaF:GetWide() - 8,  153 )
	listV:SetMultiSelect( false )
	local col1 = listV:AddColumn( rpRadio.getPhrase( "title" ) )
	local col2 = listV:AddColumn( rpRadio.getPhrase( "desc" ) )
	local col3 = listV:AddColumn( rpRadio.getPhrase( "id" ) )
	col1:SetMinWidth( 150 )
	col2:SetMinWidth( 200 )
	col2:SetMaxWidth( 325 )
	col3:SetMinWidth( 75 )
	col3:SetMaxWidth( 75 )
	
	listV.OnRowSelected = function( index, line )
	
		updateLabel( listV:GetLine( line ):GetValue( 1 ), listV:GetLine( line ):GetValue( 3 ), listV:GetLine( line ):GetValue( 2 ) )
		
		local menu = DermaMenu()
		
		local playOpt = menu:AddOption( rpRadio.getPhrase( "play" ), function()
		
			net.Start( "radChangeYouTube" )
				net.WriteEntity( ent )
				//net.WriteString( listV:GetLine( line ):GetValue( 1 ) )
				net.WriteString( listV:GetLine( line ):GetValue( 3 ) )
			net.SendToServer()
			
			mediaF:Close()
			playF:SetVisible( true )
		end )
		playOpt:SetIcon( "icon16/control_play.png" )
		
		local queueOpt = menu:AddOption( rpRadio.getPhrase( "add_to_queue" ), function()
		
			net.Start( "radEnqueueVideo" )
				net.WriteEntity( ent )
				//net.WriteString( listV:GetLine( line ):GetValue( 1 ) )
				net.WriteString( listV:GetLine( line ):GetValue( 3 ) )
			net.SendToServer()
			
			mediaF:Close()
			playF:SetVisible( true )
		end )
		queueOpt:SetIcon( "icon16/application_add.png" )
		
		local copyOpt = menu:AddOption( rpRadio.getPhrase( "copy_url" ), function()
			SetClipboardText( "https://www.youtube.com/watch?v=" .. listV:GetLine( line ):GetValue( 3 ) )
		end )
		copyOpt:SetIcon( "icon16/pencil.png" )
		
		menu:AddSpacer()
		
		if ( rpRadio.Config.YouTubeBlackList && LocalPlayer():IsAdmin() ) then
			local blackOpt = menu:AddOption( rpRadio.getPhrase( "add_to_blacklist" ), function()
				net.Start( "radBlackListVideo" )
					net.WriteString( listV:GetLine( line ):GetValue( 1 ) )
					net.WriteString( listV:GetLine( line ):GetValue( 3 ) )
				net.SendToServer()
			end )
			blackOpt:SetIcon( "icon16/delete.png" )
		end
		
		menu:AddSpacer()
		
		local nvmOpt = menu:AddOption( rpRadio.getPhrase( "nevermind" ), function() end )
		
		menu:Open()
	end
	
	local textE = vgui.Create( "DTextEntry", mediaF )
	textE:SetPos( 4, 25 )
	textE:SetSize( mediaF:GetWide() - 8, 18 )
	textE:RequestFocus()
	textE.OnEnter = function( self )
	
		if ( mediaF:GetTall() < 335 ) then
		
			for i = 0, 1, 0.1 do
			
				timer.Simple( i * 0.1, function()
					mediaF:SetSize( mediaF:GetWide(), 340 * i )
					mediaF:Center()
				end )
			end
		end
		
		timer.Simple( 0.15, function()
			local keyword = string.Trim( textE:GetValue() )
			searchYouTube( keyword )
		end )
	end
	
	local searchB = vgui.Create( "DImageButton", textE )
	searchB:SetIcon( "icon16/magnifier.png" )
	searchB:SetPos( textE:GetWide() - 16, 2 )
	searchB:SizeToContents()
	searchB.DoClick = function()
	
		if ( mediaF:GetTall() < 335 ) then
		
			for i = 0, 1, 0.1 do
			
				timer.Simple( i * 0.1, function()
					mediaF:SetSize( mediaF:GetWide(), 340 * i )
					mediaF:Center()
				end )
			end
		end
		
		timer.Simple( 0.15, function()
			local keyword = string.Trim( textE:GetValue() )
			searchYouTube( keyword )
		end )
	end
end

/*
	Playlist Menu
*/

local function styleListLines( ent, statList )

	for _, line in ipairs( statList:GetLines() ) do
		
		line.alt = ( _ % 2 == 1 )
		
		local function removeQueueF()
		
			local Menu = DermaMenu()
	
			local removeOpt = Menu:AddOption( "Remove", function()
				net.Start( "radDequeueVideo" )
					net.WriteEntity( ent )
					net.WriteString( _ )
				net.SendToServer()
			end )
			removeOpt:SetIcon( "icon16/delete.png" )
			
			Menu:Open()
		end
		
		function line:OnClickLine()
		
			removeQueueF()
		end
		
		function line:OnRightClick()
		
			removeQueueF()
		end
		
		function line:Paint( w, h )
		
			if ( self:IsSelected() ) then
			
				surface.SetDrawColor( currScheme.dark )
				surface.DrawRect( 0, 0, w, h )
			elseif ( self:IsHovered() ) then
			
				if ( self.alt ) then
					
					local color = Color( currScheme.lightest.r, currScheme.lightest.g, currScheme.lightest.b, 195 )
					surface.SetDrawColor( color )
				else
					
					local color = Color( currScheme.light.r, currScheme.light.g, currScheme.light.b, 195 )
					surface.SetDrawColor( color )
				end
				
				surface.DrawRect( 0, 0, w, h )
			else
			
				if ( self.alt ) then
					surface.SetDrawColor( currScheme.lightest )
				else
					surface.SetDrawColor( currScheme.light )
				end
				
				surface.DrawRect( 0, 0, w, h )
			end
		end
		
		for _, column in ipairs( line[ "Columns" ] ) do
			
			column:SetFont( "RadMenuFont1" )
			column:SetTextColor( color_white )
		end
	end
end

-- Scale text

function scaleText( font, text, width )

	local newStr = ""
	local i = 1
	
	surface.SetFont( font )
	
	if ( surface.GetTextSize( text ) < width - 20 ) then
		
		return text
	end
	
	while ( surface.GetTextSize( newStr .. ".." ) < width - 20 ) do
		
		newStr = newStr .. string.sub( text, i, i )
		i = i + 1
		
		surface.SetFont( font )
	end
	
	return newStr .. ".."
end

local function radioPlayListMenu( ent )

	local volume = 0
	
	local playF = vgui.Create( 'DFrame' )
	playF:SetSize( 400, 300 )
	playF:SetPos( ScrW() / 2 - playF:GetWide() / 2, ScrH() / 2 - ( ( playF:GetTall() + 22 ) / 2 ) )
	playF:SetTitle( "RP " .. rpRadio.getPhrase( "radio" ) .. ": " .. rpRadio.getPhrase( "playlist" ) )
	playF:SetDraggable( true )
	playF:ShowCloseButton( false )
	playF:MakePopup()
	
	playF.Paint = function( self )
	
		surface.SetDrawColor( Color( 17, 17, 17, 225 ) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
		surface.DrawLine( 0, 22, self:GetWide(), 22 )
		
		surface.DrawOutlinedRect( 10, 22, self:GetWide() - 20, 78 )
		
		if ( ent.GetVideoId && ent:GetVideoId() != "" ) then
			draw.SimpleTextOutlined( scaleText( "RadMenuFont2", ent:GetVideoTitle(), self:GetWide() - 20 ), "RadMenuFont2", self:GetWide() / 2, 28, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black )
		else
			draw.SimpleTextOutlined( rpRadio.getPhrase( "not_playing" ), "RadMenuFont2", self:GetWide() / 2, 28, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black )
		end
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( self:GetWide() - 15 - ( 2 + 7 + 90 + 40 ), 75 + 10 - 7.5, 90, 15 )
		
		if ( ( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) || 0 ) >= 1 ) then
			volume = Lerp( 0.01, volume, LocalPlayer():GetPData( "rpRadioVolume" ) )
		else
			volume = Lerp( 0.01, volume, ent:GetVolume() )
		end
		
		surface.SetDrawColor( Color( 36, 214, 0, 150 ) )
		surface.DrawRect( self:GetWide() - 15 - ( 2 + 7 + 90 + 40 ), 75 + 10 - 7.5, 90 * ( math.Clamp( volume, 0, 100 ) ) / 100, 15 )
	end
	
	--
	
	if ( !ent.queue ) then
	
		ent.queue = {}
	end
	
	--
	
	playF.queue = ent.queue
	
	--
	
	local exitB = vgui.Create( "DImageButton", playF )
	exitB:SetIcon( "icon16/cancel.png" )
	exitB:SetPos( playF:GetWide() - 20, 4 )
	exitB:SizeToContents()
	exitB.DoClick = function()
	
		playF:Close()
	end
	
	local refreshB = vgui.Create( "DImageButton", playF )
	refreshB:SetIcon( "icon16/arrow_refresh.png" )
	refreshB:SetPos( playF:GetWide() - 20 - ( 16 + 5 ), 4 )
	refreshB:SizeToContents()
	refreshB.DoClick = function()
	
		for _, chans in next, rpRadio.channels do
			
			local chan = rpRadio.channels[ _ ].station
			
			if ( IsValid( chan ) ) then
			
				chan:Stop()
			end
			
			rpRadio.channels[ _ ].station = nil
			
			if ( rpRadio.channels[ _ ].url != "none" ) then
				rpRadio.channels[ _ ].url = "none"
			end
		end
	end
	
	if ( LocalPlayer():IsAdmin() ) then
	
		local blackB = vgui.Create( "DImageButton", playF )
		blackB:SetIcon( "icon16/delete.png" )
		blackB:SetPos( playF:GetWide() - 20 - ( 32 + 10 ), 4 )
		blackB:SizeToContents()
		blackB.DoClick = function() playF:Close() LocalPlayer():ConCommand( "rp_rad_blacklist" ) end
	end
	
	local statList = vgui.Create( "DListView", playF )
	statList:SetSize( playF:GetWide() * .95, playF:GetTall() - 22 - 110 )
	statList:SetPos( playF:GetWide() / 2 - statList:GetWide() / 2, 105 )
	statList:SetMultiSelect( false )
	statList.Paint = function()
	
		draw.RoundedBox( 0, 0, 0, statList:GetWide(), statList:GetTall(), Color( 194, 194, 194, 40 ) )
	end
	
	local numCol = statList:AddColumn( "##" )
	local vidCol = statList:AddColumn( "Video" )
	local cols = { numCol, vidCol }
	
	numCol:SetMinWidth( 28 )
	numCol:SetMaxWidth( 28 )
	
	--
	
	playF.Think = function( self )
	
		if ( self.queue != ent.queue ) then
		
			statList:Clear()
			
			--
			
			for k, v in ipairs( ent.queue ) do
				statList:AddLine( k, v.title )
			end
			
			styleListLines( ent, statList )
			
			self.queue = ent.queue
		end
	end
	
	--
	
	if ( ent.queue != nil ) then
	
		for k, v in ipairs( ent.queue ) do
		
			statList:AddLine( k, v.title )
		end
	end
	
	local stopB = vgui.Create( "DButton", playF )
	stopB:SetText( "" )
	stopB:SetPos( 15 + 50 + 2, 100 - 30 )
	stopB:SetSize( 50, 25 )
	stopB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( 150, 0, 0, 195 ) ) //Color( currScheme.dark.r, currScheme.dark.g, currScheme.dark.b, 195 ) )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( rpRadio.getPhrase( "stop" ), "RadMenuFont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	stopB.DoClick = function()
	
		net.Start( "radStopYouTube" )
			net.WriteEntity( ent )
		net.SendToServer()
	end
	
	local nextB = vgui.Create( "DButton", playF )
	nextB:SetText( "" )
	nextB:SetPos( 15, 100 - 30 )
	nextB:SetSize( 50, 25 )
	nextB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( 0, 155, 0, 195 ) ) //Color( currScheme.dark.r, currScheme.dark.g, currScheme.dark.b, 195 ) )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( rpRadio.getPhrase( "next" ), "RadMenuFont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	nextB.DoClick = function()
		net.Start( "radPlayDequeueVideo" )
			net.WriteEntity( ent )
		net.SendToServer()
	end
	
	local autoB = vgui.Create( "DButton", playF )
	autoB:SetText( "" )
	autoB:SetPos( 15 + 50 + 2 + 50 + 2, 100 - 30 )
	autoB:SetSize( 88, 25 )
	autoB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		if ( ent.GetLoop && ent:GetLoop() ) then
			surface.SetDrawColor( Color( 0, 155, 0, 195 ) )
		else
			surface.SetDrawColor( Color( 165, 0, 0, 195 ) )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( rpRadio.getPhrase( "loop" ), "RadMenuFont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	autoB.DoClick = function()
	
		net.Start( "radSetLoop" )
			net.WriteEntity( ent )
		net.SendToServer()
	end
	
	local searchB = vgui.Create( "DButton", playF )
	searchB:SetText( "" )
	searchB:SetPos( playF:GetWide() / 2 - statList:GetWide() / 2, 32 + playF:GetTall() * .8 + 3 )
	searchB:SetSize( playF:GetWide() * .95, 22 )
	searchB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( currScheme.dark.r, currScheme.dark.g, currScheme.dark.b, 195 ) )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( rpRadio.getPhrase( "browse" ), "RadMenuFont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	searchB.DoClick = function()
	
		playF:SetVisible( false )
		YouTubeMenu( ent, playF )
	end
	
	-----
	
	local upB = vgui.Create( "DButton", playF )
	upB:SetText( "" )
	upB:SetPos( playF:GetWide() - 15 - ( 20 ), 100 - 25 )
	upB:SetSize( 20, 20 )
	upB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( 0, 0, 0, 195 ) )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( "+", "RadMenuFont2", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	upB.OnMousePressed = function()
	
		timer.Destroy( "volUpTimer03" )
		timer.Destroy( "volDownTimer03" )
		
		if ( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) >= 1 ) then
		
			LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) + 5, 0, 100 ) )
			
			timer.Create( "volUpTimer03", 0.1, 0, function()
			
				if ( input.IsMouseDown( MOUSE_LEFT ) ) then
					
					LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) + 15, 0, 100 ) )
				end
			end )
		else
		
			net.Start( "radChangeRadVolume" )
				net.WriteEntity( ent )
				net.WriteString( 5 )
			net.SendToServer()
			
			timer.Create( "volUpTimer03", 0.1, 0, function()
			
				if ( input.IsMouseDown( MOUSE_LEFT ) ) then
					
					net.Start( "radChangeRadVolume" )
						net.WriteEntity( ent )
						net.WriteString( 15 )
					net.SendToServer()
				end
			end )
		end
	end
	upB.OnMouseReleased = function()
	
		timer.Destroy( "volUpTimer03" )
	end
	
	local downB = vgui.Create( "DButton", playF )
	downB:SetText( "" )
	downB:SetPos( playF:GetWide() - 15 - ( 20 ) - 2 - 20, 100 - 25 )
	downB:SetSize( 20, 20 )
	downB.Paint = function( self, w, h )
	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( 0, 0, 0, 195 ) )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( "-", "RadMenuFont2", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	downB.OnMousePressed = function()
	
		timer.Destroy( "volUpTimer03" )
		timer.Destroy( "volDownTimer03" )
		
		if ( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) >= 1 ) then
		
			LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) - 5, 0, 100 ) )
			
			timer.Create( "volDownTimer03", 0.1, 0, function()
			
				if ( input.IsMouseDown( MOUSE_LEFT ) ) then
				
					LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) - 15, 0, 100 ) )
				end
			end )
		else
		
			net.Start( "radChangeRadVolume" )
				net.WriteEntity( ent )
				net.WriteString( -5 )
			net.SendToServer()
			
			timer.Create( "volDownTimer03", 0.1, 0, function()
			
				if ( input.IsMouseDown( MOUSE_LEFT ) ) then
				
					net.Start( "radChangeRadVolume" )
						net.WriteEntity( ent )
						net.WriteString( -15 )
					net.SendToServer()
				end
			end )
		end
	end
	downB.OnMouseReleased = function()
	
		timer.Destroy( "volDownTimer03" )
	end
	
	local checkLabel = vgui.Create( "DCheckBox", playF )
	checkLabel:SetPos( playF:GetWide() - 15 - ( 5 + 5 + 90 + 20 ) - 40, 75 + 10 - 7.5 )
	checkLabel:SetChecked( ( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) || 0 ) >= 1 )
	checkLabel.OnChange = function( pSelf, fValue )
		LocalPlayer():SetPData( "rpRadioVolOver", !fValue && 0 || 1 )
	end
	
	-----
	
	styleListLines( ent, statList )
		
	for k, v in ipairs( cols ) do
	
		if ( k == 2 ) then
			
			v.Header.DoClick = function() end
			v.Header.DoRightClick = function() end
		end
		
		v.Header:SetFont( "RadMenuFont1" )
		v.Header:SetTextColor( Color( 71, 71, 71 ) )
		
		function v.Header:Paint( w, h )
			
			surface.SetDrawColor( Color( 194, 194, 194, 255 ) )
			surface.DrawRect( 0, 0, w, h )
			
			surface.SetDrawColor( color_black )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end
	
	function statList.VBar:Paint( w, h )
	
		surface.SetDrawColor( currScheme.darkest )
		surface.DrawRect( 0, 16, w, h - 32 )
	end
	
	function statList.VBar.btnUp:Paint( w, h )
	
		surface.SetDrawColor( Color( 214, 214, 214, 120 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function statList.VBar.btnDown:Paint( w, h )
	
		surface.SetDrawColor( Color( 214, 214, 214, 120 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function statList.VBar.btnGrip:Paint( w, h )
	
		surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
		surface.DrawRect( 0, 0, w, h + 5 )
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
end
	
/*
	Radio Menu: Settings
*/

local function radioSetMenu( ent )

local offset = 10
local volume = 0

local volFrame = vgui.Create( 'DFrame' )
volFrame:SetSize( 300, 150 )
volFrame:SetPos( ScrW() / 2 - volFrame:GetWide() / 2, ScrH() / 2 - ( ( volFrame:GetTall() + 22 ) / 2 ) )
volFrame:SetTitle( "RP " .. rpRadio.getPhrase( "radio" ) .. " - " .. rpRadio.getPhrase( "settings" ) )
volFrame:SetDraggable( true )
volFrame:ShowCloseButton( false )
volFrame:MakePopup()

volFrame.Paint = function( self )

	surface.SetDrawColor( Color( 17, 17, 17, 235 ) ) --Color( 31, 31, 31, 195 ) ) --Color( 77, 77, 77, 155 ) )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	surface.DrawLine( 0, 22, self:GetWide(), 22 )
	
	--
	
	volume = Lerp( 0.01, volume, ( LocalPlayer():GetPData( "rpRadioVolume" ) || 0 ) )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 10, 45 + offset, self:GetWide() - 80, 25 )
	
	surface.SetDrawColor( Color( 36, 214, 0, 150 ) )
	surface.DrawRect( 10, 45 + offset, ( self:GetWide() - 80 ) * ( math.Clamp( volume, 0, 100 ) / 100 ), 25 )
	
	--
	
	draw.SimpleTextOutlined( rpRadio.getPhrase( "current_scheme" ) .. ": " .. rpRadio.getPhrase( LocalPlayer():GetPData( "radMenuColorScheme" ) or rpRadio.Config.ListViewColorScheme ) || rpRadio.getPhrase( "blue" ), "RadMenuFont1",  10 + ( 100 + 10 ), volFrame:GetTall() - 20 - 9 + ( 10 ), currScheme.lightest, nil, TEXT_ALIGN_CENTER, 1, color_black )
end

local exitB = vgui.Create( "DImageButton", volFrame )
exitB:SetIcon( "icon16/cancel.png" )
exitB:SetPos( volFrame:GetWide() - 20, 4 )
exitB:SizeToContents()
exitB.DoClick = function()

	volFrame:Close()
end

if ( ent && IsValid( ent ) ) then

	local menuB = vgui.Create( "DImageButton", volFrame )
	menuB:SetIcon( "icon16/application_view_tile.png" )
	menuB:SetPos( volFrame:GetWide() - 20 - ( 5 + 32 + 5 ), 4 )
	menuB:SizeToContents()
	menuB.DoClick = function()
		
		volFrame:Close()
		hook.Call( 'rpRadioMenuOpen', nil, ent )
	end
end

local refreshB = vgui.Create( "DImageButton", volFrame )
refreshB:SetIcon( "icon16/arrow_refresh.png" )
refreshB:SetPos( volFrame:GetWide() - 20 - ( 16 + 5 ), 4 )
refreshB:SizeToContents()
refreshB.DoClick = function()
	
	for _, chans in next, rpRadio.channels do
		
		local chan = rpRadio.channels[ _ ].station
		
		if ( IsValid( chan ) ) then
		
			chan:Stop()
		end
		
		rpRadio.channels[ _ ].station = nil
		
		if ( rpRadio.channels[ _ ].url != "none" ) then
			rpRadio.channels[ _ ].url = "none"
		end
	end
	
	volFrame:Close()
end

local masterL = vgui.Create( "DLabel", volFrame )
masterL:SetPos( 10, 26 + offset )
masterL:SetFont( "RadMenuFont1" )
masterL:SetText( rpRadio.getPhrase( "override_vol" ) .. ": " .. math.Clamp( tonumber( LocalPlayer():GetPData( "rpRadioVolume" ) ), 0, 100 ) .. "%" )
masterL:SetTextColor( color_white )
masterL:SizeToContents()
masterL.Think = function()
	
	local vol = math.Clamp( tonumber( LocalPlayer():GetPData( "rpRadioVolume" ) ), 0, 100 )
	
	if ( vol != masterL:GetText() ) then
		
		masterL:SetText( rpRadio.getPhrase( "override_vol" ) .. ": " ..  vol .. "%" )
		masterL:SizeToContents()
	end
end

local volUp = vgui.Create( "DButton", volFrame )
volUp:SetSize( 25, 25 )
volUp:SetPos( volFrame:GetWide() - 25 - 10, 45 + offset )
volUp:SetFont( "RadMenuFont3" )
volUp:SetTextColor( color_white )
volUp:SetText( "+" )
volUp.Paint = function( self )

	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
end
volUp.OnMousePressed = function()

	timer.Destroy( "volUpTimer02" )
	timer.Destroy( "volDownTimer02" )
	
	LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) + 5, 0, 100 ) )
	
	timer.Create( "volUpTimer02", 0.1, 0, function()
	
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			
			LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) + 15, 0, 100 ) )
		end
	end )
end
volUp.OnMouseReleased = function()

	timer.Destroy( "volUpTimer02" )
end


local volDown = vgui.Create( "DButton", volFrame )
volDown:SetSize( 25, 25 )
volDown:SetPos( volFrame:GetWide() - 25 - 10 - 5 - 25, 45 + offset )
volDown:SetFont( "RadMenuFont3" )
volDown:SetTextColor( color_white )
volDown:SetText( "-" )
volDown.Paint = function( self )

	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
end
volDown.OnMousePressed = function()

	timer.Destroy( "volUpTimer02" )
	timer.Destroy( "volDownTimer02" )
	
	LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) - 5, 0, 100 ) )
	
	timer.Create( "volDownTimer02", 0.1, 0, function()
	
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			
			LocalPlayer():SetPData( "rpRadioVolume", math.Clamp( LocalPlayer():GetPData( "rpRadioVolume" ) - 15, 0, 100 ) )
		end
	end )
end
volDown.OnMouseReleased = function()

	timer.Destroy( "volDownTimer02" )
end

local checkLabel = vgui.Create( "DCheckBoxLabel", volFrame )
checkLabel:SetPos( 10, volFrame:GetTall() - 56.5 )
checkLabel:SetText( rpRadio.getPhrase( "override_rad" ) )
checkLabel.Label:SetFont( "RadMenuFont1" )
checkLabel.Label:SetTextColor( color_white )
checkLabel:SetChecked( tonumber( LocalPlayer():GetPData( "rpRadioVolOver" ) ) >= 1 )
checkLabel:SizeToContents()
checkLabel.OnChange = function( pSelf, fValue )

	LocalPlayer():SetPData( "rpRadioVolOver", !fValue && 0 || 1 )
end

local comboBox = vgui.Create( "DComboBox", volFrame )
comboBox:SetPos( 10, volFrame:GetTall() - 20 - 9 )
comboBox:SetSize( 100, 20 )
comboBox:SetValue( rpRadio.getPhrase( "color_scheme" ) )

for k, v in next, scheme do
	comboBox:AddChoice( k )
end

comboBox.OnSelect = function( panel, index, value )
	LocalPlayer():SetPData( "radMenuColorScheme", rpRadio.getPhraseKey( value ) )
	currScheme = scheme[ rpRadio.getPhrase( LocalPlayer():GetPData( "radMenuColorScheme" ) ) ] || scheme[ rpRadio.getPhrase( "blue" ) ]
	
	timer.Simple( 0.4, function()
		
		if ( IsValid( comboBox ) ) then
			
			comboBox:SetValue( rpRadio.getPhrase( "color_scheme" ) )
		end
	end )
end
end

/*
	Radio Menu
*/

local function radioMenu( um, notUM )

local ent = !notUM && um:ReadEntity() || um
if ( !IsValid( ent ) ) then return end


-- Relative functions

local function relPos( x, y )

	return x, y + 22
end

local function relYPos( y )

	return y + 22
end


-- Center X

local pnl = FindMetaTable( 'Panel' )

function pnl:centerX( w )

	return self:GetWide() / 2 - w / 2
end


-- Draw station label

local function drawRadioStation( panel )

	if ( !IsValid( ent ) ) then return end
	
	local w, h = 175, 60
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( panel:centerX( w ), relYPos( 10 ), w, h )
	
	surface.SetFont( "RadMenuFont1" )
	
	local station = ent:GetChannel() != nil && ent:GetChannel() || 1
	
	--
	
	draw.SimpleTextOutlined( rpRadio.getPhrase( "channel" ) .. ": " .. station, "RadMenuFont1", panel:GetWide() / 2, relYPos( 10 ) + 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	
	--
	
	local txt = scaleText( "RadMenuFont2", rpRadio.stations[ station ][ 1 ], w )
	draw.SimpleTextOutlined( txt, "RadMenuFont2", panel:GetWide() / 2, relYPos( 10 ) + h / 2 + 10, station == 1 && Color( 255, 153, 0 ) || station == 2 && Color( 0, 184, 245 ) || color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
end


-- Volume bar

local volume = 0

local function drawVolumeBar( panel )

	if ( !IsValid( ent ) ) then return end
	
	volume = Lerp( 0.1, volume, ( ent:GetVolume() / 100 ) * 225 )
	
	local w, h = 25, 225
	
	surface.SetDrawColor( ent:GetChannel() < 2 && Color( 255, 70, 70, 200 ) || Color( 36, 214, 0, 150 ) )
	surface.DrawRect( panel:GetWide() - ( w + 10 ), panel:GetTall() - ( 10 ) - volume, w, volume )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( panel:GetWide() - ( w + 10 ), panel:GetTall() - ( h + 10 ), w, h )
end


-- Volume label

local function drawVolumeLabel( panel )

	surface.SetFont( "RadMenuFont3" )
	local width, height = surface.GetTextSize( rpRadio.getPhrase( "volume" ) )
	
	surface.SetTextColor( color_white )
	surface.SetTextPos( panel:GetWide() - width - ( 25 + 25 ), panel:GetTall() - ( 225 + 10 ) )
	
	surface.DrawText( rpRadio.getPhrase( "volume" ) )
end

-- Frame

local frame = vgui.Create( 'DFrame' )
frame:SetSize( 500, 350 )
frame:SetPos( ScrW() / 2 - frame:GetWide() / 2, ScrH() / 2 - ( ( frame:GetTall() + 22 ) / 2 ) )
frame:SetTitle( "RP " .. rpRadio.getPhrase( "radio" ) )
frame:SetDraggable( true )
frame:ShowCloseButton( false )
frame:MakePopup()

frame.Paint = function( self )

	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, frame:GetWide(), frame:GetTall() )
	--
	surface.DrawLine( 0, 22, frame:GetWide(), 22 )
	--
	surface.SetDrawColor( Color( 77, 77, 77, 155 ) )
	surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall() )
	
	drawRadioStation( self )
	drawVolumeBar( self )
	drawVolumeLabel( self )
end

frame.Think = function()

	if ( !IsValid( ent ) ) then
	
		frame:Close()
	end
end

local exitB = vgui.Create( "DImageButton", frame )
exitB:SetIcon( "icon16/cancel.png" )
exitB:SetPos( frame:GetWide() - 20, 4 )
exitB:SizeToContents()
exitB.DoClick = function()

	frame:Close()
end

local setB = vgui.Create( "DImageButton", frame )
setB:SetIcon( "icon16/wrench.png" )
setB:SetPos( frame:GetWide() - 20 - ( 5 + 16 ), 4 )
setB:SizeToContents()
setB.DoClick = function()

	frame:Close()
	radioSetMenu( ent )
end


local leftArrow =
{
	{ x = 30, y = 50 },
	{ x = 0, y = 25 },
	{ x = 30, y = 0 }
}

local rightArrow =
{
	{ x = 0, y = 0 },
	{ x = 30, y = 25 },
	{ x = 0, y = 50 }
}

local leftB = vgui.Create( "DButton", frame )
leftB:SetSize( 30, 50 )
leftB:SetText( "" )
leftB:SetPos( frame:centerX( 30 ) - 175 / 2 - 35, relYPos( 10 ) + 60 / 2 - 50 / 2 )
leftB.Paint = function()

	surface.SetDrawColor( rpRadio.Config.ArrowColor )
	draw.NoTexture()
	surface.DrawPoly( leftArrow )
end
leftB.DoClick = function()

	net.Start( "radChangeChannel" )
		net.WriteEntity( ent )
		net.WriteString( "d" )
	net.SendToServer()
end

local rightB = vgui.Create( "DButton", frame )
rightB:SetSize( 30, 50 )
rightB:SetText( "" )
rightB:SetPos( frame:centerX( 30 ) + 175 / 2 + 35, relYPos( 10 ) + 60 / 2 - 50 / 2 )
rightB.Paint = function()

	surface.SetDrawColor( rpRadio.Config.ArrowColor )
	draw.NoTexture()
	surface.DrawPoly( rightArrow )
end
rightB.DoClick = function()

	net.Start( "radChangeChannel" )
		net.WriteEntity( ent )
		net.WriteString( "u" )
	net.SendToServer()
end


local statList = vgui.Create( "DListView", frame )
statList:SetSize( 327.5, 225 )
statList:SetPos( 10, frame:GetTall() - ( 225 + 10 ) )
statList:SetMultiSelect( false )
statList.Paint = function()

	draw.RoundedBox( 0, 0, 0, statList:GetWide(), statList:GetTall(), Color( 194, 194, 194, 40 ) )
end

local numCol = statList:AddColumn( "##" )
local radCol = statList:AddColumn( rpRadio.getPhrase( "live_chans" ) )
local cols = { numCol, radCol }

numCol:SetMinWidth( 28 )
numCol:SetMaxWidth( 28 )

for k, v in ipairs( rpRadio.stations ) do

	if ( k < 3 || ent:GetClass() == "rp_radio_microphone" || ( k > 2 && not rpRadio.Config.VoiceRadioOnly ) ) then
	
		statList:AddLine( k, v[1] )
	end
end

statList.Think = function( self )
	
	if ( not ent.GetChannel ) then return end
	
	
	if ( IsValid( self.VBar ) && self.VBar:IsVisible() ) then
	
		if ( !self.fixed ) then
			
			radCol:SetMinWidth( self:GetWide() - ( 28 + 16 ) )
			radCol:SetMaxWidth( self:GetWide() - ( 28 + 16 ) )
			
			self.fixed = true
		end
	else
	
		if ( self.fixed ) then
			
			radCol:SetMinWidth( self:GetWide() - 28 )
			radCol:SetMaxWidth( self:GetWide() - 28 )
			
			self.fixed = false
		end
	end
	
	--
	
	if ( self:GetSelectedLine() == nil ) then
		
		for k, v in ipairs( self:GetLines() ) do
		
			v:SetSelected( false )
		end
		
		self:SelectItem( self:GetLine( ent:GetChannel() ) )
	else
		
		if ( self:GetLine( self:GetSelectedLine() ):GetValue( 1 ) != ent:GetChannel() ) then
			
			for k, v in ipairs( self:GetLines() ) do
				
				v:SetSelected( false )
			end
			
			self:SelectItem( self:GetLine( ent:GetChannel() ) )
		end
	end
end

for _, line in ipairs( statList:GetLines() ) do

	line.alt = ( _ % 2 == 1 )
	
	function line:OnMousePressed()
	
		if ( _ == 3 && not rpRadio.Config.AllowYouTube ) then return false end
		
		if ( _ == 3 && table.Count( rpRadio.Config.YouTubeJobs ) > 0 ) then
			
			if ( !LocalPlayer():IsAdmin() || !rpRadio.Config.YouTubeBlackList ) then
				if ( !table.HasValue( rpRadio.Config.YouTubeJobs, LocalPlayer():Team() ) ) then return false end
			end
		end
		
		if ( _ == 2 && ent.GetMicHost ) then
		
			local mic = ents.FindByClass( "rp_radio_microphone" )
			if ( #mic == 0 ) then return end
			
			local menu = DermaMenu()
			for k, v in ipairs( mic ) do
				local opt = menu:AddOption( v:Getowning_ent():Nick(), function()
					net.Start( "radSetMicHost" )
						net.WriteEntity( ent )
						net.WriteEntity( v )
					net.SendToServer()
				end ):SetIcon( "icon16/user_suit.png" )
			end
			menu:Open()
		else
			net.Start( "radChangeChannelDirect" )
				net.WriteEntity( ent )
				net.WriteString( self:GetValue( 1 ) )
			net.SendToServer()
		end
		
		--
		
		if ( _ == 3 && rpRadio.Config.AllowYouTube ) then
		
			frame:Close()
			radioPlayListMenu( ent )
		end
	end
	
	function line:Paint( w, h )
	
		if ( self:IsSelected() ) then
		
			surface.SetDrawColor( currScheme.dark )
            surface.DrawRect( 0, 0, w, h )
		elseif ( self:IsHovered() ) then
		
			if ( self.alt ) then
				
				local color = Color( currScheme.lightest.r, currScheme.lightest.g, currScheme.lightest.b, 195 )
				surface.SetDrawColor( color )
			else
				
				local color = Color( currScheme.light.r, currScheme.light.g, currScheme.light.b, 195 )
				surface.SetDrawColor( color )
			end
			
			surface.DrawRect( 0, 0, w, h )
		else
		
			if ( self.alt ) then
				surface.SetDrawColor( currScheme.lightest )
			else
				surface.SetDrawColor( currScheme.light )
			end
			
            surface.DrawRect( 0, 0, w, h )
        end
    end
	
    for _, column in ipairs( line[ "Columns" ] ) do
		
        column:SetFont( "RadMenuFont1" )
        column:SetTextColor( color_white )
    end
end

for k, v in ipairs( cols ) do

	if ( k == 2 ) then
		
		v.Header.DoClick = function() end
		v.Header.DoRightClick = function() end
	end
	
	v.Header:SetFont( "RadMenuFont1" )
	v.Header:SetTextColor( Color( 71, 71, 71 ) )
	
	function v.Header:Paint( w, h )
		
		surface.SetDrawColor( Color( 194, 194, 194, 255 ) )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
end

function statList.VBar:Paint( w, h )

	surface.SetDrawColor( currScheme.darkest )
	surface.DrawRect( 0, 16, w, h - 32 )
end

function statList.VBar.btnUp:Paint( w, h )

	surface.SetDrawColor( Color( 214, 214, 214, 120 ) )
	surface.DrawRect( 0, 0, w, h )
end

function statList.VBar.btnDown:Paint( w, h )

	surface.SetDrawColor( Color( 214, 214, 214, 120 ) )
	surface.DrawRect( 0, 0, w, h )
end

function statList.VBar.btnGrip:Paint( w, h )

	surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
	surface.DrawRect( 0, 0, w, h + 5 )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

local volUp = vgui.Create( "DButton", frame )
volUp:SetSize( 50, 50 )
volUp:SetPos( frame:GetWide() - ( 103 ) - 25 / 2, ( ( frame:GetTall() - ( 225 + 10 ) ) + frame:GetTall() - 10 ) / 2 - 55 )

volUp:SetFont( "RadMenuFont3" )
volUp:SetTextColor( color_white )
volUp:SetText( "+" )

volUp.Paint = function()

	surface.SetDrawColor( ent:GetChannel() < 2 && Color( 163, 5, 0, 150 ) || Color( 36, 111, 0, 115 ) )
	surface.DrawRect( 0, 0, 50, 50 )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, 50, 50 )
end

volUp.OnMousePressed = function()
	
	if ( not ent.GetChannel ) then return end
	if ( ent:GetChannel() < 2 ) then surface.PlaySound( "buttons/button18.wav" ) return end
	
	--
	
	timer.Destroy( "volUpTimer01" )
	timer.Destroy( "volDownTimer01" )
	
	net.Start( "radChangeRadVolume" )
		net.WriteEntity( ent )
		net.WriteString( 5 )
	net.SendToServer()
	
	timer.Create( "volUpTimer01", 0.1, 0, function()
	
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			
			net.Start( "radChangeRadVolume" )
				net.WriteEntity( ent )
				net.WriteString( 15 )
			net.SendToServer()
		end
	end )
end

volUp.OnMouseReleased = function()

	timer.Destroy( "volUpTimer01" )
end


local volDown = vgui.Create( "DButton", frame )
volDown:SetSize( 50, 50 )
volDown:SetPos( frame:GetWide() - ( 103 ) - 25 / 2, ( ( frame:GetTall() - ( 225 + 10 ) ) + frame:GetTall() - 10 ) / 2 + 5 )

volDown:SetFont( "RadMenuFont3" )
volDown:SetTextColor( color_white )
volDown:SetText( "-" )

volDown.Paint = function()

	surface.SetDrawColor( ent:GetChannel() < 2 && Color( 163, 5, 0, 150 ) || Color( 36, 111, 0, 115 ) )
	surface.DrawRect( 0, 0, 50, 50 )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, 50, 50 )
end

volDown.OnMousePressed = function()

	if ( ent:GetChannel() < 2 ) then surface.PlaySound( "buttons/button18.wav" ) return end
	
	--
	
	timer.Destroy( "volUpTimer01" )
	timer.Destroy( "volDownTimer01" )
	
	net.Start( "radChangeRadVolume" )
		net.WriteEntity( ent )
		net.WriteString( -5 )
	net.SendToServer()
	
	timer.Create( "volDownTimer01", 0.1, 0, function()
	
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
		
			net.Start( "radChangeRadVolume" )
				net.WriteEntity( ent )
				net.WriteString( -15 )
			net.SendToServer()
		end
	end )
end

volDown.OnMouseReleased = function()

	timer.Destroy( "volDownTimer01" )
end


local muteB = vgui.Create( "DImageButton", frame )
muteB:SetSize( 32, 32 )
muteB:SetPos( ( ( frame:GetWide() - ( 103 ) - 25 / 2 ) + ( frame:GetWide() - ( 103 ) - 25 / 2 ) + 50 ) / 2 - 16, frame:GetTall() - 10 - 32 )
muteB:SetImage( "icon32/muted.png" )

muteB.Paint = function()

	surface.SetDrawColor( Color( 255, 255, 255, 55 ) )
	surface.DrawRect( 0, 0, muteB:GetWide(), muteB:GetTall() )
	
	surface.SetDrawColor( color_white )
	surface.DrawOutlinedRect( 0, 0, muteB:GetWide(), muteB:GetTall() )
end

muteB.OnMousePressed = function()

	if ( ent:GetChannel() < 2 ) then surface.PlaySound( "buttons/button18.wav" ) return end
	
	--
	
	if ( ent:GetVolume() != 0 ) then
	
		net.Start( "radSetRadVolume" )
			net.WriteEntity( ent )
			net.WriteString( "0" )
		net.SendToServer()
		
		ent.oldVolume = ent:GetVolume()
	else
	
		if ( ent.oldVolume != nil ) then
		
			net.Start( "radSetRadVolume" )
				net.WriteEntity( ent )
				net.WriteString( tostring( ent.oldVolume ) )
			net.SendToServer()
		end
	end
end
end
usermessage.Hook( "rpRadioMenu", function( um ) radioMenu( um ) end )
hook.Add( 'rpRadioMenuOpen', 'rpRadioMenuHook01', function( ent ) radioMenu( ent, true ) end )

local function blackListMenu()

	if ( !LocalPlayer():IsAdmin() ) then return end
	
	--
	
	local blackF = vgui.Create( "DFrame" )
	blackF:SetSize( 500, 210 )
	blackF:Center()
	blackF:SetDraggable( false )
	blackF:ShowCloseButton( false )
	blackF:SetTitle( "RP " .. rpRadio.getPhrase( "radio" ) .. ": " .. rpRadio.getPhrase( "blacklist" ) )
	blackF:MakePopup()
	blackF.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
		--
		surface.DrawLine( 0, 22, w, 22 )
		--
		surface.SetDrawColor( Color( 0, 138, 184, 155 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local exitB = vgui.Create( "DImageButton", blackF )
	exitB:SetIcon( "icon16/cancel.png" )
	exitB:SetPos( blackF:GetWide() - 20, 4 )
	exitB:SizeToContents()
	exitB.DoClick = function() blackF:Close() end
	
	local statList = vgui.Create( "DListView", blackF )
	statList:SetSize( blackF:GetWide() - 10, blackF:GetTall() - 30 )
	statList:SetPos( 5, 25 )
	statList:SetMultiSelect( false )
	
	statList:AddColumn( rpRadio.getPhrase( "title" ) )
	statList:AddColumn( rpRadio.getPhrase( "id" ) )
	
	net.Start( "radRetrieveBlackList" )
	net.SendToServer()
	
	net.Receive( "radBlackListTab", function( len )
	
		local tab = net.ReadTable()
		
		for k, v in next, tab do
			local line = statList:AddLine( v.title, v.ID )
			
			function line:OnSelect()
			
				local Menu = DermaMenu()
				
				local removeOpt = Menu:AddOption( rpRadio.getPhrase( "remove" ), function()
					net.Start( "radRemoveFromBlackList" )
						net.WriteString( line:GetValue( 2 ) )
					net.SendToServer()
					
					--
					
					statList:Clear()
				end )
				removeOpt:SetIcon( "icon16/delete.png" )
				
				Menu:Open()
			end
		end
	end )
end
concommand.Add( "rp_rad_blacklist", blackListMenu )


/*
	Chat Commands: Setting Menu
*/

usermessage.Hook( "notOwnerRadio", function( um )

	radioSetMenu()
end )

hook.Add( "OnPlayerChat", "OPC01", function( ply, text )

	if ( IsValid( ply ) && ply == LocalPlayer() && string.lower( text ) == string.lower( rpRadio.Config.ChatCommandRadioSettingsMenu ) ) then
	
		radioSetMenu()
	end
end )