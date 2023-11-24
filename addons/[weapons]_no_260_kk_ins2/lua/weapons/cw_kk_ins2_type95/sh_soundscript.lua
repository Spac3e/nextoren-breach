--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_type95/sh_soundscript.lua
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
		{time = 12/32, sound = "CW_KK_INS2_MK18_BOLTBACK"},
		{time = 20/32, sound = "CW_KK_INS2_MK18_BOLTRELEASE"},
		{time = 24/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER" },
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	base_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	base_reload = {
		{time = 24/30, sound = "CW_KK_INS2_MK18_MAGRELEASE"},
		{time = 30/30, sound = "CW_KK_INS2_MK18_MAGOUT"},
		{time = 76/30, sound = "CW_KK_INS2_MK18_MAGIN"},
	--	{time = 95/30, sound = "CW_KK_INS2_MK18_HIT"},
	},

	base_reloadempty = {
		{time = 26/30, sound = "CW_KK_INS2_MK18_MAGRELEASE"},
		{time = 28/30, sound = "CW_KK_INS2_MK18_MAGOUT"},
		{time = 76/30, sound = "CW_KK_INS2_MK18_MAGIN"},
		{time = 98/32, sound = "CW_KK_INS2_MK18_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_MK18_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/32, sound = "CW_KK_INS2_MK18_BOLTBACK"},
		{time = 18/32, sound = "CW_KK_INS2_MK18_BOLTRELEASE"},
		{time = 24/32, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER" },
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 11/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 24/30, sound = "CW_KK_INS2_MK18_MAGRELEASE"},
		{time = 30/30, sound = "CW_KK_INS2_MK18_MAGOUT"},
		{time = 76/30, sound = "CW_KK_INS2_MK18_MAGIN"},
	},

	foregrip_reloadempty = {
		{time = 26/30, sound = "CW_KK_INS2_MK18_MAGRELEASE"},
		{time = 28/30, sound = "CW_KK_INS2_MK18_MAGOUT"},
		{time = 76/30, sound = "CW_KK_INS2_MK18_MAGIN"},
		{time = 98/32, sound = "CW_KK_INS2_MK18_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_MK18_BOLTRELEASE"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_MK18_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_MK18_FIRESELECT"},
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
