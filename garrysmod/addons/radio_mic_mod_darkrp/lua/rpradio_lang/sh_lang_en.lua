
/*
	-------------------------------------
	// Default language file (English) //
	-------------------------------------
	
	Don't see your language?
	
		Follow these instructions:
		
		1) Copy and paste this file in the same directory (rename it to anything)
		2) Change the text in the double quotes to your language
		3) At the bottom, change 'en' to your language code. e.g. de
		
		Type 'gmod_language' in the GMod console to discover your language code.
*/

local lang = {
	
	channel = "Channel",
	volume = "Volume",
	
	offline = "Offline",
	on_air = "ON AIR",
	in_range = "In Range",
	mic = "Microphone",
	
	radio = "Radio",
	settings = "Settings",
	live_chans = "Live Channels",
	in_game_chan = "In-Game Channel",
	
	override_vol = "Override Volume",
	override_rad = "Override Radio Volume (Stream)",
	current_scheme = "Current Scheme",
	color_scheme = "Color Scheme",
	
	blue = "blue",
	red = "red",
	green = "green",
	grey = "grey",
	orange = "orange",
	pink = "pink",
	purple = "purple",
	yellow = "yellow",
	
	next = "Next",
	stop = "Stop",
	loop = "Loop Queue",
	not_playing = "-No Video Playing-",
	browse = "Browse Videos",
	playlist = "Playlist",
	title = "Title",
	desc = "Description",
	id = "ID",
	
	blacklist = "Blacklist",
	play = "Play",
	nevermind = "Nevermind..",
	copy_url = "Copy URL",
	add_to_blacklist = "Add to blacklist",
	add_to_queue = "Add to queue",
	remove = "Remove",
	
	success_remove = "Successfully removed blacklisted video!",
	play_vid = "Playing",
}

rpRadio.addLanguage( "en", lang )