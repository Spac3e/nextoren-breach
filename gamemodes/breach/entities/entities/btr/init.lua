AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetPos(Vector(-1298, 7599, 1662))
	self:SetAngles(Angle(0,-90,0))

	self:SetModel( "models/scp_chaos_jeep/chaos_jeep.mdl" )
	--self:PhysicsInit( SOLID_BBOX )
	--self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    //local phys = self:GetPhysicsObject()
	//if (phys:IsValid()) then
		//phys:Wake()
	//end

	--local delay1 = 0

	--hook.Add( "Think", "CurTimeDelay", function()
	--if heli_copt_id_pos == 1 then
	--if CurTime() < delay1 then return end	
	--self:EmitSound( "nextoren/others/helicopter/helicopter_propeller.wav", 75, 100, 1, CHAN_AUTO ) -- Same as below
	--delay1 = CurTime() + 6
	--end
	--end)
	b_copt_id_pos = 0

  	self:SetAutomaticFrameAdvance( true )
  	self:ResetSequence( 2 )
  	self:SetPlaybackRate( -10000 )
  	self:SetCycle( 1 )

	prizem_na_vpb = 0

--[[

	timer.Simple(22, function()
		self:EmitSound( "nextoren/vo/chopper/chopper_thirty_left.wav") 
	end)

	timer.Simple(42, function()
		self:EmitSound( "nextoren/vo/chopper/chopper_ten_left.wav") 
	end)
]]--

	timer.Simple(120, function()

		b_copt_id_pos = 6
		for k,v in pairs(ents.FindInSphere(Vector(2374, 6931, 1590), 50)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
				if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_CHAOS then
					roundstats.descaped = roundstats.descaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 1000
					net.Start("OnEscaped")
						net.WriteInt(2,4)
					net.Send(v)
					v:AddFrags(5)
					v:AddExp(exptoget, true)
					v:GodEnable()
					v:Freeze(true)
					v.canblink = false
					v.isescaping = true
					v:Freeze(false)
					v:GodDisable()
					v:SetSpectator()
					WinCheck()
					v.isescaping = false
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by Chaos Insurgency Soldiers next time to get bonus points.")
				end
		end
	end

	end)

	--16

--52



end

local function easedLerp(fraction, from, to)
	return LerpVector(math.ease.InSine(fraction), from, to)
end

function ENT:Use( activator, caller )
	--print(heli_hui)
	--timer.Create( "tolkatel_heli", 2, 0, function() self:SetPos(Vector(heli_hui)) end )
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
    --[[
	local curTime = CurTime()
    if (self.nextDamage or 0) > curTime then return end
    self.nextDamage = curTime + 5
	self:SetOnFire()
	]]--
	btr_hp = btr_hp - dmginfo:GetDamage()
	print(btr_hp)
end
 
function ENT:Think()

	if btr_hp < 0 then

		self:Explode()
		self:EmitSound( "nextoren/others/explosions/explosion_7.wav")
		timer.Simple(0.5, function()
			self:Remove()
		end)

	end

	local b_pos_pizdab = LerpVector(5 * FrameTime(), self:GetPos(), (self:GetPos() + Vector(0,0,-900)))
--[[
	for k,ball in pairs(ents.FindInSphere((self:GetPos()), 500)) do
          if IsValid(ball) then
              --print(ball:GetClass())
			  	if ball:GetModel() == "models/weapons/w_cw_kk_ins2_rpg7_projectile_pd2.mdl" then
					local button = ents.Create( "prop_physics" )
					button:SetModel( "models/hunter/blocks/cube4x6x4.mdl" )
					button:SetColor(Color(0,0,0,0))
					button:SetMaterial("Models/effects/comball_sphere")
					button:SetPos( self:GetPos() )
					button:Spawn()
					if btr_copt_id_pos == 0 and prizem_na_vpb != 1 then
						timer.Simple(0.3, function()
						self:Explode()
							btr_copt_id_pos = 5
						timer.Simple(1.3, function()
						self:Explode()
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), angle_zero );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						end)
						end)
						timer.Simple(1, function()
							button:Remove()
						end)
					end

					if btr_copt_id_pos == 1 and prizem_na_vpb != 1 then
						timer.Simple(0.3, function()
						self:Explode()
							btr_copt_id_pos = 5
						timer.Simple(0.2, function()
						self:Explode()
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), angle_zero );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						end)
						end)
						timer.Simple(1, function()
							button:Remove()
						end)
					end

					if heli_copt_id_pos == 1 and prizem_na_vp == 1 then
						timer.Simple(0.2, function()
						self:Explode()
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), angle_zero );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						end)
						timer.Simple(1, function()
							button:Remove()
						end)
					end

					if heli_copt_id_pos == 2 then
						timer.Simple(0.3, function()
						self:Explode()
							heli_copt_id_pos = 5
						timer.Simple(1.2, function()
						self:Explode()
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), angle_zero );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						end)
						end)
						timer.Simple(1, function()
							button:Remove()
						end)
					end

					if heli_copt_id_pos == 3 then
						timer.Simple(0.3, function()
						self:Explode()
							heli_copt_id_pos = 5
						timer.Simple(2, function()
						self:Explode()
						ParticleEffect( "gas_explosion_firesmoke", self:GetPos(), angle_zero );
						self:EmitSound( "nextoren/others/helicopter/helicopter_explosion.wav") 
						self:Remove()
						end)
						end)
						timer.Simple(1, function()
							button:Remove()
						end)
					end
				end
          end
    end
]]--
	local delay = 0

	local b_pos_1 = LerpVector(3 * FrameTime(), self:GetPos(), Vector(-1294, 6875, 1660))
	local b_pos_2 = LerpVector(2 * FrameTime(), self:GetPos(), Vector(-20, 6965, 1660))
	local b_pos_3 = LerpVector(3 * FrameTime(), self:GetPos(), Vector(577, 6964, 1500))
	local b_pos_4 = LerpVector(1 * FrameTime(), self:GetPos(), Vector(2483, 6933, 1505))
	local b_pos_5 = LerpVector(2 * FrameTime(), self:GetPos(), Vector(3400, 6933, 1505))
	local b_pos_6 = LerpVector(2 * FrameTime(), self:GetPos(), Vector(3561, 6857, 1505))
	local b_ang_1 = LerpAngle(7 * FrameTime(), self:GetAngles(), Angle(0, 0, 0))
	local b_ang_2 = LerpAngle(9 * FrameTime(), self:GetAngles(), Angle(15, 0, 0))
	local b_ang_3 = LerpAngle(30 * FrameTime(), self:GetAngles(), Angle(0, 0, 0))
	--print(heli_hui)
	if b_copt_id_pos == 0 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(b_pos_1))
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere((Vector(-1295, 6877, 1726)), 1)) do
          if IsValid(ball) then
			  if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then b_copt_id_pos = 1 end
          end
    end

	if b_copt_id_pos == 1 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(b_pos_2))
	self:SetAngles(b_ang_1)
	delay = CurTime() + 0.00001
	end
-- -319.137482 -1471.755615 -83
--[[
	if self:GetPos() == Vector(-459, -1389, 177) then
			if CurTime() < delay then return end	
			self:SetPos(Vector(heli_pos_2))
			delay = CurTime() + 0.001
	end
]]--

	if prizem_na_vpb != 1 then
	for k,ball in pairs(ents.FindInSphere((Vector(2374, 6931, 1590)), 1)) do
          if IsValid(ball) then
              if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then 
			  	self:SetPos(Vector(2483, 6933, 1512))
				self:SetAngles(Angle(0, 0, 0))
				self:SetAutomaticFrameAdvance( true )
				self:ResetSequence( 0 )
				self:SetPlaybackRate( 0 )
				self:SetCycle( 0 ) 
				--self:EmitSound( "nextoren/vo/chopper/chopper_evacuate_start_7.wav") 
				prizem_na_vpb = 1
				self:SetBodyGroups("1")
			  end
          end
    end
	end

	for k,ball in pairs(ents.FindInSphere(Vector(75, 6972, 1687), 1)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then b_copt_id_pos = 2 end
        end
    end

	if b_copt_id_pos == 2 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(b_pos_3))
	self:SetAngles(b_ang_2)
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere(Vector(632, 6963, 1576), 10)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then 
			b_copt_id_pos = 3   	
		end
        end
    end

	if b_copt_id_pos == 3 then
	if CurTime() < delay then return end
	self:SetAngles(b_ang_3)	
	self:SetPos(Vector(b_pos_4))
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere(Vector(632, 6963, 1576), 10)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then 
			b_copt_id_pos = 3   	
		end
        end
    end

	if b_copt_id_pos == 4 then
	if CurTime() < delay then return end
	self:SetAngles(b_ang_3)	
	self:SetPos(Vector(b_pos_5))
	delay = CurTime() + 0.00001
	end

	if b_copt_id_pos == 6 then
	if CurTime() < delay then return end
	--self:SetAngles(b_ang_3)	
	self:SetPos(b_pos_6)
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere(Vector(3561, 6857, 1576), 5)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_chaos_jeep/chaos_jeep.mdl" then self:Remove() end
        end
    end

end