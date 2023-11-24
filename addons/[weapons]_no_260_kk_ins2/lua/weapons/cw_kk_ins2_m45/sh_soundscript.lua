--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_m45/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_m45/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 4/30, sound = "CW_KK_INS2_M45_SAFETY"},
		{time = 9/30, sound = "CW_KK_INS2_M45_BOLTBACK"},
		{time = 19/30, sound = "CW_KK_INS2_M45_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M45_EMPTY"},
	},

	base_reload = {
		{time = 0, sound = "CW_KK_INS2_M45_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_M45_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_M45_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_M45_MAGHIT"},
	},

	base_reload_extmag = {
		{time = 0, sound = "CW_KK_INS2_M45_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_M45_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_M45_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_M45_MAGHIT"},
	},

	base_reloadempty = {
		{time = 0/30, sound = "CW_KK_INS2_M45_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_M45_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_M45_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_M45_MAGHIT"},
		{time = 71/30, sound = "CW_KK_INS2_M45_BOLTRELEASE"},
	},

	base_reloadempty_extmag = {
		{time = 0/30, sound = "CW_KK_INS2_M45_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_M45_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_M45_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_M45_MAGHIT"},
		{time = 71/30, sound = "CW_KK_INS2_M45_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M45_EMPTY"},
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


