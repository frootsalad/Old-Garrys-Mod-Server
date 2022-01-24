--[[
MGANGS - SHARED GLOBALS
Developed by Zephruz
]]

-- Don't modify anything in this file.
-- I won't help you fix it if you do and mess up.

-- [[ADMIN GLOBALS]]
MGangs.Gang.AdminMenuOptions = {}

-- [[End Points/Request Receivers]]
netPoint:CreateEndPoint("MG2.SearchGangs", {
	searchFor = function(ply, val)
		if (#val < 1) then return false end

		val = sql.SQLStr(val)

		return (sql.Query([[SELECT * FROM `mg2_gangdata`
			WHERE instr(id, ]] .. val .. [[)>0
			OR instr(name, ]] .. val .. [[)>0
			OR instr(leader_name, ]] .. val .. [[)>0
			OR instr(leader_steamid, ]] .. val .. [[)>0
			]]))
	end,
})

-- [[Gang Edit Options]]
-- COPY GANG ID
MGangs.Gang:CreateAdminOption({
  name = "copygangid",
  type = "gang",
}, {
  name = MGangs.Language:GetTranslation("copy_gang_id"),
  icon = false,
  DoClick = function(data)
    local gangInfo = (data.gangInfo or {})

    if (gangInfo.id) then
      SetClipboardText(gangInfo.id)

      MGangs:Notification(MGangs.Language:GetTranslation("copied_gang_id"))
    end
  end,
})

-- DELETE
MGangs.Gang:CreateAdminOption({
  name = "delete",
  type = "gang",
}, {
  name = MGangs.Language:GetTranslation("delete"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    question = MGangs.Language:GetTranslation("delete_this_gang_pmt"),
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable({
          ["delete"] = true,
        })
      net.SendToServer()
    end,
  },
  update = function(gangid, data)
    if (data.delete) then
      MGangs.Gang:Delete(gangid)

      return true, MGangs.Language:GetTranslation("gang_deleted")
    end

    return false, MGangs.Language:GetTranslation("gang_not_deleted")
  end,
})

-- SET Category
MGangs.Gang:CreateAdminOption({
  name = "name",
  type = "gang",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("name"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("gang_name"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_name"))
      entry:SetCharFilter(MGangs.Config.BannedNames, MGangs.Language:GetTranslation("name_not_allowed"))
      entry:SetMinMaxChars(3,15)

      return entry.dtextentry
    end,
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  update = function(gangid, data) -- This function is only ran serverside
    local name = (data.name)

    if !(name) then return false, MGangs.Language:GetTranslation("gang_name_not_set_invalid") end

    MGangs.Gang:SetName(gangid, name)

    return true, MGangs.Language:GetTranslation("gang_name_set", name)
  end,
})

-- ICON URL
MGangs.Gang:CreateAdminOption({
  name = "icon_url",
  type = "gang",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("icon_url"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("gang_icon_url"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_icon_url"))
      entry:SetCharMatch(MGangs.Config.AllowedImageExts, MGangs.Language:GetTranslation("invalid_icon_url"))
      entry:SetMinMaxChars(4,300)

      return entry.dtextentry
    end,
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  update = function(gangid, data)
    local iconurl = (data.icon_url)

    if !(iconurl) then return false, MGangs.Language:GetTranslation("gang_invalid_icon_url") end

    MGangs.Gang:SetIconURL(gangid, iconurl)

    return true, MGangs.Language:GetTranslation("gang_icon_url_set", iconurl)
  end,
})

-- EXP
MGangs.Gang:CreateAdminOption({
  name = "exp",
  type = "gang",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("exp"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("set_exp"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_exp"))
      entry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
      entry:SetNumeric(true)

      return entry.dtextentry
    end,
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  update = function(gangid, data)
    local exp = (data.exp)

    if !(exp) then return false, MGangs.Language:GetTranslation("gang_invalid_exp") end

    MGangs.Gang:SetExp(gangid, exp)

    return true, MGangs.Language:GetTranslation("gang_exp_set", exp)
  end,
})

-- LEVEL
MGangs.Gang:CreateAdminOption({
  name = "level",
  type = "gang",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("level"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("set_level"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_level"))
      entry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
      entry:SetNumeric(true)

      return entry.dtextentry
    end,
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  update = function(gangid, data)
    local lvl = (data.level)

    if !(lvl) then return false, MGangs.Language:GetTranslation("gang_invalid_level") end

    MGangs.Gang:SetLevel(gangid, lvl)

    return true, MGangs.Language:GetTranslation("gang_level_set", lvl)
  end,
})

-- BALANCE
MGangs.Gang:CreateAdminOption({
  name = "balance",
  type = "gang",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("balance"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("set_balance"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_balance"))
      entry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
      entry:SetNumeric(true)

      return entry.dtextentry
    end,
    onYes = function(data)
      local gangInfo = (data.gangInfo)
      local vals = (data["_values"] or nil)

      if !(vals) then return false end

      net.Start("MG2.Admin.UpdateGang")
        net.WriteInt(gangInfo.id,32)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  update = function(gangid, data)
    local bal = (data.balance)

    if !(bal) then return false, MGangs.Language:GetTranslation("gang_invalid_balance") end

    MGangs.Gang:SetBalance(gangid, bal)

    return true, MGangs.Language:GetTranslation("gang_balance_set", bal)
  end,
})


-- [[Player Edit Options]]
-- kick player
MGangs.Gang:CreateAdminOption({
  name = "kick",
  type = "player",
}, {
  name = MGangs.Language:GetTranslation("kick_from_gang"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    question = MGangs.Language:GetTranslation("kick_from_gang_pmt"),
    onYes = function(data)
      local ply = data.ply
      local vals = (data["_values"] or nil)

      if !(IsValid(ply)) then return false end

      net.Start("MG2.Admin.UpdatePlayer")
        net.WriteEntity(ply)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  canDo = function(ply)
    return (ply:GetGangID() != 0)
  end,
  update = function(ply)
    local kick = ply:RemoveFromGang()

    if (kick or kick == nil) then
      return true, MGangs.Language:GetTranslation("kicked_from_gang", (ply:Nick() or "NIL"))
    end

    return false, MGangs.Language:GetTranslation("not_kicked_from_gang", (ply:Nick() or "NIL"))
  end,
})


-- set player as leader
MGangs.Gang:CreateAdminOption({
  name = "setasleader",
  type = "player",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("as_leader"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    question = MGangs.Language:GetTranslation("set_as_leader_pmt"),
    onYes = function(data)
      local ply = data.ply
      local vals = (data["_values"] or nil)

      if !(IsValid(ply)) then return false end

      net.Start("MG2.Admin.UpdatePlayer")
        net.WriteEntity(ply)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  canDo = function(ply)
    return (ply:GetGangID() != 0)
  end,
  update = function(ply)
    local setLeader = ply:SetAsLeader()

    if (setLeader or setLeader == nil) then
      return true, MGangs.Language:GetTranslation("set_as_leader", (ply:Nick() or "NIL"))
    end

    return false, MGangs.Language:GetTranslation("not_set_as_leader", (ply:Nick() or "NIL"))
  end,
})

-- set players gang
MGangs.Gang:CreateAdminOption({
  name = "setgang",
  type = "player",
  category = MGangs.Language:GetTranslation("set"),
}, {
  name = MGangs.Language:GetTranslation("gang"),
  icon = false,
  prompt = {
    pSize = {w = 300},
    pText = {MGangs.Language:GetTranslation("submit"),MGangs.Language:GetTranslation("cancel")},
    elements = function(parent)
      local entry = vgui.Create("MG2_InfoTextEntry", parent)
      entry:Dock(TOP)
      entry:DockMargin(0,0,0,0)
      entry:SetInfoText(MGangs.Language:GetTranslation("set_gang"))
      entry:SetPlaceholderText(MGangs.Language:GetTranslation("enter_gang_id"))
      entry:SetCharFilter({"[^%d_]"}, MGangs.Language:GetTranslation("mustbe_number"))
      entry:SetNumeric(true)

      return entry.dtextentry
    end,
    onYes = function(data)
      local ply = data.ply
      local vals = (data["_values"] or nil)

      if !(IsValid(ply)) then return false end

      net.Start("MG2.Admin.UpdatePlayer")
        net.WriteEntity(ply)
        net.WriteTable(vals)
      net.SendToServer()
    end,
  },
  canDo = function(ply)
    return (ply:GetGangID() == 0)
  end,
  update = function(ply, data)
    local setGang = ply:AddToGang(data.setgang)

    if (setGang or setGang == nil) then
      return true, MGangs.Language:GetTranslation("player_added_to_gang", (ply:Nick() or "NIL"), (data.setgang or 0))
    end

    return false, MGangs.Language:GetTranslation("player_not_added_to_gang", (ply:Nick() or "NIL"))
  end,
})

-- [[CURRENCY GLOBALS]]
MGangs.Gang.Currencies = {
  ["darkrp_cash"] = {
    withdraw = function(ply, amt)
      local cash = (ply:getDarkRPVar("money") or 0)

      ply:addMoney(amt)

      return (DarkRP)
    end,
    deposit = function(ply, amt)
      local cont = ply:canAfford(amt)

      if (cont) then
        ply:addMoney(-amt)
      end

      return (DarkRP && cont)
    end
  },
}

-- [[GROUP GLOBALS]]
MGangs.Gang.GroupTypes = {
	[0] = {candelete = true},
	[1] = {start = true, candelete = false},
	[2] = {leader = true, candelete = false},
}

MGangs.Gang.DefaultGroups = {
	{
		name = 'Leader',
		icon = "icon16/award_star_gold_3.png",
		priority = 10,
		grouptype = 2,
		perms = MGangs.Gang.GroupPermissions,
	},
	{
		name = 'Recruit',
		icon = "icon16/award_star_bronze_1.png",
		priority = 0,
		grouptype = 1,
		perms = {},
	},
}
