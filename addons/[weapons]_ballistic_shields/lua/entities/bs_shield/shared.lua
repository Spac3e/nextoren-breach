--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_ballistic_shields/lua/entities/bs_shield/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Deployed shield"
ENT.Category = "Ballistic shields"

ENT.Spawnable = false
ENT.DisableDuplicator = true

function ENT:Use( activator )
	if IsValid( activator ) && activator:IsPlayer() && self.Entity.Owner == activator then
		activator:Give( "deployable_shield" )
		activator:EmitSound( "npc/combine_soldier/gear2.wav" )
		table.RemoveByValue(activator.bs_shields, self.Entity)
		self.Entity:Remove()
	end
end