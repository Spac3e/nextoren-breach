--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_pf60/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Panzerfaust60 projectile"
ENT.Author = "L337N008"
ENT.Information = "A 40MM grenade modified to be launched from Panzerfaust 60"
ENT.Spawnable = false
ENT.AdminSpawnable = false

-- ENT.BlastDamage = 200
-- ENT.BlastRadius = 400

ENT.BlastDamage = 160
ENT.BlastRadius = 500 // 1000

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model or "models/weapons/w_panzerfaust_projectile.mdl")
		self:PhysicsInitBox(Vector(-6,-2,-2), Vector(4.5,2,2))
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
