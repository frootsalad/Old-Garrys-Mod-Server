--aScoreboard (1.1.6) by arie - STEAM_0:0:22593800

--------------------------------------------------------------------------------

-----General Options

--The text at the top of the scoreboard
aScoreboard.Title = GetHostName()

--The subtext below the title
aScoreboard.SubTitle = "aScoreboard by arie"

--The width of the scoreboard
--("ScrW()" is a value which represents the screen's total width - so this is the 80% of the screen's width)
aScoreboard.Width = ScrW()*0.8

--The height of the scoreboard
--("ScrH()" is a value which represents the screen's total height - so this is the 80% of the screen's height)
aScoreboard.Height = ScrH()*0.8

--------------------------------------------------------------------------------

-----Colour options

--The colour used for aScoreboard, pre-made combinations are listed below.
aScoreboard.Color 						= Color(215, 85, 80) 	--Red
--aScoreboard.Color 					= Color(66, 139, 202) 	--Blue
--aScoreboard.Color 					= Color(228, 100, 75)	--Orange
--aScoreboard.Color 					= Color(26, 188, 156)	--Turquoise
--aScoreboard.Color 					= Color(92, 184, 92)	--Green
--aScoreboard.Color 					= Color(91, 192, 222)	--Light blue

--Whether or not to use a single colour for the scoreboard or multiple presets
--(For example, without uniform colour on the DarkRP options panel will resort to using 3 different colours)
aScoreboard.UniformColor 				= true

--Whether or not to colour player rows in the Murder gamemode
--(Only affects Murder so don't worry about it if you're not sure)
aScoreboard.ColourMurderRowsByPlayer 	= false

--------------------------------------------------------------------------------

-----Miscellaneous options

--Whether or not to split teams up into their own categories
aScoreboard.TeamCategories 				= true

--Whether or not to decrease the height of each player row to fit more on the screen
aScoreboard.CompactRows					= true

--Whether or not to enable the pie chart on the dashboard page
aScoreboard.PieChart					= true

-------------------------------------------------------------------------------

-----Community options

--Link to your website, leave as "" in order to disable page
aScoreboard.WebsiteLink					= "http://celestial-networks.net/index.php"

--Link to your donation page, leave as "" in order to disable page
aScoreboard.DonationLink				= ""

--Link to your workshop collection, leave as "" in order to disable page
aScoreboard.WorkshopLink				= ""

--Link to your Steam group, leave as "" in order to disable page
aScoreboard.SteamGroupLink 				= "https://steamcommunity.com/groups/CeletialNetworks"

--Should the user be able to call for admin assistance from the admin list?
aScoreboard.EnableAssistance			= false

--The console command that should be run on the user when they request assistance from an admin on the dashboard
--Feel free to change it to something like this for DarkRP usage: "say \"/// Requesting admin assistance.\""
aScoreboard.AssistanceCommand 			= "ulx asay \"Requesting admin assistance.\""

--------------------------------------------------------------------------------

-----Rules options

--Enable the rules tab
aScoreboard.UseRulesTab 			= true

--So unless you want to go ahead and use your own rules for the rules page feel free to leave this as it is.
--However, if you DO want to use your own rules, set the variable below to false and enter your rules in the rules variable or add a HTML page.
aScoreboard.UseLink 				= true

--Do we want to use a webpage for the rules? Chances are you'll want to so set this to true and link to your webpage below
aScoreboard.UseHTMLRules 			= true

----Link to a rules.txt file if the above is set to false, if not link to your normal rules webpage
aScoreboard.RulesLink 				= "http://www.kdgaming.org/forum/m/26772030/viewthread/16064378-must-read-darkrp-rules"

aScoreboard.Rules 	= [[
--General Rules
	1. Don't RDM other players
	2. Don't annoy the admins
	3. Use common sense
]]

--------------------------------------------------------------------------------

-----Table options

--This table's used for styling your usergroups however you like them
aScoreboard.NiceRanks 					= {}

--This name will appear on each player's row if you choose to enable it (see data entries below)
--Any user who's rank matches that of the first value will have their name and their name's colour changed to what's in the following table.
--Usage:
--aScoreboard.NiceRanks["actualname"] 	= {name = "Pretty Name",	col = Color(230, 230, 230)	}
aScoreboard.NiceRanks["user"] 			= {name = "Guest", 			col = Color(230, 230, 230)	}
aScoreboard.NiceRanks["moderator"]		= {name = "Moderator", 		col = Color(255, 200, 200)	}
aScoreboard.NiceRanks["superadmin"] 	= {name = "Super Admin", 	col = Color(240, 173, 78)	}

--This table's used for deciding what columns you'll have on your scoreboard
aScoreboard.DataValues = {}

--Usage:
--The index for the table should be what you want the column header to be
--All of the other values are inside the table and are used as follows:
	--Name 			- "Enabled"
	--Type 			- Boolean (true/false)
	--Description 	- Whether or not the column should be used

	--Name 			- "Pos"
	--Type 			- Function with an integer argument. Return an integer
	--Description 	- The position of the column on the scoreboard
	--				- The argument supplied is the total width of the list panel

	--Name 			- "Col"
	--Type 			- Function with player argument. Return a color structure
	--Description 	- The colour of the text in each player's row

	--Name 			- "Func"
	--Type 			- Function with player argument. Return a string
	--Description 	- The text displayed in each player's row

	--Name 			- "Alignment"
	--Type 			- Integer
	--Description 	- How the content of the column should be aligned - see http://wiki.garrysmod.com/page/Enums/TEXT_ALIGN

aScoreboard.DataValues["Player"] 		= 	{	
												Enabled = true,
												Pos = function(length) return 5 end, 	
												Col = function(ply) return Color(255,255,255,200) end, 
												Func = function(ply) return ply:Name() end,
												Alignment = TEXT_ALIGN_LEFT
											}

if (timer.Exists("UTimeThink")) then 		--uTime support
aScoreboard.DataValues["Hours Played"] 	= 	{	
												Enabled = true,
												Pos = function(length) return length - 430 end,
												Col = function(ply) return Color(255, 255, 255, 200) end, 
												Func = function(ply) return string.FormattedTime(ply:GetUTimeTotalTime()).h end,
												Alignment = TEXT_ALIGN_CENTER
											}
end

aScoreboard.DataValues["Team"] 			= 	{	
												Enabled = false,
												Pos = function(length) return length - 430 end, 	
												Col = function(ply) return team.GetColor(ply:Team()) end, 
												Func = function(ply) return team.GetName(ply:Team()) end,
												Alignment = TEXT_ALIGN_CENTER
											}	

if ATAG then 								--aTags support
aScoreboard.DataValues["aTag"] 			= 	{		
												Enabled = true,
												Pos = function(length) return length - 280 end,	
												Col = function(ply) 
													local name, color = hook.Call( "aTag_GetScoreboardTag", nil, ply )
													if color then return color end
													return Color(255,255,255,200) 
												end, 
												Func = function(ply) 
													local name, color = hook.Call( "aTag_GetScoreboardTag", nil, ply )
													if name then return name end
													return ""
												end,
												Alignment = TEXT_ALIGN_CENTER
											}	

else										--aTags has priority over the default tags and colours

aScoreboard.DataValues["Rank"] 			= 	{		
												Enabled = true,
												Pos = function(length) return length - 280 end,	
												Col = function(ply) 
													if aScoreboard.NiceRanks[ply:GetUserGroup()] then
														return aScoreboard.NiceRanks[ply:GetUserGroup()].col
													end
													return Color(255, 255, 255, 200) 
												end, 
												Func = function(ply) 
													if aScoreboard.NiceRanks[ply:GetUserGroup()] then
														return aScoreboard.NiceRanks[ply:GetUserGroup()].name
													end
													return ply:GetUserGroup()
												end,
												Alignment = TEXT_ALIGN_CENTER
											}	
end

aScoreboard.DataValues["Score"] 		= 	{	
												Enabled = true,
												Pos = function(length) return length - 170 end,	
												Col = function(ply) return Color(255,255,255,200) end, 
												Func = function(ply) return ply:Frags() end,
												Alignment = TEXT_ALIGN_CENTER
											}

aScoreboard.DataValues["Deaths"] 		= 	{	
												Enabled = true,
												Pos = function(length) return length - 100 end,	
												Col = function(ply) return Color(255,255,255,200) end, 
												Func = function(ply) return ply:Deaths() end,
												Alignment = TEXT_ALIGN_CENTER
											}

aScoreboard.DataValues["Ping"] 			= 	{	
												Enabled = true,
												Pos = function(length) return length - 30 end,  	
												Col = function(ply) return Color(255,255,255,200) end, 
												Func = function(ply) return ply:Ping() end,
												Alignment = TEXT_ALIGN_CENTER
											}

if LevelSystemConfiguration then 		--DarkRP leveling system
aScoreboard.DataValues["Level"] 	= 	{	
												Enabled = true,
												Pos = function(length) return length - 570 end,
												Col = function(ply) return Color(255, 255, 255, 200) end, 
												Func = function(ply) return ply:getDarkRPVar("level") end,
												Alignment = TEXT_ALIGN_CENTER
											}
end

--The various font titles used in the scoreboard are found here
--Feel free to edit the font style, but make sure to not change the font identifier (the first bit)
--Remember that if you change the font from Open Sans you'll have to add your own font to the server's resources
surface.CreateFont("aScoreboardTitle", 		{font = "Open Sans", 	size = 32, 	weight = 500})
surface.CreateFont("aScoreboardSubTitle", 	{font = "Open Sans", 	size = 24, 	weight = 500})
surface.CreateFont("aScoreboardJob", 		{font = "Open Sans", 	size = 28, 	weight = 500})
surface.CreateFont("aScoreboard22", 		{font = "Open Sans", 	size = 22, 	weight = 500})
surface.CreateFont("aScoreboard20", 		{font = "Open Sans", 	size = 20, 	weight = 500})
surface.CreateFont("aScoreboard19", 		{font = "Open Sans", 	size = 19, 	weight = 500})
surface.CreateFont("aScoreboard18", 		{font = "Open Sans", 	size = 18, 	weight = 500})