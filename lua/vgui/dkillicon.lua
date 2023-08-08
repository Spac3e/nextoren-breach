--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dkillicon.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_Name", "Name" )

function PANEL:Init()

	self.m_Name = ""
	self.m_fOffset = 0
	self:NoClipping( true )

end

function PANEL:SizeToContents()

	local w, h = killicon.GetSize( self.m_Name )
	self.m_fOffset = h * 0.1
	self:SetSize( w, 5 )

end

function PANEL:Paint()

	killicon.Draw( self:GetWide() * 0.5, self.m_fOffset, self.m_Name, 255 )

end

derma.DefineControl( "DKillIcon", "A kill icon", PANEL, "Panel" )
