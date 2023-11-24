--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cw_ar15/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_AR15_FIRE", "weapons/cw_ar15/fire.wav", 1, 115, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_AR15_FIRE_SUPPRESSED", "weapons/cw_ar15/fire_suppressed1.wav", 1, 90, CHAN_STATIC)

CustomizableWeaponry:addFireSound("CW_AR15_LONGBARREL_FIRE", "weapons/cw_ar15/fire_longbarrel.wav", 1, 120, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_AR15_LONGBARREL_FIRE_SUPPRESSED", "weapons/cw_ar15/fire_longbarrel_suppressed.wav", 1, 95, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_AR15_MAGOUT", "weapons/cw_ar15/magout.wav")
CustomizableWeaponry:addReloadSound("CW_AR15_MAGIN", "weapons/cw_ar15/magin.wav")
CustomizableWeaponry:addReloadSound("CW_AR15_MAGDROP", "weapons/cw_ar15/magdrop.wav")
CustomizableWeaponry:addReloadSound("CW_AR15_BOLT", "weapons/cw_ar15/boltpull.wav")