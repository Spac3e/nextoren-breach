--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/openpermissions_scrollpanel.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self.CurrentOffset = 0
	self.TargetOffset = 0
	self.StartTime = 0
	self.EndTime = 0

	self.VBar:SetHideButtons(true)
	self.VBar:SetWide(5)
	self.VBar:DockMargin(3,3,3,3)

	function self.VBar:Paint() end
	function self.VBar.btnGrip:Paint(w,h)
		surface.SetDrawColor(0,0,0,150)
		surface.DrawRect(0,0,w,h)
	end

	self.VBar.CurrentY = 0
	self.VBar.TargetY = 0
	function self.VBar:PerformLayout()

		local Wide = self:GetWide()
		local BtnHeight = Wide
		if ( self:GetHideButtons() ) then BtnHeight = 0 end
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( BtnHeight * 2 ) ), 10 )
		local Track = self:GetTall() - ( BtnHeight * 2 ) - BarSize
		Track = Track + 1

		Scroll = Scroll * Track

		self.TargetY = BtnHeight + Scroll
		self.btnGrip:SetSize( Wide, BarSize )

		if ( BtnHeight > 0 ) then
			self.btnUp:SetPos( 0, 0, Wide, Wide )
			self.btnUp:SetSize( Wide, BtnHeight )

			self.btnDown:SetPos( 0, self:GetTall() - BtnHeight )
			self.btnDown:SetSize( Wide, BtnHeight )
			
			self.btnUp:SetVisible( true )
			self.btnDown:SetVisible( true )
		else
			self.btnUp:SetVisible( false )
			self.btnDown:SetVisible( false )
			self.btnDown:SetSize( Wide, BtnHeight )
			self.btnUp:SetSize( Wide, BtnHeight )
		end

	end

	function self.VBar:Think()
		self.CurrentY = Lerp(0.1, self.CurrentY, self.TargetY)
		self.btnGrip:SetPos(0, self.CurrentY)
	end

	self.pnlCanvas.CurrentOffset = 0
	self.pnlCanvas.TargetOffset = 0
	function self.pnlCanvas:Think()
		self.CurrentOffset = Lerp(0.1, self.CurrentOffset, self.TargetOffset)
		self:SetPos(0, self.CurrentOffset)
	end
end

function PANEL:OnVScroll(offset)
	self.pnlCanvas.TargetOffset = offset
end

function PANEL:PerformLayout()

	local Tall = self.pnlCanvas:GetTall()
	local Wide = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()

	if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide + self.VBar:GetWide() )

	self:Rebuild()

	if ( Tall != self.pnlCanvas:GetTall() ) then
		self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
	end

end

derma.DefineControl("OpenPermissions.ScrollPanel", nil, PANEL, "DScrollPanel")