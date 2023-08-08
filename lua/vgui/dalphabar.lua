--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dalphabar.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

local matGradient = Material( "vgui/gradient-u" )
local matGrid = Material( "gui/alpha_grid.png", "nocull" )

AccessorFunc( PANEL, "m_Value", "Value" )
AccessorFunc( PANEL, "m_BarColor", "BarColor" )

function PANEL:Init()

	self:SetBarColor( color_white )
	self:SetSize( 26, 26 )
	self:SetValue( 1 )

end

function PANEL:OnCursorMoved( x, y )

	if ( !input.IsMouseDown( MOUSE_LEFT ) ) then return end

	local fHeight = y / self:GetTall()

	fHeight = 1 - math.Clamp( fHeight, 0, 1 )

	self:SetValue( fHeight )
	self:OnChange( fHeight )

end

function PANEL:OnMousePressed( mcode )

	self:MouseCapture( true )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:OnMouseReleased( mcode )

	self:MouseCapture( false )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:OnChange( fAlpha )
end

function PANEL:Paint( w, h )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( matGrid )
	local size = 128
	for i = 0, math.ceil( h / size ) do
		surface.DrawTexturedRect( w / 2 - size / 2, i * size, size, size )
	end

	surface.SetDrawColor( self.m_BarColor )
	surface.SetMaterial( matGradient )
	surface.DrawTexturedRect( 0, 0, w, h )
	surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()
	surface.DrawRect( 0, ( 1 - self.m_Value ) * h - 2, w, 3 )

	surface.SetDrawColor( 255, 255, 255, 250 )
	surface.DrawRect( 0, ( 1 - self.m_Value ) * h - 1, w, 1 )

end

derma.DefineControl( "DAlphaBar", "", PANEL, "DPanel" )
