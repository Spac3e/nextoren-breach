--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cw_base/sh_hooks.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

local function CW20_PlayerEnteredVehicle(ply, vehicle, role)
	local wep = ply:GetActiveWeapon()
	
	if IsValid(wep) then
		if wep.CW20Weapon then
			wep.dt.State = CW_ACTION -- set the state to 'action' so that the player 'holsters' it
		end
	end
end

hook.Add("PlayerEnteredVehicle", "CW20_PlayerEnteredVehicle", CW20_PlayerEnteredVehicle)