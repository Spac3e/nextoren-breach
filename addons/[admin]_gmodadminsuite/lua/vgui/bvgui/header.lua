--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/header.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self:SetTall(24)
	self:DockPadding(5,5,5,5)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetTextColor(bVGUI.COLOR_BLACK)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "BOLD", 14))
	self.Label:Dock(FILL)
	self.Label:SetContentAlignment(5)

	self:SetText("Header")
	self:SetColor(bVGUI.COLOR_GMOD_BLUE)
end

function PANEL:SetText(text)
	self.Text = text
	self.Label:SetText(self.Text)
end
function PANEL:SetColor(color)
	self.Color = color
	self.Label:SetTextColor(bVGUI.TextColorContrast(color))
end

function PANEL:SetIcon(icon)
	if (icon == false) then
		if (IsValid(self.IconLeft)) then
			self.IconLeft:Remove()
		end
		if (IsValid(self.IconRight)) then
			self.IconRight:Remove()
		end
	else
		if (IsValid(self.IconLeft)) then
			self.IconLeft:SetImage(icon)
		else
			self.IconLeft = vgui.Create("DImage", self)
			self.IconLeft:SetSize(16,16)
			self.IconLeft:SetImage(icon)
		end

		if (IsValid(self.IconRight)) then
			self.IconRight:SetImage(icon)
		else
			self.IconRight = vgui.Create("DImage", self)
			self.IconRight:SetSize(16,16)
			self.IconRight:SetImage(icon)
		end
	end
end

function PANEL:PerformLayout()
	if (IsValid(self.IconLeft)) then
		self.IconLeft:AlignLeft(5)
		self.IconLeft:CenterVertical()
	end
	if (IsValid(self.IconRight)) then
		self.IconRight:AlignRight(5)
		self.IconRight:CenterVertical()
	end
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(self.Color)
	surface.DrawRect(0,0,w,h)

	surface.SetMaterial(bVGUI.MATERIAL_GRADIENT_LIGHT)
	surface.DrawTexturedRect(0,0,w,h)
end
function PANEL:PaintOver(w,h)
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect(0,h - 1,w,1)
end

derma.DefineControl("bVGUI.Header", nil, PANEL, "DPanel")