--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_ww2_c4_de/shared.lua
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
ENT.PrintName = "Activated frag grenade"
ENT.Author = "Spy"
ENT.Information = "Activated frag grenade"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.fuseParticles = "weapon_compB_fuse"
PrecacheParticleSystem(ENT.fuseParticles)

CustomizableWeaponry:addRegularSound("CW_KK_INS2_DOI_C4_DE_ENT_BOUNCE", {"weapons/tnt/tnt_bounce_01.wav", "weapons/tnt/tnt_bounce_02.wav", "weapons/tnt/tnt_bounce_03.wav"})
