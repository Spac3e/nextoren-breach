--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/entities/cw_kk_ins2_projectile_rpg/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "PG-7V Grenade"
ENT.Author = "L337N008"
ENT.Information = "A 40MM grenade modified to be launched from RPG7"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Editable = true

-- ENT.BlastDamage = 200
-- ENT.BlastRadius = 400

ENT.BlastDamage = 230
ENT.BlastRadius = 500 // 1000

ENT.SpeedStarter = 4527.55
ENT.SpeedThruster = 11574.78
ENT.SpeedMax = 11574.78

ENT.safetyBypass = false
ENT.doAClusterFuck = false

-- ENT.DontDestroy = true

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model or "models/weapons/w_cw_kk_ins2_rpg7_projectile_pd2.mdl")
		-- self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitBox(Vector(10,-2,-2), Vector(42,2,2))
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:SetMass(10)
			phys:Wake()
		end

		self:GetPhysicsObject():SetBuoyancyRatio(0)

		self.dt.State = self.States.initialized

		spd = physenv.GetPerformanceSettings()
		spd.MaxVelocity = 11574.78

		physenv.SetPerformanceSettings(spd)
	else
		self.Emitter = ParticleEmitter(self:GetPos())
	end

	local CT = CurTime()

	self.ArmTime = 0
	self.selfDestructTime = CT + 5.1
end

function ENT:SetupDataTables()
	-- self:NetworkVar("Int", 0, "State")
	self:NetworkVar("Int", 0, "State", {
		KeyName = "state",
		Edit = {
			type = "Int",
			min = 1,
			max = 3,
			order = 1
		}
	})
end

ENT.States = {
	initialized = 1,
	armed = 2,
	misfired = 3
}
