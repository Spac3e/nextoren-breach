--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_m6a1/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "M6A1 rocket"
ENT.Author = "L337N008"
ENT.Information = "A 40MM grenade modified to be launched from Bazooka"
ENT.Spawnable = false
ENT.AdminSpawnable = false

-- ENT.BlastDamage = 200
-- ENT.BlastRadius = 400

ENT.BlastDamage = 120
ENT.BlastRadius = 400 // 800

function ENT:Initialize()
	if SERVER then
		-- self:SetModel(self.Model or "models/weapons/w_cw_kk_ins2_at4_projectile_dods.mdl")
		self:SetModel(self.Model or "models/weapons/w_bazooka_projectile.mdl")
		self:PhysicsInitBox(Vector(-23,-2,-2), Vector(0,2,2))
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:SetMass(10)
			phys:Wake()
		end

		self:GetPhysicsObject():SetBuoyancyRatio(0)

		spd = physenv.GetPerformanceSettings()
		spd.MaxVelocity = 5000

		physenv.SetPerformanceSettings(spd)
	else
		self.Emitter = ParticleEmitter(self:GetPos())
		self.LunchTime = CurTime()
	end
end
