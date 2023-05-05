--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/ent_goc_teleporter.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "GOC Teleporter"
ENT.Model = "models/shaky/goc_teleporter.mdl"

function ENT:Initialize()

  self:SetModel( self.Model )

  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_VPHYSICS )

  self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

  if ( CLIENT ) then
    return
  end

  self:EmitSound( "goc_specialist/goc_teleporter_deploy.wav" )

  --sound.Play( "goc_specialist/goc_teleporter_deploy.wav", self:GetPos() )

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end

if ( SERVER ) then

  function ENT:OnTakeDamage()

    --if ( self:GetTriggered() ) then return end

    --self:SetTriggered( true )

    --self:Explode( self:GetPos() )

    if IsValid(self:GetOwner()) then
      if self:GetOwner():GTeam() != TEAM_SPEC then
        self:GetOwner():RXSENDNotify("Ваш телепорт был уничтожен!")
      end
    end

    self:Remove()

  end

  function ENT:Use( activator )

    if ( activator != self:GetOwner() ) then return end

    activator.TempValues.UsedTeleporter = false

    self:Remove()

  end

end
