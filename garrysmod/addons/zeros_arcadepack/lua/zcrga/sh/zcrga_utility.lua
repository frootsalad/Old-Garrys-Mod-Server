if SERVER then
	function zcrga_Notify(ply, msg, ntfType)
		if gmod.GetGamemode().Name == "DarkRP" then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end
end

function zcrga_LerpColor(t, c1, c2)
	local c3 = Color(0, 0, 0)
	c3.r = Lerp(t, c1.r, c2.r)
	c3.g = Lerp(t, c1.g, c2.g)
	c3.b = Lerp(t, c1.b, c2.b)
	c3.a = Lerp(t, c1.a, c2.a)

	return c3
end
