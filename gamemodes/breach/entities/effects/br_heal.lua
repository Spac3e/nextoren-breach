--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   gamemodes/breach/entities/effects/br_heal.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

EFFECT.material = Material( "particles/white.png" )

function EFFECT:Init( fx )
	local pos = fx:GetOrigin()

	local emitter = ParticleEmitter( pos, false )
		for i=0, 25 do

			local ang = math.random( 0, 360 )
			local length = math.random( 10, 150 )

			local posx, posy = math.sin( ang ) * length, math.cos( ang ) * length

			local particle = emitter:Add( self.material, pos + Vector( posx, posy, 0 ) )
			if particle then

				local vel = Vector( 0, 0, math.random( 10, 30 ) )
				local dt = math.random( 20, 50 ) / 10
				local ssize = math.random( 15, 30 ) / 10
				local esize = math.random( 5, 10 ) / 10
				local color = math.random( 100, 230 )

				particle:SetVelocity( vel )
				particle:SetColor( 0, color, 0 )

				particle:SetLifeTime( 0 )
				particle:SetDieTime( dt )

				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( ssize )
				particle:SetEndSize( esize )

			end
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end