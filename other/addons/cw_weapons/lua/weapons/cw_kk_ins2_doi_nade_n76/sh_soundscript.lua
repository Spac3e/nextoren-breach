--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_doi_nade_n76/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	base_draw = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0/35, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 10/29, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/29, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	pullbackhigh = {
		{time = 20/30, sound = "CW_KK_INS2_DOI_NADE_N76_CAPOFF"},
		{time = 30/30, sound = "CW_KK_INS2_DOI_NADE_N76_ARMDRAW"},
		// { event 3900 41 ""},
	},

	pullbackhighbake = {
		{time = 20/30, sound = "CW_KK_INS2_DOI_NADE_N76_CAPOFF"},
		{time = 30/30, sound = "CW_KK_INS2_DOI_NADE_N76_ARMDRAW"},
		// { event 3900 41 ""},
	},

	pullbacklow = {
		{time = 20/30, sound = "CW_KK_INS2_DOI_NADE_N76_CAPOFF"},
		{time = 30/30, sound = "CW_KK_INS2_DOI_NADE_N76_ARMDRAW"},
		// { event 3900 41 ""},
	},

	throw = {
		{time = 3/31.5, sound = "CW_KK_INS2_DOI_NADE_N76_THROW"},
		// { event 3005 3 ""},
	},

	throwback = {
		{time = 14/30, sound = "CW_KK_INS2_DOI_NADE_N76_ARMDRAW"},
		// { event 3900 25 ""},
	},

	bakethrow = {
		{time = 3/31.5, sound = "CW_KK_INS2_DOI_NADE_N76_THROW"},
		// { event 3013 3 ""},
	},

	lowthrow = {
		{time = 6/31.5, sound = "CW_KK_INS2_DOI_NADE_N76_THROW"},
		// { event 3016 6 ""},
	},
}
