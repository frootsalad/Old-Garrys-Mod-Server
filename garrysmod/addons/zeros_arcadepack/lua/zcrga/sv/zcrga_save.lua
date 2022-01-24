if (not SERVER) then return end

function zcrga_PublicEnts_Save(ply)
	local data = {}

	if not file.Exists("zcrga", "DATA") then
		file.CreateDir("zcrga")
	end

	for u, j in pairs(ents.FindByClass("zcg_machine")) do
		table.insert(data, {
			class = j:GetClass(),
			pos = j:GetPos(),
			ang = j:GetAngles()
		})
	end

	file.Write("zcrga/" .. game.GetMap() .. "_PublicEnts" .. ".txt", util.TableToJSON(data))

	if (IsValid(ply)) then
		zcrga_Notify(ply, "The CoinPusher Entities have been saved for the map " .. game.GetMap() .. "!", 0)
	end
end



function zcrga_PublicEnts_Load()
	local path = "zcrga/" .. game.GetMap() .. "_PublicEnts" .. ".txt"

	if file.Exists(path, "DATA") then
		local data = file.Read(path, "DATA")
		data = util.JSONToTable(data)

		for k, v in pairs(data) do
			local ent = ents.Create(v.class)
			ent:SetPos(v.pos)
			ent:SetAngles(v.ang)
			ent:Spawn()
		end

		print("[Zeros CoinPusher] Finished loading CoinPusher entities.")
	else
		print("[Zeros CoinPusher] No map data found for CoinPusher entities.")
	end
end

hook.Add( "InitPostEntity", "zcrga_PublicEnts_OnMapLoad", zcrga_PublicEnts_Load)
hook.Add("PostCleanupMap", "zcrga_PublicEnts_PostCleanUp", zcrga_PublicEnts_Load)

concommand.Add("zcrga_savepublicentities", function(ply, cmd, args)
	if zcrga_IsAdmin(ply) then
		zcrga_PublicEnts_Save(ply)
	else
		zcrga_Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
	end
end)

hook.Add("PlayerSay", "zcrga_HandleConCanCommands", function(ply, text)
	if string.sub(string.lower(text), 1, 15) == "!savecoinpusher" then
		if table.HasValue(zcrga.config.allowedRanks, ply:GetUserGroup()) then
			zcrga_PublicEnts_Save(ply)
		else
			zcrga_Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
		end
	end
end)
