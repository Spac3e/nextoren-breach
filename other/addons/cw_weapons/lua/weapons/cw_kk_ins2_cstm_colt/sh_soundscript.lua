--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_cstm_colt/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_cstm_colt/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 9/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 17/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
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
		{time = 1/30, sound = "CW_KK_INS2_M1A1_EMPTY"},


	},

	base_reload = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 60/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		// { event 46 68 ""},


	},

	base_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_M4A1_HIT"},
		// { event 46 85 ""},
		{time = 111/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},


	},

	base_reload_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 60/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		// { event 46 68 ""},
	},

	base_reloadempty_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_M4A1_HIT"},
		// { event 46 85 ""},
		{time = 111/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 1/30, sound = "CW_KK_INS2_M1A1_EMPTY"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 9/30, sound = "CW_KK_INS2_M4A1_BOLTBACK"},
		{time = 17/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_dryfire = {
		{time = 1/30, sound = "CW_KK_INS2_M1A1_EMPTY"},
	},

	foregrip_reload = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 60/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		// { event 46 68 ""},
	},

	foregrip_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_M4A1_HIT"},
		// { event 46 85 ""},
		{time = 111/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
	},

	foregrip_reload_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 60/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		// { event 46 68 ""},
	},

	foregrip_reloadempty_ext = {
		{time = 13/30, sound = "CW_KK_INS2_M4A1_MAGHITRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_M4A1_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_M4A1_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_M4A1_HIT"},
		// { event 46 85 ""},
		{time = 111/30, sound = "CW_KK_INS2_M4A1_BOLTRELEASE"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M1A1_EMPTY"},
	},
}


