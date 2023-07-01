--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/entities/cw_ammo_kit_small/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "cw_ammo_ent_base"
ENT.PrintName = "Small ammo kit"
ENT.Author = "Spy"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Category = "CW 2.0 Ammo"

ENT.ResupplyMultiplier = 12 -- max amount of mags the player can take from the ammo entity before it considers him as 'full'
ENT.AmmoCapacity = 6 -- max amount of resupplies before this entity dissapears
ENT.HealthAmount = 50 -- the health of this entity
ENT.ExplodeRadius = 256
ENT.ExplodeDamage = 50
ENT.ResupplyTime = 0.4 -- time in seconds between resupply sessions
ENT.Model = "models/Items/BoxSRounds.mdl"