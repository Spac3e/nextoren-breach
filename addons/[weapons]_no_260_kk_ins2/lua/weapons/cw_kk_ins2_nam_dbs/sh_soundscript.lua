--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_dbs/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent()
end

SWEP.Sounds = {
	base_melee_bash = {
		{time = 10/30, sound = "CW_KK_INS2_DOI_MELEE"},
	},

	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 19/30, sound = "CW_KK_INS2_NAM_DBS_BREAKCLOSE"},
	},

	base_ready2 = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 18/30, sound = "CW_KK_INS2_NAM_DBS_BREAKCLOSE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_crawl = {
		{time = 0/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},

	base_reload = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 14/30, sound = "CW_KK_INS2_NAM_DBS_BREAKOPEN"},
		{time = 41/30, sound = "CW_KK_INS2_NAM_DBS_SHELLEJECT"},
		-- {time = 55/30, sound = "", callback = shell},
		{time = 84/30, sound = "CW_KK_INS2_NAM_DBS_SHELLINSERT"},
		{time = 111/30, sound = "CW_KK_INS2_NAM_DBS_BREAKCLOSE"},
	},

	base_reloadempty = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 14/30, sound = "CW_KK_INS2_NAM_DBS_BREAKOPEN"},
		{time = 38/30, sound = "CW_KK_INS2_NAM_DBS_SHELLSEJECT"},
		{time = 39/30, sound = "", callback = shell},
		{time = 40/30, sound = "", callback = shell},
		{time = 99/30, sound = "CW_KK_INS2_NAM_DBS_SHELLINSERT"},
		{time = 125/30, sound = "CW_KK_INS2_NAM_DBS_SHELLINSERT"},
		{time = 154/30, sound = "CW_KK_INS2_NAM_DBS_BREAKCLOSE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M590_EMPTY"},
	},
}
