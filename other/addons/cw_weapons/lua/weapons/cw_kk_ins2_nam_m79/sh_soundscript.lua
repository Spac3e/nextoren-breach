--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_m79/sh_soundscript.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local function shell(wep)
	if SERVER then return end

	wep:shellEvent203()
end

SWEP.Sounds = {
	base_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 22/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 20/31, sound = "CW_KK_INS2_M45_MAGRELEASE"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
		{time = 14/34, sound = "CW_KK_INS2_M45_MAGRELEASE"},
	},

	base_crawl = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 22/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M203_EMPTY"},
	},

	base_reload = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 14/30, sound = "CW_KK_INS2_M203_OPENBARREL"},
		{time = 40/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 50/30, sound = "", callback = shell},
		{time = 83/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		{time = 119/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	base_reload2 = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 14/30, sound = "CW_KK_INS2_M203_OPENBARREL"},
		{time = 40/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 50/30, sound = "", callback = shell},
		{time = 83/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		{time = 121/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	base_reload3 = {
		{time = 0/30, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 14/30, sound = "CW_KK_INS2_M203_OPENBARREL"},
		{time = 40/30, sound = "CW_KK_INS2_UNIVERSAL_LEANIN"},
		{time = 50/30, sound = "", callback = shell},
		{time = 83/30, sound = "CW_KK_INS2_M203_INSERTGRENADE"},
		{time = 119/30, sound = "CW_KK_INS2_M203_CLOSEBARREL"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_M203_EMPTY"},
	},
}
