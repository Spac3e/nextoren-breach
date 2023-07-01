--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/vgui/openpermissions_horizontaldivider.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local PANEL = {}

function PANEL:SetRightWidth(width)
	self.InitialRightWidth = width

	local oldpaint = self.Paint
	self.Paint = function(self, w, h)
		self:SetLeftWidth(w - self.InitialRightWidth)
		self.Paint = oldpaint
	end
end

function PANEL:BalanceWidths()
	local oldpaint = self.Paint
	self.Paint = function(self, w, h)
		self:SetLeftWidth((w - self:GetDividerWidth()) / 2)
		self.Paint = oldpaint
	end
end

derma.DefineControl("OpenPermissions.HorizontalDivider", nil, PANEL, "DHorizontalDivider")