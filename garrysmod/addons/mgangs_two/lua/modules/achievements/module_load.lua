--[[
MGANGS - ACHIEVEMENTS LOAD
Developed by Zephruz
]]

MGangs.Module.mods.achievements = (MGangs.Module.mods.achievements or {})
MG2_ACHIEVEMENTS = MGangs.Module.mods.achievements
MG2_ACHIEVEMENTS.Achievements = {}
MG2_ACHIEVEMENTS.AchievementTypes = (MG2_ACHIEVEMENTS.AchievementTypes or {})

-- [[Balance Achievement Type]]
MG2_ACHIEVEMENTS.AchievementTypes["balance"] = {

		-- Triggers - calls any hooks needed for your achievement
		triggers = {
			["MG2_ACHIEVEMENTS.Gang.SetMoney.Post"] = {
			hook = "MG2.Gang.SetMoney.Post",
			receive = function(data, gangid, amt, oldAmt)
				oldAmt = tonumber(oldAmt)
				amt = tonumber(amt)
				data.reqAmt = tonumber(data.reqAmt)

				if (oldAmt <= data.reqAmt) then
					if (amt >= data.reqAmt) then
						MGangs.Gang:RewardAchievement(gangid, data.achname)
					else
						MGangs.Gang:SetAchievement(gangid, data.achname, amt)
					end
				end
			end,
		},
	},
}

-- [[Members Achievement Type]]
MG2_ACHIEVEMENTS.AchievementTypes["members"] = {
		-- Triggers - calls any hooks needed for your achievement
		triggers = {
			["MG2_ACHIEVEMENTS.Ply.AddedToGang"] = {
			hook = "MG2.Player.AddedToGang",
			receive = function(data, ply, uInfo)
				local members = MGangs.Gang:GetMembers(uInfo.gangid)

				if (members && istable(members)) then
					if (#members == data.reqAmt) then
						if (SERVER) then
							MGangs.Gang:RewardAchievement(uInfo.gangid,  data.achname)
						end
					else
						if (SERVER) then
							MGangs.Gang:SetAchievement(uInfo.gangid, data.achname, (#members))
						end
					end
				end
			end,
		},
		["MG2_ACHIEVEMENTS.OffPly.AddedToGang"] = {
			hook = "MG2.OfflinePlayer.AddedToGang",
			receive = function(data, steamid, uInfo)
				local members = MGangs.Gang:GetMembers(uInfo.gangid)

				if (members && istable(members)) then
					if (#members == data.reqAmt) then
						if (SERVER) then
							MGangs.Gang:RewardAchievement(uInfo.gangid, data.achname)
						end
					else
						MGangs.Gang:SetAchievement(uInfo.gangid, data.achname, (#members))
					end
				end
			end,
		},
	},
}

MGangs.Meta:Register("CreateAchievement", MGangs.Gang,
function(self, achName, achCat, data)
	if (!achName or !data) then return false end

	if (data.type) then
		table.Merge(data, MG2_ACHIEVEMENTS.AchievementTypes[data.type])
	end

	data["achname"] = (achName or nil)
	data["achcat"] = (achCat or "Other")
	MG2_ACHIEVEMENTS.Achievements[achName] = data

	-- Setup Triggers
	if (data.triggers) then
		local triggers = {
			["hook"] = function(tData)
				hook.Add(tData.hook, tData._key .. "." .. (data.achname),
        function(...)
          tData.receive(data, ...)
        end)
			end,
		}

		for k,v in pairs(data.triggers) do
			if (istable(v)) then
				for i,d in pairs(v) do
					local tType = triggers[i]

					if (tType) then
						v["_key"] = k
						tType(v)
					end
				end
			end
		end
	end
end)

if (SERVER) then
	include("server/sv_achs_load.lua")
	AddCSLuaFile("client/cl_achs_load.lua")
end

if (CLIENT) then
	include("client/cl_achs_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

-- [[Register Permissions]]
-- None
