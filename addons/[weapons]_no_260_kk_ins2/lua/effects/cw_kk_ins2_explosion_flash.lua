--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/effects/cw_kk_ins2_explosion_flash.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

local ang0 = Angle(-90, 0, 0)

local ent, pos, dl, tweakData

function EFFECT:Init(fx)
	ent = fx:GetEntity()

	dl = DynamicLight(ent:EntIndex())

	dl.r = 255
	dl.g = 255
	dl.b = 255
	dl.Brightness = 4
	dl.Pos = ent:GetPos()
	dl.Size = 256
	dl.Decay = 128
	dl.DieTime = CurTime() + 0.1

	pos = ent:GetPos()

	tweakData = ent:getTweakData()

	if ent:WaterLevel() == 0 then
		for _,p in pairs(tweakData.explosionParticles) do
			ParticleEffect(p, pos, ang0)
		end
		sound.Play(tweakData.explosionSound0, pos, 180)
	else
		sound.Play(tweakData.explosionSound2, pos, 180)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end