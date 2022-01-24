fus.dataTable = {
      mainDir = 'tupacscripts/freshundercover',
      entDir = 'tupacscripts/freshundercover/' .. game.GetMap() .. '_ent_spawns.txt',
      jobsDir = 'tupacscripts/freshundercover/fus_jobs.txt',
      allowedDir = 'tupacscripts/freshundercover/fus_allowed_players.txt'
}

function fus.dataInitialize()

      if not file.IsDir( 'tupacscripts', 'DATA' ) then
            file.CreateDir( 'tupacscripts' )
      end

      if not file.IsDir( fus.dataTable[ 'mainDir' ], 'DATA' ) then
            file.CreateDir( fus.dataTable[ 'mainDir' ] )
      end

      if not file.Exists( fus.dataTable[ 'entDir' ], 'DATA' ) then
            file.Write( fus.dataTable[ 'entDir' ], '' )
      end

      if not file.Exists( fus.dataTable[ 'jobsDir' ], 'DATA' ) then
            file.Write( fus.dataTable[ 'jobsDir' ], '' )
      end

      if not file.Exists( fus.dataTable[ 'allowedDir' ], 'DATA' ) then
            file.Write( fus.dataTable[ 'allowedDir' ], '' )
      end

      fus.loadData()
      fus.notifyServer( 'Initialized data!' )

end

hook.Add( 'DarkRPDBInitialized', 'fus.dataInitialize', fus.dataInitialize )

function fus.writeData( data, path )

      data = util.TableToJSON( data )
      file.Write( path, data or '' )

end

function fus.loadJSON( path )

      local data        = file.Read( path, 'DATA' )
      if not data or data == '' then return false end

      data              = util.JSONToTable( data )
      return data

end

function fus.saveData()

      local toFind            = ents.FindByClass( 'undercover_npc' )
      local found             = {}

      for i = 1, #toFind do

            local ent = toFind[ i ]
            if not ent then continue end

            found[ i ] = {
                  pos = ent:GetPos(),
                  ang = ent:GetAngles(),
                  mdl = ent:GetModel()
            }

      end

      found = util.TableToJSON( found )

      file.Write( fus.dataTable[ 'entDir' ], found or '' )

      fus.writeData( fus.jobData, fus.dataTable[ 'jobsDir' ] )
      fus.writeData( fus.allowedPlayers, fus.dataTable[ 'allowedDir' ] )

end

function fus.loadEntities()

      local entData = fus.loadJSON( fus.dataTable[ 'entDir' ] )
      if not entData then return end

      for i = 1, #entData do

            local data = entData[ i ]
            if not data then continue end

            local ent = ents.Create( 'undercover_npc' )
            ent:SetPos( data.pos )
            ent:SetAngles( data.ang )
            ent:Spawn()
            ent:SetModel( data.mdl )

      end

end

hook.Add( 'InitPostEntity', 'fus.loadEntities', fus.loadEntities )

function fus.loadData()

      local jobData = fus.loadJSON( fus.dataTable[ 'jobsDir' ] )

      if jobData then
            fus.jobData = jobData
      end

      local allowedPlayers = fus.loadJSON( fus.dataTable[ 'allowedDir' ] )

      if allowedPlayers then
            fus.allowedPlayers = allowedPlayers
      end

end
