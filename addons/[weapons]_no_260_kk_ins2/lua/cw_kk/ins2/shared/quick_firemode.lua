--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/shared/quick_firemode.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local SP = game.SinglePlayer()

// copy-pasta

function doStuff(self)
	local CT = CurTime()

	if self.ReloadDelay or CT < self.ReloadWait or self.dt.State == CW_ACTION or self.ShotgunReloadState != 0 then
		return
	end

	if CT < self.GlobalDelay then
		return
	end

	if self.dt.INS2GLActive or self.dt.M203Active then
		return
	end

	if self.dt.State == CW_RUNNING then
		return
	end

	self:CycleFiremodes()
end

// concommand

if SERVER then
	local wep

	concommand.Add("cw_kk_firemode", function(ply)
		if !IsValid(ply) then return end

		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end
		if !wep.CW20Weapon then return end

		doStuff(wep)
	end)
end
