--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_weapon_holsters/lua/autorun/sh_weapon_holsters.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if not ConVarExists("sv_weapon_holsters") then
	CreateConVar("sv_weapon_holsters",1, { FCVAR_REPLICATED, FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE }, "Enable Weapon Holsters (server side)" )
end
WepHolster = WepHolster or {}
WepHolster.HL2Weps = {
	["weapon_pistol"] = "Pistol",
	["weapon_357"] = "357",
	["weapon_frag"] = "Frag Grenade",
	["weapon_slam"] = "SLAM",
	["weapon_crowbar"] = "Crowbar",
	["weapon_stunstick"] = "Stunstick",
	["weapon_shotgun"] = "Shotgun",
	["weapon_rpg"] = "RPG Launcher",
	["weapon_smg1"] = "SMG",
	["weapon_ar2"] = "AR2",
	["weapon_crossbow"] = "Crossbow",
	["weapon_physcannon"] = "Gravity Gun",
	["weapon_physgun"] = "Physics Gun"
}
