--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_sten_mk2/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 19/30, sound = "CW_KK_INS2_DOI_STEN_BOLTBACK"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_STEN_EMPTY"},
	},

	base_reload = {
		{time = 21/33, sound = "CW_KK_INS2_DOI_STEN_MAGRELEASE"},
		{time = 29/33, sound = "CW_KK_INS2_DOI_STEN_MAGOUT"},
		{time = 33/33, sound = "CW_KK_INS2_DOI_STEN_FETCHMAG"},
		{time = 78/33, sound = "CW_KK_INS2_DOI_STEN_MAGIN"},
		-- { event 46 80 ""},
		{time = 109/33, sound = "CW_KK_INS2_DOI_STEN_RATTLE"},
	},

	base_reloadempty = {
		{time = 21/33, sound = "CW_KK_INS2_DOI_STEN_MAGRELEASE"},
		{time = 29/33, sound = "CW_KK_INS2_DOI_STEN_MAGOUT"},
		{time = 33/33, sound = "CW_KK_INS2_DOI_STEN_FETCHMAG"},
		{time = 78/33, sound = "CW_KK_INS2_DOI_STEN_MAGIN"},
		-- { event 46 80 ""},
		{time = 109/33, sound = "CW_KK_INS2_DOI_STEN_BOLTBACK"},
		{time = 139/33, sound = "CW_KK_INS2_DOI_STEN_RATTLE"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_DOI_STEN_EMPTY"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_bash_empty = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
