//
/*
	Adv Dupe Anti-Exploit Plugin
	8/12/2018
	Smart Like My Shoe ( Badass Development )
*/

timer.Simple(10, function()

	if (AdvDupe2) then 
	
		local REVISION = 4;
		
		local pairs = pairs
		local type = type
		local error = error
		local Vector = Vector
		local Angle = Angle
		local format = string.format
		local char = string.char
		local byte = string.byte
		local sub = string.sub
		local gsub = string.gsub
		local find = string.find
		local gmatch = string.gmatch
		local match = string.match
		local concat = table.concat
		local compress = util.Compress
		local decompress = util.Decompress

		AdvDupe2.CodecRevision = REVISION
		
		local function error_nodeserializer()
			buff:Seek(buff:Tell()-1)
			error(format("couldn't find deserializer for type {typeid:%d}", buff:ReadByte()))
		end

		local dec = {}
		local reference = 0
		for i=1,255 do dec[i] = error_nodeserializer end

		local function read()
			local tt = buff:ReadByte()
			
			if not tt then
				error("expected value, got EOF")
			end
			
			if tt == 0 then
				return nil
			end
			
			return dec[tt]()
			
		end

		dec[255] = function() --table
			local t = {}
			local k
			reference = reference + 1
			local ref = reference

			repeat
				
				k = read()
				
				if k ~= nil then
					t[k] = read()
				end
				
			until (k == nil)
			
			tables[ref] = t
			
			return t
			
		end

		dec[254] = function() --array
			local t = {}
			local k,v = 0
			reference = reference + 1
			local ref = reference
			
			repeat
				k = k + 1
				v = read()
				
				if(v != nil) then
					t[k] = v
				end
				
			until (v == nil)
			
			tables[ref] = t
			
			return t
			
		end

		dec[253] = function()
			return true
		end
		dec[252] = function()
			return false
		end
		dec[251] = function()
			return buff:ReadDouble()
		end
		dec[250] = function()
			return Vector(buff:ReadDouble(),buff:ReadDouble(),buff:ReadDouble())
		end
		dec[249] = function()
			return Angle(buff:ReadDouble(),buff:ReadDouble(),buff:ReadDouble())
		end
		dec[248] = function() --null-terminated string
			local start = buff:Tell()
			local slen = 0
			
			while buff:ReadByte() != 0 do
				slen = slen + 1
			end
			
			buff:Seek(start)
			
			local retv = buff:Read(slen)
			if(not retv)then retv="" end
			buff:ReadByte()

			return retv
		end
		dec[247] = function() --table reference
			reference = reference + 1
			return tables[buff:ReadShort()]
		end

		local function vsr()
			
			buff:Seek(buff:Tell() - 1)
			
			slen = buff:ReadByte()
			
			return buff:Read(slen)
			
		end

		for i=1,246 do dec[i] = vsr end
		
		local function deserialize(str)
	
			if(str==nil)then
				error("File could not be decompressed.")
				return {}
			end
			
			tables = {}
			reference = 0
			buff = file.Open("ad2temp.txt","wb","DATA")
			buff:Write(str)
			buff:Flush()
			buff:Close()
			
			buff = file.Open("ad2temp.txt","rb", "DATA")
			local success, tbl = pcall(read)
			buff:Close()
			
			if success then
				return tbl
			else
				error(tbl)
			end
		end
		
		
		
		--seperates the header and body and converts the header to a table
		local function getInfo(str)
			local last = str:find("\2")
			if not last then
				error("attempt to read AD2 file with malformed info block")
			end
			local info = {}
			local ss = str:sub(1,last-1)
			for k,v in ss:gmatch("(.-)\1(.-)\1") do
				info[k] = v
			end
			
			if info.check ~= "\r\n\t\n" then
				if info.check == "\10\9\10" then
					error("detected AD2 file corrupted in file transfer (newlines homogenized)(when using FTP, transfer AD2 files in image/binary mode, not ASCII/text mode)")
				else
					error("attempt to read AD2 file with malformed info block")
				end
			end
			return info, str:sub(last+2)
		end
		
		local versions = {}

		versions[1] = AdvDupe2.LegacyDecoders[1]
		versions[2] = AdvDupe2.LegacyDecoders[2]

		versions[3] = function(encodedDupe)
			encodedDupe = encodedDupe:Replace("\r\r\n\t\r\n", "\t\t\t\t")
			encodedDupe = encodedDupe:Replace("\r\n\t\n", "\t\t\t\t")
			encodedDupe = encodedDupe:Replace("\r\n", "\n")
			encodedDupe = encodedDupe:Replace("\t\t\t\t", "\r\n\t\n")
			return versions[4](encodedDupe)
		end

		versions[4] = function(encodedDupe)
			local info, dupestring = getInfo(encodedDupe:sub(7))
			return deserialize(
						decompress(dupestring)
					), info
		end
	
		print("[SPC] Patching Adv Dupe 2 Model-Scale Crash Exploit!");

		// Patches infinite model scale exploit 
		local function PatchInfModelScale(data)
			
			if (type(data) == "table") then 
				for k,v in next, data.Entities do 
					if (v.ModelScale) then 
					
						if (v.ModelScale > 9) then 
							v.ModelScale = 1;
						end
					end 
				end 
			end
		end

		--[[
			Name:	Decode
			Desc:	Generates the table for a dupe from the given string. Inverse of Encode
			Params:	<string> encodedDupe, <function> callback, <...> args
			Return:	runs callback(<boolean> success, <table/string> tbl, <table> info)
		]]
		function AdvDupe2.Decode(encodedDupe, callback, ...)
			
			local sig, rev = encodedDupe:match("^(....)(.)")
			
			if not rev then
				error("malformed dupe (wtf <5 chars long?!)")
			end
			
			rev = rev:byte()
			
			if sig ~= "AD2F" then
				if sig == "[Inf" then --legacy support, ENGAGE (AD1 dupe detected)
					local success, tbl, info, moreinfo = pcall(AdvDupe2.LegacyDecoders[0], encodedDupe)

					if success then
						info.size = #encodedDupe
						info.revision = 0
						info.ad1 = true
					else
						ErrorNoHalt(tbl)
					end
				
					PatchInfModelScale(tbl);
					callback(success, tbl, info, moreinfo, ...)
				else
					error("unknown duplication format")
				end
			elseif rev > REVISION then
				error(format("this install lacks the codec version to parse the dupe (have rev %u, need rev %u)",REVISION,rev))
			elseif rev < 1 then
				error(format("attempt to use an invalid format revision (rev %d)", rev))
			else
				local success, tbl, info = pcall(versions[rev], encodedDupe)
				
				if success then
					info.revision = rev
				else
					ErrorNoHalt(tbl)
				end
				
				PatchInfModelScale(tbl);
				callback(success, tbl, info, ...)
			end
		end
	end
end);