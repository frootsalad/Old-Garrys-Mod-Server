--[[
MGANGS - ACHIEVEMENTS SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/achievements/ach_config.lua") -- Config (SV)
AddCSLuaFile("modules/achievements/ach_config.lua") -- Config (CL)

--[[ SERVER ]]
include("sv_meta.lua")

--[[ CLIENT ]]
AddCSLuaFile("modules/achievements/client/cl_meta.lua")
AddCSLuaFile("modules/achievements/client/cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]

-- Verify SQLite tables exist
hook.Add("MG2.SQL.VerifyTables", "MG2.SQL.VerifyTables.MODULE.ACHIEVEMENTS",
function()
	-- [[Gang Upgrades]]
	MGangs.Data:RegisterSQLTable("mg2_gangachievements", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "achname", ctype = "VARCHAR(32) NOT NULL"},
        {name = "val", ctype = "INTEGER NOT NULL"},
				{name = "complete", ctype = "BOOLEAN NOT NULL"},
			},
		})
end)

-- Send any data (to player) this module requires
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.ACHIEVEMENTS",
function(ply)
	local gangID = ply:GetGangID()
  local achs = MGangs.Gang:GetAchievements(gangID)

  ply:SendGangAchievements(achs)
end)

-- Start of gang creation
hook.Add("MG2.Gang.Creation.Start", "MG2.Gang.Creation.Start.MODULE.ACHIEVEMENTS",
function(data)
	local gangid = data.id
	local ganginfo = data.info

  MGangs.Gang:ValidateAchievements(gangid)
end)

-- After gang creation
hook.Add("MG2.Gang.Creation.End", "MG2.Gang.Creation.End.MODULE.ACHIEVEMENTS", function(data) end)

-- After gang deleted
hook.Add("MG2.Gang.Deleted", "MG2.Gang.Deleted.MODULE.ACHIEVEMENTS",
function(id)
	MGangs.Data:DeleteWhere("mg2_gangachievements", "gangid", id)	-- Delete achievements
end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString("MG.Send.GangAchievements")
