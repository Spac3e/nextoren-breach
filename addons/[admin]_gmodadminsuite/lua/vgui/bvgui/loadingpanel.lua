--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/bvgui/loadingpanel.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:Init()
	self.LoadingPaint = self.Paint
end

function PANEL:Paint(w,h)
	if (not self.EndTime or SysTime() >= self.EndTime) then
		self.EndTime = SysTime() + 2
	end
	self.Rotation = ((self.EndTime - SysTime()) / 2) * 360

	if (self.Loading == true) then
		local size = 24
		surface.SetDrawColor(bVGUI.COLOR_WHITE)
		surface.SetMaterial(bVGUI.MATERIAL_LOADING_ICON)
		surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, math.Round(self.Rotation))
	end
end

function PANEL:SetLoading(is_loading)
	self.Loading = is_loading
end
function PANEL:GetLoading()
	return self.Loading
end

derma.DefineControl("bVGUI.LoadingPanel", nil, PANEL, "DPanel")
derma.DefineControl("bVGUI.LoadingScrollPanel", nil, table.Copy(PANEL), "bVGUI.ScrollPanel")