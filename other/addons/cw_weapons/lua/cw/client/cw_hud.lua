--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/cw/client/cw_hud.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

CustomizableWeaponry.ITEM_PACKS_TOP_COLOR = Color(0, 200, 255, 255)

local noDraw = {CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudHealth = true,
	CHudBattery = true}

local noDrawAmmo = {CHudAmmo = true,
	CHudSecondaryAmmo = true}
	
local wep, ply

local function CW_HUDShouldDraw(n)
	local customHud = GetConVarNumber("cw_customhud") >= 1
	local customAmmo = GetConVarNumber("cw_customhud_ammo") >= 1
	
	if customAmmo or customHud then
		ply = LocalPlayer()
		
		if IsValid(ply) and ply:Alive() then
			wep = ply:GetActiveWeapon()
		end
	else
		ply, wep = nil, nil
	end
	
	if customAmmo then
		if IsValid(ply) and ply:Alive() then
			if IsValid(wep) and wep.CW20Weapon then
				if noDrawAmmo[n] then
					return false
				end
			end
		end
	end
	
	if customHud then
		if IsValid(ply) and ply:Alive() then
			if IsValid(wep) and wep.CW20Weapon then
				if noDraw[n] then
					return false
				end
			end
		end
	end
end

hook.Add("HUDShouldDraw", "CW_HUDShouldDraw", CW_HUDShouldDraw)