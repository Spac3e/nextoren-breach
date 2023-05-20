AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetPos(Vector(416, 4913, 3321))
	self:SetAngles(Angle(0,90,-27))

	local start_pos = Vector(-316, -1451, -30)
	local end_pos = Vector(-1190, 126, 1339)

	self:SetModel( "models/scp_helicopter/resque_helicopter.mdl" )
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
	self:EmitSound( "nextoren/others/helicopter/helicopter_propeller.wav", 75, 100, 1, CHAN_AUTO ) -- Same as below
	--delay1 = CurTime() + 6
	--end
	--end)
	heli_copt_id_pos = 0

  	self:SetAutomaticFrameAdvance( true )
  	self:ResetSequence( 6 )
  	self:SetPlaybackRate( 200 )
  	self:SetCycle( 0 )

	prizem_na_vp = 0

	timer.Simple(22, function()
		self:EmitSound( "nextoren/vo/chopper/chopper_thirty_left.wav") 
	end)

	timer.Simple(42, function()
		self:EmitSound( "nextoren/vo/chopper/chopper_ten_left.wav") 
	end)

	timer.Simple(52, function()
		self:EmitSound( "nextoren/vo/chopper/chopper_evacuate_end.wav") 
		heli_copt_id_pos = 2
		for k,v in pairs(ents.FindInSphere(Vector(-3518, 4802, 2567), 50)) do
		if v:IsPlayer() == true then
			if v:Alive() == false then return end
			if v.isescaping == true then return end
			if v:GTeam() == TEAM_CLASSD or v:GTeam() == TEAM_SCI or v:GTeam() == TEAM_SCP then
				if v:GTeam() == TEAM_SCI then
					roundstats.rescaped = roundstats.rescaped + 1
					local rtime = timer.TimeLeft("RoundTime")
					local exptoget = 1000
					if rtime != nil then
						exptoget = GetConVar("br_time_round"):GetInt() - (CurTime() - rtime)
						exptoget = exptoget * 1.8
						exptoget = math.Round(math.Clamp(exptoget, 1000, 10000))
					end
					net.Start("OnEscaped")
						net.WriteInt(1,4)
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
					//v:PrintMessage(HUD_PRINTTALK, "You escaped! Try to get escorted by MTF next time to get bonus points.")
				end
			end
		end
	end
		
	end)
	--16

	-- -3456.639648 4999.459961 2507
	-- -3593.712646 4454.875488 2574

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
 
function ENT:Think()

	local heli_pos_pizda = LerpVector(5 * FrameTime(), self:GetPos(), (self:GetPos() + Vector(0,0,-900)))

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
					if heli_copt_id_pos == 0 and prizem_na_vp != 1 then
						timer.Simple(0.3, function()
						self:Explode()
							heli_copt_id_pos = 5
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

					if heli_copt_id_pos == 1 and prizem_na_vp != 1 then
						timer.Simple(0.3, function()
						self:Explode()
							heli_copt_id_pos = 5
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

	local delay = 0

	local heli_pos_1 = LerpVector(5 * FrameTime(), self:GetPos(), Vector(-2778, 4777, 2976))
	local heli_pos_2 = LerpVector(5 * FrameTime(), self:GetPos(), Vector(-3518, 4762, 2496))
	local heli_pos_3 = LerpVector(5 * FrameTime(), self:GetPos(), Vector(-3516, 5301, 2892))
	local heli_pos_4 = LerpVector(5 * FrameTime(), self:GetPos(), Vector(-3512, 9450, 3110))
	local heli_ang_1 = LerpAngle(5 * FrameTime(), self:GetAngles(), Angle(0, 360, 0))
	local heli_ang_2 = LerpAngle(5 * FrameTime(), self:GetAngles(), Angle(20, 360, 0))
	--print(heli_hui)
	if heli_copt_id_pos == 0 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(heli_pos_1))
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere((Vector(-2475, 4786, 3085)), 50)) do
          if IsValid(ball) then
			  if ball:GetModel() == "models/scp_helicopter/resque_helicopter.mdl" then heli_copt_id_pos = 1 end
          end
    end

	if heli_copt_id_pos == 1 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(heli_pos_2))
	self:SetAngles(heli_ang_1)
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
	if prizem_na_vp != 1 then
	for k,ball in pairs(ents.FindInSphere((Vector(-3518, 4762, 2296)), 0.0001)) do
          if IsValid(ball) then
              if ball:GetModel() == "models/scp_helicopter/resque_helicopter.mdl" then 
			  	self:SetPos(Vector(-3515, 4760, 2505))
				self:SetAngles(Angle(0, 360, 0))
				self:EmitSound( "nextoren/vo/chopper/chopper_evacuate_start_7.wav") 
				prizem_na_vp = 1
			  end
          end
    end
	end

	if heli_copt_id_pos == 2 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(heli_pos_3))
	delay = CurTime() + 0.00001
	end

	for k,ball in pairs(ents.FindInSphere(Vector(-3516, 5301, 2892), 5)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_helicopter/resque_helicopter.mdl" then heli_copt_id_pos = 3 end
        end
    end

	if heli_copt_id_pos == 3 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(heli_pos_4))
	self:SetAngles(heli_ang_2)
	delay = CurTime() + 0.00001
	end

	if heli_copt_id_pos == 5 then
	if CurTime() < delay then return end	
	self:SetPos(Vector(heli_pos_pizda))
	delay = CurTime() + 0.00001
	end


	for k,ball in pairs(ents.FindInSphere(Vector(-3474, 9391, 3189), 5)) do
        if IsValid(ball) then
            if ball:GetModel() == "models/scp_helicopter/resque_helicopter.mdl" then self:Remove() end
        end
    end

end