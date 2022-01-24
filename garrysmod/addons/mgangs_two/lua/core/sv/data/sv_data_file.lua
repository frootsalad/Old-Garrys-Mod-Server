--[[
MGANGS - SERVERSIDE DATA - FILE
Developed by Zephruz

	- The meta in this file is only for directories/files in the MGangs.Data.File._directories namespace/known files
		* For example, this means that when you use MGangs.Data.File:SearchFor("example.txt"), it will only search in the namespace/known files
]]

--[[----------
	File/JSON Data
-------------]]
MGangs.Data.File._directories = (MGangs.Data.File._directories or {})

function MGangs.Data.File:Create(dirName, files)
	if (self._directories[dirName]) then
		table.Merge(self._directories[dirName], files)

		return
	end

	self._directories[dirName] = files
end

local function recursiveFiles(files, path, indent, isTblF, isFleF)
	local indent = (indent && indent .. "-" || "")
	local path = (path || "")

	for k,v in pairs(files) do
		if (istable(v)) then
			if (isTblF) then
				isTblF(path .. k, k, v, indent)
			end

			recursiveFiles(v, path .. k .. "/", indent, (isTblF or nil), (isFleF or nil))
		else
			if (isFleF) then
				isFleF(path .. k, k, v, indent)
			end
		end
	end
end

function MGangs.Data.File:Read(fPath, searchFor)
	if !(searchFor) then
		return file.Read(fPath, "DATA")
	else
		local files = self:SearchFor(fPath)
		local retData = {}

		for k,v in pairs(files) do
			if (v.type == "file") then
				local data = file.Read(v.path)

				table.insert(retData, {
					path = v.path,
					data = data,
				})
			end
		end

		return retData
	end
end

function MGangs.Data.File:Verify()
	recursiveFiles(self._directories, "", "",
	function(path, dName, data, indent)
		if !(file.Exists(path, "DATA")) then
			file.CreateDir(path)
			MGangs:ConsoleMessage(indent .. "> Created directory " .. path, Color(0,255,0))
		else
			MGangs:ConsoleMessage(indent .. "> Found directory " .. path, Color(0,255,0))
		end
	end,
	function(path, fName, data, indent)
		if !(file.Exists(path, "DATA")) then
			MGangs:ConsoleMessage(indent .. "> Created file " .. fName, Color(0,255,0))
			file.Write(path, data)
		else
			MGangs:ConsoleMessage(indent .. "> Found file " .. fName, Color(0,255,0))
		end
	end)
end

function MGangs.Data.File:SearchFor(qryName)
	local foundFiles = {}

	recursiveFiles(self._directories, nil, nil,
	function(path, dName, data, indent)
		if (dName:find(qryName)) then
			table.insert(foundFiles, {
				path = path,
				name = dName,
				data = data,
				type = "directory",
			})
		end
	end,
	function(path, fName, data, indent)
		if (fName:find(qryName)) then
			table.insert(foundFiles, {
				path = path,
				name = fName,
				data = data,
				type = "file",
			})
		end
	end)

	return foundFiles
end
