--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_tankshrek/sh_soundscript.lua
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
		{time = 30/30, sound = "CW_KK_INS2_DOI_TANKSHREK_SHOULDER"},
		{time = 75/30, sound = "CW_KK_INS2_DOI_TANKSHREK_RATTLE"},
		{time = 93/30, sound = "CW_KK_INS2_DOI_TANKSHREK_RESHOULDER"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 16/30, sound = "CW_KK_INS2_DOI_TANKSHREK_RATTLE"},
		{time = 30/30, sound = "CW_KK_INS2_DOI_TANKSHREK_SHOULDER"},
	},

	base_holster = {
		{time = 19/33, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 12/32, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 37/32, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_DOI_LAUNCHER_EMPTY"},
	},

	base_reload = {
		{time = 31/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_RATTLE"},
		{time = 50/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_FETCH"},
		{time = 78/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_LOAD1"},
		{time = 87/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_LOAD2"},
		{time = 114/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_WIRE"},
		{time = 160/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_RESHOULDER"},
		{time = 180/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_RATTLE"},
		{time = 199/32.5, sound = "CW_KK_INS2_DOI_TANKSHREK_SHOULDER"},
		-- { event 46 132 ""},
	},

	iron_dryfire = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_LAUNCHER_EMPTY"},
	},

	iron_dryfire_preblend = {
		{time = 1/30, sound = "CW_KK_INS2_DOI_LAUNCHER_EMPTY"},
	},

	base_melee = {
		{time = 5/31, sound = "CW_KK_INS2_DOI_MELEE"},
	},
}
