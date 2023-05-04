--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1917/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_DOI_M1917_FIRE", "weapons/m1917/m1917_fp.wav", 1, 105, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_CLOSECHAMBER", "weapons/m1917/handling/m1917_close_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_COCKHAMMER", "weapons/m1917/handling/m1917_cock_hammer.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_COCKHAMMERREADY", "weapons/m1917/handling/m1917_cock_hammer_ready.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_DUMPROUNDS", {
	"weapons/m1917/handling/m1917_dump_rounds_01.wav",
	"weapons/m1917/handling/m1917_dump_rounds_02.wav",
	"weapons/m1917/handling/m1917_dump_rounds_03.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_EMPTY", "weapons/m1917/handling/m1917_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_MOONCLIP", {
	"weapons/m1917/handling/m1917_moonclip_insert_01.wav",
	"weapons/m1917/handling/m1917_moonclip_insert_02.wav",
	"weapons/m1917/handling/m1917_moonclip_insert_03.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_OPENCHAMBER", "weapons/m1917/handling/m1917_open_chamber.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_DOI_M1917_INSERTSINGLE", {
	"weapons/m1917/handling/m1917_round_insert_single_01.wav",
	"weapons/m1917/handling/m1917_round_insert_single_02.wav",
	"weapons/m1917/handling/m1917_round_insert_single_03.wav",
	"weapons/m1917/handling/m1917_round_insert_single_04.wav",
	"weapons/m1917/handling/m1917_round_insert_single_05.wav",
	"weapons/m1917/handling/m1917_round_insert_single_06.wav"
})
