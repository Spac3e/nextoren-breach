--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_cw_20/lua/weapons/cw_base/sh_stats.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- various weapon stat related convenience functions

function SWEP:addStatModifiers(tbl)
	if tbl then
		-- loop through the table and modify multipliers
		for k, v in pairs(tbl) do
			if self[k] then
				self[k] = self[k] + v
			end
		end
	end
end

function SWEP:removeStatModifiers(tbl)
	if tbl then
		for k, v in pairs(tbl) do
			if self[k] then
				self[k] = self[k] - v
			end
		end
	end
end


function SWEP:recalculateDamage()
	self.Damage = self.Damage_Orig * self.DamageMult
end

function SWEP:recalculateRecoil()
	self.Recoil = self.Recoil_Orig * self.RecoilMult
end

function SWEP:recalculateFirerate()
	self.FireDelay = self.FireDelay_Orig * self.FireDelayMult
end

function SWEP:recalculateVelocitySensitivity()
	self.VelocitySensitivity = self.VelocitySensitivity_Orig * self.VelocitySensitivityMult
end

function SWEP:recalculateAimSpread()
	self.AimSpread = self.AimSpread_Orig * self.AimSpreadMult
end

function SWEP:recalculateHipSpread()
	self.HipSpread = self.HipSpread_Orig * self.HipSpreadMult
end

function SWEP:recalculateDeployTime()
	self.DrawSpeed = self.DrawSpeed_Orig * self.DrawSpeedMult
end

function SWEP:recalculateReloadSpeed()
	self.ReloadSpeed = self.ReloadSpeed_Orig * self.ReloadSpeedMult
end

function SWEP:recalculateMouseSens()
	self.OverallMouseSens = self.OverallMouseSens_Orig * self.OverallMouseSensMult
end

function SWEP:recalculateMaxSpreadInc()
	self.MaxSpreadInc = self.MaxSpreadInc_Orig * self.MaxSpreadIncMult
end

function SWEP:recalculateClumpSpread()
	if not self.ClumpSpread then
		return
	end
	
	self.ClumpSpread = self.ClumpSpread_Orig * self.DamageMult
end

function SWEP:recalculateStats()
	-- recalculates all stats
	self:recalculateDamage()
	self:recalculateRecoil()
	self:recalculateFirerate()
	self:recalculateVelocitySensitivity()
	self:recalculateAimSpread()
	self:recalculateHipSpread()
	self:recalculateDeployTime()
	self:recalculateReloadSpeed()
	self:recalculateClumpSpread()
	
	if CLIENT then
		self:recalculateMouseSens()
	end
	
	self:recalculateMaxSpreadInc()
end