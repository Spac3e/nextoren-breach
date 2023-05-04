--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_ammo_m10.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_ammo_m10"
att.displayName = "M10A1 Smoke Rockets"
att.displayNameShort = "Smoke"
att.KK_INS2_playIdle = true

att.statModifiers = {}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {
		[1] = {t = "Swaps HEAT rockets for white phosphorus smoke rockets.", c = CustomizableWeaponry.textColors.NETURAL}
	}
end

function att:attachFunc()
	self:unloadWeapon()

	self._KK_INS2_customPickupSuffix = "_mm"
	self._KK_INS2_customReloadSuffix = "_mm"

	self.Primary.Ammo = "M10A1 Rocket"
	self.projectileClass = "cw_kk_ins2_projectile_m10"
end

function att:detachFunc()
	self:unloadWeapon()

	self._KK_INS2_customPickupSuffix = ""
	self._KK_INS2_customReloadSuffix = ""

	self.Primary.Ammo = "M6A1 Rocket"
	self.projectileClass = "cw_kk_ins2_projectile_m6a1"
end

CustomizableWeaponry:registerAttachment(att)
