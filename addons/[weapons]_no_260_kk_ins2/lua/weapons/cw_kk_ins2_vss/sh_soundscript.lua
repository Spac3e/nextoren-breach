--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_vss/sh_soundscript.lua
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
		{time = 21/30, sound = "CW_KK_INS2_VSS_BOLTBACK"},
		{time = 25/30, sound = "CW_KK_INS2_VSS_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_VSS_EMPTY"},
	},

	base_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_VSS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_VSS_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_VSS_MAGIN"},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_VSS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_VSS_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_VSS_MAGIN"},
		{time = 98/30, sound = "CW_KK_INS2_VSS_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_VSS_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_VSS_EMPTY"},
	},

	iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_VSS_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_VSS_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_VSS_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 19/30, sound = "CW_KK_INS2_VSS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_VSS_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_VSS_MAGIN"},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_VSS_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_VSS_MAGOUT"},
		{time = 66/30, sound = "CW_KK_INS2_VSS_MAGIN"},
		{time = 98/30, sound = "CW_KK_INS2_VSS_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_VSS_BOLTRELEASE"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_VSS_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 13/30, sound = "CW_KK_INS2_M14_FIRESELECT"},
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
