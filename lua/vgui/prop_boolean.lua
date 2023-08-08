--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/prop_boolean.lua
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

function PANEL:Setup( vars )

	self:Clear()

	local ctrl = self:Add( "DCheckBox" )
	ctrl:SetPos( 0, 2 )

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
		ctrl:SetChecked( tobool( val ) )
	end

	-- Alert row that value changed
	ctrl.OnChange = function( ctrl, newval )

		if ( newval ) then newval = 1 else newval = 0 end

		self:ValueChanged( newval )

	end

end

derma.DefineControl( "DProperty_Boolean", "", PANEL, "DProperty_Generic" )
