--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_revolver_mag.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_revolver_mag"
att.displayName = "Revolver Speed-loader"
att.displayNameShort = "Speed"

att.statModifiers = {}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Speeds reload up.", c = CustomizableWeaponry.textColors.POSITIVE},
		[2] = {t = "Incredibly.", c = CustomizableWeaponry.textColors.VPOSITIVE},
	}
end

local ep3 = {t = "Detaching unloads all allocated magazines.", c = CustomizableWeaponry.textColors.REGULAR}

function att:attachFunc()
	if CustomizableWeaponry.magSystem and CLIENT then
		att.description[3] = ep3
	end

	self.ShotgunReload = false
	self.magType = "revLoader"
end

function att:detachFunc()
	self.ShotgunReload = true

	if CustomizableWeaponry.magSystem and SERVER then
		local residueAmmo = 0

		for key, value in pairs(self.allocatedMags) do
			if value > 0 then
				residueAmmo = residueAmmo + value
				self.allocatedMags[key] = 0
			end
		end

		if residueAmmo > 0 then
			self.Owner:GiveAmmo(residueAmmo, self.Primary.Ammo)
			self:networkMags()
		end
	end

	self.magType = "NONE"
end

CustomizableWeaponry:registerAttachment(att)
