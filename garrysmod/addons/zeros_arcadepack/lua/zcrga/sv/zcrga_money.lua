if not SERVER then return end

function zcrga_MoneyPay(ply)
	local ply_canAfford = false

	if (zcrga.config.MoneyType == "DarkRP") then
		if (ply:canAfford(zcrga.config.PlayPrice)) then
			ply:addMoney(-zcrga.config.PlayPrice)
			ply_canAfford = true
		else
			zcrga_Notify(ply, "You cant afford this!", 1)
		end
	elseif (zcrga.config.MoneyType == "BaseWars") then
		if (ply:GetMoney() >= zcrga.config.PlayPrice) then
			ply:TakeMoney(zcrga.config.PlayPrice)
			ply_canAfford = true
		else
			zcrga_Notify(ply, "You cant afford this!", 1)
		end
	elseif (zcrga.config.MoneyType == "PointShop01") then
		if (ply:PS_HasPoints(zcrga.config.PlayPrice)) then
			ply:PS_TakePoints(zcrga.config.PlayPrice)
			ply_canAfford = true
		else
			zcrga_Notify(ply, "You cant afford this!", 1)
		end
	elseif (zcrga.config.MoneyType == "PointShop02") then
		if ply.PS2_Wallet then
			if (ply.PS2_Wallet.points >= zcrga.config.PlayPrice) then
				ply:PS2_AddStandardPoints(-zcrga.config.PlayPrice)
				ply_canAfford = true
			else
				zcrga_Notify(ply, "You cant afford this!", 1)
			end
		end
	end

	return ply_canAfford
end

function zcrga_MoneySend(ply, money)
	if (not IsValid(ply) or not ply:IsPlayer()) then return end
	local aMoney = math.Round(money)

	if (zcrga.config.MoneyType == "DarkRP") then
		ply:addMoney(aMoney)
		zcrga_Notify(ply, "You Won " .. aMoney .. zcrga.config.Currency .. "!", 0)
	elseif (zcrga.config.MoneyType == "BaseWars") then
		ply:GiveMoney(aMoney)
		zcrga_Notify(ply, "You Won " .. aMoney .. zcrga.config.Currency .. "!", 0)
	elseif (zcrga.config.MoneyType == "PointShop01") then
		ply:PS_GivePoints(aMoney)
		zcrga_Notify(ply, "You Won " .. tostring(aMoney) .. "Points!", 0)
	elseif (zcrga.config.MoneyType == "PointShop02") then
		ply:PS2_AddStandardPoints(aMoney, "CoinPusher Prize", true)
		zcrga_Notify(ply, "You Won " .. tostring(aMoney) .. "Points!", 0)
	end
end
