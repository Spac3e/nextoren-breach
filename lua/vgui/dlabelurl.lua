--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dlabelurl.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_colText", "TextColor" )
AccessorFunc( PANEL, "m_colTextStyle", "TextStyleColor" )

AccessorFunc( PANEL, "m_bAutoStretchVertical", "AutoStretchVertical" )

function PANEL:Init()

	self:SetTextStyleColor( Color( 0, 0, 255 ) )

	-- Nicer default height
	self:SetTall( 20 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:ApplySchemeSettings()

	self:UpdateFGColor()

end

function PANEL:SetTextColor( clr )

	self.m_colText = clr
	self:UpdateFGColor()

end
PANEL.SetColor = PANEL.SetTextColor

function PANEL:GetColor()

	return self.m_colText or self.m_colTextStyle

end

function PANEL:OnCursorEntered()

	self:SetTextStyleColor( Color( 0, 50, 255 ) )
	self:UpdateFGColor()

end

function PANEL:OnCursorExited()

	self:SetTextStyleColor( Color( 0, 0, 255 ) )
	self:UpdateFGColor()

end

function PANEL:UpdateFGColor()

	local col = self:GetColor()
	self:SetFGColor( col.r, col.g, col.b, col.a )

end

derma.DefineControl( "DLabelURL", "A Label", PANEL, "URLLabel" )
