AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.AutomaticFrameAdvance = true
function ENT:LinearMotion(endpos, speed)
if !IsValid(self) then return end
	local ratio = 0
	local time = 0
	local startpos = self:GetPos()
	timer.Create(self:GetClass().."_linear_motion", FrameTime(), 9999999999999, function()
		if !IsValid(self) then return end
	    ratio = speed + ratio
	    time = time + FrameTime()
	    self:SetPos(LerpVector(ratio, startpos, endpos))
	    if self:GetPos():DistToSqr(endpos) < 1 then
	    	self:SetPos(endpos)
	    end
	    if self:GetPos() == endpos then
	    	timer.Remove(self:GetClass().."_linear_motion")
	    end
	end)
end

function ENT:AngMotion(endang, angspeed)
	if !IsValid(self) then return end
	local angratio = 0
	local angtime = 0
	local startang = self:GetAngles()
	timer.Create(self:GetClass().."_ang_motion", FrameTime(), 9999999999999, function()
		if !IsValid(self) then return end
	    angratio = angspeed + angratio
	    angtime = angtime + FrameTime()
	    self:SetAngles(LerpAngle(angratio, startang, endang))
	    if self:GetAngles() == endang then
	    	timer.Remove(self:GetClass().."_ang_motion")
			self:SetAngles(endang)
	    end
	end)
end

function ENT:Initialize()
    asic_evac = 0
    heli_live = true
    heli_katok = true
	if IsValid(self) then
		timer.Create( "1_phase", 19.5, 1, function()
			self:ResetSequence( 6 )
			self:SetPlaybackRate( 3 )
			self:EmitSound( "nextoren/vo/chopper/chopper_evacuate_start_7.wav") 
            heli_katok = false
		end)
		timer.Create( "2_phase", 60, 1, function()
			self:EmitSound( "nextoren/vo/chopper/chopper_thirty_left.wav") 
		end)
		timer.Create( "3_phase", 80, 1, function()
			self:EmitSound( "nextoren/vo/chopper/chopper_ten_left.wav") 
		end)
		timer.Create( "4_phase", 90, 1, function()
            heli_katok = true
			self:ResetSequence( 6 )
			self:SetPlaybackRate( 5 )
			self:EmitSound( "nextoren/vo/chopper/chopper_evacuate_end.wav") 
			for k,v in pairs(ents.FindInSphere(Vector(-3518, 4802, 2567), 100)) do
                if v:IsPlayer() then
                if v:GetGTeam() == TEAM_SCI then
                    asic_evac = asic_evac + 1
                end
                evacuate(v,TEAM_SCI,800,"l:cutscene_evac_by_heli")
                evacuate(v,TEAM_SPECIAL,800,"l:cutscene_evac_by_heli")
                timer.Simple(0.2, function()
                evacuate(v,TEAM_NTF,800,"l:cutscene_evac_by_heli")
                evacuate(v,TEAM_SECURITY,800,"l:cutscene_evac_by_heli")
                evacuate(v,TEAM_GUARD,800,"l:cutscene_evac_by_heli")
                evacuate(v,TEAM_QRT,800,"l:cutscene_evac_by_heli")
                evacuate(v,TEAM_OSN,800,"l:cutscene_evac_by_heli")
                end)
                end
            end
		end)
		timer.Create( "5_phase", 12, 1, function()
			self:LinearMotion(Vector(-3475, 4778, 2507), 0.002)
		end )
		timer.Create( "6_phase", 12, 1, function()
			self:AngMotion(Angle(0, 0, 0), 0.002)
		end )
		timer.Create( "7_phase", 90, 1, function() 
			self:AngMotion(Angle(0, 0, -25), 0.002)
		end )
		timer.Create( "8_phase", 90, 1, function()
			self:LinearMotion(Vector(-3465, 9961, 3655), 0.001)
		end )
		timer.Create( "9_phase", 91, 1, function()
			self:LinearMotion(Vector(-3465, 9961, 3655), 0.0015)
		end )
		timer.Create( "10_phase", 91, 1, function()
			self:LinearMotion(Vector(-3465, 9961, 3655), 0.002)
		end )
	end
	self:SetPos(Vector(416, 4913, 3321))
	self:SetAngles(Angle(0,90,-27))
	self:LinearMotion(Vector(-2773, 4717, 3147), 0.001)
	self:SetModel( "models/scp_helicopter/resque_helicopter.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:EmitSound( "nextoren/others/helicopter/helicopter_propeller.wav", 75, 100, 1, CHAN_AUTO ) -- Same as below
	self:ResetSequence( 6 )
	self:SetPlaybackRate( 5 )

end

function ENT:Touch(ply)
	if heli_katok == false then return end
	if ply:IsPlayer() then
		ply:Kill()
	end
end

function ENT:Explode()
	local explosionDamage = 500
	local explosionRadius = 550
	local fireDuration = 5

    local explosion = EffectData()
    explosion:SetOrigin(self:GetPos())
    explosion:SetScale(1)
	ParticleEffect( "fluidExplosion_frames", self:GetPos(), angle_zero );
    local targets = ents.FindInSphere(self:GetPos(), explosionRadius)
    for _, target in pairs(targets) do
        local distance = self:GetPos():Distance(target:GetPos())
        local damage = math.Clamp((1 - distance / explosionRadius) * explosionDamage, 0, explosionDamage)
        target:TakeDamage(damage, self, self)
    end
    timer.Remove("FireExplode" .. self:EntIndex())
end
local heli_hp = 7000
function ENT:OnTakeDamage( dmginfo)
	heli_hp = heli_hp - dmginfo:GetDamage()
end

function ENT:Think()
	if heli_hp < 0 then
		self:Explode()
		self:EmitSound( "nextoren/others/explosions/explosion_7.wav")
		timer.Remove(self:GetClass().."_ang_motion")
		timer.Remove(self:GetClass().."_linear_motion")
		timer.Remove( "1_phase" )
		timer.Remove( "2_phase" )
		timer.Remove( "3_phase" )
		timer.Remove( "4_phase" )
		timer.Remove( "5_phase" )
		timer.Remove( "6_phase" )
		timer.Remove( "7_phase" )
		timer.Remove( "8_phase" )
		timer.Remove( "9_phase" )
		timer.Remove( "10_phase" )
			self:Remove()
	end

	for k,ball in pairs(ents.FindInSphere((self:GetPos()), 500)) do
		if IsValid(ball) then
			if ball:GetModel() == "models/weapons/w_cw_kk_ins2_rpg7_projectile_pd2.mdl" then
						ParticleEffect( "fluidExplosion_frames", self:GetPos(), Angle(0, 0, 0) );
						ParticleEffect( "fluidExplosion_frames", self:GetPos(), Angle(0, 0, 0) );
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), Angle(0, 0, 0) );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						timer.Remove(self:GetClass().."_ang_motion")
						timer.Remove(self:GetClass().."_linear_motion")
						timer.Remove( "1_phase" )
						timer.Remove( "2_phase" )
						timer.Remove( "3_phase" )
						timer.Remove( "4_phase" )
						timer.Remove( "5_phase" )
						timer.Remove( "6_phase" )
						timer.Remove( "7_phase" )
						timer.Remove( "8_phase" )
						timer.Remove( "9_phase" )
						timer.Remove( "10_phase" )
				end
		end
	end
	self:NextThink( CurTime() )
	return true
end