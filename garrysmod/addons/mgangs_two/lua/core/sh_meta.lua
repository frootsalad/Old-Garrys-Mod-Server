--[[
MGANGS - SHARED META
Developed by Zephruz
]]

--[[-------------
	Meta
---------------]]
function MGangs.Meta:Register(mn, mt, mf)
	local function setMeta(mn, mt, mf)
		if (isfunction(self[mn])) then
			local oldMeta = self[mn]

			self[mn] = {
				oldMeta,
				mf,
			}
		elseif (istable(self[mn])) then
			table.insert(self[mn], mf)
		else
			self[mn] = mf
		end

		if (mt && istable(mt)) then
			mt[mn] = mf
		end
	end

	if (istable(mn)) then
		for i=1,#mn do
			setMeta(mn[i], mt, mf)
		end
	else
		setMeta(mn, mt, mf)
	end
end

--[[-------------
	Gang Meta
---------------]]
MGangs.Meta:Register({"CreateAdminOption", "CreateAdminMenuOption"}, MGangs.Gang,
function(self, optInfo, optData)
  local adminOpts = self.AdminMenuOptions
  local optType = optInfo.type
  local optName = optInfo.name
  local catName = optInfo.category

  if (!optType or !optName) then return false end
  if (!adminOpts or !adminOpts[optType]) then adminOpts[optType] = {} end

  adminOpts = adminOpts[optType]

  if (catName) then
    if !(adminOpts[catName]) then adminOpts[catName] = {} end
    adminOpts = adminOpts[catName]
		adminOpts.category = true
  end

  if (optName) then
    adminOpts[optName] = optData
  end

  return adminOpts
end)

MGangs.Meta:Register("GetGroupTypeInfo", MGangs.Gang,
function(self, id)
	id = (tonumber(id) or false)

	if !(id) then return false end

	if (MGangs.Gang.GroupTypes[id]) then
		return MGangs.Gang.GroupTypes[id]
	end
end)

MGangs.Meta:Register({"GetOnlineMembers", "GetGangOnlineMembers"}, MGangs.Gang,
function(self, id, func)
	local gangMems = {}

	for k,v in pairs(player.GetAll()) do
		if (tonumber(v:GetGangID()) == tonumber(id)) then
			table.insert(gangMems, v)

			if (func) then
				func(v)
			end
		end
	end

	return gangMems
end)

--[[-------------
	Player Meta
---------------]]
local mgPlyMeta = FindMetaTable("Player")

function mgPlyMeta:GetGangID()
	return tonumber(self:GetNWInt("MG2_GangID", 0))
end

--[[-------------
	Misc. Meta
	- (All) Most likely will be moved when a spot's found for it.
---------------]]

-- NONE
