--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_assrifle_volk/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_AKM_FIRE", "weapons/ak47/ak47_fp.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_AKM_FIRE_SUPPRESSED", "weapons/ak47/ak47_suppressed_fp.wav", 1, 70, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_BOLTBACK", "weapons/ak47/handling/ak47_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_BOLTRELEASE", "weapons/ak47/handling/ak47_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_EMPTY", "weapons/ak47/handling/ak47_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_FIRESELECT", {
	"weapons/ak47/handling/ak47_fireselect_1.wav",
	"weapons/ak47/handling/ak47_fireselect_2.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_MAGIN", "weapons/ak47/handling/ak47_magin.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_MAGOUT", "weapons/ak47/handling/ak47_magout.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_MAGOUTRATTLE", "weapons/ak47/handling/ak47_magout_rattle.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_MAGRELEASE", "weapons/ak47/handling/ak47_magrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKM_RATTLE", "weapons/ak47/handling/ak47_rattle.wav")
