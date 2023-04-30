--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/obr_call.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Name = "OBR Spawner"
ENT.Uses = 0
ENT.ObrIcon = Material( "nextoren/obr_call/obr_idle" )
ENT.Model = Model( "models/hunter/plates/plate4x24.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar("Bool", 0, "Activate")
  self:NetworkVar("Bool", 1, "Called")
  self:NetworkVar("Int", 1, "CD")

end

local vec_spawn = Vector( -2762.389404, 2268.9, 310.649048 )
local angle_spawn = Angle( 90, -90, 0 )

function ENT:Initialize()

  self:SetModel( self.Model )

  self:PhysicsInit( SOLID_NONE )
  self:SetMoveType(MOVETYPE_NONE)
  self:SetSolid( SOLID_NONE )
  self:SetActivate( true )
  self:SetCalled( false )
  self:SetCD( CurTime() + 350 )
  self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetRenderMode( 1 )

  self.Calling = false

  self:SetPos( vec_spawn )
  self:SetAngles( angle_spawn )

  if ( SERVER ) then

    self:SetUseType( SIMPLE_USE )

  end
  self:SetColor( ColorAlpha( color_white, 1 ) )


end

function ENT:Use( activator, caller )

  if ( caller:IsPlayer() && caller:GetNClass() != role.MTF_HOF && caller:GetNClass() != role.Dispatcher ) then return end

  if ( self:GetCD() > CurTime() ) then return end

  self:SetCD( CurTime() + 525 )

  if ( caller:IsPlayer() && !self:GetActivate() ) then

    caller:Tip( 3, "Подождите, следующий отряд ещё не готов к вызову.", Color( 255, 0, 0 ) )

  end

  local count = 5

  if caller:GetNClass() == role.Dispatcher then count = math.random(8,10) end

  if ( caller && caller:IsValid() && caller:IsPlayer() && self:GetActivate() && !GetGlobalBool( "NukeTime", false ) ) then

    self.Uses = self.Uses + 1
    self:SetCalled( true )

    caller:CompleteAchievement("protocol")

    if ( self.Uses >= 3 ) then

      self:SetActivate( false )

    end

    timer.Simple( 10, function()

      if ( self && self:IsValid() ) then

        self:SetCalled( false )

        if ( SERVER ) then

          OBRSpawn(count)

          BroadcastLua( 'surface.PlaySound( "nextoren/round_sounds/intercom/obr_enter.wav" )' )

        end

      end

    end )

  end

end

function ENT:GetRotatedVec(vec)

	local v = self:WorldToLocal(vec)
	v:Rotate( self:GetAngles() )
	return self:LocalToWorld( v )

end

local clr_green = Color( 0, 200, 0 )
local clr_red = Color( 200, 0, 0 )

function ENT:Draw()

  local oang = self:GetAngles()
	local opos = self:GetPos()

  local ang = self:GetAngles()
  local pos = self:GetPos()

  ang:RotateAroundAxis( oang:Up(), 90 )
  ang:RotateAroundAxis( oang:Right(), 0 )
  ang:RotateAroundAxis( oang:Up(), 0 )
  self:DestroyShadow()

  if ( self:GetCalled() ) then

    self.ObrIcon = Material( "nextoren/obr_call/obr_window" )

  else

    self.ObrIcon = Material( "nextoren/obr_call/obr_idle" )

  end

  ------------------------------------------


  local up = self.Entity:GetUp()

  local position = self:GetRotatedVec(self.Entity:GetPos() + up * 2 + self.Entity:GetRight() * 4 )

  local _, maxs = self:GetCollisionBounds()

  local w = math.floor( math.max( maxs.x, maxs.y ) / 32 )
  local pos = self.Entity:GetPos() + up * 1

  render.SetMaterial( self.ObrIcon )
  render.DrawQuadEasy(
  	position,
  	up,
  	18, 14,
  	color_white,
  	180
  )

  render.SetMaterial( self.ObrIcon )
  render.DrawQuadEasy(
  	position,
  	up*-1,
  	18, 14,
  	color_white,
  	180
  )

  ------------------------------------------
  if ( !self:GetCalled() ) then

    cam.Start3D2D( pos + oang:Forward() * -3 + oang:Up() * 0.4 + oang:Right() * 2, ang, 0.1 )

    if ( self:GetCD() > CurTime() ) then

      draw.SimpleText( math.Round( self:GetCD() - CurTime() ), "LZTextVerySmall", 0, 0, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    else

      draw.SimpleText( "SQR ready!", "LZTextVerySmall", 0, 0, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

    cam.End3D2D()

  end

end
