-- http://lua-users.org/wiki/DayOfWeekAndDaysInMonthExample
local function is_leap_year(year) return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) end

bLogs.LocalSettings = {
	language    = "English",
	colour_mode = true,
}
function bLogs:UpdateLocalSettings()
	file.Write("blogs/local_settings.txt",util.TableToJSON(bLogs.LocalSettings))
	hook.Run("bLogs_UpdateLocalSettings")
end
if (file.Exists("blogs/local_settings.txt","DATA")) then
	local r = file.Read("blogs/local_settings.txt","DATA")
	r = util.JSONToTable(r)
	if (r) then
		bLogs.LocalSettings = r
	end
else
	bLogs:UpdateLocalSettings()
end

if (IsValid(bLogs.Menu)) then
	bLogs.Menu:Close()
end

local function json_e(str)
	return '"' .. (str:gsub("\"","\\\"")) .. '"'
end

function bLogs:chatprint(msg,type)
	if (type == "error" or type == "bad") then
		chat.AddText(Color(255,0,0),"[bLogs] ",Color(255,255,255),msg)
	elseif (type == "success" or type == "good") then
		chat.AddText(Color(0,255,0),"[bLogs] ",Color(255,255,255),msg)
	else
		chat.AddText(Color(0,255,255),"[bLogs] ",Color(255,255,255),msg)
	end
end

bLogs:netr("permission_failure",function()
	bLogs:chatprint(bLogs:t("permission_failure"),"bad")
end)

bLogs:netr("InvalidateData",function()
	bLogs.Modules = nil
	bLogs.InGameConfig = nil
end)

local voice_key = input.LookupBinding("+voicerecord",true)
local voice_enum
if (voice_key) then
	for i,v in pairs(_G) do
		if (i:sub(1,4) == "KEY_") then
			if (input.GetKeyName(v) == voice_key) then
				voice_enum = v
				break
			end
		end
	end
end

local function OpenSearch()

	if (IsValid(bLogs.SearchMenu)) then
		bLogs.SearchMenu:Close()
	end

	bLogs.SearchMenu = vgui.Create("BFrame")
	local m = bLogs.SearchMenu
	m:SetSize(450,250)
	m:Center()
	m:SetTitle(bLogs:t("advanced_search"))
	m:Configured()
	m:MakePopup()

	m.ModuleList = vgui.Create("BListView",m)
	m.ModuleList:SetSize(125,m:GetTall() - 10 - 24)
	m.ModuleList:AlignBottom(5)
	m.ModuleList:AlignLeft(5)
	m.ModuleList:AddColumn(bLogs:t("modules"))
	m.ModuleList.OnRowSelected = function(_,i)
		m.ModuleList:RemoveLine(i)
	end

	m.PlayerList = vgui.Create("BListView",m)
	m.PlayerList:SetSize(125,m:GetTall() - 10 - 24)
	m.PlayerList:AlignBottom(5)
	m.PlayerList:AlignLeft(5 + 125 + 5)
	m.PlayerList:AddColumn(bLogs:t("players"))
	m.PlayerList.OnRowSelected = function(_,i)
		m.PlayerList:RemoveLine(i)
	end

	m.ModuleDropdown = vgui.Create("DComboBox",m)
	m.ModuleDropdown:SetSize(180,25)
	m.ModuleDropdown:AlignRight(5)
	m.ModuleDropdown:AlignTop(24 + 5)
	m.ModuleDropdown:ChooseOption(bLogs:t("modules") .. "...")
	local mids = {}
	for i,v in pairs(bLogs.Modules) do
		table.insert(mids,i)
		m.ModuleDropdown:AddChoice(v.Category .. ": " .. v.Name)
	end
	m.ModuleDropdown.OnSelect = function(_,i,t)
		if (i == nil) then return end
		m.ModuleDropdown:ChooseOption(bLogs:t("modules") .. "...")
		m.ModuleList:AddLine(t).ID = mids[i]
	end

	m.PlayerDropdown = vgui.Create("DComboBox",m)
	m.PlayerDropdown:SetSize(180,25)
	m.PlayerDropdown:AlignRight(5)
	m.PlayerDropdown:AlignTop(24 + 5 + 25 + 5)
	m.PlayerDropdown:ChooseOption(bLogs:t("players") .. "...")
	m.PlayerDropdown:AddChoice("#" .. bLogs:t("custom") .. "...")
	local sids = {false}
	for _,v in pairs(player.GetAll()) do
		table.insert(sids,v:SteamID())
		m.PlayerDropdown:AddChoice(v:Nick())
	end
	m.PlayerDropdown.OnSelect = function(_,i,t)
		if (i == nil) then return end
		if (i == 1) then
			m.PlayerDropdown:ChooseOption(bLogs:t("players") .. "...")
			Billy_StringRequest(bLogs:t("custom") .. "...",bLogs:t("enter_a_steamid"),"",function(t)
				if (t:find("^STEAM_%d:%d:%d+$")) then
					m.PlayerList:AddLine(t).SteamID = t
				else
					Billy_Message(bLogs:t("error_not_steamid"),bLogs:t("error"))
				end
			end)
		else
			m.PlayerDropdown:ChooseOption(bLogs:t("players") .. "...")
			m.PlayerList:AddLine(t).SteamID = sids[i]
		end
	end

	m.Contains = vgui.Create("BTextBox",m)
	m.Contains:SetSize(180,25)
	m.Contains:AlignRight(5)
	m.Contains:AlignTop(24 + 5 + 25 + 5 + 25 + 5)
	m.Contains:SetPlaceHolder(bLogs:t("contains"))

	local function do_search(force_archive)
		local query = {}
		if (bLogs.Menu.LogsPanel.Logs.Query:find('"archive":true')) then
			query.archive = true
		end
		if (force_archive) then
			query.archive = true
		end
		for _,v in pairs(m.ModuleList:GetLines()) do
			query.module = query.module or {}
			table.insert(query.module,v.ID)
		end
		for _,v in pairs(m.PlayerList:GetLines()) do
			query.player = query.player or {}
			table.insert(query.player,util.SteamIDTo64(v.SteamID))
		end
		if (string.Trim(m.Contains:GetText()) ~= bLogs:t("contains") and string.Trim(m.Contains:GetText()) ~= "") then
			query.search = m.Contains:GetText()
		end
		if (query.search or query.module or query.search or query.player) then
			bLogs.Menu.LogsPanel.LogInfo.Close.DoClick()
			bLogs.Menu.LogsPanel.Logs:Clear()
			bLogs.Menu.LogsPanel.Logs.StoredLogs = {}
			bLogs.Menu.LogsPanel.Logs.StoredSearchLogs = {}
			bLogs.Menu.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
			bLogs.Menu.LogsPanel.Logs.Page = 1
			local d = util.TableToJSON(query):Left(-2):Right(-2)
			bLogs.Menu.LogsPanel.Logs.Query = d
			d = util.Compress(d)
			local d_ = #d
			bLogs:nets("AdvancedSelectLogs")
				net.WriteDouble(d_)
				net.WriteData(d,d_)
				net.WriteInt(1,32)
			net.SendToServer()
			m:Close()
		end
	end

	m.Search = vgui.Create("BButton",m)
	m.Search:SetSize(180,25)
	m.Search:AlignRight(5)
	m.Search:AlignTop(24 + 5 + 25 + 5 + 25 + 5 + 25 + 5)
	m.Search:SetText(bLogs:t("search"))
	m.Search.DoClick = function() do_search(false) end

	m.SearchArchive = vgui.Create("BButton",m)
	m.SearchArchive:SetSize(180,25)
	m.SearchArchive:AlignRight(5)
	m.SearchArchive:AlignTop(24 + 5 + 25 + 5 + 25 + 5 + 25 + 5 + 25 + 5)
	m.SearchArchive:SetText(bLogs:t("search_archive"))
	m.SearchArchive:SetTooltip(bLogs:t("search_archive_warning"))
	m.SearchArchive.DoClick = function() do_search(true) end

end

CreateConVar("blogs_fullscreen","0",FCVAR_ARCHIVE,"Whether bLogs should be fullscreen or not.")

local function OpenMenu()

	if (not bLogs.Modules or not bLogs.InGameConfig) then
		bLogs:chatprint(bLogs:t("getting_data"))
		bLogs:netr("Send_Setup_Data",function()

			local modules_c = net.ReadDouble()
			local modules   = net.ReadData(modules_c)
			      modules   = util.Decompress(modules)
				  modules   = util.JSONToTable(modules)
			bLogs.Modules = modules

			local settings_c = net.ReadDouble()
			local settings   = net.ReadData(settings_c)
			      settings   = util.Decompress(settings)
				  settings   = util.JSONToTable(settings)
			bLogs.InGameConfig = settings

			bLogs.IsMySQL = net.ReadBool()

			bLogs.bLogsWebURL = net.ReadString()
			if (bLogs.bLogsWebURL == "") then bLogs.bLogsWebURL = nil end

			OpenMenu()

		end)
		bLogs:nets("Send_Setup_Data")
		net.SendToServer()
		return
	end

	if (IsValid(bLogs.SearchMenu)) then
		bLogs.SearchMenu:Close()
	end
	if (IsValid(bLogs.Menu)) then
		bLogs.Menu:Close()
	end

	local admin_mode = bLogs:IsMaxPermitted()

	bLogs.Menu = vgui.Create("BFrame")
	local m = bLogs.Menu
	if (GetConVar("blogs_fullscreen"):GetBool() == true) then
		m:SetSize(ScrW(),ScrH())
		m:SetDraggable(false)
	else
		if (1152 > (ScrW() - 50)) then
			m:SetWide(ScrW() - 50)
		else
			m:SetWide(1152)
		end
		if (648 > (ScrH() - 50)) then
			m:SetTall(ScrH() - 50)
		else
			m:SetTall(648)
		end
	end
	m:Center()
	if (admin_mode) then
		m:SetTitle("bLogs " .. bLogs.Version .. " | " .. bLogs:t("admin_mode"))
		m:SetIcon("icon16/shield.png")
	else
		m:SetTitle("bLogs " .. bLogs.Version)
		m:SetIcon("icon16/user.png")
	end
	m:Configured()
	m:MakePopup()

	if (voice_enum) then
		function m:OnKeyCodePressed(keyCode)
			if (keyCode == voice_enum) then
				RunConsoleCommand("+voicerecord")
			end
		end
		function m:OnKeyCodeReleased(keyCode)
			if (keyCode == voice_enum) then
				RunConsoleCommand("-voicerecord")
			end
		end
	end

	m.OnClose = function()
		if (IsValid(bLogs.SearchMenu)) then
			bLogs.SearchMenu:Close()
		end
	end

	m.FullscreenButton = vgui.Create("DImageButton",m)
	m.FullscreenButton:SetSize(12,12)
	if (GetConVar("blogs_fullscreen"):GetBool() == true) then
		m.FullscreenButton:SetIcon("icon16/monitor_lightning.png")
	else
		m.FullscreenButton:SetIcon("icon16/monitor.png")
	end
	m.FullscreenButton:AlignRight(16 + 5)
	m.FullscreenButton:AlignTop(5)
	m.FullscreenButton.DoClick = function()
		GetConVar("blogs_fullscreen"):SetBool(not GetConVar("blogs_fullscreen"):GetBool())
		m:Close()
		bLogs:nets("OpenMenu")
		net.SendToServer()
	end

	m.Tabs = vgui.Create("BTabs",m)
	m.Tabs:SetSize(m:GetWide(),35)
	m.Tabs:AlignTop(24)

		m.LogsPanel = vgui.Create("BTabs_Panel",m)
		m.LogsPanel:SetTabs(m.Tabs)
		m.LogsPanel:SetSize(m:GetWide(),m:GetTall() - 24 - m.Tabs:GetTall())

			m.LogsPanel.LogInfo = vgui.Create("BScrollPanel",m.LogsPanel)
			m.LogsPanel.LogInfo:SetSize(250,m:GetTall() - 59 - 31 - 31)
			m.LogsPanel.LogInfo:AlignRight(0)
			m.LogsPanel.LogInfo:AlignBottom(30)

				m.LogsPanel.LogInfo.Close = vgui.Create("BButton",m.LogsPanel.LogInfo)
				m.LogsPanel.LogInfo.Close:AlignTop(10)
				m.LogsPanel.LogInfo.Close:AlignLeft(10)
				m.LogsPanel.LogInfo.Close:SetSize(230,24)
				m.LogsPanel.LogInfo.Close:SetText("X")
				m.LogsPanel.LogInfo.Close:SetDisabled(true)
				m.LogsPanel.LogInfo.Close.DoClick = function()
					m.LogsPanel.LogInfo.Close:SetDisabled(true)
					m.LogsPanel.Logs:Stop()
					m.LogsPanel.Logs:SizeTo(m.LogsPanel:GetWide() - 200,m:GetTall() - 59 - 31,0.25)
					m.LogsPanel.Logs:ClearSelection()
				end

				m.LogsPanel.LogInfo.FullLogBg = vgui.Create("BPanel",m.LogsPanel.LogInfo)
				m.LogsPanel.LogInfo.FullLogBg:SetWide(230)
				m.LogsPanel.LogInfo.FullLogBg:AlignLeft(10)
				m.LogsPanel.LogInfo.FullLogBg:AlignTop(10 + 24 + 10)
				m.LogsPanel.LogInfo.FullLogBg:SetTooltip(bLogs:t("left_click_to_copy"))
				function m.LogsPanel.LogInfo.FullLogBg:OnMousePressed(c)
					if (c == MOUSE_LEFT) then
						SetClipboardText(m.LogsPanel.LogInfo.FullLog:GetText())
						surface.PlaySound("garrysmod/content_downloaded.wav")
					end
				end
				function m.LogsPanel.LogInfo.FullLogBg:Paint(w,h)
					surface.SetDrawColor(255,255,255)
					surface.DrawRect(0,0,w,h)
					surface.SetDrawColor(0,0,0)
					surface.DrawOutlinedRect(0,0,w,h)
				end

				m.LogsPanel.LogInfo.FullLog = vgui.Create("BLabel",m.LogsPanel.LogInfo)
				m.LogsPanel.LogInfo.FullLog:SetWrap(true)
				m.LogsPanel.LogInfo.FullLog:SetAutoStretchVertical(true)
				m.LogsPanel.LogInfo.FullLog:SetTextColor(Color(0,0,0))
				m.LogsPanel.LogInfo.FullLog:SetWide(220)
				m.LogsPanel.LogInfo.FullLog:AlignLeft(15)
				m.LogsPanel.LogInfo.FullLog:AlignTop(10 + 24 + 10 + 5)
				function m.LogsPanel.LogInfo.FullLog:PaintOver()
					m.LogsPanel.LogInfo.FullLogBg:SetTall(m.LogsPanel.LogInfo.FullLog:GetTall() + 10)
					m.LogsPanel.LogInfo.InvolvedPanel:SetTall(

						m.LogsPanel.LogInfo:GetTall() -
						m.LogsPanel.LogInfo.FullLog:GetTall() -
						m.LogsPanel.LogInfo.Close:GetTall() -
						10 -
						10 -
						10 -
						10 -
						10

					)
					local x,y = m.LogsPanel.LogInfo.FullLog:GetPos()
					m.LogsPanel.LogInfo.InvolvedPanel:AlignTop(15 + m.LogsPanel.LogInfo.FullLog:GetTall() + y)
					m.LogsPanel.LogInfo.InvolvedPanel:AlignLeft(10)
				end

				m.LogsPanel.LogInfo.InvolvedPanels = {}

				m.LogsPanel.LogInfo.InvolvedPanel = vgui.Create("DPanel",m.LogsPanel.LogInfo)
				m.LogsPanel.LogInfo.InvolvedPanel:SetWide(230)
				function m.LogsPanel.LogInfo.InvolvedPanel:Paint() end

			m.LogsPanel.Logs = vgui.Create("bLogs_ListView",m.LogsPanel)
			m.LogsPanel.Logs:SetSize(m.LogsPanel:GetWide() - 200,m:GetTall() - 59 - 31)
			m.LogsPanel.Logs:AlignTop(44)
			m.LogsPanel.Logs:AlignLeft(200)
			m.LogsPanel.Logs:SetMultiSelect(false)
			m.LogsPanel.Logs:AddColumn(bLogs:t("when")):SetFixedWidth(140)
			m.LogsPanel.Logs:AddColumn("Module"):SetFixedWidth(100)
			m.LogsPanel.Logs:AddColumn("Log")

			m.LogsPanel.Logs.OnRowSelected = function(_,i,line)
				if (line:GetValue(3) == bLogs:t("no_data")) then return end
				for i,v in pairs(m.LogsPanel.LogInfo.InvolvedPanels) do
					v:Remove()
				end
				m.LogsPanel.LogInfo.InvolvedPanels = {}
				m.LogsPanel.LogInfo.Close:SetDisabled(false)
				m.LogsPanel.Logs:Stop()
				m.LogsPanel.Logs:SizeTo(m.LogsPanel:GetWide() - 450,m:GetTall() - 59 - 31,0.25)
				m.LogsPanel.LogInfo.FullLog:SetText("[" .. bLogs:FormatLongDate(line.UNIXTime) .. "]\n" .. (line:GetValue(3):gsub("<color=%d+,%d+,%d+,%d+>(.-)</color>","%1")))
				local f = true
				for i,v in pairs(line.Involved) do
					local ip = vgui.Create("DPanel",m.LogsPanel.LogInfo.InvolvedPanel)
					table.insert(m.LogsPanel.LogInfo.InvolvedPanels,ip)
					function ip:Paint(w,h)
						surface.SetDrawColor(Color(255,255,255))
						surface.DrawRect(0,0,w,h)
					end
					ip:SetSize(230,64)
					ip:Dock(TOP)
					if (f) then
						f = nil
					else
						ip:DockMargin(0,10,0,0)
					end
					ip.Avatar = vgui.Create("AvatarImage",ip)
					ip.Avatar:SetSize(64,64)
					ip.Avatar:SetSteamID(i,64)

					ip.OnlineIndicator = vgui.Create("DImage",ip)
					ip.OnlineIndicator:SetSize(16,16)
					ip.OnlineIndicator:AlignRight(5)
					ip.OnlineIndicator:AlignTop(5)
					ip.OnlineIndicator:SetImage("icon16/user_red.png")

					ip.Flag = vgui.Create("DImage",ip)
					ip.Flag:SetSize(16,12)
					ip.Flag:AlignRight(5)
					ip.Flag:AlignTop(5 + 16 + 5)
					ip.Flag:SetImage("flags16/zz.png")
					ip.Flag:SetVisible(false)

					ip.RightContainer = vgui.Create("DPanel",ip)
					ip.RightContainer:SetSize(ip:GetWide() - 64 - (5 + 16 + 5),ip:GetTall())
					ip.RightContainer:AlignRight(5 + 16 + 5)
					function ip.RightContainer:Paint() end

					ip.Name = vgui.Create("BLabel",ip.RightContainer)
					ip.Name:SetTextColor(Color(0,0,0))
					local ply = player.GetBySteamID64(i)
					if (IsValid(ply)) then
						ip.OnlineIndicator:SetImage("icon16/user_green.png")
						ip.Name:SetText(ply:Nick())

						if (ply:GetNWString("blogs_country")) then
							if (file.Exists("materials/flags16/" .. ply:GetNWString("blogs_country"):lower() .. ".png","GAME")) then
								ip.Flag:SetVisible(true)
								ip.Flag:SetImage("flags16/" .. ply:GetNWString("blogs_country"):lower() .. ".png")
							end
						end
					else
						ip.Name:SetText(v)
					end
					ip.Name:SetWide(ip.RightContainer:GetWide() - 20)
					ip.Name:SizeToContentsY()
					ip.Name:SetContentAlignment(5)
					ip.Name:AlignTop(11)
					ip.Name:CenterHorizontal()

					ip.SteamID = vgui.Create("BLabel",ip.RightContainer)
					ip.SteamID:SetTextColor(Color(0,0,0))
					ip.SteamID:SetText(util.SteamIDFrom64(i))
					ip.SteamID:SetWide(ip.RightContainer:GetWide())
					ip.SteamID:SizeToContentsY()
					ip.SteamID:SetContentAlignment(5)
					ip.SteamID:AlignBottom(11)

					ip.Clicker = vgui.Create("BButton",ip)
					ip.Clicker:Dock(FILL)
					ip.Clicker:SetTooltip(bLogs:t("involved_tooltip"))
					ip.Clicker:SetText("")
					function ip.Clicker:Paint() end
					function ip.Clicker:OnMousePressed(key)
						if (key == MOUSE_RIGHT) then
							local o = DermaMenu()
							o:AddOption(bLogs:t("logging"),function() end):SetIcon("icon16/application_view_detail.png")
							o:AddSpacer()
							o:AddOption(bLogs:t("profile"),function()
								gui.OpenURL("https://steamcommunity.com/profiles/" .. i)
								surface.PlaySound("garrysmod/content_downloaded.wav")
							end):SetIcon("icon16/user_gray.png")
							o:AddOption(bLogs:t("copy"):format("Name"),function()
								SetClipboardText(v)
								surface.PlaySound("garrysmod/content_downloaded.wav")
							end):SetIcon("icon16/vcard.png")
							o:AddOption(bLogs:t("copy"):format("SteamID"),function()
								SetClipboardText(util.SteamIDFrom64(i))
								surface.PlaySound("garrysmod/content_downloaded.wav")
							end):SetIcon("icon16/page_copy.png")
							o:AddOption(bLogs:t("copy"):format("SteamID64"),function()
								SetClipboardText(i)
								surface.PlaySound("garrysmod/content_downloaded.wav")
							end):SetIcon("icon16/page_copy.png")
							o:AddOption(bLogs:t("view_player_logs"),function()
								m.LogsPanel.LogInfo.Close.DoClick()
								m.LogsPanel.Logs:Clear()
								m.LogsPanel.Logs.StoredLogs = {}
								m.LogsPanel.Logs.StoredSearchLogs = {}
								m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
								m.LogsPanel.Logs.Page = 1
								m.LogsPanel.Logs.Query = '"player":' .. json_e(i)
								bLogs:nets("SelectLogs")
									net.WriteString(m.LogsPanel.Logs.Query)
									net.WriteInt(m.LogsPanel.Logs.Page,32)
								net.SendToServer()
								surface.PlaySound("garrysmod/content_downloaded.wav")
							end):SetIcon("icon16/user_comment.png")

							if (ulx) then
								o:AddSpacer()
								o:AddOption("ULX",function() end):SetIcon("icon16/shield.png")
								o:AddSpacer()
								o:AddOption("Go to",function()
									RunConsoleCommand("ulx","goto",util.SteamIDFrom64(i))
								end):SetIcon("icon16/lightning_go.png")
								o:AddOption("Bring",function()
									RunConsoleCommand("ulx","bring",util.SteamIDFrom64(i))
								end):SetIcon("icon16/lightning_add.png")
								o:AddOption("Spectate",function()
									RunConsoleCommand("ulx","spectate",util.SteamIDFrom64(i))
								end):SetIcon("icon16/eye.png")
							end

							o:Open()
						end
					end
				end
			end

			m.LogsPanel.Logs.Page = 1
			m.LogsPanel.Logs.PageNum = "?"

			m.LogsPanel.Pagination = vgui.Create("BPanel",m.LogsPanel)
			m.LogsPanel.Pagination:SetSize(m.LogsPanel:GetWide() - 200,31)
			m.LogsPanel.Pagination:AlignLeft(200)
			m.LogsPanel.Pagination:AlignBottom(0)

				m.LogsPanel.Pagination.Prev = vgui.Create("BButton",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Prev:SetText("<")
				m.LogsPanel.Pagination.Prev:SetSize(24,20)
				m.LogsPanel.Pagination.Prev:DockMargin(5,5,5,5)
				m.LogsPanel.Pagination.Prev:Dock(LEFT)
				m.LogsPanel.Pagination.Prev.DoClick = function()
					if (not tonumber(m.LogsPanel.Logs.PageNum)) then return end
					if (m.LogsPanel.Logs.Page == 1) then return end
					m.LogsPanel.Logs.Page = m.LogsPanel.Logs.Page - 1
					m.LogsPanel.Logs:Clear()
					m.LogsPanel.Logs.StoredLogs = {}
					m.LogsPanel.Logs.StoredSearchLogs = {}
					m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
					bLogs:nets("SelectLogs")
						net.WriteString(m.LogsPanel.Logs.Query)
						net.WriteInt(m.LogsPanel.Logs.Page,32)
					net.SendToServer()
					m.LogsPanel.LogInfo.Close.DoClick()
				end

				m.LogsPanel.Pagination.Status = vgui.Create("BLabel",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Status:SetTextColor(Color(255,255,255))
				m.LogsPanel.Pagination.Status:SetText(bLogs:FormatNumber(m.LogsPanel.Logs.Page) .. "/" .. bLogs:FormatNumber(m.LogsPanel.Logs.PageNum))
				m.LogsPanel.Pagination.Status:SizeToContents()
				m.LogsPanel.Pagination.Status:DockMargin(0,5,0,5)
				m.LogsPanel.Pagination.Status:Dock(LEFT)

				m.LogsPanel.Pagination.Next = vgui.Create("BButton",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Next:SetText(">")
				m.LogsPanel.Pagination.Next:SetSize(24,20)
				m.LogsPanel.Pagination.Next:DockMargin(5,5,0,5)
				m.LogsPanel.Pagination.Next:Dock(LEFT)
				m.LogsPanel.Pagination.Next.DoClick = function()
					if (not tonumber(m.LogsPanel.Logs.PageNum)) then return end
					if (m.LogsPanel.Logs.Page >= m.LogsPanel.Logs.PageNum) then return end
					m.LogsPanel.Logs.Page = m.LogsPanel.Logs.Page + 1
					m.LogsPanel.Logs:Clear()
					m.LogsPanel.Logs.StoredLogs = {}
					m.LogsPanel.Logs.StoredSearchLogs = {}
					m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
					bLogs:nets("SelectLogs")
						net.WriteString(m.LogsPanel.Logs.Query)
						net.WriteInt(m.LogsPanel.Logs.Page,32)
					net.SendToServer()
					m.LogsPanel.LogInfo.Close.DoClick()
				end

				m.LogsPanel.Pagination.Jump = vgui.Create("BButton",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Jump:SetTooltip(bLogs:t("jump_to_date_tooltip"))
				m.LogsPanel.Pagination.Jump:SetText(bLogs:t("jump"))
				m.LogsPanel.Pagination.Jump:SetSize(50,20)
				m.LogsPanel.Pagination.Jump:DockMargin(5,5,5,5)
				m.LogsPanel.Pagination.Jump:Dock(LEFT)
				m.LogsPanel.Pagination.Jump.DoRightClick = function()
					Billy_StringRequest(bLogs:t("jump_to_date"),bLogs:t("type_date"):format(os.date("%d"),os.date("%m"),os.date("%Y")),os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%Y"),function(txt)
						txt = string.Trim(txt)
						if (txt:find("^%d%d/%d%d/%d%d%d%d$")) then
							local d,m,y = txt:match("(%d%d)/(%d%d)/(%d%d%d%d)")
							local months = {31,28,31,30,31,30,31,31,30,31,30,31}
							if (not tonumber(d) or not tonumber(m) or not tonumber(y)) then
								Billy_Message(bLogs:t("error_not_date"):format(os.date("%d"),os.date("%m"),os.date("%Y")),bLogs:t("error"))
								return
							end
							if (is_leap_year(tonumber(y))) then
								months[2] = 29
							end
							if (not months[tonumber(m)]) then
								Billy_Message(bLogs:t("error_not_date"):format(os.date("%d"),os.date("%m"),os.date("%Y")),bLogs:t("error"))
								return
							end
							if (tonumber(d) > months[tonumber(m)]) then
								Billy_Message(bLogs:t("error_not_date"):format(os.date("%d"),os.date("%m"),os.date("%Y")),bLogs:t("error"))
								return
							end
							local t = {
								day = d,
								month = m,
								year = y,
							}
							Billy_StringRequest(bLogs:t("jump_to_time"),bLogs:t("type_time"):format(os.date("%H"),os.date("%M")),os.date("%H") .. ":" .. os.date("%M"),function(txt)
								txt = string.Trim(txt)
								if (txt:find("^%d%d:%d%d$") or txt == "") then
									if (txt ~= "") then
										local h,min = txt:match("(%d%d):(%d%d)")
										if (not tonumber(h) or not tonumber(min)) then
											Billy_Message(bLogs:t("error_not_time"):format(os.date("%H"),os.date("%M")),bLogs:t("error"))
											return
										end
										if (tonumber(h) > 23 or tonumber(min) > 59) then
											Billy_Message(bLogs:t("error_not_time"):format(os.date("%H"),os.date("%M")),bLogs:t("error"))
											return
										end
										t.hour = h
										t.min = min
									else
										t.hour = "23"
										t.min = "59"
									end

									bLogs:nets("jump_to_date")
										net.WriteString(util.TableToJSON(t))
									net.SendToServer()
								else
									Billy_Message(bLogs:t("error_not_time"):format(os.date("%H"),os.date("%M")),bLogs:t("error"))
								end
							end,nil,bLogs:t("jump"),bLogs:t("cancel"))
						else
							Billy_Message(bLogs:t("error_not_date"):format(os.date("%d"),os.date("%m"),os.date("%Y")),bLogs:t("error"))
						end
					end,nil,bLogs:t("jump"),bLogs:t("cancel"))
				end
				m.LogsPanel.Pagination.Jump.DoClick = function()
					if (not tonumber(m.LogsPanel.Logs.PageNum)) then return end
					if (m.LogsPanel.Logs.PageNum == 1) then return end
					Billy_StringRequest(bLogs:t("jump_to_page"),bLogs:t("type_page"):format(m.LogsPanel.Logs.PageNum),"1",function(txt)
						if (tonumber(txt)) then
							if (tonumber(txt) > m.LogsPanel.Logs.PageNum) then
								Billy_Message(bLogs:t("error_over_pagenum"),bLogs:t("error"))
							else
								if (not IsValid(bLogs.Menu)) then return end
								if (not IsValid(m)) then return end
								m.LogsPanel.Logs.Page = tonumber(txt)
								m.LogsPanel.Logs:Clear()
								m.LogsPanel.Logs.StoredLogs = {}
								m.LogsPanel.Logs.StoredSearchLogs = {}
								m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
								bLogs:nets("SelectLogs")
									net.WriteString(m.LogsPanel.Logs.Query)
									net.WriteInt(m.LogsPanel.Logs.Page,32)
								net.SendToServer()
								m.LogsPanel.LogInfo.Close.DoClick()
							end
						else
							Billy_Message(bLogs:t("error_not_num"),bLogs:t("error"))
						end
					end,nil,bLogs:t("jump"),bLogs:t("cancel"))
				end

				m.LogsPanel.Pagination.Help = vgui.Create("BButton",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Help:SetSize(50,20)
				m.LogsPanel.Pagination.Help:DockMargin(0,5,5,5)
				m.LogsPanel.Pagination.Help:Dock(LEFT)
				m.LogsPanel.Pagination.Help:SetTooltip(bLogs:t("help_tooltip"))
				m.LogsPanel.Pagination.Help:SetText(bLogs:t("help"))
				m.LogsPanel.Pagination.Help.DoClick = function()
					gui.OpenURL("https://blogs.gmodsto.re")
				end
				
				if (bLogs.bLogsWebURL) then
					m.LogsPanel.Pagination.bLogsWebLink = vgui.Create("BButton",m.LogsPanel.Pagination)
					m.LogsPanel.Pagination.bLogsWebLink:SetSize(100,20)
					m.LogsPanel.Pagination.bLogsWebLink:DockMargin(0,5,5,5)
					m.LogsPanel.Pagination.bLogsWebLink:Dock(LEFT)
					m.LogsPanel.Pagination.bLogsWebLink:SetTooltip(bLogs:t("open_blogs_web_tooltip"))
					m.LogsPanel.Pagination.bLogsWebLink:SetText(bLogs:t("open_blogs_web"))
					m.LogsPanel.Pagination.bLogsWebLink.DoClick = function()
						gui.OpenURL(bLogs.bLogsWebURL)
					end
				end

				m.LogsPanel.Pagination.ColoursT = vgui.Create("BLabel",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.ColoursT:SetText(bLogs:t("colour_mode"))
				m.LogsPanel.Pagination.ColoursT:SizeToContents()
				m.LogsPanel.Pagination.ColoursT:SetTextColor(Color(255,255,255))
				m.LogsPanel.Pagination.ColoursT:AlignRight(160)
				m.LogsPanel.Pagination.ColoursT:CenterVertical()

				m.LogsPanel.Pagination.Colours = vgui.Create("DCheckBox",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Colours:AlignRight(m.LogsPanel.Pagination.ColoursT:GetWide() + 165)
				m.LogsPanel.Pagination.Colours:CenterVertical()
				m.LogsPanel.Pagination.Colours:SetChecked(bLogs.LocalSettings.colour_mode)
				m.LogsPanel.Pagination.Colours.OnChange = function()
					bLogs.LocalSettings.colour_mode = m.LogsPanel.Pagination.Colours:GetChecked()
					bLogs:UpdateLocalSettings()
					bLogs:nets("SelectLogs")
						net.WriteString(m.LogsPanel.Logs.Query)
						net.WriteInt(m.LogsPanel.Logs.Page,32)
					net.SendToServer()
				end

				m.LogsPanel.Pagination.Language = vgui.Create("DComboBox",m.LogsPanel.Pagination)
				m.LogsPanel.Pagination.Language:SetSize(150,20)
				m.LogsPanel.Pagination.Language:AlignRight(5)
				m.LogsPanel.Pagination.Language:CenterVertical()
				m.LogsPanel.Pagination.Language:AddChoice("English")
				m.LogsPanel.Pagination.Language:SetValue(bLogs.SelectedLanguage)
				m.LogsPanel.Pagination.Language.OnSelect = function(_,__,v)
					if (v == "[Contribute]") then
						gui.OpenURL("https://github.com/WilliamVenner/i18n-scripts")
						m.LogsPanel.Pagination.Language:SetValue(bLogs.SelectedLanguage)
					else
						bLogs.SelectedLanguage = v
						file.Write("blogs_language.txt",v)
						if (v ~= "English") then
							include("blogs/lang/" .. v:sub(1,1):lower() .. v:sub(2) .. ".lua")
						else
							bLogs.Language = nil
						end
						OpenMenu()
					end
				end
				local f = file.Find("blogs/lang/*.lua","LUA")
				for _,v in pairs(f) do
					m.LogsPanel.Pagination.Language:AddChoice(v:sub(1,1):upper() .. (v:sub(2):gsub("%.lua$","")))
				end
				m.LogsPanel.Pagination.Language:AddChoice("[Contribute]")

			m.LogsPanel.Actions = vgui.Create("BPanel",m.LogsPanel)
			m.LogsPanel.Actions:SetSize(m.LogsPanel:GetWide() - 200,24)
			m.LogsPanel.Actions:AlignLeft(200)

					m.LogsPanel.Actions.SearchBox = vgui.Create("BTextBox",m.LogsPanel.Actions)
					m.LogsPanel.Actions.SearchBox:SetSize(170,16)
					m.LogsPanel.Actions.SearchBox:SetPlaceHolder(bLogs:t("quick_search") .. "...")
					m.LogsPanel.Actions.SearchBox:CenterVertical()
					m.LogsPanel.Actions.SearchBox:DockMargin(4,4,4,4)
					m.LogsPanel.Actions.SearchBox:Dock(LEFT)
					m.LogsPanel.Actions.SearchBox:SetTooltip(bLogs:t("search"))
					m.LogsPanel.Actions.SearchBox.OnValueChange = function()
						m.LogsPanel.Logs:Clear()
						m.LogsPanel.Logs.StoredSearchLogs = {}
						if (string.Trim(m.LogsPanel.Actions.SearchBox:GetValue()) == "") then
							for _,v in pairs(m.LogsPanel.Logs.StoredLogs) do
								local i,flog = bLogs:Unformat(v[3])
								local line = bLogs.Menu.LogsPanel.Logs:AddLine(v[1],v[2],(flog:gsub("\n"," .. ")))
								line.UNIXTime = v[4]
								line.Involved = i
								line.RawLog = v[3]
								line.Columns[1]:SetTooltip("Hello")
							end
						else
							local insert = {}
							for _,v in pairs(m.LogsPanel.Logs.StoredLogs) do
								table.insert(m.LogsPanel.Logs.StoredSearchLogs,{v[1],v[2],v[3],v[4]})
								if (v[3]:lower():find(string.PatternSafe(m.LogsPanel.Actions.SearchBox:GetValue():lower()))) then
									table.insert(insert,{v[1],v[2],v[3]})
								end
							end
							for _,v in pairs(insert) do
								local i,flog = bLogs:Unformat(v[3])
								local line = bLogs.Menu.LogsPanel.Logs:AddLine(v[1],v[2],(flog:gsub("\n"," .. ")))
								line.UNIXTime = v[4]
								line.Involved = i
								line.RawLog = v[3]
							end
						end
					end

				m.LogsPanel.Actions.AdvSearch = vgui.Create("BImageButton",m.LogsPanel.Actions)
				m.LogsPanel.Actions.AdvSearch:SetSize(16,16)
				m.LogsPanel.Actions.AdvSearch:SetImage("icon16/magnifier_zoom_in.png")
				m.LogsPanel.Actions.AdvSearch:CenterVertical()
				m.LogsPanel.Actions.AdvSearch:DockMargin(0,4,4,4)
				m.LogsPanel.Actions.AdvSearch:Dock(LEFT)
				m.LogsPanel.Actions.AdvSearch:SetTooltip(bLogs:t("advanced_search"))
				m.LogsPanel.Actions.AdvSearch.DoClick = function()
					OpenSearch()
				end

				m.LogsPanel.Actions.SteamIDFinder = vgui.Create("BImageButton",m.LogsPanel.Actions)
				m.LogsPanel.Actions.SteamIDFinder:SetSize(16,16)
				m.LogsPanel.Actions.SteamIDFinder:SetImage("icon16/tag_blue.png")
				m.LogsPanel.Actions.SteamIDFinder:CenterVertical()
				m.LogsPanel.Actions.SteamIDFinder:DockMargin(0,4,0,4)
				m.LogsPanel.Actions.SteamIDFinder:Dock(LEFT)
				m.LogsPanel.Actions.SteamIDFinder:SetTooltip(bLogs:t("steamid_finder"))
				m.LogsPanel.Actions.SteamIDFinder.DoClick = function()
					gui.OpenURL("https://steamid.venner.io/?q=" .. LocalPlayer():SteamID64())
				end

			m.LogsPanel.ActionsOverlay = vgui.Create("BPanel",m.LogsPanel)
			m.LogsPanel.ActionsOverlay:SetSize(m.LogsPanel:GetWide() - 200,24)
			m.LogsPanel.ActionsOverlay:AlignLeft(200)
			m.LogsPanel.ActionsOverlay:AlignTop(20)

			m.LogsPanel.ActionsOverlay.Text = vgui.Create("BListViewLabel",m.LogsPanel.ActionsOverlay)
			m.LogsPanel.ActionsOverlay.Text:Dock(FILL)
			m.LogsPanel.ActionsOverlay.Text:SetTextColor(Color(255,255,255))

			m.LogsPanel.PlayerLookup = vgui.Create("bLogs_ListView",m.LogsPanel)
			m.LogsPanel.PlayerLookup:SetSize(m.LogsPanel:GetWide() - 200,m.LogsPanel:GetTall())
			m.LogsPanel.PlayerLookup:AlignTop(0)
			m.LogsPanel.PlayerLookup:AlignLeft(200)
			m.LogsPanel.PlayerLookup:SetMultiSelect(false)
			m.LogsPanel.PlayerLookup:AddColumn("Online"):SetFixedWidth(55)
			m.LogsPanel.PlayerLookup:AddColumn("SteamID")
			m.LogsPanel.PlayerLookup:AddColumn("Player")
			if (bLogs:HasAccess(LocalPlayer(),"IPAddresses")) then
				m.LogsPanel.PlayerLookup:AddColumn("IP Address")
			end
			m.LogsPanel.PlayerLookup.OnClickLine = function(_,line)
				local menu = DermaMenu()
				menu:AddOption(bLogs:t("copy"):format("IP Address"),function()
					SetClipboardText(line:GetValue(4))
					surface.PlaySound("garrysmod/content_downloaded.wav")
				end):SetIcon("icon16/page_copy.png")
				menu:AddOption(bLogs:t("copy"):format("SteamID"),function()
					SetClipboardText(line:GetValue(2))
					surface.PlaySound("garrysmod/content_downloaded.wav")
				end):SetIcon("icon16/page_copy.png")
				menu:AddOption(bLogs:t("profile"),function()
					gui.OpenURL("https://steamcommunity.com/profiles/" .. util.SteamIDTo64(line:GetValue(2)))
					surface.PlaySound("garrysmod/content_downloaded.wav")
				end):SetIcon("icon16/user.png")
				menu:Open()
			end
			m.LogsPanel.PlayerLookup:SetVisible(false)

			m.LogsPanel.Categories = vgui.Create("BCategories",m.LogsPanel)
			m.LogsPanel.Categories:SetSize(200,m:GetTall() - 59)
			m.LogsPanel.Categories:AlignTop(0)

			m.LogsPanel.Categories:NewCategory("bLogs",Color(160,116,196))
			m.LogsPanel.Categories:NewItem(bLogs:t("all_logs"),Color(160,116,196),function()
				m.LogsPanel.PlayerLookup:SetVisible(false)

				m.LogsPanel.Logs.Page = 1
				m.LogsPanel.Logs.Query = ""

				m.LogsPanel.LogInfo.Close.DoClick()
				m.LogsPanel.Logs:Clear()
				m.LogsPanel.Logs.StoredLogs = {}
				m.LogsPanel.Logs.StoredSearchLogs = {}
				m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
				bLogs:nets("SelectLogs")
					net.WriteString(m.LogsPanel.Logs.Query)
					net.WriteInt(m.LogsPanel.Logs.Page,32)
				net.SendToServer()
			end)
			m.LogsPanel.Categories:NewItem(bLogs:t("archive"),Color(160,116,196),function()
				m.LogsPanel.PlayerLookup:SetVisible(false)
				
				m.LogsPanel.Logs.Page = 1
				m.LogsPanel.Logs.Query = '"archive":true'

				m.LogsPanel.LogInfo.Close.DoClick()
				m.LogsPanel.Logs:Clear()
				m.LogsPanel.Logs.StoredLogs = {}
				m.LogsPanel.Logs.StoredSearchLogs = {}
				m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
				bLogs:nets("SelectLogs")
					net.WriteString(m.LogsPanel.Logs.Query)
					net.WriteInt(m.LogsPanel.Logs.Page,32)
				net.SendToServer()
			end)

			m.LogsPanel.Categories:NewItem(bLogs:t("player_lookup"),Color(160,116,196),function()
				m.LogsPanel.PlayerLookup:SetVisible(true)
				bLogs:nets("playerlookup")
					net.WriteString(m.LogsPanel.Logs.Query)
					net.WriteInt(m.LogsPanel.Logs.Page,32)
				net.SendToServer()
			end)

			local cats  = {}
			local cats_ = {}
			for i,v in pairs(bLogs.Modules) do
				if (v.Enabled) then
					if (not cats[v.Category]) then
						cats[v.Category] = {}
					end
					table.insert(cats[v.Category],v.Name)
				end
			end
			for v in pairs(cats) do
				table.sort(cats[v])
			end
			for i,v in pairs(cats) do
				local added_cat = false
				for _,_v in pairs(v) do
					local c = bLogs.Modules[i .. "_" .. _v]
					if (bLogs:HasAccess(LocalPlayer(),i .. "_" .. _v)) then
						if (added_cat == false) then
							added_cat = true
							m.LogsPanel.Categories:NewCategory(i,bLogs.Modules[i .. "_" .. v[1]].Colour)
						end
						m.LogsPanel.Categories:NewItem(c.Name,c.Colour,function()
							m.LogsPanel.PlayerLookup:SetVisible(false)
							m.LogsPanel.Logs.Query = '"module":' .. json_e(i .. "_" .. c.Name)
							m.LogsPanel.LogInfo.Close.DoClick()
							m.LogsPanel.Logs:Clear()
							m.LogsPanel.Logs.StoredLogs = {}
							m.LogsPanel.Logs.StoredSearchLogs = {}
							m.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
							bLogs:nets("SelectLogs")
								net.WriteString(m.LogsPanel.Logs.Query)
								net.WriteInt(m.LogsPanel.Logs.Page,32)
							net.SendToServer()
						end)
					end
				end
			end

	m.Tabs:AddTab("Logs",m.LogsPanel)

	if (admin_mode) then
		m.AdminPanel = vgui.Create("BTabs_Panel",m)
		m.AdminPanel:SetTabs(m.Tabs)
		m.AdminPanel:SetSize(m:GetWide(),m:GetTall() - 24 - m.Tabs:GetTall())

		if (math.random(1,1000) == 1) then
			-- you have been blessed by the 1 in 1000 chance african man
			http.Fetch("http://gmodsto.re/i_want_to_die.png",function(body,len)
				if (len == 0) then return end
				file.Write("i_want_to_die.png",body)
				m.AdminPanel.I_Want_To_Fucking_Die = vgui.Create("DImage",m.AdminPanel)
				m.AdminPanel.I_Want_To_Fucking_Die:SetSize(m.AdminPanel:GetWide() - 200,m.AdminPanel:GetTall())
				m.AdminPanel.I_Want_To_Fucking_Die:AlignRight()
				m.AdminPanel.I_Want_To_Fucking_Die:SetImage("../data/i_want_to_die.png")
				m.AdminPanel.I_Want_To_Fucking_Die:SetZPos(-1)
				file.Delete("i_want_to_die.png")
			end)
		end

		m.AdminPanel.Categories = vgui.Create("BCategories",m.AdminPanel)
		m.AdminPanel.Categories:SetSize(200,m:GetTall() - 59)
		m.AdminPanel.Categories:AlignTop(0)

		m.AdminPanel.Categories:NewCategory("Admin",Color(150,0,255))
		m.AdminPanel.Categories:NewItem(bLogs:t("operations"),Color(150,0,255),function()
			m.AdminPanel.OperationsPanel:SetVisible(true)
			m.AdminPanel.PlayerFormatPanel:SetVisible(false)
			m.AdminPanel.GeneralSettingsPanel:SetVisible(false)
			m.AdminPanel.PermissionsPanel:SetVisible(false)
			m.AdminPanel.ModulesPanel:SetVisible(false)
		end)
		m.AdminPanel.Categories:NewItem("Modules",Color(0,255,0),function()
			m.AdminPanel.OperationsPanel:SetVisible(false)
			m.AdminPanel.PlayerFormatPanel:SetVisible(false)
			m.AdminPanel.GeneralSettingsPanel:SetVisible(false)
			m.AdminPanel.PermissionsPanel:SetVisible(false)
			m.AdminPanel.ModulesPanel:SetVisible(true)
		end)
		m.AdminPanel.Categories:NewItem(bLogs:t("general_settings"),Color(0,255,255),function()
			m.AdminPanel.OperationsPanel:SetVisible(false)
			m.AdminPanel.PlayerFormatPanel:SetVisible(false)
			m.AdminPanel.GeneralSettingsPanel:SetVisible(true)
			m.AdminPanel.PermissionsPanel:SetVisible(false)
			m.AdminPanel.ModulesPanel:SetVisible(false)
		end)
		m.AdminPanel.Categories:NewItem(bLogs:t("permissions"),Color(255,0,0),function()
			m.AdminPanel.OperationsPanel:SetVisible(false)
			m.AdminPanel.PlayerFormatPanel:SetVisible(false)
			m.AdminPanel.GeneralSettingsPanel:SetVisible(false)
			m.AdminPanel.PermissionsPanel:SetVisible(true)
			m.AdminPanel.ModulesPanel:SetVisible(false)
		end)
		m.AdminPanel.Categories:NewItem(bLogs:t("player_format"),Color(255,125,0),function()
			m.AdminPanel.OperationsPanel:SetVisible(false)
			m.AdminPanel.PlayerFormatPanel:SetVisible(true)
			m.AdminPanel.GeneralSettingsPanel:SetVisible(false)
			m.AdminPanel.PermissionsPanel:SetVisible(false)
			m.AdminPanel.ModulesPanel:SetVisible(false)
		end)
		m.AdminPanel.Categories:NewItem(bLogs:t("support"),Color(0,150,255),function()
			gui.OpenURL("https://support.gmodsto.re/")
		end)

		m.AdminPanel.PlayerFormatPanel = vgui.Create("DScrollPanel",m.AdminPanel)
		m.AdminPanel.PlayerFormatPanel:SetSize(m:GetWide() - 200,m.AdminPanel:GetTall())
		m.AdminPanel.PlayerFormatPanel:AlignRight()
		m.AdminPanel.PlayerFormatPanel:SetVisible(false)
		function m.AdminPanel.PlayerFormatPanel:Paint() end

			for i,v in pairs({

				{name = "Team",
				desc  = "Shows the player's team in the logs. This could be their DarkRP Job, TTT role, Breach role, etc.",
				key   = "Team"},

				{name = "Usergroup",
				desc  = "Shows the player's usergroup in the logs. This is their rank in admin mods.",
				key   = "Usergroup"},

				{name = "Weapon",
				desc  = "Shows the player's weapon in the logs.",
				key   = "Weapon"},

				{name = "Health",
				desc  = "Shows the player's health in the logs.",
				key   = "Health"},

				{name = "Armour",
				desc  = "Shows the player's armour in the logs.",
				key   = "Armour"},

			}) do

				local y = 10 + ((i - 1) * (15 + 16 + 5 + 10))

				local checkbox = vgui.Create("DCheckBox",m.AdminPanel.PlayerFormatPanel)
				checkbox:AlignLeft(10)
				checkbox:AlignTop(y)
				checkbox:SetValue(bLogs.InGameConfig.Info[v.key])
				function checkbox:OnChange(val)
					bLogs:nets("update_player_format")
						net.WriteString(v.key)
						net.WriteBool(val)
					net.SendToServer()
				end

				local title = vgui.Create("BLabel",m.AdminPanel.PlayerFormatPanel)
				title:SetText(v.name)
				title:SizeToContents()
				title:AlignLeft(10 + 15 + 10)
				title:AlignTop(y - 1)

				local desc = vgui.Create("BLabel",m.AdminPanel.PlayerFormatPanel)
				desc:SetText(v.desc)
				desc:SizeToContents()
				desc:AlignLeft(10 + 15 + 10)
				desc:AlignTop(y + 16 + 5 - 1)

			end

		m.AdminPanel.GeneralSettingsPanel = vgui.Create("DScrollPanel",m.AdminPanel)
		m.AdminPanel.GeneralSettingsPanel:SetSize(m:GetWide() - 200,m.AdminPanel:GetTall())
		m.AdminPanel.GeneralSettingsPanel:AlignRight()
		m.AdminPanel.GeneralSettingsPanel:SetVisible(false)
		function m.AdminPanel.GeneralSettingsPanel:Paint() end

		local xy = 0

		for i,v in pairs({

			{name = "AutoDelete Enabled",
			type  = "bool",
			desc  = "Whether AutoDelete is enabled or not.",
			key   = "AutoDeleteEnabled"},

			{name = "AutoDelete",
			type  = "number",
			desc  = "How many days should logs in the archive be deleted after? Note: If you are not using MySQL, the archive clears itself after every OTHER server restart.",
			key   = "AutoDelete"},

			{name = "VolatileLogs",
			type  = "bool",
			desc  = "Should logs be completely wiped every time the server starts?",
			key   = "VolatileLogs"},

			{name = "DisableServerLog",
			type  = "bool",
			desc  = "Should ServerLogs in server console be hidden?",
			key   = "DisableServerLog"},

			{name = "DisableDarkRPLog",
			type  = "bool",
			desc  = "Should DarkRP console logs in player consoles be hidden?",
			key   = "DisableDarkRPLog"},

		}) do

			local y = 10 + ((i - 1) * (15 + 16 + 5 + 10)) + xy

			if (v.type == "bool") then

				local checkbox = vgui.Create("DCheckBox",m.AdminPanel.GeneralSettingsPanel)
				checkbox:AlignLeft(10)
				checkbox:AlignTop(y)
				checkbox:SetValue(bLogs.InGameConfig.General[v.key])
				function checkbox:OnChange(val)
					bLogs:nets("update_general_config")
						net.WriteString(v.key)
						net.WriteBool(val)
					net.SendToServer()
				end
				checkbox:SetChecked(bLogs.InGameConfig.General[v.key])

				local title = vgui.Create("BLabel",m.AdminPanel.GeneralSettingsPanel)
				title:SetText(v.name)
				title:SizeToContents()
				title:AlignLeft(10 + 15 + 10)
				title:AlignTop(y - 1)

				local desc = vgui.Create("BLabel",m.AdminPanel.GeneralSettingsPanel)
				desc:SetText(v.desc)
				desc:SizeToContents()
				desc:AlignLeft(10 + 15 + 10)
				desc:AlignTop(y + 16 + 5 - 1)

			elseif (v.type == "number") then

				local save

				local slider = vgui.Create("DNumSlider",m.AdminPanel.GeneralSettingsPanel)
				slider:SetValue(bLogs.InGameConfig.Info[v.key])
				slider:SetMin(0)
				slider:SetMax(120)
				slider:SetDecimals(0)
				slider:SetSize(350,20)
				slider:AlignLeft(10)
				slider:AlignTop(y - 1)
				slider:SetText(v.name)
				slider.Label:SetFont("BVGUI_roboto16")
				slider.Label:SetTextColor(Color(0,0,0))
				slider:SetValue(bLogs.InGameConfig.General[v.key])
				function slider:OnValueChanged(val)
					save:SetDisabled(false)
				end

				local desc = vgui.Create("BLabel",m.AdminPanel.GeneralSettingsPanel)
				desc:SetText(v.desc)
				desc:SizeToContents()
				desc:AlignLeft(10 + 15 + 10)
				desc:AlignTop(y + 16 + 5 - 1)

				save = vgui.Create("BButton",m.AdminPanel.GeneralSettingsPanel)
				save:SetSize(75,23)
				save:SetText(bLogs:t("save"))
				save:AlignLeft(10 + 15 + 10)
				save:AlignTop(y + 16 + 5 + 16 + 5 - 1)
				save:SetDisabled(true)
				save.DoClick = function()
					bLogs:nets("update_general_config_num")
						net.WriteString(v.key)
						net.WriteInt(slider:GetValue(),32)
					net.SendToServer()
					save:SetDisabled(true)
				end

				xy = xy + 16 + 10

			end

		end

		m.AdminPanel.ModulesPanel = vgui.Create("DScrollPanel",m.AdminPanel)
		m.AdminPanel.ModulesPanel:SetSize(m:GetWide() - 200,m.AdminPanel:GetTall())
		m.AdminPanel.ModulesPanel:AlignRight()
		m.AdminPanel.ModulesPanel:SetVisible(false)
		function m.AdminPanel.ModulesPanel:Paint() end

			m.AdminPanel.ModulesPanel.ModulesList = vgui.Create("BListView",m.AdminPanel.ModulesPanel)
			m.AdminPanel.ModulesPanel.ModulesList:SetSize(250,m.AdminPanel.ModulesPanel:GetTall() - 20)
			m.AdminPanel.ModulesPanel.ModulesList:AddColumn(bLogs:t("modules"))
			m.AdminPanel.ModulesPanel.ModulesList:AlignLeft(10)
			m.AdminPanel.ModulesPanel.ModulesList:AlignTop(10)
			m.AdminPanel.ModulesPanel.ModulesList:SetMultiSelect(false)
			m.AdminPanel.ModulesPanel.ModulesList.OnRowSelected = function()
				local l = m.AdminPanel.ModulesPanel.ModulesList:GetLine(m.AdminPanel.ModulesPanel.ModulesList:GetSelectedLine()).Key
				m.AdminPanel.ModulesPanel.SettingsContainerOverlay:SetVisible(false)
				m.AdminPanel.ModulesPanel.SettingsContainer.ModuleDisabled:SetChecked(bLogs.InGameConfig.ModulesDisabled[l] or false)
				m.AdminPanel.ModulesPanel.SettingsContainer.PrintToConsole:SetChecked(bLogs.InGameConfig.PrintToConsole[l] or false)
				m.AdminPanel.ModulesPanel.SettingsContainer.SendToDiscord:SetChecked(bLogs.InGameConfig.SendToDiscord[l] or false)
			end

			m.AdminPanel.ModulesPanel.SettingsContainer = vgui.Create("BPanel",m.AdminPanel.ModulesPanel)
			m.AdminPanel.ModulesPanel.SettingsContainer:SetSize(m.AdminPanel.ModulesPanel:GetWide() - 250 - 30,m.AdminPanel.ModulesPanel:GetTall() - 20)
			m.AdminPanel.ModulesPanel.SettingsContainer:AlignLeft(10 + 250 + 10)
			m.AdminPanel.ModulesPanel.SettingsContainer:AlignTop(10)
			function m.AdminPanel.ModulesPanel.SettingsContainer:Paint(w,h)
				surface.SetDrawColor(Color(240,240,240))
				surface.DrawRect(0,0,w,h)

				surface.SetDrawColor(Color(0,0,0))
				surface.DrawOutlinedRect(0,0,w,h)
			end

				xy = 0

				for i,v in pairs({

					{name = "Module Disabled",
					type  = "bool",
					desc  = "If checked, this module won't be loaded.",
					key   = "ModuleDisabled"},

					{name = "Print to Console",
					type  = "bool",
					desc  = "If checked, this module will be printed to admins' consoles.",
					key   = "PrintToConsole"},

					{name = "Send to Discord",
					type  = "bool",
					desc  = "If checked, this module will be printed in the Discord chat your webhook is linked to.\nDo not send spammy logs to Discord! They will be rate limited.\nThis requires the Discord Relay DLC to work.",
					key   = "SendToDiscord"},

				}) do

					local y = 10 + ((i - 1) * (15 + 16 + 5 + 10)) + xy

					if (v.type == "bool") then

						local checkbox = vgui.Create("DCheckBox",m.AdminPanel.ModulesPanel.SettingsContainer)
						checkbox:AlignLeft(10)
						checkbox:AlignTop(y)
						checkbox:SetValue(bLogs.InGameConfig.General[v.key])
						function checkbox:OnChange(val)
							bLogs:nets("update_general_config")
								net.WriteString(v.key)
								net.WriteBool(val)
							net.SendToServer()
						end
						m.AdminPanel.ModulesPanel.SettingsContainer[v.key] = checkbox
						if (v.key == "ModuleDisabled") then
							function m.AdminPanel.ModulesPanel.SettingsContainer.ModuleDisabled:OnChange()
								bLogs:nets("update_modules")
									net.WriteString(m.AdminPanel.ModulesPanel.ModulesList:GetLine(m.AdminPanel.ModulesPanel.ModulesList:GetSelectedLine()).Key)
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.ModuleDisabled:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.PrintToConsole:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.SendToDiscord:GetChecked())
								net.SendToServer()
							end
						elseif (v.key == "PrintToConsole") then
							function m.AdminPanel.ModulesPanel.SettingsContainer.PrintToConsole:OnChange()
								bLogs:nets("update_modules")
									net.WriteString(m.AdminPanel.ModulesPanel.ModulesList:GetLine(m.AdminPanel.ModulesPanel.ModulesList:GetSelectedLine()).Key)
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.ModuleDisabled:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.PrintToConsole:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.SendToDiscord:GetChecked())
								net.SendToServer()
							end
						elseif (v.key == "SendToDiscord") then
							function m.AdminPanel.ModulesPanel.SettingsContainer.SendToDiscord:OnChange()
								bLogs:nets("update_modules")
									net.WriteString(m.AdminPanel.ModulesPanel.ModulesList:GetLine(m.AdminPanel.ModulesPanel.ModulesList:GetSelectedLine()).Key)
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.ModuleDisabled:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.PrintToConsole:GetChecked())
									net.WriteBool(m.AdminPanel.ModulesPanel.SettingsContainer.SendToDiscord:GetChecked())
								net.SendToServer()
							end
						end

						local title = vgui.Create("BLabel",m.AdminPanel.ModulesPanel.SettingsContainer)
						title:SetText(v.name)
						title:SizeToContents()
						title:AlignLeft(10 + 15 + 10)
						title:AlignTop(y - 1)

						local desc = vgui.Create("BLabel",m.AdminPanel.ModulesPanel.SettingsContainer)
						desc:SetText(v.desc)
						desc:SizeToContents()
						desc:AlignLeft(10 + 15 + 10)
						desc:AlignTop(y + 16 + 5 - 1)

					end

				end

			m.AdminPanel.ModulesPanel.SettingsContainerOverlay = vgui.Create("BPanel",m.AdminPanel.ModulesPanel.SettingsContainer)
			m.AdminPanel.ModulesPanel.SettingsContainerOverlay:Dock(FILL)
			m.AdminPanel.ModulesPanel.SettingsContainerOverlay:AlignLeft(10 + 250 + 10)
			m.AdminPanel.ModulesPanel.SettingsContainerOverlay:AlignTop(10)
			function m.AdminPanel.ModulesPanel.SettingsContainerOverlay:Paint(w,h)
				surface.SetDrawColor(Color(0,0,0,230))
				surface.DrawRect(0,0,w,h)

				surface.SetDrawColor(Color(0,0,0))
				surface.DrawOutlinedRect(0,0,w,h)
			end

			for i,v in pairs(bLogs.Modules) do
				m.AdminPanel.ModulesPanel.ModulesList:AddLine(v.Category .. ": " .. v.Name).Key = i
			end
			m.AdminPanel.ModulesPanel.ModulesList:SortByColumn(1)

		m.AdminPanel.PermissionsPanel = vgui.Create("DScrollPanel",m.AdminPanel)
		m.AdminPanel.PermissionsPanel:SetSize(m:GetWide() - 200,m.AdminPanel:GetTall())
		m.AdminPanel.PermissionsPanel:AlignRight()
		m.AdminPanel.PermissionsPanel:SetVisible(false)
		function m.AdminPanel.PermissionsPanel:Paint() end

			m.AdminPanel.PermissionsPanel.Usergroups = vgui.Create("BListView",m.AdminPanel.PermissionsPanel)
			m.AdminPanel.PermissionsPanel.Usergroups:AddColumn("Usergroups")
			m.AdminPanel.PermissionsPanel.Usergroups:SetSize(250,m.AdminPanel.ModulesPanel:GetTall() - 20 - 25 - 10)
			m.AdminPanel.PermissionsPanel.Usergroups:AlignLeft(10)
			m.AdminPanel.PermissionsPanel.Usergroups:AlignTop(10)
			m.AdminPanel.PermissionsPanel.Usergroups:SetMultiSelect(false)

			m.AdminPanel.PermissionsPanel.Delete = vgui.Create("BButton",m.AdminPanel.PermissionsPanel)
			m.AdminPanel.PermissionsPanel.Delete:SetSize(250,25)
			m.AdminPanel.PermissionsPanel.Delete:AlignTop(10 + m.AdminPanel.PermissionsPanel.Usergroups:GetTall() + 10)
			m.AdminPanel.PermissionsPanel.Delete:AlignLeft(10)
			m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)
			m.AdminPanel.PermissionsPanel.Delete:SetText(bLogs:t("delete_entry"))
			m.AdminPanel.PermissionsPanel.Delete.DoClick = function()
				bLogs:nets("permissions_delete")
					net.WriteString(m.AdminPanel.PermissionsPanel.Usergroups:GetLine(m.AdminPanel.PermissionsPanel.Usergroups:GetSelectedLine()):GetValue(1))
				net.SendToServer()
				m.AdminPanel.PermissionsPanel.Usergroups:RemoveLine(m.AdminPanel.PermissionsPanel.Usergroups:GetSelectedLine())
				m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)
				m.AdminPanel.PermissionsPanel.Add:SetDisabled(true)
				m.AdminPanel.PermissionsPanel.Remove:SetDisabled(true)
				m.AdminPanel.PermissionsPanel.Allowed:Clear()
				m.AdminPanel.PermissionsPanel.Forbidden:Clear()
			end

				for i,v in pairs(team.GetAllTeams()) do
					if (v.Name == "Unassigned" or v.Name == "Joining/Connecting" or (DarkRP and v.Name == "Spectator")) then continue end
					if (DarkRP) then
						m.AdminPanel.PermissionsPanel.Usergroups:AddLine("Job: " .. v.Name).i = i
					else
						m.AdminPanel.PermissionsPanel.Usergroups:AddLine("Team: " .. v.Name).i = i
					end
				end
				if (DarkRP) then
					for i in pairs(bLogs.InGameConfig.Permissions.Jobs) do
						local f = false
						for x,v in pairs(RPExtraTeams) do
							if (v.name == i) then
								f = true
								break
							end
						end
						if (not f) then
							m.AdminPanel.PermissionsPanel.Usergroups:AddLine("Job: " .. i).Team = x
						end
					end
				end
				local c_store
				if (CAMI) then
					c_store = CAMI.GetUsergroups()
					for i,v in pairs(c_store) do
						m.AdminPanel.PermissionsPanel.Usergroups:AddLine("CAMI: " .. v.Name)
					end
				end
				for i in pairs(bLogs.InGameConfig.Permissions.SteamIDs) do
					m.AdminPanel.PermissionsPanel.Usergroups:AddLine("SteamID: " .. i)
				end
				for i in pairs(bLogs.InGameConfig.Permissions.Usergroups) do
					if (c_store) then
						local y = false
						for _,x in pairs(c_store) do
							if (x.Name == i) then
								y = true
								break
							end
						end
						if (y) then
							continue
						end
					end
					m.AdminPanel.PermissionsPanel.Usergroups:AddLine("Usergroup: " .. i)
				end
				m.AdminPanel.PermissionsPanel.Usergroups:AddLine("## " .. bLogs:t("new_usergroup") .. " #")
				m.AdminPanel.PermissionsPanel.Usergroups:AddLine("## " .. bLogs:t("new_steamid") .. " #")
				m.AdminPanel.PermissionsPanel.Usergroups:SortByColumn(1)

				m.AdminPanel.PermissionsPanel.Usergroups.OnRowSelected = function(__,_,l)
					if (l:GetValue(1) == "## " .. bLogs:t("new_usergroup") .. " #") then

						m.AdminPanel.PermissionsPanel.Usergroups:ClearSelection()

						Billy_StringRequest(bLogs:t("new_usergroup"),bLogs:t("usergroup_name"),LocalPlayer():GetUserGroup(),function(txt)
							if (string.Trim(txt):len() == 0) then return end
							if (bLogs.InGameConfig.Permissions.Usergroups[txt]) then
								Billy_Message(bLogs:t("usergroup_exists"),bLogs:t("error"),"OK")
								return
							end
							bLogs:nets("permissions")
								net.WriteInt(5,16)
								net.WriteString(txt)
							net.SendToServer()
							m.AdminPanel.PermissionsPanel.Usergroups:AddLine("Usergroup: " .. txt)
						end)

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)

					elseif (l:GetValue(1) == "## " .. bLogs:t("new_steamid") .. " #") then

						m.AdminPanel.PermissionsPanel.Usergroups:ClearSelection()

						Billy_StringRequest(bLogs:t("new_steamid"),"SteamID",LocalPlayer():GetUserGroup(),function(txt)
							txt = txt:upper()
							if (string.Trim(txt):len() == 0) then return end
							if (not txt:find("^STEAM_%d:%d:%d+$")) then
								Billy_Message(bLogs:t("error_not_steamid"),bLogs:t("error"))
								return
							end
							if (bLogs.InGameConfig.Permissions.SteamIDs[txt]) then
								Billy_Message(bLogs:t("steamid_exists"),bLogs:t("error"),"OK")
								return
							end
							bLogs:nets("permissions")
								net.WriteInt(6,16)
								net.WriteString(txt)
							net.SendToServer()
							m.AdminPanel.PermissionsPanel.Usergroups:AddLine("SteamID: " .. txt)
						end)

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)

					elseif (l:GetValue(1):sub(1,5) == "Job: " or l:GetValue(1):sub(1,6) == "Team: ") then

						bLogs:nets("permissions")
							net.WriteInt(1,16)
							net.WriteString(l.i)
						net.SendToServer()

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)

					elseif (l:GetValue(1):sub(1,6) == "CAMI: ") then

						bLogs:nets("permissions")
							net.WriteInt(2,16)
							net.WriteString(l:GetValue(1):sub(7))
						net.SendToServer()

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(true)

					elseif (l:GetValue(1):sub(1,9) == "SteamID: ") then

						bLogs:nets("permissions")
							net.WriteInt(3,16)
							net.WriteString(l:GetValue(1):sub(10))
						net.SendToServer()

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(false)

					elseif (l:GetValue(1):sub(1,11) == "Usergroup: ") then

						bLogs:nets("permissions")
							net.WriteInt(4,16)
							net.WriteString(l:GetValue(1):sub(12))
						net.SendToServer()

						m.AdminPanel.PermissionsPanel.Delete:SetDisabled(false)

					end
				end

			m.AdminPanel.PermissionsPanel.Allowed = vgui.Create("BListView",m.AdminPanel.PermissionsPanel)
			m.AdminPanel.PermissionsPanel.Allowed:AddColumn("Has Permission")
			m.AdminPanel.PermissionsPanel.Allowed:SetSize(250,m.AdminPanel.ModulesPanel:GetTall() - 20)
			m.AdminPanel.PermissionsPanel.Allowed:AlignLeft(250 + 10 + 50 + 10 + 40 - 20)
			m.AdminPanel.PermissionsPanel.Allowed:AlignTop(10)
			m.AdminPanel.PermissionsPanel.Allowed.OnRowSelected = function(__,_,l)
				m.AdminPanel.PermissionsPanel.Add:SetDisabled(false)
			end

			m.AdminPanel.PermissionsPanel.Forbidden = vgui.Create("BListView",m.AdminPanel.PermissionsPanel)
			m.AdminPanel.PermissionsPanel.Forbidden:AddColumn("No Permission")
			m.AdminPanel.PermissionsPanel.Forbidden:SetSize(250,m.AdminPanel.ModulesPanel:GetTall() - 20)
			m.AdminPanel.PermissionsPanel.Forbidden:AlignLeft(610 + 25 + 50 + 25 - 20)
			m.AdminPanel.PermissionsPanel.Forbidden:AlignTop(10)
			m.AdminPanel.PermissionsPanel.Forbidden.OnRowSelected = function(__,_,l)
				m.AdminPanel.PermissionsPanel.Remove:SetDisabled(false)
			end

			m.AdminPanel.PermissionsPanel.ButtonContainer = vgui.Create("DPanel",m.AdminPanel.PermissionsPanel)
			m.AdminPanel.PermissionsPanel.ButtonContainer:SetSize(50,23 + 10 + 23)
			m.AdminPanel.PermissionsPanel.ButtonContainer:AlignLeft(610 + 25 - 20)
			m.AdminPanel.PermissionsPanel.ButtonContainer:AlignTop((m.AdminPanel.PermissionsPanel:GetTall() / 2) - (m.AdminPanel.PermissionsPanel.ButtonContainer:GetTall() / 2))
			function m.AdminPanel.PermissionsPanel.ButtonContainer:Paint() end

				m.AdminPanel.PermissionsPanel.Add = vgui.Create("BButton",m.AdminPanel.PermissionsPanel.ButtonContainer)
				m.AdminPanel.PermissionsPanel.Add:SetSize(50,23)
				m.AdminPanel.PermissionsPanel.Add:SetText(">>")
				m.AdminPanel.PermissionsPanel.Add:SetTooltip(bLogs:t("take"))
				m.AdminPanel.PermissionsPanel.Add:SetDisabled(true)
				m.AdminPanel.PermissionsPanel.Add.DoClick = function()
					for _,v in pairs(m.AdminPanel.PermissionsPanel.Allowed:GetSelected()) do
						bLogs:nets("permissions_update")
							net.WriteString(m.AdminPanel.PermissionsPanel.Usergroups:GetLine(m.AdminPanel.PermissionsPanel.Usergroups:GetSelectedLine()):GetValue(1))
							net.WriteString(v:GetValue(1))
							net.WriteBool(false)
						net.SendToServer()
						m.AdminPanel.PermissionsPanel.Forbidden:AddLine(v:GetValue(1))
						for i,x in pairs(m.AdminPanel.PermissionsPanel.Allowed:GetLines()) do
							if (x == v) then
								m.AdminPanel.PermissionsPanel.Allowed:RemoveLine(i)
								break
							end
						end
					end
					m.AdminPanel.PermissionsPanel.Add:SetDisabled(true)
					m.AdminPanel.PermissionsPanel.Allowed:SortByColumn(1)
					m.AdminPanel.PermissionsPanel.Forbidden:SortByColumn(1)
				end

				m.AdminPanel.PermissionsPanel.Remove = vgui.Create("BButton",m.AdminPanel.PermissionsPanel.ButtonContainer)
				m.AdminPanel.PermissionsPanel.Remove:SetSize(50,23)
				m.AdminPanel.PermissionsPanel.Remove:SetText("<<")
				m.AdminPanel.PermissionsPanel.Remove:SetTooltip(bLogs:t("give"))
				m.AdminPanel.PermissionsPanel.Remove:SetDisabled(true)
				m.AdminPanel.PermissionsPanel.Remove:AlignTop(23 + 10)
				m.AdminPanel.PermissionsPanel.Remove.DoClick = function()
					for _,v in pairs(m.AdminPanel.PermissionsPanel.Forbidden:GetSelected()) do
						bLogs:nets("permissions_update")
							net.WriteString(m.AdminPanel.PermissionsPanel.Usergroups:GetLine(m.AdminPanel.PermissionsPanel.Usergroups:GetSelectedLine()):GetValue(1))
							net.WriteString(v:GetValue(1))
							net.WriteBool(true)
						net.SendToServer()
						m.AdminPanel.PermissionsPanel.Allowed:AddLine(v:GetValue(1))
						for i,x in pairs(m.AdminPanel.PermissionsPanel.Forbidden:GetLines()) do
							if (x == v) then
								m.AdminPanel.PermissionsPanel.Forbidden:RemoveLine(i)
								break
							end
						end
					end
					m.AdminPanel.PermissionsPanel.Remove:SetDisabled(true)
					m.AdminPanel.PermissionsPanel.Allowed:SortByColumn(1)
					m.AdminPanel.PermissionsPanel.Forbidden:SortByColumn(1)
				end

		m.AdminPanel.OperationsPanel = vgui.Create("DScrollPanel",m.AdminPanel)
		m.AdminPanel.OperationsPanel:SetSize(m:GetWide() - 200,m.AdminPanel:GetTall())
		m.AdminPanel.OperationsPanel:AlignRight()
		m.AdminPanel.OperationsPanel:SetVisible(false)
		function m.AdminPanel.OperationsPanel:Paint() end

			m.AdminPanel.OperationsPanel.ArchiveLogs = vgui.Create("BButton",m.AdminPanel.OperationsPanel)
			m.AdminPanel.OperationsPanel.ArchiveLogs:SetSize(125,25)
			m.AdminPanel.OperationsPanel.ArchiveLogs:AlignLeft(10)
			m.AdminPanel.OperationsPanel.ArchiveLogs:AlignTop(10)
			m.AdminPanel.OperationsPanel.ArchiveLogs:SetText("Archive Logs")
			m.AdminPanel.OperationsPanel.ArchiveLogs:SetTooltip("Moves all current logs from this session into the archive.")
			m.AdminPanel.OperationsPanel.ArchiveLogs.DoClick = function()
				Billy_Query("Are you sure you want to archive all of the current logs from this session?","Are you sure?","Yes",function()

					bLogs:nets("archive_logs")
					net.SendToServer()

				end,"No")
			end

			m.AdminPanel.OperationsPanel.WipeArchive = vgui.Create("BButton",m.AdminPanel.OperationsPanel)
			m.AdminPanel.OperationsPanel.WipeArchive:SetSize(125,25)
			m.AdminPanel.OperationsPanel.WipeArchive:AlignLeft(10)
			m.AdminPanel.OperationsPanel.WipeArchive:AlignTop(10 + 25 + 10)
			m.AdminPanel.OperationsPanel.WipeArchive:SetText("Wipe Archive")
			m.AdminPanel.OperationsPanel.WipeArchive:SetTooltip("Completely destroys all logs in the archive. I recommend you do this every now and again to save space, or turn on AutoDelete.")
			m.AdminPanel.OperationsPanel.WipeArchive.DoClick = function()
				Billy_Query("Are you sure you want to WIPE all of the logs from the archive?","Are you sure?","Yes",function()

					bLogs:nets("wipe_archive")
					net.SendToServer()

				end,"No")
			end

			m.AdminPanel.OperationsPanel.ResetConfig = vgui.Create("BButton",m.AdminPanel.OperationsPanel)
			m.AdminPanel.OperationsPanel.ResetConfig:SetSize(125,25)
			m.AdminPanel.OperationsPanel.ResetConfig:AlignLeft(10)
			m.AdminPanel.OperationsPanel.ResetConfig:AlignTop(10 + 25 + 10 + 25 + 10)
			m.AdminPanel.OperationsPanel.ResetConfig:SetText("Reset Config")
			m.AdminPanel.OperationsPanel.ResetConfig:SetTooltip("Resets the in-game config back to its default state. This does not affect your config file.")
			m.AdminPanel.OperationsPanel.ResetConfig.DoClick = function()
				Billy_Query("Are you sure you want to RESET the in-game config?","Are you sure?","Yes",function()

					bLogs:nets("reset_config")
					net.SendToServer()

				end,"No")
			end

		m.Tabs:AddTab("Admin",m.AdminPanel)
	end

	m.LogsPanel.Logs.Query = ""
	bLogs:nets("SelectLogs")
		net.WriteString(m.LogsPanel.Logs.Query)
		net.WriteInt(1,32)
	net.SendToServer()

	hook.Run("bLogs_MenuOpened",m)
end
bLogs:netr("OpenMenu",OpenMenu)

if (bLogs.Config.AllowConsoleCommand) then
	concommand.Add("blogs",function()
		bLogs:nets("OpenMenu")
		net.SendToServer()
	end)
end

bLogs:netr("jump_to_date",function()
	local txt = net.ReadInt(32)
	if (not IsValid(bLogs.Menu)) then return end
	bLogs.Menu.LogsPanel.Logs.Page = tonumber(txt)
	bLogs.Menu.LogsPanel.Logs:Clear()
	bLogs.Menu.LogsPanel.Logs.StoredLogs = {}
	bLogs.Menu.LogsPanel.Logs.StoredSearchLogs = {}
	bLogs.Menu.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
	bLogs:nets("SelectLogs")
		net.WriteString(bLogs.Menu.LogsPanel.Logs.Query)
		net.WriteInt(bLogs.Menu.LogsPanel.Logs.Page,32)
	net.SendToServer()
	bLogs.Menu.LogsPanel.LogInfo.Close.DoClick()
end)

local curr_id
local clear
bLogs:netr("start_data_flow",function()
	local pages = net.ReadInt(32)
	bLogs.Menu.LogsPanel.LogInfo.Close.DoClick()
	if (bLogs.Menu.LogsPanel.Logs.Query ~= "") then
		local q = util.JSONToTable("{" .. bLogs.Menu.LogsPanel.Logs.Query .. "}")
		if (q) then
			local b = bLogs:t("searching") .. ": "
			if (q.archive) then
				b = b .. "<color=255,0,0>" .. bLogs:t("archive") .. "</color> "
			end
			if (q.player) then
				if (type(q.player) == "table") then
					if (#q.player == 1) then
						b = b .. "<color=" .. bLogs_PlayerColor .. ">" .. util.SteamIDFrom64(q.player[1]) .. "</color> "
					else
						for i,v in pairs(q.player) do
							if (i == 1) then
								b = b .. "<color=" .. bLogs_PlayerColor .. ">" .. util.SteamIDFrom64(v) .. "</color> "
							else
								b = b .. " <color=" .. bLogs_PlayerColor .. ">" .. util.SteamIDFrom64(v) .. "</color> "
							end
						end
					end
				else
					b = b .. "<color=" .. bLogs_PlayerColor .. ">" .. util.SteamIDFrom64(q.player) .. "</color> "
				end
			end
			if (q.module) then
				if (type(q.module) == "table") then
					if (#q.module == 1) then
						b = b .. "<color=" .. bLogs:MarkupColour(bLogs.Modules[q.module[1]].Colour) .. ">" .. (q.module[1]:gsub("^.-_","")) .. "</color> "
					else
						for i,v in pairs(q.module) do
							if (i == 1) then
								b = b .. "<color=" .. bLogs:MarkupColour(bLogs.Modules[v].Colour) .. ">" .. (v:gsub("^.-_","")) .. "</color> "
							else
								b = b .. " <color=" .. bLogs:MarkupColour(bLogs.Modules[v].Colour) .. ">" .. (v:gsub("^.-_","")) .. "</color> "
							end
						end
					end
				else
					b = b .. "<color=" .. bLogs:MarkupColour(bLogs.Modules[q.module].Colour) .. ">" .. (q.module:gsub("^.-_","")) .. "</color> "
				end
			end
			if (q.search) then
				b = b .. "<color=" .. bLogs_HighlightColor .. ">" .. bLogs:EscapeMarkup(q.search) .. "</color> "
			end
			bLogs.Menu.LogsPanel.ActionsOverlay.Text:SetText(b)
		end
	else
		bLogs.Menu.LogsPanel.ActionsOverlay.Text:SetText("Searching: <color=" .. bLogs_HighlightColor .. ">None</color>")
	end
	bLogs.Menu.LogsPanel.Logs.PageNum = pages
	bLogs.Menu.LogsPanel.Pagination.Status:SetText(bLogs:FormatNumber(bLogs.Menu.LogsPanel.Logs.Page) .. "/" .. bLogs:FormatNumber(bLogs.Menu.LogsPanel.Logs.PageNum))
	bLogs.Menu.LogsPanel.Pagination.Status:SizeToContents()
	if (bLogs.Menu.Tabs:GetSelectedTabID() == 1) then
		bLogs.Menu.LogsPanel.Logs:Clear()
		bLogs.Menu.LogsPanel.Logs:AddLine("","",bLogs:t("loading"))
		clear = true
	elseif (bLogs.Menu.Tabs:GetSelectedTabID() == 2) then
		bLogs.Menu.LogsPanel.Players:Clear()
		bLogs.Menu.LogsPanel.Players:AddLine("","",bLogs:t("loading"))
		clear = true
	end
	curr_id = bLogs.Menu.Tabs:GetSelectedTabID()
end)
bLogs:netr("data",function()
	local module = net.ReadString()
	local log    = net.ReadString()
	local time   = net.ReadInt(32)
	if (clear) then
		clear = nil
		if (bLogs.Menu.Tabs:GetSelectedTabID() == 1) then
			bLogs.Menu.LogsPanel.Logs:Clear()
		elseif (bLogs.Menu.Tabs:GetSelectedTabID() == 2) then
			bLogs.Menu.LogsPanel.Players:Clear()
		end
	end
	if (bLogs.Menu.Tabs:GetSelectedTabID() ~= curr_id) then
		bLogs:nets("last_data")
		net.SendToServer()
		return
	end
	if (bLogs.Menu.Tabs:GetSelectedTabID() == 1) then
		local i,flog = bLogs:Unformat(log)
		local t = bLogs:FormatTime(time)
		local ms = "<color=" .. bLogs:MarkupColour((bLogs.Modules[module] or {Colour = Color(255,0,0)}).Colour) .. ">" .. (string.Explode("_",module))[2] .. "</color>"
		local line = bLogs.Menu.LogsPanel.Logs:AddLine(t,ms,(flog:gsub("\n"," .. ")))
		line.UNIXTime = time
		line.Involved = i
		line.RawLog = log
		bLogs.Menu.LogsPanel.Logs.StoredLogs = bLogs.Menu.LogsPanel.Logs.StoredLogs or {}
		table.insert(bLogs.Menu.LogsPanel.Logs.StoredLogs,{t,ms,log,time})
	end
end)
bLogs:netr("no_data",function()
	if (bLogs.Menu.Tabs:GetSelectedTabID() == 1) then
		bLogs.Menu.LogsPanel.Logs:Clear()
	elseif (bLogs.Menu.Tabs:GetSelectedTabID() == 2) then
		bLogs.Menu.LogsPanel.Players:Clear()
	end
	if (bLogs.Menu.Tabs:GetSelectedTabID() == 1) then
		bLogs.Menu.LogsPanel.Logs:AddLine("","",bLogs:t("no_data"))
	end
end)
bLogs:netr("last_data",function()
	curr_id = nil
end)

bLogs:netr("completed",function()
	Billy_Message("Operation completed.","Success","OK")
end)

bLogs:netr("update_config_broadcast",function()
	local c = net.ReadDouble()
	local d = net.ReadData(c)
	d = util.Decompress(d)
	d = util.JSONToTable(d)

	if (d) then
		bLogs.InGameConfig = d
	end
end)

bLogs:netr("update_modules",function()
	local n = net.ReadDouble()
	local d = net.ReadData(n)
	d = util.Decompress(d)
	d = util.JSONToTable(d)

	bLogs.InGameConfig.ModulesDisabled = d.disabled

	for _,v in pairs(d.disabled) do
		bLogs.Modules[v].Enabled = false
	end
	for _,v in pairs(d.enabled) do
		bLogs.Modules[v].Enabled = true
	end
end)

bLogs:netr("permissions",function()
	if (not IsValid(bLogs.Menu)) then return end

	local n = net.ReadDouble()
	local d = net.ReadData(n)
	d = util.Decompress(d)
	d = util.JSONToTable(d)

	bLogs.Menu.AdminPanel.PermissionsPanel.Allowed:Clear()
	bLogs.Menu.AdminPanel.PermissionsPanel.Forbidden:Clear()

	for i,v in pairs(d) do
		if (i == "Menu") then
			i = "## Open Menu"
		elseif (i == "IPAddresses") then
			i = "## See IP Addresses"
		else
			i = (i:gsub("(.-)_(.-)","%1: %2"))
		end
		if (v == true) then
			bLogs.Menu.AdminPanel.PermissionsPanel.Allowed:AddLine(i)
		else
			bLogs.Menu.AdminPanel.PermissionsPanel.Forbidden:AddLine(i)
		end
	end
	bLogs.Menu.AdminPanel.PermissionsPanel.Allowed:SortByColumn(1)
	bLogs.Menu.AdminPanel.PermissionsPanel.Forbidden:SortByColumn(1)

end)

timer.Create("blogs_update_country",0,10,function()
	if (system.GetCountry()) then
		if (system.GetCountry():len() > 0) then
			bLogs:nets("update_country")
				net.WriteString(system.GetCountry():lower())
			net.SendToServer()
			timer.Remove("blogs_update_country")
		end
	end
end)

bLogs:netr("send_log",function()
	local module = net.ReadString()
	local log = net.ReadString()
	log = (log:gsub("\t","  "))
	local _,newlog = bLogs:Unformat(log)
	newlog = (newlog:gsub("<color=(%d+),(%d+),(%d+),(%d+)>(.-)</color>","\t%1,%2,%3,%5\t"))
	local tbl = {Color(255,255,255),"[",Color(255,0,255),"bLogs",Color(255,255,255),"] "}
	for i,v in pairs(string.Explode("\t",newlog)) do
		if (#v > 0) then
			if ((i / 2) % 1 == 0) then
				local r,g,b,c = v:match("(%d+),(%d+),(%d+),(.*)")
				table.insert(tbl,Color(tonumber(r),tonumber(g),tonumber(b)))
				table.insert(tbl,c)
			else
				table.insert(tbl,Color(255,255,255))
				table.insert(tbl,v)
			end
		end
	end
	table.insert(tbl,"\n")
	MsgC(unpack(tbl))
end)

bLogs:netr("playerlookup",function()
	if (not IsValid(bLogs.Menu)) then return end
	local n = net.ReadDouble()
	local data = net.ReadData(n)
	data = util.Decompress(data)
	data = util.JSONToTable(data)

	bLogs.Menu.LogsPanel.PlayerLookup:Clear()
	for steamid,info in pairs(data) do
		local ply = player.GetBySteamID(steamid)
		local online
		if (IsValid(ply)) then
			online = "Y"
		else
			online = "N"
		end
		bLogs.Menu.LogsPanel.PlayerLookup:AddLine(online,steamid,info.Nick,info.IP_Address)
	end
end)

bLogs:print("Clientside loaded","good")
