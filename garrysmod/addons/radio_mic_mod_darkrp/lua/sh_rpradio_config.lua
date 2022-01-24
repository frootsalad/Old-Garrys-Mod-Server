
if ( not rpRadio ) then

	rpRadio = {}
end

rpRadio.Config = {}


-- Edit values below --

rpRadio.Config.HearRadius = 500 -- How far away can someone hear a radio?

rpRadio.Config.VoiceRadius = 150 -- Talk radius for broadcasters (from microphone)

rpRadio.Config.DefaultVolume = 45 -- Starting volume for the radio

rpRadio.Config.VolumeCap = 50 -- Maximum volume for the radio

rpRadio.Config.VoiceRadioOnly = false -- Only allow 'In-Game Voice' channel? (streaming of Internet radio limited to microphones)

rpRadio.Config.NoCollideMic = true -- Should the mic. no collide w/ players?

rpRadio.Config.RemoveMicOnJobChange = true -- Should a mic. remove itself when the owner changes jobs?

rpRadio.Config.VolumeNotification = true -- Should a player be notified about the override radio volume feature (upon spawn)?

rpRadio.Config.OnlyRadioOwner = true -- Is the radio's owner only allowed to change its settings?

rpRadio.Config.RadioLabelColor = Color( 0, 230, 255 ) -- What color should the 'Radio' label be? (Default is lightblue)

rpRadio.Config.ArrowColor = Color( 255, 255, 0 ) -- What color should the left and right arrows in the menu be? (Default is yellow)

rpRadio.Config.ListViewColorScheme = 'blue' -- Default color scheme for the menu's channel viewer. (Options: grey, blue, pink, purple, green, yellow, orange, and red)

rpRadio.Config.ChatCommandRadioSettingsMenu = '!radio' -- The chat command that opens the radio settings menu (not case-sensitive)

rpRadio.Config.AllowYouTube = true -- Should YouTube be allowed?

rpRadio.Config.YouTubeChatNotification = true -- Should the chat display the playing video title?

rpRadio.Config.YouTubeBlackList = true -- Should admins be able to blacklist videos?

rpRadio.Config.YouTubeBlackListWords = { "ear rape", "distorted" } -- All video titles which contain these words can't be played (not case-sensitive)

rpRadio.Config.YouTubeULXRanks = {  } -- Should only certain ULX ranks be able to use YouTube? Leave blank if not. e.g. { "vip", "donator" }

rpRadio.Config.MicrophoneDefaultMode = true -- Should microphone owners be able to play a station for the 'In-Game Channel'? False represents On/Off mode.

rpRadio.Config.OwnerCanPhysgunMic = false -- Should the owner be able to physgun their microphone?

rpRadio.Config.OwnerCanPhysgunRad = false -- Should the owner be able to physgun their radio?

															
hook.Add( "InitPostEntity", "DarkRP_Radio_YTJobs", function()

	timer.Simple( 0, function()

		rpRadio.Config.YouTubeJobs = {  } -- Should only certain jobs be able to use YouTube? Leave blank if not. e.g. { TEAM_RADIOHOST, TEAM_ANYTHING }
	end )
end )

-- Radio stations --

rpRadio.addStation( "GGRadio.net", "http://sv.ggradio.net:8000/stream" )
rpRadio.addStation( "Country Roads", "http://rfcmedia.streamguys1.com/countryroads.mp3" )
rpRadio.addStation( "HipHop Forever", "http://stream.laut.fm/hiphop-forever" )
rpRadio.addStation( "Noise FM", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=567807" )
rpRadio.addStation( "Reggae", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=902496" )
rpRadio.addStation( "Classical WETA", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=103145" )

// Add a Station (on a new, separate line): rpRadio.addStation( "Name of Station", "SHOUTCAST or ALTERNATIVE URL" )
// Remove a Station: Just remove the line associated with that particular station.

