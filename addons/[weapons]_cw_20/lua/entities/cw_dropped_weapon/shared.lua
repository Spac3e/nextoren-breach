--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/entities/cw_dropped_weapon/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "cw_attpack_base"
ENT.PrintName = "Dropped CW 2.0 weapon"
ENT.Author = "Spy"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.pickupDotProduct = 0.98 -- closer to 1 - need to look in a more general direction towards the weapon
ENT.giveAttachmentsOnPickup = true -- whether the player should be given the attachments that are attached on the weapon upon pickup (if he is not given them, then upon pickup, the attachments the player does not have will not be attached)

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "WepClass")
end

function ENT:canPickup(activator)
	local canPickupWeapon = not activator:HasWeapon(self:GetWepClass())
	local canPickupAttachments = false
	
	if self.giveAttachmentsOnPickup then
		canPickupAttachments = not CustomizableWeaponry:hasSpecifiedAttachments(activator, self.stringAttachmentIDs)
	end
	
	return canPickupWeapon, canPickupAttachments
end

function ENT:getAttachments()
	return self.containedAttachments, self.stringAttachmentIDs
end