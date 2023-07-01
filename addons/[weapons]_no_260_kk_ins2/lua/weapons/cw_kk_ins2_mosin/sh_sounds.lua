--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_mosin/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_mosin/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_MOSIN_FIRE", "weapons/mosin/mosin_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_MOSIN_FIRE_SUPPRESSED", "weapons/mosin/mosin_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTBACK", "weapons/mosin/handling/mosin_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTFORWARD", "weapons/mosin/handling/mosin_boltforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTLATCH", "weapons/mosin/handling/mosin_boltlatch.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BOLTRELEASE", "weapons/mosin/handling/mosin_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_BULLETIN", {
	"weapons/mosin/handling/mosin_bulletin_1.wav",
	"weapons/mosin/handling/mosin_bulletin_2.wav",
	"weapons/mosin/handling/mosin_bulletin_3.wav",
	"weapons/mosin/handling/mosin_bulletin_4.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_MOSIN_EMPTY", "weapons/mosin/handling/mosin_empty.wav")


