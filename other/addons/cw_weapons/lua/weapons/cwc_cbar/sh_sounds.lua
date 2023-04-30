--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cwc_cbar/sh_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
lua/weapons/cwc_cbar/sh_sounds.lua
--]]
CustomizableWeaponry:addReloadSound("CWC_CBAR_SWING",{ 
"weapons/CWC_CBAR/swingn1.wav",
"weapons/CWC_CBAR/swingn2.wav",
"weapons/CWC_CBAR/swingn3.wav",
"weapons/CWC_CBAR/swingn4.wav",}, 70, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_SWISH",{ 
"weapons/CWC_CBAR/nswoosh1.wav",
"weapons/CWC_CBAR/nswoosh2.wav",}, 70, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_SWISHDRAW",{ 
"weapons/CWC_CBAR/nswoosh1.wav",
"weapons/CWC_CBAR/nswoosh2.wav",}, 40, 30, 0)

CustomizableWeaponry:addRegularSound("CWC_CBAR_HITWORLD",{ 
"weapons/CWC_CBAR/walln1.wav",
"weapons/CWC_CBAR/walln2.wav",
"weapons/CWC_CBAR/walln3.wav",
"weapons/CWC_CBAR/walln4.wav"}, 80, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_HITFLESH",{ 
"weapons/CWC_CBAR/nhit1.wav",
"weapons/CWC_CBAR/nhit2.wav",
"weapons/CWC_CBAR/nhit3.wav",
"weapons/CWC_CBAR/nhit4.wav",
"weapons/CWC_CBAR/nhit5.wav",
"weapons/CWC_CBAR/nhit6.wav",
"weapons/CWC_CBAR/nhit7.wav",
"weapons/CWC_CBAR/nhit8.wav",}, 75, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_HITFLESH_LIGHT",{ 
"weapons/CWC_CBAR/hitlight1.wav",
"weapons/CWC_CBAR/hitlight2.wav",
"weapons/CWC_CBAR/hitlight3.wav"}, 70, 80)


CustomizableWeaponry:addRegularSound("CWC_CBAR_HITWORLD_HEAVY",{ 
"weapons/CWC_CBAR/wallheavy1.wav",
"weapons/CWC_CBAR/wallheavy2.wav",
"weapons/CWC_CBAR/wallheavy3.wav"}, 82.5, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_HITFLESH_HEAVY",{ 
"weapons/CWC_CBAR/hitheavy1.wav",
"weapons/CWC_CBAR/hitheavy2.wav",
"weapons/CWC_CBAR/hitheavy3.wav"}, 80, 80)

CustomizableWeaponry:addReloadSound("CWC_CBAR_CHARGE",{ 
"weapons/CWC_CBAR/charge1.wav",
"weapons/CWC_CBAR/charge2.wav",
"weapons/CWC_CBAR/charge3.wav"})

CustomizableWeaponry:addRegularSound("CWC_CBAR_CHARGE_SWING",{ 
"weapons/CWC_CBAR/chargeswing1.wav",
"weapons/CWC_CBAR/chargeswing2.wav"}, 72, 80)

CustomizableWeaponry:addRegularSound("CWC_CBAR_DRAW",{ 
"weapons/CWC_CBAR/drawn.wav"})

