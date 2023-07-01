--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/colormixer.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self.ColorMixer = vgui.Create("DColorMixer", self)
	self.ColorMixer:SetPalette(false)
end

function PANEL:SetColor(col)
	self.ColorMixer:SetColor(col)
end
function PANEL:GetColor()
	return self.ColorMixer:GetColor()
end

function PANEL:SetLabel(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContentsX()
	self.Label:SetTall(21)
end

function PANEL:PerformLayout()
	self.ColorMixer:AlignBottom(0)
	if (IsValid(self.Label)) then
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall() - self.Label:GetTall())
	else
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall())
	end
end

derma.DefineControl("bVGUI.ColorMixer", nil, PANEL, "bVGUI.BlankPanel")