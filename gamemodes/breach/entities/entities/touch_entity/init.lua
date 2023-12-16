AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
    self:SetModel('models/hunter/blocks/cube025x025x025.mdl')

    self:DrawShadow(false)
    
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)

    self:SetNoDraw(false)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)

    self:SetTrigger(true)
    self:UseTriggerBounds(true)

    if self.Think then
        self:Think()
        self:NextThink(CurTime())
        return true
    end

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Touch(pEntity)
    if !pEntity:IsValid() or !pEntity:IsPlayer() then return end
    if self.triggered and !self.noremove then return end
    self.triggered = true
    self.TouchFunc(entity,pEntity)
    if !self.noremove then
        self:Remove()
    end
end