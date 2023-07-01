--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/npc_scp_303/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

if ( SERVER ) then

  AddCSLuaFile( "shared.lua" )

end

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Base = "base_gmodentity" 
ENT.Type = "anim"
ENT.PrintName = "SCP-303"
ENT.Author = "Shaky"
ENT.Spawnable = true
ENT.Category = "Breach"

ENT.Model = Model( "models/cultist/npc_scp/303.mdl" )

ENT.collisionheight = 85
ENT.collisionside = 13

function ENT:Initialize()

  self:SetModel( self.Model )

  if ( SERVER ) then

    self:SetHealth( 100000000000 )

    --self:CollisionSetup( self.collisionside, self.collisionheight, COLLISION_GROUP_PLAYER )

    self:PhysicsInitShadow( true, true )

    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInit(SOLID_BBOX)
    self:SetSolid(SOLID_BBOX)

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    --[[
    self:PhysicsInitConvex( {

      Vector( min.x, min.y, min.z ),
        Vector( min.x, min.y, max.z ),
        Vector( min.x, max.y, min.z ),
        Vector( min.x, max.y, max.z ),
        Vector( max.x, min.y, min.z ),
        Vector( max.x, min.y, max.z ),
        Vector( max.x, max.y, min.z ),
        Vector( max.x, max.y, max.z )

    } )]]

    local tab = self:picktable()

    if !tab then
    	self:Remove()
    	print("SCP-303 no tables found!")
    else
    	print("SCP-303 Table found")
    	self:SetNoDraw(true)
    	self:SetPos(tab.pos)
    	self:SetAngles(tab.ang)
    	for _, door in ipairs(ents.FindInSphere(tab.pos, 75)) do
    		if IsValid(door) and door:GetClass() == "func_door" then
                door:Fire("Lock")
    			door:Fire("Close")
                timer.Simple(1.25, function() door:Fire("UnLock") end)
    		end
    	end
    	timer.Simple(1.25, function()
    		if IsValid(self) then
                self:SetNoDraw(false)
                self:ResetSequence(self:LookupSequence("idle"))
            end
    	end)
    end

    timer.Simple(30, function()
    	if IsValid(self) then self:Remove() end
    end)

  end

end