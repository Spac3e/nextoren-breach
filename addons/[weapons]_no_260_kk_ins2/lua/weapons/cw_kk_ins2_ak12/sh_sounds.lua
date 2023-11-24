--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_ak12/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_AK74_FIRE", "weapons/ak74/ak74_fp.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_AK74_FIRE_SUPPRESSED", "weapons/ak74/ak74_suppressed_fp.wav", 1, 70, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_BOLTBACK", "weapons/ak74/handling/ak74_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_BOLTRELEASE", "weapons/ak74/handling/ak74_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_EMPTY", "weapons/ak74/handling/ak74_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_FIRESELECT", {
	"weapons/ak74/handling/ak74_fireselect_1.wav",
	"weapons/ak74/handling/ak74_fireselect_2.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_MAGIN", "weapons/ak74/handling/ak74_magin.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_MAGOUT", "weapons/ak74/handling/ak74_magout.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_MAGOUTRATTLE", "weapons/ak74/handling/ak74_magout_rattle.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_MAGRELEASE", "weapons/ak74/handling/ak74_magrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AK74_RATTLE", "weapons/ak74/handling/ak74_rattle.wav")
