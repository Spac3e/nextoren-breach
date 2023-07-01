--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_nam_dbs/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_KK_INS2_NAM_DBS_FIRE", "weapons/nam/ithaca37/izh43_fp.wav", 1, 105, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_DBS_BREAKCLOSE", "weapons/nam/doublebarrel/breakclose.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_DBS_BREAKOPEN", "weapons/nam/doublebarrel/breakopen.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_DBS_SHELLEJECT", "weapons/nam/doublebarrel/shelleject1.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_DBS_SHELLINSERT", {
	"weapons/nam/doublebarrel/shellinsert1.wav",
	"weapons/nam/doublebarrel/shellinsert2.wav",
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_NAM_DBS_SHELLSEJECT", "weapons/nam/doublebarrel/shellseject.wav")
