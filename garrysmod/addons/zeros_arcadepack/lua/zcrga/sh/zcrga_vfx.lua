if SERVER then
	-- Animation
	util.AddNetworkString("zcrga_AnimEvent")

	local function ServerAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	function zcrga_CreateAnimTable(prop, anim, speed)
		ServerAnim(prop, anim, speed)
		net.Start("zcrga_AnimEvent")
		local animInfo = {}
		animInfo.anim = anim
		animInfo.speed = speed
		animInfo.parent = prop
		net.WriteTable(animInfo)
		net.SendPVS(prop:GetPos())
	end

	--Effects
	util.AddNetworkString("zcrga_FX")

	function zcrga_CreateEffectTable(effect, sound, parent, angle, position, attach)
		net.Start("zcrga_FX")
		local effectInfo = {}
		effectInfo.effect = effect
		effectInfo.sound = sound
		effectInfo.pos = position
		effectInfo.ang = angle
		effectInfo.parent = parent
		effectInfo.attach = attach
		net.WriteTable(effectInfo)
		net.SendPVS(parent:GetPos())
	end

	util.AddNetworkString("zcrga_remove_FX")

	function zcrga_RemoveEffectNamed(prop, effect)
		net.Start("zcrga_remove_FX")
		local effectInfo = {}
		effectInfo.effect = effect
		effectInfo.parent = prop
		net.WriteTable(effectInfo)
		net.SendPVS(prop:GetPos())
	end
end

if CLIENT then
	-- Animation
	local function ClientAnim(prop, anim, speed)
		local sequence = prop:LookupSequence(anim)
		prop:SetCycle(0)
		prop:ResetSequence(sequence)
		prop:SetPlaybackRate(speed)
		prop:SetCycle(0)
	end

	net.Receive("zcrga_AnimEvent", function(len, ply)
		local animInfo = net.ReadTable()

		if (animInfo and IsValid(animInfo.parent) and animInfo.anim) then
			ClientAnim(animInfo.parent, animInfo.anim, animInfo.speed)
		end
	end)

	-- Effects
	net.Receive("zcrga_FX", function(len, ply)
		local effectInfo = net.ReadTable()

		if (effectInfo) then
			if (effectInfo.parent == nil) then return end

			if (IsValid(effectInfo.parent)) then
				if (effectInfo.sound) then
					effectInfo.parent:EmitSound(effectInfo.sound)
				end

				if (effectInfo.effect) then
					if (effectInfo.attach) then
						ParticleEffectAttach(effectInfo.effect, PATTACH_POINT_FOLLOW, effectInfo.parent, effectInfo.attach)
					else
						ParticleEffect(effectInfo.effect, effectInfo.pos, effectInfo.ang, effectInfo.parent)
					end
				end
			end
		end
	end)

	net.Receive("zcrga_remove_FX", function(len, ply)
		local effectInfo = net.ReadTable()

		if (effectInfo and IsValid(effectInfo.parent) and effectInfo.effect) then
			effectInfo.parent:StopParticlesNamed(effectInfo.effect)
		end
	end)
end
