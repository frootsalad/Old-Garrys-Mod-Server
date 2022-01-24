--[[
MGANGS - SHARED UTIL
Developed by Zephruz
]]

--[[-------------
	Util
---------------]]
function MGangs.Util:FormatNumber(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  int = int:reverse():gsub("(%d%d%d)", "%1,")

  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function MGangs.Util:FilterStringEntry(val, filter)
	local val = val:lower()
	local results = {pass = true, foundval = ""}

	if (filter) then
		for i=1,#filter do
			local sFPos, eFPos = val:find(filter[i])

			if (sFPos) then
				results.pass = false
				results.foundval = val:sub(sFPos, eFPos)
			end
		end
	end

	return results
end

function MGangs.Util:MatchStringEntry(val, mtbl)
	local val = val:lower()
	local results = {pass = false, value = ""}

	if (mtbl) then
		for i=1,#mtbl do
			local sMPos, eMPos = val:find(mtbl[i])

			if (sMPos) then
				results.pass = true
				results.value = val:sub(sMPos, eMPos)
			end
		end
	end

	return results
end

function MGangs.Util:SplitUpTable(inTbl,at)
  if !(istable(inTbl)) then return {} end

  inTbl = table.Copy(inTbl)

	local outTbl, keyStash = {}, {}
	local x,split = table.Count(inTbl), at
	local fl = math.ceil(x/split)

	-- [[Chop it up]]
	for i=1,fl do outTbl[i] = {} end

	-- [[Stash any non-numerical (or large) index's into a keyStash for later re-indexing]]
	for k,v in pairs(inTbl) do
		if (!isnumber(k) or k>#inTbl) then
			local data = v -- Localize data
			inTbl[k] = nil -- Nil string index

			local newPos = #inTbl+1 -- Get the new position
			inTbl[newPos] = data -- Add to a numerical index in the original table
			keyStash[newPos] = k -- Save the string key in the keystash at its number index
		end
	end

	-- [[Place into new table]]
	for i=1,#inTbl do
		local indx = math.ceil(i/split)
		local keyAt = i

    if !(outTbl[indx]) then outTbl[indx] = {} end

		outTbl[indx][(keyStash[i] || i)] = (inTbl[i] or false)
	end

	return outTbl
end

function MGangs.Util:RebuildSplitTable(inTbl)
	local outTbl = {}

	for i=1,#inTbl do
		for k,v in pairs(inTbl[i]) do
			outTbl[k] = v
		end
	end

	return outTbl
end
