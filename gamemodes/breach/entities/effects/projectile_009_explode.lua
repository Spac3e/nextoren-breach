--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   gamemodes/breach/entities/effects/projectile_009_explode.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local scale = data:GetScale()

	local emitter = ParticleEmitter(pos)

	for i=0,4 do
		local particle = emitter:Add("particle/smokesprites_000"..math.random(1,9), pos)
		particle:SetVelocity(Vector(math.Rand(-2,2), math.Rand(-2,2), math.Rand(20,75)))
		particle:SetDieTime(math.Rand(2,7))
		particle:SetStartAlpha(45)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3,4)*scale)
		particle:SetEndSize(math.Rand(5,15)*scale)
		particle:SetRoll(math.Rand(180,255))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,12,12)
		particle:SetAirResistance(150)
	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
