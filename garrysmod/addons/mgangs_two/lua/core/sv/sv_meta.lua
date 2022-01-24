--[[
MGANGS - SERVERSIDE META
Developed by Zephruz

- This handles a majority of the serverside data & algorithms.
- Stuff will probably get moved, deleted, and optimized; so on that note, be careful on what you mess with.
]]

--[[-------------
	Gang Meta
----------------]]
MGangs.Meta:Register({"GetAll", "GetAllGangs"}, MGangs.Gang,
function(self)
	local gangsTbl = MGangs.Data:SelectAll("mg2_gangdata")

	return (gangsTbl or {})
end)

MGangs.Meta:Register({"Exists", "GangExists"}, MGangs.Gang,
function(self, id)
	local gangData = MGangs.Data:SelectAllWhere("mg2_gangdata", "id", id)

	if (gangData && gangData[1]) then
		return gangData[1]
	end

	return false
end)

MGangs.Meta:Register({"Create", "CreateGang"}, MGangs.Gang,
function(self, ply, data)
	-- Cost data
	local costCfg = MGangs.Config.GangCost
	local costAmt = (costCfg && costCfg.cost || 1000)
	local costTypes = {
		["darkrp"] = {
			check = DarkRP,
			has = function(ply)
				return ply:canAfford(costAmt)
			end,
			buy = function(ply)
				ply:addMoney(-costAmt)
			end,
		},
	}

	if (!IsValid(ply)) then return false, MGangs.Language:GetTranslation("player_not_valid") end
	if (ply:HasGang()) then return false, MGangs.Language:GetTranslation("youre_already_ina_gang") end

	if (costCfg && costCfg.enabled) then
		local costTbl = costTypes[costCfg.type && costCfg.type:lower() || ""]

		if (costTbl && costTbl.check) then
			if (costTbl.has(ply)) then
				costTbl.buy(ply)
			else
				return false, MGangs.Language:GetTranslation("cant_afford_gang")
			end
		end
	end

	local gangInfo = {
		name = (data.name or "No Name"),
		icon_url = (data.icon_url or "base-url-goes-here"),
		level = (data.level or 1),
		exp = (data.exp or 0),
		balance = (data.balance or 0),
		leader_name = ply:Nick(),
		leader_steamid = ply:SteamID(),
	}

	local createGang = MGangs.Data:InsertInto("mg2_gangdata", gangInfo)

	if (createGang or createGang == nil) then
		local gangid = sql.Query("SELECT last_insert_rowid() AS id FROM mg2_gangdata LIMIT 1")[1].id

		-- Setup run hook - for modules to run their own setup
		hook.Run("MG2.Gang.Creation.Start", {info = gangInfo, id = gangid})

		-- Create Groups
		MGangs.Gang:ValidateGroups(gangid)

		local leaderGroup = MGangs.Gang:GetLeaderGroup(gangid)
		leaderGroup = (leaderGroup && leaderGroup.id)

		-- Update user
		if (leaderGroup) then
			ply:AddToGang(gangid, leaderGroup)

			hook.Run("MG2.Gang.Creation.End", {info = gangInfo, id = gangid})

			return gangid, MGangs.Language:GetTranslation("your_gang_created")
		else
			MGangs.Gang:Delete(gangid)	-- Delete any set data

			return false, MGangs.Language:GetTranslation("gang_create_fail_noleader")
		end
	else
		return false, MGangs.Language:GetTranslation("gang_create_fail")
	end
end)

MGangs.Meta:Register("ValidateGroups", MGangs.Gang,
function(self, gangid, data)
	for i=1,#MGangs.Gang.DefaultGroups do
		local gData = (data && data.groups && data.groups[i] && data.groups[i])
		local group = MGangs.Gang.DefaultGroups[i]
		group.name = (gData && gData.groupName or group.name)
		group.icon = (gData && gData.groupIconURL or group.icon)
		group.priority = (gData && gData.groupPriority or group.priority)
		if (group && group.perms) then
			MGangs.Gang:CreateGroup(gangid, group)
		end
	end
end)

MGangs.Meta:Register("GetLeaderGroup", MGangs.Gang,
function(self, gangid)
	local gangGroups = MGangs.Gang:GetGroups(gangid)

	if (gangGroups) then
		for i=1,#gangGroups do
			local group = gangGroups[i]
			local groupInfo = MGangs.Gang:GetGroupTypeInfo(group.grouptype)

			if (groupInfo && groupInfo.leader) then
				return group
			end
		end
	end

	return false
end)

MGangs.Meta:Register({"Delete", "DeleteGang"}, MGangs.Gang,
function(self, id)
	local gangData = MGangs.Gang:Exists(id)

	if (gangData) then
		local onlineMembers = MGangs.Gang:GetOnlineMembers(id)

		-- Delete gang
		local dGang = MGangs.Data:DeleteWhere("mg2_gangdata", "id", id)

		-- We'll only need the online members. Offline members gangs are re-checked when joining.
		-- This could possibly be a MASSIVE amount of queries so it's a transaction.
		sql.Query("BEGIN TRANSACTION")
		if (onlineMembers) then
			for k,v in pairs(onlineMembers) do
				v:RemoveFromGang()
			end
		end
		sql.Query("COMMIT")

		-- Delete groups
		local dGroups = MGangs.Data:DeleteWhere("mg2_ganggroups", "gangid", id)

		hook.Run("MG2.Gang.Deleted", id)

		return true, dGang
	end

	return false
end)

MGangs.Meta:Register({"GetMembers", "GetGangMembers"}, MGangs.Gang,
function(self, id)
	local gangMembers = MGangs.Data:SelectAllWhere("mg2_playerdata", "gangid", id)

	if (gangMembers) then
		return gangMembers
	end

	return false
end)

--[[Gang groups]]
MGangs.Meta:Register({"GetGroups", "GetGangGroups"}, MGangs.Gang,
function(self, gangid)
	local gangGroups = MGangs.Data:SelectAllWhere("mg2_ganggroups", "gangid", gangid)

	if (gangGroups) then
		for i=1,table.Count(gangGroups) do
			gangGroups[i].perms = util.JSONToTable(gangGroups[i].perms)
		end

		return gangGroups
	end

	return false
end)

MGangs.Meta:Register({"DeleteGroup", "DeleteGangGroup"}, MGangs.Gang,
function(self, gangid, id)
	local groups = MGangs.Gang:GetGroups(gangid)

	if (groups && istable(groups)) then
		for i=1,#groups do
			local group = groups[i]

			if (group && tonumber(group.gangid) == tonumber(gangid) && tonumber(group.id) == tonumber(id)) then
				local deleteGroup = MGangs.Data:DeleteWhere("mg2_ganggroups", "id", id)

				-- Update Online Members
				local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid)
				local groups = MGangs.Gang:GetGroups(gangid)

				for i=1,#onlineMembers do
					local ply = onlineMembers[i]

					if (ply && IsValid(ply)) then
						ply:SendGangGroups(groups)
					end
				end

				return (deleteGroup or deleteGroup == nil)
			end
		end
	end
end)

MGangs.Meta:Register({"CreateGroup", "CreateGangGroup"}, MGangs.Gang,
function(self, gangid, params)
	local getGang = MGangs.Data:SelectAllWhere("mg2_gangdata", "id", gangid)

	if !(params) then params = {} end

	if (getGang) then
		local createGroup = MGangs.Data:InsertInto("mg2_ganggroups", {
			gangid = gangid,
			icon = (params.icon or "icon16/award_star_bronze_1.png"),
			name = (params.name or "New Group"),
			priority = (params.priority or 1),
			grouptype = (params.grouptype or 0),
			perms = (util.TableToJSON(params.perms) or "[]"),
		})

		if (createGroup or createGroup == nil) then
			local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid)
			local groups = MGangs.Gang:GetGroups(gangid)

			for i=1,#onlineMembers do
				local ply = onlineMembers[i]

				if (ply && IsValid(ply)) then
					ply:SendGangGroups(groups)
				end
			end
		end

		return createGroup
	end

	return "No gang"
end)

MGangs.Meta:Register({"UpdateGroup", "UpdateGangGroup"}, MGangs.Gang,
function(self, id, params)
	local getGroup = MGangs.Data:SelectAllWhere("mg2_ganggroups", "id", id)
	getGroup = getGroup[1]

	if (params.id) then params.id = nil end
	if (params.gangid) then params.gangid = nil end
	if (params.grouptype) then params.grouptype = nil end

	if (getGroup) then
		local updateGroup = MGangs.Data:UpdateWhere("mg2_ganggroups", "id", id, params)

		if (updateGroup or updateGroup == nil) then
			local onlineMembers = MGangs.Gang:GetOnlineMembers(getGroup.gangid)
			local groups = MGangs.Gang:GetGroups(getGroup.gangid)

			for i=1,#onlineMembers do
				local ply = onlineMembers[i]

				if (ply && IsValid(ply)) then
					ply:SendGangGroups(groups)
				end
			end
		end
	end
end)

MGangs.Meta:Register({"UpdateGroups", "UpdateGangGroups"}, MGangs.Gang,
function(self, gangid, group)
	gangid = tonumber(gangid)
	group.gangid = tonumber(group.gangid)
	group.id = tonumber(group.id)

	local editTbl = {}
	local bannedKeys = {	-- Any banned keys
		["perms"] = true,
	}

	local gangGroups = MGangs.Gang:GetGangGroups(gangid)

	-- Validate any updates
	for k,v in pairs(gangGroups) do
		local gTypeInfo = MGangs.Gang:GetGroupTypeInfo(v.grouptype)

		if (group.gangid == gangid && group.id == tonumber(v.id)) then
			for j,d in pairs(v) do
				if (gTypeInfo.leader) then
					if (bannedKeys[j]) then
						group[j] = nil
					end
				end

				if (d != group[j]) then
					if (istable(group[j])) then
						group[j] = util.TableToJSON(group[j])
					end

					editTbl[j] = group[j]
				end
			end
		end
	end

	if (table.Count(editTbl) > 0) then
		MGangs.Gang:UpdateGroup(group.id, editTbl)
	end

	hook.Run("MG2.Gang.UpdatedGroups", gangid, groups)
end)

MGangs.Meta:Register({"SetLeader", "SetGangLeader"}, MGangs.Gang,
function(self, gangid, name, steamid)
	local affPlys = {}
	local gangMembers = MGangs.Gang:GetMembers(gangid)

	if (gangMembers) then
		local userData = MGangs.Player:HasGang(steamid)

		if (userData && tonumber(userData.gangid) == tonumber(gangid)) then
			local leaderGroup = MGangs.Gang:GetLeaderGroup(gangid)

			affPlys[steamid] = leaderGroup.id

			-- Find old leader
			for k,v in pairs(gangMembers) do
				if (v.group == leaderGroup.id) then
					MGangs.Data:UpdateWhere("mg2_playerdata", "steamid", v.steamid, {
						["group"] = userData.group,
					})

					affPlys[v.steamid] = userData.group
				end
			end

			-- Update new values
			MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, {
				["leader_name"] = name,
				["leader_steamid"] = steamid,
			})
			MGangs.Data:UpdateWhere("mg2_playerdata", "steamid", steamid, {
				["group"] = leaderGroup.id,
			})

			-- Update online members
			for k,v in pairs(MGangs.Gang:GetOnlineMembers(gangid)) do
				local updData = {
					leader = {name = (name or "NIL"), steamid = (steamid or "NIL")}
				}

				if (affPlys[v:SteamID()]) then
					updData.yourgroup = affPlys[v:SteamID()]
				end

				v:SendGangData(updData)
			end

			return true
		else
			return false
		end
	end

	return false
end)

--[[Gang Permissions]]
MGangs.Meta:Register("GetGroupPermissions", MGangs.Gang,
function(self, gangid, groupid)
	local groupPerms
	local gangGroups = MGangs.Gang:GetGroups(gangid)

	if (gangGroups) then
		for i=1,#gangGroups do
			local group = gangGroups[i]

			-- Check requested group
			if (group.id == groupid) then
				groupPerms = (group.perms or {})

				break
			end
		end

		return groupPerms
	end

	return false
end)

MGangs.Meta:Register({"SetName", "SetGangName"}, MGangs.Gang,
function(self, gangid, name)
	local gangData = self:Exists(gangid)

	if (gangData) then
		local data = {
			["name"] = (name or gangData.name or "NIL"),
		}

		MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, data)
		MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendGangData(data)
		end)
	end
end)

MGangs.Meta:Register({"SetIcon", "SetIconURL"}, MGangs.Gang,
function(self, gangid, iconurl)
	local gangData = self:Exists(gangid)

	if (gangData) then
		local data = {
			["icon_url"] = (iconurl or gangData.icon_url or "NIL"),
		}

		MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, data)
		MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendGangData(data)
		end)
	end
end)

--[[Gang Balance]]
MGangs.Meta:Register({"SetMoney", "SetBalance"}, MGangs.Gang,
function(self, gangid, amt)
	local gangData = MGangs.Gang:Exists(gangid)
	local addAmt = amt

	amt = tonumber(amt or 0)

	if (gangData) then
		local cont, msg = hook.Run("MG2.Gang.SetMoney.Pre", gangid, amt)

		if (cont != nil && !cont) then return cont, msg end

		local setMoney = MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, {
			["balance"] = amt,
		})

		if (setMoney or setMoney == nil) then
			MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendGangData({
					["balance"] = amt,
				})
			end)
		end

		hook.Run("MG2.Gang.SetMoney.Post", gangid, amt, tonumber(gangData.balance or 0))

		return true
	end

	return true
end)

--[[Gang Leveling/Exp]]
MGangs.Meta:Register({"SetLvl", "SetLevel"}, MGangs.Gang,
function(self, gangid, amt)
	local lvlSettings = MGangs.Config.LevelSettings
	local gangData = MGangs.Gang:Exists(gangid)
	local addAmt = amt

	amt = tonumber(amt or 0)

	if (gangData) then
		hook.Run("MG2.Gang.SetLvl.Pre", gangid, amt)

		if (amt >= lvlSettings.maxlevel) then
			amt = lvlSettings.maxlevel
		end

		local setLvl = MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, {
			["level"] = amt,
		})

		if (setLvl or setLvl == nil) then
			local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendGangData({
					["level"] = amt,
				})

				ply:MG_SendNotification(MGangs.Language:GetTranslation("gang_level_isnow", MGangs.Util:FormatNumber(amt or 0)))
			end)
		end

		hook.Run("MG2.Gang.SetLvl.Post", gangid, amt)
	end

	return false
end)

MGangs.Meta:Register({"SetExp", "SetExperience"}, MGangs.Gang,
function(self, gangid, amt)
	local lvlSettings = MGangs.Config.LevelSettings
	local gangData = MGangs.Gang:Exists(gangid)

	amt = tonumber(amt or 0)

	if (gangData) then
		hook.Run("MG2.Gang.SetExp.Pre", gangid, amt)

		local curExpForm = lvlSettings.xpformula(gangData.level)

		if (amt >= curExpForm) then
			local expLeft = (amt - curExpForm)

			for i=1,(lvlSettings.maxlevel) do
				local expForm = lvlSettings.xpformula(i)

				if (expForm >= amt) then
					local newLvl = i+1

					if (newLvl > amt) then
						newLvl = i
					end

					MGangs.Gang:SetLvl(gangid, newLvl)
					amt = expLeft

					break
				end
			end
		end

		-- Set exp
		local setExp = MGangs.Data:UpdateWhere("mg2_gangdata", "id", gangid, {
			["exp"] = amt,
		})

		if (setExp or setExp == nil) then
			-- Update Members
			MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendGangData({
					["exp"] = amt,
				})
			end)

			return true
		end

		hook.Run("MG2.Gang.SetExp.Post", gangid, amt)
	end

	return false
end)

--[[-------------
	Player Meta
----------------]]
local mgPlyMeta = FindMetaTable("Player")

--[[ONLINE PLAYER META]] -- Used for online players

-- Send split data (table), used for larger data payloads.
function mgPlyMeta:SendSplitData(nwstr, data, splitAt)
	local split = MGangs.Util:SplitUpTable(data, (splitAt or 5))

	if (#split >= 1) then
		for i=1,#split do
			net.Start(nwstr)
				net.WriteInt(i,32)
				net.WriteTable(split[i])
			net.Send(self)
		end
	else
		net.Start(nwstr)
			net.WriteInt(1,32)
			net.WriteTable({})
		net.Send(self)
	end
end

function mgPlyMeta:SendAllGangs(gangs)
	local split = MGangs.Util:SplitUpTable(gangs,3)

	for i=1,#split do
		net.Start("MG2.Send.Gangs")
			net.WriteInt(i,32)
			net.WriteTable(split[i])
		net.Send(self)
	end
end

function mgPlyMeta:MG_SendNotification(msg)
	net.Start("MG2.Send.Notification")
		net.WriteString(msg)
	net.Send(self)
end

function mgPlyMeta:CheckGangData()
	local userData = self:HasGang()

	if (userData) then
		local gangid = userData.gangid
		local gangData = MGangs.Gang:Exists(gangid)

		if (gangData) then
			-- Set NW'd data
			self:SetNWInt("MG2_GangID", (gangid or 0))

			-- Set gang leader & group
			gangData.leader = {name = (gangData.leader_name or "NIL"), steamid = (gangData.leader_steamid or "NIL")}
			gangData.yourgroup = (userData.group or "NIL")

			-- nil useless values
			gangData.leader_name = nil
			gangData.leader_steamid = nil

			-- Send data
			self:SendGangData((gangData or {}))

			return true, "Retrieved & sent " .. self:Nick() .. "'s gang data!"
		else
			self:RemoveFromGang()

			return true, "Removed " .. self:Nick() .. " from non-existant gang!"
		end
	else
		local invites = (MGangs.Player:GetInvites(self:SteamID()) or {})

		for i=1,#invites do
			local invite = invites[i]

			if (invite && invite.data) then
				invites[i].data = util.JSONToTable(invite.data)
			end
		end

		if (#invites > 0) then
			self:SendGangInvites(invites)
		end

		return true, self:Nick() .. " isn't in a gang."
	end
end

function mgPlyMeta:HasGang()
	local hasGang = MGangs.Data:SelectAllWhere("mg2_playerdata", "steamid", self:SteamID())

	if !(istable(hasGang)) then return false end

	if (hasGang && hasGang[1]) then
		if (!hasGang[1].gangid) then
			return false
		end

		return hasGang[1]
	else
		return false
	end
end

function mgPlyMeta:IsGangLeader()
	local playerInfo = self:HasGang()

	if !(playerInfo) then return false end

	local gangInfo = MGangs.Gang:Exists(playerInfo.gangid)

	if !(gangInfo) then return false end

	if (gangInfo.leader_steamid == self:SteamID()) then
		return true
	end

	return false
end

function mgPlyMeta:HasGangPermission(ptype, pname)
	local userData = self:HasGang()

	if !(userData) then return false end
	if (!ptype or !pname) then return false end

	local ldrGroup = MGangs.Gang:GetLeaderGroup(userData.gangid)

	if (tonumber(ldrGroup.id) == tonumber(userData.group)) then return true end

	local perms = MGangs.Gang:GetGroupPermissions(userData.gangid, userData.group)
	perms = (perms && perms[ptype] or {})

	return (table.HasValue(perms, pname) or false)
end

function mgPlyMeta:SendGangData(data)
	net.Start("MG2.Send.GangData")
		net.WriteTable(data)
	net.Send(self)

	hook.Run("MG2.Send.GangData", self)
end

function mgPlyMeta:SendGangInvites(invites)
	local split = MGangs.Util:SplitUpTable(invites,3)

	for i=1,#split do
		net.Start("MG2.Send.GangInvites")
			net.WriteInt(i,32)
			net.WriteTable(split[i])
		net.Send(self)
	end
end

function mgPlyMeta:SendGangGroups(groups)
	local split = MGangs.Util:SplitUpTable(groups,3)

	for i=1,#split do
		net.Start("MG2.Send.GangGroups")
			net.WriteInt(i,32)
			net.WriteTable(split[i])
		net.Send(self)
	end
end

function mgPlyMeta:SendGangMembers(members)
	local split = MGangs.Util:SplitUpTable(members,5)

	for i=1,#split do
		net.Start("MG2.Send.GangMembers")
			net.WriteInt(i,32)
			net.WriteTable(split[i])
		net.Send(self)
	end
end

function mgPlyMeta:SendRemovedGangMember(mstid)
	net.Start("MG2.Send.RemovedGangMember")
		net.WriteString(mstid)
	net.Send(self)
end

function mgPlyMeta:SendNewGangMember(member)
	net.Start("MG2.Send.NewGangMember")
		net.WriteTable(member)
	net.Send(self)
end

function mgPlyMeta:ClearGangData(cltbl)
	net.Start("MG2.Gang.ClearData")
	net.Send(self)
end

function mgPlyMeta:InviteToGang(invitor, gangid)
	if !(IsValid(self)) then return false, MGangs.Language:GetTranslation("player_not_valid") end
	if (self:HasGang()) then return false, MGangs.Language:GetTranslation("player_ina_gang") end

	local gangData = MGangs.Gang:Exists(gangid)

	if (gangData) then
		local cont = true
		local invites = (MGangs.Player:GetGangInvites(self:SteamID()) or {})
		local cont, msg = hook.Run("MG2.Player.InviteToGang", self, invitor, gangid)

		for i=1,#invites do
			if (tonumber(invites[i].gangid) == tonumber(gangid)) then
				cont = false
				msg = MGangs.Language:GetTranslation("already_invited_player", self:Nick())
			end
		end

		if (!cont && cont != nil) then return false, (msg or nil) end

		local insertInvite = MGangs.Data:InsertInto("mg2_playerinvites", {
			["gangid"] = gangid,
			["steamid"] = self:SteamID(),
			["data"] = util.TableToJSON({
				gang_icon = gangData.icon_url,
				gang_name = gangData.name,
				inv_name = invitor:Nick(),
				inv_stid = invitor:SteamID(),
			}),
		})

		if (insertInvite or insertInvite == nil) then
			local invites = (MGangs.Player:GetGangInvites(self:SteamID()) or {})

			for i=1,#invites do
				local invite = invites[i]

				if (invite && invite.data) then
					invites[i].data = util.JSONToTable(invite.data)
				end
			end

			self:SendGangInvites(invites)
			self:MG_SendNotification(MGangs.Language:GetTranslation("you_invited_to_thegang", gangData.name or "NIL"))

			return true, MGangs.Language:GetTranslation("invited_player", self:Nick())
		else
			return false, MGangs.Language:GetTranslation("invite_fail")
		end
	end
end

function mgPlyMeta:RespondToInvite(id, bool)
	if (self:HasGang()) then return false end

	local cont
	local invites = (MGangs.Player:GetGangInvites(self:SteamID()) or {})

	for i=1,#invites do
		local invite = invites[i]
		invite.data = util.JSONToTable(invite.data)

		if (invite && tonumber(invite.id) == tonumber(id) && invite.steamid == self:SteamID()) then
			if (bool) then
				self:AddToGang(invite.gangid)
			end

			table.remove(invites, i)
			break
		end
	end

	local dInv = MGangs.Data:DeleteWhere("mg2_playerinvites", "id", id)

	if (dInv or dInv == nil) then
		if (#invites <= 0) then
			self:SendGangData({
				["invites"] = {},
			})
		else
			self:SendGangInvites(invites)
		end
	end
end

function mgPlyMeta:AddToGang(gangid, setgroup)
	local gangData = MGangs.Gang:Exists(gangid)

	if (tonumber(self:GetGangID()) == tonumber(gangid)) then return false end	-- Don't add them to the gang they're already in.

	if (gangData) then
		local cont, msg = hook.Run("MG2.Player.AddToGang", self, gangid)

		if (!cont && cont != nil) then
			self:MG_SendNotification(msg or MGangs.Language:GetTranslation("you_cant_join_gang"))

			return false
		end

		local group
		local gangGroups = MGangs.Gang:GetGroups(gangid)

		if (!setgroup) then
			for i=1,#gangGroups do
				local ginfo = gangGroups[i]
				local gtype = MGangs.Gang.GroupTypes[tonumber(ginfo.grouptype)]
				if (gtype && gtype.start) then
					group = ginfo.id
				end
			end
		else
			group = setgroup
		end

		if !(group) then return false end

		local userInfo = {
			name = self:Nick(),
			steamid = self:SteamID(),
			gangid = gangid,
			group = group,
		}

		local addUser = MGangs.Data:InsertInto("mg2_playerdata", userInfo)

		if (addUser != false) then
			-- Send the online gang members the new member
			local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid,
			function(ply)
				ply:SendNewGangMember(userInfo)
			end)

			self:CheckGangData() -- Send the new member their data

			hook.Run("MG2.Player.AddedToGang", self, userInfo)

			return true
		else
			return false
		end
	else
		return false
	end
end

function mgPlyMeta:RemoveFromGang()
	local delete = MGangs.Data:DeleteWhere("mg2_playerdata", "steamid", self:SteamID())
	local gangid = self:GetGangID()
	local gangData = MGangs.Gang:Exists(gangid)

	self:SetNWInt("MG2_GangID", 0) -- Set their gang id to 0
	self:ClearGangData() -- Clear out their gang data
	self:ActivateGangMenu(false) -- Close menu

	if (gangData) then
		local gangMembers = MGangs.Gang:GetMembers(gangid)

		-- Set the gang leader or delete the gang
		if (gangMembers && table.Count(gangMembers) >= 1) then
			if (self:SteamID() == gangData.leader_steamid) then
				MGangs.Gang:SetLeader(gangid, gangMembers[1].name, gangMembers[1].steamid)
			end
		else
			MGangs.Gang:Delete(gangid)
		end

		-- Send the online gang members the removed member
		local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendRemovedGangMember(self:SteamID())
		end)

		hook.Run("MG2.Player.RemovedFromGang", self)
	else
		return false
	end

	return delete
end

function mgPlyMeta:SetAsLeader()
	local setLeader = MGangs.Gang:SetLeader(self:GetGangID(), self:Nick(), self:SteamID())

	return setLeader
end

function mgPlyMeta:ActivateGangMenu(bool)
	net.Start("MG2.Gang.ActivateMenu")
		net.WriteBool(bool)
	net.Send(self)
end

function mgPlyMeta:ActiveGangAdminMenu(bool)
	local isAdmin = (MGangs.Config.AdminGroups[self:GetUserGroup()] or false)

  if !(isAdmin) then return false end

	net.Start("MG2.Admin.ActivateMenu")
		net.WriteBool(bool)
	net.Send(self)
end

--[[STEAMID-REQUEST BASED PLAYER META]] -- Used for offline players or by utilizing a SteamID
MGangs.Meta:Register("GetAll", MGangs.Player,
function(self)
	local getUsers = MGangs.Data:SelectAll("mg2_playerdata")

	return (getUsers or {})
end)

MGangs.Meta:Register("AddToGang", MGangs.Player,
function(self, nick, steamid, gangid, group)
	local userInfo = {
		name = nick,
		steamid = steamid,
		gangid = gangid,
		group = group,
	}

	local addUser = MGangs.Data:InsertInto("mg2_playerdata", userInfo)

	if (addUser) then
		-- Send the online gang members the new member
		local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid,
		function(ply)
			ply:SendNewGangMember(userInfo)
		end)

		hook.Run("MG2.OfflinePlayer.AddedToGang", steamid, userInfo)

		return true
	else
		return false
	end
end)

MGangs.Meta:Register("RemoveFromGang", MGangs.Player,
function(self, steamid)
	local userData = MGangs.Player:HasGang(steamid)

	if (userData) then
		local gangid = userData.gangid
		local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid)

		for i=1,#onlineMembers do
			local ply = onlineMembers[i]

			if (ply && ply:SteamID() == steamid) then
				return ply:RemoveFromGang()
			end
		end

		local delete = MGangs.Data:DeleteWhere("mg2_playerdata", "steamid", steamid)
		local gangData = MGangs.Gang:Exists(gangid)

		-- Set the gang leader or delete the gang
		if (gangData) then
			local gangMembers = MGangs.Gang:GetMembers(gangid)
			local leaderGroup = MGangs.Gang:GetLeaderGroup(gangid)

			if (gangMembers && table.Count(gangMembers) >= 1) then
				if (leaderGroup.id == userData.group) then
					MGangs.Gang:SetLeader(gangid, gangMembers[1].name, gangMembers[1].steamid)
				end

				-- Send the online gang members the removed member
				for i=1,#onlineMembers do
					local ply = onlineMembers[i]

					ply:SendRemovedGangMember(steamid)
				end
			else
				MGangs.Gang:Delete(gangid)
			end
		end

		hook.Run("MG2.OfflinePlayer.RemovedFromGang", steamid)
	end

	return delete
end)

MGangs.Meta:Register("HasGang", MGangs.Player,
function(self, steamid)
	local hasGang = MGangs.Data:SelectAllWhere("mg2_playerdata", "steamid", steamid)

	if (hasGang && hasGang[1]) then
		if (!hasGang[1].gangid) then
			return false
		end

		return hasGang[1]
	else
		return false
	end
end)

MGangs.Meta:Register({"GetInvites", "GetGangInvites"}, MGangs.Player,
function(self, stid)
	local invites = MGangs.Data:SelectAllWhere("mg2_playerinvites", "steamid", stid)

	if (invites) then
		return invites
	else
		return false
	end
end)

MGangs.Meta:Register({"SetGroup", "SetGangGroup"}, MGangs.Player,
function(self, gangid, stid, groupid)
	local groups = MGangs.Gang:GetGroups(gangid)
	local members = MGangs.Gang:GetMembers(gangid)

	if (groups && members) then
		local group

		for i=1,#groups do
			if (tonumber(groups[i].id) == groupid) then
				group = groups[i]

				break
			end
		end

		if (group) then
			local grpInfo = MGangs.Gang:GetGroupTypeInfo(group.grouptype)

			if (grpInfo) then
				for i=1,#members do
					local member = members[i]

					if (member && member.steamid == stid && tonumber(member.group) != groupid) then
						if (grpInfo.leader) then
							MGangs.Gang:SetLeader(member.gangid, member.name, member.steamid)
						else
							MGangs.Data:UpdateWhere("mg2_playerdata", "steamid", stid, {
									["group"] = tonumber(groupid),
							})
						end

						break
					end
				end
			end
		end

		local onlineMembers = MGangs.Gang:GetOnlineMembers(gangid)
		local groups = MGangs.Gang:GetGroups(gangid)

		for i=1,#onlineMembers do
			local ply = onlineMembers[i]

			if (ply && IsValid(ply)) then
				ply:SendGangGroups(groups)
			end
		end
	end

	hook.Run("MG2.Gang.SetGroup", stid, groupid)
end)
