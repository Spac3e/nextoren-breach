--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/effects/cw_kk_ins2_explosion_m203.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

local td = {}
local down = Vector(0, 0, -50)
local ang0 = Angle(-90, 0, 0)

local ent, pos, ang, tr, tweakData

function EFFECT:Init(fx)
	ent = fx:GetEntity()

	pos = ent:GetPos()

	-- td.start = pos
	-- td.endpos = pos + down
	-- td.filter = ent

	-- tr = util.TraceLine(td)

	-- if tr.Hit then
		-- ang = tr.HitNormal:Angle()
	-- else
		ang = ang0
	-- end

	tweakData = ent:getTweakData()

	if ent:WaterLevel() == 0 then
		for _,p in pairs(tweakData.explosionParticles) do
			ParticleEffect(p, pos, ang, ent)
		end

		sound.Play(tweakData.explosionSound0, pos, 180)
	else
		for _,p in pairs(tweakData.explosionParticlesWater) do
			ParticleEffect(p, pos, ang, ent)
		end

		sound.Play(tweakData.explosionSoundW0, pos, 180)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
