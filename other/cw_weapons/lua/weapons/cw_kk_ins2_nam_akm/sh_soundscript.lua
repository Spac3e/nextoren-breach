--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_akm/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	base_ready = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 19/30, sound = "CW_KK_INS2_AKM_FIRESELECT"},
		{time = 36/30, sound = "CW_KK_INS2_AKM_BOLTBACK"},
		{time = 41/30, sound = "CW_KK_INS2_AKM_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0/31, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/31, sound = "CW_KK_INS2_AKM_FIRESELECT"},
	},

	base_holster = {
		{time = 0/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
		{time = 9/33, sound = "CW_KK_INS2_AKM_FIRESELECT"},
	},

	base_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AKM_EMPTY"},
	},

	base_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_AKM_FIRESELECT"},
	},

	base_reload = {
		{time = 16/30, sound = "CW_KK_INS2_AKM_MAGRELEASE"},
		{time = 26/30, sound = "CW_KK_INS2_AKM_MAGOUT"},
		{time = 39/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
		{time = 71/30, sound = "CW_KK_INS2_AKM_MAGIN"},
		// { event 46 75 ""},
		{time = 66/30, sound = "CW_KK_INS2_AKM_RATTLE"},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_AKM_MAGRELEASE"},
		{time = 26/30, sound = "CW_KK_INS2_AKM_MAGOUT"},
		{time = 39/30, sound = "CW_KK_INS2_AKM_MAGOUTRATTLE"},
		{time = 71/30, sound = "CW_KK_INS2_AKM_MAGIN"},
		// { event 46 94 ""},
		{time = 66/30, sound = "CW_KK_INS2_AKM_RATTLE"},
		{time = 107/30, sound = "CW_KK_INS2_AKM_BOLTBACK"},
		{time = 113/30, sound = "CW_KK_INS2_AKM_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AKM_EMPTY"},
	},

	iron_fireselect = {
		{time = 9/30, sound = "CW_KK_INS2_AKM_FIRESELECT"},
	},
}
