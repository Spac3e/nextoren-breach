--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/shared/rpgs.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


CustomizableWeaponry_KK.ins2.rpgs = CustomizableWeaponry_KK.ins2.rpgs or {}

function CustomizableWeaponry_KK.ins2.rpgs.fireShared(wep, IFTP, legit)
	if SERVER then
		local nade = ents.Create(wep.projectileClass)

		if IsValid(nade) then
			// get base pos,ang
			local pos = IsValid(wep.Owner) and wep.Owner:GetShootPos() or wep:GetPos()
			local ang = IsValid(wep.Owner) and wep.Owner:EyeAngles() or wep:GetAngles()

			// offset pos depending on aim
			local offset

			if wep:isAiming() then
				offset = wep.projectileOffsetPosAim
			else
				offset = wep.projectileOffsetPos
			end

			offset = ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z

			// tweak Angle used for velocity direction
			local offsetAng = wep.projectileOffsetAng

			ang:RotateAroundAxis(ang:Right(), offsetAng.p)
			ang:RotateAroundAxis(ang:Up(), offsetAng.y)
			ang:RotateAroundAxis(ang:Forward(), offsetAng.r)

			// store direction
			local dir = ang:Forward()

			// tweak ent spawn rotation
			local offsetAng = wep.projectileRotation

			ang:RotateAroundAxis(ang:Right(), offsetAng.p)
			ang:RotateAroundAxis(ang:Up(), offsetAng.y)
			ang:RotateAroundAxis(ang:Forward(), offsetAng.r)

			// set nade properties
			nade:SetPos(pos + offset)
			nade:SetAngles(ang)

			nade:Spawn()
			nade:Activate()

			// cw2 m203 rounds model tweak
			if wep.projectileClass == "cw_40mm_explosive" then
				nade:SetModel(wep.CW_KK_40MM_MDL)
				nade:PhysicsDestroy()
				nade:PhysicsInit(SOLID_VPHYSICS)
			end

			nade:SetOwner(wep.Owner)

			if not legit then
				nade.safetyBypass = true
			end

			local phys = nade:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(dir * wep.MuzzleVelocityConverted)
			end

			if wep.projectileFuse then
				nade:Fuse(wep.projectileFuse)
			end
		end
	end
end
