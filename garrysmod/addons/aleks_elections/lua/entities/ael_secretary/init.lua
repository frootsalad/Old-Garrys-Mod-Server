//Files
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

//Entity Functions

function ENT:Initialize()
	self:SetModel(AElections.SecretaryModel)
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(90)
	self:DropToFloor()
end

function ENT:AcceptInput(input, activator, caller)
	if input == "Use" and activator:IsPlayer() then
    if !activator:CanJoinElections() then return end

		net.Start("AElections_EnterMenu")
		net.Send(activator)
	end
end

//Spawn Hooks

hook.Add("PostGamemodeLoaded", "AElections_Files", function()
	if not file.IsDir("ael", "DATA") then
		file.CreateDir("ael", "DATA")
	end

	if not file.IsDir("ael/positions", "DATA") then
		file.CreateDir("ael/positions", "DATA")

		print("[AElections] The Alek's Elections data directory has been created succesfully.")
	end
end)

hook.Add("InitPostEntity", "AElections_Spawn", function()
	local spawnTable = {}
	local spawnFile = file.Read("ael/positions/"..string.lower(game.GetMap())..".txt", "DATA")

	if spawnFile != nil then
		spawnTable = util.JSONToTable(spawnFile)
	end

	for _, spawn in pairs(spawnTable) do
		local position = spawn.position
		local angle = spawn.angle
		local ael_s = ents.Create("ael_secretary")

		ael_s:SetPos(position)
		ael_s:SetAngles(angle)
		ael_s:SetMoveType(0)
		ael_s:Spawn()

		local phys = ael_s:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:EnableMotion(false)
		end
	end

	print("[AElections] Succesfully spawned the mayor's secretary npc!")
end)
