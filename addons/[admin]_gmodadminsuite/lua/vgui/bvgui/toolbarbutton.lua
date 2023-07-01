--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/toolbarbutton.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--/// bVGUI.ToolbarButton_IMG ///--

local PANEL = {}

function PANEL:Init()
	self:SetCursor("hand")
	self.bVGUI_IMG = vgui.Create("DImage", self)
	self.bVGUI_IMG:SetSize(16,16)
end

function PANEL:Paint()
	if (self:IsHovered()) then
		if (not self._IsHovered) then
			self._IsHovered = true
			self.bVGUI_IMG:SetMaterial(self.HoverMaterial)
		end
	else
		if (self._IsHovered) then
			self._IsHovered = nil
			self.bVGUI_IMG:SetMaterial(self.DefaultMaterial)
		end
	end
end

function PANEL:SetMaterial(mat)
	self.bVGUI_IMG:SetMaterial(mat)
	self.DefaultMaterial = mat
end
function PANEL:SetHoverMaterial(mat)
	self.HoverMaterial = mat
end

function PANEL:OnMouseReleased()
	self:DoClick()
end

function PANEL:PerformLayout()
	self.bVGUI_IMG:Center()
end

derma.DefineControl("bVGUI.ToolbarButton_IMG", nil, PANEL, "DPanel")

--/// bVGUI.ToolbarButton_IMGText ///--

local PANEL = {}

function PANEL:Init()
	self:SetCursor("hand")

	self.bVGUI_IMG = vgui.Create("DImage", self)
	self.bVGUI_IMG:SetSize(16,16)

	self.bVGUI_Text = vgui.Create("DLabel", self)
	self.bVGUI_Text:SetText("Menu")
	self.bVGUI_Text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
	self.bVGUI_Text:SetTextColor(bVGUI.COLOR_DARK_GREY)
end

function PANEL:Paint()
	if (self:IsHovered()) then
		if (not self._IsHovered) then
			self._IsHovered = true
			self.bVGUI_IMG:SetMaterial(self.HoverMaterial)
			self.bVGUI_Text:SetTextColor(bVGUI.COLOR_WHITE)
		end
	else
		if (self._IsHovered) then
			self._IsHovered = nil
			self.bVGUI_IMG:SetMaterial(self.DefaultMaterial)
			self.bVGUI_Text:SetTextColor(bVGUI.COLOR_DARK_GREY)
		end
	end
end

function PANEL:SetMaterial(mat)
	self.bVGUI_IMG:SetMaterial(mat)
	self.DefaultMaterial = mat
end
function PANEL:SetHoverMaterial(mat)
	self.HoverMaterial = mat
end

function PANEL:SetText(txt)
	self.bVGUI_Text:SetText(txt)
	self:PerformLayout()
end

function PANEL:PerformLayout()
	self.bVGUI_IMG:AlignLeft(5)
	self.bVGUI_IMG:CenterVertical()

	self.bVGUI_Text:SizeToContents()
	self.bVGUI_Text:AlignLeft(5 + 16 + 5)
	self.bVGUI_Text:CenterVertical()

	self:SetWide(5 + 16 + 5 + self.bVGUI_Text:GetWide() + 5 + 2)
end

function PANEL:OnMouseReleased()
	self:DoClick()
end

derma.DefineControl("bVGUI.ToolbarButton_IMGText", nil, PANEL, "DPanel")