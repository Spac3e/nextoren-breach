--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/scp_tree.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

ENT.PrintName		= "Tree"
ENT.Author		    = ""
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Owner = nil
ENT.IsAttacking = false
ENT.CurrentTargets = {}
ENT.Attacks = 0
ENT.SnapSound = Sound( "snap.wav" )

function ENT:Initialize()
	self.Entity:SetModel( "models/trees/new_elm.mdl" )
	self.Entity:SetMoveType(MOVETYPE_NOCLIP )
	self:SetCollisionGroup( COLLISION_GROUP_NONE    )
	self.Entity:SetPos(Vector(9085.486328, -1932.134644, 5.520229))
	
    self.Entity:SetModelScale( 0.23, 1 )
	 
	 
end


function ENT:Think()
    if SERVER then
        for k,v in pairs(ents.FindInSphere(self.Entity:GetPos(), 150)) do

	        if !IsValid(v:GetOwner()) then
                if v:IsPlayer() then return false end
                if v:IsWeapon() then
                    if v == self.Copied then return end
                    if v == self.CopiedOut then return end
			        if v:GetClass() == "item_scp_005" then continue end
			        if v:GetClass() == "weapon_special_gaus" then continue end
                    local Copy = ents.Create( v:GetClass() )
                    Copy:Spawn()
                    Copy:SetPos( Vector(9085.438477, -1904.265137, 81.331055) )
			
                    
                    self.Copied = v

                    
                    self.CopiedOut = Copy
                end
            

            end
	    end
    end

    self:NextThink( CurTime() + 1 )
    return true 
end
