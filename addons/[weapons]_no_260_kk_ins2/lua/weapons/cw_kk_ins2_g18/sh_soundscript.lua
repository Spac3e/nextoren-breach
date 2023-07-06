--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   addons/[weapons]_new_weapons/lua/weapons/cw_kk_ins2_g18/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 4/30, sound = "CW_KK_INS2_M9_SAFETY"},
		{time = 9/30, sound = "CW_KK_INS2_M9_BOLTBACK"},
		{time = 19/30, sound = "CW_KK_INS2_M9_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M9_EMPTY"},
	},

	base_reload = {
		{time = 0/30, sound = "CW_KK_INS2_M9_MAGRELEASE"},
		{time = 16/30, sound = "CW_KK_INS2_M9_MAGOUT"},
		{time = 48/30, sound = "CW_KK_INS2_M9_MAGIN"},
		{time = 54/30, sound = "CW_KK_INS2_M9_MAGHIT"},
	},

	base_reloadempty = {
		{time = 0/30, sound = "CW_KK_INS2_M9_MAGRELEASE"},
		{time = 10/30, sound = "CW_KK_INS2_M9_MAGOUT"},
		{time = 40/30, sound = "CW_KK_INS2_M9_MAGIN"},
		{time = 46/30, sound = "CW_KK_INS2_M9_MAGHIT"},
		{time = 65/30, sound = "CW_KK_INS2_M9_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_M9_EMPTY"},
	},

	base_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	empty_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
