--[[

	bLogs Chinese Simplified

	Contributors:

	8Z - STEAM_1:0:33380074
  
]]

bLogs.Language = {

	-- First column in the logs, shows the date/time of the log
	when = "时间",

	permission_failure = "你没有权限这么做。",

	-- When the user is an admin, this will be in the window title.
	admin_mode = "管理模式",

	-- The button to view all logs stored.
	all_logs = "所有记录",

	-- The button to view all players stored in bLogs.
	all_players = "所有玩家",

	-- The tab at the top to view players stored in bLogs.
	players = "玩家",

	-- The message shown to the player when they first open bLogs.
	getting_data = "Getting data, please wait...",

	-- The message shown when there's no logs to show.
	no_data = "没有数据",

	advanced_search = "高级搜索",
	quick_search = "快速搜索",
	search = "搜索",

	-- The button to open the SteamID Finder (steamid.venner.io)
	steamid_finder = "SteamID查询器",

	-- The message in the players panel instructing the user to select something
	-- to view players.
	select_something = "选择一个项目",

	-- The button at the pagination that allows you to jump to a specific page.
	jump = "跳到",

	-- The title of the window that pops up when you click "Jump"
	jump_to_page = "跳到页数...",

	-- The text in that window instructing the user.
	-- %d is the number of pages that exist
	type_page = "输入页数 (总共%d页)",

	cancel = "取消",

	error_over_pagenum = "那一页不存在",
	error_not_num = "那不是一个数字",

	error = "Error",

	-- Left click to copy [player] name
	involved_tooltip = "Right click for options",

	-- View logs that that this player is involved in
	view_player_logs = "查看玩家记录",

	-- Copy [something] [to clipboard]
	copy = "复制%s到剪切板",

	profile = "Steam个人主页",

	left_click_to_copy = "左键复制",

	modules = "模块",

	custom = "自定义",

	enter_a_steamid = "输入一个SteamID...",

	error_not_steamid = "那不是一个SteamID.",

	-- Used in the advanced search box
	-- "Does the log contain this text?"
	contains = "并且包含...",

	-- "Colour Mode" is whether or not the logs are shown with coloured text.
	colour_mode = "颜色模式",

	jump_to_date = "跳到日期",

	jump_to_date_tooltip = "右键跳到特定日期/时间",

	type_date = "输入一个时间，必须遵循这个格式：DD/MM/YYYY (%s/%s/%s)",

	error_not_date = "输入日期不正确，必须遵循这个格式：DD/MM/YYYY (%s/%s/%s)",

	type_time = "输入时间戳。必须遵循这个格式：HH:MM (%s:%s) (24 hour)\n留空无视时间戳。",

	error_not_time = "时间戳不正确。必须遵循这个格式：HH:MM (%s:%s) (24小时)",

	archive = "归档",

	searching = "档案",

	search_archive = "搜索档案",

	search_archive_warning = "使用本地数据库搜索档案会导致服务器卡顿。尽量避免不必要的使用。",

	logging = "记录",

	save = "保存",

	enabled = "启用",

	disabled = "禁用",

	disable = "禁用",

	enable = "启用",

	give = "给予",

	take = "撤回",

	new_steamid = "新的SteamID",

	new_usergroup = "新的用户组",

	usergroup_name = "用户组名字",

	-- "Delete this entry from permissions"
	delete_entry = "删除权限内容",

	usergroup_exists = "那个用户组已经在权限中存在了！是否已经存在一个同名的CAMI用户组？若是，请使用那个。",

	steamid_exists = "那个SteamID已经在权限中存在了！",

	loading = "加载中...",

	support = "售后支持",

	-- "Player Format" is a setting that contains everything that will be included
	-- in a log that references a player. For example, it will show the player's job,
	-- health, armour, etc. depending on the settings.
	player_format = "玩家格式",

	permissions = "权限",

	general_settings = "通用设置",

	operations = "操作",

}
