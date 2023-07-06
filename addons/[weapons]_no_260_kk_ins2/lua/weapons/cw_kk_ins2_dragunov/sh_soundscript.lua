--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_dragunov/sh_soundscript.lua
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
		{time = 10/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DRAGUNOV_EMPTY"},
	},

	base_reload = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
	},

	base_reload_ext = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	base_reloadempty_ext = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DRAGUNOV_EMPTY"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DRAGUNOV_EMPTY"},
	},

	foregrip_reload = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
	},

	foregrip_reload_ext = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	foregrip_reloadempty_ext = {
		{time = 16/30, sound = "CW_KK_INS2_DRAGUNOV_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_DRAGUNOV_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_DRAGUNOV_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_DRAGUNOV_BOLTRELEASE"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DRAGUNOV_EMPTY"},
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