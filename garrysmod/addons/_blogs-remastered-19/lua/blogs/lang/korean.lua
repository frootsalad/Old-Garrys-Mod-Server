--[[

	bLogs Korean

	Contributors:

	바른각 - STEAM_0:1:101627612

]]

bLogs.Language = {

	-- First column in the logs, shows the date/time of the log
	when = "시각",

	permission_failure = "현재 이 작업을 수행할 수 있는 권한이 없습니다.",

	-- When the user is an admin, this will be in the window title.
	admin_mode = "관리자 모드",

	-- The button to view all logs stored.
	all_logs = "전체 로그",

	-- The button to view all players stored in bLogs.
	all_players = "전체 플레이어",

	-- The tab at the top to view players stored in bLogs.
	players = "플레이어",

	-- The message shown to the player when they first open bLogs.
	getting_data = "데이터를 가져오는 중입니다. 잠시 기다려 주십시오...",

	-- The message shown when there's no logs to show.
	no_data = "데이터 없음!",

	advanced_search = "고급 검색",
	quick_search = "빠른 검색",
	search = "검색",

	-- The button to open the SteamID Finder (steamid.venner.io)
	steamid_finder = "SteamID 검색기",

	-- The message in the players panel instructing the user to select something
	-- to view players.
	select_something = "선택",

	-- The button at the pagination that allows you to jump to a specific page.
	jump = "건너뛰기",

	-- The title of the window that pops up when you click "Jump"
	jump_to_page = "페이지 건너뛰기...",

	-- The text in that window instructing the user.
	-- %d is the number of pages that exist
	type_page = "페이지 번호 입력 (%d 페이지 존재)",

	cancel = "취소",

	error_over_pagenum = "해당 로그 페이지가 존재하지 않습니다",
	error_not_num = "그것은 숫자가 아닙니다",

	error = "오류",

	-- Left click to copy [player] name
	involved_tooltip = "마우스 우클릭을 하여 옵션보기",

	-- View logs that that this player is involved in
	view_player_logs = "플레이어 로그 보기",

	-- Copy [something] [to clipboard]
	copy = "%s 복사",

	profile = "스팀 프로필",

	left_click_to_copy = "마우스 좌클릭을 하여 복사하기",

	modules = "모듈",

	custom = "커스텀",

	enter_a_steamid = "SteamID를 입력하세요...",

	error_not_steamid = "그것은 올바르지 않은 SteamID 입니다.",

	-- Used in the advanced search box
	-- "Does the log contain this text?"
	contains = "포함 단어...",

	-- "Colour Mode" is whether or not the logs are shown with coloured text.
	colour_mode = "색상 모드",

	jump_to_date = "날짜 건너뛰기",

	jump_to_date_tooltip = "마우스 우클릭하여 날짜/시간으로 이동합니다.",

	type_date = "날짜를 입력하세요. 다음과 같은 형식이여야 합니다: DD/MM/YYYY (%s/%s/%s)",

	error_not_date = "그것은 올바른 날짜가 아닙니다. 다음과 같은 형식이여야 합니다: DD/MM/YYYY (%s/%s/%s)",

	type_time = "타임스탬프를 입력하세요. 다음과 같은 형식이여야 합니다: HH:MM (%s:%s) (24 시간)\n시간을 무시하려면 칸을 비워두세요.",

	error_not_time = "그것은 올바른 타임스탬프가 아닙니다. 다음과 같은 형식이여야 합니다: HH:MM (%s:%s) (24 시간)",

	archive = "기록 보관소",

	searching = "검색중",

	search_archive = "기록 보관소 검색",

	search_archive_warning = "보관 파일을 검색하면 로컬 데이터베이스의 서버가 지연될 수 있습니다. 필요한 경우에만 사용하세요.",

	logging = "기록중",

	save = "저장",

	enabled = "활성화 됨",

	disabled = "비-활성화 됨",

	disable = "비-활성화",

	enable = "활성화",

	give = "주기",

	take = "받기",

	new_steamid = "새로운 SteamID",

	new_usergroup = "새로운 유저그룹",

	usergroup_name = "유저그룹 이름",

	-- "Delete this entry from permissions"
	delete_entry = "엔트리 삭제",

	usergroup_exists = "그 유저그룹은 이미 권한이 있습니다! 그것을 위한 CAMI 유저그룹이 있나요? 그렇다면 그 유저그룹을 사용하세요.",

	steamid_exists = "그 SteamID는 이미 권한이 있습니다.",

	loading = "로드 중...",

	support = "에드온 지원",

	-- "Player Format" is a setting that contains everything that will be included
	-- in a log that references a player. For example, it will show the player's job,
	-- health, armour, etc. depending on the settings.
	player_format = "플레이어 형식",

	permissions = "권한",

	general_settings = "기본 설정",

	operations = "bLogs 기능",

}
