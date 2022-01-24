
if ( not rpRadio ) then

	rpRadio = {}
end

rpRadio.ENT_RAD = {}
rpRadio.ENT_MIC = {}
rpRadio.ENT_BOTH = {}

hook.Add( "OnEntityCreated", "rad_OEC", function( ent )

	if ( IsValid( ent ) && ( ent:GetClass() == "rp_radio" || ent:GetClass() == "rp_radio_microphone" ) ) then
	
		table.insert( rpRadio.ENT_BOTH, ent )
		
		if ( ent:GetClass() == "rp_radio" ) then
		
			table.insert( rpRadio.ENT_RAD, ent )
		else
		
			table.insert( rpRadio.ENT_MIC, ent )
		end
	end
end )

hook.Add( "EntityRemoved", "rad_OR", function( ent )

	if ( IsValid( ent ) && ( ent:GetClass() == "rp_radio" || ent:GetClass() == "rp_radio_microphone" ) ) then
	
		table.remove( rpRadio.ENT_BOTH, table.KeyFromValue( rpRadio.ENT_BOTH, ent ) )
		
		if ( ent:GetClass() == "rp_radio" ) then
		
			table.remove( rpRadio.ENT_RAD, table.KeyFromValue( rpRadio.ENT_RAD, ent ) )
		else
		
			table.remove( rpRadio.ENT_MIC, table.KeyFromValue( rpRadio.ENT_MIC, ent ) )
		end
	end
end )