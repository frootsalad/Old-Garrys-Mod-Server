local meta = FindMetaTable("Player")
if not meta then return end

//Functions

local function AEL_DeleteSpawnPositions()
	if file.Exists("ael/positions/"..string.lower(game.GetMap())..".txt", "DATA") then
		file.Delete("ael/positions/"..string.lower(game.GetMap())..".txt")
	end
end

function AEL_ResetVotes()
	for k, v in pairs(player.GetAll()) do
		v.hasVoted = false
	end
end

function AEL_Update(ply)
	net.Start("AElections_Update")
	net.WriteTable(AEL_Candidates)

	if ply == nil then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send(ply)
	end
end

function AEL_GetMayor()
	for _, ply in pairs(player.GetAll()) do
		if team.GetName(ply:Team()) == AElections.MayorJobName or ply:isMayor() then
			return ply
		end
	end

	return false
end

function AEL_GetWinner()
	local currentWinners = {false}
	local currentWinningVotes = 0

	for _, v in pairs(AEL_Candidates) do
		local ply = player.GetBySteamID(v[1])

		if ply != false then
			if v[2] > currentWinningVotes then
				currentWinners = {}

				table.insert(currentWinners, ply) --76561198060562411

				currentWinningVotes = v[2]
			elseif v[2] == currentWinningVotes then
				if currentWinners[1] == false then
					currentWinners = {}
				end

				table.insert(currentWinners, ply)
			end
		end
	end

	if #currentWinners > 1 then
		local realWinner = math.random(1, #currentWinners)

		currentWinners = {currentWinners[realWinner]}
	end

	local returnVal = {currentWinners[1], currentWinningVotes}

	return returnVal
end

function AEL_Notify(msg, ply)
	net.Start("AElections_Notify")
	net.WriteString(msg)

	if ply == nil then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send(ply)
	end
end

//Meta Functions

function meta:AddVote(x)
	local steamid = self:SteamID()

	for _, v in pairs(AEL_Candidates) do
		if v[1] == steamid then
			v[2] = v[2] + x

			return true
		end
	end

	return false
end

function meta:SetMayor()
	self:changeTeam(AElections.MayorTeamId, true)

	self.isAELWinner = false

	return true
end

function meta:CanJoinElections()
	if AEL_GetMayor() and !AElections.AllowNewElectionsWithMayor then
		if AEL_GetMayor() == self then
			AEL_Notify("You are already the mayor!", self)
		else
			AEL_Notify("I'm sorry, but this city already has a mayor!", self)
		end

		return false
	end

	if !table.HasValue(AElections.AbleToJoinTeams, team.GetName(self:Team())) and AElections.RestrictJoining then
		AEL_Notify("I'm sorry, but you are not the right job to join the elections!", self)

		return false
	end

	if #AEL_Candidates >= AElections.MaxParticipants then
		AEL_Notify("I'm sorry, but we have reached the max possible candidates!", self)

		return false
	end

	if self:IsACandidate() then
		AEL_Notify("You are already a candidate in the elections!", self)

		return false
	end

	if !AElections.AllowF4ToEnterElections then
		for _, npc in pairs(ents.FindByClass("ael_secretary")) do
			if npc:IsValid() and self:GetPos():Distance(npc:GetPos()) < 100 then
				return true
			end
		end

		AEL_Notify("You are too far from the mayor secretary npc!", ply)

		return false
	end

	if GetGlobalBool("AEL_ElectionsActive", false) then
		AEL_Notify("The elections are currently taking place!", self)

		return false
	end

	return true
end

function meta:IsACandidate()
	for _, v in pairs(AEL_Candidates) do
		local ply = player.GetBySteamID(v[1])

		if ply != false then
			if ply == self then
				return true
			end
		end
	end

	return false
end

function meta:GetVotes()
	for _, v in pairs(AEL_Candidates) do
		local ply = player.GetBySteamID(v[1])

		if ply != false then
			if ply == self then
				return v[2]
			end
		end
	end

	return 0
end

function meta:CanVote()
	if self.hasVoted == true then
		AEL_Notify("You already voted!", self)

		return false
	end

	if !table.HasValue(AElections.AbleToVoteTeams, team.GetName(self:Team())) and AElections.RestrictVoting then
		AEL_Notify("I'm sorry, but you are not the right job to vote in the elections!", self)

		return false
	end

	if self:IsACandidate() and !AElections.CandidatesCanVote then
		AEL_Notify("Candidates are not able to vote in the elections!", self)

		return false
	end

	return true
end

//Console Commands

concommand.Add("ael_reload", function(ply)
	if not ply:IsSuperAdmin() then return end

	if timer.Exists("AEL_PreElectionsTimer") then
		timer.Remove("AEL_PreElectionsTimer")
	end

	if timer.Exists("AEL_ElectionsTimer") then
		timer.Remove("AEL_ElectionsTimer")
	end

	if timer.Exists("AEL_PostElectionsTimer") then
		timer.Remove("AEL_PostElectionsTimer")
	end

	AEL_Candidates = {}

	SetGlobalInt("AEL_ElectionsTime", 0)
	SetGlobalInt("AEL_PostElectionsTime", 0)

	SetGlobalBool("AEL_ElectionsActive", false)
	SetGlobalBool("AEL_PreElectionsActive", false)

	AEL_ResetVotes()
	AEL_Update()

	AEL_Notify("The script was re-loaded succesfully.", ply)
end)

concommand.Add("ael_sendtable", function(ply)
	if !ply:IsSuperAdmin() then return end

	AEL_Update()

	AEL_Notify("The candidates table has been broadcasted succesfully to all players.", ply)
end)

concommand.Add("ael_npcsave", function(ply)
	if !ply:IsSuperAdmin() then return end

	AEL_DeleteSpawnPositions()

	timer.Simple(1, function()
		local ael_positions = {}

		for _, ent in pairs(ents.FindByClass("ael_secretary")) do
			table.insert(ael_positions, {position = ent:GetPos(), angle = ent:GetAngles()})
		end

		file.Write("ael/positions/"..string.lower(game.GetMap())..".txt", util.TableToJSON(ael_positions))

		AEL_Notify("The mayor's secretary npc's spawn position has been saved succesfully.", ply)
	end)
end)

concommand.Add("ael_npcreset", function(ply)
	if !ply:IsSuperAdmin() then return end

	AEL_DeleteSpawnPositions()

	AEL_Notify("The mayor's secretary npc's spawn position has been reseted succesfully.", ply)
end)

concommand.Add("ael_version", function(ply)
	if !ply:IsSuperAdmin() then return end

	AEL_Notify("Alek's Elections version "..AEL_Version, ply)
end)
