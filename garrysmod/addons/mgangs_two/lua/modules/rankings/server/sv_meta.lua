--[[
MGANGS - RANKINGS SERVERSIDE META
Developed by Zephruz
]]

-- LoadRankData - Loads a specific rankings data (retreives and caches or fetches it from the cache).
function MG2_RANKINGS:LoadRankData(name)
	local rType = self:GetRankType(name)
	local cached = self:AccessCache(name)

	if (!rType or !rType.fetchData) then return false end
	if (cached) then
		local expireAt = (cached.upd_time + self.cacheExpireTime)

		if (expireAt <= CurTime()) then
			self:ReleaseFromCache(name)	-- Delete it because it's a little old.
		else
			return cached	-- Not run a pointless SQL statement when we have this...
		end
	end

	local data = rType.fetchData()
	data["upd_time"] = CurTime()

	self.rankCache[name] = data

	return data
end

-- LoadAllRanks - Loads all ranks data (retreives and caches or fetches it from the cache)
function MG2_RANKINGS:LoadAllRanks()
	local rTypes = self.rankTypes

	for k,v in pairs(rTypes) do
		self:LoadRankData(k)
	end

	return self.rankCache
end

--[[Player Meta]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:SendGangRankings(rankings)
	local split = MGangs.Util:SplitUpTable(rankings,5)

	for i=1,#split do
		net.Start("MG2.Send.GangRankings")
			net.WriteInt(i,32)
			net.WriteTable(split[i])
		net.Send(self)
	end
end
