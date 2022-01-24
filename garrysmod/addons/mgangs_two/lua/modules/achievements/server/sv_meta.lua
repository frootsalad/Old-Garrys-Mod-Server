--[[
MGANGS - ACHIEVEMENTS SERVERSIDE META
Developed by Zephruz
]]

--[[------------
	Gang Achievement Meta
---------------]]

MGangs.Meta:Register({"GetAchievements", "GetGangAchievements"}, MGangs.Gang,
function(self, gangid)
	local gangAchs = MGangs.Data:SelectAllWhere("mg2_gangachievements", "gangid", gangid)

	if (gangAchs) then
    for i=1,#gangAchs do gangAchs[i].complete = (tobool(gangAchs[i].complete) or false) end

		return gangAchs
	end

	return nil
end)

MGangs.Meta:Register({"SetAchievement", "SetGangAchievement"}, MGangs.Gang,
function(self, gangid, name, val, complete)
	local getGang = MGangs.Gang:Exists(gangid)

  if !(MG2_ACHIEVEMENTS.Achievements[name]) then return false end

	if (getGang && name) then
		local getAchs = MGangs.Gang:GetAchievements(gangid)

		if (getAchs) then
			for i=1,#getAchs do
				local k,v = i,getAchs[i]

				if (v.achname == name) then
					if !(tobool(v.complete)) then
	  				MGangs.Data:UpdateWhere("mg2_gangachievements", "id", v.id, {
	  					val = (val or 0),
	            complete = (complete or false),
	  				})

	  				MGangs.Gang:GetOnlineMembers(gangid,
	  				function(ply)
	  					ply:SendGangAchievements({
	  						{
	  							achname = name,
	  							val = val,
	                complete = (complete or false),
	  						},
	  					})
	  				end)

	        	return true, MGangs.Language:GetTranslation("ach_exists_set", (name or "NIL"))
					else
						return false, MGangs.Language:GetTranslation("ach_already_complete")
					end
        end
			end
		end

		local createAchievement = MGangs.Data:InsertInto("mg2_gangachievements", {
			gangid = (gangid),
			achname = (name),
			val = (val or 0),
      complete = (complete or false)
		})

		if (createAchievement or createAchievement == nil) then
			MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendGangAchievements({
					{
						achname = name,
						val = val,
            complete = (complete or false),
					},
				})
			end)
		end

		return true, createUpgrade
	end

	return false, "No gang"
end)

MGangs.Meta:Register("RewardAchievement", MGangs.Gang,
function(self, gangid, achName)
  local gangData = MGangs.Gang:Exists(gangid)

  if !(gangData) then return false end

  local gangAchs = MGangs.Gang:ValidateAchievements(gangid)
  local achData = MG2_ACHIEVEMENTS.Achievements[achName]

  if (!achData or !gangAchs) then return false end

  local rewards = (achData.rewards or {exp = 10, balance = 10})

  for k,v in pairs(gangAchs) do
    if (v.achname == achName && !v.complete) then
      MGangs.Gang:SetExp(gangid, (gangData.exp or 0) + rewards.exp or 0)
      MGangs.Gang:SetBalance(gangid, (gangData.balance or 0) + rewards.balance or 0)
      MGangs.Gang:SetAchievement(gangid, achName, achData.reqAmt, true)

      break
    end
  end
end)

MGangs.Meta:Register("ValidateAchievements", MGangs.Gang,
function(self, gangid)
	local achs = MGangs.Gang:GetAchievements(gangid)
	local achTbl = {}

	if (achs or achs == nil) then
		local achCfgTbl = table.Copy(MG2_ACHIEVEMENTS.Achievements)

		for k,v in pairs(achCfgTbl) do
			if (achs == nil) then
				MGangs.Gang:SetAchievement(gangid, k, (achCfgTbl.defVal or 0))
				table.insert(achTbl,v)
			else
				local exists = false

				for i=1,#achs do
					local ach = achs[i]

					if (ach && ach.achname == k) then
						exists = true
					end
				end

				if !(exists) then
					MGangs.Gang:SetAchievement(gangid, k, (achCfgTbl.defVal or 0))
					achTbl[k] = v
				end
			end
		end
	end

	-- Send user data
	if (achTbl && #achTbl > 0) then
		achs = MGangs.Gang:GetAchievements(gangid)

		MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendGangAchievements(achs or {})
		end)
	end

	return achs
end)

--[[------------
	Player Meta
---------------]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangAchievements(achs)
  if !(achs) then MGangs.Gang:ValidateAchievements(self:GetGangID()) return false end

	for i=1,#achs do
		local achs = achs[i]

		if (achs.achname && achs.val) then
			net.Start("MG.Send.GangAchievements")
				net.WriteString(achs.achname)
				net.WriteInt(achs.val, 32)
			net.Send(self)
		end
	end
end
