timer.Simple( 30, function()
    DarkRP.addPhrase('en', 'advert', '[Advert]')
    local billboardfunction = DarkRP.getChatCommand("advert")
    billboardfunction = billboardfunction['callback']
    DarkRP.removeChatCommand("advert")
        --From darkrp before the update to remove this. Check the commits
     local function PlayerAdvertise(ply, args)
        if args == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
            return ""
        end
        local DoSay = function(text)
            if text == "" then
                DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
                return
            end
            for k,v in pairs(player.GetAll()) do
                local col = team.GetColor(ply:Team())
                DarkRP.talkToPerson(v, col, DarkRP.getPhrase("advert") .. " " .. ply:Nick(), Color(255, 255, 0, 255), text, ply)
            end
            
            hook.Call("playerAdverted", nil, ply, args)
        end
        return args, DoSay
    end
    DarkRP.declareChatCommand{
        command = "billboard",
        description = "Create a billboard holding an advertisement.",
        delay = 1.5
    }
    DarkRP.declareChatCommand{
        command = "advert",
        description = "Advertise something to everyone in the server.",
        delay = 1.5
     }
    DarkRP.declareChatCommand{
        command = "ad",
        description = "Advertise something to everyone in the server.",
        delay = 1.5
     }

    if SERVER then
        DarkRP.defineChatCommand("advert", PlayerAdvertise, 1.5)
        DarkRP.defineChatCommand("ad", PlayerAdvertise, 1.5)
        DarkRP.defineChatCommand("billboard", billboardfunction)
    end
end)
--[[
LICENSE
You are free to modify and distribute this, but you must keep all names of anyone whom has done an edit.
Orignal Author: Andreblue
]]