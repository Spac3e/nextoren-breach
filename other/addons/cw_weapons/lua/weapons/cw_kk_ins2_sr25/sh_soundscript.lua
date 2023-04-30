--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_sr25/sh_soundscript.lua
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
		{time = 10/30, sound = "CW_KK_INS2_SR25_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SR25_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	base_fireselect = {
		{time = 8/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	base_fireselect_empty = {
		{time = 8/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	base_reload = {
		{time = 19/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 73/30, sound = "CW_KK_INS2_SR25_MAGIN"},
	},

	base_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 73/30, sound = "CW_KK_INS2_SR25_MAGIN"},
		{time = 113/30, sound = "CW_KK_INS2_SR25_BOLTBACK"},
		{time = 127/30, sound = "CW_KK_INS2_SR25_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	iron_fireselect_empty = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 10/30, sound = "CW_KK_INS2_SR25_BOLTBACK"},
		{time = 23/30, sound = "CW_KK_INS2_SR25_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_draw_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_holster_empty = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_reload = {
		{time = 16/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 73/30, sound = "CW_KK_INS2_SR25_MAGIN"},
	},

	foregrip_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 24/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 73/30, sound = "CW_KK_INS2_SR25_MAGIN"},
		{time = 113/30, sound = "CW_KK_INS2_SR25_BOLTBACK"},
		{time = 127/30, sound = "CW_KK_INS2_SR25_BOLTRELEASE"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	foregrip_iron_dryfire_b = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	foregrip_iron_fireselect_empty = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	foregrip_fireselect_empty = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	foregrip_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	deployed_in = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 23/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_in_empty = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYSTART"},
		{time = 23/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_DEPLOYEND"},
	},

	deployed_out = {
		{time = 7/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_out_empty = {
		{time = 7/30, sound = "CW_KK_INS2_UNIVERSAL_BIPOD_RETRACT"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	deployed_fireselect = {
		{time = 8/24, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	deployed_fireselect_empty = {
		{time = 8/24, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	deployed_reload_half = {
		{time = 19/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_SR25_MAGIN"},
	},

	deployed_reload_empty = {
		{time = 16/30, sound = "CW_KK_INS2_SR25_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_SR25_MAGOUT"},
		{time = 63/30, sound = "CW_KK_INS2_SR25_MAGIN"},
		{time = 101/30, sound = "CW_KK_INS2_SR25_BOLTBACK"},
		{time = 115/30, sound = "CW_KK_INS2_SR25_BOLTRELEASE"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_SR25_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 8/24, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	deployed_iron_fireselect_empty = {
		{time = 8/24, sound = "CW_KK_INS2_SR25_FIRESELECT"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl_empty = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
