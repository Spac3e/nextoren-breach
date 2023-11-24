--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_rpg_m72/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.Sounds = {
	base_crawl = {
		{time = 15.0000004470348/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
		{time = 38.0000004172325/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
	},

	base_fire = {
		{time = 3.00000004470348/30, sound = "CW_KK_INS2_M9_SAFETY"},
	},

	base_iron_fire = {
		{time = 3.00000004470348/30, sound = "CW_KK_INS2_M9_SAFETY"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_ready = {
		{time = 0, sound = "Draw"},
		{time = 16.0000006109476/31, sound = "CW_KK_INS2_AT4_READY"},
		{time = 42.0000006258488/31, sound = "CW_KK_INS2_AT4_LATCH01"},
		{time = 50.0000001490116/31, sound = "CW_KK_INS2_AT4_LATCH02"},
		{time = 75.0000017881393/31, sound = "CW_KK_INS2_AT4_SHOULDER"},
	},

	base_toss = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEANOUT"},
		{time = 20.9999990463257/31, sound = "CW_KK_INS2_UNIVERSAL_WEAPONLOWER"},
	},
}
