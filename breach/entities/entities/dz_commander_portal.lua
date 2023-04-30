--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
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
  Vector(-4746.1157226563, 4143.806640625, -1999.96875),
  Vector(-2620.0705566406, 1809.0070800781, 256.03125),
  Vector(-5493.8676757813, 1024.8741455078, 2452.5256347656),
  Vector(-3375.8940429688, 2355.3884277344, 128.03125),
  Vector(2499.513671875, 4467.4008789063, -98.96875),
  Vector(2155.0578613281, 4084.3933105469, 99.500061035156),
  Vector(2385.0075683594, 5921.865234375, 0.03125),
  Vector(1721.3276367188, 4318.0034179688, 0.03125),
  Vector(1804.2415771484, 3475.7448730469, 106.7883605957),
  Vector(3525.6442871094, 1448.0393066406, 0.03125),
  Vector(4231.658203125, -2319.8527832031, 68.281288146973),
  Vector(6145.6713867188, -2420.6875, 1.3310508728027),
  Vector(7712.58203125, -357.95980834961, 0.03125),
  Vector(5268.4462890625, 1370.9805908203, 0.03125),
  Vector(5268.4462890625, 1370.9805908203, 0.03125),
  Vector(6929.3818359375, 2249.4423828125, 0.031250059604645),
  Vector(6929.3818359375, 2249.4423828125, 0.031250059604645),
  Vector(9195.7998046875, -1922.6776123047, 1.4442405700684),
  Vector(9754.2470703125, -3262.2045898438, 1.3310508728027),
  Vector(10160.37890625, -4286.5078125, -126.66874694824),
  Vector(7584.6201171875, -5070.4208984375, -126.66874694824),
  Vector(6170.001953125, -5666.8715820313, 129.33126831055),
  Vector(8921.845703125, -5696.1254882813, 2.3312492370605),
  Vector(-644.49621582031, -5973.9873046875, -2400.96875),
  Vector(245.95852661133, -4034.5537109375, -1248.1639404297),
  Vector(8921.845703125, -5696.1254882813, 2.3312492370605),
  Vector(-644.49621582031, -5973.9873046875, -2400.96875),
  Vector(245.95852661133, -4034.5537109375, -1248.1639404297),
  Vector(160.75720214844, -4478.6196289063, -1248.96875),
  Vector(-513.01867675781, -5151.005859375, -1248.9779052734),
  Vector(-348.84936523438, -5688.2436523438, -1248.96875),
  Vector(-609.21179199219, -4614.2236328125, -1248.96875),
  Vector(1410.3459472656, -4468.34765625, -1248.96875),
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

        net.Start( "ForcePlaySound" )

          net.WriteString( "ambient/machines/teleport3.wav" )

        net.Send( v )

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
