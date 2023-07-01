--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/entities/cw_dropped_weapon/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include("shared.lua")
ENT.dataRequestTime = 0

function ENT:Initialize()
end

function ENT:getMainText()
	return self.weaponName
end

function ENT:Think()
	if self.inRange and (not self.containedAttachments or not self.weaponName) then
		if CurTime() > self.dataRequestTime then
			RunConsoleCommand("cw_request_wep_data", self:EntIndex())
			self.dataRequestTime = CurTime() + 1
		end
	end
end

local green = Color(215, 255, 160, 255)

function ENT:getNoAttachmentColor()
	return green
end

function ENT:getAttachmentColor()
	return green
end

net.Receive("CW_DROPPED_WEAPON_ATTACHMENTS", function()
	local entity = net.ReadEntity()
	
	if IsValid(entity) and entity:GetClass() == "cw_dropped_weapon" then
		local attachments = net.ReadTable()
		entity.containedAttachments = attachments
		entity.weaponName = weapons.GetStored(entity:GetWepClass()).PrintName
		
		entity:setupAttachmentDisplayData()
	end
end)