--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_dvl10/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_DVL10_FIRE", "weapons/dvl10/m40a1_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_DVL10_FIRE_SUPPRESSED", "weapons/dvl10/m40a1_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_BOLTBACK", "weapons/dvl10/handling/m40a1_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_BOLTFORWARD", "weapons/dvl10/handling/m40a1_boltforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_BOLTLATCH", "weapons/dvl10/handling/m40a1_boltlatch.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_BOLTRELEASE", "weapons/dvl10/handling/m40a1_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_BULLETIN", {
	"weapons/dvl10/handling/m40a1_bulletin_1.wav",
	"weapons/dvl10/handling/m40a1_bulletin_2.wav",
	"weapons/dvl10/handling/m40a1_bulletin_3.wav",
	"weapons/dvl10/handling/m40a1_bulletin_4.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DVL10_EMPTY", "weapons/dvl10/handling/m40a1_empty.wav")
