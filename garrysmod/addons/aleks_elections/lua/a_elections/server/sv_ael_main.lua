//Network Strings

util.AddNetworkString("AElections_EnterMenu")
util.AddNetworkString("AElections_EnterSent")
util.AddNetworkString("AElections_VoteMenu")
util.AddNetworkString("AElections_VoteSent")

util.AddNetworkString("AElections_ThanksMenu")
util.AddNetworkString("AElections_ThanksSent")

util.AddNetworkString("AElections_ElectionsEnd")
util.AddNetworkString("AElections_HideBanner")

util.AddNetworkString("AElections_Notify")
util.AddNetworkString("AElections_Update")

//Functions

net.Receive("AElections_EnterSent", function(_, ply)
	if !ply:IsValid() or !ply:IsPlayer() then return end

	if !ply:CanJoinElections() then return end

	if ply:canAfford(AElections.EnterCost) then
		ply:addMoney(-AElections.EnterCost)

		table.insert(AEL_Candidates, {ply:SteamID(), 0})

		AEL_Notify("Congratulations, you have succesfully entered the mayor elections! Good luck!", ply)
	else
		AEL_Notify("I'm sorry, but you can't afford to enter the elections...", ply)
	end

	if #AEL_Candidates >= AElections.MinParticipants and !GetGlobalBool("AEL_PreElectionsActive", true) and !GetGlobalBool("AEL_ElectionsActive", true) then
		AEL_StartPreElections()
	end
end)

net.Receive("AElections_VoteSent", function(_, ply)
	if !ply:CanVote() then return end

	local votePlySteamID = net.ReadString()
	local votePly = player.GetBySteamID(votePlySteamID)

	if votePly == false then
		AEL_Notify("This player disconected from the server. Please, vote for other candidate.", ply)
	else
		votePly:AddVote(1)

		ply.hasVoted = true

		AEL_Update()

		AEL_Notify("Thanks for submitting your vote!", ply)
	end
end)

net.Receive("AElections_ThanksSent", function(_, ply)
	if file.Exists("ael/thanks_received.txt", "DATA") then return end

	file.Write("ael/thanks_received.txt", "༼ つ ◕_◕ ༽つ NOTHING TO SEE HERE :D")
end)

//Hooks

hook.Add("PlayerSay", "AElections_Commands", function(ply, text)
	if (text == "!"..AElections.VoteCommand) or (text == "/"..AElections.VoteCommand) then
		if GetGlobalBool("AEL_ElectionsActive", false) then
			if !ply:CanVote() then return end

			net.Start("AElections_VoteMenu")
			net.Send(ply)
		else
			AEL_Notify("There are no elections going right now.")
		end
	elseif (text == "!"..AElections.HideCommand) or (text == "/"..AElections.HideCommand) then
		net.Start("AElections_HideBanner")
		net.Send(ply)
	elseif (text == "!aelreview") or (text == "/aelreview") then
		if !ply:IsSuperAdmin() then return end

		net.Start("AElections_ThanksMenu")
		net.Send(ply)
	elseif (text == "!aelversion") or (text == "/aelversion") then
		AEL_Notify("Alek's Elections version "..AEL_Version, ply)
	end
end)

hook.Add("PlayerInitialSpawn", "AElections_PlyVars", function(ply)
	ply.hasVoted = false
	ply.canBeDemoted = true
	ply.isAELWinner = false

	AEL_Update(ply)

	if ply:IsSuperAdmin() and !file.Exists("ael/thanks_received.txt", "DATA") then
		net.Start("AElections_ThanksMenu")
		net.Send(ply)
	end
end)

hook.Add("PlayerDeath", "AElections_DemoteMayor", function(victim, _, attacker)
	if AEL_GetMayor() != victim then return end

	if victim.canBeDemoted then
		if attacker:IsPlayer() then
			DarkRP.notifyAll(0, 4, "The mayor has been murdered!")
		else
			DarkRP.notifyAll(0, 4, "The mayor has died!")
		end

		victim:teamBan()
		victim:changeTeam(GAMEMODE.DefaultTeam, true)
	end
end)

//Functions

function AEL_PrepareTeam()
	for k, job in pairs(RPExtraTeams) do
		if (string.lower(AElections.MayorJobName) == string.lower(job.name)) or (AElections.UseLegacyMayorCheck and job.mayor) then
			AElections.MayorTeamId = k
			AElections.MayorTeamTab = job

			job.customCheck = function(ply)
				if ply.isAELWinner then return true end

				if AElections.AllowF4ToEnterElections then
					job.CustomCheckFailMsg = "Opening elections menu..."

					if ply:CanJoinElections() then
						net.Start("AElections_EnterMenu")
						net.Send(ply)
					end
				else
					job.CustomCheckFailMsg = "Visit the mayor's secretary if you want to join the elections!"
				end

				return false
			end

			return true
		end
	end

	return false
end

function AEL_Init()
	SetGlobalInt("AEL_ElectionsTime", 0)
	SetGlobalInt("AEL_PostElectionsTime", 0)

	SetGlobalBool("AEL_ElectionsActive", false)
	SetGlobalBool("AEL_PreElectionsActive", false)

	timer.Simple(1, function()
		if !AEL_PrepareTeam() then
			timer.Create("AEL_InvalidJobError", 60, 0, function()
				print(AElections.ChatTag.." The job set in AElections.MayorJobName doesn't exist!")

				AEL_Notify("Information: The job set in AElections.MayorJobName doesn't exist!")
			end)
		end
	end)
end

function AEL_StartPreElections()
SetGlobalBool("AEL_PreElectionsActive", true)

	AEL_Notify("The mayor elections will start in "..AElections.PreparationTime.." seconds!")

	timer.Create("AEL_PreElectionsTimer", AElections.PreparationTime, 1, function()
			AEL_StartElections()
	end)
end

function AEL_StartElections()
	SetGlobalBool("AEL_PreElectionsActive", false)
	SetGlobalBool("AEL_ElectionsActive", true)

	AEL_Notify("The mayor elections have started! Use '!"..AElections.VoteCommand.."'' or '/"..AElections.VoteCommand.."'' to vote for the next mayor!")

	AEL_Update()

	SetGlobalInt("AEL_ElectionsTime", AElections.VotingTime)

	timer.Create("AEL_ElectionsTimer", 1, AElections.VotingTime, function()
		SetGlobalInt("AEL_ElectionsTime", GetGlobalInt("AEL_ElectionsTime", 0) - 1)

		if GetGlobalInt("AEL_ElectionsTime", 0) == 0 then
			AEL_StopElections()
		end
	end)
end

function AEL_StopElections()
	local winnerCandidate = AEL_GetWinner()

	if winnerCandidate[1] != false then
		local winnerSteamID = winnerCandidate[1]:SteamID()
		local curMayor = AEL_GetMayor()

		if curMayor then
			curMayor:teamBan()

			curMayor:changeTeam(GAMEMODE.DefaultTeam, true)
		end

		winnerCandidate[1].isAELWinner = true

		winnerCandidate[1]:SetMayor()

		AEL_Notify(winnerCandidate[1]:Nick().." has won the elections and is now the mayor of the city!")

		if AElections.MayorAntiDemoteCooldown > 0 then
			winnerCandidate[1].canBeDemoted = false

			timer.Create(winnerCandidate[1]:SteamID64().."_AEL_Antidemote", AElections.MayorAntiDemoteCooldown, 1, function()
				mayorPly = player.GetBySteamID(winnerSteamID)

				if mayorPly != false then
					mayorPly.canBeDemoted = true
				end
			end)
		end

		SetGlobalInt("AEL_PostElectionsTime", AElections.PostElectionsTime)

		timer.Create("AEL_PostElectionsTimer", 1, AElections.PostElectionsTime, function()
			SetGlobalInt("AEL_PostElectionsTime", GetGlobalInt("AEL_PostElectionsTime", 0) - 1)
		end)
	else
		AEL_Notify("All the election candidates are gone, therefore, the mayor elections have been oficially cancelled!")
	end

	net.Start("AElections_ElectionsEnd")
	net.WriteTable(winnerCandidate)
	net.Broadcast()

	table.Empty(AEL_Candidates)

	AEL_ResetVotes()
	AEL_Update()

	SetGlobalBool("AEL_ElectionsActive", false)
end

//Init

hook.Add( "Initialize", "AEL_Init", AEL_Init)
