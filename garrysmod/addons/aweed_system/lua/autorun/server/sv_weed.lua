resource.AddWorkshop("572181423")
util.AddNetworkString("UpdateWeedState")
util.AddNetworkString("PurchaseWeed")
local PLAYER = FindMetaTable("Player")

function PLAYER:GetWeed()
	return self:GetNWInt("WeedLevel", 0)
end

function PLAYER:SetWeed(q, p)
	net.Start("UpdateWeedState")
	net.WriteInt(self:GetNWInt("WeedLevel", 0), 16)
	net.Send(self)

	if (p) then
		self:SetNWInt("WeedLevel", self:GetWeed() + p)
	else
		self:SetNWInt("WeedLevel", q)
	end
end

hook.Add("OnPlayerChangedTeam", "RemoveWeed_Job", function(ply)
	for k, v in pairs(ents.GetAll()) do
		if (v.weed_owner == ply) then
			v:Remove()
		end
	end
end)

hook.Add("PlayerDisconnected", "RemoveWeed", function(ply)
	for k, v in pairs(ents.GetAll()) do
		if (v.weed_owner == ply) then
			v:Remove()
		end
	end
end)

hook.Add("PlayerSpawn", "DisallowWeedDrug", function(ply)
	ply:SetWeed(0)
	ply.DMG = 0
end)

hook.Add("PlayerSay","Weed.Give", function(ply, text)
	if (text == "/dropweed" and ply:GetNWInt("WeedAmmount",0) >= WEED_CONFIG.VialAmount) then
		ply:SetNWInt("WeedAmmount", ply:GetNWInt("WeedAmmount",0) - WEED_CONFIG.VialAmount)
		local ent = ents.Create("sent_drug_bag")
		ent:SetPos(ply:GetEyeTrace().HitPos + ply:GetEyeTrace().HitNormal * 16)
		ent:Spawn()
		ent:SetNWInt("Quality",ply:GetNWInt("WeedQuality"))
		ent:GetNWInt("Consumable",1)
		if(ply:GetNWInt("WeedAmmount",0) == 0) then
			ply:SetNWInt("WeedQuality",0)
		end
	end
end)

hook.Add("EntityTakeDamage", "DoDelayedDamage", function(ply, dmg)
	if (ply:IsPlayer() and ply:GetWeed() > 0) then
		ply.DMG = (ply.DMG or 0) + dmg:GetDamage()
		dmg:SetDamage(0)
	end
end)

hook.Add("PlayerTick", "ResolveDamage", function(ply)
	if (ply:GetWeed() > -1 and (ply.NWeed or 0) < CurTime()) then
		ply.NWeed = CurTime() + math.random(3.0, 8.0)
		ply:SetWeed(1, -1)
	end

	if ((ply.DMG or 0) > 0) then
		if (ply:GetWeed() > 0) then
			if ((ply.NDamage or 0) < CurTime()) then
				ply.NDamage = CurTime() + 1
				ply:SetHealth(ply:Health() - math.ceil(ply.DMG / 10))
				ply.DMG = ply.DMG - math.ceil(ply.DMG / 10)

				if (ply:Health() <= 0 and ply:Alive()) then
					ply:Kill()
				end
			end
		else
			ply:SetHealth(ply:Health() - ply.DMG)
			ply.DMG = 0

			if (ply:Health() <= 0 and ply:Alive()) then
				ply:Kill()
			end
		end
	end
end)

hook.Add("SetupMove", "ClippedMod", function(ply, mv, cmd)
	if (ply:GetWeed() > 0) then
		local w = ply:GetWeed()
		local f = mv:GetForwardSpeed()
		local s = mv:GetSideSpeed()

		if ((ply.MustGoBack or 0) < CurTime()) then
			ply.MustGoBack = CurTime() + math.random(1, 5)
			mv:SetForwardSpeed(f + -math.abs(math.cos(RealTime()) * 25 * w / 75))
		elseif ((ply.MustGoBack or 0) + 2 > CurTime()) then
			mv:SetForwardSpeed(f + math.abs(math.cos(RealTime()) * 25 * w / 75))
		end

		mv:SetSideSpeed(s + math.sin(RealTime()) * 25 * w / 100)
	end
end)

function calculateWeed(ply, newAmount, newQuality)

	local oldAmount, oldQual = ply:GetNWInt("WeedAmmount"), ply:GetNWInt("WeedQuality")
	local totalQuality = ((oldAmount * oldQual) + (newAmount * newQuality) ) / (oldAmount + newAmount)

	ply:SetNWInt("WeedQuality", totalQuality)
	ply:SetNWInt("WeedAmmount", ply:GetNWInt("WeedAmmount") + newAmount)
end

net.Receive("PurchaseWeed", function(l, ply)
	local quantity = net.ReadInt(16)
	local quality = net.ReadInt(16)
	local isselling = net.ReadBool()

	if(!isselling and ply:GetNWInt("WeedQuality", 0) != 0 and quality != ply:GetNWInt("WeedQuality")) then
		//DarkRP.notify(ply, 0, 5, "You only can purchase quality ".. ply:GetNWInt("WeedQuality", 0).." (Sell your actual weed to reset it)")
		//return
	end

	if (quality > 100) then MsgN("Quality bigger than 100") return end
	if (not isnumber(quantity) or quantity > math.huge or quantity < -math.huge) then 
		MsgN("Quantity is not a valid number")
		return 
	end
	if (quality < 0) then 
	return end
	if (quantity < 10) then 
		DarkRP.notify(ply, 0, 5, "You can't buy below 10")
		return 
	end
	if (quantity > 10000) then 
		DarkRP.notify(ply, 0, 5, "You can't buy above 10000")
		return 
	end
	_weedDebug("Weed purchase, quality: " .. quality .. " - Quantity: " .. quantity)

	if (not isselling and not WEED_CONFIG.WeedPurchase) then
		_weedDebug("Weed purchase disabled!")
		DarkRP.notify(ply, 0, 5, "Weed purchase it's disabled, you only can purchase from dealers")

		return
	end

	local mn = math.Round((quantity * WEED_CONFIG.QuantityPrice * quality * WEED_CONFIG.QualityPrice * Either(isselling, WEED_CONFIG.SellingPrice, 1)) / 10) * 10 * Either(isselling, WEED_CONFIG.SellingPrice, 1)
	if (mn < 0) then return end

	if (not isselling and mn <= ply:getDarkRPVar("money")) then
		_weedDebug("Weed transaction started!")
		ply:addMoney(-mn)
		--[[
		local am = a
		local om = ply:GetNWInt("WeedAmmount",0)
		local ql = ply:GetNWInt("WeedQuality",0)

		local div = Either(ql==0,1,2)
		ply:SetNWInt("WeedAmmount",ply:GetNWInt("WeedAmmount",0)+am)

		local totalQuality = ply:GetNWInt("WeedQuality")+((am/ply:GetNWInt("WeedAmmount"))*(b))
		ply:SetNWInt("WeedQuality",math.min(totalQuality,100))
		]]
		calculateWeed(ply, quantity, quality)
		_weedDebug("Weed transaction succefully!")

		if (not ply:HasWeapon("sent_bong")) then
			DarkRP.notify(ply, 0, 5, "Remember that you'll need a bong to smoke")
		else
			DarkRP.notify(ply, 0, 5, "You've purchased " .. quantity .. " grams")
		end
	elseif (isselling and math.Round(quantity) <= math.Round(ply:GetNWInt("WeedAmmount", 0)) and math.Round(quality) == math.Round(ply:GetNWInt("WeedQuality", 0))) then
		_weedDebug("You sold some weed")
		ply:addMoney(mn)
		ply:SetNWInt("WeedAmmount", ply:GetNWInt("WeedAmmount", 0) - quantity)
		DarkRP.notify(ply, 0, 5, "You sold " .. quantity .. " grams of weed for $" .. mn)
	end

	timer.Simple(1, function()
		if (ply:GetNWInt("WeedAmmount", 0) <= 0) then
			ply:SetNWInt("WeedQuality", 0)
		end
	end)
end)
