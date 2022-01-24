local PANEL = {}

function PANEL:Init()

      self:SetDraggable( false )
      self:ShowCloseButton( false )
      self:SetTitle( '' )
      self:MakePopup()

      self.title              = ''
      self.titleSize          = 18

end

function PANEL:addClose()

      local cb = self:Add( 'fus_DButton' )
      cb:SetPos( self:GetWide() - 51, 1 )
      cb:SetSize( 50, 20 )

      cb.text                  = 'Close'
      cb.textSize              = 15

      function cb:DoClick()

            if IsValid( self:GetParent() ) then
                  self:GetParent():removeFrame()
            end

      end

end

function PANEL:centerFrame()

      local w, h  = self:GetSize()

      self:SetPos( ScrW() / 2 - ( w / 2 ), ScrH() / 2 - ( h / 2 ) )

end

function PANEL:removeFrame()

      self:SizeTo( 0, 0, fus.clientVal( 'animSpeed' ) )

      timer.Simple( fus.clientVal( 'animSpeed' ), function()
            self:Remove()
      end )

end

function PANEL:Paint( pW, pH )

      fus.drawBlur( self, 6 )
      fus.drawOutlinedBox( 0, 0, pW, pH )

      fus.txt( self.title or '', self.titleSize, pW / 2, 5, nil, 1 )

end

vgui.Register( 'fus_DFrame', PANEL, 'DFrame' )

PANEL = {}

function PANEL:Init()

      self:SetText( '' )

      self.text               = ''
      self.textSize           = 15
      self.clickable          = true
      self.lerpW              = 0
      self.btnColor           = Color( 150, 25, 25, 80 )

end

function PANEL:Paint( w, h )

      local clr = self.btnColor

      if self.clickable then

            fus.drawBox( 0, 0, w, h, clr )

            if not self:IsHovered() then

                  self.lerpW = Lerp( 0.1, self.lerpW, 0 )

            else

                  self.lerpW = Lerp( 0.1, self.lerpW, w )

            end

      else

            fus.drawBox( 0, 0, w, h, Color( 150, 25, 25, 25 ) )
            self.lerpW = Lerp( 0.1, self.lerpW, 0 )

      end

      fus.drawBox( 0, 0, self.lerpW, h, Color( clr.r + 50, clr.g + 50, clr.b + 50, 150 ) )
      fus.txt( self.text or '', self.textSize, w / 2, h / 2, nil, 1, 1 )

end

function PANEL:OnCursorEntered()

      if not self.clickable then return end
      surface.PlaySound( 'UI/buttonrollover.wav' )

end

vgui.Register( 'fus_DButton', PANEL, 'DButton' )

PANEL = {}

function PANEL:Init()
	self:SetFont( 'DermaDefault' )
end

function PANEL:Paint( w, h )

	fus.drawBox( 0, 0, w, h, Color( 0, 0, 0, 80 ) )

	self:DrawTextEntryText( fus.clientVal( 'textColor' ), Color( 150, 150, 150, 150 ), color_white )

end

vgui.Register( 'fus_DTextEntry', PANEL, 'DTextEntry' )
