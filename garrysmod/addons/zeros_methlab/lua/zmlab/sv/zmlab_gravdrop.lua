if not SERVER then return end
zmlab = zmlab or {}
zmlab.f = zmlab.f or {}

function zmlab.f.GravGun_DropOffPoint(ply, ent)
	if ((ent:GetClass() == "zmlab_meth" or ent:GetClass() == "zmlab_collectcrate" or ent:GetClass() == "zmlab_palette") and ent:GetMethAmount() > 0) then
		for k, v in pairs(ents.FindByClass("zmlab_methdropoff")) do
			if (v:GetPos():Distance(ent:GetPos()) < 45 and IsValid(v.Deliver_Player)) then
				if (ply ~= v.Deliver_Player) then
					local string = string.Replace(zmlab.language.methbuyer_dropoff_wrongguy, "$deliverguy", tostring(v.Deliver_Player:Nick()))
					zmlab.f.Notify(ply, string, 0)
				end

				-- Gives the money
				local Earning = ent:GetMethAmount() * zmlab.config.MethBuyer_SellPrice
				zmlab.f.GiveMoney(v.Deliver_Player, Earning)
				local string = string.Replace(zmlab.language.methbuyer_soldMeth, "$methAmount", tostring(math.Round(ent:GetMethAmount())))
				string = string.Replace(string, "$earning", tostring(Earning))
				string = string.Replace(string, "$currency", zmlab.config.MethBuyer_Currency)
				zmlab.f.Notify(v.Deliver_Player, string, 0)

				-- Create VFX
				if (zmlab.config.MethBuyer_ShowEffect) then
					if (ent:GetClass() == "zmlab_meth") then
						zmlab.f.CreateEffectTable("zmlab_sell_effect_small", "Meth_Sell01", v, v:GetAngles(), v:GetPos())
					elseif (ent:GetClass() == "zmlab_collectcrate") then
						zmlab.f.CreateEffectTable("zmlab_sell_effect_big", "Meth_Sell01", v, v:GetAngles(), v:GetPos())
					end
				end

				if (zmlab.config.MethBuyer_DropOffPoint_OnTimeUse) then
					v:DropOff_Close()
				end

				ent:Remove()
				break
			end
		end
	end
end

function zmlab.f.GravGun_MainLogic(ply, ent)
	zmlab.f.GravGun_DropOffPoint(ply, ent)
end

hook.Add("GravGunOnDropped", "zmlab_GravGunOnDropped", zmlab.f.GravGun_MainLogic)
