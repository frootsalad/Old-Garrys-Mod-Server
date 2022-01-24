--[[
MGANGS - CLIENTSIDE DERMA PAINT
Developed by Zephruz
]]

MGangs.Derma.Paint = {}
MGangs.Derma.Fonts = {}

-- Schemas
MGangs.Derma.CurrentSchema = "midnight"
MGangs.Derma.Paint.Schemas = {
	['midnight'] = {
		main_col = Color(54, 100, 139, 255),
		["frame"] = {
			title_color = Color(255, 255, 255, 255),
			hd_color = Color(40, 40, 40, 255),
			hdu_color = Color(61, 61, 61, 255),
			bg_color = Color(50, 50, 50, 200),
		},
		["circlebutton"] = {
			cbh_color = Color(84, 130, 169, 255),
			cb_color = Color(54, 100, 139, 255),
			cbx_color = Color(255, 255, 255, 255),
		},
		["button"] = {
			main_col = Color(55, 55, 55, 255),
			hover_col = Color(54, 100, 139, 150),
			disable_col = Color(45, 45, 45, 255),
			img_color = color_white,
		},
		["progressbar"] = {
			bar_color = Color(84, 130, 169, 255),
			bar_ul_color = Color(54, 100, 139, 255),
			bg_color = Color(40, 40, 40, 200),
			text_color = Color(255, 255, 255, 255),
		},
		["navbutton"] = {
			main_col = Color(65, 65, 65, 255),
			hover_col = Color(54, 100, 139, 150),
			main_hover_col = Color(60, 60, 60, 255),
			active_col = Color(45, 45, 45, 255),
		},
		["textbox"] = {
			main_col = Color(55, 55, 55, 245),
			focus_col = Color(54, 100, 139, 0),
			text_col = Color(225, 225, 225, 255),
			warn_col = Color(225, 85, 85, 255),
		},
	},
}

-- Element Paint
local function RegisterPaintValues(vals, additions)
	local addVals = vals

	for k,v in pairs(additions) do
		addVals[k] = v
	end

	return addVals
end

MGangs.Derma.Paint.Elements = {
	['frame'] = function(ele, title, additions)
		local addVals = RegisterPaintValues({
			fgBlur = false,
		}, (additions or {}))

		ele:SetTitle("")

		local blurmat = Material("pp/blurscreen")

		ele.Paint = function(self,w,h)
			if (addVals.fgBlur) then
				Derma_DrawBackgroundBlur( self, 1 )
			end

			local x, y = self:LocalToScreen(0, 0)
			surface.SetDrawColor(0,0,0,255)
			surface.SetMaterial(blurmat)

			for i = 1, 4 do
				blurmat:SetFloat("$blur", (i / 3) * (amount or 6))
				blurmat:Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
			end

			draw.RoundedBoxEx(6, 0, 0, w, h, Color(55,55,55,165), true, true, false, false) -- Background

			-- [[Top Bar]]
			local tbW, tbH = w, 24
			draw.RoundedBoxEx(4, 0, 0, tbW, tbH, Color(50,50,50,255), true, true, false, false)
			draw.SimpleText( title or "No title", "MG_FrameTitle", 5, tbH/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) -- Title
		end
	end,
	['tooltip'] = function(pnl, text)
		local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema]

		text = (text or "No text")

		surface.SetFont("MG_CButton_Text")
		local w, h = surface.GetTextSize(text)
		w = w + 20
		h = h + 10

		local ttPnl = vgui.Create("DPanel")
		ttPnl:SetSize(w, h)
		ttPnl:SetVisible(false)
		ttPnl.PaintOver = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, schema.main_col)

			draw.SimpleText(text, "MG_CButton_Text", w/2, h/2, schema.cbx_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		pnl:SetTooltipPanel(ttPnl)

		return ttPnl
	end,
	['scrollpanel'] = function(ele, additions)
		local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema]

		local addVals = RegisterPaintValues({
			custPaint = false,
		}, (additions or {}))

		ele.VBar:SetWide(4)

		if (addVals.custPaint) then
			ele.Paint = addVals.custPaint
		end

		function ele.VBar:Paint( w, h )
			--draw.RoundedBoxEx( 5, 0, 0, w, h, Color(55,55,55,185), false, false, false, false )
		end

		function ele.VBar.btnUp:Paint( w, h )
			draw.RoundedBoxEx( 5, 0, 2, w, h - 4, schema.main_col, false, false, false, false )
		end

		function ele.VBar.btnDown:Paint( w, h )
			draw.RoundedBoxEx( 5, 0, 2, w, h - 4, schema.main_col, false, false, false, false )
		end

		function ele.VBar.btnGrip:Paint( w, h )
			draw.RoundedBoxEx( 5, 0, 0, w, h, schema.main_col, false, false, false, false )
		end
	end,
	['circlebutton'] = function(ele, text)
		ele:SetText("")

		ele.OnCursorEntered = function(self)
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].circlebutton

			surface.SetDrawColor( schema.cb_color.r, schema.cb_color.g, schema.cb_color.b, 255 )

			if (self:IsHovered()) then
				surface.SetDrawColor( schema.cbh_color.r, schema.cbh_color.g, schema.cbh_color.b, 255 )
			end

			draw.NoTexture()
			draw.Circle( (w / 2), (h / 2), w/2 - 1, 100 )

			draw.SimpleText( text or "No text", "MG_CButton_Text", w/2, h/2, schema.cbx_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end,
	['closebutton'] = function(ele, text)
		ele:SetText("")

		ele.OnCursorEntered = function(self)
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].circlebutton
			local col = schema.cb_color

			if (self:IsHovered()) then
				col = schema.cbh_color
			end

			draw.RoundedBoxEx(4, 0, 0, w, h, col, false, true, false, false)

			draw.SimpleText( text or "No text", "DermaDefault", w/2 + 1, h/2, schema.cbx_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end,
	['progressbar'] = function(ele, infofunc)
		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].progressbar

			local dprog_frac = self:GetFraction()

			draw.RoundedBoxEx( 6, 0, 0, w, h, schema.bg_color, true, true, true, true )
			draw.RoundedBoxEx( 6, 2, h - 10, (w * dprog_frac) - 4, 8, schema.bar_ul_color, false, false, true, true )
			draw.RoundedBoxEx( 6, 2, 2, (w * dprog_frac) - 4, h - 10, schema.bar_color, true, true, true, true )

			if (infofunc) then
				infofunc(self,w,h)
			end
		end
	end,
	-- Nav Bar
	['navbar'] = function(ele)
		ele.Paint = function(self,w,h)
			draw.RoundedBoxEx(6, 0, 0, w, h, Color(55,55,55,255), false, false, false, false)
		end
	end,
	['navbarInfo'] = function(ele, additions)
		local addVals = RegisterPaintValues({
			text = "Nav Button",
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
			infofunc = false,
		}, (additions or {}))

		ele.Paint = function(self,w,h)
			draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, Color(65,65,65,225), addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)

			if (addVals.infofunc) then
				addVals.infofunc(self,w,h)
			end
		end
	end,
	['navbutton'] = function(ele, additions)
		ele:SetText("")
		ele.HoverTime = 0
		ele.ActiveBarTime = 0

		local addVals = RegisterPaintValues({
			text = "Nav Button",
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
		}, (additions or {}))

		ele.OnCursorEntered = function(self)
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].navbutton

			draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, schema.main_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)

			if (self:GetDisabled()) then
				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, schema.active_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, 8, h, schema.hover_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			elseif (self:IsHovered()) then
				self.HoverTime = math.min(8, Lerp(0.5, self.HoverTime, self.HoverTime + 1))

				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, schema.main_hover_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, self.HoverTime, h, schema.hover_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			else
				self.HoverTime = math.max(0, Lerp(0.5, self.HoverTime, self.HoverTime - 1))

				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, self.HoverTime, h, schema.hover_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			end

			draw.SimpleText( addVals.text or "No text", "MG_Button_Text", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end,

	-- Misc
	['header'] = function(ele, additions)
		local addVals = RegisterPaintValues({
			text = "Header",
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
		}, (additions or {}))

		ele.Paint = function(self,w,h)
			draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, Color(45,45,45,255), addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			draw.SimpleText( (addVals.text or "Header"), "MG_GangInfo_SM", 5, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end,
	['textentry'] = function(ele, additions)
		local addVals = RegisterPaintValues({
			ptext = "Placeholder",
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
		}, (additions or {}))

		ele.FocusTime = 0

		local checkIcon = Material("icon16/tick.png")
		local errorIcon = Material("icon16/exclamation.png")

		local function drawFilterIcon(w, h, schema, icon)
			if (icon) then
				draw.RoundedBoxEx( addVals.rc_rad, w-25, 0, 25, h, schema.main_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br )

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(w-20, 5, 16, 16)
			end
		end

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].textbox

			local selfValue = self:GetValue()

			draw.RoundedBoxEx( addVals.rc_rad, 0, 0, w, h, schema.main_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br )

			if (self:HasFocus()) then
				self.FocusTime = self.FocusTime + 3
				schema.focus_col.a = math.Clamp(self.FocusTime, 0, 55)
				draw.RoundedBoxEx( addVals.rc_rad, 0, 0, w, h, schema.focus_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br )
			else
				self.FocusTime = 0
			end

			self:DrawTextEntryText(Color(255, 255, 255, 0), Color(30, 130, 255, 255), Color(255, 255, 255, 255))

			-- Draw Text
			if (addVals.ptext && #self:GetValue() <= 0) then
				schema.text_col.a = 100
				draw.SimpleText( addVals.ptext, (self:GetFont() or "DermaDefault"), 3, h/2, schema.text_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				schema.text_col.a = 255
				draw.SimpleText( selfValue, (self:GetFont() or "DermaDefault"), 3, h/2, schema.text_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end

			-- Draw Filters
			local filterVal

			-- Filters
			if (ele.CharacterFilter && #selfValue > 0) then
				local filterRes = MGangs.Util:FilterStringEntry(selfValue, ele.CharacterFilter)

				if (!filterRes.pass) then
					filterVal = ele.CharacterFilterError .. " (" .. filterRes.foundval .. ")"
				end
			end

			-- Matches
			if (ele.CharacterMatch && #selfValue > 0) then
				local matchRes = MGangs.Util:MatchStringEntry(selfValue, ele.CharacterMatch)

				if (!matchRes.pass) then
					filterVal = ele.CharacterMatchError
				end
			end

			if (ele.MaxCharacters && #selfValue > ele.MaxCharacters && ele.MaxCharacters > 0) then
				filterVal = "Max Characters: " .. ele.MaxCharacters
			end

			if (ele.MinCharacters && #selfValue < ele.MinCharacters && ele.MinCharacters > 0) then
				filterVal = "Min. Characters: " .. ele.MinCharacters
			end

			ele.ValuesPass = true
			if (filterVal) then
				local fTxtW, fTxtH = surface.GetTextSize(filterVal)

				if (self:HasFocus()) then
					draw.RoundedBoxEx( addVals.rc_rad, w-(fTxtW+10), 0, fTxtW + 10, h, schema.main_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br )
					draw.SimpleText( filterVal, (self:GetFont() or "DermaDefault"), w - 3, h/2, schema.warn_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					drawFilterIcon(w, h, schema, errorIcon)
				end

				ele.ValuesPass = false
			elseif (ele.CharacterFilter or ele.CharacterMatch) then
				drawFilterIcon(w, h, schema, checkIcon)
			end
		end
	end,
	['combobox'] = function(ele, additions)
		ele:SetTextColor(Color(225,225,225,0))

		local addVals = RegisterPaintValues({
			text = "Combo Box",
			icon = false,
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
		}, (additions or {}))

		local icon = (addVals.icon && Material(addVals.icon) || false)

		ele.FocusTime = 0

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].textbox

			local TxtX, TxtY = 3, h/2
			draw.RoundedBoxEx( addVals.rc_rad, 0, 0, w, h, Color(45,45,45,235), addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)

			if (self:IsMenuOpen()) then
				self.FocusTime = self.FocusTime + 3
				schema.focus_col.a = math.Clamp(self.FocusTime, 0, 55)
				draw.RoundedBoxEx( addVals.rc_rad, 0, 0, w, h, schema.focus_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br )
			else
				self.FocusTime = 0
			end

			if (icon && !icon:IsError()) then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(5, 5, 16, 16)

				TxtX = 25
			end

			draw.SimpleText( (self:GetValue() or addVals.text), (self:GetFont() or "DermaDefault"), TxtX, TxtY, Color(225,225,225,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end,
	['button'] = function(ele, additions)
		ele:SetText("")
		ele.HoverTime = 0

		local addVals = RegisterPaintValues({
			font = "MG_Button_Text",
			text = "Button Text",
			hover_text = false,
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
			icon = false,
			paint = nil,
		}, (additions or {}))

		-- Get text & set button size
		surface.SetFont(addVals.font)

		local btnSize = ele:GetWide()
		local btnW, btnH = surface.GetTextSize(addVals.text or ele:GetText())

		if (btnW >= btnSize) then
			ele:SetWide(btnW + 20)
		end

		addVals.hover_text = (addVals.hover_text or addVals.text)

		ele.OnCursorEntered = function(self)
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		ele.Paint = function(self,w,h)
			local schema = MGangs.Derma.Paint.Schemas[MGangs.Derma.CurrentSchema].button

			draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, schema.main_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)

			if (self:GetDisabled()) then
				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, Color(45,45,45,255), addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			elseif (self:IsHovered()) then
				self.HoverTime = self.HoverTime + 5
				schema.hover_col.a = math.Clamp(self.HoverTime, 0, 255)
				draw.RoundedBoxEx(addVals.rc_rad, 0, 0, w, h, schema.hover_col, addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)
			else
				self.HoverTime = 0
			end

			-- if (icon) then end
			draw.SimpleText( (self:IsHovered() && addVals.hover_text || addVals.text or "No text"), (addVals.font or "MG_Button_Text"), w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if (addVals.paint) then
				addVals.paint(self,w,h)
			end
		end
	end,
	['infobox'] = function(ele, additions)
		local addVals = RegisterPaintValues({
			text = "InfoBox",
			font = "DermaDefault",
			toolTipText = false,
			rc_rad = 4,
			rc_tl = false,
			rc_tr = false,
			rc_bl = false,
			rc_br = false,
		}, (additions or {}))

		ele:SetMouseInputEnabled(true)

		if (addVals.toolTipText) then
			ele:SetWide(ele:GetWide() + 20)	-- adjust for icon

			local tTip = vgui.Create("MG2_ToolTip")
			tTip:setTTParent(ele)
			-- tTip:setTTFont("MG_GangInfo_XSM")
			tTip:setTTText(addVals.toolTipText or "Tooltip text")
		end

		local infoIcon = Material("icon16/help.png")

		ele.OnCursorEntered = function(self)
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		ele.Paint = function(self,w,h)
			local font = (addVals.font or "DermaDefault")
			local text = (ele.InfoText or addVals.text)
			local tAlign, sAlign = TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
			local tPosX, tPosY = w/2, h/2

			draw.RoundedBoxEx(addVals.rc_rad,0,0,w,h,Color(40,40,40,255),addVals.rc_tl, addVals.rc_tr, addVals.rc_bl, addVals.rc_br)

			if (addVals.toolTipText) then
				tAlign = TEXT_ALIGN_RIGHT
				tPosX = w-5

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(infoIcon)
				surface.DrawTexturedRect(5, 5, 16, 16)
			end

			draw.SimpleText(text, font, tPosX, tPosY, Color(215,215,215,255), tAlign, sAlign)
		end
	end,
}

-- =======
--[[ Fonts ]]
-- =======
MGangs.Derma.Fonts['MG_GangInfo_LG'] = {
	font = "Abel",
	size = 27,
}
MGangs.Derma.Fonts['MG_GangInfo_MD'] = {
	font = "Abel",
	size = 24,
}
MGangs.Derma.Fonts['MG_GangInfo_SM'] = {
	font = "Abel",
	size = 21,
}
MGangs.Derma.Fonts['MG_GangInfo_XSM'] = {
	font = "Abel",
	size = 17,
}
MGangs.Derma.Fonts['MG_FrameTitle'] = {
	font = "Abel",
	size = 22,
}
MGangs.Derma.Fonts['MG_GangInfo_Name'] = {
	font = "Abel",
	size = 22,
}
MGangs.Derma.Fonts['MG_GangInfo_SubText'] = {
	font = "Abel",
	size = 18,
}
MGangs.Derma.Fonts['MG_Button_Text'] = {
	font = "Abel",
	size = 20,
}
MGangs.Derma.Fonts['MG_ProgBar_Text'] = {
	font = "Abel",
	size = 18,
}
MGangs.Derma.Fonts['MG_CButton_Text'] = {
	font = "Abel",
	size = 16,
	weight = 600
}

for ft,fd in pairs(MGangs.Derma.Fonts) do
	surface.CreateFont(ft, fd)
end

-- ==============
-- [[CUSTOM DRAWS]]
-- ==============
-- [[Draw Circle]]
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DisableClipping( false )
	surface.DrawPoly( cir )
end

-- [[Circle Poly func (for avatar)]]
function MakeCirclePoly( pos_x, pos_y, radius, ang_pts )
    local _u = ( pos_x + radius * 320 ) - pos_x;
    local _v = ( pos_y + radius * 320 ) - pos_y;

    local _slices = ( 2 * math.pi ) / ang_pts;
    local _poly = { };
    for i = 0, ang_pts - 1 do
        local _angle = ( _slices * i ) % ang_pts;
        local x = pos_x + radius * math.cos( _angle );
        local y = pos_y + radius * math.sin( _angle );
        table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
    end

    return _poly;
end
