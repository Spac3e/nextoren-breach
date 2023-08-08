--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dsprite.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_Material", "Material" )
AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_Rotation", "Rotation" )
AccessorFunc( PANEL, "m_Handle", "Handle" )

function PANEL:Init()

	self:SetColor( color_white )
	self:SetRotation( 0 )
	self:SetHandle( Vector( 0.5, 0.5, 0 ) )

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

	self:NoClipping( true )

end

function PANEL:Paint()

	local Mat = self.m_Material
	if ( !Mat ) then return true end

	surface.SetMaterial( Mat )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )

	local w, h = self:GetSize()
	local x, y = 0, 0
	surface.DrawTexturedRectRotated( x, y, w, h, self.m_Rotation )

	return true

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetMaterial( Material( "brick/brick_model" ) )
	ctrl:SetSize( 200, 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DSprite", "A sprite", PANEL, "DPanel" )

-- Convenience function
function CreateSprite( mat )
	local sprite = vgui.Create( "DSprite" )
	sprite:SetMaterial( mat )
	return sprite
end
