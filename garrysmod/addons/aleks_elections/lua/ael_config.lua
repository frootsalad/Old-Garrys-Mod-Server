--[[

THANKS FOR BUYING THIS!
And please, if you like it, write a review, it helps a lot more than you think!

____                           _   ____       _   _   _
/ ___| ___ _ __   ___ _ __ __ _| | / ___|  ___| |_| |_(_)_ __   __ _ ___
| |  _ / _ \ '_ \ / _ \ '__/ _` | | \___ \ / _ \ __| __| | '_ \ / _` / __|
| |_| |  __/ | | |  __/ | | (_| | |  ___) |  __/ |_| |_| | | | | (_| \__ \
\____|\___|_| |_|\___|_|  \__,_|_| |____/ \___|\__|\__|_|_| |_|\__, |___/
                                                              |___/
]]

AElections.WorkshopDownload = false
-- OR
AElections.ServerDownload = false
--[[ These 2 settings do the same thing, they both make every player who joins
the server automatically download the 6 icons needed for the UI to look correctly,
however, I recommend having the WorkshopDownload to true and the ServerDownload
to false since not all Garry's Mod hosts support server downloads. ]]

AElections.SecretaryModel = "models/mossman.mdl"
--[[ The model of the NPC used to enter the elections. ]]

AElections.EnterCost = 5000
--[[ The price in darkrp money people will have to pay in order to become a
candidate in the elections. ]]

AElections.VoteCommand = "elections"
--[[ The command players will have to use to open the voting menu during the
elections. ]]

AElections.HideCommand = "hideelections"
--[[ The command players will have to use to hide the elections banner during the
elections. ]]

AElections.MayorJobName = "President"
--[[ Enter here the job NAME of your darkrp mayor team. ]]

AElections.UseLegacyMayorCheck = false
--[[ Set this to true if you don't become mayor even after having
AElections.MayorJobName configured correctly. ]]

AElections.AllowNewElectionsWithMayor = false
--[[ Set this to true if you want players to be able to start new elections
even if the city already has a mayor. ]]

AElections.CandidatesCanVote = true
--[[ Set this to true if you want the elections candidates to be able to vote
in the elections. ]]

AElections.MinParticipants = 2
--[[ This is the number of candidates the system needs in order to start
the elections. ]]

AElections.MaxParticipants = 5
--[[ This is the max number of candidates able to participate in
the elections. ]]

AElections.AllowF4ToEnterElections = false
--[[ Set this to true if you want players able to enter the elections via the
darkrp F4 menu (normaly, they would have to talk with the NPC). ]]

AElections.DemoteMayorOnDeath = true
--[[ Set this to true if you want mayors to be automatically demoted after
they die or get killed. ]]

AElections.RestrictJoining = false
--[[ Set this to true if you want only the jobs set on AElections.AbleToJoinTeams
to be able to join the elections. ]]

AElections.AbleToJoinTeams = {
  "Lawyer",
  "Politician",
  "TV Star"
}

AElections.RestrictVoting = false
--[[ Set this to true if you want only the jobs set on AElections.AbleToVoteTeams
to be able to vote on the elections. ]]

AElections.AbleToVoteTeams = {
  "Citizen",
  "Police Officer",
  "Medic"
}

--[[

_____ _                       ____       _   _   _
|_   _(_)_ __ ___   ___ _ __  / ___|  ___| |_| |_(_)_ __   __ _ ___
 | | | | '_ ` _ \ / _ \ '__| \___ \ / _ \ __| __| | '_ \ / _` / __|
 | | | | | | | | |  __/ |     ___) |  __/ |_| |_| | | | | (_| \__ \
 |_| |_|_| |_| |_|\___|_|    |____/ \___|\__|\__|_|_| |_|\__, |___/
                                                         |___/
]]

AElections.PreparationTime = 60
--[[ The ammount of time (in seconds) the system will wait to start the
elections AllowF4ToEnterElections the MinParticipants goal is reached. ]]

AElections.VotingTime = 60
--[[ The ammount of time (in seconds) the elections will last. ]]

AElections.PostElectionsTime = 10
--[[ The ammount of time (in seconds) that players will see the winner on
their screen after the elections end. ]]

AElections.MayorAntiDemoteCooldown = 120
--[[ The ammount of time (in seconds) that mayors are protected from being
demoted after they die (if DemoteMayorOnDeath is set to true). ]]

--[[

_____ _                           ____       _   _   _
|_   _| |__   ___ _ __ ___   ___  / ___|  ___| |_| |_(_)_ __   __ _ ___
 | | | '_ \ / _ \ '_ ` _ \ / _ \ \___ \ / _ \ __| __| | '_ \ / _` / __|
 | | | | | |  __/ | | | | |  __/  ___) |  __/ |_| |_| | | | | (_| \__ \
 |_| |_| |_|\___|_| |_| |_|\___| |____/ \___|\__|\__|_|_| |_|\__, |___/
                                                             |___/
]]

AElections.Theme_RainbowAccentColor = false

AElections.Theme_AccentColor = Color(255, 55, 55, 255)

AElections.Theme_ColoredBorders = true

AElections.ChatTag = "[Mayor Elections]"

AElections.ChatTagColor = Color(200, 30, 30, 255)
