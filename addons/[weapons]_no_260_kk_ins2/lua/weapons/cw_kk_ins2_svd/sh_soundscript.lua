--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   addons/[weapons]_new_weapons/lua/weapons/cw_kk_ins2_svd/sh_soundscript.lua
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
		{time = 10/30, sound = "CW_KK_INS2_SVD_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SVD_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	base_reload = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_SVD_MAGIN"},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_SVD_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_SVD_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_SVD_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_SVD_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SVD_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_empty_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_empty_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_SVD_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_SVD_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_SVD_BOLTRELEASE"},
	},

	foregrip_reload = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_SVD_MAGIN"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	deployed_in = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 23/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out = {
		{time = 7/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	deployed_reload = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 65/30, sound = "CW_KK_INS2_SVD_MAGIN"},
	},

	deployed_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SVD_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SVD_MAGOUT"},
		{time = 67/30, sound = "CW_KK_INS2_SVD_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_SVD_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_SVD_BOLTRELEASE"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	deployed_empty_in = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 23/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_empty_out = {
		{time = 7/20, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_empty_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SVD_EMPTY"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
