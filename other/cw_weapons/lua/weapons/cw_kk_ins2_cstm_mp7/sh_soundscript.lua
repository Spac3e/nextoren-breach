--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_mp7/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_cstm_mp7/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 16/32.5, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_SWIVEL"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 30/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	base_fireselect = {
		{time = 10/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},

	base_reload = {
		{time = 23/30, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 26/30, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 57/30, sound = "CW_KK_INS2_MP5K_MAGIN"},
		-- { event 46 60 ""},
	},

	base_reloadempty = {
		{time = 15/32, sound = "CW_KK_INS2_MP5K_MAGRELEASE"},
		{time = 22/32, sound = "CW_KK_INS2_MP5K_MAGOUT"},
		{time = 62/32, sound = "CW_KK_INS2_MP5K_MAGIN"},
		{time = 100/32, sound = "CW_KK_INS2_MP5K_BOLTBACK"},
		{time = 113/32, sound = "CW_KK_INS2_MP5K_BOLTRELEASE"},
		-- { event 46 116 ""},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MP5K_EMPTY"},
	},

	iron_fireselect = {
		{time = 10/30, sound = "CW_KK_INS2_MP5K_FIRESELECT"},
	},
}


