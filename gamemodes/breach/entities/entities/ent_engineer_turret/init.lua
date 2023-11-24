AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Status = 0
ENT.StatusTime = 0

ENT.NextAnim = 0
ENT.LastAnim = -1

ENT.Mins = Vector( -24.5, -41, -33 )
ENT.Maxs = Vector( 44, 41, 16.5 )

ENT.VerticalRange = 10
ENT.HorizontalRange = 30

function ENT:SetupDataTables()
    self:NetworkVar( "Float", 0, "DesiredAngleY" )
	self:NetworkVar( "Float", 0, "DesiredAngleP" )
	self:NetworkVar( "Float", 0, "AnimSpeed" )

	self:NetworkVar( "Entity", 0, "TurretOwner" )
	self:NetworkVar( "Int", 0, "OwnerSignature" )
end

function ENT:Initialize()
    self:SetModel( "models/codbo/other/autoturret.mdl" )

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )

    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:EnableMotion( false )
    end
    
    self:SetCollisionGroup( COLLISION_GROUP_NONE )
    self:CollisionRulesChanged()
    
    self:SetAutomaticFrameAdvance( true )
    
    if self:GetOwner() == NULL then self:SetOwner(self) end

    self.LastAngle = Angle( 0, 0, 0 )
    self.PredictedAngle = Angle( 0, 0, 0 )
end

function ENT:Use(caller)
    if (caller == self:GetOwner()) then
        caller:SetSpecialMax(caller:GetSpecialMax() + 1)
        caller:SetSpecialCD(CurTime() + 3)
        self:Remove()
    end
end