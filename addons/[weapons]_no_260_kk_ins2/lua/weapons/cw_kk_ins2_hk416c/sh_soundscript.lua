--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_hk416c/sh_soundscript.lua
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
		{time = 23/32, sound = "CW_KK_INS2_HK416C_BOLTBACK"},
		{time = 36/32, sound = "CW_KK_INS2_HK416C_BOLTRELEASE"},
		{time = 55/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER" },
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_HK416C_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_HK416C_FIRESELECT"},
	},

	base_reload = {
		{time = 13/30, sound = "CW_KK_INS2_HK416C_MAGRELEASE"},
		{time = 17/30, sound = "CW_KK_INS2_HK416C_MAGOUT"},
		{time = 59/30, sound = "CW_KK_INS2_HK416C_MAGIN"},
		{time = 80/30, sound = "CW_KK_INS2_HK416C_HIT"},
	},

	base_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_HK416C_MAGRELEASE"},
		{time = 17/30, sound = "CW_KK_INS2_HK416C_MAGOUT"},
		{time = 62/30, sound = "CW_KK_INS2_HK416C_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_HK416C_HIT"},
		{time = 107/30, sound = "CW_KK_INS2_HK416C_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_HK416C_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_HK416C_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 23/32, sound = "CW_KK_INS2_HK416C_BOLTBACK"},
		{time = 36/32, sound = "CW_KK_INS2_HK416C_BOLTRELEASE"},
		{time = 55/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER" },
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_HK416C_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_HK416C_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 13/30, sound = "CW_KK_INS2_HK416C_MAGRELEASE"},
		{time = 17/30, sound = "CW_KK_INS2_HK416C_MAGOUT"},
		{time = 59/30, sound = "CW_KK_INS2_HK416C_MAGIN"},
		{time = 80/30, sound = "CW_KK_INS2_HK416C_HIT"},
	},

	foregrip_reloadempty = {
		{time = 13/30, sound = "CW_KK_INS2_HK416C_MAGRELEASE"},
		{time = 17/30, sound = "CW_KK_INS2_HK416C_MAGOUT"},
		{time = 62/30, sound = "CW_KK_INS2_HK416C_MAGIN"},
		{time = 85/30, sound = "CW_KK_INS2_HK416C_HIT"},
		{time = 107/30, sound = "CW_KK_INS2_HK416C_BOLTRELEASE"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_HK416C_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_HK416C_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
