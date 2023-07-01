--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/horizontaldivider.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("sizewe")

	self.LeftWidth = 0
	self.MiddleWidth = 0
	self.RightWidth = 0
end

function PANEL:SetLeft(pnl)
	self.LeftPnl = pnl
	pnl:SetParent(self)
end

function PANEL:SetMiddle(pnl)
	self.MiddlePnl = pnl
	pnl:SetParent(self)
end

function PANEL:SetRight(pnl)
	self.RightPnl = pnl
	pnl:SetParent(self)
end

function PANEL:SetDividerWidth(w)
	self.DividerWidth = w
end

function PANEL:BalanceWidths()
	self.BalanceWidth = true
end

function PANEL:PerformLayout(w,h)
	if (self.BalanceWidth) then
		self.BalanceWidth = nil

		if (IsValid(self.MiddlePnl)) then
			self.LeftWidth   = (w - (self.DividerWidth * 2)) / 3
			self.MiddleWidth = (w - (self.DividerWidth * 2)) / 3
			self.RightWidth  = (w - (self.DividerWidth * 2)) / 3
		else
			self.LeftWidth   = (w - self.DividerWidth) / 2
			self.MiddleWidth = 0
			self.RightWidth  = (w - self.DividerWidth) / 2
		end
	end

	if (IsValid(self.LeftPnl)) then
		self.LeftPnl:SetSize(self.LeftWidth, h)
		self.LeftPnl:AlignLeft(0)
	end
	if (IsValid(self.MiddlePnl)) then
		self.MiddlePnl:SetSize(self.MiddleWidth, h)
		self.MiddlePnl:AlignLeft(self.LeftWidth + self.DividerWidth)
	end
	if (IsValid(self.RightPnl)) then
		self.RightPnl:SetSize(self.RightWidth, h)
		self.RightPnl:AlignRight(0)
	end
end

function PANEL:Paint(w,h)
	if (not IsValid(self.LeftPnl) or not IsValid(self.RightPnl)) then return end

	surface.SetDrawColor(51,80,114)
	surface.DrawRect(self.LeftWidth,0,self.DividerWidth,h)

	surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LARGE)
	surface.DrawTexturedRect(self.LeftWidth,0,self.DividerWidth,h)

	if (IsValid(self.MiddlePnl)) then
		surface.SetDrawColor(51,80,114)
		surface.DrawRect(w - self.RightWidth - self.DividerWidth,0,self.DividerWidth,h)

		surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LARGE)
		surface.DrawTexturedRect(w - self.RightWidth - self.DividerWidth,0,self.DividerWidth,h)
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self.Dragging = true
	end
end
function PANEL:OnCursorMoved(x,y)
	local w,h = self:GetSize()
	if (self.Dragging) then
		
	end
end
function PANEL:OnMouseReleased(m)
	if (m == MOUSE_LEFT) then
		self.Dragging = nil
	end
end

derma.DefineControl("bVGUI.HorizontalDivider", nil, PANEL, "DHorizontalDivider")