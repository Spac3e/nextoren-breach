--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw/shared/attachments/kk_ins2_sawnoff_generic.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local att = {}
att.name = "kk_ins2_sawnoff_generic"
att.displayNameShort = "Hacksaw"
att.displayName = "CQC Variant"
att.isBG = true
att.KK_INS2_playIdle = true
att.WeaponLength = -16

att.statModifiers = {
	AimSpreadMult = 0.1,
	DrawSpeedMult = 0.05,
	VelocitySensitivityMult = 0.2,
	// OverallMouseSensMult = 0.1,
	DamageMult = 0.1,
	RecoilMult = 0.2,
}

if CLIENT then
	-- att.displayIcon = surface.GetTextureID("atts/" .. att.name)
	att.displayIcon = surface.GetTextureID("atts/kk_dogg")
	att.description = {}
end

CustomizableWeaponry:registerAttachment(att)
