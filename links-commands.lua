CATEGORY_NAME = "Community Links"


// Forums
function ulx.website(ply)
	ply:SendLua([[gui.OpenURL("http://celestial-networks.net/")]])
end
local website = ulx.command( CATEGORY_NAME, "ulx website", ulx.website, "!website" )
website:defaultAccess( ULib.ACCESS_ALL )
website:help( "Displays our wonderful forums." )


// Donate
function ulx.donate(ply)
	ply:SendLua([[gui.OpenURL("http://celestial-networks.net/donate/")]])
end
local donate = ulx.command( CATEGORY_NAME, "ulx donate", ulx.donate, "!donate" )
donate:defaultAccess( ULib.ACCESS_ALL )
donate:help( "Donate to our community here!" )