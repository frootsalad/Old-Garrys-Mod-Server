--[[
MGANGS - ASSOCIATIONS LOAD
Developed by Zephruz
]]
MGangs.Module.mods.associations = {}
MG2_ASSOCIATIONS = MGangs.Module.mods.associations

MG2_ASSOCIATIONS.DefaultStatus = 1
MG2_ASSOCIATIONS.Status = {
  [1] = {
    name = "Neutral",
    icon = Material("icon16/flag_yellow.png"),
    perms = {
      startWar = false,
      killOther = true,
    },
  },
  [2] = {
    name = "Allies",
    icon = Material("icon16/flag_green.png"),
    perms = {
      startWar = false,
      killOther = true,
    },
  },
  [3] = {
    name = "Enemies",
    icon = Material("icon16/flag_red.png"),
    perms = {
      startWar = true,
      killOther = true,
    },
  },
}

if (SERVER) then
	include("server/sv_assoc_load.lua")
	AddCSLuaFile("client/cl_assoc_load.lua")
end

if (CLIENT) then
	include("client/cl_assoc_load.lua")
end

-- [[ SETUP/REGISTER MODULE ]]

function MG2_ASSOCIATIONS:GetStatus(id)
  id = (id && tonumber(id) || false)

  local status = (self.Status && (self.Status[id] or self.Status))

  for k,v in pairs(self.Status) do
    self.Status[k].id = k
  end

  return status
end

-- Register Permissions
MGangs.Gang:RegisterPermissions("Associations", "War", {
  use = function(gData, bool)
    local gid = (gData && gData.id)
		if (!gid) then return false end

    MGangs.Gang:SetWarStatus(gid, bool)
	end,
  menuOpts = {
		["War"] = function(gData, sInfo)
      local sInfo = MG2_ASSOCIATIONS:GetStatus(sInfo && sInfo.id)
      local sPerms = (sInfo && sInfo.perms)
    
      if (!sPerms or !sPerms.startWar) then return false end

			local warData = {
        {
          name = "Start",
          id = true,
        },
        {
          name = "End",
          id = false,
        },
      }

			return warData
		end,
	},
})

MGangs.Gang:RegisterPermissions("Associations", "Set Status", {
	use = function(gData, sid)
    local gid = (gData && gData.id)
		if (!gid) then return false end

    MGangs.Gang:SetAssociation(gid, sid)
	end,
	menuOpts = {
		["Set Status"] = function()
			local statData = {}
      local status = MG2_ASSOCIATIONS:GetStatus()

      for i,stat in pairs(status) do
        table.insert(statData, stat)
      end

			return statData
		end,
	},
})
