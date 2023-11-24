--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cw_mr96/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry:addFireSound("CW_MR96_FIRE", "weapons/cw_mr96/mr96_regular.wav", 1, 115, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_MR96_FIRE_LONG", "weapons/cw_mr96/mr96_long.wav", 1, 120, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_MR96_FIRE_SHORT", "weapons/cw_mr96/mr96_short.wav", 1, 110, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_MR96_CYLINDEROPEN", "weapons/cw_mr96/chamber_out.wav")
CustomizableWeaponry:addReloadSound("CW_MR96_CYLINDERCLOSE", "weapons/cw_mr96/chamber_in.wav")
CustomizableWeaponry:addReloadSound("CW_MR96_ROUNDSOUT", "weapons/cw_mr96/roundsout.wav")
CustomizableWeaponry:addReloadSound("CW_MR96_ROUNDSIN", "weapons/cw_mr96/roundsin.wav")