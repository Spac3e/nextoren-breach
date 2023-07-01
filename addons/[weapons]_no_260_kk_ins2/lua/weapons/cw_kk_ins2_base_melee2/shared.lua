--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_base_melee2/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not CustomizableWeaponry then return end

AddCSLuaFile()

--AddCSLuaFile("weapons/cw_extrema_ratio_official/shared.lua")
--AddCSLuaFile("weapons/cw_melee_base/shared.lua")

--include("weapons/cw_extrema_ratio_official/shared.lua")
--include("weapons/cw_melee_base/shared.lua")

SWEP.KKINS2Melee = true

SWEP.Base = "cw_kk_ins2_base_main"

SWEP.SpeedDec = 0
SWEP.WeaponLength = 0

function SWEP:IndividualThink()
	-- weapons.GetStored("cw_kk_ins2_base").IndividualThink(self)
	weapons.GetStored("cw_kk_ins2_base_main").IndividualThink(self)

	weapons.GetStored("cw_melee_base").IndividualThink(self)
end

SWEP.SprintingEnabled = true
SWEP.InactiveWeaponStates = {
	[CW_RUNNING] = false,
	[CW_ACTION] = true,
	[CW_CUSTOMIZE] = true,
	[CW_HOLSTER_START] = true,
	[CW_HOLSTER_END] = true,
	[CW_PRONE_BUSY] = true,
	[CW_PRONE_MOVING] = true
}

SWEP.reticleInactivityCallbacksRaw = {
	["slash_primary"] = -0.4,
	["slash_secondary"] = -0.4,
}
