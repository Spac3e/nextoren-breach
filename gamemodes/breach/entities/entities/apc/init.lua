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
	self:SetPos(Vector(-1298, 7599, 1662))
	self:SetAngles(Angle(0,-90,0))
	self:SetModel( "models/scp_chaos_jeep/chaos_jeep.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:LinearMotion(Vector(-1302, 6951, 1662), 0.002)
	for k,ball in pairs(ents.FindInSphere((Vector(-1287, 7203, 1757)), 100)) do
	  if IsValid(ball) then
		  if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  end
	end
	timer.Simple(2, function()
		self:AngMotion(Angle(0, 0, 0), 0.002)
	end)
	timer.Simple(4, function()
		self:LinearMotion(Vector(-1054, 6812, 1662), 0.002)
	end)
	timer.Simple(8, function()
		self:LinearMotion(Vector(-43, 6968, 1662), 0.001)
		for k,ball in pairs(ents.FindInSphere((Vector(-1317, 7201, 1751)), 500)) do
	  		if IsValid(ball) then
		 		if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  		end
		end
	end)
	timer.Simple(23, function()
		self:AngMotion(Angle(30, 0, 0), 0.002)
	end)
	timer.Simple(24, function()
		self:AngMotion(Angle(20, 0, 0), 0.002)
	end)
	timer.Simple(23, function()
		self:LinearMotion(Vector(509, 6970, 1520), 0.001)
	end)
	timer.Simple(31.5, function()
		self:AngMotion(Angle(0, 0, 0), 0.002)
	end)
	timer.Simple(38, function()
		self:LinearMotion(Vector(2674, 6935, 1515), 0.0005)
	end)
	timer.Simple(69, function()
		self:SetBodyGroups("111")
		self:SetAutomaticFrameAdvance( true )
		self:ResetSequence( 1 )
		self:SetPlaybackRate( 1 )
		self:SetCycle( 1 )
	end)
	timer.Create( "1_phase", 130, 1, function()
		self:LinearMotion(Vector(3532, 6874, 1515), 0.002)
		self:SetAutomaticFrameAdvance( true )
		self:ResetSequence( 2 )
		self:SetPlaybackRate( 1 )
		self:SetCycle( 1 )
		self:SetBodyGroups("000")
		for k,ball in pairs(ents.FindInSphere((Vector(2911, 6861, 1598)), 200)) do
	  		if IsValid(ball) then
		 		if ball:GetClass() == "func_door" then ball:Fire("Open") end
	  		end
		end
		for k,v in pairs(ents.FindInSphere(Vector(2666, 6915, 1576), 400)) do
		evacuate(v,TEAM_CLASSD,1000,"l:cutscene_evac_by_ci")
		evacuate(v,TEAM_CHAOS,1000,"l:cutscene_evac_by_ci")
		end
	end)
	timer.Create( "2_phase", 145, 1, function()
		for k,ball in pairs(ents.FindInSphere((Vector(2911, 6861, 1598)), 200)) do
	  		if IsValid(ball) then
		 		if ball:GetClass() == "func_door" then ball:Fire("Close") end
	  		end
		end
		self:Remove()
	end)
	self:SetAutomaticFrameAdvance( true )
  	self:ResetSequence( 2 )
  	self:SetPlaybackRate( 1 )
  	self:SetCycle( 1 )
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