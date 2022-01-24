
Simplac = Simplac or {}
Simplac.settings = {}
Simplac.settings.bantime = 0 -- Permanent (time is in seconds, 0= permanent)
Simplac.settings.banreason = "Cheating"
Simplac.settings.telleveryoneaboutcheaters = 2 -- tell everyone who cheated 0/false = tell no one, 2 = everyone, 1 = admins only

Simplac.settings.testmode = true -- test mode (disable bans)
Simplac.settings.testmode2 = false -- full test mode (no kicks)


Simplac.settings.readdetectiondisclaimer = false -- Did you read the detection disclaimer?

--if you want to disable something because one of your addons causes issues

-- SET THIS TO FALSE FOR NON ROUND BASED GM AKA STUFF LIKE DARKRP, SANDBOX 
-- KEEP TO TRUE FOR GAMEMODES WITH ROUNDS LIKE TTT

Simplac.BotSuicide = true -- The bot suicides if he doesn't feel like living (aka needs to die) (round based gms only aka e.g. TTT, prop hunt)

-- If you want the bot gone set the detection Simplac.settings.Aimbot_MCheck to false
Simplac.settings.Aimbot_MCheck = true -- AM = "DAMN THIS BOT IS SO ANNOYING LOL" - Aimbot check/breaker (uses bots, takes 1 slot of yo serv)

--MC is pretty cool but apperently currently doesn't work for every addon/gamemode setup
Simplac.settings.MouseCheck2 = true -- MC = Mouse Check ( against aimbots etc. )

Simplac.settings.SeedCheck = true -- SC = Seed check ( against nospreads )
Simplac.settings.AutofireCheck1 =  true -- AF = Autofire toggle check
Simplac.settings.AutofireCheck2 =  true -- AF2 = Autofire toggle check 2
Simplac.settings.BhopCheck = true --BH = Bunnyhop check
Simplac.settings.Aimbot_NCheck = true -- AN = Aimbot check (also against aimbots etc. )
Simplac.settings.MoveCheck = true -- MV check (against C++ cheats etc.)


--these are disabled by default
Simplac.settings.FlashlightCheck = false -- FL = Anti flashlight spam ( Sebastian wanted this lol )
Simplac.settings.MouseCheck1 = false -- MC = Mouse Check ( against aimbots etc. )
Simplac.settings.Aimbot_SCheck = false -- AS = Statistical aimbot check (also against aimbots etc.)






-- DONT TOUCH THESE
-- IF YOU EDIT THOSE AND HAVE PROBS; ITS YOUR OWN FAULT
-- ONLY TOUCH IF YOU KNOW WHAT YOU'RE DOING

Simplac.settings.aimbot_mcheck_team = nil -- nil=default team
Simplac.settings.aimbot_mcheck_wep = nil -- nil=default weapon 

Simplac.settings.aimbot = {}

--statistical aimbot meme
Simplac.settings.aimbot.maxdhits = 4 -- you can max hit these many targets in 
Simplac.settings.aimbot.dhitsint = 1 -- these many seconds

--norm aimbot meme
Simplac.settings.aimbot.minsnapviolations = 1 -- more than 1 snaps within 60s = ban
Simplac.settings.aimbot.storecmds = nil -- if you set this, then only the last set usercommands will be checked 
Simplac.settings.aimbot.SnapFov = 35 -- more than 35 degrees = snap
Simplac.settings.aimbot.SnapWait = 0.5 -- if he killed the player faster than that and snapped, hes cheating
Simplac.settings.aimbot.mindist = 250 -- minimum distance
Simplac.settings.aimbot.mercy = true -- kanye wests best song
Simplac.settings.aimbot.mercycooldown = 5 -- be merciful these many times a minute