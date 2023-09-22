AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("AlphaWarheadTimer_CLIENTSIDE")
util.AddNetworkString("NukeStart")
util.AddNetworkString("NukeReturn")
util.AddNetworkString("NukeReturn2")
util.AddNetworkString("NukeReturn3")
util.AddNetworkString("NukeReturn4")

function ENT:Initialize()

    self:SetModel( "models/hunter/plates/plate1x3.mdl" )

 self:PhysicsInit( SOLID_NONE )
 self:SetMoveType(MOVETYPE_NONE)
 self:SetSolid( SOLID_NONE )
 self:SetActivated( false )
 self:SetDeactivationTime( 120 )
 bg_self = self
 bg_sound_resume = false
 bg_deac_local_time = 120
 self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
 self:SetRenderMode( 1 )

 self.Calling = false

 self:SetPos( Vector(-723.134705, -6288.651367, -2343.054932) )

 if ( SERVER ) then

   self:SetUseType( SIMPLE_USE )

 end
 self:SetColor( ColorAlpha( color_white, 1 ) )

  BroadcastLua("bg_self_unit = "..self)

end

function ENT:Use( activator, caller )

 if activator:GTeam() == TEAM_GOC then
  if GetGlobalBool("Evacuation", false) then return end
  if self:GetActivated() == false then

    if self:GetDeactivationTime() == 120 then

      if bg_sound_resume == false then

        self:SetDeactivationTime( self:GetDeactivationTime() )
        timer.Pause("Evacuation")
        timer.Pause("EvacuationWarhead")
        timer.Pause("RoundTime")
        timer.Pause("EndRound_Timer")
        net.Start("NukeStart")
          net.WriteBool(true)
        net.Broadcast()

        PlayAnnouncer("no_music/nukes/goc_nuke.ogg")

        local button = ents.Create( "alphawarhead_monitor" )
        button:Spawn()
        self:SetActivated( true )
        PlayAnnouncer("nextoren/sl/warheadcrank.ogg")

        timer.Simple( 15, function()

        SetGlobalBool( "Evacuation_HUD", true )

        for k,v in pairs(player.GetAll()) do
          v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:goc_nuke_start", Color(255, 255, 255))
        end

        net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
          net.WriteString( self:GetDeactivationTime() )
            net.WriteBool( true )
          net.Broadcast()

        end )

        --self:SetDeactivationTime( 90 )

      end

    else

        self:SetDeactivationTime( self:GetDeactivationTime() )
        timer.Pause("Evacuation")
        timer.Pause("EvacuationWarhead")
        timer.Pause("RoundTime")
        timer.Pause("EndRound_Timer")
        net.Start("NukeStart")
          net.WriteBool(true)
        net.Broadcast()

        local button = ents.Create( "alphawarhead_monitor" )
        button:Spawn()
        self:SetActivated( true )
        PlayAnnouncer("nextoren/sl/warheadcrank.ogg")
        PlayAnnouncer("no_music/nukes/nuke_sequence_main_1.ogg")

      timer.Simple( 15, function()

        SetGlobalBool( "Evacuation_HUD", true )

        for k,v in pairs(player.GetAll()) do
          v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:goc_nuke_start", Color(255, 255, 255))
        end

        for k, v in ipairs(BREACH.TimeDecision) do

          if v.time == self:GetDeactivationTime() then
              
            PlayAnnouncer(v.sound)
            self:SetDeactivationTime( v.time )

          end

          net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
          net.WriteString( self:GetDeactivationTime() )
            net.WriteBool( true )
          net.Broadcast()

        end
      end)
    end

  end


  elseif activator:GTeam() != TEAM_GOC then

  if bg_deac_local_time > 10 and self:GetActivated() == true then

    SetGlobalBool( "Evacuation_HUD", false )

    local cl_time = ((timer.TimeLeft("RoundTime")) * -1)

    print(cl_time)

    timer.Simple( 0.5, function()
      PlayAnnouncer("nextoren/round_sounds/intercom/goc_nuke_cancel.mp3")
    end )


    for i, v in pairs(player.GetAll()) do
        v:ConCommand( "stopsound" )
    end

    for k, v in ipairs(ents.GetAll()) do
      if v:GetClass() == "alphawarhead_monitor" then
        v:Remove()
      end
    end

    self:SetActivated( false )


    net.Start("NukeStart")
      net.WriteBool(false)
    net.Broadcast()

    net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
      net.WriteString( self:GetDeactivationTime() )
      net.WriteBool( false )
    net.Broadcast()


    BroadcastLua("cltime = "..cl_time)

    timer.UnPause("Evacuation")
    timer.UnPause("EvacuationWarhead")
    timer.UnPause("RoundTime")
    timer.UnPause("EndRound_Timer")

  end

 end

end

net.Receive("NukeReturn", function()
  local hui = tonumber(net.ReadString())
  if math.Round(hui,-1) >= 90 then
  bg_self:SetDeactivationTime( 90 )
  else
  bg_self:SetDeactivationTime( math.Round(hui,-1) )
  end
end)

net.Receive("NukeReturn3", function()
  timer.Simple(2, function()
    I_Nuke_Boom()
    Goc_Evac()
  end)
  Goc_Evac_Ef()
  net.Start("New_SHAKYROUNDSTAT") 
		net.WriteString("l:roundend_alphawarhead")
		net.WriteFloat(27)
	net.Broadcast()
end)

net.Receive("NukeReturn2", function()
  local hui = tonumber(net.ReadString())
  bg_deac_local_time = hui
end)

function ENT:Think()
  if self:GetActivated() == false then
    SetGlobalBool( "NukeTime", false )
  end

  print(bg_deac_local_time)

end


function I_Nuke_Boom()
  AlphaWarheadBoomEffect()
	for k,v in pairs(player.GetAll()) do
    if v:GTeam() != TEAM_SPEC then
		v:KillSilent()
    v:SendLua("surface.PlaySound(\"nextoren/ending/nuke.mp3\")")
	  v:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 255 ), 0.6, 4 )
	  v:SendLua("util.ScreenShake( Vector( 0, 0, 0 ), 50, 10, 3, 5000 )")		
	end
	end
  timer.Simple(27, function()
		RoundRestart()
	end)

end

function Goc_Evac_Ef(b_origin , b_leave)

	for k,v in pairs(player.GetAll()) do

		if v:GTeam() == TEAM_GOC then

			BroadcastLua("ParticleEffectAttach(\"mr_portal_1a\", PATTACH_POINT_FOLLOW, Entity("..v:EntIndex().."), Entity("..v:EntIndex().."):LookupAttachment(\"waist\"))")

			net.Start("ThirdPersonCutscene", true)
			net.WriteUInt(2, 4)
			net.WriteBool(false)
			net.Send(v)
			v:SetMoveType(MOVETYPE_OBSERVER)

			v:EmitSound("nextoren/others/introfirstshockwave.wav", 115, 100, 1.4)

			timer.Create("timer_xuyak_ebaaa_teleport"..v:SteamID64(), 2, 1, function()
				v:StopParticles()
				v:SetMoveType(MOVETYPE_WALK)
			end)

			v:SetForcedAnimation(v:LookupSequence("MPF_Deploy"))


			timer.Simple(6, function()

			v:StopParticles()

			end)

		end

	end

end

local eblya = {
	{reason = "l:activated_warhead", value = 551}
}

function Goc_Evac()
	for k,v in pairs(player.GetAll()) do


				if v:Alive() == false then return end
				if v.isescaping == true then return end
					if v:GTeam() == TEAM_GOC then
            v:AddToStatistics("l:escaped", 600)
						--v:LevelBar()
            net.Start("LevelBar")
            net.WriteTable(eblya)
	          net.WriteUInt(66, 32)
	          net.Send(v)
						v:SetupNormal()
						v:SetSpectator()
						--roundstats.sescaped = roundstats.sescaped + 1
						--local rtime = timer.TimeLeft("RoundTime")
						--local exptoget = 1200
						--net.Start("OnEscaped")
							--net.WriteInt(4,4)
						--net.Send(v)
						--v:AddFrags(5)
						--v:AddExp(exptoget, true)
						--v:GodEnable()
						--v:Freeze(true)
						--v.canblink = false
						--v.isescaping = true
						--v:Freeze(false)
						--v:GodDisable()
						--v:SetSpectator()
						--WinCheck()
						--v.isescaping = false
					end
		end

end