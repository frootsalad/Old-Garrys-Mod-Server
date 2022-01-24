for i = 1, 150 do

      surface.CreateFont( 'fus_font_' .. i, {
            font = 'Arial Bold',
            size = i,
            weight = 500
      } )

end

-- Most of this is from my Fresh Garbage System script :D

function fus.clientVal( key )
	return fus.config.client[ key ]
end

local blur = Material 'pp/blurscreen'

function fus.drawBlur( pan, amt )

	local x, y = pan:LocalToScreen( 0, 0 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, 3 do

		blur:SetFloat( '$blur', ( i / 3 ) * ( amt or 6 ) )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )

	end

end

function fus.drawBox( x, y, w, h, clr, out )

	if not clr then clr = fus.clientVal( 'backgroundColor' ) end

	surface.SetDrawColor( clr )
	surface.DrawRect( x, y, w, h )

end

function fus.drawOutlinedBox( x, y, w, h, clr )

	if not clr then clr = fus.clientVal( 'backgroundColor' ) end

	fus.drawBox( x, y, w, h, clr )

	surface.SetDrawColor( fus.clientVal( 'linesColor' ) )
	surface.DrawLine( 0, 0, w - 1, 0 )
	surface.DrawLine( w - 1, 0, w - 1, h - 1 )
	surface.DrawLine( 0, h - 1, w - 1, h - 1 )
	surface.DrawLine( 0, 0, 0, h )

end

function fus.txt( str, size, x, y, clr, a1, a2 )

	if not a1 then a1 = 0 end
	if not a2 then a2 = 0 end
	if not clr or clr == nil then clr = fus.clientVal( 'textColor' ) end

	draw.SimpleText( str, 'fus_font_' .. size, x, y, clr, a1, a2 )

end
