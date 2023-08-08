--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/imagecheckbox.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:SetMaterial( On )

	if ( self.MatOn ) then
		self.MatOn:Remove()
	end

	self.MatOn = vgui.Create( "Material", self )
	self.MatOn:SetSize( 16, 16 )
	self.MatOn:SetMaterial( On )

	self:InvalidateLayout( true )

end

function PANEL:SetChecked( bOn )

	if ( self.State == bOn ) then return end
	self.MatOn:SetVisible( bOn )
	self.State = bOn

end

function PANEL:GetChecked()

	return self.State

end

function PANEL:Set( bOn )

	self:SetChecked( bOn )

end

function PANEL:DoClick()

	self:SetChecked( !self.State )

end

function PANEL:SizeToContents()

	if ( self.MatOn ) then
		self:SetSize( self.MatOn:GetWide(), self.MatOn:GetTall() )
	end

	self:InvalidateLayout()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 50 ) )
	return true

end

function PANEL:PerformLayout()

	self.MatOn:SetPos( ( self:GetWide() - self.MatOn:GetWide() ) / 2, ( self:GetTall() - self.MatOn:GetTall() ) / 2 )

end

vgui.Register( "ImageCheckBox", PANEL, "Button" )
