--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1912/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_M1912_FIRE", "weapons/m1912/m1912_fp.wav", 1, 105, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1912_EMPTY", "weapons/m1912/handling/m1912_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1912_PUMPBACK", "weapons/m1912/handling/m1912_pumpback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1912_PUMPFORWARD", "weapons/m1912/handling/m1912_pumpforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1912_SHELLINSERT", {
	"weapons/m1912/handling/m1912_shell_insert_1.wav",
	"weapons/m1912/handling/m1912_shell_insert_2.wav",
	"weapons/m1912/handling/m1912_shell_insert_3.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1912_SHELLINSERTSINGLE", {
	"weapons/m1912/handling/m1912_single_shell_insert_1.wav",
	"weapons/m1912/handling/m1912_single_shell_insert_2.wav",
	"weapons/m1912/handling/m1912_single_shell_insert_3.wav"
})
