--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/arbuz.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Initialize()

	self:SetModel( "models/props_junk/watermelon01.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end

end

function ArbuzFunc(index)
	if !IsValid(Entity(index)) then return end
	local emitter = ParticleEmitter( Entity(index):GetPos() )
	for i = 1, 12 do

    local particle = emitter:Add( "!sprite_bloodspray"..math.random( 8 ), Entity(index):GetPos() )
    particle:SetVelocity( Vector(0,1,0) * 32 + VectorRand() * 16 )
    particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
    particle:SetStartAlpha( 200 )
    particle:SetEndAlpha( 0 )
    particle:SetStartSize( math.Rand( 13, 14 ) )
    particle:SetEndSize( math.Rand( 10, 12 ) )
    particle:SetRoll( 180 )
    particle:SetDieTime( 3 )
    particle:SetColor( 255, 0, 0 )
    particle:SetLighting( true )

  end

  local particle = emitter:Add( "!sprite_bloodspray"..math.random( 8 ), Entity(index):GetPos() )
  particle:SetVelocity( Vector(0,1,0) * 32 )
  particle:SetDieTime( math.Rand( 2.25, 3 ) )
  particle:SetStartAlpha( 200 )
  particle:SetEndAlpha( 0 )
  particle:SetStartSize( math.Rand( 28, 32 ) )
  particle:SetEndSize( math.Rand( 14, 28 ) )
  particle:SetRoll( 180 )
  particle:SetColor( 255, 0, 0 )
  particle:SetLighting( true )
  emitter:Finish() emitter = nil collectgarbage( "step", 64 )
end

function ENT:OnTakeDamage(dmginfo)
	for k, v in ipairs(player.GetAll()) do
		v:SendLua("ArbuzFunc("..self:EntIndex()..")")
	end
end