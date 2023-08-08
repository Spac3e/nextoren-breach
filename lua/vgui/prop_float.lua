--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/prop_float.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

function PANEL:Init()
end

function PANEL:GetDecimals()
	return 2
end

function PANEL:Setup( vars )

	self:Clear()

	vars = vars or {}

	local ctrl = self:Add( "DNumSlider" )
	ctrl:Dock( FILL )
	ctrl:SetDark( true )
	ctrl:SetDecimals( self:GetDecimals() )

	-- Apply vars
	ctrl:SetMin( vars.min || 0 )
	ctrl:SetMax( vars.max || 1 )

	-- The label needs mouse input so we can scratch
	self:GetRow().Label:SetMouseInputEnabled( true )
	-- Take the scratch and place it on the Row's label
	ctrl.Scratch:SetParent( self:GetRow().Label )
	-- Hide the numslider's label
	ctrl.Label:SetVisible( false )
	-- Move the text area to the left
	ctrl.TextArea:Dock( LEFT )
	-- Add a margin onto the slider - so it's not right up the side
	ctrl.Slider:DockMargin( 0, 3, 8, 3 )

	-- Return true if we're editing
	self.IsEditing = function( self )
		return ctrl:IsEditing()
	end

	-- Enabled/disabled support
	self.IsEnabled = function( self )
		return ctrl:IsEnabled()
	end
	self.SetEnabled = function( self, b )
		ctrl:SetEnabled( b )
	end

	-- Set the value
	self.SetValue = function( self, val )
		ctrl:SetValue( val )
	end

	-- Alert row that value changed
	ctrl.OnValueChanged = function( ctrl, newval )

		self:ValueChanged( newval )

	end

	self.Paint = function()

		-- PERFORMANCE !!!
		ctrl.Slider:SetVisible( self:IsEditing() || self:GetRow():IsChildHovered() )

	end

end

derma.DefineControl( "DProperty_Float", "", PANEL, "DProperty_Generic" )
