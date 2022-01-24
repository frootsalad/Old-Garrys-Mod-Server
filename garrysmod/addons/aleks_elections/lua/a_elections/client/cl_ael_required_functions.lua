local meta = FindMetaTable("Player")
if not meta then return end

//Functions

function AEL_GetWinningVotes()
	local winningVotes = -1

	for _, v in pairs(AEL_Candidates) do
		local ply = player.GetBySteamID(v[1])

		if ply != false then
			if v[2] > winningVotes then
				winningVotes = v[2]
			end
		end
	end

	return winningVotes
end

function AEL_GetWinner()
	local currentWinners = {false}
	local currentWinningVotes = 0

	for _, v in pairs(AEL_Candidates) do
		local ply = player.GetBySteamID(v[1])

		if ply != false then
			if v[2] > currentWinningVotes then
				currentWinners = {}

				table.insert(currentWinners, ply)
				currentWinningVotes = v[2]
			elseif v[2] == currentWinningVotes then
				if currentWinners[1] == false then
					currentWinners = {}
				end

				table.insert(currentWinners, ply)
			end
		end
	end

	return currentWinners
end

function AEL_CL_Notify(msg)
	surface.PlaySound("buttons/lightswitch2.wav")

	chat.AddText(AElections.ChatTagColor, AElections.ChatTag.." ", Color(255, 255, 255), msg)
end

function AEL_DrawBorders(x, y, w, h, up, down, left, right)
	if AElections.Theme_ColoredBorders then
		surface.SetDrawColor(ael_accentColor.r, ael_accentColor.g, ael_accentColor.b, 255)
	else
		surface.SetDrawColor(25, 25, 25, 255)
	end

	if (up) then surface.DrawRect(x, y, w, 1) end
	if (down) then surface.DrawRect(x, y + h - 1, w, 1) end
	if (left) then surface.DrawRect(x, y, 1, h) end
	if (right) then surface.DrawRect(x + w - 1, y, 1, h) end
end

//Meta Functions

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

//Net Messages

net.Receive("AElections_Update", function()
	AEL_Candidates = net.ReadTable()
end)

net.Receive("AElections_Notify", function()
	local msg = net.ReadString()

	AEL_CL_Notify(msg)
end)
