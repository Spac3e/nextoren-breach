--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_cultist_submac_aks74u_modern/sh_soundscript.lua
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
		{time = 12/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
		{time = 27/30, sound = "CW_KK_INS2_AKS74U_BOLTBACK"},
		{time = 39/30, sound = "CW_KK_INS2_AKS74U_BOLTRELEASE"},
	},

	base_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	base_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	base_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AKS74U_EMPTY"},
	},

	base_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
	},

	base_reload = {
		{time = 17/30, sound = "CW_KK_INS2_AKS74U_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_AKS74U_MAGOUT"},
		{time = 29/30, sound = "CW_KK_INS2_AKS74U_MAGOUTRATTLE"},
		{time = 63/30, sound = "CW_KK_INS2_AKS74U_MAGIN"},
		{time = 80/30, sound = "CW_KK_INS2_AKS74U_RATTLE"},
	},

	base_reloadempty = {
		{time = 17/30, sound = "CW_KK_INS2_AKS74U_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_AKS74U_MAGOUT"},
		{time = 29/30, sound = "CW_KK_INS2_AKS74U_MAGOUTRATTLE"},
		{time = 63/30, sound = "CW_KK_INS2_AKS74U_MAGIN"},
		{time = 80/30, sound = "CW_KK_INS2_AKS74U_RATTLE"},
		{time = 98/30, sound = "CW_KK_INS2_AKS74U_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_AKS74U_BOLTRELEASE"},
	},

	iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AKS74U_EMPTY"},
	},

	iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
	},

	foregrip_ready = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
		{time = 12/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
		{time = 27/30, sound = "CW_KK_INS2_AKS74U_BOLTBACK"},
		{time = 39/30, sound = "CW_KK_INS2_AKS74U_BOLTRELEASE"},
	},

	foregrip_draw = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_DRAW"},
	},

	foregrip_holster = {
		{time = 0, sound = "CW_KK_INS2_UNIVERSAL_HOLSTER"},
	},

	foregrip_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AKS74U_EMPTY"},
	},

	foregrip_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
	},

	foregrip_reload = {
		{time = 17/30, sound = "CW_KK_INS2_AKS74U_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_AKS74U_MAGOUT"},
		{time = 29/30, sound = "CW_KK_INS2_AKS74U_MAGOUTRATTLE"},
		{time = 63/30, sound = "CW_KK_INS2_AKS74U_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_AKS74U_RATTLE"},
	},

	foregrip_reloadempty = {
		{time = 17/30, sound = "CW_KK_INS2_AKS74U_MAGRELEASE"},
		{time = 20/30, sound = "CW_KK_INS2_AKS74U_MAGOUT"},
		{time = 29/30, sound = "CW_KK_INS2_AKS74U_MAGOUTRATTLE"},
		{time = 63/30, sound = "CW_KK_INS2_AKS74U_MAGIN"},
		{time = 84/30, sound = "CW_KK_INS2_AKS74U_RATTLE"},
		{time = 98/30, sound = "CW_KK_INS2_AKS74U_BOLTBACK"},
		{time = 104/30, sound = "CW_KK_INS2_AKS74U_BOLTRELEASE"},
	},

	foregrip_iron_dryfire = {
		{time = 0, sound = "CW_KK_INS2_AKS74U_EMPTY"},
	},

	foregrip_iron_fireselect = {
		{time = 14/30, sound = "CW_KK_INS2_AKS74U_FIRESELECT"},
	},

	base_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},

	foregrip_crawl = {
		{time = 16/30, sound = "CW_KK_INS2_UNIVERSAL_LEFTCRAWL"},
		{time = 37/30, sound = "CW_KK_INS2_UNIVERSAL_RIGHTCRAWL"},
	},
}
