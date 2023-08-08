--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/contextbase.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetText( "" )
	self.Label:SetDark( true )

end

function PANEL:SetConVar( cvar )
	self.ConVarValue = cvar
end

function PANEL:ConVar()
	return self.ConVarValue
end

function PANEL:ControlValues( kv )

	self:SetConVar( kv.convar or "" )
	self.Label:SetText( kv.label or "" )

end

function PANEL:PerformLayout()

	local y = 5
	self.Label:SetPos( 5, y )
	self.Label:SetWide( self:GetWide() )

	y = y + self.Label:GetTall()
	y = y + 5

	return y

end

function PANEL:TestForChanges()

	-- You should override this function and use it to
	-- check whether your convar value changed

end

function PANEL:Think()

	if ( self.NextPoll && self.NextPoll > CurTime() ) then return end

	self.NextPoll = CurTime() + 0.1

	self:TestForChanges()

end

vgui.Register( "ContextBase", PANEL, "Panel" )
