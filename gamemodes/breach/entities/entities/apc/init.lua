AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
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
btr_hp = 15000
function ENT:OnTakeDamage( dmginfo )
	btr_hp = btr_hp - dmginfo:GetDamage()
end

function ENT:Initialize()
	fat_evac = 0
	btr_katok = true
	self:SetPos(Vector(2430, 7498, 1515))
	self:SetAngles(Angle(0,90,0))
	self:SetModel( "models/scp_chaos_jeep/chaos_jeep.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:LinearMotion(Vector(2442, 6847, 1515), 0.002)
	self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
	
	for k,ball in pairs(ents.FindInSphere((Vector(2435, 7194, 1607)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end
	timer.Simple(8, function()
		for k,ball in pairs(ents.FindInSphere((Vector(-1317, 7201, 1751)), 500)) do
	  		if IsValid(ball) then
		 		if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  		end
		end
		btr_katok = false
		self:SetBodyGroups("111")
		self:SetAutomaticFrameAdvance( true )
		self:ResetSequence( 1 )
		self:SetPlaybackRate( 1 )
		self:SetCycle( 1 )
	end)
	
	timer.Create( "1_phase", 99, 1, function()
		
		self:LinearMotion(Vector(2430, 7498, 1515), 0.002)
		self:SetAutomaticFrameAdvance( true )
		self:ResetSequence( 2 )
		self:SetPlaybackRate( 1 )
		self:SetCycle( 1 )
		self:SetBodyGroups("000")
		for k,ball in pairs(ents.FindInSphere((Vector(2435, 7194, 1607)), 100)) do
		if IsValid(ball) then
			if ball:GetClass() == "func_door" then ball:Fire("Open") end
		end
		end
		for k,v in pairs(ents.FindInSphere(Vector(2666, 6915, 1576), 400)) do
            if v:IsPlayer() then
				if v:GetGTeam() == TEAM_CLASSD then
						fat_evac = fat_evac + 1
				end
				evacuate(v,TEAM_CLASSD,1000,"l:cutscene_evac_by_ci")
				timer.Simple(0.5, function()
				evacuate(v,TEAM_CHAOS,1000,"l:cutscene_evac_by_ci")
				btr_katok = true
				end)
			end
		end
	end)
	self:SetAutomaticFrameAdvance( true )
  	self:ResetSequence( 2 )
  	self:SetPlaybackRate( 1 )
  	self:SetCycle( 1 )
end

function ENT:Touch(ply)
	if btr_katok == false then return end
	if ply:IsPlayer() then
		ply:Kill()
	end
end

function ENT:Think()
	self:NextThink( CurTime() )
	if btr_hp < 0 then
		self:Explode()
		self:EmitSound( "nextoren/others/explosions/explosion_7.wav")
		timer.Remove(self:GetClass().."_ang_motion")
		timer.Remove(self:GetClass().."_linear_motion")
		timer.Remove( "1_phase" )
		timer.Remove( "2_phase" )
		timer.Simple(0.5, function()
			self:Remove()
		end)
	end
	return true
end