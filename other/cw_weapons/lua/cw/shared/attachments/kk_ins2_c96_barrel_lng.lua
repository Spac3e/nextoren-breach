--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_c96_barrel_lng.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_c96_barrel_lng"
att.displayName = "Long Barrel"
att.displayNameShort = "Long"
att.WeaponLength = 12
att.isSight = true
att.aimPos = {"LongBarrelPos", "LongBarrelAng"}
att.FOVModifier = 0

att.statModifiers = {
	VelocitySensitivityMult = -0.3,
	// OverallMouseSensMult = -0.15,
	RecoilMult = -0.2,
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.description = {}
end

function att:attachFunc()
	self.MuzzleAttachmentName_Orig = self.MuzzleAttachmentName_Orig or self.MuzzleAttachmentName
	self.MuzzleAttachmentName = "muzzle_carbine"
end

function att:detachFunc()
	self.MuzzleAttachmentName = self.MuzzleAttachmentName_Orig
end

CustomizableWeaponry:registerAttachment(att)
