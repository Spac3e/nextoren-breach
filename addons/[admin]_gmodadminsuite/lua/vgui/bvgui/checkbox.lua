--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/checkbox.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

local checked_mat = Material("vgui/bvgui/checked.png", "smooth")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
	self:SetSize(18,18)

	self.Checked = false
end

local checkbox_bg = Color(47,53,66)
local check_size = 12
function PANEL:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, checkbox_bg)

	if (self.CheckedIconOpacity) then
		self.CheckedIconOpacity:DoLerp()
		surface.SetMaterial(checked_mat)
		surface.SetDrawColor(255,255,255,self.CheckedIconOpacity:GetValue())
		surface.DrawTexturedRect(w / 2 - check_size / 2, h / 2 - check_size / 2, check_size, check_size)
	end
end

function PANEL:OnMouseReleased()
	if (not self.CheckedIconOpacity) then
		self.CheckedIconOpacity = bVGUI.Lerp(0,255,.5)
	end
	self:SetChecked(not self:GetChecked())
	if (self:GetChecked()) then
		GAS:PlaySound("btn_on")
		self.CheckedIconOpacity:SetTo(255)
	else
		GAS:PlaySound("btn_off")
		self.CheckedIconOpacity:SetTo(0)
	end
	if (self.OnChange) then
		self:OnChange()
	end
end

function PANEL:SetChecked(checked)
	if (not self.CheckedIconOpacity) then
		if (checked) then
			self.CheckedIconOpacity = bVGUI.Lerp(255,255,.5)
		else
			self.CheckedIconOpacity = bVGUI.Lerp(0,0,.5)
		end
	else
		if (checked) then
			self.CheckedIconOpacity:SetTo(255)
		else
			self.CheckedIconOpacity:SetTo(0)
		end
	end
	self.Checked = checked
end
function PANEL:GetChecked()
	return self.Checked
end

function PANEL:SetTooltip(text)
	self.Tooltip = text
end
function PANEL:OnCursorEntered()
	if (self.Tooltip) then
		bVGUI.CreateTooltip({
			VGUI_Element = self,
			Text = self.Tooltip
		})
	end
end
function PANEL:OnCursorExited()
	if (self.Tooltip) then
		bVGUI.DestroyTooltip()
	end
end

derma.DefineControl("bVGUI.Checkbox", nil, PANEL, "DPanel")