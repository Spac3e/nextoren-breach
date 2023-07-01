--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_deathanimation.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Death Animation ( Fake Ragdoll )"

if ( CLIENT ) then

  ENT.Animations = {

    4813,
    4812,
    4811,
    5204,
    5188

  }

  function ENT:Initialize()

    self:SetMoveType( MOVETYPE_NONE )

    timer.Simple( .3, function()

      if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

      self:SetModel( self.Owner:GetModel() )
      self:SetSkin( self.Owner:GetSkin() )

      if ( #self.Bodygroups > 0 ) then

        for i = 1, #self.Bodygroups do

          local bodygroup = self.Bodygroups[ i ]

          self:SetBodygroup( bodygroup.id, bodygroup.value )

        end

      end

      self:SetAutomaticFrameAdvance( true )
      self:SetPlaybackRate( 1.0 )
      self:SetCycle( 0 )

      self.SetupComplete = true

    end )

  end

  function ENT:Think()

    self:NextThink( CurTime() )

    if ( self:GetSequence() == 0 ) then

      self:SetSequence( self.Animations[ math.random( 1, #self.Animations ) ] )

    elseif ( self:GetCycle() < 1 ) then

      self:SetCycle( math.Approach( self:GetCycle(), 1, RealFrameTime() * .35 ) )

    end

    if ( self.Owner:Health() > 0 ) then

      self:Remove()

    elseif ( self.Owner:GetNWEntity( "NTF1Entity" ) != self ) then

      self.Owner:SetNWEntity( "NTF1Entity", self )

    end

  end

  function ENT:Draw()

    if ( !self.SetupComplete ) then return end

    self:DrawModel()

  end

end
