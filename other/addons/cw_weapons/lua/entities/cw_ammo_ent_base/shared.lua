--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/entities/cw_ammo_ent_base/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- use this entity as a base for your ammo entities
-- below you can see all the necessary variables that can be used for setting up an ammo entity
-- they must be defined shared (clientside and serverside, aka in this file)

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Ammo entity base"
ENT.Author = "Spy"
ENT.Spawnable = false
ENT.AdminSpawnable = false 
ENT.Category = "CW 2.0 Ammo"

ENT.ResupplyMultiplier = 12 -- max amount of mags the player can take from the ammo entity before it considers him as 'full'
ENT.AmmoCapacity = 24 -- max amount of resupplies before this entity dissapears
ENT.HealthAmount = 100 -- the health of this entity
ENT.ExplodeRadius = 512 -- the explosion radius when it reaches 0 health from taking damage, measured in units
ENT.ExplodeDamage = 100 -- the explosion damage
ENT.ResupplyTime = 0.4 -- time in seconds between resupply sessions
ENT.Model = "models/Items/ammocrate_smg1.mdl" -- what model to use

ENT.CaliberSpecific = false -- whether the entity will give a specific ammo caliber
ENT.ResupplyAmount = 40 -- how many rounds to give
ENT.Caliber = "7.62x51MM" -- which caliber to resupply

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "ammoCharge")
end