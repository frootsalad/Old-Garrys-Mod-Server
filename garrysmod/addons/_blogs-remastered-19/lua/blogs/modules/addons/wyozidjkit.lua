if (not wdj) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Wyozi DJ"
MODULE.Name     = "Audio Queued"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("WDJAudioQueued","WDJAudioQueued",function(ply,ent,channel,channel_name,audio_url,audio_title)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " queued " .. bLogs:Highlight(audio_title or "UNKNOWN") .. " (" .. bLogs:Highlight(audio_url or "UNKNOWN") .. ") on channel " .. bLogs:Highlight(channel_name or "UNKNOWN"))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Wyozi DJ"
MODULE.Name     = "Channel Renamed"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("WDJChannelRenamed","WDJChannelRenamed",function(ply,ent,channel,channel_name)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " renamed a channel to " .. bLogs:Highlight(channel_name or "UNKNOWN"))
end)

bLogs:AddModule(MODULE)
