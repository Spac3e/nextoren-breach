AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("AlphaWarheadTimer_CLIENTSIDE")
util.AddNetworkString("NukeStart")

function ENT:Initialize()
  self:SetModel( "models/hunter/plates/plate1x3.mdl" )
  self:PhysicsInit( SOLID_NONE )
  self:SetMoveType(MOVETYPE_NONE)
  self:SetSolid( SOLID_NONE )
  self:SetActivated( false )
  self:SetDeactivationTime( 120 )
  self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetRenderMode( 1 )
  self.Calling = false
  self:SetPos( Vector(-723.134705, -6288.651367, -2343.054932) )
  self:SetUseType( SIMPLE_USE )
  self:SetColor( ColorAlpha( color_white, 1 ) )
end

function ENT:Use( activator )

  if activator:GTeam() == TEAM_GOC and activator:GetModel() == "models/cultist/humans/goc/goc.mdl" then
    if GetGlobalBool("Evacuation", false) then return end
    if self:GetActivated() == false then

      if self:GetDeactivationTime() == 120 then
          self:SetDeactivationTime( self:GetDeactivationTime() )
          timer.Pause("Evacuation")
          timer.Pause("EvacuationWarhead")
          timer.Pause("RoundTime")
          timer.Pause("EndRound_Timer")
          net.Start("NukeStart")
            net.WriteBool(true)
          net.Broadcast()
          PlayAnnouncer("no_music/nukes/goc_nuke.ogg")
          local moni = ents.Create( "alphawarhead_monitor" )
          moni:Spawn()
          self:SetActivated( true )
          PlayAnnouncer("nextoren/sl/warheadcrank.ogg")
          timer.Simple( 15, function()

            timer.Create("NukeTimer", self:GetDeactivationTime(), 1, function()

              timer.Simple(2, function()
                I_Nuke_Boom()
              end)
              timer.Simple(1, function()
                Goc_Evac()
              end)
              Goc_Evac()
              Goc_Evac_Ef()
              net.Start("New_SHAKYROUNDSTAT") 
                net.WriteString("l:roundend_alphawarhead")
                net.WriteFloat(27)
              net.Broadcast()

            end)
          SetGlobalBool( "NukeTime", true )
          SetGlobalBool( "Evacuation_HUD", true )
          for k,v in pairs(player.GetAll()) do
            v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:goc_nuke_start", Color(255, 255, 255))
          end
          net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
            net.WriteString( self:GetDeactivationTime() )
              net.WriteBool( true )
            net.Broadcast()
          end )
      else
          self:SetDeactivationTime( self:GetDeactivationTime() )
          timer.Pause("Evacuation")
          timer.Pause("EvacuationWarhead")
          timer.Pause("RoundTime")
          timer.Pause("EndRound_Timer")
          net.Start("NukeStart")
            net.WriteBool(true)
          net.Broadcast()

          local moni = ents.Create( "alphawarhead_monitor" )
          moni:Spawn()
          self:SetActivated( true )
          PlayAnnouncer("nextoren/sl/warheadcrank.ogg")
          PlayAnnouncer("no_music/nukes/nuke_sequence_main_1.ogg")
        timer.Simple( 15, function()
          SetGlobalBool( "NukeTime", true )
          SetGlobalBool( "Evacuation_HUD", true )
            timer.Create("NukeTimer", self:GetDeactivationTime(), 1, function()

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
          for k,v in pairs(player.GetAll()) do
            v:BrTip(0, "[VAULT Breach]", Color(255, 0, 0), "l:goc_nuke_start", Color(255, 255, 255))
          end
            net.Start( "AlphaWarheadTimer_CLIENTSIDE" )
            net.WriteString( self:GetDeactivationTime() )
              net.WriteBool( true )
            net.Broadcast()
          for k, v in ipairs(BREACH.TimeDecision) do
            if v.time == self:GetDeactivationTime() then
                PlayAnnouncer(v.sound)
                self:SetDeactivationTime( v.time )
            elseif self:GetDeactivationTime() <= 30 then
              PlayAnnouncer("nextoren/sl/Resume30.ogg")
              self:SetDeactivationTime( 30 )
            end
          end
        end)
      end

    end


  elseif activator:GTeam() != TEAM_GOC and timer.TimeLeft("NukeTimer") > 10 and self:GetActivated() == true and timer.Exists("NukeTimer") then
    SetGlobalBool( "Evacuation_HUD", false )
    if timer.TimeLeft("NukeTimer") >= 90 then
    self:SetDeactivationTime(90)
    else
    self:SetDeactivationTime(math.Round(timer.TimeLeft("NukeTimer"),-1))
    end
    timer.Destroy("NukeTimer")
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
    local cl_time = ((timer.TimeLeft("RoundTime")) * -1)
    BroadcastLua("cltime = "..cl_time)
    timer.UnPause("Evacuation")
    timer.UnPause("EvacuationWarhead")
    timer.UnPause("RoundTime")
    timer.UnPause("EndRound_Timer")

 end

end


function ENT:Think()
  if self:GetActivated() == false then
    SetGlobalBool( "NukeTime", false )
  end
end


function I_Nuke_Boom()
  AlphaWarheadBoomEffect()
	timer.Simple(5, function()
		for k,v in pairs(player.GetAll()) do
			if v:GTeam() != TEAM_SPEC then
				v:TakeDamage(99999,nil,nil)
			end
		end
	end)
						
	timer.Simple(27, function()
		RoundRestart()
	end)
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

function Goc_Evac()
	for k,v in pairs(player.GetAll()) do
    evacuate(v,TEAM_GOC,950,"l:activated_warhead")
	end
end