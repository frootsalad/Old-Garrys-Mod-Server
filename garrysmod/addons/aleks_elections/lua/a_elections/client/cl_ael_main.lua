//Fonts

surface.CreateFont("AEL_Font",{
	font = "DermaLarge",
	size = 21,
	weight = 1000,
	antialias = true
})

surface.CreateFont("AEL_Font2",{
	font = "DermaLarge",
	size = 25,
	weight = 1000,
	antialias = true
})

surface.CreateFont("AEL_Font3",{
	font = "DermaLarge",
	size = 15,
	weight = 1000,
	antialias = true
})

surface.CreateFont("AEL_Font4",{
	font = "DermaLarge",
	size = 30,
	weight = 1000,
	antialias = true
})

surface.CreateFont("AEL_Font5",{
	font = "DermaLarge",
	size = 90,
	weight = 1000,
	antialias = true
})

surface.CreateFont("AEL_Font6",{
	font = "DermaLarge",
	size = 80,
	weight = 1000,
	antialias = true
})

//Variables

shouldEZShowUI = true
ezUISpace = 150
trueWinner = {false}
trueWinnerName = "Disconected"
trueWinnerVotes = 0
ael_accentColor = AElections.Theme_AccentColor
ael_text = true
ael_alpha = 0

//Textures

timer_txt = Material("ez_e/icons/timer_icon.png")
winner_txt = Material("ez_e/icons/winner_icon.png")
check_txt = Material("ez_e/icons/check_icon.png")
mayor_txt = Material("ez_e/icons/mayor_icon.png")
vote_txt = Material("ez_e/icons/vote_icon.png")

//Functions

local function VoteConfirmation(name, steamid)
	surface.PlaySound("buttons/lightswitch2.wav")

	local confirmhovering = false
	local denyhovering = false

	local ael_enter_panel = vgui.Create("DFrame")
	ael_enter_panel:SetSize(250, 125)
	ael_enter_panel:SetPos(ScrW() / 2 - 125, ScrH() / 2 - 62)
	ael_enter_panel:SetTitle("")
	ael_enter_panel:SetVisible(true)
	ael_enter_panel:ShowCloseButton(false)
	ael_enter_panel:SetBackgroundBlur(true)
	ael_enter_panel:MakePopup()

	function ael_enter_panel:Paint(w, h)
		draw.RoundedBox(1, 0, 0, w, h, Color(54, 57, 62, 255))

		AEL_DrawBorders(0, 0, w, h, true, true, true, true)

		draw.DrawText("Are you sure you want to\n vote for "..name.."?", "AEL_Font", w / 2, h / 2 - 44, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local confirmbutton = vgui.Create( "DButton", ael_enter_panel)
	confirmbutton:SetText(" ")
	confirmbutton:SetSize(100, 40)
	confirmbutton:SetPos(130, 75)

	function confirmbutton:OnCursorEntered()
		surface.PlaySound("UI/buttonrollover.wav")

		confirmhovering = true
	end

	function confirmbutton:OnCursorExited()
		confirmhovering = false
	end

	function confirmbutton:Paint(w, h)
		if confirmhovering then
			draw.RoundedBox(3, 0, 0, w, h, Color(math.max(ael_accentColor.r - 10, 0), math.max(ael_accentColor.g - 10, 0), math.max(ael_accentColor.b - 10, 0)))
			draw.RoundedBox(3, 0, 0, w, h - 5, ael_accentColor)
		else
			draw.RoundedBox(3, 0, 0, w, h, Color(40, 42, 46, 255))
			draw.RoundedBox(3, 0, 0, w, h - 5, Color(42, 44, 48, 255))
		end

		draw.DrawText("Yes", "AEL_Font4", w / 2, h / 2 - 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	function confirmbutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		net.Start("AElections_VoteSent")
		net.WriteString(steamid)
		net.SendToServer()

		ael_enter_panel:Close()
	end

	local denybutton = vgui.Create( "DButton", ael_enter_panel)
	denybutton:SetText(" ")
	denybutton:SetSize(100, 40)
	denybutton:SetPos(20, 75)

	function denybutton:OnCursorEntered()
		surface.PlaySound("UI/buttonrollover.wav")

		denyhovering = true
	end

	function denybutton:OnCursorExited()
		denyhovering = false
	end

	function denybutton:Paint(w, h)
		if denyhovering then
			draw.RoundedBox(3, 0, 0, w, h, Color(math.max(ael_accentColor.r - 10, 0), math.max(ael_accentColor.g - 10, 0), math.max(ael_accentColor.b - 10, 0)))
			draw.RoundedBox(3, 0, 0, w, h - 5, ael_accentColor)
		else
			draw.RoundedBox(3, 0, 0, w, h, Color(40, 42, 46, 255))
			draw.RoundedBox(3, 0, 0, w, h - 5, Color(42, 44, 48, 255))
		end

		draw.DrawText("No", "AEL_Font4", w / 2, h / 2 - 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	function denybutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		VoteMenu()

		ael_enter_panel:Close()
	end
end

local function VoteMenu()
	surface.PlaySound("ambient/levels/labs/coinslot1.wav")

	local frameW = 550
	local frameH = 450

	if #AEL_Candidates < 5 then
		frameH = 65 + (80 * #AEL_Candidates)
	end

	local ael_v_frame = vgui.Create("DFrame")
	ael_v_frame:SetSize(frameW, frameH)
	ael_v_frame:SetPos(ScrW() / 2 - frameW / 2, ScrH() / 2 - frameH / 2)
	ael_v_frame:SetTitle("")
	ael_v_frame:ShowCloseButton(false)
	ael_v_frame:SetVisible(true)
	ael_v_frame:MakePopup()

	function ael_v_frame:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(54, 57, 62, 255))

		AEL_DrawBorders(0, 0, w, h, true, true, true, true)
	end

	local ael_v_closebutton = vgui.Create("DButton", ael_v_frame)
	ael_v_closebutton:SetSize(40, 15)
	ael_v_closebutton:SetPos(500, 5)
	ael_v_closebutton:SetText("")
	ael_v_closebutton:SetTooltip("Close")

	function ael_v_closebutton:Paint(w, h)
		draw.RoundedBox(3, 0, 0, w, h, ael_accentColor)
	end

	function ael_v_closebutton:DoClick()
		ael_v_frame:Close()
	end

	ael_candidates_panel = vgui.Create("DPanel", ael_v_frame)
	ael_candidates_panel:SetSize(frameW - 20, frameH - 35)
	ael_candidates_panel:SetPos(10, 25)

	function ael_candidates_panel:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(42, 46, 48, 255))
	end

	local ael_v_scroll = vgui.Create("DScrollPanel", ael_candidates_panel)
	ael_v_scroll:SetSize(frameW - 30, frameH - 45)
	ael_v_scroll:SetPos(5, 5)

	function ael_v_scroll:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(42, 46, 48, 255))
	end

	local ael_v_scrollbar = ael_v_scroll:GetVBar()

	function ael_v_scrollbar:Paint(w, h)
		draw.RoundedBox(3, 5, 0, 10, h, Color(46, 49, 54, 255))
	end

	function ael_v_scrollbar.btnUp:Paint(w, h)
		draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
	end

	function ael_v_scrollbar.btnDown:Paint(w, h)
		draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
	end

	function ael_v_scrollbar.btnGrip:Paint(w, h)
		draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
	end

	local ael_candidates_title = vgui.Create("DPanel", ael_v_scroll)
	ael_candidates_title:SetSize(0, 30)
	ael_candidates_title:DockMargin(0, 0, 0, 5)
	ael_candidates_title:Dock(TOP)
	ael_candidates_title:SetText("")

	function ael_candidates_title:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(36, 39, 44, 150))
		draw.DrawText("Name", "Trebuchet24", (w / 9) * 2 + 40, h / 2 - 12, ael_accentColor, TEXT_ALIGN_CENTER)
		draw.DrawText("Votes", "Trebuchet24", (w / 9) * 6, h / 2 - 12, ael_accentColor, TEXT_ALIGN_CENTER)
	end

	for k, cand in pairs(AEL_Candidates) do
		local hovering = false
		local hoverspace = 0
		local hoveralpha = 0
		local ply = player.GetBySteamID(cand[1])
		local plyName = "Disconected"
		local plyVotes = 0

		local ael_cand_panel = vgui.Create("DPanel", ael_v_scroll)
		ael_cand_panel:SetSize(0, 65)
		ael_cand_panel:DockMargin(0, 0, 0, 5)
		ael_cand_panel:Dock(TOP)
		ael_cand_panel:SetText("")

		if ply != false then
			local ael_avatar = vgui.Create("AvatarImage", ael_cand_panel)
			ael_avatar:SetPos(20, 5)
			ael_avatar:SetSize(55, 55)
			ael_avatar:SetPlayer(ply, 64)
		else
			local ael_avatar = vgui.Create("DImage", ael_cand_panel)
			ael_avatar:SetPos(20, 5)
			ael_avatar:SetSize(55, 55)
			ael_avatar:SetImage("ael/icons/disconected_icon.png")
		end

		local ael_vote_btn = vgui.Create("DButton", ael_cand_panel)
		ael_vote_btn:SetSize(100, 45)
		ael_vote_btn:SetPos(410, 10)
		ael_vote_btn:SetText("")

		function ael_vote_btn:OnCursorEntered()
			surface.PlaySound("UI/buttonrollover.wav")

			hovering = true
		end

		function ael_vote_btn:OnCursorExited()
			hovering = false
		end

		function ael_cand_panel:Paint(w, h)
			draw.RoundedBox(3, 0, 0, w, h, Color(46, 49, 54, 255))
			draw.RoundedBox(3, 0, 0, w, h, Color(36, 39, 44, hoveralpha))

			if ply != false then
				plyName = ply:Nick()
				plyVotes = ply:GetVotes()
			end

			if hovering then draw.RoundedBox(3, 0, 0, 10, h, ael_accentColor) end

			if hovering and hoveralpha < 255 then
				hoveralpha = math.min(hoveralpha + 20, 255)
			elseif not hovering and hoveralpha > 0 then
				hoveralpha = math.max(hoveralpha - 2, 0)
			end

			if hovering and hoverspace < 10 then
				hoverspace = hoverspace + 1
			elseif not hovering and hoverspace > 0 then
				hoverspace = hoverspace - 1
			end

			if hovering then
				draw.DrawText(plyName, "Trebuchet24", (w / 9) * 2 + hoverspace - 20, h / 2 - 12, ael_accentColor, TEXT_ALIGN_LEFT)
				draw.DrawText(plyVotes, "Trebuchet24", (w / 9) * 6 + hoverspace, h / 2 - 12, ael_accentColor, TEXT_ALIGN_LEFT)

				surface.SetDrawColor(ael_accentColor.r, ael_accentColor.g, ael_accentColor.b, 255)
			else
				draw.DrawText(plyName, "Trebuchet24", (w / 9) * 2 + hoverspace - 20, h / 2 - 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
				draw.DrawText(plyVotes, "Trebuchet24", (w / 9) * 6 + hoverspace, h / 2 - 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

				surface.SetDrawColor(255, 255, 255, 255)
			end

			surface.SetMaterial(check_txt)
			surface.DrawTexturedRect(((w / 9) * 6) - 30 + hoverspace, 20, 25, 25)
		end

		function ael_vote_btn:Paint(w, h)
			draw.RoundedBox(3, 0, 0, w, h, Color(36, 39, 44, 255))
			draw.RoundedBox(3, 0, 0, w, h, Color(28, 31, 36, hoveralpha))

			if hovering then
				draw.DrawText("Vote", "Trebuchet24", 45 + hoverspace, h / 2 - 12, ael_accentColor, TEXT_ALIGN_LEFT)

				surface.SetDrawColor(ael_accentColor.r, ael_accentColor.g, ael_accentColor.b, 255)
			else
				draw.DrawText("Vote", "Trebuchet24", 45 + hoverspace, h / 2 - 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

				surface.SetDrawColor(255, 255, 255, 255)
			end

			surface.SetMaterial(vote_txt)
			surface.DrawTexturedRect(10 + hoverspace, 6, 32, 32)
		end

		function ael_vote_btn:DoClick()
			VoteConfirmation(plyName, cand[1])

			ael_v_frame:Close()
		end
	end
end

local function ThanksWindow()
	surface.PlaySound("ui/achievement_earned.wav")

	local confirmhovering = false

	local ael_thanks_panel = vgui.Create("DFrame")
	ael_thanks_panel:SetSize(300, 450)
	ael_thanks_panel:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 225)
	ael_thanks_panel:SetTitle("")
	ael_thanks_panel:SetVisible(true)
	ael_thanks_panel:ShowCloseButton(false)
	ael_thanks_panel:SetBackgroundBlur(true)
	ael_thanks_panel:MakePopup()

	function ael_thanks_panel:Paint(w, h)
		draw.RoundedBox(1, 0, 0, w, h, Color(54, 57, 62, 255))

		AEL_DrawBorders(0, 0, w, h, true, true, true, true)

		draw.DrawText("Hello, and thanks for buying\nmy newest script, Alek's Elections!", "AEL_Font", w / 2, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.DrawText("I know this probably won't\nmean a lot to you, but I just\nwanted you to know how cool\nyou are! Seriously, thanks.", "AEL_Font", w / 2, 75, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.DrawText("I hope you really enjoy my\nscript, if you have any questions\nor issues, don't hesitate in\ncontacting me, I will be glad\nto help you!", "AEL_Font", w / 2, 165, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.DrawText("Also, if you want to help me\neven more, please consider writing\na review, it helps me A LOT\nand it only takes a couple of\nseconds. Click [HERE] to do it.", "AEL_Font", w / 2, 275, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) // 76561198060562411
	end

	local confirmbutton = vgui.Create( "DButton", ael_thanks_panel)
	confirmbutton:SetText(" ")
	confirmbutton:SetSize(270, 40)
	confirmbutton:SetPos(15, 400)

	function confirmbutton:OnCursorEntered()
		surface.PlaySound("UI/buttonrollover.wav")

		confirmhovering = true
	end

	function confirmbutton:OnCursorExited()
		confirmhovering = false
	end

	function confirmbutton:Paint(w, h)
		if confirmhovering then
			draw.RoundedBox(3, 0, 0, w, h, Color(math.max(ael_accentColor.r - 10, 0), math.max(ael_accentColor.g - 10, 0), math.max(ael_accentColor.b - 10, 0)))
			draw.RoundedBox(3, 0, 0, w, h - 5, ael_accentColor)
		else
			draw.RoundedBox(3, 0, 0, w, h, Color(40, 42, 46, 255))
			draw.RoundedBox(3, 0, 0, w, h - 5, Color(42, 44, 48, 255))
		end

		draw.DrawText("You're welcome :D!", "AEL_Font4", w / 2, h / 2 - 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	function confirmbutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		net.Start("AElections_ThanksSent")
		net.SendToServer()

		ael_thanks_panel:Close()
	end

	local reviewbutton = vgui.Create( "DButton", ael_thanks_panel)
	reviewbutton:SetText(" ")
	reviewbutton:SetSize(62, 20)
	reviewbutton:SetPos(145, 361)

	function reviewbutton:Paint(w, h)
		AEL_DrawBorders(0, 0, w, h, true, true, true, true)
	end

	function reviewbutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		gui.OpenURL("https://scriptfodder.com/scripts/view/3057/reviews")
	end
end

local function EnterElectionsMenu()
	surface.PlaySound("buttons/lightswitch2.wav")

	local confirmhovering = false
	local denyhovering = false

	local ael_enter_panel = vgui.Create("DFrame")
	ael_enter_panel:SetSize(250, 125)
	ael_enter_panel:SetPos(ScrW() / 2 - 125, ScrH() / 2 - 62)
	ael_enter_panel:SetTitle("")
	ael_enter_panel:SetVisible(true)
	ael_enter_panel:ShowCloseButton(false)
	ael_enter_panel:SetBackgroundBlur(true)
	ael_enter_panel:MakePopup()

	function ael_enter_panel:Paint(w, h)
		draw.RoundedBox(1, 0, 0, w, h, Color(54, 57, 62, 255))

		AEL_DrawBorders(0, 0, w, h, true, true, true, true)

		if AElections.EnterCost == 0 then
			draw.DrawText("Do you want to enter the\nmayor elections?", "AEL_Font", w / 2, h / 2 - 44, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.DrawText("Do you want to enter the\nmayor elections for $"..AElections.EnterCost.."?", "AEL_Font", w / 2, h / 2 - 44, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local confirmbutton = vgui.Create("DButton", ael_enter_panel)
	confirmbutton:SetText(" ")
	confirmbutton:SetSize(100, 40)
	confirmbutton:SetPos(130, 75)

	function confirmbutton:OnCursorEntered()
		surface.PlaySound("UI/buttonrollover.wav")

		confirmhovering = true
	end

	function confirmbutton:OnCursorExited()
		confirmhovering = false
	end

	function confirmbutton:Paint(w, h)
		if confirmhovering then
			draw.RoundedBox(3, 0, 0, w, h, Color(math.max(ael_accentColor.r - 10, 0), math.max(ael_accentColor.g - 10, 0), math.max(ael_accentColor.b - 10, 0)))
			draw.RoundedBox(3, 0, 0, w, h - 5, ael_accentColor)
		else
			draw.RoundedBox(3, 0, 0, w, h, Color(40, 42, 46, 255))
			draw.RoundedBox(3, 0, 0, w, h - 5, Color(42, 44, 48, 255))
		end

		draw.DrawText("Yes", "AEL_Font4", w / 2, h / 2 - 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	function confirmbutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		net.Start("AElections_EnterSent")
		net.SendToServer()

		ael_enter_panel:Close()
	end

	local denybutton = vgui.Create( "DButton", ael_enter_panel)
	denybutton:SetText(" ")
	denybutton:SetSize(100, 40)
	denybutton:SetPos(20, 75)

	function denybutton:OnCursorEntered()
		surface.PlaySound("UI/buttonrollover.wav")

		denyhovering = true
	end

	function denybutton:OnCursorExited()
		denyhovering = false
	end

	function denybutton:Paint(w, h)
		if denyhovering then
			draw.RoundedBox(3, 0, 0, w, h, Color(math.max(ael_accentColor.r - 10, 0), math.max(ael_accentColor.g - 10, 0), math.max(ael_accentColor.b - 10, 0)))
			draw.RoundedBox(3, 0, 0, w, h - 5, ael_accentColor)
		else
			draw.RoundedBox(3, 0, 0, w, h, Color(40, 42, 46, 255))
			draw.RoundedBox(3, 0, 0, w, h - 5, Color(42, 44, 48, 255))
		end

		draw.DrawText("No", "AEL_Font4", w / 2, h / 2 - 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	function denybutton:DoClick()
		surface.PlaySound("UI/buttonclickrelease.wav")

		ael_enter_panel:Close()
	end
end

local function DoEZAnims()
	if shouldEZShowUI and ezUISpace > 0 then
		ezUISpace = math.max(ezUISpace - 1, 0)
	elseif !shouldEZShowUI and ezUISpace < 150 then
		ezUISpace = math.min(ezUISpace + 1, 150)
	end
end

local function DrawElectionsBase()
	draw.RoundedBox(0, 0, 0, ScrW(), 85 - ezUISpace, Color(54, 57, 62, 255))

	draw.RoundedBox(3, 5, 5, ScrW() - 10, 35 - ezUISpace, Color(math.max(ael_accentColor.r - 20, 0), math.max(ael_accentColor.g - 20, 0), math.max(ael_accentColor.b - 20, 0)))
	draw.RoundedBox(3, 5, 5, ScrW() - 10, 30 - ezUISpace, ael_accentColor)

	AEL_DrawBorders(0, 0, ScrW(), 85 - ezUISpace, false, true, false, false)
end

local function DrawElectionsText()
	local winner = AEL_GetWinner()
	local winnerVotes = AEL_GetWinningVotes()
	local winnerName = "An error has occurred!"

	if ael_text and ael_alpha < 255 then
		ael_alpha = math.min(ael_alpha + 5, 255)
	elseif !showInfoButton and ael_alpha > 0 then
		ael_alpha = math.max(ael_alpha - 5, 0)
	end

	if winner[1] == false or #winner > 1 then
		winnerName = "Currently tied!"
	else
		winnerName = winner[1]:Nick()
	end

	surface.SetFont("Trebuchet24")

	draw.DrawText("MAYOR ELECTIONS:", "Trebuchet24", ScrW() / 9, 10 - ezUISpace, Color(54, 57, 62, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.DrawText("Type '/"..AElections.VoteCommand.."' or '!"..AElections.VoteCommand.."' to vote for the next mayor!", "Trebuchet24", ScrW() / 2, 10 - ezUISpace, Color(54, 57, 62, 255 - ael_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.DrawText("Use '/"..AElections.HideCommand.."' or '!"..AElections.HideCommand.."' to hide this banner!", "Trebuchet24", ScrW() / 2, 10 - ezUISpace, Color(54, 57, 62, ael_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local tw, th = surface.GetTextSize("Time left: "..GetGlobalInt("AEL_ElectionsTime", 0))

	draw.DrawText("Time left: "..GetGlobalInt("AEL_ElectionsTime", 0), "Trebuchet24", ((ScrW() / 9) * 1) - ((tw / 2) - 12), (50 + 35 / 2 - 18)  - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(timer_txt)
	surface.DrawTexturedRect(((ScrW() / 9) * 1) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)

	local tw, th = surface.GetTextSize("Currently winning: "..winnerName)

	draw.DrawText("Currently winning: "..winnerName, "Trebuchet24", ((ScrW() / 2) * 1) - ((tw / 2) - 12), (50 + 35 / 2 - 18) - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(winner_txt)
	surface.DrawTexturedRect(((ScrW() / 2) * 1) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)

	local tw, th = surface.GetTextSize("Votes: "..winnerVotes)

	draw.DrawText("Votes: "..winnerVotes, "Trebuchet24", ((ScrW() / 9) * 8) - ((tw / 2) - 12), (50 + 35 / 2 - 18) - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(check_txt)
	surface.DrawTexturedRect(((ScrW() / 9) * 8) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)
end

local function DrawPostElectionsText()
	surface.SetFont("Trebuchet24")

	draw.DrawText("The mayor elections are officially over!", "Trebuchet24", ScrW() / 2, 10 - ezUISpace, Color(54, 57, 62, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	local tw, th = surface.GetTextSize("The time's over!")

	draw.DrawText("The time's over!", "Trebuchet24", ((ScrW() / 9) * 1) - ((tw / 2) - 12), (50 + 35 / 2 - 18) - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(timer_txt)
	surface.DrawTexturedRect(((ScrW() / 9) * 1) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)

	local tw, th = surface.GetTextSize("Winner: "..trueWinnerName)

	draw.DrawText("Winner: "..trueWinnerName, "Trebuchet24", ((ScrW() / 2) * 1) - ((tw / 2) - 12), (50 + 35 / 2 - 18) - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(winner_txt)
	surface.DrawTexturedRect(((ScrW() / 2) * 1) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)

	local tw, th = surface.GetTextSize("Votes: "..trueWinnerVotes)

	draw.DrawText("Votes: "..trueWinnerVotes, "Trebuchet24", ((ScrW() / 9) * 8) - ((tw / 2) - 12), (50 + 35 / 2 - 18) - ezUISpace, ael_accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(check_txt)
	surface.DrawTexturedRect(((ScrW() / 9) * 8) - ((tw / 2) + 12), 52 - ezUISpace, 22, 22)
end

local function DrawEntityHud()
	local localplayer = LocalPlayer()
	local shootPos = localplayer:GetShootPos()
	local aimVec = localplayer:GetAimVector()
	for k, ent in pairs (ents.FindByClass("aellections_secretary")) do
		local hisPos = ent:GetPos()
		if hisPos:DistToSqr(shootPos) < 20000 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.75 then
				local trace = util.QuickTrace(shootPos, pos, localplayer)
				local position = (ent:EyePos() - Vector(0, 0, 25)):ToScreen()
				if trace.Hit and trace.Entity ~= ent then return end

				surface.SetFont("Trebuchet24")
				local w, h = surface.GetTextSize("Press E to enter the mayor elections!")

				surface.SetDrawColor(ael_accentColor.r, ael_accentColor.g, ael_accentColor.b, 255)
				surface.SetMaterial(mayor_txt)
				surface.DrawTexturedRect(position.x - 25 - w / 2, position.y - 62, 25, 25)

				draw.SimpleText("Press E to enter the mayor elections!", "Trebuchet24", position.x, position.y - 50, ael_accentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

//Hooks

hook.Add( "HUDPaint", "AEL_Text", function()
	DrawEntityHud()
	DoEZAnims()

	if GetGlobalInt("AEL_ElectionsTime", 0) > 0 and ezUISpace != 150 then
		DrawElectionsBase()
		DrawElectionsText()
	elseif GetGlobalInt("AEL_PostElectionsTime", 0) > 0 and ezUISpace != 150 then
		DrawElectionsBase()
		DrawPostElectionsText()
	end
end)

//Net Messages

net.Receive("AElections_EnterMenu", EnterElectionsMenu)

net.Receive("AElections_VoteMenu", VoteMenu)

net.Receive("AElections_ThanksMenu", ThanksWindow)

net.Receive("AElections_ElectionsEnd", function()
	shouldEZShowUI = true

	surface.PlaySound("ui/achievement_earned.wav")

	trueWinner = net.ReadTable()
	trueWinnerName = trueWinner[1]:Nick()
	trueWinnerVotes = trueWinner[2]

	table.Empty(AEL_Candidates)
end)

net.Receive("AElections_HideBanner", function()
	if shouldEZShowUI == false then
		shouldEZShowUI = true

		AEL_CL_Notify("The elections banner will now be shown.")
	elseif shouldEZShowUI == true then
		shouldEZShowUI = false

		AEL_CL_Notify("The elections banner will now be hidden.")
	end
end)

//Init

timer.Create("AEL_Text", 10, 0,function()
	ael_text = !ael_text
end)

if AElections.Theme_RainbowAccentColor then
	local ael_r = 100
	local ael_g = 150
	local ael_b  = 200

	timer.Create("AEL_RainbowColorsTimer", 0.1, 0, function()
		ael_r = math.random(-15, 15)
		ael_g = math.random(-15, 15)
		ael_b = math.random(-15, 15)

		ael_accentColor = Color(math.min(math.max(ael_accentColor.r + ael_r, 0), 255), math.min(math.max(ael_accentColor.g + ael_g, 0), 255), math.min(math.max(ael_accentColor.b + ael_b, 0), 255))
	end)
else
	ael_accentColor = AElections.Theme_AccentColor
end
