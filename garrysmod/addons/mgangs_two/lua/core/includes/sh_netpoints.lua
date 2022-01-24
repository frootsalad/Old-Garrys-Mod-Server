--[[
	netPoint - V1

	-- What does this do?
		* Provides a means of data transferring/querying between the client and server
		* Performs (mostly) like Ajax

	TODO:
		- Handshakes between client & server (to verify that the data is supposed to be transferred at the time of request)
]]

netPoint = (netPoint or {})
netPoint._endPoints = (netPoint._endPoints or {})
netPoint._cache = (netPoint._cache or {})
netPoint._clRecID, netPoint._svRecID = "NP.RC", "NP.RS"

--[[CONFIG]]
netPoint.debug = true 		-- Enables debug messages

netPoint.reqTimeout = 2  	-- How long before a request times out and retries

netPoint.reqRetryAmt = 5	-- How many times a request is retried before closed

netPoint.maxRequests = 100 -- Maximum amount of requests within 5 seconds [before a user gets blocked from sending more until timeout]

--[[----------
	SHARED
------------]]

---------------------
--> netPoint:DebugMessage(...)
-- 	-> Prints a message to console if debug mode is enabled.
-- 	-> Used for debugging.
--  -> ARGUMENTS
	-- Works the same as MsgC()
---------------------
function netPoint:DebugMessage(...)
	if !(self.debug) then return false end

	local pfx = (CLIENT && "CLIENT" || "SERVER")

	MsgC(Color(255,255,0), "[NP - " .. pfx .. "] ", Color(255,255,255), ..., "\n")
end

---------------------
--> netPoint:GetEndPoint(reqEP)
-- 	-> Retrieves an EndPoint
--  -> ARGUMENTS
	-- * reqEP (STRING) - EndPoint name
---------------------
function netPoint:GetEndPoint(reqEP)
	return (self._endPoints && self._endPoints[reqEP] || nil)
end

---------------------
--> netPoint:RemoveEndPoint(reqEP)
-- 	-> Removes an EndPoint
--  -> ARGUMENTS
	-- * reqEP (STRING) - EndPoint name
---------------------
function netPoint:RemoveEndPoint(reqEP)
	self._endPoints[reqEP] = nil -- Just nil it
end

---------------------
--> netPoint:CreateEndPoint(reqEP, data)
-- 	-> Creates an EndPoint
--  -> ARGUMENTS
	-- * reqEP (STRING) - EndPoint name
	-- * data (TABLE) - EndPoint data/configuration
---------------------
function netPoint:CreateEndPoint(reqEP, data)
	if !(self._endPoints) then self._endPoints = {} end

	local rfsNWStr = self._svRecID .. reqEP
	local rtcNWStr = self._clRecID .. reqEP

	self._endPoints[reqEP] = data

	if !(SERVER) then return end -- Don't want to receive anything on the client since this is shared

	-- Setup endpoint net receive [request] & send [result]
	util.AddNetworkString(rfsNWStr)

	net.Receive(rfsNWStr,
	function(len,ply)
		if !(IsValid(ply)) then return false end

		-- Check if this player is spamming, if so; stop them (temporarily)
		local maxReqs = 100
		local rfsResAt = (ply:GetNWInt("NP_RS_RESETAT"))
		local rfsTReqs = (ply:GetNWInt("NP_RS_TOTAL", 1))

		if (rfsResAt > os.time() && rfsTReqs >= maxReqs) then
			return false
		elseif (rfsResAt < os.time()) then
			ply:SetNWInt("NP_RS_RESETAT", os.time()+5)
			ply:SetNWInt("NP_RS_TOTAL", 0)
		else
			ply:SetNWInt("NP_RS_TOTAL", rfsTReqs+1)
		end

		local retData = {}
		local reqEP = net.ReadString()
		local reqID = net.ReadString()
		local reqData = net.ReadTable()

		local epData = self:GetEndPoint(reqEP)

		if !(epData) then return false end	-- This should not happen; this message got sent to the wrong endpoint or this user is attempting an exploit
		if (!reqData or reqData["CL_ERR"]) then print(reqData["CL_ERR"] .. "\n") return false end

		for k,v in pairs(epData) do
			local val = reqData[k]

			if (val) then
				retData[k] = (v(ply,val) or {})
			end
		end

		if !(retData) then return false end

		local reqLink = rtcNWStr .. "." .. reqID
		local compData, compBInt = self:CompressTableToSend(retData)

		util.AddNetworkString(reqLink)

		net.Start(reqLink)
			net.WriteUInt(compBInt, 32)
			net.WriteData(compData, compBInt)
		net.Send(ply)
	end)
end

function netPoint:CompressTableToSend(tbl)
	tbl = (istable(tbl) && util.TableToJSON(tbl))
	tbl = util.Compress(tbl)

	return tbl, #tbl
end

--[[
 CLIENT
]]
if (CLIENT) then
	---------------------
	--> netPoint:FromEndPoint(reqEP, reqID, data, retAmt (NIL))
	-- 	-> Requests data from the specified endpoint
	--  -> ARGUMENTS
		-- * reqEP (STRING) - EndPoint name
		-- * retID (STRING) - EndPoint unique request name
		-- * data (TABLE) - EndPoint data/configuration
		-- * retAmt (INTEGER) - This is handled in the function automatically
	---------------------
	function netPoint:FromEndPoint(reqEP, reqID, data, retAmt)
		local rfsNWStr = self._svRecID .. reqEP
		local rtcNWStr = self._clRecID .. reqEP

		self._cache = (self._cache or {})
		self._openRequests = (self._openRequests or {})

		local function closeRequest(reqID)
			self._openRequests[reqID] = nil
		end

		local function openRequest(reqEP, data)
			local reqLink = rfsNWStr .. "." .. reqEP

			-- Start request
			net.Start(rfsNWStr)
				net.WriteString(reqEP)
				net.WriteString(tostring(reqID))
				net.WriteTable(data.requestData || {["CL_ERR"] = "[MG2-DATA] CLIENT REQUEST ERROR: `data.requestData` invalid \n\treqEP: " .. (reqEP or "NIL")})
			net.SendToServer()

			self:DebugMessage("REQUEST SENT: " .. reqID .. " - " .. os.date("%H:%M:%S - %m/%d/%Y", os.time()))
		end

		local function openListener(reqEP, data)
			local reqTime = CurTime()
			local reqLink = rtcNWStr .. "." .. reqID

			self._openRequests[reqID] = {
				data = data,
				time = reqTime,
			}

			-- Receive any results from server
			net.Receive(reqLink,
			function(len)
				local dataBInt = net.ReadUInt(32)
				local dataRes = net.ReadData(dataBInt)
				dataRes = (dataRes && util.Decompress(dataRes))
				dataRes = (dataRes && util.JSONToTable(dataRes) || nil)

				if (dataRes && data.receiveResults) then
					-- Add to cache
					self._cache[reqID] = (self._cache[reqID] or {})
					table.insert(self._cache[reqID], {
						params = data,
						result = dataRes,
					})

					data.receiveResults(dataRes)
					closeRequest(reqID)

					self:DebugMessage("RESULT RECEIVED: " .. reqID .. " (SIZE#" .. (dataBInt || "NIL") .. ")" .. " - " .. os.date("%H:%M:%S - %m/%d/%Y", os.time()))
				end
			end)

			timer.Simple(self.reqTimeout,
			function()
				if (self._openRequests[reqID] && self._openRequests[reqID].time == reqTime) then
					retAmt = (retAmt && retAmt + 1 or 1)

					self:DebugMessage("RESULT TIMED OUT: " .. reqID .. " (RETRYING - " .. retAmt .. " of " .. self.reqRetryAmt .. ") - " .. os.date("%H:%M:%S - %m/%d/%Y", os.time()))

					self:FromEndPoint(reqEP, reqID, data, retAmt)	-- Retry (Probably dropped/not received)
				end
			end)
		end

		if (retAmt && retAmt >= self.reqRetryAmt) then closeRequest(reqID) return false end

		openListener(reqEP, data)	-- Open our listener
		openRequest(reqEP, data)	-- Start our request
	end
end
