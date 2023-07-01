--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/whitebackground.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.SZClipZone			= true

local cyb_mat = Material( "lights/white001" )

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate4x24.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	self:SetRenderMode( 1 )

	self:SetColor( ColorAlpha( color_white, 1 ) )

end

function ENT:GetRotatedVec(vec)

	local v = self:WorldToLocal(vec)
	v:Rotate(self:GetAngles())

	return self:LocalToWorld( v )
end

function ENT:Draw()

	self:DestroyShadow()

	local pl = LocalPlayer()

	local pos = self:GetRotatedVec(self.Entity:GetPos() + self.Entity:GetUp() * 54 + self.Entity:GetRight() * -32)
	local dir = self.Entity:GetForward()

	local mins, maxs = self:GetCollisionBounds()

	local w = math.floor(math.max(maxs.x, maxs.y) / 32)

	for i = 1, w, 1 do

		if ( w == 1 ) then

			i = 1.15

		end

		local pos = self.Entity:GetPos() + self.Entity:GetUp() * 2
		render.SetMaterial(cyb_mat)
		render.DrawQuadEasy(
			pos,
			self.Entity:GetUp(),
			125, 125,
			color_white,
			180
		)

		render.SetMaterial(cyb_mat)
		render.DrawQuadEasy(
			pos,
			self.Entity:GetUp()*-1,
			125, 125,
			color_white,
			180
		)
	end
end
