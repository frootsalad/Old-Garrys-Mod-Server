MGangs = (MGangs or {})
MGangs.Version = 1

MGangs.Config = (MGangs.Config or {})

MGangs.Language = (MGangs.Language or {})
MGangs.Include = (MGangs.Include or {})
MGangs.Module = (MGangs.Module or {})
MGangs.Module.mods = (MGangs.Module.mods or {})
MGangs.Util = (MGangs.Util or {})
MGangs.Meta = (MGangs.Meta or {})
MGangs.Data = (MGangs.Data or {})
MGangs.NetWork = (MGangs.NetWork or {})
MGangs.Gang = (MGangs.Gang or {})
MGangs.Gang.Data = (MGangs.Gang.Data or {})
MGangs.Player = (MGangs.Player or {})

function MGangs:ConsoleMessage(msg, col)
	MsgC(col or Color(255,0,0), "[mGangs] ", Color(255,255,255), msg .. "\n")
end

MGangs:ConsoleMessage("----------------------------", Color(0,255,0))
MGangs:ConsoleMessage("        mGangs - V" .. MGangs.Version, Color(0,255,0))
MGangs:ConsoleMessage("----------------------------", Color(0,255,0))

if (SERVER) then
	include("core/sv/sv_load.lua")
	AddCSLuaFile("core/cl/cl_load.lua")
end

if (CLIENT) then
	include("core/cl/cl_load.lua")
end
