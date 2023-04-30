--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_piat/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include("shared.lua")

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Think()
	if CurTime() - self.LunchTime < 10 then
		self:DrawTrailParticle()
	end
end

function ENT:Draw()
	self:DrawModel()

	-- self:DrawDLight()
	-- self:DrawEffect()
end

local ten = 5

function ENT:kkTime()
	self.LunchTime = self.LunchTime or CurTime()

	return ten - math.Clamp(CurTime() - self.LunchTime, 0, ten)
end

function ENT:DrawTrailParticle()
	local part = self.Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), self:GetPos())
	part:SetStartSize(12)
	part:SetEndSize(32)
	part:SetStartAlpha(25 * self:kkTime())
	part:SetEndAlpha(0)
	part:SetDieTime(10)
	part:SetRoll(math.random(0, 360))
	part:SetRollDelta(0.01)
	part:SetColor(220, 220, 230)
	part:SetLighting(true)
	part:SetVelocity(VectorRand() * 2)
end
