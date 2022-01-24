--[[
MGANGS - RANKINGS LOAD
Developed by Zephruz
]]

MGangs.Module.mods.rankings = (MGangs.Module.mods.rankings or {})

MG2_RANKINGS = MGangs.Module.mods.rankings
MG2_RANKINGS.cacheExpireTime = 300
MG2_RANKINGS.rankCache = (MG2_RANKINGS.rankCache or {})
MG2_RANKINGS.rankTypes = (MG2_RANKINGS.rankTypes or {})

if (SERVER) then
	include("server/sv_rnks_load.lua")
	AddCSLuaFile("client/cl_rnks_load.lua")
end

if (CLIENT) then
	include("client/cl_rnks_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

-- [[ MODULE-RELATED REGISTRATION/META ]]

-- Caching for Rank Data
function MG2_RANKINGS:FlushCache()
	local cVals = (table.Count(self.rankCache) or 0)

	self.rankCache = {}

	MGangs:ConsoleMessage("[RANKINGS] - Flushed (" .. cVals .. ") cached rankings.")
end

function MG2_RANKINGS:ReleaseFromCache(name)
	self.rankCache[name] = nil
end

function MG2_RANKINGS:AccessCache(name)
	if !(self.rankCache[name]) then return false end

	return self.rankCache[name]
end

-- Getters & Setters for Rank Types
function MG2_RANKINGS:RegisterRankType(name, data)
	self.rankTypes[name] = data
end

function MG2_RANKINGS:GetRankType(name)
	return (self.rankTypes[name] or false)
end

MG2_RANKINGS:RegisterRankType("top_balance", {
	name = "Most Cash",
	fetchData = function()
		local maxKey = "MAX(balance)"
		local query = MGangs.Data:Query("SELECT id, name, icon_url, " .. maxKey .. " FROM mg2_gangdata")
		query = (query[1])

		local maxVal = query[maxKey]

		if (query && maxVal) then
			query["data"] = MGangs.Config.DollarSymbol .. MGangs.Util:FormatNumber(maxVal or 0)
			query[maxKey] = nil

			return query
		end

		return {}
	end,
})

MG2_RANKINGS:RegisterRankType("top_level", {
	name = "Highest Level",
	fetchData = function()
		local maxKey = "MAX(level)"
		local query = MGangs.Data:Query("SELECT id, name, icon_url, " .. maxKey .. " FROM mg2_gangdata")
		query = (query[1])

		local maxVal = query[maxKey]

		if (query && maxVal) then
			query["data"] = MGangs.Util:FormatNumber(maxVal or 0)
			query[maxKey] = nil

			return query
		end

		return {}
	end,
})

MG2_RANKINGS:RegisterRankType("top_exp", {
	name = "Highest Experience",
	fetchData = function()
		local maxKey = "MAX(exp)"
		local query = MGangs.Data:Query("SELECT id, name, icon_url, " .. maxKey .. " FROM mg2_gangdata")
		query = (query[1])

		local maxVal = query[maxKey]

		if (query && maxVal) then
			query["data"] = MGangs.Util:FormatNumber(maxVal or 0)
			query[maxKey] = nil

			return query
		end

		return {}
	end,
})

MG2_RANKINGS:RegisterRankType("top_members", {
	name = "Most Members",
	fetchData = function()
		local query = MGangs.Data:Query("SELECT gangid, COUNT(*) AS magnitude FROM mg2_playerdata GROUP BY gangid ORDER BY magnitude DESC LIMIT 1")
		query = (query[1])

		local gangData = MGangs.Gang:Exists(query["gangid"])
		local totalMem = query["magnitude"]

		if (query && gangData && totalMem) then
			query["name"] = (gangData.name or "GANG NAME")
			query["icon_url"] = (gangData.icon_url or "url")
			query["data"] = MGangs.Util:FormatNumber(totalMem or 0)
			query["magnitude"] = nil

			return query
		end

		return {}
	end,
})
