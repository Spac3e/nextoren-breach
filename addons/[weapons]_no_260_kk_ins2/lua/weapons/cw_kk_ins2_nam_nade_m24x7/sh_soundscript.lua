--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_nade_m24x7/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_DRAW"},
	},

	holster = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_GRENADE_HOLSTER"},
	},

	crawl = {
		{time = 10/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	pullbackhigh = {
		{time = 15/32, sound = "CW_KK_INS2_DOI_NADE_M24_CAPOFF"},
		{time = 44/32, sound = "CW_KK_INS2_DOI_NADE_M24_ARMDRAW"},
		// { event 3900 52 ""},
	},

	pullbackhighbake = {
		{time = 15/35.2, sound = "CW_KK_INS2_DOI_NADE_M24_CAPOFF"},
		{time = 44/35.2, sound = "CW_KK_INS2_DOI_NADE_M24_ROPEPULL"},
		{time = 55/35.2, sound = "CW_KK_INS2_DOI_NADE_M24_ARMDRAW"},
		// { event 3900 66 ""},
	},

	pullbacklow = {
		{time = 15/32, sound = "CW_KK_INS2_DOI_NADE_M24_CAPOFF"},
		{time = 39/32, sound = "CW_KK_INS2_DOI_NADE_M24_ARMDRAW"},
		// { event 3900 49 ""},
	},

	throw = {
		{time = 14/33.5, sound = "CW_KK_INS2_DOI_NADE_M24_ROPEPULL"},
		{time = 30/33.5, sound = "CW_KK_INS2_DOI_NADE_M24_THROW"},
		// { event 3005 31 ""},
	},

	throwback = {
		{time = 14/30, sound = "CW_KK_INS2_DOI_NADE_M24_ARMDRAW"},
		// { event 3900 25 ""},
	},

	bakethrow = {
		{time = 6/31.5, sound = "CW_KK_INS2_DOI_NADE_M24_THROW"},
		// { event 3013 6 ""},
	},

	lowthrow = {
		{time = 10/31.5, sound = "CW_KK_INS2_DOI_NADE_M24_ROPEPULL"},
		{time = 23/31.5, sound = "CW_KK_INS2_DOI_NADE_M24_THROW"},
		// { event 3016 24 ""},
	},
}
