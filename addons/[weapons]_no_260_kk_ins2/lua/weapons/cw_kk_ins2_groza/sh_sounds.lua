--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_groza/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_GROZA_FIRE", "weapons/groza/aks_fp.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_GROZA_FIRE_SUPPRESSED", "weapons/groza/aks_suppressed_fp.wav", 1, 70, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_BOLTBACK", "weapons/groza/handling/aks_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_BOLTRELEASE", "weapons/groza/handling/aks_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_EMPTY", "weapons/groza/handling/aks_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_FIRESELECT", {
	"weapons/groza/handling/aks_fireselect_1.wav",
	"weapons/groza/handling/aks_fireselect_2.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_MAGIN", "weapons/groza/handling/aks_magin.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_MAGOUT", "weapons/groza/handling/aks_magout.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_MAGOUTRATTLE", "weapons/groza/handling/aks_magout_rattle.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_MAGRELEASE", "weapons/groza/handling/aks_magrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_GROZA_RATTLE", "weapons/groza/handling/aks_rattle.wav")
