--[[
MGANGS - SERVERSIDE DATA - SOCKET
Developed by Zephruz
]]

local bsockEx, bsockErr = pcall(function() require("bromsock") end)

if !(bsockEx) then
  MGangs:ConsoleMessage("Bromsocket doesn't exist, not including data type 'socket' (THIS IS OKAY)", Color(0,255,0))
else

-- Setup socket metatables
MGangs.Data.Sock = (MGangs.Data.Sock or {})
MGangs.Data.Sock.Info = {
  keyLen = 32, -- Don't change this...
  keyChars = "abcdefghijklmnopqrstuvwxyz123456789",
  portRange = {
    min = 90099,
    max = 90699,
  },
}

MGangs.Data.Sock.__index = MGangs.Data.Sock
MGangs.Data.Sock._key = (MGangs.Data.Sock._key or nil)
MGangs.Data.Sock._db = (MGangs.Data.Sock._db or nil)

-- Metatables
MGangs.Data.Sock.Client = {}
MGangs.Data.Sock.Server = {}

-- Metatable setup
MGangs.Data.Sock.Client.__index = MGangs.Data.Sock.Client
setmetatable(MGangs.Data.Sock.Client,{
  __call = function(self,...)
    return MGangs.Data.Sock.Client.Create(...)
  end,
  __index = MGangs.Data.Sock
})

MGangs.Data.Sock.Server.__index = MGangs.Data.Sock.Server
setmetatable(MGangs.Data.Sock.Server,{
  __call = function(self,...)
    return MGangs.Data.Sock.Server.Create(...)
  end,
  __index = MGangs.Data.Sock
})

--[[
  SERVER
]]

-- Server Constructor
function MGangs.Data.Sock.Server.Create()
  local self = setmetatable({},MGangs.Data.Sock.Server)

  self._socket = BromSock()

  self._socket:SetCallbackAccept(function(...)
    self:OnAccept(...)
  end)

  return self
end

function MGangs.Data.Sock.Server:OnAccept(serversock, clientsock)
  print("[BS:S] Accepted:", serversock, clientsock)

  clientsock:SetCallbackReceive(function(sock, packet)
    print("[BS:S] Received:", sock, packet)
    print("[BS:S] R_Num:", packet:ReadInt())

    packet:WriteString("String test.")
    sock:Send(packet)

    -- normaly you'd want to call Receive again to read the next packet. However, we know that the client ain't going to send more, so fuck it.
    -- theres only one way to see if a client disconnected, and that's when a error occurs while sending/receiving.
    -- this is why most applications have a disconnect packet in their code, so that the client informs the server that he exited cleanly. There's no other way.
    -- We set a timeout, so let's be stupid and hope there's another packet incomming. It'll timeout and disconnect.
    sock:Receive()
  end)

  clientsock:SetCallbackDisconnect(function(sock)
    print("[BS:S] Disconnected:", sock)
  end)

  clientsock:SetTimeout(1000) -- timeout send/recv commands in 1 second. This will generate a Disconnect event if you're using callbacks

  clientsock:Receive()

  -- Who's next in line?
  serversock:Accept()
end

function MGangs.Data.Sock.Server:Listen(port)

  if !(self._socket:Listen(port)) then
		print("[BS:S] Failed to listen!")
	else
		print("[BS:S] Server listening...")
	end
end

function MGangs.Data.Sock.Server:Close()
  if (self && self._socket) then
    self._socket:Close()

    MGangs.Data:DebugMessage("Closed server socket", Color(255,255,0))
  end
end

--[[
  CLIENT
]]

-- Client Constructor
function MGangs.Data.Sock.Client.Create()
  local self = setmetatable({},MGangs.Data.Sock.Client)

  self._socket = BromSock()

  self._socket:SetCallbackConnect(function(sock, ret, ip, port)
    self:OnConnect(sock, ret, ip, port)
  end)

  self._socket:SetCallbackReceive(function(sock, packet)
    self:OnReceive(sock, packet)
  end)

  self._socket:SetCallbackSend(function(sock, datasent)
    self:OnSend(sock, datasent)
  end)

  return self
end

function MGangs.Data.Sock.Client:OnConnect(sock, ret, ip, port)
  local socket_client = self._socket

  if (not ret) then
    print("[BS:C] Failed to connect to: ", ret, ip, port)
    return
  end

  if (port == 443) then
    socket_client:StartSSLClient()
  end

  print("[BS:C] Connected to server:", sock, ret, ip, port)
  local packet_client = BromPacket(socket_client)
  packet_client:WriteInt(13000)
  socket_client:Send(packet_client)

  -- we expect a response form the server after he received this, so instead of calling Receive at the connect callback, we do it here.
  socket_client:Receive()
end

function MGangs.Data.Sock.Client:OnReceive(sock, packet)
  print("[BS:C] Received:", sock, packet, packet and packet:InSize() or -1)
  print("[BS:C] R_Str:", packet:ReadString())

  -- normaly you'd call Receive here again, instead of disconnect
  sock:Disconnect()
end

function MGangs.Data.Sock.Client:OnSend(sock, datasent)
  print("[BS:C] Sent:", "", sock, datasent)
end

function MGangs.Data.Sock.Client:Connect(ip,port)
  self._socket:Connect(ip,port)
end

function MGangs.Data.Sock.Client:Close()
  if (self && self._socket) then
    self._socket:Close()

    MGangs.Data:DebugMessage("Closed client socket", Color(255,255,0))
  end
end

--[[
  MISC META
]]

-- Receive key
function MGangs.Data.Sock:ReceiveKey(packet)
  local data = packet:ReadStringAll()
  data = util.JSONToTable(data)

  if (data && istable(data)) then
    local key = (data.key)

    MGangs.Data.Sock:VerifyKey(key,
    function(d)
      data["ip"] = (d.ip)
      data["lPort"] = (d.listen_port)

      MGangs.Data:DebugMessage("Verified key from " .. ip .. ":" .. port .. " [" .. key .. "]", Color(255,255,0))
    end)
  end
end

-- Get open listen port
function MGangs.Data.Sock:GetOpenListenPort(serverTbl)
  local lPort
  local info = self.Info
  local prMax, prMin, prTbl = (info.portRange.max or 100), (info.portRange.min or 1), {}

  for i=1,#serverTbl do
    local d = serverTbl[i]

    if (d && d.listen_port) then
      table.insert(prTbl, d.listen_port)
    end
  end

  for i=prMin,prMax do
    if !(table.HasValue(prTbl,i)) then
      lPort = i

      break
    end
  end

  return lPort
end

-- Refresh key
function MGangs.Data.Sock:RequestKey(onDone)
  local info = self.Info
  local keyLen = (info && info.keyLen || 36)
  local keyChars = (inof && info.keyChars || "abcdefghijklmnopqrstuvwxyz123456789")
  local key = string.random(keyLen, keyChars)
  local sIP, sPort, lPort = game.GetIP(), GetConVarString("hostport"), 1

  local selStr = "SELECT * FROM `mg2_serverdata`"

  MGangs.Data.MySQL:Query(selStr,
  function(qry,data)
    lPort = self:GetOpenListenPort(data)

    local exists
    local updStr = "UPDATE `mg2_serverdata` SET `key`='" .. key .. "' WHERE `ip`='" .. sIP .. "' AND `port`='" .. sPort .. "'"
    local insStr = "INSERT INTO `mg2_serverdata` (`key`, `ip`, `port`, `listen_port`) VALUES ('" .. key .. "', '" .. sIP .. "', '" .. sPort .. "', '" .. lPort .. "')"

    for i=1,#data do
      if (data[i] && tonumber(data[i].port) == tonumber(sPort)) then
        exists = data[i].listen_port

        break
      end
    end

    if (exists) then
      MGangs.Data.MySQL:Query(updStr, function()
        -- Server exists, continue
        onDone(data[i])
      end,
      function(qry, err) return err end)
    else
      MGangs.Data.MySQL:Query(insStr, function()
        -- Server didn't exist, now does, continue
        onDone(data[i])
      end,
      function(qry, err) return err end)
    end
  end,
  function(qry,err)
    return err
  end)

  self:SetKey(key)

  return key
end

-- Verify key
function MGangs.Data.Sock:VerifyKey(key, onVal)
  MGangs.Data.MySQL:Query("SELECT * FROM mg2_serverdata WHERE `key` = '" .. key .. "'",
  function(qry,data)
    if (data[1]) then
      if (onVal) then onVal(data[1]) end
    end
  end,
  function(qry,err)
    MGangs.Data:DebugMessage(err, Color(255,255,0))
  end)
end

end
