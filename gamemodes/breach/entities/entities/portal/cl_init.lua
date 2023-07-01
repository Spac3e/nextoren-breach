--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   gamemodes/breach/entities/entities/portal/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include( "shared.lua" )

local vec_offset = Vector( 0, 0, 30 )

function ENT:Think()

  if ( !self.StartPatricle ) then

    self.StartPatricle = true
    ParticleEffect( "mr_portal_2a_fg", self:GetPos() + vec_offset, angle_zero, self )

  end

  local dlight = DynamicLight( self:EntIndex() )
  if ( dlight ) then
    dlight.pos = self:GetPos() + Vector(0,0,7)
    dlight.r = 0
    dlight.g = 15
    dlight.b = 0
    dlight.brightness = 0.5
    dlight.Decay = 400
    dlight.Size = 1251
    dlight.DieTime = CurTime() + 5
  end

end

function ENT:OnRemove()

  self:StopAndDestroyParticles()

end

function ENT:Draw()
end
