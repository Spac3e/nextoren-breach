--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_mp40/sh_soundscript.lua
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
		{time = 26/30, sound = "CW_KK_INS2_DOI_MP40_BOLTUNLOCK"},
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

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	empty_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MP40_EMPTY"},
	},

	base_reload = {
		{time = 12/30, sound = "CW_KK_INS2_DOI_MP40_MAGRELEASE"},
		{time = 15/30, sound = "CW_KK_INS2_DOI_MP40_MAGOUT"},
		{time = 64/30, sound = "CW_KK_INS2_DOI_MP40_MAGIN"},
		{time = 66/30, sound = "CW_KK_INS2_DOI_MP40_MAGHIT"},
	},

	base_reloadempty = {
		{time = 14/30, sound = "CW_KK_INS2_DOI_MP40_BOLTBACK"},
		{time = 20/30, sound = "CW_KK_INS2_DOI_MP40_BOLTLOCK"},
		{time = 41/30, sound = "CW_KK_INS2_DOI_MP40_MAGRELEASE"},
		{time = 46/30, sound = "CW_KK_INS2_DOI_MP40_MAGOUT"},
		{time = 95/30, sound = "CW_KK_INS2_DOI_MP40_MAGIN"},
		{time = 97/30, sound = "CW_KK_INS2_DOI_MP40_MAGHIT"},
		{time = 114/30, sound = "CW_KK_INS2_DOI_MP40_BOLTUNLOCK"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_MP40_EMPTY"},
	},

	base_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	empty_melee_bash = {
		{time = 6/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
