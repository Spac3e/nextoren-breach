--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/ddrawer.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_iOpenSize", "OpenSize" )
AccessorFunc( PANEL, "m_fOpenTime", "OpenTime" )

function PANEL:Init()

	self.m_bOpened = false

	self:SetOpenSize( 100 )
	self:SetOpenTime( 0.3 )
	self:SetPaintBackground( false )
	self:SetSize( 0, 0 )

	self.ToggleButton = vgui.Create( "DButton", self:GetParent() )
	self.ToggleButton:SetSize( 16, 16 )
	self.ToggleButton:SetText( "::" )
	self.ToggleButton.DoClick = function()

		self:Toggle()

	end

	self.ToggleButton.Think = function()

		self.ToggleButton:CenterHorizontal()
		self.ToggleButton.y = self.y - 8

	end

end

function PANEL:OnRemove()

	self.ToggleButton:Remove()

end

function PANEL:Think()

	local w, h = self:GetParent():GetSize()
	self:SetPos( 0, h - self:GetTall() )
	self:SetWide( w )

end

function PANEL:Toggle()

	if ( self.m_bOpened ) then
		self:Close()
	else
		self:Open()
	end

end

function PANEL:Open()

	if ( self.m_bOpened == true ) then return end

	self.m_bOpened = true
	self:SizeTo( self:GetWide(), self.m_iOpenSize, self.m_fOpenTime )
	self.ToggleButton:MoveToFront()

end

function PANEL:Close()

	if ( self.m_bOpened == false ) then return end

	self.m_bOpened = false
	self:SizeTo( self:GetWide(), 0, self.m_fOpenTime )
	self.ToggleButton:MoveToFront()

end

derma.DefineControl( "DDrawer", "", PANEL, "DPanel" )
