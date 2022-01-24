--[[
MGANGS - CLIENTSIDE MENU - ADMIN
Developed by Zephruz
]]

local MENU = {}
MENU.chatCmds = {
  "gangadmin",
  "mgadmin",
}

net.Receive("MG2.Admin.ActivateMenu",
function(len)
	local open = (net.ReadBool() or false)

	if !(open) then
		if (MENU.menuframe && IsValid(MENU.menuframe)) then
			MENU.menuframe:Remove()
		end
	else
		MENU:Init()
	end
end)

function MENU:Init()
  local isAdmin = (MGangs.Config.AdminGroups[LocalPlayer():GetUserGroup()] or false)

  if !(isAdmin) then return false end
	if (IsValid(self.menuframe)) then self.menuframe:Remove() end

	-- [[Derma]]
  local mfW, mfH = 650, 400

	self.menuframe = vgui.Create("DFrame")
	self.menuframe:SetSize(mfW,mfH)
	self.menuframe:Center()
	self.menuframe:MakePopup()
	self.menuframe:ShowCloseButton(false)
	MGangs.Derma.Paint.Elements['frame'](self.menuframe, "")
	self.menuframe.active = {button = nil, pg = nil}

	self.menuclose = vgui.Create("DButton", self.menuframe)
	self.menuclose:SetSize(20,24)
	self.menuclose:SetPos(self.menuframe:GetWide() - 20,0)
	self.menuclose.DoClick = function(self)
		self:GetParent():Remove()
	end
	MGangs.Derma.Paint.Elements['closebutton'](self.menuclose, "X")

  --[[Admin Buttons]]
  self:CreateAdminButtons()
end

function MENU:SetCurrentMenu(navBtn, menu)
  if (IsValid(self.menuframe.active.button)) then self.menuframe.active.button:SetDisabled(false) end
  if (IsValid(self.menuframe.active.pg)) then self.menuframe.active.pg:Remove() end

	local curNavBtn = navBtn
  local curPage = (curNavBtn && curNavBtn.Page && curNavBtn:Page(self.menuframe) or menu && menu(self.menuframe) or false)

	self.menuframe.active.pg = curPage

  if (curNavBtn) then
    self.menuframe.active.button = curNavBtn
    self.menuframe.active.button:SetDisabled(true)
  end
end

--[[
	LOAD ADMIN MENUS
	- Called to retreive any menus that are externally added.
]]
function MENU:LoadAdminMenus()
  for _,mb in pairs(MGangs.Derma.AdminButtons) do
		mb(self)
	end
end

function MENU:CreateAdminButtons()
  --[[Menu Buttons]]
  self.menuadminbtns = vgui.Create("DScrollPanel", self.menuframe)
  self.menuadminbtns:Dock(FILL)
  MGangs.Derma.Paint.Elements['scrollpanel'](self.menuadminbtns, {
    custPaint = function(s,w,h)
      draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
    end,
  })

  --[[Header]]
  local hdr = vgui.Create("DPanel", self.menuadminbtns)
  hdr:Dock(TOP)
  hdr:DockMargin(0,0,0,0)
  MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("admin"), rc_tl = true, rc_tr = true})

  self:SetCurrentMenu(false, function(parent)
    return self.menuadminbtns
  end)

  -- Menu Buttons
  self:EditPlayersMenu()  -- Load Player Edit Menu
  self:EditGangsMenu()    -- Load Gang Edit Menu
  self:LoadAdminMenus()   -- Load Admin Menus
end

--[[Edit Players]]
local function getAllPlayers()  -- Made this function so the table is searchable (for the MG2_PagedScrollPanel derma)
  local players = player.GetAll()

  for i=1,#players do
    local ply = players[i]

    if (IsValid(ply)) then
      players[i] = {
        name = (ply:Nick() or "NIL"),
        steamid = (ply:SteamID() or "NIL"),
        gangid = (ply:GetGangID() or 0),
        pEnt = ply,
      }
    end
  end

  return players
end

local function newAdminOptionPrompt(optBtn, optData, passData)
  local optNm = (optData._name)
  local optType = (optData._type)
  local optSubType = (optData._subtype)

  local optCat = MGangs.Gang.AdminMenuOptions[optType]

  if (optSubType) then
    optType = (optCat && optCat[optSubType])
  end
  optType = (optCat && optCat[optNm] or optType && optType[optNm])

  if (optType) then
    local promptData = optType.prompt

    if !(promptData) then return false end

    local vals
    local valPass = true
    local pText = (promptData.pText)
    local pSize = (promptData.pSize)
    local pNo,pYes = (pText && pText[1] || MGangs.Language:GetTranslation("submit")), (pText && pText[2] || MGangs.Language:GetTranslation("cancel"))
    local pW, pH = (pSize && pSize.w or 200), (pSize && pSize.h or 100)

    local prompt = vgui.Create("MG2_PromptBox")
    prompt:SetQuestionText(promptData.question or "")
    prompt:SetButtonTexts(pNo,pYes)
    prompt:SetSize(pW,pH)
    prompt:Setup()

    if (promptData.elements) then
      valEle = promptData.elements(prompt)
    end

    prompt:SetOptions(
    function()
        if (promptData.elements && valEle && !valEle.ValuesPass) then
          MGangs:Notification(MGangs.Language:GetTranslation("fix_errors_please"))

          return false
        end

        if (promptData.onYes) then
          passData["_values"] = {}

          if (optSubType) then
            passData["_values"][optSubType] = {}
            passData["_values"][optSubType][optNm] = (!IsValid(valEle) || valEle:GetText())
          else
            passData["_values"][optNm] = (!IsValid(valEle) || valEle:GetText())
          end

          promptData.onYes(passData)
        end

        prompt:Remove()

        return true
    end, (promptData.onNo or nil))
  end
end

local function loadOptions(optCat,params)
  local adminOpts = MGangs.Gang.AdminMenuOptions[optCat]

  if !(adminOpts) then return false end

  local function createOption(optMenu,optData,params)
    local k,v = (optData[1]), (optData[2])
    local canDo = true

    if (!optMenu or !k or !v) then return false end

    local subMenu = optData["_subtype"]

    if (v.canDo) then
      canDo = v.canDo(params && (params.DoClickData or params.PromptData or {}))
    end

    if (canDo) then
      local opt = optMenu:AddOption(v.name)
      opt.DoClick = function(s)
        if (v.DoClick) then
          v.DoClick(params && params.DoClickData or {})
        elseif (v.prompt) then
          v["_name"] = k
          v["_type"] = optCat
          v["_subtype"] = subMenu

          newAdminOptionPrompt(s,v,(params && params.PromptData or {}))
        end
      end
    end
  end

  local optMenu = DermaMenu()

  for k,v in pairs(adminOpts) do
    if (v.category) then
      local subOptMenu = optMenu:AddSubMenu(k)

      for i,d in pairs(v) do
        if !(isbool(d)) then
          createOption(subOptMenu, {
            ["_subtype"] = k,
            i,
            d,
          }, params)
        end
      end
    else
      createOption(optMenu, {k, v}, params)
    end
  end

  optMenu:Open()
end

function MENU:EditPlayersMenu()
  self.mnav_EditPlayers = vgui.Create("DButton", self.menuadminbtns)
	self.mnav_EditPlayers:Dock(TOP)
	self.mnav_EditPlayers:DockMargin(5,5,5,0)
	self.mnav_EditPlayers:SetTall(35)
	self.mnav_EditPlayers.DoClick = function(slf)
		self:SetCurrentMenu(false, function(parent)
      local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:DockMargin(0,0,0,0)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
			end

      --[[Header]]
      local hdr = vgui.Create("DPanel", pnl)
      hdr:Dock(TOP)
      hdr:DockMargin(0,0,0,0)
      MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("edit_players"), rc_tl = true, rc_tr = true})

      local backBtn = vgui.Create("DButton", hdr)
    	backBtn:Dock(RIGHT)
    	backBtn:SetWide(100)
    	MGangs.Derma.Paint.Elements['button'](backBtn, {text = MGangs.Language:GetTranslation("back_to_admin"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
    	backBtn.DoClick = function(slf)
    		self:CreateAdminButtons()

    		pnl:Remove()
    	end

      --[[Players Panel]]
      local plyListPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
			plyListPnl:Dock(FILL)
			plyListPnl:SetMaxPageResults(6)
			plyListPnl.Paint = function(s,w,h) end

			--[[Load Players]]
			plyListPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_players"), placeholder = MGangs.Language:GetTranslation("search_players_pholder")})
			plyListPnl.PageItemSetup = function(s, page, ply)
        local plyData = ply
        local ply = (ply.pEnt)
        local gangs = MGangs.Gang:GetAll()

        if (IsValid(ply)) then
          local gangInfo
          local hasGang = (ply:GetGangID() != 0)

          if (hasGang) then
            for i=1,#gangs do
              local gang = gangs[i]

              if (tonumber(gang.id) == tonumber(ply:GetGangID())) then
                gangInfo = gang
              end
            end
          end

  				local plyPnl = vgui.Create("DPanel")
  				plyPnl:Dock(TOP)
  				plyPnl:DockMargin(5,5,5,0)
  				plyPnl:SetTall(40)
  				plyPnl.Paint = function(s,w,h)
  					draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

            local x, y = 45, 3

  					-- Name
  					draw.SimpleText( ply:Nick(), "MG_GangInfo_SM", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

            -- SteamID
            draw.SimpleText( ply:SteamID(), "MG_GangInfo_XSM", x, h - y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

            -- Gang
            draw.SimpleText( (gangInfo && gangInfo.name || MGangs.Language:GetTranslation("no_gang")), "MG_GangInfo_XSM", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  				end

          local plyAva = vgui.Create("AvatarImage", plyPnl)
          plyAva:Dock(LEFT)
          plyAva:DockMargin(2,2,2,2)
          plyAva:SetWide(36)
          plyAva:SetPlayer(ply)

          --[[Edit Player]]
          local editPlyBtn = vgui.Create("DButton", plyPnl)
          editPlyBtn:Dock(RIGHT)
          editPlyBtn:SetWide(100)
          MGangs.Derma.Paint.Elements['button'](editPlyBtn, {text = MGangs.Language:GetTranslation("edit"), rc_tr = true, rc_br = true})

          editPlyBtn.DoClick = function(s)
            loadOptions("player",{
              DoClickData = ply,
              PromptData = {
                ply = ply,
              },
            })
          end

  				return plyPnl
  			end
      end
  		plyListPnl:SetPageTable(getAllPlayers())
  		plyListPnl:SetCurrentPage(1)

      return pnl
    end)
  end
  MGangs.Derma.Paint.Elements['button'](self.mnav_EditPlayers, {text = MGangs.Language:GetTranslation("edit_players"), rc_tl = true, rc_tr = true, rc_bl = true, rc_br = true})
end

--[[Edit Gangs]]
function MENU:EditGangsMenu()
  self.mnav_EditGangs = vgui.Create("DButton", self.menuadminbtns)
	self.mnav_EditGangs:Dock(TOP)
	self.mnav_EditGangs:DockMargin(5,5,5,0)
	self.mnav_EditGangs:SetTall(35)
	self.mnav_EditGangs.DoClick = function(slf)
		self:SetCurrentMenu(false, function(parent)
      local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:DockMargin(0,0,0,0)
			pnl.Paint = function(self,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
			end

      --[[Header]]
      local hdr = vgui.Create("DPanel", pnl)
      hdr:Dock(TOP)
      hdr:DockMargin(0,0,0,0)
      MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("edit_gangs"), rc_tl = true, rc_tr = true})

      local backBtn = vgui.Create("DButton", hdr)
    	backBtn:Dock(RIGHT)
    	backBtn:SetWide(100)
    	MGangs.Derma.Paint.Elements['button'](backBtn, {text = MGangs.Language:GetTranslation("back_to_admin"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = false})
    	backBtn.DoClick = function(slf)
    		pnl:Remove()

        self:CreateAdminButtons()
    	end

      local refreshBtn = vgui.Create("DButton", hdr)
    	refreshBtn:Dock(RIGHT)
      refreshBtn:DockMargin(0,0,5,0)
    	refreshBtn:SetWide(100)
    	MGangs.Derma.Paint.Elements['button'](refreshBtn, {text = MGangs.Language:GetTranslation("refresh_gangs")})
    	refreshBtn.DoClick = function(slf)
    		MGangs.Gang:RequestAll()
    	end

      --[[Gangs Panel]]
      local gangListPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
			gangListPnl:Dock(FILL)
			gangListPnl:SetMaxPageResults(6)
			gangListPnl.Paint = function(s,w,h) end

			--[[Load Gangs]]
			gangListPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_gangs"), placeholder = MGangs.Language:GetTranslation("search_gangs_criteria")})
			gangListPnl.PageItemSetup = function(s, page, gangInfo)
        if (gangInfo) then
          local leader = {
            name = (gangInfo.leader_name or "NIL"),
            stid = (gangInfo.leader_steamid or "NIL"),
          }

          gangInfo.name = (gangInfo.name or "NIL")
          gangInfo.id = (gangInfo.id or "0")

    			local gangPnl = vgui.Create("DPanel")
    			gangPnl:Dock(TOP)
    			gangPnl:DockMargin(5,5,5,0)
    			gangPnl:SetTall(40)
    			gangPnl.Paint = function(s,w,h)
    				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)
            local x, y = 45, 3

            -- Name
            draw.SimpleText( gangInfo.name, "MG_GangInfo_SM", x, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    				-- Gang ID
    				draw.SimpleText( "ID: " .. gangInfo.id, "MG_GangInfo_XSM", x, h - y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

            -- Name
            draw.SimpleText( leader.name, "MG_GangInfo_SM", w/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

    				-- SteamID
    				draw.SimpleText( leader.stid, "MG_GangInfo_XSM", w/2, h - y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    			end

          local gangImg = vgui.Create("HTTPImage", gangPnl)
        	gangImg:SetPos(2, 2)
          gangImg:SetSize(36, 36)
        	gangImg:SetURL(gangInfo.icon_url or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")

          --[[Edit Gang]]
          local editGangBtn = vgui.Create("DButton", gangPnl)
          editGangBtn:Dock(RIGHT)
          editGangBtn:SetWide(100)
          MGangs.Derma.Paint.Elements['button'](editGangBtn, {text = MGangs.Language:GetTranslation("edit"), rc_tr = true, rc_br = true})

          editGangBtn.DoClick = function(s)
            loadOptions("gang",{
              DoClickData = {
                gangInfo = gangInfo,
              },
              PromptData = {
                gangInfo = gangInfo,
              },
            })
          end

    			return gangPnl
        end
      end
  		gangListPnl:SetPageTable(MGangs.Gang:GetAll())
  		gangListPnl:SetCurrentPage(1)

      return pnl
    end)
  end
  MGangs.Derma.Paint.Elements['button'](self.mnav_EditGangs, {text = MGangs.Language:GetTranslation("edit_gangs"), rc_tl = true, rc_tr = true, rc_bl = true, rc_br = true})
end

MGangs.Derma:RegisterMenu({"gang_admin", "mg2_admin"}, MENU)
