--[[
MGANGS - SERVERSIDE DATA - SQLITE
Developed by Zephruz
]]

--[[---------
	SQL Data
------------]]

--[[SQL Table Registration]]
MGangs.Data.SQLTables = (MGangs.Data.SQLTables or {})

function MGangs.Data:RegisterSQLTable(name, tbl)
	local sqlTbl = self.SQLTables[name]

	if (sqlTbl && sqlTbl.permanent) then MGangs:ConsoleMessage("SQL Table '" .. name .. "' - forced to permanent table") return false end

	self.SQLTables[name] = tbl

	self:DebugMessage("Registered SQL table '" .. name .. "' " .. (tbl.permanent && "(permanent)" || "(overrideable)") .. ".", Color(255,255,0))
end

--[[SQL Table Creation]]
function MGangs.Data:CheckSQL()
	MGangs:ConsoleMessage("/----- SQL Table Registration -----\\", Color(0,255,0))

  hook.Run("MG2.SQL.VerifyTables")

	MGangs:ConsoleMessage("/----- SQL Table Creation -----\\", Color(0,255,0))

	for k,v in pairs(MGangs.Data.SQLTables) do
		self:CreateTable(k)
	end
end

--[[SQL Functions]]
function MGangs.Data:Query(query)
	return sql.Query(query)
end

function MGangs.Data:SQLQueryResult(query, succmsg, noval)
	if (query or query == nil) then
		self:DebugMessage((succmsg or "Query was successful"), Color(255,255,0))

		return query
	else
		self:DebugMessage(tostring(sql.LastError()), Color(255,255,0))

		return sql.LastError()
	end
end

function MGangs.Data:CreateTable(name)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && tbl.create) then
		local cols = tbl.create

		if !(sql.TableExists(name)) then
			if (istable(tbl.create)) then
				local queryStr = {}

				for k,v in pairs(tbl.create) do
					table.insert(queryStr, sql.SQLStr(v.name) .. " " .. v.ctype)
				end

				local query = self:Query( "CREATE TABLE `" .. name .. "` ( " .. table.concat( queryStr, ", " ) .. " )" )

				return self:SQLQueryResult(query, "Created " .. name .. " SQL Table.")
			end
		else
			MGangs:ConsoleMessage("SQL Table '" .. name .. "' exists", Color(0,255,0))
		end
	end
end

function MGangs.Data:DropTable(name)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		local query = self:Query( "DROP TABLE `" .. name .. "`" )

		return self:SQLQueryResult(query, "Dropped '" .. name .. "' SQL Table.")
	end
end

function MGangs.Data:SelectAll(name)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.selectAll) then
			return tbl.selectAll(colname, value)
		else
			local query = self:Query( "SELECT * FROM `" .. name .. "`" )

			return self:SQLQueryResult(query, "Queried table '" .. tostring(name) .. "' for all values.")
		end
	end
end

function MGangs.Data:SelectAllWhere(name, colname, value)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.selectAllWhere) then
			return tbl.selectAllWhere(colname, value)
		else
			local query = self:Query( "SELECT * FROM `" .. name .. "` WHERE `" .. colname .. "`=" .. sql.SQLStr(value) )

			return self:SQLQueryResult(query, "Queried column '" .. tostring(colname) .. "' for value '" .. tostring(value) .. "'.")
		end
	end
end

function MGangs.Data:SelectWhereLimit(name, limit, colname, value)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.selectWhereLimit) then
			return tbl.selectWhereLimit(limit, colname, value)
		else
			local query = self:Query( "SELECT * FROM `" .. name .. "` WHERE `" .. colname .. "`=" .. sql.SQLStr(value) .. " LIMIT " .. limit )

			return self:SQLQueryResult(query, "Queried column '" .. tostring(colname) .. "' for value '" .. tostring(value) .. "' with limit of " .. limit .. ".")
		end
	end
end

function MGangs.Data:UpdateWhere(name, colname, value, sets)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.updateWhere) then
			return tbl.updateWhere(colname, value)
		else
			local setsTbl = {}

			for k,v in pairs(sets) do
				table.insert(setsTbl, "`" .. k .. "`=" .. (v != "NULL" && sql.SQLStr(v) || "NULL"))
			end

			sets = table.concat(setsTbl, ", ")

			local query = self:Query( "UPDATE `" .. name .. "` SET " .. sets .. " WHERE `" .. colname .. "`=" .. sql.SQLStr(value))

			return self:SQLQueryResult(query, "Updated `" .. name .. "` for value(s) (" .. tostring(sets) .. ").")
		end
	end
end

function MGangs.Data:InsertInto(name, insTbl)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.insertInto) then
			return tbl.insertInto(vals)
		else
			local cols = {}
			local vals = {}

			for k,v in pairs(insTbl) do
				table.insert(cols,sql.SQLStr(k))
				table.insert(vals,(v != "NULL" && sql.SQLStr(v) || "NULL"))
			end

			cols = table.concat(cols, ", ")
			vals = table.concat(vals, ", ")

			local query = self:Query( "INSERT INTO `" .. name .. "` (" .. cols .. ") VALUES (" .. vals .. ")" )

			return self:SQLQueryResult(query, "Inserted (" .. tostring(cols) .. ") VALUES (" .. tostring(vals) .. ")")
		end
	end
end

function MGangs.Data:DeleteWhere(name, colname, val)
	local tbl = MGangs.Data.SQLTables[name]

	if (tbl && sql.TableExists(name)) then
		if (tbl.deleteWhere) then
			return tbl.deleteWhere(colname, val)
		else
			local query = self:Query( "DELETE FROM `" .. name .. "` WHERE `" .. colname .. "`=" .. sql.SQLStr(val) )

			return self:SQLQueryResult(query, "Deleted row WHERE " .. colname .. "=" .. sql.SQLStr(val))
		end
	end
end

-- [[Register SQL Tables]]
hook.Add("MG2.SQL.VerifyTables", "MG2.SQL.VerifyTables.Default",
function()
	-- [[Player Gang Data]]
	MGangs.Data:RegisterSQLTable("mg2_playerdata", {
			permanent = true,
			create = {
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "group", ctype = "VARCHAR(32)"},
				{name = "name", ctype = "VARCHAR(32) NOT NULL"},
				{name = "steamid", ctype = "VARCHAR(32) NOT NULL PRIMARY KEY"},
			},
		})

	-- [[Player Gang Invites
	MGangs.Data:RegisterSQLTable("mg2_playerinvites", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "steamid", ctype = "VARCHAR(32) NOT NULL"},
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "data", ctype = "BLOB NOT NULL"},
			},
		})

	-- [[Gang Data]]
	MGangs.Data:RegisterSQLTable("mg2_gangdata", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "name", ctype = "VARCHAR(32) NOT NULL"},
				{name = "level", ctype = "INTEGER NOT NULL"},
				{name = "exp", ctype = "INTEGER NOT NULL"},
				{name = "balance", ctype = "INTEGER NOT NULL"},
				{name = "icon_url", ctype = "VARCHAR NOT NULL"},
				{name = "leader_name", ctype = "VARCHAR(32) NOT NULL"},
				{name = "leader_steamid", ctype = "VARCHAR(32) NOT NULL"},
			},
		})

	-- [[Gang Groups/Ranks]]
	MGangs.Data:RegisterSQLTable("mg2_ganggroups", {
			permanent = true,
			create = {
				{name = "id", ctype = "INTEGER PRIMARY KEY AUTOINCREMENT"},
				{name = "gangid", ctype = "INTEGER NOT NULL"},
				{name = "priority", ctype = "INTEGER"},
				{name = "grouptype", ctype = "INTEGER"},
				{name = "icon", ctype = "VARCHAR NOT NULL"},
				{name = "name", ctype = "VARCHAR(32) NOT NULL"},
				{name = "perms", ctype = "BLOB NOT NULL"},
			},
		})
end)
