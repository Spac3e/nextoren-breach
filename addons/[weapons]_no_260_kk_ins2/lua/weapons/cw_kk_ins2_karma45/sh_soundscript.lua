--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_karma45/sh_soundscript.lua
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
		{time = 12/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 13/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	base_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 70/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
	},

	base_reloadempty = {
		{time = 12/30, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 18/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 19/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 70/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		{time = 98/30, sound = "CW_KK_INS2_MP5K_BOLTLOCK"},
		{time = 105/30, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	iron_fireselect = {
		{time = 6/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
