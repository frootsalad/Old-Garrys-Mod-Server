AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

-- Spawn
function ENT:SpawnFunction(ply, tr)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 30
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	angle = Angle(0, angle.yaw, 0)
	angle:RotateAroundAxis(angle:Up(), 0)
	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:UseClientSideAnimation()
	self:CreateProp("zcg_animbase", self:GetPos(), self:GetAngles(), "models/zerochain/props_arcade/zap_coinpusher_glass.mdl")
	self.Chest = self:CreateProp("zcg_animbase", self:GetPos(), self:GetAngles(), "models/zerochain/props_arcade/zap_coinpusher_chest.mdl")
	self.Coin = self:CreateProp("zcg_animbase", self:GetPos(), self:GetAngles(), "models/zerochain/props_arcade/zap_coinanim.mdl")
	self.InsertCoin = self:CreateProp("zcg_animbase", self:GetPos(), self:GetAngles(), "models/zerochain/props_arcade/zap_coinanim.mdl")
	-- Field01
	self.Field01_money = 0
	local Field01Pos = self:GetPos() + self:GetUp() * 6 + self:GetForward() * 16
	self.Field01_CoinPile = self:CreateProp("zcg_animbase", Field01Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coinpile.mdl")
	self.Field01_CoinPile:SetBodygroup(0, 6)
	self.Field01_CoinWin_small = self:CreateProp("zcg_animbase", Field01Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_small.mdl")
	self.Field01_CoinWin_medium = self:CreateProp("zcg_animbase", Field01Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_medium.mdl")
	self.Field01_CoinWin_big = self:CreateProp("zcg_animbase", Field01Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_big.mdl")
	self.Field01_CoinWin_small:SetNoDraw(true)
	self.Field01_CoinWin_medium:SetNoDraw(true)
	self.Field01_CoinWin_big:SetNoDraw(true)
	-- Field01
	self.Field02_money = 0
	local Field02Pos = self:GetPos()
	self.Field02_CoinPile = self:CreateProp("zcg_animbase", Field02Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coinpile.mdl")
	self.Field02_CoinPile:SetBodygroup(0, 6)
	self.Field02_CoinWin_small = self:CreateProp("zcg_animbase", Field02Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_small.mdl")
	self.Field02_CoinWin_medium = self:CreateProp("zcg_animbase", Field02Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_medium.mdl")
	self.Field02_CoinWin_big = self:CreateProp("zcg_animbase", Field02Pos, self:GetAngles(), "models/zerochain/props_arcade/zap_coin_win_big.mdl")
	self.Field02_CoinWin_small:SetNoDraw(true)
	self.Field02_CoinWin_medium:SetNoDraw(true)
	self.Field02_CoinWin_big:SetNoDraw(true)

	timer.Simple(1, function()
		if (IsValid(self)) then
			zcrga_CreateAnimTable(self, "run", 1)
		end
	end)

	if (zcrga.config.StartEmpty == false) then
		local startMoney = math.random(zcrga.config.TriggerAmount / 5, zcrga.config.TriggerAmount / 2)
		self:SetMoneyCount(startMoney)
		self.Field01_money = startMoney * 0.7
		self.Field02_money = startMoney * 0.3
	end

	self:UpdateVisual(1)
	self:UpdateVisual(2)
	self.InUse = false
	self.LockPickTime = zcrga.config.LockPickTime
end

hook.Add("canLockpick", "zcrga_canLockpick", function(ply, ent)

	if (ent:GetClass() == "zcg_machine" and zcrga.config.CanBeLockPicked and ent.InUse == false and ent:GetMoneyCount() > 0) then
		local police

		for k, v in pairs(player.GetAll()) do
			if (table.HasValue(zcrga.config.TEAM_POLICE, team.GetName( v:Team() ))) then
				police = v
				break
			end
		end

		if (police or table.Count(zcrga.config.TEAM_POLICE) == 0) then
			ent.InUse = true

			return true
		else
			return false
		end
	end
end)

hook.Add("lockpickTime", "zcrga_lockpickTime", function(ply, ent)
	if (ent:GetClass() == "zcg_machine" and ply:IsPlayer()) then
		return zcrga.config.LockPickTime
	end
end)

hook.Add("onLockpickCompleted", "zcrga_onLockpickCompleted", function(ply, success, ent)
	if (ent:GetClass() == "zcg_machine" and ply:IsPlayer()) then
		if (success) then
			local winPool = {}

			for i = 1, 100 * zcrga.config.LockPick_WinChance do
				table.insert(winPool, true)
			end

			for i = 1, 100 * (1 - zcrga.config.LockPick_WinChance) do
				table.insert(winPool, false)
			end

			local Win = table.Random(winPool)

			if (Win == true) then
				ent:PlayCoinFallAnim(1, 1)
				ent:PlayCoinFallAnim(1, 2)
				local money = ent:GetMoneyCount() * zcrga.config.LockPick_WinAmount
				ent:GivePrize(money, ply)

				local police = {}

				for k, v in pairs(player.GetAll()) do
					if (table.HasValue(zcrga.config.TEAM_POLICE, team.GetName( v:Team() ) ) ) then
						table.insert(police,v)
					end
				end

				if (police and table.Count(police) > 0) then
					for k, v in pairs(police) do
						ply:wanted(v, "PickLocked a ArcadeMachine!", 120)
					end
				end

				ent:SetMoneyCount(ent:GetMoneyCount() - money)
				ent.Field01_money = money * 0.7
				ent.Field02_money = money * 0.3
				ent:UpdateVisual(1)
				ent:UpdateVisual(2)
			else
				zcrga_Notify(ply, "It almost opened!", 1)
			end
		end

		ent.InUse = false
	end
end)

function ENT:CreateProp(class,pos,ang,model)
	local ent = ents.Create(class)
	ent:SetModel(model)
	ent:SetAngles( ang )
	ent:SetPos( pos )
	ent:SetParent(self)
	ent:Spawn()
	ent:Activate()
	ent.PhysgunDisabled = true
	return ent
end

local coinAnimData = {}

coinAnimData[1] = {
	anim = "coin_field01_shot01",
	Hit01_delay = 1,
	Hit02_delay = -1,
	Effect_delay = 1.1,
	EffectPos = "effect_pos03",
	field = 1
}

coinAnimData[2] = {
	anim = "coin_field01_shot02",
	Hit01_delay = 1,
	Hit02_delay = -1,
	Effect_delay = 1.1,
	EffectPos = "effect_pos04",
	field = 1
}

coinAnimData[3] = {
	anim = "coin_field02_shot01",
	Hit01_delay = 1,
	Hit02_delay = 1.25,
	Effect_delay = 1.6,
	EffectPos = "effect_pos01",
	field = 2
}

coinAnimData[4] = {
	anim = "coin_field02_shot02",
	Hit01_delay = 1,
	Hit02_delay = 1.25,
	Effect_delay = 1.6,
	EffectPos = "effect_pos02",
	field = 2
}

-- Logic
function ENT:Use(ply, caller)
	if (self.InUse) then return end
	if not IsValid(caller) or not caller:IsPlayer() then return end
	self:ValidPlayer(ply)
end

-- Here we check if the player is allowed do play
function ENT:ValidPlayer(ply)

	-- Is this machine allready used by a player?
	if (IsValid(self.InUse_Player) and self.InUse_Player:IsPlayer()) then

		-- Does the player still play with it?
		if (CurTime() < self.LastInteraction) then

			-- Is this the current Player who plays the machine?
			if (ply ~= self.InUse_Player) then
				zcrga_Notify(ply, "Another Player is using this right now!", 1)

				return
			end
		else
			self.InUse_Player = nil
		end

		if (ply ~= self.InUse_Player ) then
			-- Did the player allready interact with a machine?
			if (ply.zcrga_LastInteraction) then
				-- Does the Player has do wait for the CoolDown?
				if (ply.zcrga_LastInteraction > CurTime()) then
					local waitTime = ply.zcrga_LastInteraction - CurTime()
					zcrga_Notify(ply, "You have do wait " .. math.Round(waitTime) .. " seconds before you can use another machine!", 1)

					return
				end
			end
		end
	else
		-- Did the player allready interact with a machine?
		if (ply.zcrga_LastInteraction) then
			-- Does the Player has do wait for the CoolDown?
			if (ply.zcrga_LastInteraction > CurTime()) then
				local waitTime = ply.zcrga_LastInteraction - CurTime()
				zcrga_Notify(ply, "You have do wait " .. math.Round(waitTime) .. " seconds before you can use another machine!", 1)

				return
			end
		end
	end

	-- Here we take the money of the player or return if he cant afford it
	if (not zcrga_MoneyPay(ply)) then return end
	self.InUse_Player = ply
	self.LastInteraction = CurTime() + zcrga.config.PlayerCoolDown
	ply.zcrga_LastInteraction = self.LastInteraction
	-- This Starts the whole game
	self.InUse = true
	self:InsertTheCoin(ply)
end

-- This Handles the insert Coin logic
function ENT:InsertTheCoin(ply)
	zcrga_CreateEffectTable(nil, "zap_coininsert", self, self:GetAngles(), self:GetPos(), nil)
	zcrga_CreateAnimTable(self.InsertCoin, "coin_insert", 1)

	-- Make Coin Visible
	timer.Simple(0.1, function()
		if (IsValid(self)) then
			self.InsertCoin:SetNoDraw(false)
		end
	end)

	local rndAnimData = coinAnimData[math.random(#coinAnimData)]

	-- Play Throw animation for coin
	timer.Simple(0.5, function()
		if (IsValid(self)) then
			self.InsertCoin:SetNoDraw(true)
			self.Coin:SetNoDraw(false)
			zcrga_CreateAnimTable(self.Coin, rndAnimData.anim, 1)
			zcrga_CreateEffectTable(nil, "zap_coinpusher_shoot", self, self:GetAngles(), self:GetPos() + self:GetUp() * 25 + self:GetForward() * -7, nil)
		end
	end)

	-- Play first hit metal sound
	timer.Simple(rndAnimData.Hit01_delay, function()
		if (IsValid(self)) then
			zcrga_CreateEffectTable(nil, "zap_coinpusher_coinhit_sfx", self, self:GetAngles(), self:GetPos(), nil)
		end
	end)

	-- Play second hit metal sound
	if (rndAnimData.Hit02_delay ~= -1) then
		timer.Simple(rndAnimData.Hit02_delay, function()
			if (IsValid(self)) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_coinhit_sfx", self, self:GetAngles(), self:GetPos(), nil)
			end
		end)
	end

	-- Play hit coin pile sound
	timer.Simple(rndAnimData.Effect_delay, function()
		if (IsValid(self)) then
			zcrga_CreateEffectTable("zap_coinpusher_coinhit", "zap_coinpusher_hitpile", self, self:GetAngles(), self.Coin:GetAttachment(self.Coin:LookupAttachment(rndAnimData.EffectPos)).Pos, nil)
			self.Coin:SetNoDraw(true)

			if (rndAnimData.field == 1) then
				self.Field01_money = self.Field01_money + zcrga.config.PlayPrice
				self:UpdateField01(ply)
			elseif (rndAnimData.field == 2) then
				self.Field02_money = self.Field02_money + zcrga.config.PlayPrice
				self:UpdateField02(ply)
			end
		end
	end)
end

-- This Handles the logic for our first field
function ENT:UpdateField01(ply)
	local WinChance = self:CalcWinChance(1)

	if (WinChance == 0) then
		self:NoWin(ply)
	else
		local DropAmount = self:CalcWinAmount(1)

		if (DropAmount == 0) then
			self:NoWin(ply)
		else
			self:PlayCoinFallAnim(DropAmount, 1)
			local prizeMoney = 0

			if (self.Field01_money < zcrga.config.Prize[DropAmount].Amount) then
				prizeMoney = self.Field01_money
				self.Field01_money = 0
			else
				prizeMoney = zcrga.config.Prize[DropAmount].Amount
				self.Field01_money = self.Field01_money - zcrga.config.Prize[DropAmount].Amount
			end

			-- This updates our coin pile
			self:UpdateVisual(1)

			timer.Simple(1, function()
				if (IsValid(self)) then
					self.Field02_money = self.Field02_money + prizeMoney
					--Trigger next field and give him
					self:UpdateField02(ply)
				end
			end)
		end
	end

	-- This updates our coin pile
	self:UpdateVisual(1)
	self:UpdateVisual(2)
end

-- This Handles the logic for our second field
function ENT:UpdateField02(ply)
	local WinChance = self:CalcWinChance(2)

	if (WinChance == 0) then
		self:NoWin(ply)
	else
		local PrizeSize = self:CalcWinAmount(2)

		if (PrizeSize == 0) then
			self:NoWin(ply)
		else
			self:PlayCoinFallAnim(PrizeSize, 2)
			local prizeMoney = 0

			if (self.Field02_money < zcrga.config.Prize[PrizeSize].Amount) then
				prizeMoney = self.Field02_money
				self.Field02_money = 0
			else
				prizeMoney = zcrga.config.Prize[PrizeSize].Amount
				self.Field02_money = self.Field02_money - zcrga.config.Prize[PrizeSize].Amount
			end

			timer.Simple(1.3, function()
				if (IsValid(self)) then
					self:GivePrize(prizeMoney, ply)
				end
			end)
		end
	end

	-- This updates our coin pile
	self:UpdateVisual(1)
	self:UpdateVisual(2)
end

-- Here we check if the player wins something
function ENT:CalcWinChance(field)
	local currentMoney = 0
	local MoneyCap = zcrga.config.TriggerAmount / 2

	if (field == 1) then
		currentMoney = self.Field01_money
	elseif (field == 2) then
		currentMoney = self.Field02_money
	end

	local ItemChancePool = {}

	for i = 1, (100 - (100 * zcrga.config.WinChance)) do
		table.insert(ItemChancePool, 0)
	end

	for i = 1, (100 * zcrga.config.WinChance) do
		table.insert(ItemChancePool, 1)
	end

	-- This Increases the chance of money dropping if there is allready much mony on the field
	if (currentMoney > MoneyCap) then
		local prizePoolCount = table.Count(ItemChancePool)
		prizePoolCount = prizePoolCount / 2

		for i = 1, prizePoolCount do
			table.insert(ItemChancePool, 1)
		end
	end

	return table.Random(ItemChancePool)
end

-- Here we check how much the player wins
function ENT:CalcWinAmount(field)
	local PrizeAmount = -1
	local PrizeAmountPool = {}
	local currentMoney

	if (field == 1) then
		currentMoney = self.Field01_money
	elseif (field == 2) then
		currentMoney = self.Field02_money
	end

	local MoneyCap = zcrga.config.TriggerAmount / 2

	if (currentMoney > MoneyCap / 3) then
		-- This builds the Basic Prize Amount Pool defined in the config
		for k, v in pairs(zcrga.config.Prize) do
			for i = 1, v.WinChance do
				table.insert(PrizeAmountPool, k)
			end
		end

		-- This will increase our chance of wining big if the machine gets too full
		-- More Money in Machine == We Win More
		local DropBoni

		if (currentMoney > MoneyCap) then
			-- Big Win
			DropBoni = 3
		end

		if (DropBoni) then
			-- This gives us the influence count our DropBoni has in the PrizePool
			local InfluenceChance = table.Count(PrizeAmountPool) * zcrga.config.TriggerChance -- 90% Chance our drop money influences the win

			-- Here we add the Bonus Drop Chance
			for i = 1, InfluenceChance do
				table.insert(PrizeAmountPool, DropBoni)
			end
		end

		PrizeAmount = table.Random(PrizeAmountPool)
	else
		-- No Win
		PrizeAmount = 0
	end

	return PrizeAmount
end

-- This Function gets called when the player wins nothing
function ENT:NoWin(ply)
	self.InUse = false
end

-- This function plays the coin fall animation depending on the win size
function ENT:PlayCoinFallAnim(size, field)
	local field_big
	local field_medium
	local field_small
	local effectPos

	if (field == 1) then
		field_big = self.Field01_CoinWin_big
		field_medium = self.Field01_CoinWin_medium
		field_small = self.Field01_CoinWin_small
		effectPos = self:GetPos() + self:GetUp() * 6 + self:GetForward() * 16
	elseif (field == 2) then
		effectPos = self:GetPos()
		field_big = self.Field02_CoinWin_big
		field_medium = self.Field02_CoinWin_medium
		field_small = self.Field02_CoinWin_small

		if (not zcrga.config.NoWinMusic) then
			if (size == 1) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_music_win_small", self, self:GetAngles(), self:GetPos(), nil)
			elseif (size == 2) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_music_win_medium", self, self:GetAngles(), self:GetPos(), nil)
			elseif (size == 3) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_music_win_big", self, self:GetAngles(), self:GetPos(), nil)
			end
		end
	end

	if (size == 1) then
		field_small:SetNoDraw(false)
		zcrga_CreateAnimTable(field_small, "win", 2)
		zcrga_CreateEffectTable("zap_coinpusher_win_coinexplo_small", "zap_coinpusher_coin_small", self, self:GetAngles(), effectPos, nil)
	elseif (size == 2) then
		field_medium:SetNoDraw(false)
		zcrga_CreateAnimTable(field_medium, "win", 2)
		zcrga_CreateEffectTable("zap_coinpusher_win_coinexplo_medium", "zap_coinpusher_coin_medium", self, self:GetAngles(), effectPos, nil)
	elseif (size == 3) then
		field_big:SetNoDraw(false)
		zcrga_CreateAnimTable(field_big, "win", 2)
		zcrga_CreateEffectTable("zap_coinpusher_win_coinexplo_big", "zap_coinpusher_coin_big", self, self:GetAngles(), effectPos, nil)
	end

	local resetTime = self:SequenceDuration(self:GetSequence())

	timer.Simple(resetTime, function()
		if (IsValid(self)) then
			field_small:SetNoDraw(true)
			field_medium:SetNoDraw(true)
			field_big:SetNoDraw(true)
		end
	end)

	timer.Simple(0.5, function()
		if (IsValid(self)) then
			if (field == 1) then
				zcrga_CreateEffectTable("zap_coinpusher_coinhit", "zap_coinpusher_hitpile", self, self:GetAngles(), self:GetPos() + self:GetUp() * 31 + self:GetForward() * -3, nil)
				zcrga_CreateEffectTable("zap_coinpusher_coinhit", "zap_coinpusher_hitpile", self, self:GetAngles(), self:GetPos() + self:GetUp() * 31 + self:GetForward() * -3 + self:GetRight() * 7, nil)
				zcrga_CreateEffectTable("zap_coinpusher_coinhit", "zap_coinpusher_hitpile", self, self:GetAngles(), self:GetPos() + self:GetUp() * 31 + self:GetForward() * -3 + self:GetRight() * -7, nil)
			end

			if (size == 1) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_coin_small", self, self:GetAngles(), self:GetPos(), nil)
			elseif (size == 2) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_coin_medium", self, self:GetAngles(), self:GetPos(), nil)
			elseif (size == 3) then
				zcrga_CreateEffectTable(nil, "zap_coinpusher_coin_big", self, self:GetAngles(), self:GetPos(), nil)
			end
		end
	end)
end

-- This function gives the player his prize
function ENT:GivePrize(PrizeMoney, ply)
	zcrga_CreateEffectTable(nil, "zap_coinpusher_door", self, self:GetAngles(), self:GetPos(), nil)
	zcrga_CreateAnimTable(self.Chest, "give", 2)

	timer.Simple(0.2, function()
		if (IsValid(self)) then
			zcrga_MoneySend(ply, PrizeMoney)
			self.InUse = false
		end
	end)
end

function ENT:UpdateVisual(field)
	self:SetMoneyCount(self.Field01_money + self.Field02_money)
	local currentMoney
	local coinPile
	local MoneyCap = zcrga.config.TriggerAmount / 2 -- We Half it because we have 2 fields
	local currentBG

	if (field == 1) then
		currentMoney = self.Field01_money
		coinPile = self.Field01_CoinPile
	elseif (field == 2) then
		currentMoney = self.Field02_money
		coinPile = self.Field02_CoinPile
	end

	if (currentMoney > 0) then
		if (currentMoney < MoneyCap / 6) then
			currentBG = 1
		elseif (currentMoney < MoneyCap / 5) then
			currentBG = 2
		elseif (currentMoney < MoneyCap / 4) then
			currentBG = 3
		elseif (currentMoney < MoneyCap / 3) then
			currentBG = 4
		elseif (currentMoney < MoneyCap / 2) then
			currentBG = 5
		elseif (currentMoney < MoneyCap) then
			currentBG = 6
		elseif (currentMoney >= MoneyCap) then
			currentBG = 7
		end

		coinPile:SetBodygroup(0, currentBG)
	else
		coinPile:SetBodygroup(0, 0)
	end
end

function ENT:DebugFields()
	print("End PlayStats")
	print("Field01: " .. self.Field01_money)
	print("Field02: " .. self.Field02_money)
	print("------------------------------")
end
