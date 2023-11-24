--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_toz/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_toz/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_TOZ_FIRE", "weapons/toz_shotgun/toz_fp.wav", 1, 105, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_TOZ_FIRE_SUPPRESSED", "weapons/toz_shotgun/toz_suppressed_fp.wav", 1, 75, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_TOZ_EMPTY", "weapons/toz_shotgun/handling/toz_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_TOZ_PUMPBACK", "weapons/toz_shotgun/handling/toz_pumpback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_TOZ_PUMPFORWARD", "weapons/toz_shotgun/handling/toz_pumpforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_TOZ_SHELLINSERT", {
	"weapons/toz_shotgun/handling/toz_shell_insert_1.wav",
	"weapons/toz_shotgun/handling/toz_shell_insert_2.wav",
	"weapons/toz_shotgun/handling/toz_shell_insert_3.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_TOZ_SHELLINSERTSINGLE", {
	"weapons/toz_shotgun/handling/toz_single_shell_insert_1.wav",
	"weapons/toz_shotgun/handling/toz_single_shell_insert_2.wav",
	"weapons/toz_shotgun/handling/toz_single_shell_insert_3.wav"
})


