--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_anm14/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not CustomizableWeaponry then return end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Thrown incendiary grenade"
ENT.Author = "Spy"
ENT.Information = "Thrown incendiary grenade"
ENT.Spawnable = false
ENT.AdminSpawnable = false

CustomizableWeaponry:addRegularSound("CW_KK_INS2_ANM14_ENT_BOUNCE", {"weapons/anm14/an_m14_bounce_01.wav", "weapons/anm14/an_m14_bounce_02.wav", "weapons/anm14/an_m14_bounce_03.wav"})
