--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_scp_122/sh_soundscript.lua
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
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 27/30, sound = "CW_KK_INS2_AK74_BOLTBACK"},
		{time = 39/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0/30, sound = "SCP_122_Empty"},
	},

	base_fireselect = {
		{time = 5/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	base_reload = {
		{time = 14/30, sound = "SCP_122_BoltRelease"},
		{time = 14/30, sound = "SCP_122_MagOut"},
		{time = 58/30, sound = "SCP_122_MagIn"},
		{time = 82/30, sound = "SCP_122_BoltBack"}
	},

	base_reloadempty = {
    {time = 14/30, sound = "SCP_122_BoltRelease"},
		{time = 14/30, sound = "SCP_122_MagOut"},
		{time = 58/30, sound = "SCP_122_MagIn"},
		{time = 94/30, sound = "SCP_122_BoltBack"}
	},

	iron_dryfire = {
		{time = 0/30, sound = "SCP_122_Empty"},
	},

	iron_fireselect = {
		{time = 1/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 27/30, sound = "CW_KK_INS2_AK74_BOLTBACK"},
		{time = 39/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 5/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	foregrip_reload = {
    {time = 12/30, sound = "SCP_122_BoltRelease"},
		{time = 12/30, sound = "SCP_122_MagOut"},
		{time = 54/30, sound = "SCP_122_MagIn"},
		{time = 82/30, sound = "SCP_122_BoltBack"}
	},

	foregrip_reloadempty = {
    {time = 12/30, sound = "SCP_122_BoltRelease"},
		{time = 12/30, sound = "SCP_122_MagOut"},
		{time = 54/30, sound = "SCP_122_MagIn"},
		{time = 94/30, sound = "SCP_122_BoltBack"}
	},

	foergrip_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	gl_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
		{time = 27/30, sound = "CW_KK_INS2_AK74_BOLTBACK"},
		{time = 39/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	gl_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	gl_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	gl_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	gl_fireselect = {
		{time = 5/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	gl_reload = {
		{time = 36/30, sound = "CW_KK_INS2_AK74_MAGRELEASE"},
		{time = 36/30, sound = "CW_KK_INS2_AK74_MAGOUT"},
		{time = 36/30, sound = "CW_KK_INS2_AK74_MAGOUTRATTLE"},
		{time = 54/30, sound = "CW_KK_INS2_AK74_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	gl_reloadempty = {
		{time = 36/30, sound = "CW_KK_INS2_AK74_MAGRELEASE"},
		{time = 39/30, sound = "CW_KK_INS2_AK74_MAGOUT"},
		{time = 45/30, sound = "CW_KK_INS2_AK74_MAGOUTRATTLE"},
		{time = 62/30, sound = "CW_KK_INS2_AK74_MAGIN"},
		{time = 70/30, sound = "CW_KK_INS2_AK74_RATTLE"},
		{time = 86/30, sound = "CW_KK_INS2_AK74_BOLTBACK"},
		{time = 98/30, sound = "CW_KK_INS2_AK74_BOLTRELEASE"},
	},

	gl_iron_dryfire = {
		{time = 0/30, sound = "CW_KK_INS2_AK74_EMPTY"},
	},

	gl_iron_fireselect = {
		{time = 5/30, sound = "CW_KK_INS2_AK74_FIRESELECT"},
	},

	glsetup_in = {
		{time = 0/31, sound = "CW_KK_INS2_GP30_SELECT"},
	},

	glsetup_out = {
		{time = 0/31, sound = "CW_KK_INS2_GP30_DESELECT"},
	},

	glsetup_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	glsetup_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	glsetup_dryfire = {
		{time = 0/31, sound = "CW_KK_INS2_GP30_EMPTY"},
	},

	glsetup_iron_dryfire = {
		{time = 0/31, sound = "CW_KK_INS2_GP30_EMPTY"},
	},

	glsetup_reload = {
		{time = 0, sound = "CW_KK_INS2_GL_BEGINRELOAD"},
		{time = 41/31, sound = "CW_KK_INS2_GP30_INSERTGRENADE"},
		{time = 50/31, sound = "CW_KK_INS2_GP30_INSERTGRENADECLICK"},
		{time = 70/31, sound = "CW_KK_INS2_AK74_RATTLE"},
	},

	base_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	gl_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	glsetup_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

}
