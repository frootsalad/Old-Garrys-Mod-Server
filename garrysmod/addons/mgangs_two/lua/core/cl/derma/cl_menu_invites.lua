--[[
MGANGS - CLIENTSIDE MENU - INVITES
Developed by Zephruz
]]

local MENU = {}
MENU.chatCmds = {
  "ganginvites",
  "mginvites",
}

function MENU:Init()
	if (LocalPlayer():GetGangID() != 0) then MGangs:Notification("You can't check your invites because you're in a gang!") return false end

	if (IsValid(self.menuframe)) then self.menuframe:Remove() end

	local imnW, imnH = 500, 425

	-- [[Derma]]
	self.menuframe = vgui.Create("DFrame")
	self.menuframe:SetSize(imnW, imnH)
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

	local pnl = vgui.Create("DPanel", self.menuframe)
	pnl:Dock(FILL)
	pnl:DockMargin(0,0,0,0)
	pnl.Paint = function(self,w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,165), true, true, false, false)
	end

	--[[Invites Search Panel]]
	local invitesPnl = vgui.Create("MG2_PagedScrollPanel", pnl)
	invitesPnl:Dock(FILL)
	invitesPnl:SetMaxPageResults(30)
	invitesPnl.Paint = function(s,w,h) end

	--[[Header]]
	local hdr = vgui.Create("DPanel", invitesPnl)
	hdr:Dock(TOP)
	hdr:DockMargin(0,0,0,0)
	MGangs.Derma.Paint.Elements['header'](hdr, {text = MGangs.Language:GetTranslation("gang_invites"), rc_tl = true, rc_tr = true})

	--[[Load Players]]
	local invites = MGangs.Player:GetInvites()

	invitesPnl:SetupSearchBar({infotext = MGangs.Language:GetTranslation("search_invites"), placeholder = MGangs.Language:GetTranslation("search_invites_criteria")})
	invitesPnl.PageItemSetup = function(s, page, invInfo)
		if (invInfo) then
			local invData = invInfo.data

			-- Player Panel
			local invPnl = vgui.Create("DPanel")
			invPnl:Dock(TOP)
			invPnl:DockMargin(5,5,5,0)
			invPnl:SetTall(45)
			invPnl.Paint = function(s,w,h)
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(45,45,45,225), true, true, true, true)

				-- Name
				draw.SimpleText( invData.gang_name or "NIL: GANG NAME", "MG_GangInfo_SM", 50, h*0.33, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				-- SteamID
				draw.SimpleText( (invData.inv_name or "NIL: NAME") .. " (" .. (invData.inv_stid or "NIL: STEAMID") .. ")", "MG_GangInfo_XSM", 50, h*0.72, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end

			local gangAva = vgui.Create("HTTPImage", invPnl)
			gangAva:Dock(LEFT)
			gangAva:DockMargin(5,5,5,5)
			gangAva:SetSize(35,35)
			gangAva:SetURL(invData.gang_icon or "http://www.tiesolution.com/promotiontie.com/images/products/80x80.jpg")

			-- Deny Gang
			local denyBtn = vgui.Create("DButton", invPnl)
			denyBtn:Dock(RIGHT)
			denyBtn:DockMargin(5,0,0,0)
			denyBtn:SetWide(50)
			MGangs.Derma.Paint.Elements['button'](denyBtn, {text = MGangs.Language:GetTranslation("deny"), rc_tl = false, rc_bl = false, rc_tr = true, rc_br = true})
			denyBtn.DoClick = function(slf)
				MGangs.Player:RespondToInvite(invInfo.id, false)

				table.remove(invites, invInfo._key)

				invPnl:Remove()
			end

			-- Join Gang
			local joinBtn = vgui.Create("DButton", invPnl)
			joinBtn:Dock(RIGHT)
			joinBtn:SetWide(50)
			MGangs.Derma.Paint.Elements['button'](joinBtn, {text = MGangs.Language:GetTranslation("join")})
			joinBtn.DoClick = function(slf)
				MGangs.Player:RespondToInvite(invInfo.id, true)

				table.remove(invites, invInfo._key)

				invPnl:Remove()
			end

      return invPnl
		end
	end
	invitesPnl:SetPageTable(invites)
	invitesPnl:SetCurrentPage(1)
end
MGangs.Derma:RegisterMenu("gang_invites", MENU)
