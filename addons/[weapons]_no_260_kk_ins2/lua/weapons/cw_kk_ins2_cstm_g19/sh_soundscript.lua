--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_g19/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_cstm_g19/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
		{time = 4/30, sound = "CW_KK_INS2_MAKAROV_SAFETY"},
		{time = 14/30, sound = "CW_KK_INS2_CSTM_G19_BOLTBACK"},
		{time = 20/30, sound = "CW_KK_INS2_CSTM_G19_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	base_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_MAKAROV_EMPTY"},
	},

	base_reload = {
		{time = 0/30, sound = "CW_KK_INS2_CSTM_G19_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_CSTM_G19_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MAKAROV_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_CSTM_G19_MAGHIT"},
	},

	base_reloadempty = {
		{time = 0/30, sound = "CW_KK_INS2_CSTM_G19_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_CSTM_G19_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MAKAROV_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_CSTM_G19_MAGHIT"},
		{time = 71/30, sound = "CW_KK_INS2_CSTM_G19_BOLTRELEASE"},
	},

	base_reload_extmag = {
		{time = 0/30, sound = "CW_KK_INS2_CSTM_G19_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_CSTM_G19_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MAKAROV_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_CSTM_G19_MAGHIT"},
	},

	base_reloadempty_extmag = {
		{time = 0/30, sound = "CW_KK_INS2_CSTM_G19_MAGRELEASE"},
		{time = 7/30, sound = "CW_KK_INS2_CSTM_G19_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_MAKAROV_MAGIN"},
		{time = 58/30, sound = "CW_KK_INS2_CSTM_G19_MAGHIT"},
		{time = 71/30, sound = "CW_KK_INS2_CSTM_G19_BOLTRELEASE"},
	},

	empty_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_DRAW"},
	},

	empty_holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_PISTOL_HOLSTER"},
	},

	empty_crawl = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/35, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_MAKAROV_EMPTY"},
	},
}


