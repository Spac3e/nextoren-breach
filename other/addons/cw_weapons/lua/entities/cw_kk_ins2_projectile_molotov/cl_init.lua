--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_molotov/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include("shared.lua")

function ENT:Initialize()
	ParticleEffectAttach(self.fuseParticles, PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Think()
	if self:WaterLevel() == 0 then
		local dlight = DynamicLight(self:EntIndex())

		dlight.r = 255
		dlight.g = 110
		dlight.b = 74
		dlight.Brightness = 0
		dlight.Pos = self:GetPos()
		dlight.Size = 64
		dlight.Decay = 256
		dlight.DieTime = CurTime() + FrameTime()
	end
end
