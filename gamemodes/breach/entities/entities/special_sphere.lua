--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/special_sphere.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.Type = "anim"

ENT.Name = "Sphere"
ENT.Category = "[BREACH] Others"

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Model = Model( "models/hunter/misc/sphere375x375.mdl" )

if ( SERVER ) then

  function ENT:Initialize()

    self:SetModel( self.Model )

    self:SetSolid( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )

    self:PhysWake()

    local phys_object = self:GetPhysicsObject()

    if ( phys_object && phys_object:IsValid() ) then

      phys_object:EnableMotion( false )

    end

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    self:Activate()

    self:SetModelScale( 4, 0 )

    self.DeathTime = CurTime() + 15

  end

end

--if SERVER then
  function ENT:Think()
    if ( ( self.DeathTime || 0 ) - CurTime() < 0 ) and SERVER then

      self:Remove()

    end
    local owner = self:GetOwner()
    if !(IsValid(owner) and owner:HaveSpecialAb(ROLES.ROLE_SHIELD) and owner:Health() > 0 and owner:Alive()) and SERVER then
      self:Remove()
    end
    self:SetPos(owner:GetPos())
    self:NextThink(CurTime())
  end
--end

if ( CLIENT ) then

  local SHIELD_MATERIAL = Material( "effects/combineshield/comshieldwall3" )

  function ENT:Draw()

    local pos, ang = self:GetPos(), self:GetAngles()

    render.SetMaterial( SHIELD_MATERIAL )

    render.DrawSphere( pos, 120, 40, 40, color_white )
    render.DrawSphere( pos, -120, 40, 40, color_white )

  end

end
