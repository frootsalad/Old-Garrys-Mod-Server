--[[
MGANGS - SERVERSIDE DATA - LOAD
Developed by Zephruz
]]

MGangs.Data.File = (MGangs.Data.File or {})
MGangs.Data.MySQL = (MGangs.Data.MySQL or {})

-- [[CONFIG START]]
MGangs.Data.EnableDebugMessages = true

MGangs.Data.MySQL.Info = {
  enabled = false,
  module = "mysqloo", -- mysqloo
  host = "localhost",
  dbname = "mgangs2",
  user = "root",
  pass = "password",
}
-- [[CONFIG END]]

function MGangs.Data:DebugMessage(msg, col)
	if (self.EnableDebugMessages) then
		MsgC(col or Color(255,0,0), "[mGangs-DBG] ", Color(255,255,255), msg .. "\n")
	end
end

-- Include Data Types
include("sv_data_sqlite.lua")
include("sv_data_mysql.lua")
include("sv_data_socket.lua")
include("sv_data_file.lua")

--[[
	Load Data
]]

--[[File Data]]
-- Default Directories
MGangs.Data.File:Create("mgangs", {})

-- [[Load All Data]]
function MGangs.Data:Load()
	MGangs:ConsoleMessage("/----- Checking Data -----\\", Color(0,255,0))
	self.File:Verify() -- [[Flat file data]]
	self:CheckSQL() -- [[SQL Data]]

  hook.Run("MG2.Data.Initialized")
end
