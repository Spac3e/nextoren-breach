--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_mat49/sh_soundscript.lua
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
		{time = 21/30, sound = "CW_KK_INS2_MP40_BOLTUNLOCK"},
		{time = 53/30, sound = "CW_KK_INS2_MP40_BOLTLOCK"},
		{time = 63/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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
		{time = 0, sound = "CW_KK_INS2_MP40_EMPTY"},
	},

	base_reload = {
		{time = 18/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 33/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 84 ""},
	},

	base_reloadempty = {
		{time = 18/30, sound = "CW_KK_INS2_MP40_MAGRELEASE"},
		{time = 33/30, sound = "CW_KK_INS2_MP40_MAGOUT"},
		{time = 77/30, sound = "CW_KK_INS2_MP40_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_MP40_MAGHIT"},
		// { event 46 109 ""},
		{time = 110/30, sound = "CW_KK_INS2_MP40_BOLTBACK"},
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
