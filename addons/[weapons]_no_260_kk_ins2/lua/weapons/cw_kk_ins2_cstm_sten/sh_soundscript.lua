--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_sten/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_cstm_sten/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 19/31.2, sound = "CW_KK_INS2_M4A1_HIT"},
		{time = 41/31.2, sound = "CW_KK_INS2_M1A1_BOLTBACK"},
		{time = 66/31.2, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 14/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},

	base_reload = {
		{time = 17/31.2, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 23/31.2, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 69/31.2, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 76/31.2, sound = "CW_KK_INS2_MP40_MAGHIT"},
		-- { event 46 76 ""},
		{time = 95/31.2, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	base_reloadempty = {
		{time = 28/30, sound = "CW_KK_INS2_MP40_BOLTBACK"},
		{time = 31/30, sound = "CW_KK_INS2_MP40_BOLTLOCK"},
		{time = 36/30, sound = "CW_KK_INS2_MP40_BOLTUNLOCK"},
		{time = 61/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 69/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 120/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 129/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		-- { event 46 129 ""},
		{time = 150/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},
}


