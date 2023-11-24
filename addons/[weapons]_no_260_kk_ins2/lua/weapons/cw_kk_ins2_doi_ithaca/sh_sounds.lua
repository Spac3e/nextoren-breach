--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_ithaca/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_ITHC_FIRE", "weapons/ithaca/ithaca_fp.wav", 1, 105, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_EMPTY", "weapons/ithaca/handling/ithaca_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_PUMPBACK", "weapons/ithaca/handling/ithaca_pumpback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_PUMPFORWARD", "weapons/ithaca/handling/ithaca_pumpforward.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_RATTLE", "weapons/ithaca/handling/ithaca_rattle.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_SHELLINSERT", {
	"weapons/ithaca/handling/ithaca_shell_insert_1.wav",
	"weapons/ithaca/handling/ithaca_shell_insert_2.wav",
	"weapons/ithaca/handling/ithaca_shell_insert_3.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_ITHC_SHELLINSERTSINGLE", {
	"weapons/ithaca/handling/ithaca_single_shell_insert_1.wav",
	"weapons/ithaca/handling/ithaca_single_shell_insert_2.wav",
	"weapons/ithaca/handling/ithaca_single_shell_insert_3.wav"
})
