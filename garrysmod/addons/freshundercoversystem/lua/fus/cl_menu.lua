local poses = {
	"pose_standing_01",
	"pose_standing_04",
	"pose_standing_03",
	'pose_standing_02',
	'idle_melee_angry',
	'seq_meleeattack01'
}

function fus.randPose( ent )
	return ent:LookupSequence( table.Random( poses ) )
end

function fus.menu()

      local w                 = ScrW() * 0.75
      local h                 = ScrH() * 0.75
      local pnlX              = 5
      local pnlY              = 23
      local pnlW              = w / 3
      local pnlH              = h - 28
      local sideways          = true
      local jobPanels         = {}

      local bg = vgui.Create( 'fus_DFrame' )
      bg:SetSize( w, h )
      bg:Center()
      bg:addClose()

      bg.title = 'Undercover NPC'

	function bg:PaintOver( w, h )

		if table.Count( fus.jobData ) <= 0 then
			fus.txt( 'No jobs to display!', 25, w / 2, h / 2, nil, 1, 1 )
		end

	end

      local scroll = bg:Add( 'DHorizontalScroller' )
      scroll:SetSize( w - 10, pnlH )
      scroll:SetPos( 5, 23 )
      scroll:SetOverlap( -5 )

      function scroll.btnRight:Paint( w, h )

            fus.drawOutlinedBox( 0, 0, w, h )
            fus.txt( '⇒', 20, w / 2, h / 2, nil, 1, 1 )

      end

      function scroll.btnLeft:Paint( w, h )

            fus.drawOutlinedBox( 0, 0, w, h )
            fus.txt( '⇐', 20, w / 2, h / 2, nil, 1, 1 )

      end

      for i = 1, #fus.jobData do

            local data              = fus.jobData[ i ]
            if not data then continue end

            local job               = data.team
            local jobData           = RPExtraTeams[ job ]
            local groupCheck        = function() return true end
            local jobCheck          = function() return true end

            if not jobData then continue end
		if LocalPlayer():Team() == job then continue end

            if data.allowedGroups and istable( data.allowedGroups ) then

                  groupCheck = function()
                        return data.allowedGroups[ LocalPlayer():GetUserGroup() ]
                  end

            end

            if data.allowedJobs and istable( data.allowedJobs ) then

                  jobCheck = function()
                        return data.allowedJobs[ team.GetName( LocalPlayer():Team() ) ]
                  end

            end

		local usable = false

		if groupCheck() and jobCheck() then
			usable = true
		end

            local jobPnl = bg:Add( 'DPanel' )
            jobPnl:SetSize( pnlW, pnlH )
            jobPnl:SetPos( pnlX, pnlY )

            function jobPnl:Paint( w, h )

                  fus.drawBox( 0, 0, w, h )
                  fus.txt( team.GetName( job ), 17, w / 2, 5, nil, 1 )

            end

            local jobMdl = jobPnl:Add( 'DModelPanel' )
            jobMdl:SetSize( pnlW, pnlH - 50 )
            jobMdl:SetPos( 0, 0 )
            jobMdl:SetModel( istable( jobData.model ) and jobData.model[ 1 ] or jobData.model )

		local top = Vector( 0.025778, -0.303267, 62.222530 )

		jobMdl:SetCamPos( top - Vector( -100, 0, 0 ) )
		jobMdl:SetFOV( 47 )
		jobMdl:SetLookAt( top )

            local pose = fus.randPose( jobMdl.Entity )
      	jobMdl:GetEntity():SetSequence( pose )

      	function jobMdl:LayoutEntity( ent )
      		self:RunAnimation()
      	end

            local jobBtn = jobPnl:Add( 'fus_DButton' )
            jobBtn:SetSize( pnlW, pnlH - jobMdl:GetTall() )
            jobBtn:SetPos( 0, pnlH - ( pnlH - jobMdl:GetTall() ) )

            function jobBtn:DoClick()

                  net.Start( 'fus.undercoverStart' )
                        net.WriteInt( i, 32 )
                  net.SendToServer()

                  bg:removeFrame()

            end

            jobBtn.text 	= fus.translate( 'select' )
		jobBtn.clickable 	= usable

            scroll:AddPanel( jobPnl )

      end

end

net.Receive( 'fus.openMenu', fus.menu )
