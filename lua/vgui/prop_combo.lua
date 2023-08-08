--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/prop_combo.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )

	vars = vars or {}

	self:Clear()

	local combo = vgui.Create( "DComboBox", self )
	combo:Dock( FILL )
	combo:DockMargin( 0, 1, 2, 2 )
	combo:SetValue( vars.text or "Select..." )

	local hasIcons, icon = istable( vars.icons )
	for id, thing in pairs( vars.values or {} ) do

		if ( hasIcons ) then
			icon = vars.icons[ id ]
		else
			icon = vars.icons
		end

		combo:AddChoice( id, thing, id == vars.select, icon )
	end

	self.IsEditing = function( self )
		return combo:IsMenuOpen()
	end

	self.SetValue = function( self, val )
		for id, data in pairs( combo.Data ) do
			if ( data == val ) then
				combo:ChooseOptionID( id )
			end
		end
	end

	combo.OnSelect = function( _, id, val, data )
		self:ValueChanged( data, true )
	end

	combo.Paint = function( combo, w, h )

		if self:IsEditing() or self:GetRow():IsHovered() or self:GetRow():IsChildHovered() then
			DComboBox.Paint( combo, w, h )
		end

	end

	self:GetRow().AddChoice = function( self, value, data, select )
		combo:AddChoice( value, data, select )
	end

	self:GetRow().SetSelected = function( self, id )
		combo:ChooseOptionID( id )
	end

	-- Enabled/disabled support
	self.IsEnabled = function( self )
		return combo:IsEnabled()
	end
	self.SetEnabled = function( self, b )
		combo:SetEnabled( b )
	end

end

derma.DefineControl( "DProperty_Combo", "", PANEL, "DProperty_Generic" )
