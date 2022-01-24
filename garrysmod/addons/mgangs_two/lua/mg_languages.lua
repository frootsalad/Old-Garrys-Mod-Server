--[[
MGANGS - LANGUAGES SHARED
Developed by Zephruz
]]


MGangs.Language._reg = (MGangs.Language._reg or {})
MGangs.Language.Active = (MGangs.Language._reg[MGangs.Config.Language or "en"] or MGangs.Language._reg["en"] or {})

-- [[Register Language]]
function MGangs.Language:Register(name)
	self._reg[name] = (self._reg[name] or {})

	return self._reg[name]
end

function MGangs.Language:AddTranslation(lang, name, text)
	self._reg[lang] = (self._reg[lang] or {})

	self._reg[lang][name] = text
end

function MGangs.Language:GetTranslation(name, ...)
	local enLang = (self._reg["en"] or {})
	local curLang = (self.Active or {})
	local lang = (curLang[name] || enLang[name])

	return (lang && string.format(lang, ...) || name)
end

-- [[Print Languages]]
function MGangs.Language:PrintAll()
	MGangs:ConsoleMessage("/-------- Languages --------\\", Color(0,255,0))

	for nm, data in pairs(self._reg) do
		print("\t" .. nm .. " - " .. table.Count(istable(data) && data or {}) .. " translations" )
	end
end

-- [[Load Languages]]
function MGangs.Language:Load()
	MGangs:ConsoleMessage("/----- Loading languages -----\\", Color(0,255,0))

	local f_languages, d_languages = file.Find("languages/mg_language_*.lua", "LUA")

	for dir, lang_file in pairs(f_languages) do
		AddCSLuaFile("languages/" .. lang_file)
		include("languages/" .. lang_file)

		print("\t Loaded " .. lang_file)
	end

	self.Active = (self._reg[MGangs.Config.Language or "en"] or self._reg["en"]) -- [[Set the active language]]

	if (SERVER) then
		MGangs:ConsoleMessage("Loaded all languages!", Color(0,255,0))
	end
end

MGangs.Language:Load()	-- Load Language
