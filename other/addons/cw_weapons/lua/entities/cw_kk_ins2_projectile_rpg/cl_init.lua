--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_rpg/cl_init.lua
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
	self:StopSound("CW_KK_INS2_RPG_PROJECTILE")
end

function ENT:Think()
	self:SetBodygroup(0,1)

	-- if CurTime() > self.ArmTime and self.dt.State != self.States.misfired then
		-- if not self.NextSoundTime or self.NextSoundTime < CT then
			-- self:EmitSound("CW_KK_INS2_RPG_PROJECTILE", 105, 100)
			-- self.NextSoundTime = CT + 3
		-- end
	-- end
end

function ENT:Draw()
	self:DrawModel()

	if self.dt.State == self.States.armed and self.selfDestructTime > CurTime() then
		self:DrawDLight()
		self:DrawEffect()
		-- self:DrawTrailParticle()
	end
end

function ENT:DrawEffect()
	ParticleEffectAttach("muzzleflash_M3", PATTACH_POINT_FOLLOW, self, 1)
	-- ParticleEffectAttach("muzzleflash_pistol", PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:DrawDLight()
	dlight = DynamicLight(self:EntIndex())

	dlight.r = 255
	dlight.g = 218
	dlight.b = 74
	dlight.style = math.pow(6,math.random(0,1))
	dlight.Brightness = 1
	dlight.Pos = self:GetPos()
	dlight.Size = 512
	dlight.Decay = 8000
	dlight.DieTime = CurTime() + 2
end

function ENT:DrawTrailParticle()
	local part = self.Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), self:GetPos())
	part:SetStartSize(12)
	part:SetEndSize(32)
	part:SetStartAlpha(255)
	part:SetEndAlpha(0)
	part:SetDieTime(10)
	part:SetRoll(math.random(0, 360))
	part:SetRollDelta(0.01)
	part:SetColor(220, 220, 230)
	part:SetLighting(true)
	part:SetVelocity(VectorRand() * 2)
end
