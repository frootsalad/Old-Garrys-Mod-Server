
CATEGORY_NAME = "Community Links"-- What category this command falls under. Choose existing group or create a new one.function ulx.steamgroup(ply)
	ply:SendLua([[gui.OpenURL("http://YOURURLHERE.com/")]]) -- Opens URL on ply's browser.endlocal steamgroup = ulx.command( CATEGORY_NAME, "ulx steamgroup", ulx.steamgroup, "!steamgroup" ) -- "!steamgroup" is the custom command. Change this to whatever you want players to type in.
steamgroup:defaultAccess( ULib.ACCESS_ALL ) -- Who has access to this command? Refer to ULib ranks.
steamgroup:help( "Custom description here! CHANGE ME" ) -- Describes what the command does to the player using it.