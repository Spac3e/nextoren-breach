--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_flare/cl_init.lua
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
	if self._timeToLive > CurTime() then
		self:DrawDLight()
		self:DrawEffect()
	end
end

function ENT:Draw()
	self:DrawModel()

	-- if self._timeToLive > CurTime() then
		-- self:DrawEffect()
	-- end
end

function ENT:DrawEffect()
	-- ParticleEffectAttach("muzzleflash_M3", PATTACH_POINT_FOLLOW, self, 1)

	-- local ed = EffectData()
	-- ed:SetOrigin(self:GetPos())
	-- util.Effect("ElectricSpark", ed)
	-- util.Effect("MetalSpark", ed)
	-- util.Effect("Sparks", ed)

	local c = self.LightColor

	for _ = 1,20 do
		local p = self.Emitter:Add("particle/fire", self:GetPos())
		p:SetColor(c.r, c.g, c.b)
		p:SetLighting(false)
		p:SetStartAlpha(255)
		p:SetStartSize(1)
		p:SetCollide(true)
		p:SetBounce(0)
		p:SetVelocity(VectorRand() * 100)
		p:SetDieTime((math.random(30) / 100) + 0.05)
		p:SetEndSize(0)
		p:SetEndAlpha(0)

		-- p:SetThinkFunction(function(self)
			-- local per = self:GetLifeTime() / self:GetDieTime()

			-- local r = 255 - ((255 - (c.r)) * per)
			-- local g = 255 - ((255 - (c.g)) * per)
			-- local b = 255 - ((255 - (c.b)) * per)

			-- self:SetColor(r,g,b)
		-- end)
	end
end

function ENT:DrawDLight()
	dlight = DynamicLight(self:EntIndex())

	dlight.r = self.LightColor.r
	dlight.g = self.LightColor.g
	dlight.b = self.LightColor.b
	dlight.style = math.pow(6,math.random(0,1))
	dlight.Brightness = 0
	dlight.Pos = self:GetPos()
	dlight.Size = 1024
	dlight.Decay = 250
	dlight.DieTime = CurTime() + 10
end
