--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nade_c4/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_nade_c4/sh_soundscript.lua
--]]

SWEP.Sounds = {
	base_plant = {
		{time = 0, sound = "CW_KK_INS2_C4_ARMMOVEMENT"},
		{time = 16/30, sound = "CW_KK_INS2_C4_PLANTPLACE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 10/29, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/29, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
	},

	secondary_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
	},

	low_pullback = {
		{time = 6/30, sound = "CW_KK_INS2_M67_ARMDRAW"},
	},

	base_throw = {
		{time = 7/33, sound = "CW_KK_INS2_C4_THROW"},
	},

	secondary_throw = {
		{time = 7/33, sound = "CW_KK_INS2_C4_THROW"},
	},

	low_throw = {
		{time = 7/30, sound = "CW_KK_INS2_C4_THROW"},
	},

	det_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	det_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	det_crawl = {
		{time = 10/29, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 20/29, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	det_detonate = {
		-- {time = 10/30, sound = "CW_KK_INS2_C4_TRIGGERSEC"},
		{time = 20/30, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},
}


