--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/material.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self.Material = nil
	self.AutoSize = true
	self:SetAlpha( 255 )

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:Paint()

	if (!self.Material) then return true end

	surface.SetMaterial( self.Material )
	surface.SetDrawColor( 255, 255, 255, self.Alpha )
	surface.DrawTexturedRect( 0, 0, self:GetSize() )

	return true

end

function PANEL:SetAlpha( _alpha_ )

	self.Alpha = _alpha_

end

function PANEL:SetMaterial( _matname_ )

	--self.Material = surface.GetTextureID( _matname_ )

	self.Material = Material( _matname_ )
	local Texture = self.Material:GetTexture( "$basetexture" )
	if ( Texture ) then
		self.Width = Texture:Width()
		self.Height = Texture:Height()
	else
		self.Width = 32
		self.Height = 32
	end

	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	if ( !self.Material ) then return end
	if ( !self.AutoSize ) then return end

	self:SetSize( self.Width, self.Height )

end

vgui.Register( "Material", PANEL, "Button" )
