local MODULE = bLogs:Module()

MODULE.Category = "Cinema"
MODULE.Name     = "Video Queued"
MODULE.Colour   = Color(255,0,0)

MODULE:Hook("PostVideoQueued","videoqueued",function(vid,cinema)
	MODULE:Log(bLogs:FormatPlayer(vid:GetOwner()) .. " queued " .. bLogs:Highlight(vid:Title()) .. " at theatre " .. bLogs:Highlight(cinema:Name()))
end)

bLogs:AddModule(MODULE)
