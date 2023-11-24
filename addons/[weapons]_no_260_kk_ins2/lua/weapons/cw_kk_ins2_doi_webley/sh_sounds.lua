--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_webley/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_WEBLEY_FIRE", "weapons/webley/webley_fp.wav", 1, 105, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_CLOSECHAMBER", "weapons/webley/handling/webley_close_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_COCKHAMMER", "weapons/webley/handling/webley_cock_hammer.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_COCKHAMMERREADY", "weapons/webley/handling/webley_cock_hammer_ready.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_DUMPROUNDS", {
	"weapons/webley/handling/webley_dump_rounds_01.wav",
	"weapons/webley/handling/webley_dump_rounds_02.wav",
	"weapons/webley/handling/webley_dump_rounds_03.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_EMPTY", "weapons/webley/handling/webley_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_OPENCHAMBER", "weapons/webley/handling/webley_open_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_INSERTSINGLE", {
	"weapons/webley/handling/webley_round_insert_single_01.wav",
	"weapons/webley/handling/webley_round_insert_single_02.wav",
	"weapons/webley/handling/webley_round_insert_single_03.wav",
	"weapons/webley/handling/webley_round_insert_single_04.wav",
	"weapons/webley/handling/webley_round_insert_single_05.wav",
	"weapons/webley/handling/webley_round_insert_single_06.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_WEBLEY_SPEEDLOADERINSERT", "weapons/webley/handling/webley_speed_loader_insert_01.wav")
