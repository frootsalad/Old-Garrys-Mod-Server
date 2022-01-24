function fus.adminMenu( jobData )

      local w           = ScrW() * 0.5
      local h           = ScrH() * 0.75
      local jobH        = 100
      local jobY        = 0
      local entryW      = w - jobH - 10
      local entryH      = 22
      local entryY      = 23

      local bg = vgui.Create( 'fus_DFrame' )
      bg:SetSize( w, h )
      bg:Center()
      bg:addClose()

      bg.title = 'Undercover System - Admin Menu'

      local scroll = bg:Add( 'DScrollPanel' )
      scroll:SetSize( w, h - 28 )
      scroll:SetPos( 0, 23 )
      scroll:GetVBar():SetWide( 0 )

      for _, data in ipairs( RPExtraTeams ) do

            entryY = 23

            local curTeam                 = nil
            local buttons                 = {}
            local entries                 = {}
            local isAdded                 = false
            local btnX                    = jobH
            local btnW                    = w / 2 - ( jobH / 2 )
            local groups                  = {}
            local jobs                    = {}

            for i, v in ipairs( team.GetAllTeams() ) do

                  if v.Name == data.name then
                        curTeam = i
                  end

            end

            if not curTeam then continue end

            for i, j in pairs( jobData ) do

                  if j.team == curTeam then

                        isAdded = true
                        break

                  end

            end

            local jobPnl = scroll:Add( 'DPanel' )
            jobPnl:SetSize( w, jobH )
            jobPnl:SetPos( 0, jobY )

            function jobPnl:Paint( w, h )

                  fus.drawBox( 0, 0, w, h )
                  fus.txt( data.name, 17, w / 2, 5, nil, 1 )

            end

            local jobMdl = jobPnl:Add( 'DModelPanel' )
            jobMdl:SetSize( jobH, jobH )
            jobMdl:SetPos( 0, 0 )
            jobMdl:SetModel( istable( data.model ) and data.model[ 1 ] or data.model )

            function jobMdl:LayoutEntity() return false end

            local top = Vector( 0.025778, -0.303267, 62.222530 )

		jobMdl:SetCamPos( top - Vector( -100, 0, 0 ) )
		jobMdl:SetFOV( 15 )
		jobMdl:SetLookAt( top )

            entries[ 1 ] = {
                  title = 'Allowed Ranks (NOT Required, Separate with a \',\')',
                  type = 'ranks',
                  pnl = nil
            }

            entries[ 2 ] = {
                  title = 'Allowed Jobs (NOT Required, Separate with a \',\')',
                  type = 'jobs',
                  pnl = nil
            }

            for i = 1, #entries do

                  local data        = entries[ i ]
                  local jobStr      = ''
                  local rankStr     = ''

                  local entry = jobPnl:Add( 'fus_DTextEntry' )
                  entry:SetSize( entryW, entryH )
                  entry:SetPos( jobH + 5, entryY )
                  entry:SetText( data.title )

                  entry.changed = false

                  data.pnl = entry

                  if curTeam ~= nil then

                        for i, v in ipairs( fus.jobData ) do

                              if v.team == curTeam then

                                    if data.type == 'jobs' and v.allowedJobs then

                                          for str, _ in pairs( v.allowedJobs ) do

                                                if _ then
                                                      jobStr = ( jobStr ~= '' and jobStr .. ',' .. str ) or str
                                                end

                                          end

                                          entry:SetText( jobStr )

                                    end

                                    if data.type == 'ranks' and v.allowedGroups then

                                          for str, _ in pairs( v.allowedGroups ) do

                                                if _ then
                                                      rankStr = ( rankStr ~= '' and rankStr .. ',' .. str ) or str
                                                end

                                          end

                                          entry:SetText( rankStr )

                                    end

                              end

                        end

                  end

                  function entry:OnGetFocus()

                        self:SetText( '' )
                        self.changed = true

                  end

                  entryY = entryY + entryH + 5

            end

            buttons[ 1 ] = {
                  text = 'Delete',
                  clickable = isAdded,
                  func = function( self )

                        net.Start( 'fus.deleteJob' )
                              net.WriteInt( curTeam, 32 )
                        net.SendToServer()

                        self.clickable = false

                  end
            }

            buttons[ 2 ] = {
                  text = 'Add/Edit',
                  clickable = true,
                  func = function()

                        local groupEntry              = entries[ 1 ].pnl
                        local jobEntry                = entries[ 2 ].pnl
                        local groupData               = {}
                        local jobData                 = {}

                        if groupEntry.changed then
                              groupData = string.Explode( ',', groupEntry:GetText() )
                        end

                        if jobEntry.changed then
                              jobData = string.Explode( ',', jobEntry:GetText() )
                        end

                        net.Start( 'fus.addJob' )

                              net.WriteInt( curTeam, 32 )
                              net.WriteTable( groupData )
                              net.WriteTable( jobData )

                        net.SendToServer()

                  end
            }

            for i = 1, #buttons do

                  local btnData = buttons[ i ]
                  if not btnData then continue end

                  local btn = jobPnl:Add( 'fus_DButton' )
                  btn:SetSize( btnW, 23 )
                  btn:SetPos( btnX, entryY )

                  btn.text    	= btnData.text
                  btn.clickable     = btnData.clickable
                  function btn:DoClick() btnData.func( self ) end

                  btnX = btnX + btnW

            end

            jobY = jobY + jobH + 5

      end

end
