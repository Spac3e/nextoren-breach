--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_aks74u/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cw_kk_ins2_aks74u/sh_sounds.lua
--]]
CustomizableWeaponry:addFireSound("CW_KK_INS2_AKS74U_FIRE", "weapons/aks74u/aks_fp.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_KK_INS2_AKS74U_FIRE_SUPPRESSED", "weapons/aks74u/aks_suppressed_fp.wav", 1, 70, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_BOLTBACK", "weapons/aks74u/handling/aks_boltback.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_BOLTRELEASE", "weapons/aks74u/handling/aks_boltrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_EMPTY", "weapons/aks74u/handling/aks_empty.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_FIRESELECT", {
	"weapons/aks74u/handling/aks_fireselect_1.wav",
	"weapons/aks74u/handling/aks_fireselect_2.wav"
})
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_MAGIN", "weapons/aks74u/handling/aks_magin.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_MAGOUT", "weapons/aks74u/handling/aks_magout.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_MAGOUTRATTLE", "weapons/aks74u/handling/aks_magout_rattle.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_MAGRELEASE", "weapons/aks74u/handling/aks_magrelease.wav")
CustomizableWeaponry:addReloadSound("CW_KK_INS2_AKS74U_RATTLE", "weapons/aks74u/handling/aks_rattle.wav")


