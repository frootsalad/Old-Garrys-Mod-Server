--[[
MGANGS - SERVERSIDE DATA - SQLITE
Developed by Zephruz

  - Used to make connections, queries, etc. via MySQL modules
]]

local DEFAULT_CACHE = "_cache"

MGangs.Data.MySQL._db = (MGangs.Data.MySQL._db or false)
MGangs.Data.MySQL[DEFAULT_CACHE] = (MGangs.Data.MySQL[DEFAULT_CACHE] or {})
MGangs.Data.MySQL.MaxCacheSize = 5000 -- # of entries, not actual size; this is when the cache will start deleting older entries

MGangs.Data.MySQL.Types = {
  ["mysqloo"] = {
    connect = function(sqlInfo, onCon, onConF)
      local db = mysqloo.connect(sqlInfo.host, sqlInfo.user, sqlInfo.pass, sqlInfo.dbname, 3306 )

      function db:onConnected()
        if (onCon) then
          onCon(self)
        end
      end

      function db:onConnectionFailed(err)
        if (onConF) then
          onConF(self,err)
        end
      end

      db:connect()

      return db
    end,
    query = function(qryStr, ...)
      local db = MGangs.Data.MySQL:GetDB()

      if !(db) then return false end

      local q = db:query(qryStr)
      local onSuc, onErr = ...

      function q:onSuccess(data)
        if (onSuc) then
          onSuc(self,data)
        end
      end

      function q:onError(err, sql)
        if (onErr) then
          onErr(self,err)
        end
      end

      q:start()

      return q
    end,
  },
}

function MGangs.Data.MySQL:GetDB()
  return (self._db or nil)
end

function MGangs.Data.MySQL:SetDB(db)
  self._db = db
end

function MGangs.Data.MySQL:SaveCache(cacheName)
  local data = (self[cacheName] or self[DEFAULT_CACHE])
  data = util.TableToJSON(data || {})

  file.Write("mg2" .. cacheName .. ".txt", data)
end

function MGangs.Data.MySQL:CleanCache(cache, cAmt)
  if (table.Count(cache) >= self.MaxCacheSize) then
    for i=1,#cAmt do
      table.remove(cache,i)
    end
  end
end

function MGangs.Data.MySQL:CacheData(cacheName, data)
  -- Insert Query
  self[cacheName] = (self[cacheName] or {})

  table.insert(self[cacheName],{
    time = os.time(),
    data = data,
  })

  self:CleanCache(self[cacheName], 1)
end

function MGangs.Data.MySQL:GetCache(cacheName)
  return (self[cacheName] or self[DEFAULT_CACHE])
end

-- Gets active module
function MGangs.Data.MySQL:GetActiveModule()
  local sqlInfo = (params or self.Info)
  local module = sqlInfo.module
  local modType = self.Types[module or "mysqloo"]

  return modType
end

-- Connects to a MySQL Database
function MGangs.Data.MySQL:Connect(onCon, onErr)
  local sqlInfo = self.Info
  local module = sqlInfo.module
  local modType = self.Types[module or "mysqloo"]

  if !(sqlInfo.enabled) then return false end

  if (modType) then
    require(module)

    local db = modType.connect(sqlInfo,
    function(db)
      self:SetDB(db)

      if !(onCon) then return end

      onCon(db)
    end,
    function(db,err)
      if !(onErr) then return end

      onErr(db,err)
    end)

    return db
  end

  return nil
end

-- Runs a query on the active database
function MGangs.Data.MySQL:Query(qryStr, ...)
  local qry
  local modType = MGangs.Data.MySQL:GetActiveModule()
  local onSuc, onErr = ...

  if (modType) then
    qry = modType.query(qryStr,
    function(qry,data)
      if (onSuc) then
        local suc, msg = onSuc(qry,data)

        if (suc && msg) then
          MGangs.Data:DebugMessage(msg, Color(255,255,0))
        end
      end

      self:CacheData("_queryCache", qryStr) -- Cache the query because it was successful
    end,
    function(qry,err)
      if (onErr) then
        local msg = onErr(qry,err)

        if (msg) then
          MGangs.Data:DebugMessage(msg, Color(255,255,0))
        end
      end
    end)
  end

  return qry
end
