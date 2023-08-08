--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dmenuoptioncvar.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

DEFINE_BASECLASS( "DMenuOption" )

AccessorFunc( PANEL, "m_strConVar", "ConVar" )
AccessorFunc( PANEL, "m_strValueOn", "ValueOn" )
AccessorFunc( PANEL, "m_strValueOff", "ValueOff" )

function PANEL:Init()

	self:SetChecked( false )
	self:SetIsCheckable( true )

	self:SetValueOn( "1" )
	self:SetValueOff( "0" )

end

function PANEL:Think()

	if ( !self.m_strConVar ) then return end
	local strValue = GetConVarString( self.m_strConVar )

	self:SetChecked( strValue == self.m_strValueOn )

end

function PANEL:OnChecked( b )

	if ( !self.m_strConVar ) then return end

	if ( b ) then
		RunConsoleCommand( self.m_strConVar, self.m_strValueOn )
	else
		RunConsoleCommand( self.m_strConVar, self.m_strValueOff )
	end

end

derma.DefineControl( "DMenuOptionCVar", "", PANEL, "DMenuOption" )
