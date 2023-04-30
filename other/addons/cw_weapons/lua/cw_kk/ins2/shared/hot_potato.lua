--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/shared/hot_potato.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

--[[
local SP = game.SinglePlayer()
local MP = !SP

CustomizableWeaponry_KK.ins2.hotPotato = CustomizableWeaponry_KK.ins2.hotPotato or {}
function CustomizableWeaponry_KK.ins2.hotPotato:IsValid() return true end

function CustomizableWeaponry_KK.ins2.hotPotato:attemptPickUp(ply, nade)
	self.restrictedStates = self.restrictedStates or {
		[CW_ACTION] = true,
		[CW_CUSTOMIZE] = true,
		[CW_KK_ACTION] = true,
		[CW_KK_QNADE] = true,
		[CW_KK_QKNIFE] = true,
	}

	local wep = ply:GetActiveWeapon()

	if !IsValid(wep) or !wep.KKINS2Wep then
		return
	end

	if IsValid(wep.dt.Potato) then
		return
	end

	if wep.GlobalDelay > CurTime() then
		return
	end

	if self.restrictedStates[wep.dt.State] then
		return
	end

	nade:SetNoDraw(true)
	nade:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	nade:SetOwner(ply)

	wep.dt.Potato = nade
	nade.heldBy = wep
end

function CustomizableWeaponry_KK.ins2.hotPotato:DoPlayerDeath(victim, attacker, dmginfo)
	local wep = victim:GetActiveWeapon()

	if IsValid(wep) and wep.KKINS2Wep then
		local nade = wep.dt.Potato

		if IsValid(nade) then
			nade:SetCollisionGroup(COLLISION_GROUP_NONE)
			nade:SetNoDraw(false)
		end
	end
end

hook.Add("DoPlayerDeath", CustomizableWeaponry_KK.ins2.hotPotato, CustomizableWeaponry_KK.ins2.hotPotato.DoPlayerDeath)
--]]