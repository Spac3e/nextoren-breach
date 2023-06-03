AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel("models/noundation/electronics/keyboard.mdl")
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	I_Nuke_Ativi = 0
	I_Nuke_Time = 130

end

function ENT:Use( activator, caller )

	print("Хуй")

	if I_Nuke_Ativi == 0 and (activator:GTeam() == TEAM_GOC and activator:GetModel() == "models/cultist/humans/goc/goc.mdl") then

		print("Хуй")

		I_Nuke_explod_Start()
		I_Nuke_Annon()

	end

	if I_Nuke_Ativi == 1 and activator:GTeam() != TEAM_GOC then

		I_Nuke_Defuse()

	end

end

function I_Nuke_Annon()

	if I_Nuke_Time == 130 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('no_music/nukes/goc_nuke.ogg')")
		v:SendLua("surface.PlaySound('nextoren/sl/warheadcrank.ogg')")    
		timer.Simple(14, function()
			v:SendLua("surface.PlaySound('nextoren/round_sounds/main_decont/final_nuke.mp3')")    
			v:BrTip( 7, "[VAULT]", Color( 255, 0, 0), "Боегловка Альфа была активированна, всему персоналу - немедленно эвакуироваться", Color( 255,255,255) )
		end)
	end)
		end
	
	end

	if I_Nuke_Time == 90 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume90.ogg')")    
		end)
		end
	
	end

	if I_Nuke_Time == 80 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume80.ogg')")    
		end)
		end
	
	end

	if I_Nuke_Time == 70 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume70.ogg')")    
		end)
		end
	
	end

	if I_Nuke_Time == 60 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume60.ogg')")    
		end)
		end
	
	end

	if I_Nuke_Time == 50 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume50.ogg')")    
		end)
		end
	
	end

	if I_Nuke_Time == 40 then

		for k,v in pairs(player.GetAll()) do
		v:ConCommand("stopsound")
		timer.Simple(0.2, function()
		v:SendLua("surface.PlaySound('nextoren/sl/resume40.ogg')")    
		end)
		end
	
	end

end

function I_Nuke_explod_Start()

			I_Nuke_Ativi = 1

		if I_Nuke_Time == 130 then

				timer.Create( "90", 1, 1, function() 
				
					I_Nuke_Time = 90
				
				end )

				timer.Create( "80", 50, 1, function() 
				
					I_Nuke_Time = 80
				
				end )

				timer.Create( "70", 60, 1, function() 
				
					I_Nuke_Time = 70
				
				end )

				timer.Create( "60", 70, 1, function() 
				
					I_Nuke_Time = 60
				
				end )

				timer.Create( "50", 80, 1, function() 
				
					I_Nuke_Time = 50
				
				end )

				timer.Create( "40", 90, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 93, 1, function() 
					I_Nuke_Time = 30
					for k,v in pairs(player.GetAll()) do
					v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					end
				end)

				timer.Create( "goc_evac_ef", 123, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 129, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 130, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 90 then

				timer.Create( "80", 15, 1, function() 
				
					I_Nuke_Time = 80
				
				end )

				timer.Create( "70", 25, 1, function() 
				
					I_Nuke_Time = 70
				
				end )

				timer.Create( "60", 35, 1, function() 
				
					I_Nuke_Time = 60
				
				end )

				timer.Create( "50", 45, 1, function() 
				
					I_Nuke_Time = 50
				
				end )

				timer.Create( "40", 55, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 58, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 90, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 94, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 95, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 80 then

				timer.Create( "70", 15, 1, function() 
				
					I_Nuke_Time = 70
				
				end )

				timer.Create( "60", 25, 1, function() 
				
					I_Nuke_Time = 60
				
				end )

				timer.Create( "50", 35, 1, function() 
				
					I_Nuke_Time = 50
				
				end )

				timer.Create( "40", 45, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 48, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 80, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 84, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 85, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 70 then

				timer.Create( "60", 15, 1, function() 
				
					I_Nuke_Time = 60
				
				end )

				timer.Create( "50", 25, 1, function() 
				
					I_Nuke_Time = 50
				
				end )

				timer.Create( "40", 35, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 38, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 70, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 74, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 75, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 60 then

				timer.Create( "50", 15, 1, function() 
				
					I_Nuke_Time = 50
				
				end )

				timer.Create( "40", 25, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 28, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 60, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 64, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 65, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 50 then

				timer.Create( "40", 15, 1, function() 
				
					I_Nuke_Time = 40
				
				end )

				timer.Create( "30", 18, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 50, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 54, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 55, 1, function() 
					
					I_Nuke_Boom()

				end)

		end

		if I_Nuke_Time == 40 then

				timer.Create( "30", 8, 1, function() 
					I_Nuke_Time = 30
					--for k,v in pairs(player.GetAll()) do
					--v:SendLua("surface.PlaySound('nextoren/round_sounds/lhz_decont/decont_countdown.ogg')")
					--end
				end)

				timer.Create( "goc_evac_ef", 40, 1, function() 
					
					Goc_Evac_Ef()

				end)

				timer.Create( "goc_evac", 44, 1, function() 
					
					Goc_Evac()

				end)

				timer.Create( "0", 45, 1, function() 
					
					I_Nuke_Boom()

				end)

		end


end

function I_Nuke_Boom()

	for k,v in pairs(player.GetAll()) do
    if v:GTeam() != TEAM_SPEC then
		v:KillSilent()
	end
	v:SendLua("surface.PlaySound(\"scp_alphawarheads/nukeexplode.wav\")")
	v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
	v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
	end

end

function Goc_Evac_Ef(b_origin , b_leave)

	for k,v in pairs(player.GetAll()) do

		v:SendLua("surface.PlaySound('nextoren/others/introfirstshockwave.wav')")

		if v:GTeam() == TEAM_GOC then

			net.Start( "ThirdPersonCutscene" )

			net.WriteUInt( 4, 4 )
			net.WriteBool( false )
	
		    net.Send( v )

			ParticleEffect( "mr_portal_1a_ff", v:GetPos(), angle_zero, v );
			v:Freeze(true)
			timer.Simple(2, function()
				ParticleEffect( "mr_portal_1a", v:GetPos(), angle_zero, v );
			end)

			timer.Simple(6, function()

			v:StopParticles()

			end)

		end

	end

end

function Goc_Evac()
	for k,v in pairs(player.GetAll()) do


				if v:Alive() == false then return end
				if v.isescaping == true then return end
					if v:GTeam() == TEAM_GOC then
						--roundstats.sescaped = roundstats.sescaped + 1
						--local rtime = timer.TimeLeft("RoundTime")
						local exptoget = 1200
						net.Start("OnEscaped")
							net.WriteInt(4,4)
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
						--WinCheck()
						v.isescaping = false
					end
		end

end

function I_Nuke_Defuse()

	if I_Nuke_Time != 30 then

		I_Nuke_Ativi = 0
		timer.Remove( "90" )
		timer.Remove( "80" )
		timer.Remove( "70" )
		timer.Remove( "60" )
		timer.Remove( "50" )
		timer.Remove( "40" )
		timer.Remove( "30" )
		timer.Remove( "0" )
		timer.Remove( "goc_evac" )
		timer.Remove( "goc_evac_ef" )

		for k,v in pairs(player.GetAll()) do
			v:ConCommand("stopsound")
			timer.Simple(0.3, function()
			v:SendLua("surface.PlaySound('nextoren/round_sounds/intercom/goc_nuke_cancel.mp3')")
			end)
		end

	end


end

function ENT:Think()

end

function ENT:OnRemove()

	timer.Remove( "90" )
	timer.Remove( "80" )
	timer.Remove( "70" )
	timer.Remove( "60" )
	timer.Remove( "50" )
	timer.Remove( "40" )
	timer.Remove( "30" )
	timer.Remove( "0" )
	timer.Remove( "goc_evac" )
	timer.Remove( "goc_evac_ef" )

end