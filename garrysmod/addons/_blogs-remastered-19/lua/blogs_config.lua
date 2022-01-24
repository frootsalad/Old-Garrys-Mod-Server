bLogs.Config = {} local config = bLogs.Config
--[[


	██╗    ██╗ █████╗ ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗
	██║    ██║██╔══██╗██╔══██╗████╗  ██║██║████╗  ██║██╔════╝
	██║ █╗ ██║███████║██████╔╝██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
	██║███╗██║██╔══██║██╔══██╗██║╚██╗██║██║██║╚██╗██║██║   ██║
	╚███╔███╔╝██║  ██║██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝
	 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝

	If you are using a leak of bLogs, before you even bother to configure it, I warn you that the leak WILL NOT work.

	If you are willing to take the risk, you may be causing yourself a danger. SO DON'T DO IT.

	You can purchase the script on GmodStore.

	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	Si tu utilises un leak de bLogs, avant que tu te fasses chier à le configurer, je te préviens que ce leak NE MARCHERA PAS.

	Si tu tiens à prendre le risque, tu te poses un danger inutile. ALORS NE LE FAIS PAS.

	Tu peux acheter ce script sur GmodStore.

	=================================================================================================================================================================

	██████╗ ██╗      ██████╗  ██████╗ ███████╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
	██╔══██╗██║     ██╔═══██╗██╔════╝ ██╔════╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
	██████╔╝██║     ██║   ██║██║  ███╗███████╗    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
	██╔══██╗██║     ██║   ██║██║   ██║╚════██║    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
	██████╔╝███████╗╚██████╔╝╚██████╔╝███████║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
	╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝

	Please note that there is quite a lot of profanity and insults in this config, mostly because many people can't FUCKING READ
	However, if you can read and you have common sense, we're best bros so you can just ignore the profanity.

	WARNING: Are you retarded? Then this might be more difficult for you! The config is very simple and I provide instructions,
			 examples, templates and more but some people still can't figure it out. If that's you, read it again and PLEASE
			 avoid making a ticket. I am very busy most of the time and I cannot provide config support.

	WARNING: You might need to know English to configure this addon! English is a very popular language!
			 Maybe you should learn it if you don't know it.

	WARNING: Use a fucking syntax text editor! Are you using Notepad? Fuck off! Download Notepad++, Sublime Text or Atom.io.

	███╗   ███╗██╗   ██╗███████╗ ██████╗ ██╗
	████╗ ████║╚██╗ ██╔╝██╔════╝██╔═══██╗██║
	██╔████╔██║ ╚████╔╝ ███████╗██║   ██║██║
	██║╚██╔╝██║  ╚██╔╝  ╚════██║██║▄▄ ██║██║
	██║ ╚═╝ ██║   ██║   ███████║╚██████╔╝███████╗
	╚═╝     ╚═╝   ╚═╝   ╚══════╝ ╚══▀▀═╝ ╚══════╝

	Looking for the MySQL config? Go to blogs_mysql_config.lua.

		 __
	    / /  __ _ _ __   __ _ _   _  __ _  __ _  ___
	   / /  / _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \
	  / /__| (_| | | | | (_| | |_| | (_| | (_| |  __/
	  \____/\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___|
	                    |___/             |___/

	bLogs supports different languages.

	If you'd like to contribute to the translation of bLogs, please contact me.
	Understand however that you need to be FLUENT in English AND the other language(s).
	A chain is only as strong as its weakest link!

	EXAMPLES:

	config.DefaultLanguage = "English"
	config.DefaultLanguage = "French"

]] config.DefaultLanguage = "English" --[[

	                     ___                    _ _   _           _
	  /\/\   __ ___  __ / _ \___ _ __ _ __ ___ (_) |_| |_ ___  __| |
	 /    \ / _` \ \/ // /_)/ _ \ '__| '_ ` _ \| | __| __/ _ \/ _` |
	/ /\/\ \ (_| |>  </ ___/  __/ |  | | | | | | | |_| ||  __/ (_| |
	\/    \/\__,_/_/\_\/    \___|_|  |_| |_| |_|_|\__|\__\___|\__,_|

	This setting is a list of SteamIDs, SteamID64s and usergroups that
	have maximum permissions to bLogs.

	FUCKING READ THIS SHIT OKAY??

	If you have someone in MaxPermitted (this is common sense btw, you retard)
	then you don't need to put them in the next setting, Permissions. Why?
	Because as said above, THEY HAVE MAXIMUM FUCKING PERMISSIONS

	By maximum fucking permissions I mean they can wipe all your logs,
	fuck around with permissions, etc.

	In the table (or list for you simpletons) you will add SteamIDs, SteamID64s and usergroups.

	A SteamID looks like this:

	STEAM_0:1:40314158

	A SteamID64 looks like this:

	76561198040894045

	and (you should know this as a server owner or "developer" (btw, stop calling yourself a fucking developer,
	I'm a developer, you're a configurer unless you can actually CODE Lua.)) a usergroup is whatever you want it
	to be.

	Here's a few examples of MaxPermitted:

	config.MaxPermitted = {"STEAM_0:1:40314158"}
	config.MaxPermitted = {"76561198074425791","STEAM_0:1:40314158"}
	config.MaxPermitted = {"76561198074425791","STEAM_0:1:40314158","superadmin"}
	config.MaxPermitted = {"superadmin"}

	Do you get it now? A table is a list? Every item is seperated by commas? Good? Okay.

]] config.MaxPermitted = {"superadmin"} --[[

	   ___ _           _     ___                                          _
	  / __\ |__   __ _| |_  / __\___  _ __ ___  _ __ ___   __ _ _ __   __| |
	 / /  | '_ \ / _` | __|/ /  / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` |
	/ /___| | | | (_| | |_/ /__| (_) | | | | | | | | | | | (_| | | | | (_| |
	\____/|_| |_|\__,_|\__\____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|

	This is pretty obvious but if you're retarded I'll give you the run down.
	This is what the players will type in chat to open the menu.

	Examples:

	config.ChatCommand = "!blogs"

	config.ChatCommand = "!logs"

	config.ChatCommand = "/blogs"

	config.ChatCommand = "/logs"

]] config.ChatCommand = "!blogs" --[[

	   _   _ _                ___                      _        ___                                          _
	  /_\ | | | _____      __/ __\___  _ __  ___  ___ | | ___  / __\___  _ __ ___  _ __ ___   __ _ _ __   __| |
	 //_\\| | |/ _ \ \ /\ / / /  / _ \| '_ \/ __|/ _ \| |/ _ \/ /  / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` |
	/  _  \ | | (_) \ V  V / /__| (_) | | | \__ \ (_) | |  __/ /__| (_) | | | | | | | | | | | (_| | | | | (_| |
	\_/ \_/_|_|\___/ \_/\_/\____/\___/|_| |_|___/\___/|_|\___\____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|

	bLogs, by default, has a console command to open the menu. It is ALWAYS "blogs".
	You can turn it on and off here.

]] config.AllowConsoleCommand = true --[[

	 ______                _   _             __  __                  _  __
	|  ____|              | | (_)           |  \/  |                | |/ /
	| |__ _   _ _ __   ___| |_ _  ___  _ __ | \  / | ___ _ __  _   _| ' / ___ _   _
	|  __| | | | '_ \ / __| __| |/ _ \| '_ \| |\/| |/ _ \ '_ \| | | |  < / _ \ | | |
	| |  | |_| | | | | (__| |_| | (_) | | | | |  | |  __/ | | | |_| | . \  __/ |_| |
	|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|_|  |_|\___|_| |_|\__,_|_|\_\___|\__, |
																			  __/ |
																			 |___/

	If false, F1, F2, F3 and F4 will NOT open the menu.
	If 1, F1 will open the menu.
	If 2, F2 will open the menu.
	If 3, F3 will open the menu.
	If 4, F4 will open the menu.

	If your players are saying that their F1/F2/F3/F4 key is not opening the menu
	and you have this on, tell them to rebind their F1, F2, F3 and F4 keys:

	bind f1 gm_showhelp
	bind f2 gm_showteam
	bind f3 gm_showspare1
	bind f4 gm_showspare2

	Examples:

	config.FunctionMenuKey = false

	config.FunctionMenuKey = 1

	config.FunctionMenuKey = 2

	config.FunctionMenuKey = 3

	config.FunctionMenuKey = 4

]] config.FunctionMenuKey = false --[[

	 _                     _____          _____
	| |                   |  __ \        |  __ \
	| |     ___   __ _ ___| |__) |__ _ __| |__) |_ _  __ _  ___
	| |    / _ \ / _` / __|  ___/ _ \ '__|  ___/ _` |/ _` |/ _ \
	| |___| (_) | (_| \__ \ |  |  __/ |  | |  | (_| | (_| |  __/
	|______\___/ \__, |___/_|   \___|_|  |_|   \__,_|\__, |\___|
				 __/ |                               __/ |
				|___/                               |___/

	If you're experiencing lag when loading logs, you can turn this down.

]] config.LogsPerPage = 60 --[[

	 ______       _   _ _         _   _
	|  ____|     | | (_) |       | \ | |
	| |__   _ __ | |_ _| |_ _   _|  \| | __ _ _ __ ___   ___  ___
	|  __| | '_ \| __| | __| | | | . ` |/ _` | '_ ` _ \ / _ \/ __|
	| |____| | | | |_| | |_| |_| | |\  | (_| | | | | | |  __/\__ \
	|______|_| |_|\__|_|\__|\__, |_| \_|\__,_|_| |_| |_|\___||___/
							__/ |
						   |___/

	Some developers don't share their scripted weapons'/entity's names with the server.
	That means sometimes bLogs can't get the real name of an entity.

	For example, ALL of the TTT weapons only share their name with the client. Therefore,
	they all show up with dumb names on bLogs. The crowbar shows up as weapon_zm_improvised

	In this table, you can create your own definitions. I've already got some there as an example.

]] config.EntityNames = {

	-- TTT stuff
	["weapon_zm_improvised"] = "Crowbar",
	["weapon_zm_carry"] = "Magneto Stick",
	["weapon_ttt_unarmed"] = "Holstered",

} --[[

	 ______                     _ __  __           _       _
	|  ____|                   | |  \/  |         | |     | |
	| |__ ___  _ __ ___ ___  __| | \  / | ___   __| |_   _| | ___  ___
	|  __/ _ \| '__/ __/ _ \/ _` | |\/| |/ _ \ / _` | | | | |/ _ \/ __|
	| | | (_) | | | (_|  __/ (_| | |  | | (_) | (_| | |_| | |  __/\__ \
	|_|  \___/|_|  \___\___|\__,_|_|  |_|\___/ \__,_|\__,_|_|\___||___/

	If you're an idiot and you're ignoring all of Falco's warnings to NEVER touch a single core file
	of DarkRP and the DarkRP modules aren't loading for you, you can force them (and other gamemode modules)
	to load here.

	If you want a renamed DarkRP, you HAVE to use DerivedRP, or you will experience problems with addons.
	Google it, you fucking numbskull. It's also pretty useful and cool, and more compatible with the
	server list.

	To remind server owners: if your "developer" (configurer) is recommending you to edit core files,
	fire him. He's a fucking idiot. DarkRP can be fully customized without editing core files.

]] config.ForcedModules = {

	["Trouble in Terrorist Town"] = false,
	["Cinema"] = false,
	["DarkRP"] = false,
	["Murder"] = false,

} --[[

	 ____  _            _    _ _     _           _  _____                                          _     
	|  _ \| |          | |  | (_)   | |         | |/ ____|                                        | |    
	| |_) | | __ _  ___| | _| |_ ___| |_ ___  __| | |     ___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
	|  _ <| |/ _` |/ __| |/ / | / __| __/ _ \/ _` | |    / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
	| |_) | | (_| | (__|   <| | \__ \ ||  __/ (_| | |___| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
	|____/|_|\__,_|\___|_|\_\_|_|___/\__\___|\__,_|\_____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
	                                                                                                      
	
	When using the ULX commands and DarkRP commands logging modules (they are on by default), you can control
	what is logged using this setting.

	By default:

	* ulx noclip is disabled - admins will spam this.
	* DarkRP's OOC feature is disabled. You will still see the chat messages in the chat module, but you
	  won't see any annoying // or /ooc in your Commands modules.

	You can add or remove from this table if you choose to do so.

	Default:

		ulx = {
			"noclip",
		},

		darkrp = {
			"/",
			"/ooc",
		}

]] config.BlacklistedCommands = {

	ulx = { -- Do not remove this bit
		"noclip", -- You can change/add to/remove this bit
	},

	darkrp = { -- Same applies here
		"/",
		"/ooc",
	}

} --[[

           _      _         ____ _______ _    _ ______ _____     _____ ____  _   _ ______ _____ _____
     /\   | |    | |       / __ \__   __| |  | |  ____|  __ \   / ____/ __ \| \ | |  ____|_   _/ ____|
    /  \  | |    | |      | |  | | | |  | |__| | |__  | |__) | | |   | |  | |  \| | |__    | || |  __
   / /\ \ | |    | |      | |  | | | |  |  __  |  __| |  _  /  | |   | |  | | . ` |  __|   | || | |_ |
  / ____ \| |____| |____  | |__| | | |  | |  | | |____| | \ \  | |___| |__| | |\  | |     _| || |__| |
 /_/    \_\______|______|  \____/  |_|  |_|  |_|______|_|  \_\  \_____\____/|_| \_|_|    |_____\_____|
                 _____  _____   _____ _   _         _____          __  __ ______
                |_   _|/ ____| |_   _| \ | |       / ____|   /\   |  \/  |  ____|
                  | | | (___     | | |  \| |______| |  __   /  \  | \  / | |__
                  | |  \___ \    | | | . ` |______| | |_ | / /\ \ | |\/| |  __|
                 _| |_ ____) |  _| |_| |\  |      | |__| |/ ____ \| |  | | |____
                |_____|_____/  |_____|_| \_|       \_____/_/    \_\_|  |_|______|


]]
