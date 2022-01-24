if CLIENT then return end

if zcrga.config.EnableResourceAddfile then
	zcrga = zcrga or {}
	zcrga.force = zcrga.force or {}

	function zcrga.force.AddDir(path)
		local files, folders = file.Find(path .. "/*", "GAME")

		for k, v in pairs(files) do
			resource.AddFile(path .. "/" .. v)
		end

		for k, v in pairs(folders) do
			zcrga.force.AddDir(path .. "/" .. v)
		end
	end

	zcrga.force.AddDir("particles")
	zcrga.force.AddDir("sound/zap")
	zcrga.force.AddDir("models/zerochain/props_arcade")
	zcrga.force.AddDir("materials/zerochain/props_arcade/coin")
	zcrga.force.AddDir("materials/zerochain/props_arcade/coinpusher")
	zcrga.force.AddDir("materials/zerochain/zap/particles")
else
	resource.AddWorkshop("1344490358") -- Zeros CoinPusher Contentpack
end
