--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/entities/dz_commander_portal.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.Model       = Model( "models/player/Group01/male_01.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar( "Vector", 0, "TeleportPos" )

  self:SetTeleportPos( vector_origin )

end

local Table_Teleport_Positions = {
  Vector(-3654.365967, 3134.879883, 0),
  Vector(-1487.955322, 1583.706421, 0),
  Vector(-2091.016846, 1601.917725, 0),
  Vector(-70.880516, 2290.548828, 0),
  Vector(2128.645020, 4053.326172, 0),
  Vector(3817.575928, 4792.387695, 0),
  Vector(3704.447754, 5920.334961, 0),
  Vector(5853.832031, 3567.092529, 0),
  Vector(6738.983887, 2222.299072, 0),
  Vector(5354.400879, 1650.796997, 0),
  Vector(5223.846680, 506.682281, 0),
  Vector(5435.876465, -597.374390, 0),
  Vector(6410.299316, -1906.259644, 0),
  Vector(7807.858398, -1678.972168, 0),
  Vector(9219.670898, -1843.295044, 0),
  Vector(9831.014648, -2433.529053, 0),
  Vector(10373.200195, -1365.314087, 0),
  Vector(6233.232422, -3668.630371, 0)
}

function ENT:Initialize()

  if ( SERVER ) then

    self:SetModel( self.Model )
    self:PhysicsInit( SOLID_NONE )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_NONE )

    self.NextTeleport = 0

    math.randomseed( os.time() )

    self:SetAngles( angle_zero )

    self:SetTeleportPos( table.Random( Table_Teleport_Positions ) )

    self.DeathTime = CurTime() + 30

  end

end

local vec_up = Vector( 0, 0, 36 )

function ENT:Think()

  self:NextThink( CurTime() + .25 )

  if ( CLIENT ) then

    if ( !self.StartPatricle ) then

      self.StartPatricle = true
      ParticleEffect( "portal4_green", self:GetPos() + vec_up, angle_zero, self )

    end

  end

  if ( SERVER ) then

    if ( ( self.DeathTime || 0 ) - CurTime() < 0 ) then

      self:Remove()

    end

    local nearby_entities = ents.FindInSphere( self:GetPos(), 90 )

    for i = 1, #nearby_entities do

      local v = nearby_entities[ i ]

      if ( v:IsPlayer() && v:GTeam() != TEAM_SPEC && self.NextTeleport < CurTime() ) then

        self.NextTeleport = CurTime() + 2

        self:EmitSound( "ambient/machines/teleport3.wav", 75, math.random( 80, 100 ), 1, CHAN_STATIC )

        v:ScreenFade( SCREENFADE.OUT, color_white, .1, 1 )

        v:SetPos( self:GetTeleportPos() )

        local unique_id = "CheckTeleportPos" .. v:SteamID64()

        timer.Create( unique_id, 0, 0, function()

          if ( v:GetPos():DistToSqr( self:GetTeleportPos() ) > 20000 ) then

            v:SetPos( self:GetTeleportPos() )

          else

            timer.Remove( unique_id )

            print( "Position is fine, removing debug timer..." )

          end

        end )

        net.Start( "ForcePlaySound" )

          net.WriteString( "ambient/machines/teleport3.wav" )

        net.Send( v )

        local unique_id2 = "StuckCheck" .. v:SteamID64()
        local player_data = {}

        timer.Create( unique_id2, 1, 15, function()

          if ( !( v && v:IsValid() ) || v:Team() == TEAM_SPEC || v:Health() <= 0 ) then

            timer.Remove( unique_id2 )

            return
          end

          local current_pos = v:GetPos()
          local current_vel = v:GetVelocity():Length()

          if ( player_data.Pos && player_data.Vel && player_data.Pos == current_pos && ( current_vel > 0 && player_data.Vel == current_vel ) ) then

            timer.Remove( unique_id2 )
            v:Kill()

          end

          player_data.Pos = current_pos
          player_data.Vel = current_vel

        end )

      end

    end

  end

end

function ENT:OnRemove()

	if ( CLIENT ) then

		self:StopAndDestroyParticles()

	end

end

function ENT:Draw() end
