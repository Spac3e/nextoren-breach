--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_m18/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Thrown smoke grenade"
ENT.Author = "Spy"
ENT.Information = "Thrown smoke grenade"
ENT.Spawnable = false
ENT.AdminSpawnable = false

CustomizableWeaponry:addRegularSound("CW_KK_INS2_SMOKE_ENT_BOUNCE", {"weapons/m18/m18_bounce_01.wav", "weapons/m18/m18_bounce_02.wav", "weapons/m18/m18_bounce_03.wav"})
CustomizableWeaponry:addRegularSound("CW_KK_INS2_SMOKE_ENT_DETONATE", "weapons/m18/m18_detonate.wav")
CustomizableWeaponry:addRegularSound("CW_KK_INS2_SMOKE_ENT_LOOP", "weapons/m18/m18_burn_loop.wav")
CustomizableWeaponry:addRegularSound("CW_KK_INS2_SMOKE_ENT_END", "weapons/m18/m18_burn_loop_end.wav")

CustomizableWeaponry:addRegularSound("CW_KK_INS2_SMOKE_ENT_FULL", "weapons/m18/smokeburn.wav")
