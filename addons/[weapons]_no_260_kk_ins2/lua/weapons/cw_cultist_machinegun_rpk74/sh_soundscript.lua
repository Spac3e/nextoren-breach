--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_machinegun_rpk74/sh_soundscript.lua
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
		{time = 14/28, sound = "CW_KK_INS2_RPK_FIRESELECT"},
		{time = 29/28, sound = "CW_KK_INS2_RPK_BOLTBACK"},
		{time = 41/28, sound = "CW_KK_INS2_RPK_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 15/30, sound = "CW_KK_INS2_UNIVERSAL_RightCrawl"},
		{time = 38/30, sound = "CW_KK_INS2_UNIVERSAL_LeftCrawl"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_RPK_EMPTY"},
	},

	base_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_RPK_FIRESELECT"},
	},

	base_reload = {
		{time = 20/30, sound = "CW_KK_INS2_RPK_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_RPK_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_RPK_MAGOUTRATTLE"},
		{time = 50/30, sound = "CW_KK_INS2_RPK_FETCHMAG"},
		{time = 97/30, sound = "CW_KK_INS2_RPK_MAGIN"},
		{time = 122/30, sound = "CW_KK_INS2_RPK_RATTLE"},
	},

	base_reloadempty = {
		{time = 20/30, sound = "CW_KK_INS2_RPK_MAGRELEASE"},
		{time = 23/30, sound = "CW_KK_INS2_RPK_MAGOUT"},
		{time = 35/30, sound = "CW_KK_INS2_RPK_MAGOUTRATTLE"},
		{time = 50/30, sound = "CW_KK_INS2_RPK_FETCHMAG"},
		{time = 97/30, sound = "CW_KK_INS2_RPK_MAGIN"},
		{time = 122/30, sound = "CW_KK_INS2_RPK_RATTLE"},
		{time = 146/30, sound = "CW_KK_INS2_RPK_BOLTBACK"},
		{time = 153/30, sound = "CW_KK_INS2_RPK_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_RPK_EMPTY"},
	},

	iron_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_RPK_FIRESELECT"},
	},

	deployed_in = {
		{time = 16/30, sound = "CW_KK_INS2_RPK_BIPODDEPLOY"},
	},

	deployed_out = {
		{time = 13/30, sound = "CW_KK_INS2_RPK_MAGOUTRATTLE"},
		{time = 20/30, sound = "CW_KK_INS2_RPK_BIPODRETRACT"},
	},

	deployed_dryfire = {
		{time = 0, sound = "CW_KK_INS2_RPK_EMPTY"},
	},

	deployed_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_RPK_FIRESELECT"},
	},

	deployed_reload = {
		{time = 16/30, sound = "CW_KK_INS2_RPK_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_RPK_MAGOUT"},
		{time = 44/30, sound = "CW_KK_INS2_RPK_MAGOUTRATTLE"},
		{time = 80/30, sound = "CW_KK_INS2_RPK_FETCHMAG"},
		{time = 111/30, sound = "CW_KK_INS2_RPK_MAGIN"},
		{time = 130/30, sound = "CW_KK_INS2_RPK_ENDDEPLOYEDRELOAD"},
	},

	deployed_reloadempty = {
		{time = 16/30, sound = "CW_KK_INS2_RPK_MAGRELEASE"},
		{time = 35/30, sound = "CW_KK_INS2_RPK_MAGOUT"},
		{time = 44/30, sound = "CW_KK_INS2_RPK_MAGOUTRATTLE"},
		{time = 80/30, sound = "CW_KK_INS2_RPK_FETCHMAG"},
		{time = 111/30, sound = "CW_KK_INS2_RPK_MAGIN"},
		{time = 150/30, sound = "CW_KK_INS2_RPK_BOLTBACK"},
		{time = 157/30, sound = "CW_KK_INS2_RPK_BOLTRELEASE"},
		{time = 168/30, sound = "CW_KK_INS2_RPK_ENDDEPLOYEDRELOAD"},
	},

	deployed_iron_idle = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_IronIdle"},
	},

	deployed_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_RPK_EMPTY"},
	},

	deployed_iron_fireselect = {
		{time = 17/30, sound = "CW_KK_INS2_RPK_FIRESELECT"},
	},
}
