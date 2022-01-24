--[[
MGANGS - SHARED PERMISSIONS
Developed by Zephruz
]]

--[[--------------
	Permissions
-----------------]]
MGangs.Gang.GroupPermissions = (MGangs.Gang.GroupPermissions or {})
MGangs.Gang.GroupPermissionData = (MGangs.Gang.GroupPermissionData or {})

MGangs.Meta:Register("RegisterPermissions", MGangs.Gang,
function(self, category, name, data)
	if !(MGangs.Gang.GroupPermissions[category]) then MGangs.Gang.GroupPermissions[category] = {} end
	if !(MGangs.Gang.GroupPermissionData[category]) then MGangs.Gang.GroupPermissionData[category] = {} end

	for k,v in pairs(MGangs.Gang.GroupPermissions[category]) do
		if (v == name) then
			table.remove(MGangs.Gang.GroupPermissions[category], k)
		end
	end

	table.insert(MGangs.Gang.GroupPermissions[category], name)
	MGangs.Gang.GroupPermissionData[category][name] = {
		data = (data && data.data || {
			icon = "icon16/star.png",
		}),
		use = (data && data.use || false),
		menuOpts = (data && data.menuOpts || false)
	}
end)

MGangs.Meta:Register("GetPermissionInfo", MGangs.Gang,
function(self, category, name)
	if !(MGangs.Gang.GroupPermissionData[category]) then return false end
	if !(MGangs.Gang.GroupPermissionData[category][name]) then return false end

	return MGangs.Gang.GroupPermissionData[category][name]
end)

--[[Default Permissions]]
-- Gang
MGangs.Gang:RegisterPermissions("Gang", "Delete")
MGangs.Gang:RegisterPermissions("Gang", "Edit")

-- Balance
MGangs.Gang:RegisterPermissions("Balance", "Withdraw")
MGangs.Gang:RegisterPermissions("Balance", "Deposit")
MGangs.Gang:RegisterPermissions("Balance", "Spend")

-- Groups
MGangs.Gang:RegisterPermissions("Group", "Delete")
MGangs.Gang:RegisterPermissions("Group", "Create")
MGangs.Gang:RegisterPermissions("Group", "Edit")

-- User/Non-Member
MGangs.Gang:RegisterPermissions("User", "Invite")

-- Members
MGangs.Gang:RegisterPermissions("Member", "Kick", {
	use = function(parent, stid)
		MGangs.Player:Kick(stid)

		parent:Remove()
	end,
})
MGangs.Gang:RegisterPermissions("Member", "Set Group", {
	use = function(parent, stid, gData)
		if (!gData or !gData.id) then return false end

		MGangs.Player:SetGroup(stid, gData.id)
	end,
	menuOpts = {
		["Set Group"] = function()
			local grpData = {}
			local groups = MGangs.Gang:GetGroups()

			for i=1,#groups do
				local group = groups[i]

				grpData[i] = {
					id = group.id,
					name = group.name
				}
			end

			return grpData
		end,
	},
})
