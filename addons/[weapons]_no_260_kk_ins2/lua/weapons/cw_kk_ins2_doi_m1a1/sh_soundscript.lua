--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_m1a1/sh_soundscript.lua
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
		{time = 24/32, sound = "CW_KK_INS2_DOI_M1A1_STOCK1"},
		{time = 38/32, sound = "CW_KK_INS2_DOI_M1A1_STOCK2"},
		{time = 67/32, sound = "CW_KK_INS2_DOI_M1A1_RATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1A1_EMPTY"},
	},

	base_reload = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1A1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1A1_MAGOUT"},
		{time = 71/35, sound = "CW_KK_INS2_DOI_M1A1_MAGIN"},
		-- { event 46 72 ""},
	},

	base_reloadempty = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1A1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1A1_MAGOUT"},
		{time = 78/35, sound = "CW_KK_INS2_DOI_M1A1_MAGIN"},
		-- { event 46 79 ""},
		{time = 123/35, sound = "CW_KK_INS2_DOI_M1A1_BOLTBACK"},
		{time = 131/35, sound = "CW_KK_INS2_DOI_M1A1_BOLTRELEASE"},
	},

	base_reload_ext = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1A1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1A1_MAGOUT"},
		{time = 71/35, sound = "CW_KK_INS2_DOI_M1A1_MAGIN"},
		-- { event 46 72 ""},
	},

	base_reloadempty_ext = {
		{time = 18/35, sound = "CW_KK_INS2_DOI_M1A1_MAGRELEASE"},
		{time = 24/35, sound = "CW_KK_INS2_DOI_M1A1_MAGOUT"},
		{time = 78/35, sound = "CW_KK_INS2_DOI_M1A1_MAGIN"},
		-- { event 46 79 ""},
		{time = 123/35, sound = "CW_KK_INS2_DOI_M1A1_BOLTBACK"},
		{time = 131/35, sound = "CW_KK_INS2_DOI_M1A1_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_M1A1_EMPTY"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_melee_end = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
