include("shared.lua")

local StageInfo = {
	[1] = zmlab.language.combiner_step01,
	[2] = zmlab.language.combiner_step02,
	[3] = zmlab.language.combiner_step03,
	[4] = zmlab.language.combiner_step04,
	[5] = zmlab.language.combiner_step05,
	[6] = zmlab.language.combiner_step06,
	[7] = zmlab.language.combiner_step07,
	[8] = zmlab.language.combiner_step08
}

-- Debug
local laser = Material("cable/redlaser")

function ENT:Draw_FilterIndicator()
	render.SetMaterial(laser)
	local filter_startPos = self:GetAttachment(self:LookupAttachment("input")).Pos
	local filter_endPos = filter_startPos + self:GetUp() * 60
	render.DrawBeam(filter_startPos, filter_endPos, 5, 1, 1, Color(255, 0, 0, 0))
	local output_startPos = self:GetAttachment(self:LookupAttachment("effect03")).Pos
	local output_endPos = output_startPos + self:GetUp() * -15
	render.DrawBeam(output_startPos, output_endPos, 5, 1, 1, Color(255, 0, 0, 0))
end

-- Draw
function ENT:Draw()
	self:DrawModel()

	if (LocalPlayer():GetPos():Distance(self:GetPos()) < 500) then
		self:DrawInfo()
		self:VFXSoundLogic()

		if (zmlab.config.debug) then
			self:Draw_FilterIndicator()
		end
	end
end

function ENT:VFXSoundLogic()
	local currentStage = self:GetStage()
	local hasFilter = self:GetHasFilter()

	if (currentStage == 5) then
		-- The Sound Stuff
		if (hasFilter) then
			if (self.PoisonGasSound:IsPlaying()) then
				self.PoisonGasSound:Stop()
			end

			if (not self.FilterSound:IsPlaying()) then
				self.FilterSound:Play()
			end
		else
			if (self.FilterSound:IsPlaying()) then
				self.FilterSound:Stop()
			end

			if (not self.PoisonGasSound:IsPlaying()) then
				self.PoisonGasSound:Play()
			end
		end

		-- The effect Stuff
		if ((self._zmlab_emitTime or CurTime()) > CurTime()) then

		else
			self._zmlab_emitTime = CurTime() + 1

			if (hasFilter) then
				ParticleEffectAttach("zmlab_cleand_gas", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("input"))
			else
				ParticleEffectAttach("zmlab_poison_gas", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("input"))
			end
		end
	else
		if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
			self.PoisonGasSound:Stop()
		end

		if (self.FilterSound and self.FilterSound:IsPlaying()) then
			self.FilterSound:Stop()
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

-- UI
function ENT:DrawInfo()
	local attach = self:GetAttachment(self:LookupAttachment("screen"))

	if attach then
		local Pos = attach.Pos
		local Ang = attach.Ang

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Pos = Pos + self:GetForward() * 3
		Pos = Pos + self:GetRight() * -0.7
		local comp01_Text = "Aluminium: " .. self:GetNeedAluminium() .. " (" .. self:GetAluminium() .. ")"
		local comp02_Text = "Methylamin: " .. self:GetNeedMethylamin() .. " (" .. self:GetMethylamin() .. ")"
		cam.Start3D2D(Pos, Ang, 0.19)
			draw.RoundedBox(3, -80, -50, 195, 100, Color(50, 50, 50))
			draw.RoundedBox(0, -80, -20, 195, 2, Color(75, 75, 75))
			draw.RoundedBox(0, -80, 13, 195, 2, Color(75, 75, 75))
			local currentStage = self:GetStage()

			if (currentStage ~= 7) then
				if (currentStage == 3) then
					draw.DrawText(comp01_Text, "zmlab_font1", -75, -42, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				end

				if (currentStage == 1) then
					draw.DrawText(comp02_Text, "zmlab_font1", -75, -42, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				end
			end

			draw.DrawText(zmlab.language.combiner_nextstep, "zmlab_nextstep", -75, -16, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			draw.DrawText(StageInfo[currentStage], "zmlab_font2", -17, -16, Color(255, 255, 0, 255), TEXT_ALIGN_LEFT)

			if (self:GetHasFilter()) then
				draw.DrawText(zmlab.language.combiner_filter, "zmlab_font2", 30, -40, Color(0, 200, 0), TEXT_ALIGN_LEFT)
			else
				if (currentStage == 5) then
					local glow = math.abs(math.sin(CurTime() * 6) * 255) -- Math stuff for flashing.
					local warncolor = Color(glow, 0, 0) -- This flashes red.
					draw.DrawText(zmlab.language.combiner_danger, "zmlab_font3", 26, -43, warncolor, TEXT_ALIGN_LEFT)
				end
			end

			local procesTime = self:GetProcessingTime()
			local methSludge = self:GetMethSludge()
			local cleanProcess = self:GetCleaningProgress()

			if (procesTime > 0) then
				draw.RoundedBox(0, -75, 20, (180 / self:GetMaxProcessingTime()) * procesTime, 25, Color(0, 150, 0))
				draw.DrawText(zmlab.language.combiner_processing, "zmlab_font1", -40, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end

			if (methSludge > 0) then
				draw.RoundedBox(0, -75, 20, (180 / self:GetMaxMethSludge()) * methSludge, 25, Color(0, 150, 255))
				draw.DrawText(zmlab.language.combiner_methsludge .. methSludge, "zmlab_font1", -25, 25, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end

			if (cleanProcess > 0) then
				local color01 = Color(197, 218, 231)
				local color02 = Color(45, 74, 92)
				local progress = (1 / zmlab.config.Combiner_DirtAmount) * cleanProcess
				local progressColor = LerpVector(progress, Vector(color01.r, color01.g, color01.b), Vector(color02.r, color02.g, color02.b))
				draw.RoundedBox(0, -75, 20, (180 / zmlab.config.Combiner_DirtAmount) * cleanProcess, 25, progressColor)
			end
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self:CreateClientMeshSludge()
	self.PoisonGasSound = CreateSound(self, Sound("/ambient/gas/steam2.wav"))
	self.PoisonGasSound:SetSoundLevel(60)
	self.FilterSound = CreateSound(self, Sound("ambient/machines/city_ventpump_loop1.wav"))
	self.FilterSound:SetSoundLevel(60)
end

-- This creates our client methsludge dummy
function ENT:CreateClientMeshSludge()
	local ent = ents.CreateClientProp()
	ent:SetModel("models/zerochain/zmlab/zmlab_sludge.mdl")
	ent:SetPos(self:GetPos() + self:GetUp() * 20)
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)
	--ent:SetCollisionGroup( COLLISION_GROUP_WORLD  )
	ent:SetNoDraw(true)
	self.SludgeDummy = ent
end

function ENT:OnRemove()
	self:StopSound("progress_cooking")
	self:StopSound("progress_done")
	self:StopSound("progress_filter")

	if (IsValid(self.SludgeDummy)) then
		self.SludgeDummy:Remove()
	end

	if (self.PoisonGasSound and self.PoisonGasSound:IsPlaying()) then
		self.PoisonGasSound:Stop()
	end

	if (self.FilterSound and self.FilterSound:IsPlaying()) then
		self.FilterSound:Stop()
	end
end

-- Network
net.Receive("zmlab_ProcessingSound", function()
	local CombinerENT = net.ReadEntity()
	local stage = net.ReadFloat()

	if (IsValid(CombinerENT)) then
		if (stage == 2 or stage == 4 or stage == 6) then
			CombinerENT:EmitSound("progress_cooking")
		elseif (stage == 3 or stage == 7) then
			CombinerENT:StopSound("progress_cooking")
			CombinerENT:EmitSound("progress_done")
		else
			CombinerENT:StopSound("progress_cooking")
		end
	end
end)
net.Receive("zmlab_MethSlude_Update_net", function(len, ply)
	local entIndex = net.ReadFloat()
	local ent = Entity(entIndex)

	if (IsValid(ent)) then
		ent:Update_ClientMethSludge()
	end
end)

function ENT:Update_ClientMethSludge()
	if (IsValid(self.SludgeDummy)) then
		self.SludgeDummy:SetNoDraw(false)
	else
		self:CreateClientMeshSludge()
		self.SludgeDummy:SetNoDraw(false)
	end

	local currentStage = self:GetStage()

	if (currentStage == 1) then
		self.SludgeDummy:SetNoDraw(true)
		zmlab.f.ClientAnim(self.SludgeDummy, "idle", 1)
	elseif (currentStage == 2) then
		zmlab.f.ClientAnim(self.SludgeDummy, "half", 1)
	elseif (currentStage == 4) then
		zmlab.f.ClientAnim(self.SludgeDummy, "full", 1)
	elseif (currentStage == 8) then
		self.SludgeDummy:SetNoDraw(true)
		zmlab.f.ClientAnim(self.SludgeDummy, "idle", 1)
	end
end
